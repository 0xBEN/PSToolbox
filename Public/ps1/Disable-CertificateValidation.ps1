function Disable-CertificateValidation {

    [CmdletBinding()]
    Param(

    )
    begin {

        $class =
@"
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
public static class DoNotValidateCertificates
{
    private static bool ValidationCallback(object sender, X509Certificate certificate, X509Chain chain,
        SslPolicyErrors sslPolicyErrors) { return true; }
    public static void SetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = ValidationCallback; }
    public static void UnsetCallback() { System.Net.ServicePointManager.ServerCertificateValidationCallback = null; }
}
"@

    }
    process {

        if (-not ([System.Management.Automation.PSTypeName]"DoNotValidateCertificates").Type) { Add-Type -TypeDefinition $class }
        [DoNotValidateCertificates]::SetCallback()

    }

}
