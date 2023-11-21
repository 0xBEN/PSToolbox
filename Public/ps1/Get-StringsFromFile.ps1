function Get-StringsFromFile {

    [CmdletBinding()]
    [Alias('strings')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({
            $userInput = $_
            try {
                $resolved = Resolve-Path $userInput -ErrorAction Stop
                $item = Get-Item $resolved
                $isFile = $item.GetType().Name -eq 'FileInfo'
                if (-not $isFile) { throw "$userInput is not a file."}
                else { return $true }
            }
            catch {
                throw $_
            }
        })]
        [String]$FilePath,

        [Parameter()]
        [Switch]$AsciiOnly
    )
    begin {
        
        # Form regex pattern based on runtime parameters
        # Bytes 0xA0 (160) to 0xFF (255) are printable characters in UTF-8
        # Bytes 0x20 (32) to 0x7E (126) are printable characters in the ASCII table
        # \r\n also includes any carriage return (CR) and line feed (LF)
        if ($AsciiOnly) { $regexPattern = '[\x20-\x7E\\r\n]' }
        else { $regexPattern = '[\x20-\x7E\xA0-\xFF\r\n]' }

    }
    process {

        # Get the full path to the file
        $file = Resolve-Path $FilePath
        $bytes = [System.IO.File]::ReadAllBytes($file.Path) -match $regexPattern
        [char[]]$chars = $bytes

    }
    end {

        return -join$chars

    }

}