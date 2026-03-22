<#
.SYNOPSIS
    Windows Optimization Tool by esieme
.DESCRIPTION
    Ferramenta completa de otimizacao do Windows
.NOTES
    Version: 1.0
    Author: esieme
#>

# Verificar Administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Clique com botao direito no PowerShell e escolha 'Executar como administrador'" -ForegroundColor Yellow
    pause
    exit
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$global:idioma = "PT"
$global:logFile = "$env:TEMP\WindowsOpt_esieme_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Write-Log {
    param($msg)
    $timestamp = Get-Date -Format "HH:mm:ss"
    "$timestamp $msg" | Out-File $global:logFile -Append -Encoding UTF8
}

# Criar Formulario
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Optimization Tool - by esieme"
$form.Size = New-Object System.Drawing.Size(980, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Cores
$corDestaque = [System.Drawing.Color]::FromArgb(0, 120, 215)
$corOuro = [System.Drawing.Color]::FromArgb(255, 215, 0)
$corFundo = [System.Drawing.Color]::FromArgb(45, 45, 48)

# Header
$header = New-Object System.Windows.Forms.Panel
$header.Size = New-Object System.Drawing.Size(980, 85)
$header.Location = New-Object System.Drawing.Point(0, 0)
$header.BackColor = $corDestaque

$lblTitulo = New-Object System.Windows.Forms.Label
$lblTitulo.Text = "WINDOWS OPTIMIZATION TOOL"
$lblTitulo.Location = New-Object System.Drawing.Point(15, 10)
$lblTitulo.Size = New-Object System.Drawing.Size(700, 30)
$lblTitulo.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$lblTitulo.ForeColor = [System.Drawing.Color]::White
$header.Controls.Add($lblTitulo)

$lblAssinatura = New-Object System.Windows.Forms.Label
$lblAssinatura.Text = "BY ESIEME"
$lblAssinatura.Location = New-Object System.Drawing.Point(15, 45)
$lblAssinatura.Size = New-Object System.Drawing.Size(400, 30)
$lblAssinatura.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$lblAssinatura.ForeColor = $corOuro
$header.Controls.Add($lblAssinatura)

$btnLang = New-Object System.Windows.Forms.Button
$btnLang.Text = "ENGLISH"
$btnLang.Location = New-Object System.Drawing.Point(830, 25)
$btnLang.Size = New-Object System.Drawing.Size(130, 35)
$btnLang.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 70)
$btnLang.ForeColor = [System.Drawing.Color]::White
$btnLang.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$header.Controls.Add($btnLang)
$form.Controls.Add($header)

# Tab Control
$tabControl = New-Object System.Windows.Forms.TabControl
$tabControl.Size = New-Object System.Drawing.Size(940, 480)
$tabControl.Location = New-Object System.Drawing.Point(20, 95)

$tabEssential = New-Object System.Windows.Forms.TabPage
$tabEssential.Text = " Essential Tweaks "
$tabEssential.BackColor = $corFundo
$tabControl.Controls.Add($tabEssential)

$tabAdvanced = New-Object System.Windows.Forms.TabPage
$tabAdvanced.Text = " Advanced Tweaks "
$tabAdvanced.BackColor = $corFundo
$tabControl.Controls.Add($tabAdvanced)

$tabCustomize = New-Object System.Windows.Forms.TabPage
$tabCustomize.Text = " Customize "
$tabCustomize.BackColor = $corFundo
$tabControl.Controls.Add($tabCustomize)

$tabPower = New-Object System.Windows.Forms.TabPage
$tabPower.Text = " Performance "
$tabPower.BackColor = $corFundo
$tabControl.Controls.Add($tabPower)

$tabLog = New-Object System.Windows.Forms.TabPage
$tabLog.Text = " Log "
$tabLog.BackColor = $corFundo
$tabControl.Controls.Add($tabLog)

$form.Controls.Add($tabControl)

# Essential Tweaks
$groupEssential = New-Object System.Windows.Forms.GroupBox
$groupEssential.Location = New-Object System.Drawing.Point(8, 8)
$groupEssential.Size = New-Object System.Drawing.Size(920, 430)
$groupEssential.ForeColor = [System.Drawing.Color]::White
$groupEssential.BackColor = $corFundo
$groupEssential.Text = "Select essential tweaks"

