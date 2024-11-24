extends Control

@onready var mainscreen = $mainscreen
@onready var savescreen = $saves


const NEWGAME = preload("res://prefabs/uistuff/newgame_ui.tscn")
const SAVESLOT = preload("res://prefabs/uistuff/save_slot_ui.tscn")
@onready var savecontainer = $saves/ColorRect/VBoxContainer

func _ready():
	backtomain()
	for n in Savedata.datacount():
		var sl = SAVESLOT.instantiate()
		sl.file = n
		savecontainer.add_child(sl)
		sl.clicked.connect(loadgame)
	var ng = NEWGAME.instantiate()
	ng.gui_input.connect(newgame)
	savecontainer.add_child(ng)
	

func loadgame(id:int):
	Savedata.curfile = id
	Savedata.load_data()
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func newgame(event):
	if(event.is_action_pressed("leftclick")):
		Savedata.curfile = Savedata.datacount()
		Savedata.load_data()
		get_tree().change_scene_to_file("res://scenes/world.tscn")

func startbutton():
	mainscreen.visible = false
	savescreen.visible = true

func optionsbutton():
	pass

func quitbutton():
	get_tree().quit()

func backtomain():
	mainscreen.visible = true
	savescreen.visible = false
