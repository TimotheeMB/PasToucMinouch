extends Node

const RPC_PORT = 31400
const MAX_PLAYERS = 10

var is_host = false

func initialize_server():
	is_host = true
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(RPC_PORT, MAX_PLAYERS)
	get_tree().network_peer = peer

func initialize_client(server_ip):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(server_ip, RPC_PORT)
	get_tree().network_peer = peer

