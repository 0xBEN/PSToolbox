function Out-UrlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's URL encoded equivalent.

    .EXAMPLE
    PS> Out-UrlEncoding -InputString ' '

    %20

    .EXAMPLE
    If you are doing some input fuzzing against a web app and want to encode the URI before submitting.

    PS> Out-UrlEncoding -InputString 'http://some.site/path?input=cat /etc/passwd > local.file'

    http://some.site/path?input=cat%20/etc/passwd%20%3E%20local.file

    .INPUTS
    System.String
    
    .OUTPUTS
    System.String
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString
    )
    process {

        $InputString | ForEach-Object {

            $isUri = [System.Uri]$_ | Select-Object -ExpandProperty Scheme
            if ($isUri) { # User passed a URI to encode

                [System.UriBuilder]::new($_).Uri.AbsoluteUri

            }
            else { # User passed a string to encode

                [System.Text.Encodings.Web.UrlEncoder]::Default.Encode($_)

            }

        }

    }

}