function Set-SSHPrivateKeyAcl {

    [CmdletBinding()]
    [Alias('setprivkeyacl')]
    Param (
        [Parameter(
            Mandatory = $true, 
            ValueFromPipeline = $true
        )]
        [ValidateScript({
            if (-not (Test-Path $_)) { throw "Invalid Path: $_"}
            else { return $true }
        })]
        [String[]]
        $KeyFilePath
    )

    process {

        foreach ($file in $KeyFilePath) {

            $acl = Get-Acl $file

            $identity = whoami
            $rights = 'FullControl'
            $type = 'Allow'

            # Create an access rule with the current user getting full access
            $accessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $identity, $rights, $type
            # Add the rule to the object
            $acl.SetAccessRule($accessRule)
            # Apply the changes
            Set-Acl $file $acl

            $acl = Get-Acl $file            
            # Protect the file from inheritance
            $isProtected = $true
            # Remove existing inherited rules
            $preserveInheritance = $false
            # Strip inheritance
            $acl.SetAccessRuleProtection($isProtected, $preserveInheritance)
            # Apply changes
            Set-Acl $file $acl

            $acl = Get-Acl $file
            # Remove any remaining access rules
            $acl.Access | 
            Where-Object {$_.IdentityReference -ne $(whoami)} |
            ForEach-Object { $acl.RemoveAccessRule($_)}
            # Apply changes 
            Set-Acl $file $acl

        }

    }

}