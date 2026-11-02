[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SkillRoot,

    [string[]]$ExpectedNames,
    [switch]$CheckPackageHashes
)

$ErrorActionPreference = "Stop"
$resolvedRoot = (Resolve-Path -LiteralPath $SkillRoot).Path

if (-not $ExpectedNames -or $ExpectedNames.Count -eq 0) {
    $manifestPath = Join-Path $PSScriptRoot "manifest.json"
    if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
        throw "manifest.json not found beside validator."
    }
    $manifest = Get-Content -LiteralPath $manifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
    $ExpectedNames = @($manifest.all_skill_ids)
}

$errors = New-Object System.Collections.Generic.List[string]
$passed = 0
$seen = @{}
$skillFiles = @(Get-ChildItem -LiteralPath $resolvedRoot -Filter "SKILL.md" -File -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch '[\\/]\.hub[\\/]' })

foreach ($name in $ExpectedNames) {
    if ($seen.ContainsKey($name)) {
        $errors.Add("Duplicate expected skill ID in manifest: $name")
        continue
    }
    $seen[$name] = $true

    if ($name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
        $errors.Add("Invalid skill ID format: $name")
        continue
    }

    $matchesForName = New-Object System.Collections.Generic.List[object]
    foreach ($file in $skillFiles) {
        $rawCandidate = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
        if ($rawCandidate -notmatch '(?s)\A---\s*\r?\n(.*?)\r?\n---\s*\r?\n') { continue }
        $candidateFrontmatter = $Matches[1]
        $candidateName = [regex]::Match($candidateFrontmatter, '(?m)^name:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        if ($candidateName.Success -and $candidateName.Groups[1].Value.Trim() -eq $name) {
            $matchesForName.Add([pscustomobject]@{ File = $file; Raw = $rawCandidate; Frontmatter = $candidateFrontmatter })
        }
    }

    if ($matchesForName.Count -eq 0) {
        $errors.Add("Missing skill with frontmatter name '$name' under $resolvedRoot")
        continue
    }
    if ($matchesForName.Count -gt 1) {
        $paths = ($matchesForName | ForEach-Object { $_.File.FullName }) -join "; "
        $errors.Add("Duplicate installed skill ID '$name': $paths")
        continue
    }

    $entry = $matchesForName[0]
    $skillFile = $entry.File.FullName
    $skillPath = Split-Path -Parent $skillFile
    $raw = $entry.Raw
    $frontmatter = $entry.Frontmatter

    if ($skillPath -ne $resolvedRoot -and (Split-Path -Leaf $skillPath) -ne $name) {
        $errors.Add("Skill folder name does not match skill ID '$name': $skillPath")
        continue
    }

    $descriptionMatch = [regex]::Match($frontmatter, '(?m)^description:\s*(\S.*)$')
    if (-not $descriptionMatch.Success) {
        $errors.Add("Frontmatter description missing: $skillFile")
        continue
    }

    $description = $descriptionMatch.Groups[1].Value.Trim().Trim('"').Trim("'")
    if ($description.Length -lt 1 -or $description.Length -gt 60) {
        $errors.Add("Description length is outside 1-60 characters (Hermes compact profile): $skillFile")
        continue
    }

    # Check explicit relative references written in inline code.
    $pathMatches = [regex]::Matches($raw, '`((?:references|templates|examples|scripts)/[^`]+)`')
    foreach ($match in $pathMatches) {
        $relative = $match.Groups[1].Value.Trim()
        if ($relative -match '[\*\s]' -or $relative -match '^[a-z]+://') { continue }
        $relative = $relative -replace '[:#].*$', ''
        $candidate = Join-Path $skillPath ($relative -replace '/', [IO.Path]::DirectorySeparatorChar)
        if (-not (Test-Path -LiteralPath $candidate)) {
            $errors.Add("Referenced local path missing in ${name}: $relative")
        }
    }

    $passed++
    Write-Host "PASS $name ($skillPath)" -ForegroundColor Green
}

if ($errors.Count -gt 0) {
    Write-Host ""
    foreach ($errorText in $errors) {
        Write-Host "FAIL $errorText" -ForegroundColor Red
    }
    throw "Validation failed: $($errors.Count) issue(s), $passed skill(s) passed."
}

if ($CheckPackageHashes) {
    $checksumFile = Join-Path $PSScriptRoot "SHA256SUMS.txt"
    if (-not (Test-Path -LiteralPath $checksumFile -PathType Leaf)) {
        throw "SHA256SUMS.txt missing beside validator."
    }
    $checksumLines = Get-Content -LiteralPath $checksumFile -Encoding UTF8
    foreach ($line in $checksumLines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -notmatch '^([a-fA-F0-9]{64})\s{2}(.+)$') {
            throw "Invalid SHA-256 manifest line: $line"
        }
        $expectedHash = $Matches[1].ToLowerInvariant()
        $relativePath = $Matches[2].Replace('/', [IO.Path]::DirectorySeparatorChar)
        $filePath = Join-Path $PSScriptRoot $relativePath
        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            throw "Checksum target missing: $relativePath"
        }
        $actualHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actualHash -ne $expectedHash) {
            throw "SHA-256 mismatch: $relativePath"
        }
    }
    Write-Host "SHA-256 package manifest: OK" -ForegroundColor Green
}

Write-Host ""
Write-Host "VALID: $passed skill(s) checked under $resolvedRoot" -ForegroundColor Green
