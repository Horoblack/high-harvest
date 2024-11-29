extends Node

const SAVEFILE = "user://saves/SAVEFILE%s.save"

var gamedata = {}

var curfile = 0

func _ready():
	load_data()

func datacount():
	var testfile = 0
	while true:
		if(FileAccess.file_exists(SAVEFILE % testfile)):
			testfile += 1
		else:
			break
	return testfile

func load_data():
	if(!DirAccess.dir_exists_absolute("user://saves")):
		DirAccess.make_dir_absolute("user://saves")
	if(curfile == -1):
		return
	
	if(FileAccess.file_exists(SAVEFILE%curfile)):
		var file = FileAccess.open(SAVEFILE%curfile, FileAccess.READ)
		gamedata = file.get_var()
	else:
		gamedata = {
			"playtime":0.0,
			"day": 0,
			"timeofday": 1200,
			"money": 50,
			"playerscene":0,
			"player": [Vector3(-19,0.5,-23), Vector3(0,deg_to_rad(180),0), 50,50,[], [],[]],
			"objects0": [
				["pickup",Vector3(-18, 2.15, -29.28), Vector3(0, 0, 0), "calendar", {  }], 
				["pickup",Vector3(-18, 2.4, -29.25), Vector3(0, 0, 0), "nail", {  }], 
				["pickup",Vector3(-11.5, 2.57, -17), Vector3(0, deg_to_rad(90), 0), "lantern", {  }], 
				["pickup",Vector3(-27.3, 1.6, -20.7), Vector3(0, deg_to_rad(90), 0), "pillow", {  }], 
				["pickup",Vector3(-27.908, 0.923, -31.43), Vector3(deg_to_rad(-60), deg_to_rad(-90), 0), "lock", {  }], 
				["other", "table", Vector3(-12.1, 1.4, -28), Vector3(0, 0, 0)], 
				["other", "truck", Vector3(-32, .5, -25), Vector3(0, deg_to_rad(180), 0)], 
				["other", "bedframe", Vector3(-26.5, 1.1, -20.7), Vector3(0, deg_to_rad(90), 0)], 
				["other", "mattress", Vector3(-26.5, 1.5, -20.7), Vector3(0, deg_to_rad(90), 0)], 
				["other", "stove", Vector3(-27, 1, -27), Vector3(0, deg_to_rad(-90), 0),{"fuel":5.5}], 
				],
			"objects1": [
				
			],
			"stocks": {
					"carrot":1,
					"tomato":1,
				},
			"seenevents": {
				
			}
		}
	return gamedata

func save_data():
	if(curfile != -1):
		var file = FileAccess.open(SAVEFILE % curfile, FileAccess.WRITE)
		file.store_var(gamedata)

func loadonce(dat : int):
	if(FileAccess.file_exists(SAVEFILE%dat)):
		return FileAccess.open(SAVEFILE%dat, FileAccess.READ).get_var()
	else:
		return null

func delete_data(dat : int):
	if(FileAccess.file_exists(SAVEFILE%dat)):
		DirAccess.remove_absolute(SAVEFILE%dat)
		var list = DirAccess.get_files_at("user://saves")
		for n in list.size():
			DirAccess.rename_absolute("user://saves/"+list[n], SAVEFILE%n)
			
