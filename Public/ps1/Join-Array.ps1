function Join-Array {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [PSObject[]]$InputArray,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [String]$JoinString = ','
    )
    begin {
        $tallyObjects = @()
    }
    process {
        $tallyObjects += $_
    }
    end {
    
        if ($tallyObjects.Count -lt 2) {
            throw "Cannot perform join operation on collection size smaller than 2"
        }
        else {
            $tallyObjects -join $JoinString
        }    
        
    }

}
