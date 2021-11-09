function Split-Output {

    [CmdletBinding()]
    [Alias('cut', 'split')]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'May pass a character, string, or regular expression'
        )]
        [Alias('d')]
        [String]
        $Delimiter,

        [Parameter(
            Position = 2,
            HelpMessage = 'May choose an individual or range of items starting from the zero index'
        )]
        [Alias('f')]
        [Int[]]
        $OutputItems
    )
    process {

        $InputString | ForEach-Object {

            $string = $_
            if ($OutputItems) {
                
                try {
                    return $string -split $Delimiter | Select-Object -Index $OutputItems
                }
                catch {
                    throw $_.Exception    
                }

            } 
            else {

                try {
                    return $string -split $Delimiter
                }
                catch {
                    throw $_.Exception    
                }

            }

        }

    }

}