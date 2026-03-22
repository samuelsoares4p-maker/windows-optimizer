<#
.SYNOPSIS
    Windows Optimization Tool By esieme - Versao Premium
.DESCRIPTION
    Ferramenta profissional de otimizacao do Windows
.NOTES
    Author: esieme
    Version: 3.0
#>

# Verificar Administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.Forms.MessageBox]::Show("Este script precisa ser executado como Administrador!", "By esieme", "OK", "Warning")
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Variaveis Globais
$global:idioma = "PT"
$global:logFile = "$env:TEMP\WindowsOpt_esieme_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Cores do Tema
$corFundo = [System.Drawing.Color]::FromArgb(32, 32, 32)
$corPainel = [System.Drawing.Color]::FromArgb(45, 45, 48)
$corDestaque = [System.Drawing.Color]::FromArgb(0, 120, 215)
$corPerigo = [System.Drawing.Color]::FromArgb(200, 50, 50)
$corTexto = [System.Drawing.Color]::White
$corOuro = [System.Drawing.Color]::FromArgb(255, 215, 0)

# Criar Formulario - Tamanho ajustado para 1280x720
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Optimization Tool - By esieme"
$form.Size = New-Object System.Drawing.Size(980, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = $corFundo
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false
$form.MinimumSize = New-Object System.Drawing.Size(980, 680)

# ========== CABECALHO COM DESTAQUE ==========
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Size = New-Object System.Drawing.Size(980, 85)
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.BackColor = $corDestaque

$lblTitulo = New-Object System.Windows.Forms.Label
$lblTitulo.Text = "WINDOWS OPTIMIZATION TOOL"
$lblTitulo.Location = New-Object System.Drawing.Point(15, 10)
$lblTitulo.Size = New-Object System.Drawing.Size(700, 30)
$lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$lblTitulo.ForeColor = $corTexto
$headerPanel.Controls.Add($lblTitulo)

$lblAssinatura = New-Object System.Windows.Forms.Label
$lblAssinatura.Text = "BY ESIEME"
$lblAssinatura.Location = New-Object System.Drawing.Point(15, 45)
$lblAssinatura.Size = New-Object System.Drawing.Size(400, 30)
$lblAssinatura.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$lblAssinatura.ForeColor = $corOuro
$headerPanel.Controls.Add($lblAssinatura)

$btnIdioma = New-Object System.Windows.Forms.Button
$btnIdioma.Text = "ENGLISH"
$btnIdioma.Location = New-Object System.Drawing.Point(830, 25)
$btnIdioma.Size = New-Object System.Drawing.Size(130, 35)
$btnIdioma.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 70)
$btnIdioma.ForeColor = $corTexto
$btnIdioma.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnIdioma.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$headerPanel.Controls.Add($btnIdioma)

$form.Controls.Add($headerPanel)

# ========== TAB CONTROL ==========
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(940, 480)
$tabControl.Location = New-Object System.Drawing.Point(20, 95)
$tabControl.Font = New-Object System.Drawing.Font("Segoe UI", 9)

# Criar Tabs
$tabEssential = New-Object System.Windows.Forms.TabPage
$tabEssential.BackColor = $corPainel
$tabControl.Controls.Add($tabEssential)

$tabAdvanced = New-Object System.Windows.Forms.TabPage
$tabAdvanced.BackColor = $corPainel
$tabControl.Controls.Add($tabAdvanced)

$tabCustomize = New-Object System.Windows.Forms.TabPage
$tabCustomize.BackColor = $corPainel
$tabControl.Controls.Add($tabCustomize)

$tabPower = New-Object System.Windows.Forms.TabPage
$tabPower.BackColor = $corPainel
$tabControl.Controls.Add($tabPower)

$tabLog = New-Object System.Windows.Forms.TabPage
$tabLog.BackColor = $corPainel
$tabControl.Controls.Add($tabLog)

$form.Controls.Add($tabControl)

