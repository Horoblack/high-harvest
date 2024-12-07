extends RigidBody3D
class_name basepickup
@export var sound : AudioStream
const fallback = preload("res://sounds/collision.wav")

var soundplayer : AudioStreamPlayer3D

var lastspeed : Vector3

func _ready():
	soundplayer = AudioStreamPlayer3D.new()
	add_child(soundplayer)
	soundplayer.stream = sound if sound != null else fallback
	body_entered.connect(makesound)

func _physics_process(delta):
	lastspeed = linear_velocity

func makesound(b):
	if(lastspeed.length() > 1):
		soundplayer.play()
