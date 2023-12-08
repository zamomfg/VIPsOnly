
$Array = @()

$users = Get-MgUser -All

foreach ($user in $users) {
    $Row = "" | Select UserUPN, ManagerUPN

    $manager = Get-MgUserManager -UserID $user.UserPrincipalName -ErrorAction SilentlyContinue | %{Get-MgUser -UserId $_.Id}
    $Row.UserUPN = $user.UserPrincipalName
    $Row.ManagerUPN = $manager.UserPrincipalName
    $Array += $Row
}

Write-Output $Array