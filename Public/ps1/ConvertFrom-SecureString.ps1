function ConvertFrom-SecureString {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [System.Security.SecureString[]]
        $SecureString
    )
    process {

        $SecureString | ForEach-Object {

            try {
                [System.Runtime.InteropServices.Marshal]::PtrToStringUni([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($_))
            }
            catch{
                Write-Error -Exception $_.Exception
            }
            
        }

    }

}