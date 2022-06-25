extends RigidBody



func interact():
	var apple_tree = get_tree().root.get_node("Game/Levels/Level1/AppleTree_TypeA")
	apple_tree.tree_hit()
