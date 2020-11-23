<#
.\GetDeviceInformation.ps1 -Computername '10.11.11.59' -SSHCredential (Import-Clixml -Path 'C:\Credentials\DeviceRoot.cred')
.\GetDeviceInformation.ps1 -Computername '10.11.11.59' -SSHCredential (Get-Credential)
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
  ComputerName   = $Computername
  Hostname       = Invoke-SSHCommandStream -Command 'hostname'
  Manufacturer   = Invoke-SSHCommandStream -Command 'dmidecode -s system-manufacturer'
  SerialNumber   = Invoke-SSHCommandStream -Command 'dmidecode -s system-serial-number'
  IPAddress      = Invoke-SSHCommandStream -Command "getmyip && echo"
  MacAddress     = Invoke-SSHCommandStream -Command "ethtool -P eth0 | sed 's/^Permanent address: //g'"
  UnitID         = Invoke-SSHCommandStream -Command 'get_unit_id && echo'
  SCEPClientCert = Invoke-SSHCommandStream -Command 'cat /wfs/scep_cerificates/cert0/client.cert'
  TcCertificate  = Invoke-SSHCommandStream -Command 'cat /wfs/client-certs/tc_ca.crt'
}
$Result

$null = $SSHSession | Remove-SSHSession