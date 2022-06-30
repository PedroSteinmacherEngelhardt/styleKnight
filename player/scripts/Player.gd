extends KinematicBody2D

var direction = Vector2()
var velocity = Vector2()
var speed = 280

var player_control = true;
var alive = true;

func _process(delta):
	walk(delta);
	animation();


func walk(delta):
	if player_control:
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left");
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
		
	velocity = direction.normalized() * speed;
	velocity = move_and_slide(velocity);

func animation():
	if alive:
		if Input.is_action_pressed("ui_right"):
			$Sprite.play("run");
			$Sprite.set_flip_h(false);
		elif Input.is_action_pressed("ui_left"):
			$Sprite.play("run");
			$Sprite.set_flip_h(true);
		else:
			$Sprite.play("idle");
	else:
		$Sprite.play("dead")


func process_class(a):
	var count = 0
	
	for  i in (a.size() - 1)/2:
		count+=1
		i+=count
		
		match a[i]:
			"color":
				validade_color(a[i+1])
				
			"height":
				scale.y = int(a[i+1])
			
			"width":
				scale.x = int(a[i+1])
			
			_:
				break


func validade_color(color):
	match color:
		"red":
			$Sprite.modulate = Color("EB0909") 
		"blue":
			$Sprite.modulate = Color("1726E0") 
		"green":
			$Sprite.modulate = Color("02C811") 
		"yellow":
			$Sprite.modulate = Color(1,1,0) 
		1:
			$Sprite.modulate = Color(1,1,1)
		_:
			$Sprite.modulate = Color(color)


func _on_TextEdit_text_changed() -> void:
	if $Sprite.modulate == Color(1,1,0): # yellow
		var novaCena = load("res://ux/Vitoria.tscn").instance()
		get_tree().current_scene.add_child(novaCena)
		print("AUTO VITORIA HEHE");
		

func _on_TextEdit_focus_entered() -> void:
	player_control = false;

func _on_TextEdit_focus_exited() -> void:
	player_control = true;

func dor(var enemyposx, enemyposy):
	print("dor")
	set_modulate(Color(1,0.3,0.3,0.5))
	player_control = false
	alive = false;
	
	if position.x < enemyposx:
		direction.x = -1
	elif position.x > enemyposx:
		direction.x = 1
	if position.y < enemyposy:
		direction.y = 1
	elif position.y > enemyposy:
		direction.y = -1
	speed = 500
