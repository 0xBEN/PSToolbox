function ConvertFrom-Base64 {

    <#
    .SYNOPSIS
    Converts a Base64-encoded string into a plaintext string.

    .EXAMPLE
    This example demonstrates the process of passing a Base64-encoded string to the function in order to convert it to a plaintext string.

    PS> ConvertFrom-Base64 -Base64String "aGVsbG8gd29ybGQu"

    Hello world.

    .EXAMPLE
    This example demonstrates the process of passing the content of file out as a string and converting it to Base64 encoding.

    PS> Get-Content -Path 'C:\Windows\Temp\logfile.log' | Out-String | ConvertTo-Base64

    .EXAMPLE
    This example demonstrates the process of concatenating a PowerShell cmdlet to a string and converting that string to Base64 encoding.
    This will allow this encoded string to be run by PowerShell using the powershell.exe -EncodedCommand 

    PS> 'RwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgAC0AUABhAHQAaAAgACIAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFQAZQBtAHAAIgA=' | ConvertFrom-Base64 -Encoding Unicode

    Get-ChildItem -Path "C:\Windows\Temp"

    .INPUTS
    System.String

    .OUTPUTS
    System.String
    #>
    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $Base64String,

        [Parameter()]
        [ValidateSet('ASCII', 'BigEndianUnicode', 'Default', 'Unicode', 'UTF7', 'UTF8', 'UTF32')]
        [string]
        $Encoding = 'Default'

    )
    process {

        try {

            [System.Text.Encoding]::$Encoding.GetString([System.Convert]::FromBase64String($Base64String))

        } catch {

            $_ | Write-Error

        }

    }

}