function Convert-NmapXmlToObject {

    [CmdletBinding()]
    Param (

        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Xml]
        $NmapXml

    )
    process {

        $nmapHostProperties = $NmapXml.nmaprun.host | Get-Member -MemberType Property | Select-Object -ExpandProperty Name
        $nmapHostObjects = $NmapXml.nmaprun.host | ForEach-Object {

            $thisHost = $_
            $nmapHostObject = New-Object PSObject
            $nmapHostProperties | ForEach-Object {
                
                $propertyName = $_
                $nmapHostObject | Add-Member -MemberType NoteProperty -Name $propertyName -Value $thisHost.$propertyName -ErrorAction SilentlyContinue

            }
            $nmapHostObject

        }

    }
    end {

        if ($nmapHostObjects) {

            if ($nmapHostObjects.Count -gt 1) {

                return $nmapHostObjects.GetEnumerator()

            }
            else {

                return $nmapHostObjects

            }

        }
        else {

            throw "Unable to form any objects from the provided XML input."

        }

    }

}