function Out-Uri {

    [CmdletBinding()]
    Param (

        [Parameter (
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $UriString

    )

    $castURI = $UriString -as [System.Uri]
    if (-not $castURI.AbsoluteUri) { $castURI = ('https://' + $UriString) -as [System.Uri] }
    if (-not $castURI.AbsoluteUri) { Write-Error "Ensure URL is in valid format."}
    else { return $castURI }

}