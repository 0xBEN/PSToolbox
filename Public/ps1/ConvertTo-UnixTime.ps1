function ConvertTo-UnixTime {

    [CmdletBinding()]
    [Alias('ConvertTo-EpochTime')]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [DateTime[]]
        $DateTime

    )
    begin {

        $unixEpoch = Get-Date '1/1/1970 00:00:00'

    }
    process {

        $DateTime | ForEach-Object {

            Write-Verbose "Converting $_ to Unix Epoch time"
            ($_ - $unixEpoch).TotalSeconds

        }

    }
    end {

    }

}