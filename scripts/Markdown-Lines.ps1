function Get-MarkdownContentLines {
    param([string]$Path)

    # Preserve line numbers by replacing fence delimiters and contents with blanks.
    # This handles top-level fences, not nested list/blockquote containers.
    $fenceCharacter = $null
    $fenceLength = 0
    foreach ($line in Get-Content -LiteralPath $Path) {
        if ($null -ne $fenceCharacter) {
            if ($line -match '^ {0,3}(`{3,}|~{3,})[ \t]*$') {
                $delimiter = $Matches[1]
                if ($delimiter[0] -eq $fenceCharacter -and $delimiter.Length -ge $fenceLength) {
                    $fenceCharacter = $null
                }
            }
            ''
            continue
        }

        if ($line -match '^ {0,3}(`{3,}|~{3,})(.*)$') {
            $delimiter = $Matches[1]
            $info = $Matches[2]
            # Backtick fence info strings cannot themselves contain backticks.
            if ($delimiter[0] -eq '~' -or -not $info.Contains('`')) {
                $fenceCharacter = $delimiter[0]
                $fenceLength = $delimiter.Length
                ''
                continue
            }
        }
        $line
    }
}
