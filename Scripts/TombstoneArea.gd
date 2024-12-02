extends Area2D

@export var player: Player

var timeGone: float = 5.0
var isInArea: bool = true

func _process(delta: float) -> void:
	if player.beControlled != null:
		timeGone = 5.0
		
	if isInArea == false and player.beControlled == null:
		timeGone = timeGone - delta
		
	if timeGone < 0:
		timeGone = 1
		player.healthComponent.takeDamage(10)
	
	
func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area is HitboxComponent and area.get_parent().get_parent() is Player:
		isInArea = true
		timeGone = 5.0


func _on_hitbox_component_area_exited(area: Area2D) -> void:
	if area is HitboxComponent and area.get_parent().get_parent() is Player:
		isInArea = false
