function Out-ParameterSplattingTemplate {

    [CmdletBinding(DefaultParameterSetName = 'Command')]
    param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'Command',
            HelpMessage = 'Enter a command name from your environment.'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$CommandName,

        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ParameterSetName = 'Script',
            HelpMessage = 'Enter a path to a parameterized script file.'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ScriptFile
    )
    begin {

        if ($PSCmdlet.ParameterSetName -eq 'Command') {
            $command = $CommandName
        }
        else {
            $command = $ScriptFile
        }

        [String[]]$exlcudedParameterNames = [System.Management.Automation.PSCmdlet]::CommonParameters
        $exlcudedParameterNames += [System.Management.Automation.PSCmdlet]::OptionalCommonParameters

        try {
            $parameterNames = (Get-Command $command -ErrorAction Stop).Parameters.Keys | Where-Object { $_ -notin $exlcudedParameterNames }
            if (-not $parameterNames) {
                throw "This command does not appear to have any parameters."
            }
        }
        catch{
            throw $_.Exception
        }

    }
    process {

        [String[]]$template = "@{`n"
        $parameterNames | ForEach-Object {
            $name = $_
            $template += "    $name`n"
        }
        $template += '}'

    }
    end {

        if ($template) { return $template }
        else { return }

    }
    
}