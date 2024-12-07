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
				#["pickup",Vector3(-18, 2.15, -29.28), Vector3(0, 0, 0), "calendar", {  }], 
				#["pickup",Vector3(-18, 2.4, -29.25), Vector3(0, 0, 0), "nail", {  }], 
				#["pickup",Vector3(-11.5, 2.57, -17), Vector3(0, deg_to_rad(90), 0), "lantern", {  }], 
				#["pickup",Vector3(-27.3, 1.6, -20.7), Vector3(0, deg_to_rad(90), 0), "pillow", {  }], 
				["pickup",Vector3(-27.908, 0.923, -31.43), Vector3(deg_to_rad(-60), deg_to_rad(-90), 0), "lock", {  }], 
				#["pickup",Vector3(-26.8, 1.6, -26.8), Vector3(0, 0, 0), "pan", {  }], 
				#["other", "table", Vector3(-12.1, 1.4, -28), Vector3(0, 0, 0)], 
				#["other", "truck", Vector3(-32, .5, -25), Vector3(0, deg_to_rad(180), 0)], 
				#["other", "bedframe", Vector3(-26.5, 1.1, -20.7), Vector3(0, deg_to_rad(90), 0)], 
				#["other", "mattress", Vector3(-26.5, 1.5, -20.7), Vector3(0, deg_to_rad(90), 0)], 
				#["other", "stove", Vector3(-27, 1, -27), Vector3(0, deg_to_rad(-90), 0),{"fuel":5.5}], 
				#["other", "wickerman1", Vector3(-5, 1.7, -5), Vector3(0, deg_to_rad(-180), 0)], 
				],
			"objects1": [
				["pickup",Vector3(0.7, 0.68, -5.82), Vector3(0, 0, 0), "lock", {  }], 
				["pickup",Vector3(-2, 0.5, -5.6), Vector3(deg_to_rad(75), 0, 0), "shotgun", {  }], 
				["other", "wickerman1", Vector3(3.3, 1.5, -18.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(12.8, 1.5, -27), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(18.7, 1.5, -43.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-27.2, 1.5, -44), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(4.3, 1.5, -51.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(22.8, 1.5, -59), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(40.3, 1.5, -11.5), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(40.3, 1.5, -35), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-15.2, 1.5, -60), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(7.3, 1.5, -60), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(-28.2, 1.5, -68), Vector3(0, 0, 0)], 
				["other", "wickerman1", Vector3(31.3, 1.5, -83), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(-15, 0.5, -20), Vector3(0, 0, 0)], 
				["pickup",Vector3(-15, 1.25, -20), Vector3(0, 0, 0), "oilbottle", {  }], 
				["other", "woodenbox", Vector3(27, 0.5, -20), Vector3(0, 0, 0)], 
				["other", "woodenbox", Vector3(28.5, 0.5, -21), Vector3(0, deg_to_rad(-15), 0)], 
				["pickup",Vector3(27, 1.25, -20), Vector3(0, 0, 0), "turnip", {  }], 
				["pickup",Vector3(40.3, 1.5, -35.4), Vector3(deg_to_rad(180), 0, 0), "knife", {  }], 
			],
			"stocks": {
					"carrot":1,
					"tomato":1,
					"turnip":1,
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
			
