function Out-RotatedString {
    
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString,

        [Parameter(Mandatory = $true)]
        [ValidateScript({$_ -ge 1 -and $_ -le 26})]
        [Byte]
        $RotateBy,

        [Parameter()]
        [Switch]
        $Reverse
    )
    begin {
        $lowerBytes = 91..122
        $upperBytes = 65..90
    }
    process {
        $charArray = $InputString.ToCharArray()
        $rotatedChars = $charArray | ForEach-Object {

            if ([char]::IsLetter($_)) {
            
                if ([char]::IsUpper($_)) {
                    [byte]$upperByte = $_
                    if ($Reverse) {
                        $rotationTotal = $upperByte - $RotateBy
                        if ($rotationTotal -lt $upperBytes[0]) {
                            $remainder = $upperBytes[0] - $rotationTotal - 1
                            $byteOffset = $upperBytes[-1] - $remainder
                            $returnByte = $byteOffset
                        }
                        else {
                            $returnByte = $rotationTotal
                        }
                    }
                    else {
                        $rotationTotal = $upperByte + $RotateBy
                        if ($rotationTotal -gt $upperBytes[-1]) {
                            $remainder = $rotationTotal - $upperBytes[-1]
                            $byteOffset = $upperBytes[0] + $remainder - 1
                            $returnByte = $byteOffset
                        }
                        else {
                            $returnByte = $rotationTotal
                        }
                    }
                }
                else {
                    [byte]$lowerByte = $_
                    if ($Reverse) {
                        $rotationTotal = $lowerByte - $RotateBy
                        if ($rotationTotal -lt $lowerBytes[0]) {
                            $remainder = $lowerBytes[0] - $rotationTotal
                            $byteOffset = $lowerBytes[0] + $remainder - 1
                            $returnByte = $byteOffset
                        }
                        else {
                            $returnByte = $rotationTotal
                        }
                    }
                    else {
                        $rotationTotal = $lowerByte + $RotateBy
                        if ($rotationTotal -gt $lowerBytes[-1]) {
                            $remainder = $rotationTotal - $lowerBytes[-1]
                            $byteOffset = $rotationTotal - $remainder - 1
                            $returnByte = $byteOffset
                        }
                        else {
                            $returnByte = $rotationTotal
                        }
                    }
                }

                [char]($returnByte)

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
