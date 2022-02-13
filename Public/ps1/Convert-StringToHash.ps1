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
			[String]$hash = ''
            $algorithm.ComputeHash($stringToBytes) | ForEach-Object {

				# ComputeHash() method returns raw bytes
                # Output each byte in hexadecimal and append to string
				$hash += '{0:X}' -f $_

            }
            
            return $hash

        }

    }

}
