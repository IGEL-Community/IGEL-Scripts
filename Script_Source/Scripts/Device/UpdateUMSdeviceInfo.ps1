#Check for PSIGEL Module - Install if not present

#regionCheckForModule
Write-Output "Checking for PSIGEL Module"

Start-Sleep -Seconds 1

if(Get-Module -ListAvailable -Name PSIGEL)
    {write-Output "PSIGEL Module Exists, bypass installing module"}

    else{ Write-Output "Installing and Importing modules, you may be prompted to install PowerShell Get if not installed"
      Install-Module -Name PSIGEL -AllowClobber -Force
      Import-Module -Name PSIGEL

      Install-Module -Name POSH-SSH -AllowClobber -Force
      Import-Module -Name POSH-SSH
}

#endregionCheckForModule

#regionAuthentication

<#UMS Authentication - An account needs to be used that can authenticate to the UMS.  For repeatable scripts,
a PowerShell cmdlet can be used to store the account credentials and referenced via Import Clixml.
#>

#Uncomment to export credentials to .xml file.
#Get-Credential | Export-Clixml -Path "Enter your path"

#Create authentication to UMS, update credPath variable and '*-UMS*:Computername value of localhost

$credPath = "PATH_TO_psigelcreds"
$creds = $credPath


$PSDefaultParameterValues = @{
 '*-UMS*:Computername' = 'localhost'
}

$webSession = New-UMSAPICookie -Credential (Import-Clixml -Path $creds)
$PSDefaultParameterValues.Add('*-UMS*:WebSession', $webSession)

#endregionAuthentication

#Variables for Datasource

$csvPath = 'PATH_TO_CitrixDirector_AD_dataset.csv'
$csvData = Import-Csv -Path $csvPath

#Read csv file and update device fields

foreach($csv in $csvData) {
$device = Get-UMSDevice | Where-Object {$_.Unitid -eq $csv.igeldeviceid}

Update-UMSDevice -Id $device.Id -CostCenter $csv.costcenter  -Department $csv.department -Comment $csv.username

}
