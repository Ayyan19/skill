[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SkillPath,
    [switch]$CheckHashes
)

$ErrorActionPreference = "Stop"
$resolvedSkillPath = (Resolve-Path -LiteralPath $SkillPath).Path
$skillFile = Join-Path $resolvedSkillPath "SKILL.md"

if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
    throw "SKILL.md not found: $skillFile"
}

$content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8
if ($content -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---\s*\r?\n') {
    throw "SKILL.md frontmatter block is missing or malformed."
}
$frontmatter = $Matches[1]

if ($frontmatter -notmatch '(?m)^name:\s*kicad-pcb-reviewer\s*$') {
    throw "Frontmatter name must be kicad-pcb-reviewer."
}
if ($frontmatter -notmatch '(?m)^description:\s*.+$') {
    throw "Frontmatter description is missing."
}

foreach ($folder in @("references", "templates", "examples", "scripts")) {
    $folderPath = Join-Path $resolvedSkillPath $folder
    if (-not (Test-Path -LiteralPath $folderPath -PathType Container)) {
        throw "Required folder missing: $folder"
    }
}

$referenceCount = (Get-ChildItem (Join-Path $resolvedSkillPath "references") -Filter "*.md" -File).Count
$templateCount = (Get-ChildItem (Join-Path $resolvedSkillPath "templates") -File).Count
$exampleCount = (Get-ChildItem (Join-Path $resolvedSkillPath "examples") -Filter "*.md" -File).Count

if ($referenceCount -lt 10) { throw "Expected at least 10 reference documents; found $referenceCount." }
if ($templateCount -lt 7) { throw "Expected at least 7 templates; found $templateCount." }
if ($exampleCount -lt 3) { throw "Expected at least 3 examples; found $exampleCount." }

if ($CheckHashes) {
    $checksumFile = Join-Path $resolvedSkillPath "SHA256SUMS.txt"
    if (-not (Test-Path -LiteralPath $checksumFile -PathType Leaf)) {
        throw "SHA256SUMS.txt not found."
    }

    $lines = Get-Content -LiteralPath $checksumFile -Encoding UTF8
    foreach ($line in $lines) {
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        if ($line -notmatch '^([a-fA-F0-9]{64})\s{2}(.+)$') {
            throw "Invalid checksum line: $line"
        }

        $expectedHash = $Matches[1].ToLowerInvariant()
        $relativePath = $Matches[2].Replace('/', [IO.Path]::DirectorySeparatorChar)
        $filePath = Join-Path $resolvedSkillPath $relativePath

        if (-not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
            throw "Checksum target missing: $relativePath"
        }

        $actualHash = (Get-FileHash -LiteralPath $filePath -Algorithm SHA256).Hash.ToLowerInvariant()
        if ($actualHash -ne $expectedHash) {
            throw "SHA-256 mismatch: $relativePath"
        }
    }
}

Write-Host "VALID: $resolvedSkillPath"
Write-Host "Frontmatter: OK"
Write-Host "References: $referenceCount | Templates: $templateCount | Examples: $exampleCount"
if ($CheckHashes) { Write-Host "SHA-256 manifest: OK" }
