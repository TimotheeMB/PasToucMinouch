extends Button

func _ready():
	for ip in IP.get_local_addresses():
		if "192." in ip :
			$IP.text = "IP: " + ip

func host():
	Net.initialize_server()
