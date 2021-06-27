[CmdletBinding()]
param (
	# Specifies a path to the iso file
	[Parameter(
		Mandatory = $true,
		Position = 0,
		ParameterSetName = "ParameterSetName",
		ValueFromPipeline = $false,
		ValueFromPipelineByPropertyName = $true,
		HelpMessage = "Path to iso file")]
	[Alias("PSPath")]
	[ValidateNotNullOrEmpty()]
	[string]
	$SourceIsoPath,
	# Parameter help description
	[Parameter(Mandatory = $true,
		Position = 1, HelpMessage = "windows product key")]
	[string]
	$ProductKey
)

$ErrorActionPreference = 'Stop'

# https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
Get-Command oscdimg.exe, 7z.exe -ErrorAction Stop
Test-Path ~\Downloads\appraiserres.dll

$SourceIsoPath = convert-Path $SourceIsoPath

$SourceIsoPath
Push-Location temp:

& {
	Export-WindowsDriver -Online -Destination .\drivers\
	Push-Location .\drivers
	remove-item -Recurse -Force .\arduino*, .\gameflt*, .\vigembus*, .\prnms*, .\xvdd*, .\genuino*, .\gameflt*, .\linino*, .\adafruit*
	Pop-Location
}

# https://stackoverflow.com/questions/56869181/how-to-extract-iso-file-with-powershell-2-0
7z.exe x -y -o".\expandediso" "$SourceIsoPath"

mkdir -Path .\image
Mount-WindowsImage -Path .\image -ImagePath ".\expandediso\sources\install.wim" -Index 4
Set-WindowsProductKey -ProductKey $ProductKey -Path .\image
Add-WindowsDriver -Path .\image -Driver .\drivers\ -Recurse
Expand-Archive -Path "$env:OneDriveConsumer\settings\Bypass Insider Block.zip" -DestinationPath '.\image\Users\All Users\Desktop\'
Enable-WindowsOptionalFeature -Path .\image -FeatureName "Containers", "Microsoft-Hyper-V-All", "Microsoft-Windows-Subsystem-Linux", "Containers-DisposableClientVM", "HypervisorPlatform", "VirtualMachinePlatform", "HostGuardian"
foreach ($item in "MathRecognizer~~~~", "OpenSSH.Client~~~~") {
	Add-WindowsCapability -Path .\image -Name $item
}
dismount-WindowsImage -Path .\image -Save -CheckIntegrity

Remove-Item -Path .\expandediso\sources\appraiserres.dll -Force
Copy-Item -Path ~\Downloads\appraiserres.dll -Destination .\expandediso\sources\

# https://winaero.com/how-to-install-windows-11-without-tpm-2-0/
cmd /c "oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,b$(Convert-Path .\expandediso\boot\etfsboot.com)#pEF,e,b$(Convert-Path .\expandediso\efi\Microsoft\boot\efisys.bin) $(Convert-Path .\expandediso) $(Convert-Path ~\)\CustomWindows.iso"

Pop-Location
