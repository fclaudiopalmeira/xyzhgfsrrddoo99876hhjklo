Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
If(-not(Get-InstalledModule PowershellGet -ErrorAction silentlycontinue)){
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Confirm:$False -Force
};
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord;
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord;
If(-not(Get-InstalledModule PowershellGet -ErrorAction silentlycontinue)){
    Install-Module PowershellGet -Confirm:$False -Force
};
Install-WindowsFeature -name Web-Server -IncludeAllSubFeature -IncludeManagementTools;
exit 0;