function Test-ICMP {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [string[]]$ComputerName,

        [ValidateRange(1,50)]
        [int]$ParallelPings = 10
    )

    begin {
        if ($PSVersionTable.OS -like "*Windows*") { $hostOS = "Windows" }
        elseif ($PSVersionTable.Platform -eq "Unix") { $hostOS = "Linux" }
        else { $hostOS = "Windows" }

        Add-Type -AssemblyName System.Management.Automation

        $pool = [runspacefactory]::CreateRunspacePool(1, $ParallelPings)
        $pool.Open()

        $runspaceJobs = @()
    }
    process {

        foreach ($target in $ComputerName) {

            try { 
                [IPAddress]$_ | Out-Null
            }
            catch {
                try { 

                    if ($hostOS -eq 'Windows') {
                        Resolve-DnsName $_ -DnsOnly -ErrorAction Stop | Out-Null 
                    }
                    else {
                        $lookup = /bin/bash -c "host $target"
                        if ($lookup -like '*NXDOMAIN*') {
                            throw "NXDOMAIN"
                        }
                    }
                }
                catch { 
                    Write-Error "$_ is neither a valid IP nor valid hostname." 
                    return
                }
            }

            $ps = [powershell]::Create()
            $ps.RunspacePool = $pool

            $null = $ps.AddScript({
                param($target, $os)

                $result = [PSCustomObject]@{
                    Host = $target
                    PingSucceeded = $false
                }

                if ($os -eq "Windows") {

                    # .NET ICMP – reliable inside runspaces
                    $ping = New-Object System.Net.NetworkInformation.Ping
                    try {
                        $reply = $ping.Send($target, 1000)  # 1 second timeout
                        if ($reply.Status -eq "Success") {
                            $result.PingSucceeded = $true
                        }
                    }
                    catch {
                        $result.PingSucceeded = $false
                    }
                }
                else {
                    # Linux
                    $output = timeout 1 ping -c 1 $target 2>$null
                    if ($output -match "bytes from") {
                        $result.PingSucceeded = $true
                    }
                }

                return $result

            }).AddArgument($target).AddArgument($hostOS)

            $runspaceJobs += [PSCustomObject]@{
                Pipe   = $ps
                Handle = $ps.BeginInvoke()
            }
        }

    }
    end {

        foreach ($job in $runspaceJobs) {
            $output = $job.Pipe.EndInvoke($job.Handle)
            $job.Pipe.Dispose()
            $output
        }

        $pool.Close()
        $pool.Dispose()

    }
}
