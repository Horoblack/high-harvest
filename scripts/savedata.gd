extends Node

const SAVEFILE = "user://SAVEFILE.save"

var gamedata = {}

func _ready():
	load_data()

func load_data():
	if(FileAccess.file_exists(SAVEFILE)):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		gamedata = file.get_var()
	else:
		gamedata = {
			"objects": [
				#[Vector3(0, 1.75, -4.25), Vector3(0, 0, 0), "shovel", {  }], 
				#[Vector3(-2.25, 0.5, -4.5), Vector3(0, 0, 0), "carrot", {  }], 
				#[Vector3(-2.43005, 0, -2.17649), Vector3(0, 0, 0), "carrotseed", {  }], 
				#[Vector3(-2.50922, 0, -1.41715), Vector3(0, 0, 0), "carrotseed", {  }], 
				#[Vector3(-1.5, 0.25, 0), Vector3(0, 0, 0), "wateringcan", {  }]
				]
		}
	return gamedata

func _input(event):
	if(event is InputEventKey):
		if(event.keycode == KEY_DELETE):
			delete_data()

func save_data():
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	file.store_var(gamedata)

func delete_data():
	if(FileAccess.file_exists(SAVEFILE)):
		DirAccess.remove_absolute(SAVEFILE)
