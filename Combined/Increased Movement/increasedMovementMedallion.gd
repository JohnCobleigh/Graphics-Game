extends Area2D


func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Player:
		var player: Player = area.get_parent().get_parent() 
		player.moreSpeed = 400
		queue_free()
