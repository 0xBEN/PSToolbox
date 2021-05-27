function Get-WhoIsInfo {
    
    [CmdletBinding()]
    Param (
        [Parameter(
            Position= 0,
            Mandatory = $true
        )]
        [ValidateScript({[IPAddress]::Parse($_)})]
        [String[]]
        $IPAddress
    )
    $uri = 'https://who.is/whois-ip/ip-address/'
    $r = Invoke-WebRequest ($uri + $IPAddress) -UseBasicParsing
    $r = $r.Content -split '>' -replace '<.*' | 
        Select-String -Pattern "^\w+\:.*" | 
        ForEach-Object { $_ -replace '\:\s{1,}', '::' }
    $r = $r.Split("`n") | Where-Object { -not [string]::IsNullOrWhiteSpace($_) -and -not [string]::IsNullOrEmpty($_) }
    $object = New-Object PSObject
    $addressLineCount = 0
    $networkCommentLineCount = 0
    $orgCommentLineCount = 0
    $r | ForEach-Object {
        $split = $_ -split '::'
        $key = $split[0]
        $value = $split[-1]
        if ($key -eq 'NetRange') { $monitor = 'Network' }
        if ($key -eq 'OrgName') { $monitor = 'Organization' }
        if ($monitor -eq 'Network') {
            if ($key -eq 'RegDate') { $key = 'NetRegDate' }
            if ($key -eq 'Updated') { $key = 'NetRegUpdated' }
            if ($key -eq 'Ref') {$key = 'NetRef'}
            if ($key -eq 'Comment') {
                if ($networkCommentLineCount -gt 0) {
                    $key = "NetCommentContinued$networkCommentLineCount"
                }
                else {
                    $key = 'NetComment'
                }
                $networkCommentLineCount++
            }
        }
        if ($monitor -eq 'Organization') {
            if ($key -eq 'Address') {
                if ($addressLineCount -gt 0) {
                    $key = "OrgAddressContinued$addressLineCount"
                }
                else {
                    $key = 'OrgAddress'
                }
                $addressLineCount++
            }
            if ($key -eq 'Comment') {
                if ($networkCommentLineCount -gt 0) {
                    $key = "OrgCommentContinued$orgCommentLineCount"
                }
                else {
                    $key = 'OrgComment'
                }
                $orgCommentLineCount++
            }
            if ($key -eq 'RegDate') { $key = 'OrgRegDate' }
            if ($key -eq 'Updated') { $key = 'OrgRegUpdated' }
            if ($key -eq 'Ref') { $key = 'OrgRef' }
        }
        $object | Add-Member -MemberType NoteProperty -Name $key -Value $value
    }
    $object

}