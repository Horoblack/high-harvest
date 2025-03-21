extends basepickup

@onready var rod: MeshInstance3D = $rod
@onready var bobber: RigidBody3D = $rod/bobber
@onready var linerender: MeshInstance3D = $linerender
@onready var rendpoint: Node3D = $rod/rendpoint

var throwing : bool = false

var throwlength : float = 0

var resetting : bool = false

var castout : bool = false

func _ready() -> void:
	super()
	add_collision_exception_with(bobber)

func trigger(bod):
	if(throwing || resetting || castout):
		return
	
	throwing = true

func _physics_process(delta: float) -> void:
	linerender.SetPoints([rendpoint.global_position,bobber.global_position])
	super(delta)
	if(throwing):
		if(!Input.is_action_pressed("leftclick")):
			throwing = false
			resetting = false
			cast()
		throwlength = clamp(throwlength+delta, 0,1)
	else:
		if(!resetting && throwlength != 0):
			throwlength = clamp(throwlength-(delta*40), -2,1)
		else:
			throwlength = clamp(throwlength+(delta*3), -2,0)
		if(throwlength < -.9):
			resetting = true
		elif throwlength == 0:
			resetting = false
	rod.rotation_degrees.x = lerp(0,25,throwlength/1)

func cast():
	castout = true
	bobber.reparent(get_tree().current_scene)
	bobber.freeze = false
	bobber.sleeping = false
	bobber.apply_impulse(global_basis.z * -2 * throwlength)

func sectrigger(bod):
	bobber.reparent(rod)
	bobber.freeze = true
	await get_tree().process_frame
	castout = false
	bobber.position = Vector3(0,1.05,-.1)
	bobber.basis = Basis()
