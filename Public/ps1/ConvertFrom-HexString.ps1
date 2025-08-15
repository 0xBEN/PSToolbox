function ConvertFrom-HexString {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$HexString
  )
  begin {
    $ErrorActionPreference = 'Stop'
  }
  process {
    foreach ($string in $HexString) {
      # Some hex strings are formatted with a 0x prefix
      # Strip this prefix and leave only hexadecimal bytes
      Write-Verbose "Parsing string: $string"
      try {
        [byte[]]$byteArray = @()
        $string = $string -replace '^0x' -replace '^\\x'
        for ($index = 0; $index -lt $string.length; $index += 2) {
          $byteArray += '0x' + $string.Substring($index, 2)
        }
        -join[char[]]$byteArray
      }
      catch {
        $exception = $_
        Write-Error "Error while parsing HexString ($string)`n$exception"
      }
    }
  }
  end {
  }
}
