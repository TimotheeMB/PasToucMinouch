extends KinematicBody2D

const SPEED = 50

export(Resource) var bonome_monte
export(Resource) var bonome_descend
export(Resource) var bonome_profil

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
		
		var dir = Vector2(x_input, y_input).normalized()
		
		move_and_slide(dir * SPEED)
		
		if dir == Vector2(0,0):
			$Sprite.speed_scale = 0
			$Particles2D.emitting = false
		else:
			$Sprite.speed_scale = 1
			$Particles2D.emitting = true
			$Particles2D.process_material.set_direction(Vector3(-dir.x,-dir.y,0))
			
		if dir == Vector2(0,1):
			$Sprite.flip_h = false
			if $Sprite.frames != bonome_descend:
				$Sprite.frames = bonome_descend
		elif dir == Vector2(1,0):
			$Sprite.flip_h = false
			if $Sprite.frames != bonome_profil:
				$Sprite.frames = bonome_profil
		elif dir == Vector2(0,-1):
			$Sprite.flip_h = false
			if $Sprite.frames != bonome_monte:
				$Sprite.frames = bonome_monte
		elif dir == Vector2(-1,0):
			$Sprite.flip_h = true
			if $Sprite.frames != bonome_profil:
				$Sprite.frames = bonome_profil

			
		rpc_unreliable("update_position", position,rotation,$Sprite.speed_scale)

remote func update_position(pos,rot,sp):
	position = pos
	rotation = rot
	$Sprite.speed_scale = sp
