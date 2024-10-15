extends CharacterBody2D
#class_name Wisp


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var enemyToSwitch: CharacterBody2D = null
var isNearEnemy: bool = false
var beControlled: Enemy1 = null
var isPlayerInvisible: bool = false
@onready var wispCollision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:

	if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy == true:
		print("Test")
		switchChar(enemyToSwitch)
	


#
#func _physics_process(delta) -> void:
	#if isPlayerInvisible:
		#global_position = enemyToSwitch.global_position
	#else:
		#if not is_on_floor():
			#velocity.y += gravity * delta
	#
	#
		#if Input.is_action_just_pressed("jump") and is_on_floor():
			#velocity.y = JUMP_VELOCITY
	#
	#
		#var direction = Input.get_axis("left", "right")
		#if direction:
			#velocity.x = direction * SPEED
		#else:
			#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
		#move_and_slide()


#func _on_area_2d_body_entered(body: Node2D) -> void:
	#
	##body.isControlled = true
	#print(body, " Type: ", body.get_class())
#
	#if body.is_in_group("Enemy") == true:
		#print(body, " Entered")
		#isNearEnemy = true
		#
		#var temp = body as Enemy1
		#print(temp, " ", body)
		#temp.isControlled = true
		#enemyToSwitch = temp
		##body.



	
	
func switchChar(enemyToSwitch: CharacterBody2D) -> void:
	
	#if event.is_action_pressed("switch") and isNearEnemy and enemyToSwitch:
	print(enemyToSwitch, " ", isNearEnemy, " ")
	enemyToSwitch.isControlled = true
	print("Switched")
	
	set_collision_layer_value(1, false)
	set_transform(enemyToSwitch.transform) 


func _on_area_2d_area_entered(area: Area2D) -> void:	
	#body.isControlled = true
	print(area, " Type: ", area.get_class())

	if area.is_in_group("Enemy") == true:
		print(area, " Entered")
		isNearEnemy = true
		var temp = area.get_parent() as Enemy
		#print(temp, " ", area)
		#temp.isControlled = true
		enemyToSwitch = temp
		#beControlled
		#body.
		
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	isNearEnemy = false
	enemyToSwitch = null
	
