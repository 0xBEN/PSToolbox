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
        [ValidateRange(1,1000)]
        [Int]$ParallelPorts = 100,

        [Parameter(Position = 4)]
        [ValidateRange(100,10000)]
        [Int]$TimeoutMilliseconds = 100
    )
    begin {

        $TargetHost = $TargetHost | Select-Object -Unique
        $Port = $Port | Select-Object -Unique
        #if ($ParallelPorts -gt $Port.Count) { $ParallelPorts = $Port.Count }
        #if ($ParallelPorts -gt $TargetHost.Count) { $ParallelHosts = $TargetHost.Count }
        
        $hostJobs = @()
        # ScriptBlock for processing hosts to scan
        $hostScriptBlock = {

            param (
                $scriptBlockTarget,
                $scriptBlockPorts,
                $scriptBlockTimeout,
                $numThreads
            )
            # Nested ScriptBlock as each host runspace will
            # Have child runspaces for scanning ports
            $portScriptBlock = {
                param (
                    $runspaceTarget,
                    $runspacePort,
                    $runspaceTimeout
                )

                $tcpClient = New-Object Net.Sockets.TcpClient
                try {
                    # Have to do it this way to support PowerShell Core TCP ConnectAsync method output
                    if ($tcpClient.ConnectAsync($runspaceTarget, $runspacePort).Wait($runspaceTimeout)) {
                        $state = 'Open'
                    }
                    else {
                        throw 'Connection failed'
                    }
                }
                catch {
                    $state = 'Closed'
                }

                $tcpClient.Close()
                $tcpClient.Dispose()

                return [PSCustomObject]@{
                    'Protocol' = 'TCP'
                    'Port' = $runspacePort
                    'State' = $state
                }
            }

            $hostObject = [PSCustomObject]@{
                'Host' = $scriptBlockTarget
                'Ports' = @()
            }

            # Slice the number of ports into smaller chunks based on the user thread input
            # That way if the user passes all 65,535 TCP ports, we aren't waiting for all of them to queue into the runspace pool
            for ($portIndex = 0; $portIndex -lt $scriptBlockPorts.Count; $portIndex += $numThreads) {
                # Nested runspace pool for port scanning
                $portRunspacePool = [runspacefactory]::CreateRunspacePool(1, $numThreads)
                $portRunspacePool.Open()
                $portJobs = @()
                $portStart = $portIndex
                $portEnd = ($portIndex + $numThreads) - 1
                # Take the first chunk of ports and queue them in the runspace pool
                $scriptBlockPorts[$portStart..$portEnd] | ForEach-Object {
                    $port = $_
                    $portPoshInstance = [powershell]::Create()
                    $portPoshInstance.RunspacePool = $portRunspacePool
                    $portPoshInstance.AddScript($portScriptBlock) | Out-Null
                    $portPoshInstance.AddArgument($scriptBlockTarget) | Out-Null
                    $portPoshInstance.AddArgument($port) | Out-Null
                    $portPoshInstance.AddArgument($scriptBlockTimeout) | Out-Null
                    $portJobs += $portPoshInstance
                }
                $portScanData = $portJobs.Invoke() # Run the jobs and store the data
                $hostObject.Ports += $portScanData # Add this batch of ports to the host object
                $portRunspacePool.Close() # Destroy the runspace to clean up garbage
            }
            return $hostObject
        }
        
    }
    process {

        # Chunk the number of hosts to run in parallel at a time
        # Each host starts a PowerShell job and each job has a nested runspace to process ports in parallel
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
