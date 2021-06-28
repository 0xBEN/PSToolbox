function Get-UrlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's URL encoded equivalent.

    .EXAMPLE
    PS> Get-UrlEncoding -String ' '

    %20

    .EXAMPLE
    If you are doing some input fuzzing against a web app and want to encode the URI before submitting.

    PS> Get-UrlEncoding -URI 'http://some.site/path?input=cat /etc/passwd > local.file'

    http://some.site/path?input=cat%20/etc/passwd%20%3E%20local.file

    .INPUTS
    System.String
    System.Uri

    .OUTPUTS
    System.String
    #>
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(
            HelpMessage = 'Enter a character or string to encode.',
            Mandatory = $true,
            ParameterSetName = 'Default'
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $String,

        [Parameter(
            HelpMessage = 'Enter a URI with non-conforming characters to encode.',
            Mandatory = $true,
            ParameterSetName = 'URI'
        )]
        [ValidateNotNullOrEmpty()]
        [System.Uri[]]
        $URI
    )
    begin {
        $inputObject = if ($String) { $String } else { $URI }
    }
    process {

        $inputObject | ForEach-Object {
        
            if ($PSCmdlet.ParameterSetName -eq 'Default') {
                [System.Text.Encodings.Web.UrlEncoder]::Default.Encode($_)
            }
            else {
                [System.UriBuilder]::new($_).Uri.AbsoluteUri
            }

        }
        
    }

}