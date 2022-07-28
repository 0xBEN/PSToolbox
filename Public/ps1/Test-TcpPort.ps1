function Test-TcpPort {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            HelpMessage = 'Enter an IP address, hostname, or FQDN.'
        )]
        [String[]]
        $TargetHost,

        [Parameter(
            Mandatory = $true,
            Position = 1,
            HelpMessage = 'Enter a TCP port between 1 and 65535. It may be a single port, comma separated, or a range; or a combination.'
        )]
        [ValidateRange(1,65535)]
        [Int[]]
        $Port,

        [Parameter(Position = 2)]
        [ValidateRange(1,100)]
        [Int]
        $Threads = 10,

        [Parameter(Position = 3)]
        [ValidateRange(100,10000)]
        [Int]
        $TimeOutMilliseconds = 1000
    )
    begin {

        $jobs = @()
        $scriptBlock = {

            $target = $args[0]
            $ports = $args[1]
            $timeout = $args[2]

            $result = [PSCustomObject]@{
                'Target' = $target
                'Ports' = @()
            }

            $ports | ForEach-Object {

                $port = $_            
                $tcpClient = New-Object Net.Sockets.TcpClient
                if ($tcpClient.ConnectAsync($target, $port).Wait($timeout)) {
                    $state = 'Open'
                }
                else {
                    $state = 'Closed'
                }

                $result.Ports += [PSCustomObject]@{
                    'Protocol' = 'TCP'
                    'Port' = $port
                    'State' = $state
                }

                $tcpClient.Close()
                $tcpClient.Dispose()

            }
            return $result

        }

    }
    process {

        for ($i = 0; $i -le $TargetHost.Count; $i += $Threads) {
            
            $start = $i
            $end = ($i + $Threads) - 1
            $TargetHost[$start..$end] | ForEach-Object {
                $target = $_
                Write-Verbose "Processing host: $target"
                $jobs += Start-Job -Name $target -ScriptBlock $scriptBlock -ArgumentList $target, $Port, $TimeOutMilliseconds
            }
            $jobs | Wait-Job | Out-Null

        }

    }
    end {

        $jobs | Receive-Job | Select-Object -Property * -ExcludeProperty PSComputerName, PSShowComputerName, RunspaceId
        $jobs | Remove-Job -Force

    }
    
}