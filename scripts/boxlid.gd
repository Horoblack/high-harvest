extends basepickup
class_name boxlid

signal unlid

func grabtrigger(bod):
	unlid.emit()
