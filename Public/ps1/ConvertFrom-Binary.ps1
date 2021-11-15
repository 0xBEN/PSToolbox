function ConvertFrom-Binary {
    <#
    .SYNOPSIS

    Converts binary to decimal.

    .DESCRIPTION
    
    Takes base 2 input, parses it, and converts it to decimal.

    .PARAMETER InputString

    This parameter is mandatory.
    Takes a string in binary notation.
    For example, 00110110
            
    .EXAMPLE

    PS> [char[]]('01101000 01100101 01101100 01101100 01101111' -split ' ' | ConvertFrom-Binary)

    .INPUTS
       
    System.String

    .OUTPUTS
        
    System.Int
    #>
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $InputString
    )
    process {

        # Try to be conservative with memory use during conversion
        # Where using the smallest unit possible to convert back
        # Finally, throw an error once all options exhausted
        try {
            [Convert]::ToByte($InputString, 2)
        }
        catch {
            
            try {
                [Convert]::ToInt16($InputString, 2)
            }
            catch {
                
                try {
                    [Convert]::ToInt32($InputString, 2)
                }
                catch {
                    
                    try {
                        [Convert]::ToInt64($InputString, 2)
                    }
                    catch {
                        Write-Error -Exception $_.Exception
                    }

                }

            }

        }

    }

}