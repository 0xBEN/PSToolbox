function Get-DnsRecord {

    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Domain
    )
    DynamicParam {
        # Create a dictionary to hold any dynamic parameters
        $parameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        # Dynamic Parameter 1: RecordType
        $moduleNameParameterName = 'RecordType'
        $moduleNameParameterAttributes = New-Object System.Management.Automation.ParameterAttribute # Instantiate empty parameter attributes object for definition below
        $moduleNameParameterAttributesCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]' # An array to hold any attributes assigned to this parameter
        $moduleNameParameterAttributes.Mandatory = $true # Parameter is mandatory
        $moduleNameParameterAttributes.Position = 0
        $moduleNameParameterAttributes.ParameterSetName = 'RecordType'
        $moduleNameParameterValidationSet = [Microsoft.DnsClient.Commands.RecordType]::GetNames([Microsoft.DnsClient.Commands.RecordType]) | Sort-Object # Use the .NET class to enumerate all available record types
        $moduleNameParameterValidationSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($moduleNameParameterValidationSet)
        $moduleNameParameterAttributesCollection.Add($moduleNameParameterAttributes)
        $moduleNameParameterAttributesCollection.Add($moduleNameParameterValidationSetAttribute)
        $createModuleNameParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($moduleNameParameterName, [String[]], $moduleNameParameterAttributesCollection)
        $parameterDictionary.Add($moduleNameParameterName, $createModuleNameParameter) # Add ModuleName to the parameter dictionary
        
        return $parameterDictionary
    }
    process {
        
        $Domain | ForEach-Object {

            $domainString = $_
            try {
                $nameServer = Resolve-DnsName -Name $domainString -Type NS -ErrorAction Stop
            }
            catch {
                Write-Error -Exception $_.Exception
                return
            }

            if ($PSCmdlet.ParameterSetName -eq 'RecordType') {
                $recordTypes = [Microsoft.DnsClient.Commands.RecordType].GetEnumNames() | Where-Object {$_ -in $PSBoundParameters['RecordType']} | Sort-Object
            }
            else {
                $recordTypes = [Microsoft.DnsClient.Commands.RecordType].GetEnumNames() | Sort-Object
            }
            $recordTypes | ForEach-Object {

                $type = $_
                try {
                    Resolve-DnsName -Name $domainString -Type $type -Server $nameServer[0..4].NameHost -ErrorAction Stop |
                    Where-Object {$_.Type -eq $type -and $_.QueryType -eq $type}
                }
                catch {
                    Out-Null # Silencing stderr
                }

            }

        }

    }

}