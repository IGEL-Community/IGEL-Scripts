<#
.\NewDeviceSCEPCert.ps1 -Computername '10.11.11.59' -SSHCredential (Import-Clixml -Path 'C:\Credentials\DeviceRoot.cred')
.\NewDeviceSCEPCert.ps1 -Computername '10.11.11.59' -SSHCredential (Get-Credential)
#>

param (
  [Parameter(Mandatory)]
  [String]
  $Computername,

  [Parameter(Mandatory)]
  [PSCredential]
  $SSHCredential
)

if (!@(Get-Module -ListAvailable -Name Posh-SSH))
{
  Install-Module -Name Posh-SSH
}
else
{
  Import-Module -Name Posh-SSH -Force
}

$SSHSessionParams = @{
  ComputerName = $Computername
  Credential   = $SSHCredential
  AcceptKey    = $treu
  ErrorAction  = 'SilentlyContinue'
}
$SSHSession = New-SSHSession @SSHSessionParams

$PSDefaultParameterValues = @{
  'Invoke-SSH*:SShSession' = $SSHSession
}

<#todo

check group.ini for scep url in profile

#>

$Prepare = @"
cd /wfs/scep_cerificates/cert0
scep_getca 0
scep_mkrequest 0
scep_enroll 0
"@

$Null = ($Prepare -split "`n").ForEach{
  Invoke-SSHCommandStream -Command $_
}

$Result = [pscustomobject]@{
  Hostname       = Invoke-SSHCommandStream -Command 'hostname'
  SCEPClientCert = Invoke-SSHCommandStream -Command 'cat /wfs/scep_cerificates/cert0/client.cert'
}
$Result

$null = $SSHSession | Remove-SSHSession