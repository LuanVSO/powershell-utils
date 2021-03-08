function get-shortProcess ([string]$name) {
	do {
		$pwsc = get-process -ProcessName $name -ErrorAction SilentlyContinue
	}until($pwsc)
	return $pwsc
}