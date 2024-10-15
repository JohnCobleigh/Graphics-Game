extends CharacterBody2D
class_name Player

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -600.0
const DASH_SPEED: float = 2000.0
const DASH_DURATION: float = 0.1
const DASH_COOLDOWN: float = .4
const DOUBLE_TAP_TIME: float = 0.25

#var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity: float = 1500


@onready var wisp = $Wisp
@onready var playerDetector: Area2D = $PlayerDetector
@onready var healthComponent: HealthComponent = %HealthComponent
@onready var hitboxComponent: HitboxComponent = %HitboxComponent
@onready var worldCollision: CollisionShape2D = %WorldCollision




# Variables for possession
var enemyToSwitch: CharacterBody2D = null
var isNearEnemy: bool = false
var beControlled: Enemy1 = null
var isPlayerInvisible: bool = false



var lastDirection: Vector2
var canDash: bool = true 
var dashing: bool = false

# Track double-tap for each direction
var lastLeftTap: float = 0.0
var lastRightTap: float = 0.0
var lastKeyPressed: String = ""

var run = 0

func _ready() -> void:
	Globals.player = self
	updateCollisionShape(wisp.wispCollision.shape)

	
	
func updateCollisionShape(newShape: Shape2D) -> void:
	hitboxComponent.collisionShape.shape = newShape
	worldCollision.shape = newShape
	
	
#func _unhandled_key_input(event: InputEvent) -> void:
	#
	#if event.is_released():
		#if timer.is_stopped():
			#timer.start()
			#
	#if event.is_pressed():
		#if !timer.is_stopped():
			#print("SD")


func _physics_process(delta) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction = Input.get_axis("left", "right")
	#
	#if Input.is_action_just_released("left") && canDash:
		#testDashLeft()
	#
	#if  Input.is_action_pressed("left") && dashPotential:
		##print("DASH")
		#position = position + Vector2(-30,0)
		#canDash = false
		#await get_tree().create_timer(.1).timeout
		#dashPotential = false
		#canDash = true
		#
		#
	#if Input.is_action_just_released("right") && canDash:
		#testDashRight()
	#
	#if  Input.is_action_pressed("right") && dashPotential:
		##print("DASH")
		#position = position + Vector2(30,0)
		#canDash = false
		#await get_tree().create_timer(.1).timeout
		#dashPotential = false
		#canDash = true
		
	
	
	#Check for dash
	if canDash and not dashing:
		if Input.is_action_just_pressed("left"):
			if lastKeyPressed == "left" and Time.get_ticks_msec() - lastLeftTap < DOUBLE_TAP_TIME * 1000:
				start_dash(Vector2(-1, 0))
			lastLeftTap = Time.get_ticks_msec()
			lastKeyPressed = "left"

		if Input.is_action_just_pressed("right"):
			if lastKeyPressed == "right" and Time.get_ticks_msec() - lastRightTap < DOUBLE_TAP_TIME * 1000:
				start_dash(Vector2(1, 0))
			lastRightTap = Time.get_ticks_msec()
			lastKeyPressed = "right"
	
	if Input.is_action_pressed("run"):
		run = 200
	elif Input.is_action_just_released("run"):
		run = 0
	
	
	
		
		
	if dashing:
		velocity.x = lastDirection.x * DASH_SPEED
	else:
		if direction:
			velocity.x = direction * (SPEED + run)
			lastDirection = Vector2(direction, 0)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	rotateMesh()



#Handles most of the dash logic
func start_dash(dash_dir: Vector2) -> void:
	dashing = true
	canDash = false
	lastDirection = dash_dir
	await get_tree().create_timer(DASH_DURATION).timeout
	dashing = false
	velocity.x = 0  # Reset velocity to avoid jitter
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	canDash = true



#Rotates the Mesh when the character looks from left to righ
func rotateMesh() -> void:
	if lastDirection.x < 0:
		wisp.scale.x = -abs(wisp.scale.x)
		playerDetector.scale.x = -abs(playerDetector.scale.x)
	elif lastDirection.x > 0 :
		wisp.scale.x = abs(wisp.scale.x)
		playerDetector.scale.x = abs(playerDetector.scale.x)
	
		




func _input(event: InputEvent) -> void:
	
	#Runs the Switches the character to enemy if the possess button is clicked
	if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy:
		switchChar(enemyToSwitch)
		enemyToSwitch = null
		
	#Releases the currently possessed enemy if the release button is clicked
	if Input.is_action_pressed("release") and isPlayerInvisible == true and beControlled != null:
		#print(beControlled)
		
		releaseChar(beControlled)

#Possesses an enemy in the Player Detector box
#TODO: Add possession to the closest enemy to the character, not the most recent to be in the Area
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
	
	
#Releases currently possessed Character
func releaseChar(enemyToRelease: CharacterBody2D):
	if Input.is_action_pressed("release"):
		
		print(enemyToRelease)
		
		enemyToRelease.isControlled = false
		enemyToRelease.reparent(Globals.main)
		
		wisp.visible = true
		isPlayerInvisible = false
		beControlled = null
		updateCollisionShape(wisp.wispCollision.shape)
		
		#remove_child(enemyToRelease)
		
		
		

#Detects when an enemy enters the Area
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print("Enemy entered: ", area.get_parent())
		isNearEnemy = true
		enemyToSwitch = area.get_parent() as CharacterBody2D 


#Detects when an enemy leaves the Area
func _on_area_2d_area_exited(area: Area2D) -> void:
	isNearEnemy = false
	enemyToSwitch = null
	
