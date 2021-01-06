function Get-DotNetClassName {

    Param(

        [Parameter(ParameterSetName = "SearchString")]
        [ValidateNotNullOrEmpty()]
        [string]
        $SearchString

    )
    begin {
        
        $nameSpaces = [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes().Where({$_.IsPublic -eq $true}).FullName

    } 
    process {

        if ($SearchString) {  return $nameSpaces | Where-Object { $_ -like "*$SearchString*" } } 
        else { return $nameSpaces }

    }

}