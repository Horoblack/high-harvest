extends CharacterBody3D
class_name Player

@onready var coyote_time = $coyoteTime
@onready var cam = $cam
@onready var shape = $CollisionShape3D
@onready var ceilingcheck = $ceilingcheck
@onready var stats: RichTextLabel = $cam/CanvasLayer/stats
@onready var shadow: RigidBody3D = $shadow
@onready var shadowshape: CollisionShape3D = $shadow/CollisionShape3D
@onready var normalshape: CollisionShape3D = $CollisionShape3D

var curspeed
const SPEED = 160
const JUMP_VELOCITY = 600
const drag = .87

var curjumpvel : float

var wasonfloor
var frozen : bool = false
var npcspeak : bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var hunger : float = 50
var energy : float = 50

var ragdolled : bool = false
@onready var ragdolltime: Timer = $ragdolltime

func _ready():
	shadow.call_deferred("reparent",get_tree().current_scene)
	add_collision_exception_with(shadow)
	shadow.add_collision_exception_with(self)
	curspeed = 100

func resetjump():
	curjumpvel = 0
	gravvel = .1

func _input(event):
	if(event.is_action_pressed("crouch")):
		crouchheight(!crouched)

var gravvel : float = .1
func _physics_process(delta):
	if !is_on_floor():
		velocity.y -= gravity * delta * gravvel
		
		if(gravvel < 7):
			gravvel += delta * gravvel * 10
		
		if(curjumpvel > 0):
			if(Input.is_action_pressed("ui_accept")):
				curjumpvel -= delta * 3000
			else:
				curjumpvel = 0
	else:
		gravvel = 0.5
	# get the vault casts
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, global_transform.origin - global_transform.basis.z)
	query.exclude = [self]
	var feet = get_world_3d().direct_space_state.intersect_ray(query)
	query = PhysicsRayQueryParameters3D.create(global_transform.origin + Vector3.UP * 3, (global_transform.origin + Vector3.UP * 2) - global_transform.basis.z)
	query.exclude = [self]
	var head = get_world_3d().direct_space_state.intersect_ray(query)
	
	if(!frozen && !ragdolled):
		# handle jump
		if Input.is_action_just_pressed("jump") && (is_on_floor() || !coyote_time.is_stopped()):
			curjumpvel = JUMP_VELOCITY
			coyote_time.stop()
		
		if(Input.is_action_pressed("jump") && feet.has("collider") && !head.has("collider") || !coyote_time.is_stopped()):
			curjumpvel = JUMP_VELOCITY / 2
			coyote_time.stop()
		
		if(curjumpvel > 0):
			velocity.y += curjumpvel * delta * 1.5
		
		#movement and acceleration biz
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			if(curspeed < SPEED):
				curspeed += 10
			else:
				curspeed -= 3
			
			velocity.x += direction.x * curspeed * delta
			velocity.z += direction.z * curspeed * delta
			
			if(direction.x < 0 && velocity.x > 0):
				velocity.x -= curspeed * delta
			if(direction.x > 0 && velocity.x < 0):
				velocity.x += curspeed * delta
				
			if(direction.z < 0 && velocity.z > 0):
				velocity.z -= curspeed * delta
			if(direction.z > 0 && velocity.z < 0):
				velocity.z += curspeed * delta
		else:
			if(curspeed > 100):
				curspeed -= 20
			else:
				curspeed = 100
			
			velocity.x = move_toward(velocity.x, 0, 1.5)
			velocity.z = move_toward(velocity.z, 0, 1.5)
	
	velocity *= drag
	
	wasonfloor = is_on_floor()
	if(!ragdolled):
		move_and_slide()
		shadow.global_position = global_position
		shadow.global_basis = global_basis
	else:
		global_position = shadow.global_position
		global_basis = shadow.global_basis
	if wasonfloor && !is_on_floor():
		coyote_time.start()
		
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.6)
			#col.get_collider().apply_impulse(-col.get_normal() * 0.03, col.get_position())

func _process(delta: float) -> void:
	hunger -= delta * .01
	hunger = clamp(hunger,0,100)
	energy -= delta * .005
	energy = clamp(energy,0,100)
	if(hunger < 15 || energy < 15) && ragdolltime.is_stopped():
		ragdolltime.start(10)
	
	stats.text = "[color=#ff8400]%s[/color]\n[color=#00aaff]%s[/color]" % [str(hunger).pad_decimals(1),str(energy).pad_decimals(1)]

var crouched : bool = false
func crouchheight(down : bool = true):
	if(!down && ceilingcheck.is_colliding()):
		return
	crouched = down
	shape.shape.height = 1.5 if down else 2
	shape.position.y = .75 if down else 1
	cam.position.y = .90 if down else 1.8

func feed(amt : float):
	hunger += amt
	hunger = clamp(hunger,0,100)

func ragdoll():
	ragdolled = true
	shadow.freeze = false
	normalshape.disabled = true
	shadowshape.disabled = false
	shadow.linear_velocity = -global_basis.z*3 if velocity.is_zero_approx() else velocity*3
	shadow.angular_velocity = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	velocity = Vector3.ZERO
	await get_tree().create_timer(3).timeout
	crouchheight(true)
	ragdolled = false
	shadow.freeze = true
	normalshape.disabled = false
	shadowshape.disabled = true

func _on_ragdolltime_timeout() -> void:
	ragdoll()
