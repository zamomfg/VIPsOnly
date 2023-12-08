
$Array = @()
$Users = @{}

$AdUsers = Get-MgUser -All

foreach ($user in $AdUsers) {
    # $Row = "" | Select UserUPN, ManagerUPN

    $manager = Get-MgUserManager -UserID $user.UserPrincipalName -ErrorAction SilentlyContinue | %{Get-MgUser -UserId $_.Id}
    # $Row.UserUPN = $user.UserPrincipalName
    # $Row.ManagerUPN = $manager.UserPrincipalName
    # $Array += $Row

    # Write-Output $user.UserPrincipalName

    if($manager.UserPrincipalName -ne $null && $Users["$manager.UserPrincipalName"] -eq $null){
        $ManagerObj = [User]::new()
        $ManagerObj.ObjectId = $manager.Id
        $ManagerObj.UPN = $manager.UserPrincipalName
        $ManagerObj.Employees = @()

        $Users[$ManagerObj.UPN] = $ManagerObj
    }

    if($Users[$user.UserPrincipalName] -eq $null){
        $UserObj = [User]::new()
        $UserObj.ObjectId = $user.Id
        $UserObj.UPN = $user.UserPrincipalName
        $UserObj.Manager = $ManagerObj
        $UserObj.Employees = @()

        # Write-Output $UserObj
        # Write-Output $manager.UserPrincipalName
        $Users[$user.UserPrincipalName] = $UserObj

    }
    
    if($manager.UserPrincipalName -ne $null){
        $Users[$manager.UserPrincipalName].Employees += $UserObj
    }
}


foreach ($user in $Users.Values) {
    Write-Output $user
}

# Write-Output $Users["LeeG@t20dk.onmicrosoft.com"].Employees
# Write-Output $Users["LidiaH@t20dk.onmicrosoft.co"]

class User {
    [string]$ObjectId
    [string]$UPN
    [User[]]$Employees
    [User]$Manager
}