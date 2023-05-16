function Enable-CertificateValidation {

    [CmdletBinding()]
    Param(

    )
    process {

        if ([System.Net.ServicePointManager]::ServerCertificateValidationCallback) { 
        
            [System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null
            
        }
    
    }

}
