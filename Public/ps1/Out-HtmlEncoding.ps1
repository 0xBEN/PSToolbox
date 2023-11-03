function Out-HtmlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's HTML encoded equivalent.

    .EXAMPLE
    PS> Out-HtmlEncoding -InputString ' '

    &#x20;

    .EXAMPLE
    PS> Out-HtmlEncoding -InputString "<> test &"

    &lt;&gt; test &amp;

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
                # Output all characters as hexadeciaml-encoded HTML entities
                # Mimicks the functionality of the [System.Text.Encodings.Web.HtmlEncoder] class
                # This class is only available in PowerShell Core, doing it this way for backwards compatibility
                $charArray = $string.ToCharArray()
                $hexByteArray = $charArray | ForEach-Object { '{0:X}' -f [byte]$_ }
                $htmlEncodedHexByteArray = $hexByteArray | ForEach-Object { "&#x$_;" }
                -join$htmlEncodedHexByteArray
            }
            else {
                # Use the native 
                [System.Web.HttpUtility]::HtmlEncode($string)
            }

        }

    }

}