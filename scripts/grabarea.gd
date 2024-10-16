extends Node3D

signal grabbed(bod)
func grabtrigger(bod):
	grabbed.emit(bod)
