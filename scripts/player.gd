extends CharacterBody3D
class_name Player

var curspeed
const SPEED = 120
const JUMP_VELOCITY = 600
const drag = .87

var curjumpvel : float

var wasonfloor
var frozen : bool = false
var npcspeak : bool = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var coyote_time = $coyoteTime
@onready var cam = $cam
@onready var shape = $CollisionShape3D
@onready var ceilingcheck = $ceilingcheck

func _ready():
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
		
		if(gravvel < 4):
			gravvel += delta * gravvel * 7
		
		if(curjumpvel > 0):
			if(Input.is_action_pressed("ui_accept")):
				curjumpvel -= delta * 40 * 100
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
	
	if(!frozen):
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
			
			if(Input.is_action_pressed("run")):
				direction *= 2
			
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
	move_and_slide()
	if wasonfloor && !is_on_floor():
		coyote_time.start()
		
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.6)
			#col.get_collider().apply_impulse(-col.get_normal() * 0.03, col.get_position())

var crouched : bool = false
func crouchheight(down : bool = true):
	if(!down && ceilingcheck.is_colliding()):
		return
	crouched = down
	shape.shape.height = 1.5 if down else 2
	shape.position.y = .75 if down else 1
	cam.position.y = .90 if down else 1.8
