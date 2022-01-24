extends KinematicBody2D

const SPEED = 200


func initialize(id):
	name = str(id)
	set_network_master(id)
	if id == get_tree().get_network_unique_id():
		$Camera2D.current = true
	else:
		modulate = Color8(255, 0, 0, 255)
	#print("Player name is " + name)

func _physics_process(delta):
	if is_network_master():
		var velocity = Vector2()
		if Input.is_action_pressed("ui_right"):
			velocity.x = 1
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -1
		else:
			velocity.x = 0
		if Input.is_action_pressed("ui_down"):
			velocity.y = 1
		elif Input.is_action_pressed("ui_up"):
			velocity.y = -1
		else:
			velocity.y = 0
		
		velocity = velocity.normalized()*SPEED
		move_and_slide(velocity)
		if velocity != Vector2(0,0):
			$Sprite.rotation = velocity.angle()+PI/2
			$Sprite.speed_scale = 1
		else:
			$Sprite.speed_scale = 0
		rpc_unreliable("update_position", position,$Sprite.rotation,$Sprite.speed_scale)

remote func update_position(pos,rot,sp):
	position = pos
	$Sprite.rotation = rot
	$Sprite.speed_scale = sp
