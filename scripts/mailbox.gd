extends Node3D

@onready var flag = $flag
@onready var area = $Area3D
@onready var letterspawn = $letterspawn
@onready var boxspawn = $boxspawn

const box = preload("res://prefabs/box.tscn")

var ignore : Array

func _on_timer_timeout():
	if(InfoChecker.visibletoplayer(global_position)):
		return
		
	var delivery = area.get_overlapping_bodies()
	if(delivery != null):
		for n in delivery:
			if(!ignore.has(n) && n is box): #.is_in_group("pickup") && !n.is_in_group("heavy")
				n.queue_free()
				spawnletter()
			if(!ignore.has(n) && n is storeflyer && !n.buyingselection.is_empty()):
				var bx : box = Library.objs["box"].instantiate()
				for i in n.buyingselection:
					for q in n.buyingselection[i]:
						bx.inventory.append(i)
				get_tree().current_scene.add_child(bx)
				bx.global_position = boxspawn.global_position
				bx.global_rotation = boxspawn.global_rotation
				n.queue_free()
		

func spawnletter():
	var letter : bankstatement = Library.objs["bankstatement"].instantiate()
	get_tree().current_scene.add_child(letter)
	letter.text("Good sale :)")
	letter.global_position = letterspawn.global_position
	letter.global_rotation = letterspawn.global_rotation
