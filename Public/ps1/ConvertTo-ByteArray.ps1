function ConvertTo-ByteArray {

    [CmdletBinding()]
    Param (
        
        [Parameter( 
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $InputString,

        [Parameter(Position = 1)]
        [ValidateSet(2, 16)]
        [Int]
        $Base = 2

    )
    Process {

        $InputString | ForEach-Object {

            $byteArray = $_.ToCharArray() | ForEach-Object {

                if ($Base -eq 2) { [byte][char]$_ }
                else { '0x' + '{0:X}' -f [byte][char]$_ }

            }
            return $byteArray

        }

    }

}