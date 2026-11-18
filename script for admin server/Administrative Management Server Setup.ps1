# ============================================================
# AMV-ADM1 - Administrative Management Server Setup
# Run PowerShell as Administrator
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " AMV-ADM1 Administrative Server Setup"
Write-Host "=============================================" -ForegroundColor Cyan

# ------------------------------------------------------------
# 1. Verify Administrative Privileges
# ------------------------------------------------------------

$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Write-Host "ERROR: Run this script as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "`n[OK] Running as Administrator." -ForegroundColor Green


# ------------------------------------------------------------
# 2. Install Active Directory Management Tools
# ------------------------------------------------------------

Write-Host "`nInstalling Active Directory management tools..." -ForegroundColor Yellow

Install-WindowsFeature RSAT-AD-Tools -IncludeAllSubFeature

Write-Host "[OK] Active Directory tools installed." -ForegroundColor Green


# ------------------------------------------------------------
# 3. Install Group Policy Management
# ------------------------------------------------------------

Write-Host "`nInstalling Group Policy Management..." -ForegroundColor Yellow

Install-WindowsFeature GPMC

Write-Host "[OK] Group Policy Management installed." -ForegroundColor Green


# ------------------------------------------------------------
# 4. Install DNS Management Tools
# ------------------------------------------------------------

Write-Host "`nInstalling DNS management tools..." -ForegroundColor Yellow

Install-WindowsFeature RSAT-DNS-Server

Write-Host "[OK] DNS management tools installed." -ForegroundColor Green


# ------------------------------------------------------------
# 5. Install DHCP Management Tools
# ------------------------------------------------------------

Write-Host "`nInstalling DHCP management tools..." -ForegroundColor Yellow

Install-WindowsFeature RSAT-DHCP

Write-Host "[OK] DHCP management tools installed." -ForegroundColor Green


# ------------------------------------------------------------
# 6. Install File Services Management Tools
# ------------------------------------------------------------

Write-Host "`nInstalling File Services management tools..." -ForegroundColor Yellow

Install-WindowsFeature RSAT-File-Services

Write-Host "[OK] File Services tools installed." -ForegroundColor Green


# ------------------------------------------------------------
# 7. Install Failover Clustering Management Tools
# Useful for future Windows Server/AZ-802 labs
# ------------------------------------------------------------

Write-Host "`nInstalling Failover Cluster management tools..." -ForegroundColor Yellow

Install-WindowsFeature RSAT-Clustering

Write-Host "[OK] Failover Cluster tools installed." -ForegroundColor Green


# ------------------------------------------------------------
# 8. Test Active Directory PowerShell Module
# ------------------------------------------------------------

Write-Host "`nTesting Active Directory PowerShell module..." -ForegroundColor Yellow

try {
    Import-Module ActiveDirectory
    Write-Host "[OK] ActiveDirectory module loaded." -ForegroundColor Green
}
catch {
    Write-Warning "ActiveDirectory module could not be loaded."
}


# ------------------------------------------------------------
# 9. Display Installed Management Features
# ------------------------------------------------------------

Write-Host "`nInstalled RSAT / Management Features:" -ForegroundColor Cyan

Get-WindowsFeature |
    Where-Object {
        $_.Installed -and (
            $_.Name -like "RSAT*" -or
            $_.Name -eq "GPMC"
        )
    } |
    Select-Object DisplayName, Name, InstallState |
    Format-Table -AutoSize


# ------------------------------------------------------------
# 10. Test Common Administrative Consoles
# ------------------------------------------------------------

Write-Host "`nChecking common administrative consoles..." -ForegroundColor Cyan

$Tools = @{
    "Active Directory Users and Computers" = "$env:SystemRoot\System32\dsa.msc"
    "Group Policy Management"              = "$env:SystemRoot\System32\gpmc.msc"
    "DNS Manager"                          = "$env:SystemRoot\System32\dnsmgmt.msc"
    "DHCP Manager"                         = "$env:SystemRoot\System32\dhcpmgmt.msc"
}

foreach ($Tool in $Tools.GetEnumerator()) {

    if (Test-Path $Tool.Value) {
        Write-Host "[FOUND] $($Tool.Key)" -ForegroundColor Green
    }
    else {
        Write-Host "[NOT FOUND] $($Tool.Key)" -ForegroundColor Red
    }
}


Write-Host "`n=============================================" -ForegroundColor Green
Write-Host " AMV-ADM1 Setup Complete"
Write-Host "=============================================" -ForegroundColor Green

Write-Host "
You should now have access to:

  • Active Directory Users and Computers
  • Active Directory Administrative Center
  • Active Directory PowerShell
  • Group Policy Management
  • DNS Manager
  • DHCP Manager
  • Server Manager
  • File Services management tools
  • Failover Cluster management tools

Recommended next step:
Please install Windows Admin Center from Windows Evaluation center
" -ForegroundColor Cyan
