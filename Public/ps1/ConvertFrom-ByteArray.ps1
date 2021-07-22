function ConvertFrom-ByteArray {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [System.Byte[]]
        $ByteArray

    )
    Process {

        try {
            return [char[]]$ByteArray
        }
        catch {
            throw $_
        }

    }

}