# ========== ESSENTIAL TWEAKS ==========
$essentialGroup = New-Object System.Windows.Forms.GroupBox
$essentialGroup.Location = New-Object System.Drawing.Point(8, 8)
$essentialGroup.Size = New-Object System.Drawing.Size(920, 430)
$essentialGroup.ForeColor = $corTexto
$essentialGroup.BackColor = $corPainel
$essentialGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$essentialCheckboxes = @{}
$essentialItems = @(
    "Create Restore Point", "Delete Temporary Files", "Disable Activity History",
    "Disable ConsumerFeatures", "Disable Explorer Automatic Folder Discovery",
    "Disable Hibernation", "Disable Location Tracking", "Disable Powershell 7 Telemetry",
    "Disable Telemetry", "Disable Windows Platform Binary Table (WPTB)",
    "Enable End Task With Right Click", "Remove Widgets", "Run Disk Cleanup", "Set Services to Manual"
)

$essentialDefaults = @{
    "Create Restore Point" = $true; "Delete Temporary Files" = $true; "Disable Activity History" = $true
    "Disable ConsumerFeatures" = $true; "Disable Explorer Automatic Folder Discovery" = $true
    "Disable Hibernation" = $false; "Disable Location Tracking" = $true
    "Disable Powershell 7 Telemetry" = $true; "Disable Telemetry" = $true
    "Disable Windows Platform Binary Table (WPTB)" = $true; "Enable End Task With Right Click" = $true
    "Remove Widgets" = $false; "Run Disk Cleanup" = $true; "Set Services to Manual" = $true
}

$xPos = 15
$yPos = 30
$col = 0

for ($i = 0; $i -lt $essentialItems.Count; $i++) {
    $item = $essentialItems[$i]
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($xPos, $yPos)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = $corTexto
    $cb.Checked = $essentialDefaults[$item]
    $cb.BackColor = $corPainel
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
    $essentialGroup.Controls.Add($cb)
    $essentialCheckboxes[$item] = $cb
    
    $yPos += 28
    $col++
    
    if ($col -eq 7) {
        $xPos = 460
        $yPos = 30
        $col = 0
    }
}

$tabEssential.Controls.Add($essentialGroup)

# ========== ADVANCED TWEAKS ==========
$advancedGroup = New-Object System.Windows.Forms.GroupBox
$advancedGroup.Location = New-Object System.Drawing.Point(8, 8)
$advancedGroup.Size = New-Object System.Drawing.Size(920, 430)
$advancedGroup.ForeColor = [System.Drawing.Color]::Orange
$advancedGroup.BackColor = $corPainel
$advancedGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$advancedCheckboxes = @{}
$advancedItems = @(
    "Adobe Network Block", "Block Razer Software Installs", "Brave Debloat",
    "Disable Background Apps", "Disable Fullscreen Optimizations", "Disable IPv6",
    "Disable Microsoft Copilot", "Disable Notification Tray", "Disable Storage Sense",
    "Disable Teredo", "Edge Debloat", "Prefer IPv4 over IPv6",
    "Remove ALL MS Store Apps", "Remove Gallery from explorer",
    "Remove Home from Explorer", "Remove Microsoft Edge", "Remove OneDrive",
    "Remove Xbox and Gaming", "Revert the new start menu", "Set Classic Right-Click Menu",
    "Set Display for Performance", "Set Time to UTC (Dual Boot)"
)

$xPos = 15
$yPos = 30
$col = 0

foreach ($item in $advancedItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($xPos, $yPos)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = $(if ($item -like "*MS Store*" -or $item -like "*Microsoft Edge*" -or $item -like "*OneDrive*") { [System.Drawing.Color]::LightCoral } else { $corTexto })
    $cb.Checked = $false
    $cb.BackColor = $corPainel
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
    $advancedGroup.Controls.Add($cb)
    $advancedCheckboxes[$item] = $cb
    
    $yPos += 28
    $col++
    
    if ($col -eq 11) {
        $xPos = 460
        $yPos = 30
        $col = 0
    }
}

$tabAdvanced.Controls.Add($advancedGroup)

