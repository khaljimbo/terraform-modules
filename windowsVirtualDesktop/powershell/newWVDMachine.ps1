function new-WVDMachine {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $AADTenantID,

        [Parameter(Mandatory = $true)]
        [string]
        $HostPoolName,

        [Parameter(Mandatory = $true)]
        [string]
        $AppGroupName,

        [Parameter(Mandatory = $true)]
        [string]
        $AppID,

        [Parameter(Mandatory = $true)]
        [securestring]
        $Password,
        
        [Parameter(Mandatory = $true)]
        [string]
        $TokenPath, 

        [Paremeter(Mandatory = $true)]
        [string]
        $ExpirantionHours
    )
    
    begin {

        Write-Host "Checking if WVD Management Module is installed"
        if (!(Get-Module -Name "Microsoft.RDInfra.RDPowerShell")) {
            Write-Host "WVD Management Module is not installed. Proceeding to install" {
                Install-Module Microsoft.RDInfra.RDPowerShell
            }            
        }

        # Gets the credentials of the service principal
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AppID, $Password

        # Logs into the RDS Account with the service principal details supplied above
        Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -ServicePrincipal -AadTenantId $AADTenantID

        # Creates a token to be able to add a VM to the WVD RDS Pool
        New-RdsRegistrationInfo -TenantName $AADTenantID -HostPoolName $HostPoolName -ExpirationHours $ExpirantionHours | Select-Object -ExpandProperty Token | Out-File -FilePath $TokenPath

        # Export the Token to join the VM to WVD RDS
        $token = (Export-RdsRegistrationInfo -TenantName $AADTenantID -HostPoolName $HostPoolName).Token
    }
    
    process {
        wget "https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv"
    }
    end {
        
    }
}

