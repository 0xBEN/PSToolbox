function Undo-UrlEncoding {

    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $InputString
    )
    process {

        $InputString | ForEach-Object {

            $string = $_
            $uri = [System.Uri]$string
            if ($uri.Scheme) { # User passed a URI to decode

                $decode = ''
                $decode += $uri.Scheme + '://' + $uri.host + $uri.LocalPath
                $decode # Return the decoded URI

            }
            else { # User passed a string to decode

                $uri = [System.Uri]"http://fake.site/$string"
                $decode = $uri.LocalPath[1..($uri.LocalPath.Length - 1)] -join '' # Return just the original string decoded
                $decode

            }

        }

    }

}