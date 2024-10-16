extends StaticBody3D

func uproot():
	queue_free()

func _on_area_3d_body_entered(body):
	if(body.has_meta("obj")):
		var data : InventoryObject = body.get_meta("obj")
		if(Library.crops.has(data.objaddress)):
			var cr = Library.crops[data.objaddress].instantiate()
			get_tree().current_scene.add_child(cr)
			cr.global_position = global_position
			uproot()
			body.queue_free()
