function Convert-StringToHash {

    [CmdletBinding()]
    [Alias("stringhash")]
    Param (
        
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $String,

        [Parameter(Position = 1)]
        [ValidateSet('MACTripleDES', 'MD5', 'RIPEMD160', 'SHA1', 'SHA256', 'SHA512')]
        [string]
        $HashingAlgorithm = 'MD5'

    )
    begin {

        $algorithm = [System.Security.Cryptography.HashAlgorithm]::Create($HashingAlgorithm) # Instantiate the algorithm
        $encoder = [System.Text.Encoding]::UTF8 # Instantiate the string encoder

    }
    process {

        $String | ForEach-Object {

            $stringToBytes = $encoder.GetBytes($_)
            $stringBuilder = New-Object System.Text.StringBuilder # Instantiate the string builder for final output
            $algorithm.ComputeHash($stringToBytes) | ForEach-Object {

                # Parsing each byte and adding to final string output
                $stringBuilder.Append($_.ToString('x2')) | Out-Null

            }
            
            return $stringBuilder.ToString()

        }

    }

}