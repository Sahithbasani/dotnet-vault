[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. (Join-Path $PSScriptRoot "Markdown-Lines.ps1")

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$docsRoot = Join-Path $repoRoot "docs"
$requiredSections = @(
    "Overview",
    "Why It Matters in Real Projects",
    "Core Concepts",
    "Practical Explanation",
    "Enterprise / Backend Use Case",
    "Production Considerations",
    "C# / .NET Example",
    "Best Practices",
    "Common Mistakes",
    "Interview Questions",
    "References"
)
$structureIgnoredFiles = @(
    (Join-Path $docsRoot "README.md")
)
$headingCache = @{}
$failures = New-Object System.Collections.ArrayList
$linkCount = 0

function Add-Failure {
    param([string]$Message)

    [void]$failures.Add($Message)
}

function ConvertTo-GitHubAnchor {
    param([string]$Heading)

    $anchor = $Heading.ToLowerInvariant().Trim()
    $anchor = $anchor -replace '<[^>]+>', ''
    $anchor = $anchor -replace '[`*_~]', ''
    $anchor = $anchor -replace '&amp;', 'and'
    $anchor = $anchor -replace '[^a-z0-9 _-]', ''
    $anchor = $anchor -replace '\s+', '-'
    $anchor = $anchor -replace '-+', '-'
    return $anchor.Trim('-')
}

function Get-MarkdownHeadings {
    param([string]$Path)

    if ($headingCache.ContainsKey($Path)) {
        return $headingCache[$Path]
    }

    $anchors = @()
    $anchorCounts = @{}

    foreach ($line in Get-MarkdownContentLines -Path $Path) {
        if ($line -match '^(#{1,6})\s+(.+?)\s*$') {
            $baseAnchor = ConvertTo-GitHubAnchor -Heading $Matches[2]
            if ([string]::IsNullOrWhiteSpace($baseAnchor)) {
                continue
            }

            if ($anchorCounts.ContainsKey($baseAnchor)) {
                $anchorCounts[$baseAnchor] = [int]$anchorCounts[$baseAnchor] + 1
                $anchor = "{0}-{1}" -f $baseAnchor, $anchorCounts[$baseAnchor]
            }
            else {
                $anchorCounts[$baseAnchor] = 0
                $anchor = $baseAnchor
            }

            $anchors += $anchor
        }
    }

    $headingCache[$Path] = $anchors
    return $anchors
}

function Get-MarkdownLinks {
    param([string]$Path)

    $results = @()
    $lineNumber = 0

    foreach ($line in Get-MarkdownContentLines -Path $Path) {
        $lineNumber++

        $matches = [System.Text.RegularExpressions.Regex]::Matches($line, '!?\[[^\]]*\]\((?<target>[^)]+)\)')
        foreach ($match in $matches) {
            $target = $match.Groups["target"].Value.Trim()

            if ($target -match '^(?<path><[^>]+>|[^ ]+)(?:\s+".*")?$') {
                $target = $Matches["path"]
            }

            if ($target.StartsWith("<") -and $target.EndsWith(">")) {
                $target = $target.Substring(1, $target.Length - 2)
            }

            $results += [pscustomobject]@{
                LineNumber = $lineNumber
                Target = $target
            }
        }
    }

    return $results
}

function Test-RequiredSections {
    param([string]$Path)

    if ($structureIgnoredFiles -contains $Path) {
        return
    }

    $sectionHeadings = @()
    $h1Count = 0

    foreach ($line in Get-MarkdownContentLines -Path $Path) {
        if ($line -match '^#\s+(.+?)\s*$') {
            $h1Count++
        }

        if ($line -match '^##\s+(.+?)\s*$') {
            $sectionHeadings += $Matches[1].Trim()
        }
    }

    if ($h1Count -ne 1) {
        Add-Failure ("{0} should contain exactly one H1 heading, found {1}." -f $Path, $h1Count)
    }

    foreach ($section in $requiredSections) {
        if (-not ($sectionHeadings -contains $section)) {
            Add-Failure ("{0} is missing required section '{1}'." -f $Path, $section)
        }
    }

    $positions = foreach ($section in $requiredSections) {
        [array]::IndexOf($sectionHeadings, $section)
    }

    for ($index = 1; $index -lt $positions.Count; $index++) {
        if ($positions[$index] -lt $positions[$index - 1]) {
            Add-Failure ("{0} does not keep the standard section order." -f $Path)
            break
        }
    }
}

function Test-LinkTarget {
    param(
        [string]$SourcePath,
        [string]$Target,
        [int]$LineNumber
    )

    if ([string]::IsNullOrWhiteSpace($Target)) {
        return
    }

    if ($Target -match '^(https?|mailto):') {
        return
    }

    $script:linkCount++
    $decodedTarget = [System.Uri]::UnescapeDataString($Target)
    $fragment = $null
    $pathPart = $decodedTarget

    if ($decodedTarget.Contains("#")) {
        $parts = $decodedTarget.Split("#", 2)
        $pathPart = $parts[0]
        $fragment = $parts[1]
    }

    if ([string]::IsNullOrWhiteSpace($pathPart)) {
        $resolvedPath = $SourcePath
    }
    else {
        $candidatePath = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $SourcePath) $pathPart))
        if (-not (Test-Path -LiteralPath $candidatePath)) {
            Add-Failure ("{0}:{1} references missing path '{2}'." -f $SourcePath, $LineNumber, $Target)
            return
        }

        $resolvedPath = $candidatePath
    }

    if ([string]::IsNullOrWhiteSpace($fragment)) {
        return
    }

    $anchors = Get-MarkdownHeadings -Path $resolvedPath
    if (-not ($anchors -contains $fragment)) {
        Add-Failure ("{0}:{1} references missing anchor '{2}' in '{3}'." -f $SourcePath, $LineNumber, $fragment, $resolvedPath)
    }
}

$allPaths = @(Get-ChildItem -Path $repoRoot -Recurse -File -Filter *.md |
    Where-Object { $_.FullName -notlike (Join-Path $repoRoot ".git\*") } |
    Sort-Object FullName |
    ForEach-Object { $_.FullName })

foreach ($path in $allPaths) {
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }

    if ($path -like "$docsRoot*") {
        Test-RequiredSections -Path $path
    }

    foreach ($link in Get-MarkdownLinks -Path $path) {
        Test-LinkTarget -SourcePath $path -Target $link.Target -LineNumber $link.LineNumber
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }

    throw "Documentation verification failed with $($failures.Count) issue(s)."
}

Write-Host ("Verified {0} Markdown files and {1} internal link(s)." -f $allPaths.Count, $linkCount)
