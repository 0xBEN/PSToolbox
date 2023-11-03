function Out-HtmlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's HTML encoded equivalent.

    .EXAMPLE
    PS> Out-HtmlEncoding -InputString ' '

    &#x20;

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
        $InputString,

        [Parameter(Position = 1)]
        [Switch]$EncodeAllCharacters
    )
    process {

        $InputString | ForEach-Object {

            $string = $_
            if ($EncodeAllCharacters) {
                $charArray = $string.ToCharArray()
                $hexByteArray = $charArray | ForEach-Object { '{0:X}' -f [byte]$_ }
                $htmlEncodedHexByteArray = $hexByteArray | ForEach-Object { "&#x$_;" }
                -join$htmlEncodedHexByteArray
            }
            else {
                [System.Web.HttpUtility]::HtmlEncode($string)
            }

        }

    }

}