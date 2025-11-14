function Test-TcpPort {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [String[]]$TargetHost,

        [Parameter(Mandatory = $true, Position = 1)]
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
        $Port       = $Port | Select-Object -Unique

        # Create a single runspace pool for all work
        $maxThreads = [Math]::Min(($ParallelHosts * $ParallelPorts), 2000) # cap threads
        $runspacePool = [runspacefactory]::CreateRunspacePool(1, $maxThreads)
        $runspacePool.Open()

        $jobs = @()

        # ScriptBlock for scanning one port
        $scanScriptBlock = {
            param($target, $port, $timeout)

            $tcpClient = New-Object Net.Sockets.TcpClient
            try {
                if ($tcpClient.ConnectAsync($target, $port).Wait($timeout)) {
                    $state = 'Open'
                } else {
                    throw 'Connection failed'
                }
            } catch {
                $state = 'Closed'
            } finally {
                $tcpClient.Close()
                $tcpClient.Dispose()
            }

            [PSCustomObject]@{
                Host     = $target
                Protocol = 'TCP'
                Port     = $port
                State    = $state
            }
        }
    }

    process {
        foreach ($target in $TargetHost) {
            Write-Verbose "Queueing scan for host: $target"
            foreach ($p in $Port) {
                $ps = [powershell]::Create().AddScript($scanScriptBlock).AddArgument($target).AddArgument($p).AddArgument($TimeoutMilliseconds)
                $ps.RunspacePool = $runspacePool
                $handle = $ps.BeginInvoke()
                $jobs += [PSCustomObject]@{
                    PowerShell = $ps
                    Handle     = $handle
                }
            }
        }
    }

    end {
        $results = foreach ($job in $jobs) {
            $job.Handle.AsyncWaitHandle.WaitOne() | Out-Null
            $output = $job.PowerShell.EndInvoke($job.Handle)
            $job.PowerShell.Dispose()
            $output
        }

        $runspacePool.Close()
        $runspacePool.Dispose()

        $results | Sort-Object Host, Port
    }
}
