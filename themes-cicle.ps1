$ErrorActionPreference = 'Stop'
ColorTool.exe -x -c -a

function map_ranges($input_start, $input_end, $out_start, $out_end, $index) {
	$num_elements_out = ($out_end - $out_start) + 1
	$num_elements_in = ($input_end - $input_start) + 1
	# https://stackoverflow.com/a/5732390/12406510
	return [math]::floor(($num_elements_out / $num_elements_in) * $index + $out_start)
}

$themes = (Get-Command ColorTool.exe | Split-Path -parent |
	Join-Path -ChildPath "schemes" | Get-ChildItem).Name
for ($i = 0; $i -lt $themes.Count; $i++) {
	ColorTool.exe -x -q $themes[$i]
	Write-Progress -Activity "theme:" -Status $themes[$i] -PercentComplete (map_ranges 0 $themes.Count 1 100 $i)
	switch ([console]::ReadKey($true).KeyChar) {
		'q' { break; }
		'f' { $i += 9 }
		'b' { $i = $themes.count - 2 }
		Default {}
	}
}
