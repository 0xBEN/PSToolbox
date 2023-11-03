function Undo-HtmlEncoding {

    <#
    .SYNOPSIS
    Decodes HTML encoded strings to plaintext.

    .EXAMPLE
    PS> Undo-HtmlEncoding -InputString '&#x54;&#x65;&#x73;&#x74;&#x20;&#x73;&#x74;&#x72;&#x69;&#x6E;&#x67;&#x20;&#x26;'

    Test string &

    .EXAMPLE
    PS> Undo-HtmlEncoding -InputString '&lt;&gt; test &amp;'

    <> test &

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
        $InputString | ForEach-Object { [System.Web.HttpUtility]::HtmlDecode($_) }
    }

}
