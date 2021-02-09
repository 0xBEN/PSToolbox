$publicFunctions = Get-ChildItem -Path "$PSScriptRoot\Public\ps1" | Where-Object {$_.Extension -eq '.ps1'}
$privateFunctions = Get-ChildItem -Path "$PSScriptRoot\Private\ps1" | Where-Object {$_.Extension -eq '.ps1'}
$publicFunctions | ForEach-Object { . $_.FullName }
$privateFunctions | ForEach-Object { . $_.FullName }

$aliases = @()
$publicFunctions | ForEach-Object { # Export all of the public functions from this module
    
    # The command has already been sourced in above. Query any defined aliases.
    $alias = Get-Alias -Definition (Get-Command $_.BaseName) -ErrorAction SilentlyContinue 
    if ($alias) { # If alias string found (see example above)
        $aliases += $alias
        Export-ModuleMember -Function $_.BaseName -Alias $alias
    }
    else {
        Export-ModuleMember -Function $_.BaseName        
    }

}

$moduleName = $PSScriptRoot.Split([System.IO.Path]::DirectorySeparatorChar)[-1]
$moduleManifest = "$PSScriptRoot\$moduleName.psd1"
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    $currentManifest = pwsh -NoProfile -Command "Test-ModuleManifest '$moduleManifest'" # Unfortunate hack to test the module manifest for changes without having to reload PowerShell
}
else {
    $currentManifest = powershell -NoProfile -Command "Test-ModuleManifest '$moduleManifest'" # Unfortunate hack to test the module manifest for changes without having to reload PowerShell
}
$functionsAdded = $publicFunctions | Where-Object {$_.BaseName -notin $currentManifest.ExportedFunctions.PSObject.Properties.Name}
$functionsRemoved = $currentManifest.ExportedFunctions.PSObject.Properties.Name | Where-Object {$_ -notin $publicFunctions.BaseName}
$aliasesAdded = $aliases | Where-Object {$_ -notin $currentManifest.ExportedAliases.PSObject.Properties.Name}
$aliasesRemoved = $currentManifest.ExportedAliases.PSObject.Properties.Name | Where-Object {$_ -notin $aliases}
if ($functionsAdded -or $functionsRemoved -or $aliasesAdded -or $aliasesRemoved) { 
    try {

        if ($aliasesAdded) {
            Update-ModuleManifest -Path $moduleManifest -FunctionsToExport $publicFunctions.BaseName -AliasesToExport $aliases -ErrorAction Stop
        }
        else {
            Update-ModuleManifest -Path $moduleManifest -FunctionsToExport $publicFunctions.BaseName -AliasesToExport @() -ErrorAction Stop
        }

    }
    catch {
        # Empty to silence errors
    }
}
