extends Node3D

@onready var sub_viewport = $model/Sprite3D/SubViewport
@onready var label = $model/Sprite3D/SubViewport/Label

var properties

func _ready():
	properties = get_meta("obj").customproperties
	label.text = "CONGRATULATIONS.\n\n%s\n$%.2f" % [Library.timetransition(properties["timeplayed"]), properties["moneyearned"]]

func _process(delta):
	sub_viewport.size = label.size
