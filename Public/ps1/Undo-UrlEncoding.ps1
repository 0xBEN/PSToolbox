function Undo-UrlEncoding {

    <#
    .SYNOPSIS
    Decodes URL encoded strings to plaintext.

    .EXAMPLE
    PS> Undo-UrlEncoding -String 'http://some.site/path?input=cat%20/etc/passwd%20%3E%20local.file'

    http://some.site/path?input=cat /etc/passwd > local.file

    .EXAMPLE
    
    PS> Undo-UrlEncoding -String 'cat%20/etc/passwd%20%3E%20local.file'

    cat /etc/passwd > local.file

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
        $InputString | ForEach-Object { [System.Uri]::UnescapeDataString($_) }
    }

}
