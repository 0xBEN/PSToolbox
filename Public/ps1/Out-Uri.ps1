function Out-Uri {

    <#
    .SYNOPSIS
    Takes a string as input and attempts to convert it to a System.Uri object.

    .EXAMPLE
    PS> Out-Uri -UriString 'http://some.site/path'

    AbsolutePath   : /path
    AbsoluteUri    : http://some.site/path
    LocalPath      : /path
    Authority      : some.site
    HostNameType   : Dns
    IsDefaultPort  : True
    IsFile         : False
    IsLoopback     : False
    PathAndQuery   : /path
    Segments       : {/, path}
    IsUnc          : False
    Host           : some.site
    Port           : 80
    Query          : 
    Fragment       : 
    Scheme         : http
    OriginalString : http://some.site/path
    DnsSafeHost    : some.site
    IdnHost        : some.site
    IsAbsoluteUri  : True
    UserEscaped    : False
    UserInfo       : 


    .EXAMPLE
    PS> Out-Uri -UriString 'https://10.0.0.100/path with spaces/'

    AbsolutePath   : /path%20with%20spaces/
    AbsoluteUri    : https://10.0.0.100/path%20with%20spaces/
    LocalPath      : /path with spaces/
    Authority      : 10.0.0.100
    HostNameType   : IPv4
    IsDefaultPort  : True
    IsFile         : False
    IsLoopback     : False
    PathAndQuery   : /path%20with%20spaces/
    Segments       : {/, path%20with%20spaces/}
    IsUnc          : False
    Host           : 10.0.0.100
    Port           : 443
    Query          : 
    Fragment       : 
    Scheme         : https
    OriginalString : https://10.0.0.100/path with spaces/
    DnsSafeHost    : 10.0.0.100
    IdnHost        : 10.0.0.100
    IsAbsoluteUri  : True
    UserEscaped    : False
    UserInfo       : 

    .INPUTS
    System.String

    .OUTPUTS
    System.Uri
    #>
    [CmdletBinding()]
    Param (

        [Parameter (
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $UriString

    )

    # Try to cast input as-is
    $castURI = $UriString -as [System.Uri]
    # Try to re-cast with a defined scheme
    if (-not $castURI.AbsoluteUri) { $castURI = ('https://' + $UriString) -as [System.Uri] }
    if (-not $castURI.AbsoluteUri) { Write-Error "Ensure URI string is in valid format."} # Throw an error
    else { return $castURI } # Or return the new URI

}