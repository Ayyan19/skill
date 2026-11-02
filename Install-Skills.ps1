#Requires -Version 5.1
[CmdletBinding()]
param(
    [switch]$SkipHermes,
    [switch]$SkipOpenCode,
    [switch]$Force,
    [switch]$ValidateOnly,
    [switch]$ValidateInstalled
)

$ErrorActionPreference = "Stop"
$PackageRoot = $PSScriptRoot
$ManifestPath = Join-Path $PackageRoot "manifest.json"
$Validator = Join-Path $PackageRoot "Validate-Skills.ps1"
$LocalSkillRoot = Join-Path $PackageRoot "skills"

if (-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)) { throw "manifest.json missing." }
if (-not (Test-Path -LiteralPath $Validator -PathType Leaf)) { throw "Validate-Skills.ps1 missing." }

$Manifest = Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json
$AllNames = @($Manifest.all_skill_ids)
$LocalNames = @($Manifest.local_skill_ids)
$UpstreamNames = @($Manifest.upstream_sources | ForEach-Object { $_.skills } | ForEach-Object { $_ })

if ($AllNames.Count -ne 16) { throw "Manifest must declare exactly 16 skill IDs; found $($AllNames.Count)." }
if (@($AllNames | Select-Object -Unique).Count -ne $AllNames.Count) { throw "Manifest contains duplicate skill IDs." }

$Targets = @()
if (-not $SkipHermes) {
    $Targets += [pscustomobject]@{
        Name = "Hermes"
        Root = Join-Path $HOME ".hermes\skills"
    }
}
if (-not $SkipOpenCode) {
    $Targets += [pscustomobject]@{
        Name = "OpenCode"
        Root = Join-Path $HOME ".config\opencode\skills"
    }
}
if ($Targets.Count -eq 0 -and -not ($ValidateOnly -or $ValidateInstalled)) {
    throw "Both target platforms were skipped."
}
if ($ValidateInstalled -and $Targets.Count -eq 0) {
    throw "Select at least one platform when using -ValidateInstalled."
}

if ($ValidateOnly) {
    Write-Host "Validating the nine locally packaged skills. No network or installation changes."
    & $Validator -SkillRoot $LocalSkillRoot -ExpectedNames $LocalNames -CheckPackageHashes
    return
}

if ($ValidateInstalled) {
    foreach ($target in $Targets) {
        Write-Host "Validating installed skills for $($target.Name)..."
        & $Validator -SkillRoot $target.Root -ExpectedNames $AllNames
        if ($target.Name -eq "Hermes") {
            $hermesCommand = Get-Command hermes -ErrorAction SilentlyContinue
            if ($hermesCommand) {
                Write-Host "Hermes CLI inventory:"
                & $hermesCommand.Name skills list
            }
        }
    }
    return
}

$HermesCommand = $null
# Resolve the active Hermes data home. Native Windows defaults to %LOCALAPPDATA%\hermes;
# WSL/Linux defaults to ~/.hermes. HERMES_HOME overrides either default.
if (-not [string]::IsNullOrWhiteSpace($env:HERMES_HOME)) {
    $HermesHome = $env:HERMES_HOME
}
elseif ($env:OS -eq "Windows_NT" -and -not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    $HermesHome = Join-Path $env:LOCALAPPDATA "hermes"
}
else {
    $HermesHome = Join-Path $HOME ".hermes"
}
$HermesRoot = Join-Path $HermesHome "skills"
$OpenCodeRoot = Join-Path $HOME ".config\opencode\skills"

function Find-SkillFoldersByName([string]$Root, [string]$SkillName) {
    $found = New-Object System.Collections.Generic.List[string]
    if (-not (Test-Path -LiteralPath $Root -PathType Container)) { return @() }

    $files = Get-ChildItem -LiteralPath $Root -Filter "SKILL.md" -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch '[\\/]\.hub[\\/]' }

    foreach ($file in $files) {
        $raw = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
        if ($raw -notmatch '(?s)\A---\s*\r?\n(.*?)\r?\n---\s*\r?\n') { continue }
        $candidate = [regex]::Match($Matches[1], '(?m)^name:\s*["'']?([^"''\r\n]+)["'']?\s*$')
        if ($candidate.Success -and $candidate.Groups[1].Value.Trim() -eq $SkillName) {
            $found.Add((Split-Path -Parent $file.FullName))
        }
    }
    return @($found)
}


