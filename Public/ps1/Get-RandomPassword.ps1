function Get-RandomPassword {

    <#
    .SYNOPSIS

    Generates a random password string of variable length.

    .DESCRIPTION
    
    Generates a random password string between 8 - 32 characters long.
    Can specify whether or not to use special characters in the string.

    .PARAMETER Length

    This parameter is mandatory.
    Takes an integer between 8 - 32 to determine the string length.

    .PARAMETER NoSpecialCharacters

    If switched on, will only return a string of uppercase, lowercase, and number characters
            
    .EXAMPLE

    PS>Get-RandomPassword -Length 15

    !XkTd7wG9P5XJL#

    .EXAMPLE

    PS>Get-RandomPassword -Length 15 -NoSpecialCharacters

    GO8pUoppUUCLhY5

    .INPUTS
       
    System.Int

    .OUTPUTS
        
    System.String
    #>

    [CmdletBinding()]
    [alias("password", "grpw")]
    Param (

        [Parameter(Mandatory = $true)]
        [ValidateRange(8,32)]
        [int]
        $Length,

        [switch]
        $NoSpecialCharacters

    )
    begin {

        $lowerLetters = 97..122 | ForEach-Object { [char][byte]$_ -as [string] }
        $allCharacterSets = @{
            'LowercaseLetters' = $lowerLetters
            'UppercaseLetters' = $lowerLetters | ForEach-Object { $_.ToUpper() }
            'Numbers' = 0..9 | ForEach-Object { $_.ToString() }
            'SpecialCharacters' = ('!', '@', '#', '$', '%', '^', '&', '*')
        }
        if ($NoSpecialCharacters) { $allCharacterSets.Remove('SpecialCharacters') }

    }
    process {

            do {
            
                $password = @()
                while ($password.Length -ne $Length) {
                    do { $char = $allCharacterSets.Values | Get-Random } until ($char -cne $password[-1]) # Don't want the same char back to back
                    $password += $char
                }

                # Loop over the key names and use those to index into the hashtable
                # Verify that there are at least two characters from each character set in the password
                $verified = 0
                $allCharacterSets.Keys | ForEach-Object {
                    $key = $_
                    $charsInSet = $password | Where-Object {$_ -cin $allCharacterSets[$key]}
                    if ($charsInSet.Count -ge 2) { $verified++ }
                }
            
            } until ($verified -eq $allCharacterSets.Keys.Count) 

    }
    end {

        return -join$password
        
    }

}
