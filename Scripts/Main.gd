extends Node2D


var player = preload("res://Scenes/Player.tscn")
var enemy = preload("res://Scenes/Enemy.tscn")

var nb_of_player := 1

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	randomize()



func _player_connected(id) -> void:
	create_player(id)
	nb_of_player += 1


func create_player(id):
	var p = player.instance()
	add_child(p)
	p.initialize(id)



func _on_Host_pressed():
	Net.initialize_server()
	create_player(get_tree().get_network_unique_id())
	$CanvasLayer/UI.visible = false


func _on_Join_pressed():
	Net.initialize_client($CanvasLayer/UI/Join/IP.text)
	create_player(get_tree().get_network_unique_id())
	$CanvasLayer/UI.visible = false


func _on_Timer_timeout():
	if Net.is_host:
		var e = enemy.instance()
		add_enemy(e)
		e.position = Vector2(randf()*300,randf()*300)
		if nb_of_player > 1:
			rpc("add_enemy",e)

func add_enemy(enemy):
	$Enemies.add_child(enemy)
