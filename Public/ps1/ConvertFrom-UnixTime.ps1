function ConvertFrom-UnixTime {

    [CmdletBinding()]
    [Alias('ConvertFrom-EpochTime')]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Double[]]
        $TotalSeconds

    )
    begin {

        $unixEpoch = Get-Date '1/1/1970 00:00:00'

    }
    process {

        $TotalSeconds | ForEach-Object {

            Write-Verbose "Converting seconds to local timestamp"
            return $unixEpoch.AddSeconds($_)

        }

    }

}