extends RigidBody3D
class_name boxlid

signal unlid

func grabtrigger(bod):
	unlid.emit()
