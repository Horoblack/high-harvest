extends Node3D

@onready var model: MeshInstance3D = $Skeleton3D/model
@onready var eyes = $Skeleton3D/eyes
@onready var anim = $AnimationPlayer
@onready var respawntimer = $respawntimer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var pl : Player

var active : bool = true

var targettransparency = 1

var distance = 40

func _ready():
	pl = get_tree().get_first_node_in_group("player")
	model.transparency = 1
	eyes.transparency = 1
	spawn()
	Savedata.cansave += 1

func spawn():
	if(distance == 10):
		Savedata.cansave -= 1
		queue_free()
	audio.play()
	var randpos = pl.basis.z * distance
	global_position = pl.global_position + Vector3(randpos.x,0,randpos.z)
	active = true
	visible = true
	targettransparency = -2
	distance -= 5
	distance = clamp(distance,20,100)

func _process(delta):
	var dir = global_position.direction_to(pl.global_position)
	if(global_position.distance_to(pl.global_position) < 1):
		pl.ragdoll(50)
		queue_free()
		Savedata.cansave -= 1
	basis = basis.looking_at(-dir)
	global_position += dir * delta * 6
	if(active):
		if(InfoChecker.visibletoplayer(global_position)):
			active = false
	else:
		if(targettransparency <= 1):
			targettransparency += delta * 5
			model.transparency = targettransparency
			eyes.transparency = targettransparency
		else:
			visible = false
			if(respawntimer.is_stopped()):
				respawntimer.start()
