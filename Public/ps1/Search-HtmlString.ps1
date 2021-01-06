function Search-HtmlString {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [String]
        $HtmlBody,

        [Parameter (
            ParameterSetName = 'regex',
            Mandatory = $true,
            Position = 1
        )]
        [Regex]
        $RegexPattern,

        [Parameter(
            ParameterSetName = 'likeness',
            Mandatory = $true,
            Position = 1
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $SearchString,

        [Parameter(
            ParameterSetName = 'exact',
            Mandatory = $true,
            Position = 1
        )]
        [ValidateNotNullOrEmpty()]
        [String]
        $ExactMatch

    )
    process{

        $HtmlBody | ForEach-Object {

            $html = $_
            $parsedHtml = $html -split '>' -split '\<\/\w+' -replace '<.*', '' -split "`n" | # Remove any HTML artifacts and whitespace lines
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not [string]::IsNullOrEmpty($_) }

            switch ($PSCmdlet.ParameterSetName) {

                regex {

                   return $parsedHtml -match $RegexPattern
    
                }
                likeness {
                    
                   return $parsedHtml -like "*$SearchString*"
                    
                }
                exact {
                    
                    return $parsedHtml -like $ExactMatch
                    
                }
    
            }

        }

    }

}