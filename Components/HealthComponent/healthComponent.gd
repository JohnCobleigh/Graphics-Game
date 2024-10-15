extends Node
class_name HealthComponent

@export var maxHealth: float
@export var health: float


func _ready() -> void:
	health = maxHealth


func takeDamage(damage) -> void:
	health = health - damage
	
	if(health <= 0):
		die()
	
	
func die() -> void:
	print("DEAD")
	pass
