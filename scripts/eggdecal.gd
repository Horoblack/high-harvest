extends Decal

@export var lifetime : float = 10
var lftm

func _ready():
	lftm = lifetime

func _process(delta):
	lftm -= delta
	modulate.a = lftm / (lifetime/2)
	if(lftm <= 0):
		queue_free()
