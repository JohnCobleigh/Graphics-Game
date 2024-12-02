extends Node
class_name HealthComponent

@export var character: CharacterBody2D
@export var maxHealth: float
@export var health: float
@export var stateMachine: StateMachine# = $StateMachine



func _ready() -> void:
	health = maxHealth


func takeDamage(damage) -> void:
	health = health - damage
	
	if(health <= 0):
		#health = 100
		if character.has_method("die"):
			character.die()
		
func heal(healAmt) -> void:
	health = health + healAmt
	if health > maxHealth:
		health = maxHealth
		
		
