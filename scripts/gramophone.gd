extends basepickup
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var grab: grabarea = $StaticBody3D
@onready var vinylcheck: Area3D = $vinylcheck

var data : InventoryObject
var curvinyl : String
var vinylobj : vinyl

func _ready() -> void:
	super()
	data = get_meta("obj")
	if(data.customproperties.has("playing")):
		audio.playing = data.customproperties["playing"]
	else:
		audio.playing = false
	
	if(data.customproperties.has("curvinyl")):
		curvinyl = data.customproperties["curvinyl"]
		var vin = Library.objs[curvinyl].instantiate()
		get_tree().current_scene.add_child(vin)
		vin.global_position = vinylcheck.global_position
	add_collision_exception_with(grab)

func _physics_process(delta: float) -> void:
	if(vinylobj):
		vinylobj.global_basis = vinylcheck.global_basis
		if(audio.playing):
			vinylcheck.rotation.y += delta
	if(lidtime > 0):
		lidtime -= delta

func trigger(pl):
	audio.playing = !audio.playing
	data.customproperties["playing"] = audio.playing
	set_meta("obj",data)

func _on_vinylcheck_body_entered(body: Node3D) -> void:
	if(body is vinyl && vinylobj == null && lidtime <= 0):
		curvinyl = body.get_meta("obj").objaddress
		body.unlid.connect(unlidded)
		vinylobj = body
		vinylobj.freeze = true
		vinylobj.reparent(self)
		add_collision_exception_with(vinylobj)
		vinylobj.global_position = vinylcheck.global_position
		audio.stream = vinylobj.song
		data.customproperties["curvinyl"] = curvinyl
		set_meta("obj",data)

var lidtime : float = 0
func unlidded():
	if(vinylobj):
		lidtime = .2
		vinylobj.reparent(get_tree().current_scene)
		remove_collision_exception_with(vinylobj)
		vinylobj.unlid.disconnect(unlidded)
		vinylobj.freeze = false
		vinylobj = null
		curvinyl = ""
		audio.stream = null
		data.customproperties["curvinyl"] = ""
		set_meta("obj",data)
