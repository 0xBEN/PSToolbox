function Remove-HtmlTags {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [String]
        $HtmlBody

    )
    process {

        $HtmlBody | ForEach-Object {

            $html = $_
            $parsedHtml = $html -split '>' -split '\<\/\w+' -replace '<.*', '' -split "`n" | # Remove any HTML artifacts and whitespace lines
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not [string]::IsNullOrEmpty($_) }
            return $parsedHtml

        }

    }

}