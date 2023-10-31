function Get-SecurityTrailsSubdomains {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, HelpMessage = "Example: contoso.org")]
    [String[]]
    $BaseDomain,

    [Parameter(Mandatory = $true, Position = 1)]
    [String]
    $ApiKey
  )

  begin {
    $baseUri = 'https://api.securitytrails.com/v1/domain/'
    $endpoint = '/subdomains'
    $headers = @{'APIKEY' = $ApiKey}
  }
  process {
  
    $BaseDomain | ForEach-Object {

      try {
        $uri = $baseUri + $_ + $endpoint
        Invoke-RestMethod -Method Get -Headers $headers -Uri $uri
      }
      catch {
        $_ | Write-Error
      }
      
    }
    
  }
  end {}
}
