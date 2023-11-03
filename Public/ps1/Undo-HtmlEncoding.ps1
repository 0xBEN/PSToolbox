function Undo-HtmlEncoding {

    <#
    .SYNOPSIS
    Decodes HTML encoded strings to plaintext.

    .EXAMPLE
    PS> Undo-HtmlEncoding -InputString '&#x3C;&#x3E;&#x20;&#x74;&#x65;&#x73;&#x74;&#x20;&#x26;&#x20;&#x22;'

    <> test & "

    .EXAMPLE
    PS> Undo-HtmlEncoding -InputString '&lt;&gt; test &amp; &quot;'

    <> test & "

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
