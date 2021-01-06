function ConvertFrom-UnixTime {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Int]
        $TotalSeconds

    )
    begin {

        $unixEpoch = Get-Date '1/1/1970 00:00:00'

    }
    process {

        $TotalSeconds | ForEach-Object {

            return $unixEpoch.AddSeconds($_)

        }

    }

}