# module for the ShareShield API.

<#
# .SYNOPSIS
    Create a new secret with ShareShield.
# .DESCRIPTION
    This function creates a new secret with ShareShield.
# .PARAMETER Secret
    The secret to be shared.
# .PARAMETER ExpiresInDays
    The number of days the secret will be available for.
# .PARAMETER IdOnly
    Return only the secret id.
# .EXAMPLE
    New-ShareShieldSecret -Secret "This is a secret" -ExpiresInDays 1
    Creates a new secret that will expire in 1 day.
# .NOTES

#>
function New-ShareShieldSecret {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline=$true, Position=0)]
        [string]$Secret,
        [Parameter(Mandatory = $false)]
        [ValidateSet(1,3,7)]
        [int]$ExpiresInDays = 1,
        [Parameter(Mandatory = $false)]
        [switch]$IdOnly
    )
    
    begin {
        $secretLinks = @()
        # TODO
        # auth to ShareShield API and get token
        $token = $null
    }
    
    process {
        # Prepare API request
        $apiUrl = "https://api.shareshield.net/v1/secrets"
        $headers = @{
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json"
        }

        $body = @{
            "password" = $Secret
            "expiry" = $ExpiresInDays
            "showUrl" = $true
        }

        # Send API request
        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Method Post -Headers $headers -Body ($body | ConvertTo-Json)   
        }
        catch {
            Write-Error "Couldn't create secret: $($_.Exception.Message)"
        }

        if($null -ne $response) {
            # Return secret id or url
            if ($IdOnly) {
                $secretLinks += [PSCustomObject]@{
                    Id = ($response.url.replace('https://app.shareshield.net/', ''))
                }
            }else{
                $secretLinks += [PSCustomObject]@{
                    Url = $response.url
                }
            }
        }
    }
    
    end {
        return $secretLinks
    }
}

<#
# .SYNOPSIS
    Retrieve a secret with ShareShield.
# .DESCRIPTION
    This function retrieves a secret with ShareShield.
# .PARAMETER SecretId
    The id of the secret to be retrieved.
# .EXAMPLE
    Get-ShareShieldSecret -SecretId 5gi9nddj1g9
    Retrieves the secret with id 5gi9nddj1g9.
# .NOTES

#>
function Get-ShareShieldSecret {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline=$true, Position=0)]
        [string]$SecretId
    )
    
    begin {
        $secrets = @()
        # TODO
        # auth to ShareShield API and get token
        $token = $null
    }
    
    process {
        # Prepare API request
        $apiUrl = "https://api.shareshield.net/v1/secrets/$SecretId"
        $headers = @{
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json"
        }

        # Send API request
        try {
            $response = Invoke-RestMethod -Uri $apiUrl -Method Get -Headers $headers
        }
        catch {
            Write-Error "Couldn't retrieve secret: $($_.Exception.Message)"
        }

        if($null -ne $response) {
            $secrets += [PSCustomObject]@{
                Secret = $response.secret
            }
        }
    }
    
    end {
        return $secrets
    }
}