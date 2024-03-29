function ConvertFrom-Unicode {

  [CmdletBinding()]
  Param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [String[]]$InputString
  )

  begin {}
  process {
    
    $Inputstring | ForEach-Object {
      
      $unicodeString = $_
      $splitString = $unicodeString.Split('\') | Where-Object { -not [String]::IsNullOrEmpty($_) }
      foreach ($unicodeSeq in $splitString) {
        $unicodeSeq.Split('u')[1] -replace '00','0x' -as [byte] -as [char]
      }
      
    }
    
  }
  end {}

}
