# PsShareShield

## Description
PsShareShield is a PowerShell module that provides a set of functions to interact with the API at https://app.shareshield.net

## Installation
```powershell
Install-Module -Name PsShareShield
```

## Usage
```powershell
Import-Module -Name PsShareShield

# Create a new secret that expires in 7 days
New-ShareShieldSecret -Secret "SecretPassword"

# Retrieve the secret
Get-ShareShieldSecret -SecretId "SecretId"
```

## License
MIT

# Contributing
If you would like to contribute, please open an issue or a pull request.

