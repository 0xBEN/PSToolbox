function Out-UrlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's URL encoded equivalent.

    .EXAMPLE
    PS> Out-UrlEncoding -InputString ' '

    %20

    .EXAMPLE
    If you are doing some input fuzzing against a web app and want to encode the URI before submitting.

    PS> Out-UrlEncoding -InputString 'http://some.site/path?input=cat /etc/passwd'

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
        [String[]]$InputString,

        [Parameter()]
        [Switch]$EncodeAllCharacters
    )
    process {

        $InputString | ForEach-Object {

            $isUri = $_ -as [Uri] | Select-Object -ExpandProperty IsAbsoluteUri
            if ($isUri) { # User passed a URI to encode
                [System.UriBuilder]::new($_).Uri.AbsoluteUri
            }
            elseif ($EncodeAllCharacters) {            
                [System.Web.HttpUtility]::UrlEncode($_)                
            }
            else { # User passed a string to encode
                [System.Web.HttpUtility]::UrlEncode($_)
            }

        }

    }

}
