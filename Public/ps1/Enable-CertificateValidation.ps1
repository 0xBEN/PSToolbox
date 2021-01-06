function Enable-CertificateValidation {

    [CmdletBinding()]
    Param(

    )
    process {

        if (([System.Management.Automation.PSTypeName]"DoNotValidateCertificates").Type) { [DoNotValidateCertificates]::UnsetCallback() }
    
    }

}