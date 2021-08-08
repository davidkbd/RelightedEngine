extends Node

func round_1_decimal(n : float) -> float:
	var r = round(n * 10.0) * .1

	return r
