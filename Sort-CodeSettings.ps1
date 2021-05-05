$CodeSettings = Get-Content "$env:APPDATA\Code\User\settings.json" | ConvertFrom-Json

$ShortedByProperties = [ordered]@{}

Get-Member -Type NoteProperty -InputObject $CodeSettings | Sort-Object name | ForEach-Object { $ShortedByProperties[$_.Name] = $CodeSettings.$($_.Name) }

$File = New-Object PSCustomObject
Add-Member -InputObject $File -NotePropertyMembers $ShortedByProperties

$File | ConvertTo-Json -Depth 100 | Set-Content "$env:APPDATA\Code\User\settings.json"