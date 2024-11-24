extends ColorRect

var file : int = 0
@onready var label = $Label
@onready var label2 = $Label2

func _ready():
	label.text = "SAVE " + str(file+1)
	var data = Savedata.loadonce(file)
	if(data != null):
		label2.text = timetransition(data["playtime"])

func deletesave():
	Savedata.delete_data(file)

func timetransition(t : float) -> String:
	var minute = str(floor(t/60)).pad_zeros(2).pad_decimals(0)
	var hour = str(floor(floor(t/60)/60)).pad_zeros(2).pad_decimals(0)
	var seconds = str(fmod(t, 60)).pad_zeros(2).pad_decimals(0)
	return hour + ":" + minute + ":" + seconds

signal clicked(fil)
func _on_gui_input(event):
	if(event.is_action_pressed("leftclick")):
		clicked.emit(file)