# Warn about older shared copies and possible legacy Anthropic document-skill folders.
$LegacySharedRoot = Join-Path $HOME ".agents\skills"
if (Test-Path -LiteralPath $LegacySharedRoot -PathType Container) {
    $legacyMatches = @()
    foreach ($skillName in $AllNames) {
        if ((Find-SkillFoldersByName -Root $LegacySharedRoot -SkillName $skillName).Count -gt 0) {
            $legacyMatches += $skillName
        }
    }
    if ($legacyMatches.Count -gt 0) {
        Write-Warning ("Legacy shared skill copies detected in ~/.agents/skills: " + ($legacyMatches -join ", ") + ". They are not modified; inspect docs/legacy-migration.md.")
    }
}

$restrictedDocIds = @("docx", "pdf", "xlsx", "pptx")
$legacySearchRoots = @($LegacySharedRoot, $HermesRoot, $OpenCodeRoot)
foreach ($legacyRoot in $legacySearchRoots) {
    foreach ($legacyName in $restrictedDocIds) {
        $legacyPaths = @(Find-SkillFoldersByName -Root $legacyRoot -SkillName $legacyName)
        if ($legacyPaths.Count -gt 0) {
            Write-Warning ("Possible legacy Anthropic document skill '$legacyName' found under $legacyRoot. This package does not install it; verify provenance and applicable license before retaining or using it.")
        }
    }
}

if (-not $SkipHermes) {
    $HermesCommand = Get-Command hermes -ErrorAction SilentlyContinue
    if (-not $HermesCommand) {
        throw "Hermes CLI was not found in this PowerShell environment. If Hermes runs in WSL, use the WSL instructions in README.md; otherwise add hermes to PATH or run with -SkipHermes."
    }
}

# Hermes upstream skills are installed via the official CLI so the Skills Hub
# security scanner, provenance log, and quarantine policy are applied.
# Do not overwrite an existing hub-managed skill from this script.
if (-not $SkipHermes) {
    $existingHermesUpstream = @()
    foreach ($skillName in $UpstreamNames) {
        if ((Find-SkillFoldersByName -Root $HermesRoot -SkillName $skillName).Count -gt 0) {
            $existingHermesUpstream += $skillName
        }
    }
    if ($existingHermesUpstream.Count -gt 0) {
        throw ("Existing Hermes upstream skill folders detected: " + ($existingHermesUpstream -join ", ") + ". This installer will not bypass Hermes' hub registry or scanner. Use 'hermes skills update' for hub-managed copies, or inspect and archive legacy manual copies before retrying. See docs/legacy-migration.md.")
    }
}

# Windows PowerShell 5.1 may otherwise default to older TLS versions.
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
} catch {
    Write-Warning "Could not explicitly set TLS 1.2; continuing with system defaults."
}

$TempRoot = Join-Path ([IO.Path]::GetTempPath()) ("master-skills-" + [guid]::NewGuid().ToString("N"))
$StageRoot = Join-Path $TempRoot "staged-skills"
New-Item -ItemType Directory -Path $TempRoot -Force | Out-Null
New-Item -ItemType Directory -Path $StageRoot -Force | Out-Null

$SourceLog = New-Object System.Collections.Generic.List[object]
$SourceBySkill = @{}
$BackupRoot = Join-Path $HOME (".skill-install-backups\master-skills-" + (Get-Date -Format "yyyyMMdd-HHmmss-fff"))
$Backups = New-Object System.Collections.Generic.List[object]
$InstalledCopies = New-Object System.Collections.Generic.List[string]
$HermesHubInstalled = New-Object System.Collections.Generic.List[string]

