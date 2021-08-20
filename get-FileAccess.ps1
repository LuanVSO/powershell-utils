[CmdletBinding()]
param (
	# path to files or folders to get access
	[Parameter(Mandatory = $true,
		Position = 0,
		HelpMessage = "path to folder or file to get access"
	)]
	[alias("PSPath")]
	[ValidateNotNullOrEmpty()]
	[string]
	$Path
)

$ErrorActionPreference = 'Stop'

$ar = @()

$acl = Get-Acl $Path
if (test-path $path -PathType Leaf) {
	$ar = New-Object  System.Security.AccessControl.FileSystemAccessRule(
		[System.Security.Principal.WindowsIdentity]::GetCurrent().Name, "FullControl", "Allow")
}
else {
	$ar = New-Object System.Security.AccessControl.FileSystemAccessRule(
		[System.Security.Principal.WindowsIdentity]::GetCurrent().Name,
		"FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
}

Write-Debug ("{0} {1}" -f $ar, $acl)
$acl.AddAccessRule($ar)

set-acl $Path $acl;
