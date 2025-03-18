$StartupPath="HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
$ProgramName="Kanata"
$KanataPath=(get-command kanata_winIOv2.exe).Path
$KanataConfigPath="$PSScriptRoot\kanata.kbd"
$StartupCommand="""C:\Windows\system32\conhost.exe"" --headless ""$KanataPath"" --cfg ""$KanataConfigPath"""
Set-ItemProperty -LiteralPath "$StartupPath" -Name "$ProgramName" -Value "$StartupCommand"