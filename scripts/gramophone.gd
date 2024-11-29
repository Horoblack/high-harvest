extends RigidBody3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var grab: grabarea = $StaticBody3D
var data : InventoryObject
func _ready() -> void:
	data = get_meta("obj")
	if(data.customproperties.has("playing")):
		audio.playing = data.customproperties["playing"]
	else:
		audio.playing = true
	add_collision_exception_with(grab)

func trigger(pl):
	audio.playing = !audio.playing
	data.customproperties["playing"] = audio.playing
	set_meta("obj",data)