$checkboxesEssential = @{}
$essentialItems = @(
    "Create Restore Point", "Delete Temporary Files", "Disable Activity History",
    "Disable ConsumerFeatures", "Disable Explorer Auto Discovery", "Disable Hibernation",
    "Disable Location Tracking", "Disable Telemetry", "Enable End Task With Right Click",
    "Remove Widgets", "Run Disk Cleanup", "Set Services to Manual"
)

$x = 15; $y = 30; $col = 0
foreach ($item in $essentialItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($x, $y)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.Checked = $true
    $cb.BackColor = $corFundo
    $groupEssential.Controls.Add($cb)
    $checkboxesEssential[$item] = $cb
    $y += 28
    $col++
    if ($col -eq 6) { $x = 460; $y = 30; $col = 0 }
}
$tabEssential.Controls.Add($groupEssential)

# Advanced Tweaks
$groupAdvanced = New-Object System.Windows.Forms.GroupBox
$groupAdvanced.Location = New-Object System.Drawing.Point(8, 8)
$groupAdvanced.Size = New-Object System.Drawing.Size(920, 430)
$groupAdvanced.ForeColor = [System.Drawing.Color]::Orange
$groupAdvanced.BackColor = $corFundo
$groupAdvanced.Text = "Advanced Tweaks - Use with caution!"

$checkboxesAdvanced = @{}
$advancedItems = @(
    "Disable Background Apps", "Disable IPv6", "Disable Microsoft Copilot",
    "Disable Teredo", "Prefer IPv4 over IPv6", "Remove ALL MS Store Apps",
    "Remove Microsoft Edge", "Remove OneDrive", "Remove Xbox Components",
    "Set Classic Right-Click Menu", "Set Display for Performance"
)

$x = 15; $y = 30; $col = 0
foreach ($item in $advancedItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($x, $y)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.Checked = $false
    $cb.BackColor = $corFundo
    $groupAdvanced.Controls.Add($cb)
    $checkboxesAdvanced[$item] = $cb
    $y += 28
    $col++
    if ($col -eq 6) { $x = 460; $y = 30; $col = 0 }
}
$tabAdvanced.Controls.Add($groupAdvanced)

# Customize
$groupCustomize = New-Object System.Windows.Forms.GroupBox
$groupCustomize.Location = New-Object System.Drawing.Point(8, 8)
$groupCustomize.Size = New-Object System.Drawing.Size(920, 430)
$groupCustomize.ForeColor = [System.Drawing.Color]::White
$groupCustomize.BackColor = $corFundo
$groupCustomize.Text = "Customize your Windows"

$checkboxesCustomize = @{}
$customizeItems = @(
    "Dark Theme for Windows", "Show File Extensions", "Show Hidden Files",
    "Num Lock on Startup", "Center Taskbar Items", "Remove Settings Home Page",
    "Task View Button", "Verbose Logon Messages"
)

$x = 15; $y = 30; $col = 0
foreach ($item in $customizeItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Location = New-Object System.Drawing.Point($x, $y)
    $cb.Size = New-Object System.Drawing.Size(430, 26)
    $cb.ForeColor = [System.Drawing.Color]::White
    $cb.Checked = ($item -eq "Dark Theme for Windows")
    $cb.BackColor = $corFundo
    $groupCustomize.Controls.Add($cb)
    $checkboxesCustomize[$item] = $cb
    $y += 28
    $col++
    if ($col -eq 4) { $x = 460; $y = 30; $col = 0 }
}
$tabCustomize.Controls.Add($groupCustomize)

# Power Plans
$groupPower = New-Object System.Windows.Forms.GroupBox
$groupPower.Location = New-Object System.Drawing.Point(15, 15)
$groupPower.Size = New-Object System.Drawing.Size(900, 150)
$groupPower.ForeColor = [System.Drawing.Color]::White
$groupPower.BackColor = $corFundo
$groupPower.Text = "Power Plans"

