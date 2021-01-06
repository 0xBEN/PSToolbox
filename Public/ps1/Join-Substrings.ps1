function Join-Substrings {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $String,

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [ValidateScript({$_ -gt 0 })]
        [Byte]
        $SplitIndex,

        [Parameter(
            Mandatory = $true,
            Position = 2
        )]
        [AllowEmptyString()]
        [String]
        $JoinTo
    )
    process {

        $String | ForEach-Object {
           
            $length = $_.Length
            if ($length % $SplitIndex -ne 0) { 
                Write-Error "$_ is $length characters long and is not divisible by $SplitIndex" 
            }
            else {
                $index = 0
                $length = $_.Length
                $subStrings = while ($index -lt $length) {
                    $_.Substring($index, $SplitIndex)
                    $index += $SplitIndex 
                }
                return $subStrings -join $JoinTo
            }

        }

    }
    
}