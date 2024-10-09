extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var playerCollision: CollisionShape2D = $PlayerCollision
@onready var wisp: Player =  $Wisp

# Variables for possession
var enemyToSwitch: CharacterBody2D = null
var isNearEnemy: bool = false
var beControlled: Enemy1 = null  # Store the currently possessed enemy
var isPlayerInvisible: bool = false  # Track when the player (wisp) is invisible


func _ready() -> void:
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
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()







# Handle input for possession (replaces what was in the Wisp script)
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy:
		switchChar(enemyToSwitch)


func switchChar(enemyToSwitch: CharacterBody2D) -> void:
	print("Switching to ", enemyToSwitch)

	# Set the enemy as controlled by the Player
	enemyToSwitch.isControlled = true
	print("Switched", enemyToSwitch)

	# Remove the enemy from its current parent (Enemy1) and reparent it to the Player
	var enemyParent = enemyToSwitch.get_parent()  # This will be Enemy1
	enemyParent.remove_child(enemyToSwitch)  # Remove it from Enemy1
	add_child(enemyToSwitch)  # Add it as a child of the Player

	# Set the Player as the new owner of the enemy
	enemyToSwitch.set_owner(self)

	# Make the wisp invisible
	wisp.visible = false

	# Update the Player's collision to match the enemy's collision shape
	var enemyCollisionShape: Shape2D = enemyToSwitch.get_node("CollisionShape2D").shape
	enemyToSwitch.set_collision_layer_value(1, false)
	updateCollisionShape(enemyCollisionShape)

	# Reset the enemy's position relative to the Player
	enemyToSwitch.global_position = global_position



func releaseChar(event: InputEvent):
	if Input.is_action_pressed("release"):
		pass

# Area2D detection for nearby enemies
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print("Enemy entered: ", area)
		isNearEnemy = true
		enemyToSwitch = area.get_parent() as CharacterBody2D  # Get the enemy's parent node


# Area2D exit detection
func _on_area_2d_area_exited(area: Area2D) -> void:
	isNearEnemy = false
	enemyToSwitch = null
	
