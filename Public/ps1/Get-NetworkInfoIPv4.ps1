function Get-NetworkInfoIPv4 {
    <#
    .SYNOPSIS
        Calculates subnet information from CIDR notation.
    
    .DESCRIPTION
        Given one or more subnets in CIDR notation, outputs subnet range, subnet mask,
        usable IP range, gateway, and broadcast address. Optionally lists all IPs
        with their type classification (network/host/broadcast).
        Validates input against IPv4 RFC standards.
    
    .PARAMETER Subnet
        One or more subnets in CIDR notation (e.g., "192.168.1.0/24")
    
    .PARAMETER ListIPAddresses
        Switch to output all IP addresses with type classification instead of summary info
    
    .EXAMPLE
        Get-NetworkInfoIPv4 -CIDRBlock "192.168.1.0/24"
    
    .EXAMPLE
        Get-NetworkInfoIPv4 -CIDRBlock "10.0.0.0/28","172.16.0.0/22" -ListIPAddresses
    
    .EXAMPLE
        "192.168.1.0/24","10.0.0.0/16" | Get-NetworkInfoIPv4
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true)]
        [ValidateScript({
            if ($_ -notmatch '^(\d{1,3}\.){3}\d{1,3}/\d{1,2}$') {
                throw "Invalid CIDR notation format. Use format: x.x.x.x/yy"
            }
            $parts = $_ -split '/'
            $ip = $parts[0]
            $cidr = [int]$parts[1]
            if ($cidr -lt 0 -or $cidr -gt 32) {
                throw "CIDR prefix must be between 0 and 32"
            }
            $octets = $ip -split '\.'
            foreach ($octet in $octets) {
                $octetInt = [int]$octet
                if ($octetInt -lt 0 -or $octetInt -gt 255) {
                    throw "Invalid IP address. Each octet must be between 0 and 255"
                }
            }
            $firstOctet = [int]$octets[0]
            if ($firstOctet -ge 240) {
                throw "IP address is in Class E range (240.0.0.0/4) - Reserved"
            }
            return $true
        })]
        [string[]]$CIDRBlock,
        [Parameter(Mandatory=$false)]
        [Switch]$ListIPAddresses
    )
    
    begin {
        $allResults = @()
    }
    
    process {
        foreach ($block in $CIDRBlock) {
            $inputIP = $block.Split('/')[0]
            $cidr = $block.Split('/')[1]
            
            $octets = $inputIP -split '\.'
            $ipBinary = $octets | ForEach-Object { [Convert]::ToString([int]$_, 2).PadLeft(8, '0') }
            
            $maskBinary = ('1' * $cidr).PadRight(32, '0')
            $subnetMask = ""
            for ($i = 0; $i -lt 32; $i += 8) {
                if ($subnetMask) { $subnetMask += '.' }
                $subnetMask += [Convert]::ToInt32($maskBinary.Substring($i, 8), 2)
            }
            
            $wildcardBinary = $maskBinary -replace '0','x' -replace '1','0' -replace 'x','1'
            $wildcardMask = ""
            for ($i = 0; $i -lt 32; $i += 8) {
                if ($wildcardMask) { $wildcardMask += '.' }
                $wildcardMask += [Convert]::ToInt32($wildcardBinary.Substring($i, 8), 2)
            }
            
            $networkBinary = ""
            for ($i = 0; $i -lt 32; $i++) {
                $networkBinary += if ($i -lt $cidr) { $ipBinary[$i] } else { '0' }
            }
            $networkAddress = ""
            for ($i = 0; $i -lt 32; $i += 8) {
                if ($networkAddress) { $networkAddress += '.' }
                $networkAddress += [Convert]::ToInt32($networkBinary.Substring($i, 8), 2)
            }
            
            $broadcastBinary = ""
            for ($i = 0; $i -lt 32; $i++) {
                $broadcastBinary += if ($i -lt $cidr) { $networkBinary[$i] } else { '1' }
            }
            $broadcastAddress = ""
            for ($i = 0; $i -lt 32; $i += 8) {
                if ($broadcastAddress) { $broadcastAddress += '.' }
                $broadcastAddress += [Convert]::ToInt32($broadcastBinary.Substring($i, 8), 2)
            }
            
            $netOctets = $networkAddress -split '\.'
            $networkInt = ([int64]$netOctets[0] -shl 24) + ([int64]$netOctets[1] -shl 16) + ([int64]$netOctets[2] -shl 8) + [int64]$netOctets[3]
            $bcastOctets = $broadcastAddress -split '\.'
            $broadcastInt = ([int64]$bcastOctets[0] -shl 24) + ([int64]$bcastOctets[1] -shl 16) + ([int64]$bcastOctets[2] -shl 8) + [int64]$bcastOctets[3]
            $totalHosts = [Math]::Pow(2, (32 - $cidr)) - 1
            
            if ($cidr -eq 32) {
                $firstUsable = $networkAddress
                $lastUsable = $networkAddress
                $usableHosts = 1
                $hasBroadcast = $false
                $hasGateway = $false
            } elseif ($cidr -eq 31) {
                $firstUsable = $networkAddress
                $lastUsable = $broadcastAddress
                $usableHosts = 2
                $hasBroadcast = $false
                $hasGateway = $false
            } else {
                $firstInt = $networkInt + 1
                $lastInt = $broadcastInt - 1
                $firstUsable = "{0}.{1}.{2}.{3}" -f (($firstInt -shr 24) -band 0xFF), (($firstInt -shr 16) -band 0xFF), (($firstInt -shr 8) -band 0xFF), ($firstInt -band 0xFF)
                $lastUsable = "{0}.{1}.{2}.{3}" -f (($lastInt -shr 24) -band 0xFF), (($lastInt -shr 16) -band 0xFF), (($lastInt -shr 8) -band 0xFF), ($lastInt -band 0xFF)
                $gateway = $firstUsable
                $usableHosts = $totalHosts - 1
                $hasBroadcast = $true
                $hasGateway = $true
            }
            
            if ($ListIPAddresses) {
                if ($cidr -eq 32) {
                    $allResults += [PSCustomObject]@{
                        Subnet = $block
                        IPAddress = $networkAddress
                        Type = 'host'
                    }
                } elseif ($cidr -eq 31) {
                    $allResults += [PSCustomObject]@{
                        Subnet = $block
                        IPAddress = $networkAddress
                        Type = 'host'
                    }
                    $allResults += [PSCustomObject]@{
                        Subnet = $block
                        IPAddress = $broadcastAddress
                        Type = 'host'
                    }
                } else {
                    $currentInt = $networkInt
                    while ($currentInt -le $broadcastInt) {
                        $currentIP = "{0}.{1}.{2}.{3}" -f (($currentInt -shr 24) -band 0xFF), (($currentInt -shr 16) -band 0xFF), (($currentInt -shr 8) -band 0xFF), ($currentInt -band 0xFF)
                        $type = if ($currentInt -eq $networkInt) { 'network' } elseif ($currentInt -eq $broadcastInt) { 'broadcast' } else { 'host' }
                        $allResults += [PSCustomObject]@{
                            Subnet = $block
                            IPAddress = $currentIP
                            Type = $type
                        }
                        $currentInt++
                    }
                }
            } else {
                $outputHash = [ordered]@{
                    'Network Address' = "$networkAddress/$cidr"
                    'Subnet Mask' = $subnetMask
                    'Wildcard Mask' = $wildcardMask
                }
                if ($hasBroadcast) {
                    $outputHash['Broadcast Address'] = $broadcastAddress
                }
                $outputHash['First Usable IP'] = $firstUsable
                $outputHash['Last Usable IP'] = $lastUsable
                if ($hasGateway) {
                    $outputHash['Gateway'] = $gateway
                }
                $outputHash['Total IP Addresses'] = $totalHosts
                $outputHash['Usable IP Addresses'] = $usableHosts
                $allResults += [PSCustomObject]$outputHash
            }
        }
    }
    
    end {
        if ($allResults.Count -gt 0) {
            return $allResults
        }
    }
}