# ========== CUSTOMIZE PREFERENCES ==========
$customizeGroup = New-Object System.Windows.Forms.GroupBox
$customizeGroup.Location = New-Object System.Drawing.Point(8, 8)
$customizeGroup.Size = New-Object System.Drawing.Size(920, 430)
$customizeGroup.ForeColor = $corTexto
$customizeGroup.BackColor = $corPainel
$customizeGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$customizeCheckboxes = @{}
$customizeItems = @(
    "Bing Search in Start Menu", "Center Taskbar Items", "Cross-Device Resume",
    "Dark Theme for Windows", "Detailed BSoD", "Disable Multiplane Overlay",
    "Modern Standby fix", "Mouse Acceleration", "New Outlook", "Num Lock on Startup",
    "Recommendations in Start Menu", "Remove Settings Home Page", "S3 Sleep",
    "Search Button in Taskbar", "Show File Extensions", "Show Hidden Files",
    "Sticky Keys", "Task View Button", "Verbose Messages During Logon"
)

$customizeDefaults = @{
    "Bing Search in Start Menu" = $false; "Center Taskbar Items" = $true
    "Cross-Device Resume" = $false; "Dark Theme for Windows" = $true
    "Detailed BSoD" = $true; "Disable Multiplane Overlay" = $false
    "Modern Standby fix" = $false; "Mouse Acceleration" = $false
    "New Outlook" = $false; "Num Lock on Startup" = $true
    "Recommendations in Start Menu" = $false; "Remove Settings Home Page" = $true
    "S3 Sleep" = $false; "Search Button in Taskbar" = $false
    "Show File Extensions" = $true; "Show Hidden Files" = $true
    "Sticky Keys" = $false; "Task View Button" = $false
    "Verbose Messages During Logon" = $false
}

$xPos = 15
$yPos = 30
$col = 0

foreach ($item in $customizeItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($xPos, $yPos)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = $corTexto
    $cb.Checked = $customizeDefaults[$item]
    $cb.BackColor = $corPainel
    $cb.Font = New-Object System.Drawing.Font("Segoe UI", 8.5)
    $customizeGroup.Controls.Add($cb)
    $customizeCheckboxes[$item] = $cb
    
    $yPos += 28
    $col++
    
    if ($col -eq 10) {
        $xPos = 460
        $yPos = 30
        $col = 0
    }
}

$tabCustomize.Controls.Add($customizeGroup)

# ========== POWER PLANS ==========
$powerGroup = New-Object System.Windows.Forms.GroupBox
$powerGroup.Location = New-Object System.Drawing.Point(15, 15)
$powerGroup.Size = New-Object System.Drawing.Size(900, 150)
$powerGroup.ForeColor = $corTexto
$powerGroup.BackColor = $corPainel
$powerGroup.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$btnAddPower = New-Object System.Windows.Forms.Button
$btnAddPower.Location = New-Object System.Drawing.Point(40, 40)
$btnAddPower.Size = New-Object System.Drawing.Size(380, 40)
$btnAddPower.BackColor = $corDestaque
$btnAddPower.ForeColor = $corTexto
$btnAddPower.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnAddPower.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$powerGroup.Controls.Add($btnAddPower)

$btnRemovePower = New-Object System.Windows.Forms.Button
$btnRemovePower.Location = New-Object System.Drawing.Point(460, 40)
$btnRemovePower.Size = New-Object System.Drawing.Size(380, 40)
$btnRemovePower.BackColor = $corPerigo
$btnRemovePower.ForeColor = $corTexto
$btnRemovePower.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRemovePower.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$powerGroup.Controls.Add($btnRemovePower)

$lblPowerStatus = New-Object System.Windows.Forms.Label
$lblPowerStatus.Location = New-Object System.Drawing.Point(40, 95)
$lblPowerStatus.Size = New-Object System.Drawing.Size(800, 30)
$lblPowerStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$lblPowerStatus.ForeColor = [System.Drawing.Color]::LightGray
$lblPowerStatus.TextAlign = "MiddleCenter"
$powerGroup.Controls.Add($lblPowerStatus)

$tabPower.Controls.Add($powerGroup)

# ========== LOG TAB ==========
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(8, 8)
$logBox.Size = New-Object System.Drawing.Size(920, 430)
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$logBox.ForeColor = [System.Drawing.Color]::LightGreen
$logBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$tabLog.Controls.Add($logBox)