function Resolve-SourceCommit([string]$Repository, [string]$Ref) {
    $api = "https://api.github.com/repos/$Repository/commits/$Ref"
    try {
        $result = Invoke-RestMethod -Uri $api -Headers @{ "User-Agent" = "Hermes-OpenCode-MasterSkills-Installer" } -Method Get
        if ($result.sha) { return [string]$result.sha }
    } catch {
        Write-Warning "Could not resolve commit SHA for $Repository@$Ref via API; downloading the requested ref directly."
    }
    return $Ref
}

function Add-IntegrationCompatibility([string]$SkillName, [string]$SkillPath) {
    $skillFile = Join-Path $SkillPath "SKILL.md"
    $content = Get-Content -LiteralPath $skillFile -Raw -Encoding UTF8

    $descriptionProperty = $Manifest.compact_descriptions.PSObject.Properties[$SkillName]
    if ($descriptionProperty) {
        $shortDescription = [string]$descriptionProperty.Value
        $descriptionRegex = [regex]::new('(?m)^description:\s*.*$')
        $content = $descriptionRegex.Replace($content, "description: $shortDescription", 1)
    }

    switch ($SkillName) {
        "systematic-debugging" {
            $content = $content.Replace(
                'Use the `superpowers:test-driven-development` skill for writing proper failing tests',
                'Use an available host-native test workflow to create a minimal failing reproduction; if a separate TDD skill is installed, it may be used.'
            )
            $content = $content.Replace('superpowers:verification-before-completion', 'verification-before-completion')
        }
        "requesting-code-review" {
            $content = $content.Replace(
                'Dispatch a code reviewer subagent to catch issues before they cascade.',
                'When the host supports an independent subagent, dispatch a code reviewer to catch issues before they cascade. If not, perform a scoped in-session review using the bundled template and disclose that it was not independent.'
            )
            $content = $content.Replace(
                'Dispatch a `general-purpose` subagent, filling the template at `code-reviewer.md`',
                'If a suitable subagent is available, dispatch it using the template at `code-reviewer.md`. Otherwise use that template for a focused in-session review.'
            )
        }
        "writing-plans" {
            $content = $content.Replace('superpowers:using-git-worktrees', 'using-git-worktrees (if installed)')
            $content = $content.Replace(
                'REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.',
                'OPTIONAL EXECUTION INTEGRATION: Use subagent-driven-development or executing-plans if installed; otherwise follow the host native sequential workflow after the user approves the plan.'
            )
            $content = $content.Replace(
                'REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development',
                'OPTIONAL EXECUTION INTEGRATION: Use subagent-driven-development if installed; otherwise use the host native workflow after approval.'
            )
            $content = $content.Replace(
                'REQUIRED SUB-SKILL: Use superpowers:executing-plans',
                'OPTIONAL EXECUTION INTEGRATION: Use executing-plans if installed; otherwise use the host native sequential workflow after approval.'
            )
        }
        "context-optimization" {
            $content += @"

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills named in this upstream document are not installed here. If an adjacent sibling is unavailable, use host-native reasoning or state the limitation; do not invoke a skill that is not present.

Runtime caveat: do not invent context utilization, token counts, cache-hit rates, or quality measurements. Use compaction, masking, KV-cache, and partitioning only when the host actually exposes the capability. Treat numeric thresholds and performance targets in this document as heuristics or targets to evaluate, not guarantees. Never discard active errors, user constraints, exact values, or unresolved evidence merely to reduce context.
"@
        }
        "context-compression" {
            $content += @"

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills referenced by the upstream document are not installed here. If a referenced skill is unavailable, use the host-native workflow and disclose that no separate skill was loaded.

Preserve exact user constraints, decisions, filenames, paths, versions, measurements, error messages, verification evidence, unresolved risks, and next actions. Do not compress away active debugging evidence or replace unknown facts with assumptions.
"@
        }
        "filesystem-context" {
            $content += @"

## Selected-bundle compatibility note

This bundle includes only `context-optimization`, `context-compression`, and `filesystem-context` from the larger context-engineering collection. Other sibling skills referenced by the upstream document are not installed here. If a referenced skill is unavailable, use host-native file operations and disclose the limitation.

Use project-approved paths, preserve source artifacts, avoid storing credentials or sensitive data in scratch files, and retrieve only the relevant file ranges. File offloading is not permission to modify, delete, or publish project data.
"@
        }
    }

    $note = @"

## Master bundle portability and approval note

This is a selected standalone-skill installation, not the complete upstream plugin or skill collection. Check whether optional referenced skills and tools are actually available. If not, use a host-native fallback and disclose the limitation. Recommendations to edit, commit, publish, release manufacturing data, or perform physical actions do not grant permission; user approval and domain-specific safety boundaries take precedence.
"@
    if ($content -notmatch 'Master bundle portability and approval note') {
        $content += $note
    }

    [IO.File]::WriteAllText($skillFile, $content, [System.Text.UTF8Encoding]::new($false))
}

