extends Area2D

var goingUp: bool = true
var switchTime: float = 1.0

func _physics_process(delta: float) -> void:
	
	if goingUp == true:
		position = position - Vector2(0,.2)
	else:
		position = position + Vector2(0,.2)
	
	if switchTime < 0:
		switchTime = 1
		goingUp = !goingUp
		
	switchTime = switchTime - delta

func _on_hitbox_component_area_entered(area: Area2D) -> void:
	
	if area.get_parent().get_parent() is Player:
		var hitbox: HitboxComponent = area
		hitbox.heal(10)
		print("Heal10")
		queue_free()
