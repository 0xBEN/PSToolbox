function ConvertFrom-ByteArray {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [System.Byte]
        $ByteArray

    )
    Process {

        $charArray = $ByteArray | ForEach-Object { [char][byte]$_ }
        return $charArray

    }

}