try {
    # Stage the nine local/original skills.
    foreach ($skillName in $LocalNames) {
        $sourcePath = Join-Path $LocalSkillRoot $skillName
        if (-not (Test-Path -LiteralPath (Join-Path $sourcePath "SKILL.md") -PathType Leaf)) {
            throw "Local skill source missing: $sourcePath"
        }
        Copy-Item -LiteralPath $sourcePath -Destination (Join-Path $StageRoot $skillName) -Recurse
    }

    # Download and stage the seven selected upstream skills at resolved commits.
    foreach ($source in $Manifest.upstream_sources) {
        $repo = [string]$source.repository
        $requestedRef = [string]$source.ref
        $resolvedRef = Resolve-SourceCommit -Repository $repo -Ref $requestedRef
        $repoName = ($repo -split "/")[-1]
        $archive = Join-Path $TempRoot ($repoName + ".zip")
        $extractRoot = Join-Path $TempRoot ($repoName + "-extract")
        New-Item -ItemType Directory -Path $extractRoot -Force | Out-Null

        $url = "https://codeload.github.com/$repo/zip/$resolvedRef"
        Write-Host "Downloading $repo@$resolvedRef..."
        Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing -Headers @{ "User-Agent" = "Hermes-OpenCode-MasterSkills-Installer" }

        $archiveHash = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
        Expand-Archive -LiteralPath $archive -DestinationPath $extractRoot -Force
        $repoRoot = Get-ChildItem -LiteralPath $extractRoot -Directory | Select-Object -First 1
        if (-not $repoRoot) { throw "Could not identify extracted repository root for $repo." }

        $licenseSource = Join-Path $repoRoot.FullName "LICENSE"
        if (-not (Test-Path -LiteralPath $licenseSource -PathType Leaf)) {
            $licenseSource = Join-Path $repoRoot.FullName "LICENSE.txt"
        }
        if (-not (Test-Path -LiteralPath $licenseSource -PathType Leaf)) {
            $licenseSource = Join-Path $repoRoot.FullName "LICENSE.md"
        }
        if (-not (Test-Path -LiteralPath $licenseSource -PathType Leaf)) {
            throw "Upstream license file missing for $repo; refusing to copy without license notice."
        }

        foreach ($skillName in $source.skills) {
            $from = Join-Path (Join-Path $repoRoot.FullName "skills") $skillName
            if (-not (Test-Path -LiteralPath (Join-Path $from "SKILL.md") -PathType Leaf)) {
                throw "Expected upstream skill not found: $repo/skills/$skillName"
            }

            $to = Join-Path $StageRoot $skillName
            Copy-Item -LiteralPath $from -Destination $to -Recurse
            Copy-Item -LiteralPath $licenseSource -Destination (Join-Path $to "UPSTREAM-LICENSE.txt") -Force

            $sourceInfo = @"
Repository: $repo
Requested ref: $requestedRef
Resolved ref: $resolvedRef
Archive SHA-256: $archiveHash
Retrieved UTC: $([DateTime]::UtcNow.ToString("o"))
"@
            Set-Content -LiteralPath (Join-Path $to "UPSTREAM-SOURCE.txt") -Value $sourceInfo -Encoding UTF8

            Add-IntegrationCompatibility -SkillName $skillName -SkillPath $to

            $record = [pscustomobject]@{
                skill = $skillName
                repository = $repo
                requested_ref = $requestedRef
                resolved_ref = $resolvedRef
                archive_sha256 = $archiveHash
                hermes_raw_url = "https://raw.githubusercontent.com/$repo/$resolvedRef/skills/$skillName/SKILL.md"
            }
            $SourceLog.Add($record)
            $SourceBySkill[$skillName] = $record
        }
    }

    # Validate all 16 staged skills before changing destinations.
    & $Validator -SkillRoot $StageRoot -ExpectedNames $AllNames

    # Preflight OpenCode and local Hermes skill destinations.
    $copyTargets = @()
    if (-not $SkipOpenCode) {
        foreach ($skillName in $AllNames) {
            $copyTargets += [pscustomobject]@{ Platform = "OpenCode"; Name = $skillName; Root = $OpenCodeRoot }
        }
    }
    if (-not $SkipHermes) {
        foreach ($skillName in $LocalNames) {
            $copyTargets += [pscustomobject]@{ Platform = "Hermes"; Name = $skillName; Root = $HermesRoot }
        }
    }

    $collisions = New-Object System.Collections.Generic.List[string]
    foreach ($item in $copyTargets) {
        $dest = Join-Path $item.Root $item.Name
        if (Test-Path -LiteralPath $dest) { $collisions.Add("$($item.Platform): $dest") }
    }
    if ($collisions.Count -gt 0 -and -not $Force) {
        Write-Host "Existing skill folders were found:" -ForegroundColor Yellow
        foreach ($collision in $collisions) { Write-Host "  $collision" -ForegroundColor Yellow }
        throw "No destination changes were made. Re-run with -Force to back up and replace these OpenCode/local-Hermes folders. Hermes upstream folders are managed separately by the Hermes CLI."
    }

    # Install copies: OpenCode gets all 16; Hermes gets the nine local/original skills.
    foreach ($item in $copyTargets) {
        New-Item -ItemType Directory -Path $item.Root -Force | Out-Null
        $dest = Join-Path $item.Root $item.Name

        if (Test-Path -LiteralPath $dest) {
            $backup = Join-Path (Join-Path $BackupRoot $item.Platform) $item.Name
            New-Item -ItemType Directory -Path (Split-Path -Parent $backup) -Force | Out-Null
            Move-Item -LiteralPath $dest -Destination $backup
            $Backups.Add([pscustomobject]@{ Original = $dest; Backup = $backup })
        }

        $staged = Join-Path $StageRoot $item.Name
        $InstalledCopies.Add($dest)
        Copy-Item -LiteralPath $staged -Destination $dest -Recurse
    }

    if (-not $SkipOpenCode) {
        & $Validator -SkillRoot $OpenCodeRoot -ExpectedNames $AllNames
        Write-Host "OpenCode: all 16 skills installed and validated." -ForegroundColor Green
    }

    if (-not $SkipHermes) {
        # Install seven upstream skills through Hermes' own Skills Hub scanner.
        foreach ($skillName in $UpstreamNames) {
            $record = $SourceBySkill[$skillName]
            $rawUrl = [string]$record.hermes_raw_url
            Write-Host "Hermes security-scanned install: $skillName"
            & $HermesCommand.Name skills install $rawUrl
            if ($LASTEXITCODE -ne 0) {
                throw "Hermes CLI failed or installation was declined for $skillName. Previously approved Hub installs may remain; inspect 'hermes skills list' before retrying."
            }

            $installedPaths = @(Find-SkillFoldersByName -Root $HermesRoot -SkillName $skillName)
            if ($installedPaths.Count -ne 1) {
                throw "Hermes reported success but expected exactly one installed '$skillName' skill; found $($installedPaths.Count)."
            }
            $hermesSkillPath = $installedPaths[0]
            $hermesSkillFile = Join-Path $hermesSkillPath "SKILL.md"

            # Preserve the source notices and apply the same local portability patch
            # to the scanner-installed copy.
            Copy-Item -LiteralPath (Join-Path (Join-Path $StageRoot $skillName) "UPSTREAM-LICENSE.txt") -Destination (Join-Path $hermesSkillPath "UPSTREAM-LICENSE.txt") -Force
            Copy-Item -LiteralPath (Join-Path (Join-Path $StageRoot $skillName) "UPSTREAM-SOURCE.txt") -Destination (Join-Path $hermesSkillPath "UPSTREAM-SOURCE.txt") -Force
            Add-IntegrationCompatibility -SkillName $skillName -SkillPath $hermesSkillPath

            # requesting-code-review uses a root-level review template. The Hub
            # fetches referenced support folders; copy this exact MIT-licensed file
            # from the same pinned archive if it exists.
            $rootSupportFiles = Get-ChildItem -LiteralPath (Join-Path $StageRoot $skillName) -File -Filter "*.md" |
                Where-Object { $_.Name -ne "SKILL.md" }
            foreach ($supportFile in $rootSupportFiles) {
                Copy-Item -LiteralPath $supportFile.FullName -Destination (Join-Path $hermesSkillPath $supportFile.Name) -Force
            }
            $HermesHubInstalled.Add($skillName)
        }

        # Re-scan Hub-installed skills after the local compatibility edits.
        & $HermesCommand.Name skills audit
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Hermes skills audit returned a non-zero exit code. Review the audit/quarantine output; the following structural validation will fail if any selected skill is not active."
        }

        & $Validator -SkillRoot $HermesRoot -ExpectedNames $AllNames
        Write-Host "Hermes: all 16 skills are present and structurally validated." -ForegroundColor Green
        Write-Host "Hermes CLI inventory:"
        & $HermesCommand.Name skills list
    }

    $logDirectory = Join-Path $HOME ".skill-install-logs"
    New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
    $logPath = Join-Path $logDirectory ("master-skills-" + (Get-Date -Format "yyyyMMdd-HHmmss-fff") + ".json")
    $SourceLog | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $logPath -Encoding UTF8

    Write-Host ""
    Write-Host "Installation completed. Source log: $logPath" -ForegroundColor Green
    if ($Backups.Count -gt 0) { Write-Host "Previous copy-based folders backed up under: $BackupRoot" }
    Write-Host "Restart both agents. Hermes installs the seven upstream skills through its security-scanned CLI pipeline."
    Write-Host "The installer does not execute downloaded scripts or install optional Python/EDA tools."
}
catch {
    Write-Host "Installation failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Rolling back only folders copied directly by this installer..." -ForegroundColor Yellow

    for ($i = $InstalledCopies.Count - 1; $i -ge 0; $i--) {
        $dest = $InstalledCopies[$i]
        if (Test-Path -LiteralPath $dest) {
            try { Remove-Item -LiteralPath $dest -Recurse -Force -ErrorAction Stop }
            catch { Write-Warning "Could not remove partial copy $dest : $($_.Exception.Message)" }
        }
    }
    for ($i = $Backups.Count - 1; $i -ge 0; $i--) {
        $entry = $Backups[$i]
        if (Test-Path -LiteralPath $entry.Backup) {
            try {
                New-Item -ItemType Directory -Path (Split-Path -Parent $entry.Original) -Force | Out-Null
                Move-Item -LiteralPath $entry.Backup -Destination $entry.Original -ErrorAction Stop
            } catch {
                Write-Warning "Could not restore backup $($entry.Backup) to $($entry.Original): $($_.Exception.Message)"
            }
        }
    }
    if ($HermesHubInstalled.Count -gt 0) {
        Write-Warning ("Hermes Hub-installed skills are not automatically uninstalled during rollback. Review: " + ($HermesHubInstalled -join ", ") + ". Use 'hermes skills list' and manage them through Hermes.")
    }
    throw
}
finally {
    if (Test-Path -LiteralPath $TempRoot) {
        try { Remove-Item -LiteralPath $TempRoot -Recurse -Force -ErrorAction Stop }
        catch { Write-Warning "Temporary staging cleanup failed: $($_.Exception.Message)" }
    }
}
