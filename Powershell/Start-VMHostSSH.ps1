Param(
    [String]$VMHost,
    [String]$username,
    [String]$password
)

Function Connect-VMHost {
    param(
        [String]$VMHost,
        [String]$username,
        [String]$password
    )

    try {
        $session = connect-viserver -Server $VMHost -User $username -Password $password
    }
    catch {
        throw $error[0]
    }
    $session
}

Function Start-VMHostSSH {
    Param(
        [String]$VMHost
    )

    try { $VMHost = Get-VMHost }
    Catch { 
        Throw $error[0] 
    }

    try { 
        Start-VMHostService -HostService ($VMHost | Get-VMHostService | Where-object { $_.Key -eq "TSM-SSH" }) -confirm:$false
    }
    catch {
        throw $error[0]
    }
}

$session = Connect-vCenter -vCenterServer $VMHost -username $username -password $password
Start-VMHostSSH -VMHost $VMHost
Disconnect-VIServer $session -confirm:$false