extends Area2D








func _on_Exit_body_entered(body: Node) -> void:
	var novaCena = load("res://ux/Vitoria.tscn").instance()
	get_tree().current_scene.add_child(novaCena)
	print('teste')