$btnAddPower = New-Object System.Windows.Forms.Button
$btnAddPower.Location = New-Object System.Drawing.Point(40, 40)
$btnAddPower.Size = New-Object System.Drawing.Size(380, 40)
$btnAddPower.Text = "Add Ultimate Performance Profile"
$btnAddPower.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnAddPower.ForeColor = [System.Drawing.Color]::White
$btnAddPower.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$btnRemovePower = New-Object System.Windows.Forms.Button
$btnRemovePower.Location = New-Object System.Drawing.Point(460, 40)
$btnRemovePower.Size = New-Object System.Drawing.Size(380, 40)
$btnRemovePower.Text = "Remove Ultimate Performance Profile"
$btnRemovePower.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$btnRemovePower.ForeColor = [System.Drawing.Color]::White
$btnRemovePower.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$lblPower = New-Object System.Windows.Forms.Label
$lblPower.Location = New-Object System.Drawing.Point(40, 95)
$lblPower.Size = New-Object System.Drawing.Size(800, 30)
$lblPower.ForeColor = [System.Drawing.Color]::LightGray
$currentPlan = powercfg /getactivescheme
$lblPower.Text = "Current plan: $currentPlan"

$groupPower.Controls.Add($btnAddPower)
$groupPower.Controls.Add($btnRemovePower)
$groupPower.Controls.Add($lblPower)
$tabPower.Controls.Add($groupPower)

# Log Tab
$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(8, 8)
$logBox.Size = New-Object System.Drawing.Size(920, 430)
$logBox.Multiline = $true
$logBox.ScrollBars = "Vertical"
$logBox.ReadOnly = $true
$logBox.BackColor = [System.Drawing.Color]::FromArgb(25, 25, 30)
$logBox.ForeColor = [System.Drawing.Color]::LightGreen
$logBox.Font = New-Object System.Drawing.Font("Consolas", 8)
$logBox.Text = "Ready...`n"
$tabLog.Controls.Add($logBox)

# Bottom Panel
$bottomPanel = New-Object System.Windows.Forms.Panel
$bottomPanel.Location = New-Object System.Drawing.Point(20, 585)
$bottomPanel.Size = New-Object System.Drawing.Size(940, 55)
$bottomPanel.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 12)
$progressBar.Size = New-Object System.Drawing.Size(320, 32)

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Location = New-Object System.Drawing.Point(340, 12)
$lblStatus.Size = New-Object System.Drawing.Size(260, 32)
$lblStatus.ForeColor = [System.Drawing.Color]::White
$lblStatus.Text = "Ready"

$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Location = New-Object System.Drawing.Point(610, 8)
$btnRun.Size = New-Object System.Drawing.Size(150, 40)
$btnRun.Text = "RUN TWEAKS"
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$btnUndo = New-Object System.Windows.Forms.Button
$btnUndo.Location = New-Object System.Drawing.Point(770, 8)
$btnUndo.Size = New-Object System.Drawing.Size(150, 40)
$btnUndo.Text = "UNDO SELECTED"
$btnUndo.BackColor = [System.Drawing.Color]::FromArgb(200, 50, 50)
$btnUndo.ForeColor = [System.Drawing.Color]::White
$btnUndo.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat

$bottomPanel.Controls.Add($progressBar)
$bottomPanel.Controls.Add($lblStatus)
$bottomPanel.Controls.Add($btnRun)
$bottomPanel.Controls.Add($btnUndo)
$form.Controls.Add($bottomPanel)

# Funcoes de Aplicacao
function Apply-EssentialTweak {
    param($tweak)
    switch ($tweak) {
        "Create Restore Point" { Enable-ComputerRestore -Drive "C:\"; Checkpoint-Computer -Description "by esieme" -RestorePointType "MODIFY_SETTINGS" }
        "Delete Temporary Files" { Remove-Item "$env:TEMP\*" -Recurse -Force -EA 0 }
        "Disable Activity History" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0 -Force -EA 0 }
        "Disable ConsumerFeatures" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 1 -Force -EA 0 }
        "Disable Explorer Auto Discovery" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "AutoCheckSelect" -Value 0 -Force -EA 0 }
        "Disable Hibernation" { powercfg /h off }
        "Disable Location Tracking" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Value 1 -Force -EA 0 }
        "Disable Telemetry" { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 -Force -EA 0 }
        "Enable End Task With Right Click" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Taskbar" -Name "DisableEndTask" -Value 0 -Force -EA 0 }
        "Remove Widgets" { Get-AppxPackage *widgets* | Remove-AppxPackage -EA 0 }
        "Run Disk Cleanup" { Cleanmgr /sagerun:1 | Out-Null }
        "Set Services to Manual" { @("DiagTrack","dmwappushservice") | ForEach { Set-Service $_ -StartupType Manual -EA 0 } }
    }
}