# ========== BOTOES PRINCIPAIS ==========
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Location = New-Object System.Drawing.Point(20, 585)
$bottomPanel.Size = New-Object System.Drawing.Size(940, 55)
$bottomPanel.BackColor = $corFundo

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 12)
$progressBar.Size = New-Object System.Drawing.Size(320, 32)
$bottomPanel.Controls.Add($progressBar)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(340, 12)
$lblStatus.Size = New-Object System.Drawing.Size(260, 32)
$lblStatus.ForeColor = $corTexto
$lblStatus.Text = "Pronto"
$lblStatus.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$bottomPanel.Controls.Add($lblStatus)

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(610, 8)
$btnRun.Size = New-Object System.Drawing.Size(150, 40)
$btnRun.BackColor = $corDestaque
$btnRun.ForeColor = $corTexto
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$bottomPanel.Controls.Add($btnRun)

$btnUndo = New-Object System.Windows.Forms.Button
$btnUndo.Location = New-Object System.Drawing.Point(770, 8)
$btnUndo.Size = New-Object System.Drawing.Size(150, 40)
$btnUndo.BackColor = $corPerigo
$btnUndo.ForeColor = $corTexto
$btnUndo.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnUndo.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$bottomPanel.Controls.Add($btnUndo)

$form.Controls.Add($bottomPanel)

# ========== FUNCOES DOS TWEAKS ==========
function Apply-EssentialTweak {
    param($tweak, $enable)
    Write-Log "[ESSENTIAL] $tweak - Enable: $enable"
    
    switch ($tweak) {
        "Create Restore Point" { if ($enable) { Enable-ComputerRestore -Drive "C:\"; Checkpoint-Computer -Description "By esieme" -RestorePointType "MODIFY_SETTINGS" } }
        "Delete Temporary Files" { if ($enable) { Remove-Item "$env:TEMP\*" -Recurse -Force -EA 0; Remove-Item "C:\Windows\Temp\*" -Recurse -Force -EA 0 } }
        "Disable Activity History" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force -EA 0 }
        "Disable ConsumerFeatures" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 1 -Force -EA 0 }
        "Disable Explorer Automatic Folder Discovery" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Value 0 -Force -EA 0 }
        "Disable Hibernation" { if ($enable) { powercfg /h off } else { powercfg /h on } }
        "Disable Location Tracking" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Value 1 -Force -EA 0 }
        "Disable Powershell 7 Telemetry" { [Environment]::SetEnvironmentVariable("POWERSHELL_TELEMETRY_OPTOUT", "true", "User") }
        "Disable Telemetry" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -EA 0 }
        "Disable Windows Platform Binary Table (WPTB)" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\WPTB" -Name "DisableWptb" -Value 1 -Force -EA 0 }
        "Enable End Task With Right Click" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Taskbar" -Name "DisableEndTask" -Value 0 -Force -EA 0 }
        "Remove Widgets" { if ($enable) { Get-AppxPackage *widgets* | Remove-AppxPackage -EA 0 } }
        "Run Disk Cleanup" { if ($enable) { Cleanmgr /sagerun:1 | Out-Null } }
        "Set Services to Manual" { if ($enable) { @("DiagTrack","dmwappushservice") | ForEach { Set-Service $_ -StartupType Manual -EA 0 } } }
    }
}

