extends GPUParticles3D

func _ready():
	emitting = true

func end():
	queue_free()
