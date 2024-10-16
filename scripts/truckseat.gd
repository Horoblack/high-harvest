extends StaticBody3D

var seated
@onready var seatpos = $seatpos

func grabtrigger(pl : Player):
	pl.reparent(self)
	var p : CollisionShape3D
	pl.frozen = true
	pl.crouchheight(true)
	seated = pl
	pl.global_position = seatpos.global_position
	pl.global_rotation = global_rotation
	#add_collision_exception_with(seated)

func _input(event):
	if(seated != null && event.is_action_pressed("jump")):
		seated.reparent(get_tree().current_scene)
		#remove_collision_exception_with(seated)
		#remove_child(seated)
		seated.frozen = false
		seated = null
