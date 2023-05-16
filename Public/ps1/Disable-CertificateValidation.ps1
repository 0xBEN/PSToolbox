function Disable-CertificateValidation {

    [CmdletBinding()]
    Param()
    process {
        
        if (-not ([System.Net.ServicePointManager]::ServerCertificateValidationCallback)) {
        
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
            
        }
    }

}
