extends Node2D

func _ready():
	get_tree().connect("network_peer_connected",self,"create_player")
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	if get_tree().is_network_server():
		create_player(get_tree().get_network_unique_id())
		
func create_players():
	for id in Net.peer_ids:
		create_player(id)
	create_player(Net.net_id)
	
func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	create_player(get_tree().get_network_unique_id())

func create_player(id):
	#print("Player with ID " + str(id) + " initialized")
	var p = preload("res://Scenes/Player.tscn").instance()
	add_child(p)
	p.initialize(id)

