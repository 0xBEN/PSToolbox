function Out-ReversedString {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString
    )
    process  {

        foreach ($string in $InputString) {
            
            try {
                -join[Regex]::Matches($string, '.', "RightToLeft")
            }
            catch{
                Write-Error -Exception $_.Exception
            }

        }

    }
}