function Apply-AdvancedTweak {
    param($tweak, $enable)
    Write-Log "[ADVANCED] $tweak - Enable: $enable"
    
    switch ($tweak) {
        "Disable Background Apps" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Force -EA 0 }
        "Disable IPv6" { Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -ComponentID ms_tcpip6 -EA 0 }
        "Disable Microsoft Copilot" { Set-ItemProperty "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Force -EA 0 }
        "Disable Teredo" { netsh interface teredo set state disabled }
        "Prefer IPv4 over IPv6" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 0x20 -Type DWord -Force -EA 0 }
        "Remove ALL MS Store Apps" { if ($enable) { Get-AppxPackage -AllUsers | Remove-AppxPackage -EA 0 } }
        "Remove Microsoft Edge" { if ($enable) { Get-AppxPackage *edge* | Remove-AppxPackage -EA 0 } }
        "Remove OneDrive" { if ($enable) { Stop-Process -Name "OneDrive" -Force -EA 0; winget uninstall "Microsoft OneDrive" --silent -EA 0 } }
        "Remove Xbox and Gaming" { if ($enable) { Get-AppxPackage *xbox*,*gaming* | Remove-AppxPackage -EA 0 } }
        "Set Classic Right-Click Menu" { Set-ItemProperty "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Force -EA 0 }
        "Set Display for Performance" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Force -EA 0 }
        "Set Time to UTC (Dual Boot)" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Value 1 -Force -EA 0 }
        "Edge Debloat" { Get-AppxPackage *edge* | Remove-AppxPackage -EA 0 }
        "Brave Debloat" { Remove-Item "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Local State" -Force -EA 0 }
        "Disable Fullscreen Optimizations" { Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Force -EA 0 }
        "Disable Storage Sense" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Name "01" -Value 0 -Force -EA 0 }
        "Disable Notification Tray" { Set-ItemProperty "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -Value 1 -Force -EA 0 }
        "Remove Gallery from explorer" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Value 1 -Force -EA 0 }
        "Remove Home from Explorer" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowHome" -Value 0 -Force -EA 0 }
        "Revert the new start menu" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_ShowClassicMode" -Value 1 -Force -EA 0 }
        "Adobe Network Block" { if ($enable) { New-Item "HKLM:\SOFTWARE\Policies\Adobe" -Force | Out-Null; Set-ItemProperty "HKLM:\SOFTWARE\Policies\Adobe" -Name "DisableNetwork" -Value 1 -Force -EA 0 } }
        "Block Razer Software Installs" { if ($enable) { New-Item "HKLM:\SOFTWARE\Policies\Razer" -Force | Out-Null; Set-ItemProperty "HKLM:\SOFTWARE\Policies\Razer" -Name "DisableInstall" -Value 1 -Force -EA 0 } }
    }
}

function Apply-CustomizePreference {
    param($option, $enable)
    Write-Log "[CUSTOMIZE] $option - Enable: $enable"
    
    switch ($option) {
        "Bing Search in Start Menu" { Set-ItemProperty "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value $(if ($enable) {0} else {1}) -Force -EA 0 }
        "Center Taskbar Items" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Dark Theme for Windows" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value $(if ($enable) {0} else {1}) -Force -EA 0; Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value $(if ($enable) {0} else {1}) -Force -EA 0 }
        "Detailed BSoD" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl" -Name "DisplayParameters" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Show File Extensions" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value $(if ($enable) {0} else {1}) -Force -EA 0 }
        "Show Hidden Files" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value $(if ($enable) {1} else {2}) -Force -EA 0 }
        "Num Lock on Startup" { Set-ItemProperty "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value $(if ($enable) {2} else {0}) -Force -EA 0 }
        "Mouse Acceleration" { Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Verbose Messages During Logon" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Remove Settings Home Page" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -Value "hide:home" -Force -EA 0 }
        "Search Button in Taskbar" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value $(if ($enable) {2} else {0}) -Force -EA 0 }
        "Task View Button" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Recommendations in Start Menu" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Cross-Device Resume" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ActivityFeed" -Name "EnableActivityFeed" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Disable Multiplane Overlay" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" -Name "DisableMPO" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "Modern Standby fix" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PlatformAoAcOverride" -Value $(if ($enable) {0} else {1}) -Force -EA 0 }
        "New Outlook" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Office\16.0\Outlook\Options\General" -Name "NewOutlook" -Value $(if ($enable) {1} else {0}) -Force -EA 0 }
        "S3 Sleep" { powercfg /setacvalueindex scheme_current sub_buttons lidaction $(if ($enable) {1} else {0}); powercfg /setdcvalueindex scheme_current sub_buttons lidaction $(if ($enable) {1} else {0}) }
        "Sticky Keys" { Set-ItemProperty "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Value $(if ($enable) {"506"} else {"510"}) -Force -EA 0 }
    }
}

