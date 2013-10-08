Get-ADUser -Filter * -SearchBase "ou=Student Teachers" -Properties username

Get-ADUser -Filter * -SearchScope "ou=Staff" -Properties username