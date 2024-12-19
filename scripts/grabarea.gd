extends Node3D
class_name grabarea

@export var hovertext : String = ""

signal grabbed(bod)
func grabtrigger(bod):
	grabbed.emit(bod)

func info():
	return hovertext
