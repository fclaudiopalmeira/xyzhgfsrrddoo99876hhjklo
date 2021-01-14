#New-Item -Path "C:\" -Name "GlobalScoopApps" -ItemType "directory"
New-Item -Path "C:\" -Name "Applications\Scoop" -ItemType "directory"

$env:SCOOP='C:\Applications\Scoop\'
#$Env:Path +="C:\Applications\Scoop\shims"
[Environment]::SetEnvironmentVariable('SCOOP', $env:SCOOP, 'Machine')
#$env:SCOOP_GLOBAL='C:\GlobalScoopApps'
$env:SCOOP_GLOBAL=$env:ProgramData
[Environment]::SetEnvironmentVariable('SCOOP_GLOBAL', $env:SCOOP_GLOBAL, 'Machine')
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

## Adds scoop to the path in environment variables
$path = [Environment]::GetEnvironmentVariable('Path', 'Machine')
$newpath = $path + ';C:\Applications\Scoop\shims'
[Environment]::SetEnvironmentVariable("Path", $newpath, 'Machine')
## End of the Environment variables part

scoop install python