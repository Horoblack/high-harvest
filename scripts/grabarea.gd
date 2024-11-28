extends Node3D
class_name grabarea
signal grabbed(bod)
func grabtrigger(bod):
	grabbed.emit(bod)
