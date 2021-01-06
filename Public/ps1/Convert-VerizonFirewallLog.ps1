function Convert-VerizonFirewallLog {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateScript({Test-Path $_})]
        [ValidateNotNullOrEmpty()]
        [String]
        $LogFilePath

    )
    begin {

        class LogObject {

            [DateTime]$LogDate
            [String]$LogEntry
            [String]$Action
            [String]$InboundInterface
            [String]$OutboundInterface
            [String]$SourceMacAddress
            [IPAddress]$SourceIPAddress
            [IPAddress]$DestinationIPAddress
            [Int32]$ContentLength
            [String]$TypeOfService
            [String]$Precedence
            [Int32]$TTL
            [Int32]$ID
            [String]$Protocol
            [Int32]$SourcePort
            [Int32]$DestinationPort
            [Int64]$TcpSequence
            [Int64]$ACK
            [Int32]$Window
            [String]$Flag
            [Int]$IsUrgent
            [Int]$Mark

        }

    }
    process {

        $LogFilePath | ForEach-Object {

            $logContent = Get-Content $LogFilePath
            $logContent | ForEach-Object {
                
                $logObject = New-Object LogObject
                $logEntry = $_
                # Filter any data that is strictly informational, remove unwanted characters
                $logInformation = ($logEntry -split ' ' | Where-Object { $_ -notlike '*=*' -and -not [string]::IsNullOrEmpty($_) }) -replace ']:', ']'
                # Filter any actual packet data, remove unwanted characters
                $logData = ($logEntry -split ' ' | Where-Object { $_ -like '*=*' }) -replace '.*=', ''

                $month = $logInformation[0]
                $day = $logInformation[1]
                $timeOfDay = $logInformation[2]
                $year = $logInformation[3]
                $logDate = "$month $day, $year $timeOfDay" # Form a valid date time string, since the original value is not compatible

                $logObject.LogDate = $logDate
                $logObject.LogEntry = $logInformation[4] + ' ' + $logInformation[5]
                $logObject.Action = $logInformation[6]
                $logObject.Flag = $logInformation[8..$logInformation.Length]
                $logObject.InboundInterface = $logData[0]
                $logObject.OutboundInterface = $logData[1]
                $logObject.SourceMacAddress = $logData[2]
                $logObject.SourceIpAddress = $logData[3]
                $logObject.DestinationIPAddress = $logData[4]
                $logObject.ContentLength = $logData[5]
                $logObject.TypeOfService = $logData[6]
                $logObject.Precedence = $logData[7]
                $logObject.TTL = $logData[8]
                $logObject.ID = $logData[9]
                $logObject.Protocol = $logData[10]
                $logObject.SourcePort = $logData[11]
                $logObject.DestinationPort = $logData[12]
                $logObject.TcpSequence = $logData[13]
                $logObject.ACK = $logData[14]
                $logObject.Window = $logData[15]
                $logObject.IsUrgent = $logObject[16]
                $logObject.Mark = $logData[17]

                return $logObject

            }

        }

    }

}