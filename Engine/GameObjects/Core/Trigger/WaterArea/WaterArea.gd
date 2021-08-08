extends Area

export(NodePath) var surface : NodePath

func freeze():
	get_node(surface).freeze()

func unfreeze():
	get_node(surface).unfreeze()
