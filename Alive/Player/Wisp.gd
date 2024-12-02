extends CharacterBody2D
#class_name Wisp

var enemyToSwitch: CharacterBody2D = null
var isNearEnemy: bool = false
var beControlled: Enemy1 = null
var isPlayerInvisible: bool = false
@onready var wispCollision: CollisionShape2D = $CollisionShape2D


#func _ready() -> void:
	#pass
	#
#func _input(_event: InputEvent) -> void:
#
	#if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy == true:
		#print("Test")
		#switchChar(enemyToSwitch)
	#
	#
	#
#func switchChar(enemyToSwitch: CharacterBody2D) -> void:
	#
	#print(enemyToSwitch, " ", isNearEnemy, " ")
	#enemyToSwitch.isControlled = true
	#print("Switched")
	#
	#set_collision_layer_value(1, false)
	#set_transform(enemyToSwitch.transform) 
#
#
#func _on_area_2d_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Enemy") == true:
		#print(area, " Entered")
		#isNearEnemy = true
		#var temp = area.get_parent() as Enemy
		#enemyToSwitch = temp
		#
		#
#func _on_area_2d_body_exited(_body: Node2D) -> void:
	#isNearEnemy = false
	#enemyToSwitch = null
	#
