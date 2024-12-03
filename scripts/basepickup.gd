extends RigidBody3D
class_name basepickup
@export var sound : AudioStream
const fallback = preload("res://sounds/collision.wav")

var soundplayer : AudioStreamPlayer3D

func _ready():
	soundplayer = AudioStreamPlayer3D.new()
	add_child(soundplayer)
	soundplayer.stream = sound if sound != null else fallback
	body_entered.connect(makesound)

func makesound(b):
	soundplayer.play()
