function ConvertTo-Binary {
    <#
    .SYNOPSIS

    Converts input to binary.

    .DESCRIPTION
    
    Takes an input string and converts it to binary.

    .PARAMETER InputString

    This parameter is mandatory.
    The input will be parsed as a string.
    
    .EXAMPLE

    PS> 'hello world' -split ' ' | ConvertTo-Binary

    .INPUTS
       
    System.String

    .OUTPUTS
        
    System.String
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [AllowEmptyString()]
        [String]
        $InputString
    )
    process {

        try {
            [Byte]$InputString | Out-Null
            [Convert]::ToString($InputString, 2).PadLeft(8, '0')
        }
        catch {

            try {
                [Int16]$InputString | Out-Null
                [Convert]::ToString($InputString, 2).PadLeft(8, '0')
            }
            catch {

                try {
                    [Int32]$InputString | Out-Null
                    [Convert]::ToString($InputString, 2).PadLeft(8, '0')                    
                }
                catch {

                    try {
                        [Int64]$InputString | Out-Null
                        [Convert]::ToString($InputString, 2).PadLeft(8, '0')                    
                    }
                    catch {

                        try {
                            [Char]$InputString | Out-Null
                            [Convert]::ToString($InputString, 2).PadLeft(8, '0')
                        }
                        catch {

                            try {
                             
                                [byte[]][char[]]$InputString | ForEach-Object {
                                    [Convert]::ToString($_, 2).PadLeft(8, '0')
                                }

                            }
                            catch {
                                Write-Error -Exception $_.Exception
                            }

                        }

                    }

                }
                
            }
            
        }

    }

}