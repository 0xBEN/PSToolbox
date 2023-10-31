function Get-SecurityTrailsApiQuota {

  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true, Position = 0)]
    [String]
    $ApiKey
  )
  begin {
    $headers = @{'APIKEY' = $ApiKey}
  }
  process {

    try {
      Invoke-RestMethod -Method Get -Headers $headers -Uri 'https://api.securitytrails.com/v1/account/usage'
    }
    catch {
      $_ | Write-Error
    }

  }
  end {}
    
}
