. .\ordenacao-base.ps1
$gaps = 701, 301, 132, 57, 23, 10, 5, 2, 1

function shellSort($a) {
	foreach ($gap in $gaps) {
		for ($i = $gap; $i -lt $a.Count; $i++) {
			$temp = $a[$i]
			for ($j = $i; $j -ge $gap -and ($a[$j - $gap] -lt $temp) ; $j -= $gap) {
				$a[$j] = $a[$j - $gap]
			}
			$a[$j] = $temp

			get-arrStr($a)
		}
	}
}

shellSort $namArr