function Apply-AdvancedTweak {
    param($tweak)
    switch ($tweak) {
        "Disable Background Apps" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Force -EA 0 }
        "Disable IPv6" { Get-NetAdapterBinding -ComponentID ms_tcpip6 | Disable-NetAdapterBinding -ComponentID ms_tcpip6 -EA 0 }
        "Disable Microsoft Copilot" { Set-ItemProperty "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1 -Force -EA 0 }
        "Disable Teredo" { netsh interface teredo set state disabled }
        "Prefer IPv4 over IPv6" { Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" -Name "DisabledComponents" -Value 0x20 -Force -EA 0 }
        "Remove ALL MS Store Apps" { Get-AppxPackage -AllUsers | Remove-AppxPackage -EA 0 }
        "Remove Microsoft Edge" { Get-AppxPackage *edge* | Remove-AppxPackage -EA 0 }
        "Remove OneDrive" { Stop-Process -Name "OneDrive" -Force -EA 0; Start-Sleep 2; winget uninstall "Microsoft OneDrive" --silent -EA 0 }
        "Remove Xbox Components" { Get-AppxPackage *xbox* | Remove-AppxPackage -EA 0 }
        "Set Classic Right-Click Menu" { Set-ItemProperty "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" -Name "System.IsPinnedToNameSpaceTree" -Value 0 -Force -EA 0 }
        "Set Display for Performance" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Force -EA 0 }
    }
}

function Apply-Customize {
    param($option)
    switch ($option) {
        "Dark Theme for Windows" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0 -Force -EA 0 }
        "Show File Extensions" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force -EA 0 }
        "Show Hidden Files" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force -EA 0 }
        "Num Lock on Startup" { Set-ItemProperty "HKU:\.DEFAULT\Control Panel\Keyboard" -Name "InitialKeyboardIndicators" -Value 2 -Force -EA 0 }
        "Center Taskbar Items" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Value 1 -Force -EA 0 }
        "Remove Settings Home Page" { Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -Value "hide:home" -Force -EA 0 }
        "Task View Button" { Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Value 0 -Force -EA 0 }
        "Verbose Logon Messages" { Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "VerboseStatus" -Value 1 -Force -EA 0 }
    }
}

# Eventos dos Botoes
$btnLang.Add_Click({
    if ($global:idioma -eq "PT") {
        $global:idioma = "EN"
        $btnLang.Text = "PORTUGUES"
        $tabEssential.Text = " Essential Tweaks "
        $tabAdvanced.Text = " Advanced Tweaks "
        $tabCustomize.Text = " Customize "
        $tabPower.Text = " Performance "
        $groupEssential.Text = "Select essential tweaks"
        $groupAdvanced.Text = "Advanced Tweaks - Use with caution!"
        $groupCustomize.Text = "Customize your Windows"
        $groupPower.Text = "Power Plans"
        $btnAddPower.Text = "Add Ultimate Performance Profile"
        $btnRemovePower.Text = "Remove Ultimate Performance Profile"
        $btnRun.Text = "RUN TWEAKS"
        $btnUndo.Text = "UNDO SELECTED"
        $lblStatus.Text = "Ready"
        $lblPower.Text = "Current plan: $(powercfg /getactivescheme)"
    } else {
        $global:idioma = "PT"
        $btnLang.Text = "ENGLISH"
        $tabEssential.Text = " Tweaks Essenciais "
        $tabAdvanced.Text = " Tweaks Avancados "
        $tabCustomize.Text = " Personalizacoes "
        $tabPower.Text = " Energia "
        $groupEssential.Text = "Selecione os tweaks essenciais"
        $groupAdvanced.Text = "Tweaks Avancados - Use com cuidado!"
        $groupCustomize.Text = "Personalize seu Windows"
        $groupPower.Text = "Planos de Energia"
        $btnAddPower.Text = "Adicionar Ultimate Performance Profile"
        $btnRemovePower.Text = "Remover Ultimate Performance Profile"
        $btnRun.Text = "APLICAR TWEAKS"
        $btnUndo.Text = "DESFAZER"
        $lblStatus.Text = "Pronto"
        $lblPower.Text = "Plano atual: $(powercfg /getactivescheme)"
    }
})

