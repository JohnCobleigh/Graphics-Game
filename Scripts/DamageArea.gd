extends CollisionShape2D


var isInArea: bool = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	isInArea = true
	print("Someone Walked into the Brush")
	if area is HitboxComponent and area.get_parent().get_parent() is Player:
		while(isInArea):
			area.damage(10)
			await get_tree().create_timer(1).timeout


func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if area is HitboxComponent and area.get_parent().get_parent() is Player:
		isInArea = false
	pass # Replace with function body.