function Write-Log {
    param($msg)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $logMsg = "[$timestamp] $msg"
    $logMsg | Out-File $global:logFile -Append -Encoding UTF8
}

# ========== ATUALIZAR IDIOMA (SEM ACENTOS) ==========
function Update-Language {
    if ($global:idioma -eq "PT") {
        $global:idioma = "EN"
        $btnIdioma.Text = "PORTUGUES"
        $form.Text = "Windows Optimization Tool - By esieme"
        $lblTitulo.Text = "WINDOWS OPTIMIZATION TOOL"
        $lblAssinatura.Text = "BY ESIEME"
        $tabEssential.Text = " Essential Tweaks "
        $tabAdvanced.Text = " Advanced Tweaks - CAUTION "
        $tabCustomize.Text = " Customize Preferences "
        $tabPower.Text = " Performance Plans "
        $tabLog.Text = " Log "
        $essentialGroup.Text = "Select essential tweaks"
        $advancedGroup.Text = "Advanced Tweaks - Use with caution!"
        $customizeGroup.Text = "Customize your Windows"
        $powerGroup.Text = "Power Plans Management"
        $btnAddPower.Text = "Add and Activate Ultimate Performance Profile"
        $btnRemovePower.Text = "Remove Ultimate Performance Profile"
        $btnRun.Text = "RUN TWEAKS"
        $btnUndo.Text = "UNDO SELECTED"
        $lblStatus.Text = "Ready"
    } else {
        $global:idioma = "PT"
        $btnIdioma.Text = "ENGLISH"
        $form.Text = "Ferramenta de Otimizacao - By esieme"
        $lblTitulo.Text = "FERRAMENTA DE OTIMIZACAO"
        $lblAssinatura.Text = "POR ESIEME"
        $tabEssential.Text = " Tweaks Essenciais "
        $tabAdvanced.Text = " Tweaks Avancados - CUIDADO "
        $tabCustomize.Text = " Personalizacoes "
        $tabPower.Text = " Planos de Energia "
        $tabLog.Text = " Log "
        $essentialGroup.Text = "Selecione os tweaks essenciais"
        $advancedGroup.Text = "Tweaks Avancados - Use com cuidado!"
        $customizeGroup.Text = "Personalize seu Windows"
        $powerGroup.Text = "Gerenciamento de Planos de Energia"
        $btnAddPower.Text = "Adicionar e Ativar Ultimate Performance Profile"
        $btnRemovePower.Text = "Remover Ultimate Performance Profile"
        $btnRun.Text = "APLICAR TWEAKS"
        $btnUndo.Text = "DESFAZER SELECIONADOS"
        $lblStatus.Text = "Pronto"
    }
    
    # Atualizar status da energia
    $currentPlan = powercfg /getactivescheme
    if ($global:idioma -eq "PT") {
        $lblPowerStatus.Text = "Plano atual: $currentPlan"
    } else {
        $lblPowerStatus.Text = "Current plan: $currentPlan"
    }
}

# ========== EVENTOS DOS BOTOES ==========
$btnIdioma.Add_Click({ Update-Language })

