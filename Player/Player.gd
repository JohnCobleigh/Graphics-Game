extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var playerCollision: CollisionShape2D = $PlayerCollision
@onready var wisp = $Wisp
@onready var playerDetector: Area2D = $PlayerDetector

# Variables for possession
var enemyToSwitch: CharacterBody2D = null
var isNearEnemy: bool = false
var beControlled: Enemy1 = null
var isPlayerInvisible: bool = false

var lastDirection: Vector2 


func _ready() -> void:
	Globals.player = self
	updateCollisionShape(wisp.wispCollision.shape)
	
	
func updateCollisionShape(newShape: Shape2D) -> void:
	playerCollision.shape = newShape


func _physics_process(delta) -> void:
	


	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		lastDirection = Vector2(direction, 0)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	rotateMesh()


func rotateMesh() -> void:
	if lastDirection.x < 0:
		wisp.scale.x = -abs(wisp.scale.x)
		playerDetector.scale.x = -abs(playerDetector.scale.x)
	elif lastDirection.x > 0 :
		wisp.scale.x = abs(wisp.scale.x)
		playerDetector.scale.x = abs(playerDetector.scale.x)
	
		




func _input(event: InputEvent) -> void:
	#print(beControlled)
	if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy:
		switchChar(enemyToSwitch)
		enemyToSwitch = null
		
	
	if Input.is_action_pressed("release") and isPlayerInvisible == true and beControlled != null:
		#print(beControlled)
		
		releaseChar(beControlled)


func switchChar(enemyToSwitch: CharacterBody2D) -> void:
	if beControlled != null:
		return
	print("Switching to ", enemyToSwitch)

	# Set the enemy as controlled by the Player
	enemyToSwitch.isControlled = true
	print("Switched", enemyToSwitch)

	# Remove the enemy from its current parent (Enemy1) and reparent it to the Player
	var enemyParent = enemyToSwitch.get_parent()
	enemyParent.remove_child(enemyToSwitch)
	add_child(enemyToSwitch)
	beControlled = enemyToSwitch

	enemyToSwitch.set_owner(self)
	isPlayerInvisible = true
	wisp.visible = false

	var enemyCollisionShape: Shape2D = enemyToSwitch.get_node("CollisionShape2D").shape
	enemyToSwitch.set_collision_layer_value(1, false)
	updateCollisionShape(enemyCollisionShape)

	enemyToSwitch.global_position = global_position


func releaseChar(enemyToRelease: CharacterBody2D):
	if Input.is_action_pressed("release"):
		
		print(enemyToRelease)
		
		enemyToRelease.reparent(Globals.main)
		
		wisp.visible = true
		isPlayerInvisible = false
		beControlled = null
		updateCollisionShape(wisp.wispCollision.shape)
		
		#remove_child(enemyToRelease)
		
		
		

# Area2D detection for nearby enemies
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print("Enemy entered: ", area.get_parent())
		isNearEnemy = true
		enemyToSwitch = area.get_parent() as CharacterBody2D  # Get the enemy's parent node


# Area2D exit detection
func _on_area_2d_area_exited(area: Area2D) -> void:
	isNearEnemy = false
	enemyToSwitch = null
	
