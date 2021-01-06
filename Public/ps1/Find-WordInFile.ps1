function Find-WordInFile {

    <#
    .SYNOPSIS

    Searches files for a string and optionally replaces the string in the file.

    .DESCRIPTION
    
    Searches files for a string or list of strings.
    Outputs the string name and the name of the file if the string found.
    Optionally, provides the ability to replace the string(s) in the file.

    .PARAMETER WordToFind

    This parameter is mandatory.
    Only accepts string input.
    Will accept a list of strings.

    .PARAMETER Path

    This parameter is mandatory.
    Only accepts string input.
    Will validate if the input is a valid path.
    Can be a path to a directory or to a file.
    If the path is a directory, a recursive search will be performed.

    .PARAMETER FileExtension

    Optional.
    Only accepts string input.
    May provide a single or list of strings.
    If the path specified is a directory, will only search files with matching file extensions.

    .PARAMETER ReplaceWith

    Only accepts string input.
    This is the string that will replace WordToFind.
    The original file will be overwritten.
    
    .EXAMPLE

    PS C:\WINDOWS\system32> Find-WordInFile -WordToFind 'word13', 'Word97', 'word22' -Path ~/Desktop
    
    Found in: C:\Users\TestUser\Desktop\wordcount1
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    Found in: C:\Users\TestUser\Desktop\wordcount10
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    Found in: C:\Users\TestUser\Desktop\wordcount2
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    Found in: C:\Users\TestUser\Desktop\wordcount3
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    Found in: C:\Users\TestUser\Desktop\wordcount4
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    Found in: C:\Users\TestUser\Desktop\wordcount5
    Line 13: Word13
    Line 97: Word97
    Line 22: Word22
    ...

    .EXAMPLE

    PS C:\WINDOWS\system32> Find-WordInFile -WordToFind 'word13', 'Word97', 'word22' -Path ~/Desktop -FileExtension '.txt' -ReplaceWith 'replace with this text.'
    
    Found in: C:\Users\BenHeater\Desktop\wordlist1.txt
    Line 13: word13
    ReplacedWith: replace with this text.
    Line 97: Word97
    ReplacedWith: replace with this text.
    Line 22: word22
    ReplacedWith: replace with this text.
    Found in: C:\Users\BenHeater\Desktop\wordlist10.txt
    Line 13: word13
    ReplacedWith: replace with this text.
    Line 97: Word97
    ReplacedWith: replace with this text.
    Line 22: word22
    ReplacedWith: replace with this text.
    Found in: C:\Users\BenHeater\Desktop\wordlist2.txt
    Line 13: word13
    ReplacedWith: replace with this text.
    Line 97: Word97
    ReplacedWith: replace with this text.
    Line 22: word22
    ReplacedWith: replace with this text.    
    ...

    .INPUTS
       
    System.String
    System.IO.Path

    .OUTPUTS
        
    System.String
    #>

    [CmdletBinding()]
    Param (

        [Parameter(
            ParameterSetName = 'Find',
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [Parameter(
            ParameterSetName = 'Replace',
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $WordToFind,

        [Parameter(
            ParameterSetName = 'Find',
            Mandatory = $true
        )]
        [Parameter(
            ParameterSetName = 'Replace',
            Mandatory = $true
        )]
        [ValidateScript({try { Resolve-Path $_ } catch { throw $_ }})]
        [string[]]
        $Path,

        [Parameter(ParameterSetName = 'Find')]
        [Parameter(ParameterSetName = 'Replace')]
        [ValidateScript({$_.StartsWith('.')})]
        [string[]]
        $FileExtension,

        [Parameter(
            ParameterSetName = 'Replace',
            Mandatory = $true
        )]
        [AllowNull()]
        [AllowEmptyString()]
        [string]
        $ReplaceWith,

        [Parameter(ParameterSetName = 'Replace')]
        [Switch]
        $WhatIf

    )
    begin {
        $WordToFind = $WordToFind | ForEach-Object { [regex]::Escape($_) }
    }
    process {

        $Path | ForEach-Object {

            $workingPath = $_
            if (($workingPath | Get-Item).Mode.StartsWith('d')) { # Directory

                $childItems = Get-ChildItem -Path $workingPath -File -Recurse
                if ($FileExtension) { 
                    
                    $childItems = $childItems | Where-Object { $_.Extension -eq $FileExtension }
                    if (-not $childItems) { Write-Error "No files with extension: $FileExtension in $($workingPath.FullName)"}
                
                }
                   
                $childItems | ForEach-Object {

                    $childItem = $_
                    Write-Verbose "Now processing: $($childItem.FullName)"

                    $fileContents = $childItem | Get-Content
                    $modifiedContents = $fileContents
                    $matchesFound = $false
                    $WordToFind.ForEach({ if ($fileContents -match ".*$_*") { $matchesFound = $true } })
                    if ($matchesFound) {

                        Write-Host "Found in: " -NoNewline
                        Write-Host $childItem.FullName -ForegroundColor Green

                        $WordToFind | ForEach-Object {
                        
                            $word = $_
                            $indexCounter = 0
                            $fileContents | ForEach-Object {

                                $indexOfLine = $indexCounter
                                $line = $_
                                if ($line -match ".*$word*") {
                                    
                                    Write-Host "Line $($indexCounter + 1): " -ForegroundColor Green -NoNewline 
                                    Write-Host $line
                                    if ($PSCmdlet.ParameterSetName -eq 'Replace') {

                                        Write-Host "ReplacedWith: " -ForegroundColor Magenta -NoNewline
                                        $fileContents[$indexOfLine] -replace $word, $ReplaceWith
                                        $modifiedContents[$indexOfLine] = $modifiedContents[$indexOfLine] -replace $word, $ReplaceWith

                                    }

                                }
                                $indexCounter++
                                
                            }
                            if ($PSCmdlet.ParameterSetName -eq 'Replace') { 
                            
                                if ($WhatIf.IsPresent) {
                                    Write-Warning "No replace action taken. WhatIf enabled."
                                }
                                else {
                                    $modifiedContents > $childItem.FullName 
                                }
                            
                            }

                        }

                    }
                    else {

                        Write-Error "No matches found in $($childItem.FullName)"

                    }

                }

            }
            else { # File

                $item = Get-Item -Path $workingPath
                if ($FileExtension) {

                    $item = $item | Where-Object { $_.Extension -eq $FileExtension }
                    if (-not $item) { Write-Error "No file with that extension: $FileExtension"}

                }
                Write-Verbose "Now processing: $($item.FullName)"

                $fileContents = $item | Get-Content
                $modifiedContents = $fileContents
                $matchesFound = $false
                $WordToFind.ForEach({ if ($fileContents -match ".*$_*") { $matchesFound = $true } })
                if ($matchesFound) {

                    Write-Host "Found in: " -NoNewline
                    Write-Host $item.FullName -ForegroundColor Green

                    $WordToFind | ForEach-Object {
                    
                        $word = $_
                        $indexCounter = 0
                        $fileContents | ForEach-Object {

                            $indexOfLine = $indexCounter
                            $line = $_
                            if ($line -match ".*$word*") {
                                
                                Write-Host "Line $($indexCounter + 1): " -ForegroundColor Green -NoNewline 
                                Write-Host $line
                                if ($PSCmdlet.ParameterSetName -eq 'Replace') {

                                    Write-Host "ReplacedWith: " -ForegroundColor Magenta -NoNewline
                                    $fileContents[$indexOfLine] -replace $word, $ReplaceWith
                                    $modifiedContents[$indexOfLine] = $modifiedContents[$indexOfLine] -replace $word, $ReplaceWith

                                }

                            }
                            $indexCounter++    

                        }
                        if ($PSCmdlet.ParameterSetName -eq 'Replace') { 
                            
                            if ($WhatIf.IsPresent) {
                                Write-Warning "No replace action taken. WhatIf enabled."
                            }
                            else {
                                $modifiedContents > $item.FullName 
                            }
                        
                        }
                        
                    }

                }
                else {

                    Write-Error "No matches found in $($item.FullName)"

                }

            }

        }

    }

}