$btnRun.Add_Click({
    $btnRun.Enabled = $false
    $btnUndo.Enabled = $false
    $progressBar.Value = 0
    $lblStatus.Text = if ($global:idioma -eq "PT") { "Aplicando..." } else { "Applying..." }
    $logBox.Text = ""
    
    $selected = @()
    foreach ($cb in $essentialCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Essential"} } }
    foreach ($cb in $advancedCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Advanced"} } }
    foreach ($cb in $customizeCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Customize"} } }
    
    $total = $selected.Count
    $current = 0
    
    foreach ($item in $selected) {
        $current++
        $percent = ($current / $total) * 100
        $progressBar.Value = $percent
        $lblStatus.Text = "Aplicando: $($item.Name)"
        $logBox.AppendText("Aplicando: $($item.Name)`r`n")
        $logBox.ScrollToCaret()
        
        try {
            if ($item.Type -eq "Essential") { Apply-EssentialTweak $item.Name $true }
            elseif ($item.Type -eq "Advanced") { Apply-AdvancedTweak $item.Name $true }
            elseif ($item.Type -eq "Customize") { Apply-CustomizePreference $item.Name $true }
            $logBox.AppendText("  OK`r`n")
        } catch {
            $logBox.AppendText("  ERRO: $_`r`n")
        }
        Start-Sleep -Milliseconds 50
    }
    
    $logBox.AppendText("`r`n" + "="*50 + "`r`n")
    $logBox.AppendText("Concluido! Log salvo em: $global:logFile`r`n")
    $logBox.AppendText("Reinicie o computador para aplicar todas as alteracoes.`r`n")
    
    $lblStatus.Text = if ($global:idioma -eq "PT") { "Concluido!" } else { "Completed!" }
    $progressBar.Value = 100
    [System.Windows.Forms.MessageBox]::Show("Tweaks aplicados com sucesso!`nReinicie o computador.", "By esieme", "OK", "Information")
    
    $btnRun.Enabled = $true
    $btnUndo.Enabled = $true
})

$btnUndo.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Reverter tweaks selecionados?", "By esieme", "YesNo", "Warning")
    if ($result -eq "Yes") {
        $btnRun.Enabled = $false
        $btnUndo.Enabled = $false
        $progressBar.Value = 0
        $lblStatus.Text = if ($global:idioma -eq "PT") { "Revertendo..." } else { "Reverting..." }
        
        $selected = @()
        foreach ($cb in $essentialCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Essential"} } }
        foreach ($cb in $advancedCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Advanced"} } }
        foreach ($cb in $customizeCheckboxes.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="Customize"} } }
        
        $total = $selected.Count
        $current = 0
        
        foreach ($item in $selected) {
            $current++
            $percent = ($current / $total) * 100
            $progressBar.Value = $percent
            $lblStatus.Text = "Revertendo: $($item.Name)"
            $logBox.AppendText("Revertendo: $($item.Name)`r`n")
            
            try {
                if ($item.Type -eq "Essential") { Apply-EssentialTweak $item.Name $false }
                elseif ($item.Type -eq "Advanced") { Apply-AdvancedTweak $item.Name $false }
                elseif ($item.Type -eq "Customize") { Apply-CustomizePreference $item.Name $false }
                $logBox.AppendText("  OK`r`n")
            } catch {
                $logBox.AppendText("  ERRO: $_`r`n")
            }
            Start-Sleep -Milliseconds 50
        }
        
        $lblStatus.Text = if ($global:idioma -eq "PT") { "Revertido!" } else { "Reverted!" }
        $progressBar.Value = 100
        [System.Windows.Forms.MessageBox]::Show("Tweaks revertidos!", "By esieme", "OK", "Information")
        
        $btnRun.Enabled = $true
        $btnUndo.Enabled = $true
    }
})

$btnAddPower.Add_Click({
    try {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1 | Out-Null
        powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        $plan = powercfg /getactivescheme
        if ($global:idioma -eq "PT") { $lblPowerStatus.Text = "Plano atual: $plan" } else { $lblPowerStatus.Text = "Current plan: $plan" }
        $logBox.AppendText("Ultimate Performance Profile ativado`r`n")
        [System.Windows.Forms.MessageBox]::Show("Ultimate Performance Profile ativado!", "By esieme", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Erro: $_", "By esieme", "OK", "Error")
    }
})

$btnRemovePower.Add_Click({
    try {
        powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61
        $plan = powercfg /getactivescheme
        if ($global:idioma -eq "PT") { $lblPowerStatus.Text = "Plano atual: $plan" } else { $lblPowerStatus.Text = "Current plan: $plan" }
        $logBox.AppendText("Ultimate Performance Profile removido`r`n")
        [System.Windows.Forms.MessageBox]::Show("Ultimate Performance Profile removido!", "By esieme", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Erro: $_", "By esieme", "OK", "Error")
    }
})

# Inicializar
$currentPlan = powercfg /getactivescheme
$lblPowerStatus.Text = "Plano atual: $currentPlan"
$logBox.Text = "Aguardando execucao dos tweaks...`n`n"
Write-Log "Ferramenta iniciada - By esieme"

$form.ShowDialog() | Out-Null
