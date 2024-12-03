extends basepickup

@onready var waterlevel = $waterlevel

var wateramt : float

var cubes : Array[String]
const WATERPARTICLES = preload("res://prefabs/waterparticles.tscn")

var data : InventoryObject

var cooking : bool

var boil : float

func _ready():
	super()
	data = get_meta("obj")
	if(data.customproperties.has("wateramt")):
		wateramt = data.customproperties["wateramt"]
	if(data.customproperties.has("cubes")):
		wateramt = data.customproperties["cubes"]
	set_meta("obj",data)
	
func _process(delta):
	waterlevel.position.y = lerp(-.1,.1,wateramt/6)

func _physics_process(delta):
	if(global_basis.y.dot(Vector3.DOWN) > 0.4 && wateramt > 0):
		dump()
	if(cooking && boil < 30):
		boil += delta * 3
	elif(boil > 0):
		boil -= delta *.5

func water():
	wateramt = clamp(wateramt+.3, 0, 6)
	data.customproperties["cubes"] = []
	data.customproperties["wateramt"] = wateramt

func trigger(pl : PlayerCam):
	if(wateramt >= 2 && cubes.size() >= 2):
		wateramt -= 2
		cubes.erase(cubes[0])
		cubes.erase(cubes[0])
		pl.body.feed(15 if boil >= 20 else 30)
		data.customproperties["cubes"] = []
		data.customproperties["wateramt"] = wateramt

func dump():
	wateramt = 0
	var oj = WATERPARTICLES.instantiate()
	get_tree().current_scene.add_child(oj)
	oj.global_position = global_position
	oj.global_rotation = global_rotation
	for n in cubes:
		var obj = Library.objs[n].instantiate()
		get_tree().current_scene.add_child(obj)
		obj.global_position = global_position + global_basis.y
	cubes.clear()
	data.customproperties["cubes"] = []
	data.customproperties["wateramt"] = wateramt

func _on_area_3d_body_entered(body:Node3D):
	if(body.is_in_group("diced") && cubes.size() < 6 && wateramt > .1):
		cubes.append(body.get_meta("obj").objaddress)
		body.queue_free()
		data.customproperties["cubes"] = []
		data.customproperties["wateramt"] = wateramt

func info():
	return "Water: %s\nBits: %s\nBoiling: %s" % [wateramt, cubes.size(), "yes" if boil >= 20 else "no"]

func heat(p):
	cooking = p
