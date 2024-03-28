function ConvertTo-Unicode {

  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$InputString
  )

  begin {}
  process {
    
    $InputString | ForEach-Object {
      $string = $_
      $charArray = $string.ToCharArray()
      foreach ($char in $charArray) {
        '\u{0:x4}' -f [byte][char]$char
      }
      
    }
    
  }
  end {}

}
