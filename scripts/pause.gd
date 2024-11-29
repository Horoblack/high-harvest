extends Control

@onready var ps = $ps
@onready var label = $Label

var held : bool = false

var curhold : float = 0
var targethold : float = .2

func resettarget():
	targethold = .2

func _ready():
	#await get_tree().process_frame
	ObjectManager.call_deferred("deserializeall")
	ps.visible = false

func _process(delta):
	label.self_modulate.a = curhold/targethold
	if(held):
		if(!ps.visible):
			curhold += delta
			if(curhold >= targethold):
				pausegame()
				curhold = 0
				held = false
		else:
			unpausegame()
			held = false
	elif(curhold > 0):
		curhold -= delta * 3

func _input(event):
	if(event.is_action_pressed("pause")):
		held = true
	if(event.is_action_released("pause")):
		held = false

func pausegame():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	ps.visible = true
	get_tree().paused = true

func unpausegame():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ps.visible = false
	get_tree().paused = false

func save():
	ObjectManager.serializeall()
	Savedata.save_data()

func quickload():
	unpausegame()
	Savedata.load_data()
	get_tree().reload_current_scene()

func quitgame():
	unpausegame()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
