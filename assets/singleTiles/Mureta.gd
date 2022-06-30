extends StaticBody2D

export(String, "blue","green","red","yellow","") var corInicio

func _ready() -> void:
	corzinhaBonitinha();

func corzinhaBonitinha():
	match corInicio:
		"red":
			$Sprite.modulate = Color(1,0,0)
			#$Label.text = ".mureta{color:red;}"
		"blue":
			$Sprite.modulate = Color(0,0,1)
			#$Label.text = ".mureta{color:blue;}"
		"green":
			$Sprite.modulate = Color(0,1,0)
			#$Label.text = ".mureta{color:green;}"
		"yellow":
			$Sprite.modulate = Color(1,1,0)
			#$Label.text = ".mureta{color:yellow;}"
		"":
			$Sprite.modulate = Color(1,1,1)
			#$Label.text = ".mureta{}"
