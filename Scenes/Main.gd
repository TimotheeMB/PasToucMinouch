extends Node2D


var player = preload("res://Scenes/Player.tscn")

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connected_to_server", self, "_connected_to_server")


func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	create_player(id)


func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	create_player(get_tree().get_network_unique_id())


func create_player(id):
	var p = player.instance()
	add_child(p)
	p.initialize(id)


func _on_Host_pressed():
	Net.initialize_server()
	create_player(get_tree().get_network_unique_id())
	$CanvasLayer/UI.visible = false


func _on_Join_pressed():
	Net.initialize_client($IP.text)
	$CanvasLayer/UI.visible = false
