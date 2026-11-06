$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'Verify-Docs.ps1')

$fixture = [IO.Path]::GetTempFileName()
try {
    $cases = @(
        @{ Name = 'tilde'; Lines = @('~~~markdown', '# Hidden', '[bad](missing.md)', '~~~') },
        @{ Name = 'backtick'; Lines = @('```markdown', '# Hidden', '[bad](missing.md)', '```') },
        @{ Name = 'short closer'; Lines = @('````', '```', '# Hidden', '[bad](missing.md)', '````') },
        @{ Name = 'mixed closer'; Lines = @('~~~', '```', '# Hidden', '[bad](missing.md)', '~~~') },
        @{ Name = 'closer with text'; Lines = @('```', '```not-a-closer', '# Hidden', '[bad](missing.md)', '```') },
        @{ Name = 'longer closer'; Lines = @('~~~', '# Hidden', '[bad](missing.md)', '~~~~') },
        @{ Name = 'indented fence'; Lines = @('   ~~~', '# Hidden', '[bad](missing.md)', '   ~~~') }
    )
    foreach ($case in $cases) {
        $lines = @('# Visible') + $case.Lines + @('[visible](#visible)')
        Set-Content -LiteralPath $fixture -Value $lines
        $headingCache.Clear()
        $anchors = @(Get-MarkdownHeadings $fixture)
        $links = @(Get-MarkdownLinks $fixture)
        if ($anchors.Count -ne 1 -or $anchors[0] -ne 'visible' -or
            $links.Count -ne 1 -or $links[0].Target -ne '#visible' -or
            $links[0].LineNumber -ne $lines.Count) {
            throw "Fence regression: $($case.Name)"
        }
        # The same filter must prevent a fenced H1 from breaking section checks.
        $sections = @($requiredSections | ForEach-Object { "## $_" })
        Set-Content -LiteralPath $fixture -Value (@('# Visible') + $case.Lines + $sections)
        $failures.Clear()
        Test-RequiredSections $fixture
        if ($failures.Count -ne 0) { throw "Structure regression: $($case.Name)" }
    }

    Set-Content $fixture -Value @('# Visible', '~~~', '# Hidden', '[bad](missing.md)')
    if (@(Get-MarkdownLinks $fixture).Count -ne 0) { throw 'Unclosed fence leaked content' }

    Set-Content $fixture -Value @('```invalid`info', '[visible](#visible)')
    if (@(Get-MarkdownLinks $fixture).Count -ne 1) { throw 'Invalid opener swallowed content' }

    Set-Content $fixture -Value @('~~~', '[ignored](missing.md)', '~~~', '[bad](missing.md)')
    $failures.Clear()
    $link = @(Get-MarkdownLinks $fixture)[0]
    Test-LinkTarget $fixture $link.Target $link.LineNumber
    if ($failures.Count -ne 1 -or $failures[0] -notmatch ':4 references missing path') {
        throw 'Real broken link after fence was not reported at line 4'
    }

    Set-Content $fixture -Value @('Use `[example](missing.md)` when explaining Markdown.', '[real](#visible)')
    $links = @(Get-MarkdownLinks $fixture)
    if ($links.Count -ne 1 -or $links[0].Target -ne '#visible' -or $links[0].LineNumber -ne 2) {
        throw 'Inline code span was treated as a navigable link'
    }

    Set-Content $fixture -Value @('``[example](missing.md)``', '[real](#visible)')
    $links = @(Get-MarkdownLinks $fixture)
    if ($links.Count -ne 1 -or $links[0].Target -ne '#visible') {
        throw 'Multi-backtick inline code span was treated as a navigable link'
    }
    Write-Host 'Passed Markdown fence and inline-code regression scenarios.'
}
finally {
    Remove-Item -LiteralPath $fixture
}

