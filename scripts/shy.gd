extends MeshInstance3D

var player
var speed : float = .1

@onready var timer = $Timer

var seen : bool = false
var delete : bool = false

func _ready():
	player = get_tree().get_first_node_in_group("player")
	#reparent(player)

func _process(delta):
	global_position = lerp(global_position, player.global_position + (player.basis.z) + Vector3(0,1.5,0), .08)
	if(InfoChecker.visibletoplayer(global_position) && speed < .2):
		if(!seen):
			seen = true
			timer.start()
		speed += delta
	elif(!InfoChecker.visibletoplayer(global_position) && speed > 0):
		speed -= delta
		if(delete):
			queue_free()


func _on_timer_timeout():
	delete = true
