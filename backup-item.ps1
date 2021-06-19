[CmdletBinding()]
param (
	# path to a file/folder
	[Parameter()]
	[string]
	$file
)
$ErrorActionPreference = 'Stop'

$newpath = "$env:OneDriveConsumer\settings\$((Get-ItemProperty $file).Name)"

Move-Item $file $newpath

if (test-path $newpath -PathType Leaf) {
	New-Item $file -ItemType SymbolicLink -Value $newpath
}
else {
	New-Item $file -ItemType Junction -Value $newpath
}
