function Test-TcpPort {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = 'Enter an IP address, hostname, or FQDN.'
        )]
        [String[]]$TargetHost,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'Enter a TCP port between 1 and 65535. It may be a single port, comma separated, or a range; or a combination.'
        )]
        [ValidateRange(1,65535)]
        [Int[]]$Port,

        [Parameter(Position = 2)]
        [ValidateRange(1,10)]
        [Int]$ParallelHosts = 5,

        [Parameter(Position = 3)]
        [ValidateRange(1,10000)]
        [Int]$ParallelPorts = 100,

        [Parameter(Position = 4)]
        [ValidateRange(100,10000)]
        [Int]$TimeoutMilliseconds = 100
    )
     begin {

        if ($ParallelPorts -gt $Port.Count) { $ParallelPorts = $Port.Count }
        if ($ParallelPorts -gt $TargetHost.Count) { $ParallelHosts = $TargetHost.Count }
        
        $hostJobs = @()
        $hostScriptBlock = {

            param (
                $thisTarget,
                $ports,
                $timeout,
                $numThreads
            )

            $nestedPortScriptBlock = {
                param (
                    $nestedTarget,
                    $port,
                    $nestedTimeout
                )

                $tcpClient = New-Object Net.Sockets.TcpClient
                if ($tcpClient.ConnectAsync($nestedTarget, $port).Wait($nestedTimeout)) {
                    $state = 'Open'
                }
                else {
                    $state = 'Closed'
                }

                $tcpClient.Close()
                $tcpClient.Dispose()

                return [PSCustomObject]@{
                    'Protocol' = 'TCP'
                    'Port' = $port
                    'State' = $state
                }
            }

            $result = [PSCustomObject]@{
                'Host' = $thisTarget
                'Ports' = @()
            }
            
            for ($portIndex = 0; $portIndex -lt $ports.Count; $portIndex += $numThreads) {
                $counter = 0
                $portJobs = @()
                $portStart = $portIndex
                $portEnd = ($portIndex + $numThreads) - 1

                $ports[$portStart..$portEnd] | ForEach-Object {
                    $port = $_
                    $portJobParameters = @{
                        ScriptBlock = $nestedPortScriptBlock
                        ArgumentList = @($thisTarget, $port, $timeout)
                    }
                    $portJobs += Start-Job @portJobParameters
                }
                
                $portResults = $portJobs | 
                    Wait-Job | 
                    Receive-Job | 
                    Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunspaceId
                    
                $result.Ports += $portResults
            }
            return $result
        }
        
    }
    process {

        for ($hostIndex = 0; $hostIndex -lt $TargetHost.Count; $hostIndex += $ParallelHosts) {
            $hostStart = $hostIndex
            $hostEnd = ($hostIndex + $ParallelHosts) - 1

            $TargetHost[$hostStart..$hostEnd] | ForEach-Object {
                $target = $_
                Write-Verbose "Starting scan of host: $target"
                $hostJobParameters = @{
                    Name = $target
                    ScriptBlock = $hostScriptBlock
                    ArgumentList = @($target, $Port, $TimeoutMilliseconds, $ParallelPorts)
                }
                $hostJobs += Start-Job @hostJobParameters
            }
            $hostJobs | Wait-Job | Out-Null
        }

    }
    end {
        $hostJobs | Receive-Job | Select-Object -Property * -ExcludeProperty RunspaceId
        $hostJobs | Remove-Job -Force
    }
}
