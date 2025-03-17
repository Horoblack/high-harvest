extends basepickup
class_name vinyl

@export var song : AudioStream

signal unlid

func grabtrigger(bod):
	unlid.emit()
