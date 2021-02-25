Param(
    [String]$VMHost,
    [String]$username,
    [String]$password,
    [String]$turnOn
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

Function Set-VMHostSSH {
    Param(
        [String]$VMHost,
        [Boolean]$turnOn
    )

    try { $VMHostObj = Get-VMHost -Name $VMHost }
    Catch { 
        Throw $error[0] 
    }

    try { 
        if ($turnOn -eq $true) {
            write-host "nope"
            Start-VMHostService -HostService ($VMHostObj | Get-VMHostService | Where-object { $_.Key -eq "TSM-SSH" }) -confirm:$false
        } else {
            Stop-VMHostService -HostService ($VMHostObj | Get-VMHostService | Where-object { $_.Key -eq "TSM-SSH" }) -confirm:$false
        }
    }
    catch {
        throw $error[0]
    }
}

$turnOnBool = [System.Convert]::ToBoolean($turnOn)
$session = Connect-VMHost -VMHost $VMHost -username $username -password $password
Set-VMHostSSH -VMHost $VMHost -turnOn $turnOnBool
Disconnect-VIServer $session -confirm:$false