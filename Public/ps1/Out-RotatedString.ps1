function Out-RotatedString {
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString,

        [Parameter(Mandatory = $true)]
        [ValidateScript({$_ -gt 0 -and $_ -lt 25})]
        [Byte]
        $RotateBy
    )
    begin {
        $RotateBy -= 1 # Since chars are 0 indexed
        $lowerChars = 97..122 | ForEach-Object { [char][byte]$_ }
        $lastLowerIndex = $lowerChars.IndexOf($lowerChars[-1])
        $upperChars = $lowerChars | ForEach-Object { $_.ToString().ToUpper() }
        $lastUpperIndex = $upperChars.IndexOf($upperChars[-1])
    }
    process {
        $charArray = $InputString.ToCharArray()
        $rotatedChars = $charArray | ForEach-Object {

            if ([char]::IsLetter($_)) {
                if ([char]::IsUpper($_)) {
                    $upperIndex = $upperChars.IndexOf($_)
                    $rotationTotal = $upperIndex + $RotateBy
                    if (($rotationTotal) -gt ($lastUpperIndex)) {
                        $newChar = $upperChars[($rotationTotal - $lastUpperIndex)]
                    }
                    else {
                        $newChar = $upperChars[$rotationTotal]
                    }
                    $newChar
                }
                else {
                    $lowerIndex = $lowerChars.IndexOf($_)
                    $rotationTotal = $lowerIndex + $RotateBy
                    if (($rotationTotal) -gt ($lastLowerIndex)) {
                        $newChar = $lowerChars[($rotationTotal - $lastLowerIndex)]
                    }
                    else {
                        $newChar = $lowerChars[$rotationTotal]
                    }
                    $newChar
                }

            }
            else {
                $_
            }
            
        }
    }
    end {
        return $rotatedChars -join ''
    }

}