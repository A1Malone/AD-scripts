# AD-Scripts
scripts for AD

Simple AD PowerShell Commands

##Domain Commands

Display basic domain info 
```
Get-ADDomain
````

list all domain controllers by hostname, IPv4, and operating system
```
Get-ADDomainController -filter * | select hostname, IPv4Address, operatingsystem
```

Backup Avtive Directoy System State Remotely
(Change "DC-Name" to your server name and change "Backup-Path")
```
invoke-command -ComputerName DC-Name -scriptblock {wbadmin start systemstateback up -backupTarget:"Backup-Path" -quiet}
```




##User Commands

List all attibutes of a user 
(change "username" to the name of the user)
```
Get-ADUser username -Properties *
```

Get specific attibutes from a user
```
Get-ADUser username -Properties * | Select name, department, title
```

Get all usersw in a domin 
```
Get-ADUser -Filter *
```

Get all users from a specific OU
(change ou= dc=)
```
Get-ADUser -SearchBase “OU=ADPRO Users,dc=ad,dc=activedirectorypro.com” -Filter *
```

Display All users with the same name
(put namne in between * *)
get-Aduser -Filter {name -like "*PUT NAME HERE*"}


Disable User account
```
Disable-ADAccount -Identity NAMEHERE
```

Enable user account
```
Enable-ADAccount -Identity NAMEHERE
```

Display accounts wwith passsowrds that do not expire
```
get-aduser -filter * -properties Name, PasswordNeverExpires | where {$_.passwordNeverExpires -eq "true" } | Select-Object DistinguishedName,Name,Enabled
```

Dispaly all locked accounts
```
Search-ADAccount -LockedOut
```




##Group Commands