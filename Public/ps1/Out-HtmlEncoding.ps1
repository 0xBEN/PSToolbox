function Out-HtmlEncoding {

    <#
    .SYNOPSIS
    Converts input text into it's HTML encoded equivalent.

    .EXAMPLE
    PS> Out-HtmlEncoding '<> test & "'

    &lt;&gt; test &amp; &quot;

    .EXAMPLE
    PS> Out-HtmlEncoding '<> test & "' -EncodeAllCharacters

    &#x3C;&#x3E;&#x20;&#x74;&#x65;&#x73;&#x74;&#x20;&#x26;&#x20;&#x22;

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
                # Encodes all characters in the string as hexadecimal-encoded entities
                # Mimicks the functionality of [System.Text.Encodings.Web.HtmlEncoder]
                # This class is only available in PowerShell Core, so do it this way to preserve backwards functionality
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