$btnRun.Add_Click({
    $btnRun.Enabled = $false
    $btnUndo.Enabled = $false
    $progressBar.Value = 0
    $lblStatus.Text = "Applying..."
    $logBox.Text = ""
    
    $selected = @()
    foreach ($cb in $checkboxesEssential.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="E"} } }
    foreach ($cb in $checkboxesAdvanced.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="A"} } }
    foreach ($cb in $checkboxesCustomize.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="C"} } }
    
    $total = $selected.Count
    $current = 0
    
    foreach ($item in $selected) {
        $current++
        $percent = ($current / $total) * 100
        $progressBar.Value = $percent
        $lblStatus.Text = "Applying: $($item.Name)"
        $logBox.AppendText("Applying: $($item.Name)`r`n")
        
        try {
            if ($item.Type -eq "E") { Apply-EssentialTweak $item.Name }
            if ($item.Type -eq "A") { Apply-AdvancedTweak $item.Name }
            if ($item.Type -eq "C") { Apply-Customize $item.Name }
            $logBox.AppendText("  OK`r`n")
            Write-Log "Applied: $($item.Name)"
        } catch {
            $logBox.AppendText("  ERROR: $_`r`n")
            Write-Log "Error: $($item.Name) - $_"
        }
        Start-Sleep -Milliseconds 50
    }
    
    $logBox.AppendText("`r`nCompleted! Log: $global:logFile`r`n")
    $lblStatus.Text = "Done!"
    $progressBar.Value = 100
    [System.Windows.Forms.MessageBox]::Show("Tweaks applied!`nRestart your computer.", "by esieme", "OK", "Information")
    
    $btnRun.Enabled = $true
    $btnUndo.Enabled = $true
})

$btnUndo.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Undo selected tweaks?", "by esieme", "YesNo", "Warning")
    if ($result -eq "Yes") {
        $btnRun.Enabled = $false
        $btnUndo.Enabled = $false
        $progressBar.Value = 0
        $lblStatus.Text = "Undoing..."
        $logBox.Text = ""
        
        $selected = @()
        foreach ($cb in $checkboxesEssential.Values) { if ($cb.Checked) { $selected += @{Name=$cb.Text; Type="E"} } }
        
        $total = $selected.Count
        $current = 0
        
        foreach ($item in $selected) {
            $current++
            $percent = ($current / $total) * 100
            $progressBar.Value = $percent
            $lblStatus.Text = "Undoing: $($item.Name)"
            $logBox.AppendText("Undoing: $($item.Name)`r`n")
            
            try {
                if ($item.Name -eq "Disable Hibernation") { powercfg /h on }
                if ($item.Name -eq "Disable Telemetry") { Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 3 -Force -EA 0 }
                $logBox.AppendText("  OK`r`n")
            } catch {
                $logBox.AppendText("  ERROR`r`n")
            }
            Start-Sleep -Milliseconds 50
        }
        
        $lblStatus.Text = "Undone!"
        $progressBar.Value = 100
        [System.Windows.Forms.MessageBox]::Show("Tweaks undone!", "by esieme", "OK", "Information")
        
        $btnRun.Enabled = $true
        $btnUndo.Enabled = $true
    }
})

$btnAddPower.Add_Click({
    try {
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>&1 | Out-Null
        powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        $lblPower.Text = if ($global:idioma -eq "PT") { "Plano atual: $(powercfg /getactivescheme)" } else { "Current plan: $(powercfg /getactivescheme)" }
        $logBox.AppendText("Ultimate Performance Profile activated`r`n")
    } catch { $logBox.AppendText("Error activating`r`n") }
})

$btnRemovePower.Add_Click({
    try {
        powercfg -delete e9a42b02-d5df-448d-aa00-03f14749eb61
        $lblPower.Text = if ($global:idioma -eq "PT") { "Plano atual: $(powercfg /getactivescheme)" } else { "Current plan: $(powercfg /getactivescheme)" }
        $logBox.AppendText("Ultimate Performance Profile removed`r`n")
    } catch { $logBox.AppendText("Error removing`r`n") }
})

Write-Log "Tool started by esieme"
$form.ShowDialog() | Out-Null
