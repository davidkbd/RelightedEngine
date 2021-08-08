extends Spatial

func idle():
	$AnimationPlayer.play("Idle-loop")

func fly():
	$AnimationPlayer.play("Fly-loop")

func walk():
	$AnimationPlayer.play("Walk-loop")
