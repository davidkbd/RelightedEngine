extends Node

func timestamp(seconds : int) -> String:
	var secs = seconds % 60
	var mins = seconds / 60
	return ("%02d" % mins) + ":" + ("%02d" % secs)

func timestamp_float(seconds : float) -> String:
	var secs = int(seconds) % 60
	var mins = seconds / 60
	return ("%02d" % mins) + ":" + ("%02.1f" % secs)
