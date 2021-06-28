function Out-UrlEncoding {

    [CmdletBinding(DefaultParameterSetName = 'String')]
    param (
        [Parameter(
            ParameterSetName = 'String',
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString,

        [Parameter(
            ParameterSetName = 'Uri',
            Mandatory = $true,
            Position = 0
        )]
        [System.Uri[]]
        $URI
    )
    begin {

        $parameterSetName = $PSCmdlet.ParameterSetName

    }
    process {

        if ($parameterSetName -eq 'String') {

            $InputString | ForEach-Object {

                [System.Text.Encodings.Web.UrlEncoder]::Default.Encode($_)

            }

        }
        else {

            $URI | ForEach-Object {

               [System.UriBuilder]::new($_.ToString()).Uri.AbsoluteUri

            }

        }

    }

}