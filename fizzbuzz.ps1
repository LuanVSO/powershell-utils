function fizz($a) {
	$valuesToCheck = @(
		@{num = 3; str = "Fizz" },
		@{num = 5; str = "Buzz" }
	)

	$out = ""
	foreach ($pair in $valuesToCheck) {
		if ($a % $pair.num -eq 0) {
			$out += $pair.str
		}
	}
	if ($out.Length -ne 0) { $out } else { $a }
}

0..101 | ForEach-Object { fizz $_ }
