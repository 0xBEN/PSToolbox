function Write-LogMessage {

     <#
        .SYNOPSIS
        Geneartes log lines in syslog compatible fomr,at
        
        .DESCRIPTION
        Takes inputs to create a valid syslog-formatted log line.
        Facility, Severity, Tag, and Message are all required parameters.

        .PARAMETER Facility
        https://en.wikipedia.org/wiki/Syslog#Facility
        Defaults to 13, which is a log audit message

        .PARAMETER Severity
        https://en.wikipedia.org/wiki/Syslog#Severity_level
        Defaults to 6, which is an informational log

        .PARAMETER Tag
        This is the name of the application being logged
        You could put PowerShell, a function name, a scipt name, etc
        
        .PARAMETER Message
        The actual log message describing the event
        
        .INPUTS
        System.Int
        System.String

        .OUTPUTS
        System.String

        .EXAMPLE
        PS> Write-LogMessage -Facility 13 -Severity 6 -Tag 'powershell' -Message 'The script Test-Script.ps1 has exited with a non-zero result.'
        
        .EXAMPLE
        PS> Out-LogMessage 13 6 'powershell' 'test log'
        Demonstrates the alias for the function, as well as positional arguments
    #>

    [CmdletBinding()]
    [Alias('Out-LogMessage')]
    param (	    
        [Parameter(Position = 0)]
        [ValidateRange(0,23)]
        [Int]$Facility = 13,
        
        [Parameter(Position = 1)]
        [ValidateRange(0,7)]
        [Int]$Severity = 6,
        
        [Parameter(
            Position = 2,
            Manadatory = $true,
            HelpMessage="The name of the application generating the log."
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Tag 
        
	    [Parameter(Position = 3, Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Message
    )
    begin {
        $priority = ($Facility * 8) + $Severity
        $timestamp = (Get-Date).ToUniversalTime().ToString('MMM dd HH:mm:ss')
        $computerName = $env:ComputerName
    }
    process {
        $logLine = "<$priority> $timestamp $computerName $Tag`: $Message"
    }
    end {
        if ($logLine) { return $logLine }
        else { return }
    }

}
