function ConvertTo-Base64 {

    <#
    .SYNOPSIS
    Converts a plaintext string into a Base64-encoded string.

    .EXAMPLE
    This example demonstrates the process of passing a plaintext string to the function in order to convert it to Base64 encoding.

    PS> ConvertTo-Base64 -String "Hello world."

    aGVsbG8gd29ybGQu

    .EXAMPLE
    This example demonstrates the process of passing the content of file out as a string and converting it to Base64 encoding.

    PS> Get-Content -Path 'C:\Windows\Temp\logfile.log' | Out-String | ConvertTo-Base64

    .EXAMPLE
    This example demonstrates the process of concatenating a PowerShell cmdlet to a string and converting that string to Base64 encoding.
    This will allow this encoded string to be run by PowerShell using the powershell.exe -EncodedCommand 

    PS> 'Get-ChildItem -Path "C:\Windows\Temp" | ConvertTo-Base64 -Encoding Unicode

    'RwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgAC0AUABhAHQAaAAgACIAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFQAZQBtAHAAIgA='

    PS> powershell.exe -EncodedCommmand 'RwBlAHQALQBDAGgAaQBsAGQASQB0AGUAbQAgAC0AUABhAHQAaAAgACIAQwA6AFwAVwBpAG4AZABvAHcAcwBcAFQAZQBtAHAAIgA='

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
        $String,

        [Parameter()]
        [ValidateSet('ASCII', 'BigEndianUnicode', 'Default', 'Unicode', 'UTF7', 'UTF8', 'UTF32')]
        [string]
        $Encoding = "Default"

    )
    process {

        try {
        
            [System.Convert]::ToBase64String([System.Text.Encoding]::$Encoding.GetBytes($String))
        
        } catch {

            $_ | Write-Error

        }

    }

}