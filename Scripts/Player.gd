extends KinematicBody2D

const SPEED = 200


func initialize(id):
	name = str(id)
	set_network_master(id)
	if id == get_tree().get_network_unique_id():
		$Camera2D.current = true
	else:
		modulate = Color8(255, 0, 0, 255)

func _physics_process(_delta):
	if is_network_master():
		var x_input = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
		var y_input = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
		
		var dir = Vector2(x_input, y_input).normalized().rotated(rotation+PI/2)
		
		move_and_slide(dir * SPEED)
		
		look_at(get_global_mouse_position())

		if dir != Vector2(0,0):
			$Sprite.speed_scale = 1
		else:
			$Sprite.speed_scale = 0
			
		rpc_unreliable("update_position", position,rotation,$Sprite.speed_scale)

remote func update_position(pos,rot,sp):
	position = pos
	rotation = rot
	$Sprite.speed_scale = sp
