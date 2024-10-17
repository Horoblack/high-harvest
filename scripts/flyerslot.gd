extends Control

@onready var selectcircle = $selectcircle
@onready var amounttxt = $selectcircle/amounttxt
@onready var icon = $texturebox/TextureRect
@onready var nametxt = $namebox/Label
@onready var pricetxt = $pricebox/Label

var itemobj : InventoryObject

func setup(obj):
	itemobj = obj
	numb(0)
	nametxt.text = itemobj.name
	pricetxt.text = "$ " + str(Library.purchasables[itemobj.objaddress])
	icon.texture = itemobj.icon

func numb(amt : int):
	selectcircle.visible = amt > 0
	amounttxt.visible = amt > 1
	amounttxt.text = "x" + str(amt)
