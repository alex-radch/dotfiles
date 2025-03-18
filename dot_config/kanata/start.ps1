$KanataPath=(get-command kanata_winIOv2.exe).Path
$KanataConfigPath="$PSScriptRoot\kanata.kbd"
C:\Windows\system32\conhost.exe --headless $KanataPath --cfg $KanataConfigPath