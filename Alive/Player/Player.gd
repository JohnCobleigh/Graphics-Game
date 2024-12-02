extends CharacterBody2D
class_name Player

const JUMP_VELOCITY: float = -750.0
const DASH_SPEED: float = 2500.0
const DASH_DURATION: float = 0.14
const DASH_COOLDOWN: float = .4
const DOUBLE_TAP_TIME: float = 0.25


@onready var wisp = $Wisp
@onready var playerDetector: Area2D = $PlayerDetector
@onready var healthComponent: HealthComponent = %HealthComponent
@onready var hitboxComponent: HitboxComponent = %HitboxComponent
@onready var worldCollision: CollisionShape2D = %WorldCollision

var wispProjectileScene = preload("res://Alive/Player/wispProjectile.tscn")
var heartPiece = preload("res://Combined/Heart 1/Heart1.tscn")
var heartContainer = preload("res://Combined/Heart 2/Heart2.tscn")

var gravity: float = 2000
var speed: float = 300.0

# Variables for possession
var enemyToSwitch: Enemy = null
var isNearEnemy: bool = false
var beControlled: Enemy = null
var isPlayerInvisible: bool = false
var wispHealthBefore: float = 100
var wispHealth: float


var lastDirection: Vector2
var canDash: bool = true 
var dashing: bool = false

# Track double-tap for each direction
var lastLeftTap: float = 0.0
var lastRightTap: float = 0.0
var lastKeyPressed: String = ""

var run = 0
var toggleFly: bool = false
var ownsDoubleJump: bool = false
var doubleJump: bool = false
var moreSpeed: float = 0
var canAttack: bool = true

func _ready() -> void:
	Globals.player = self
	updateCollisionShape(wisp.wispCollision.shape)




func updateCollisionShape(newShape: Shape2D) -> void:
	hitboxComponent.collisionShape.shape = newShape
	worldCollision.shape = newShape




func _physics_process(delta) -> void:
	
	if not is_on_floor():
		if beControlled != null:
			velocity.y += gravity * delta
			
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
	

				
	var direction = Input.get_axis("left", "right")
	
	if is_on_floor():
		doubleJump = false
		
	#Movement code depending on possessed body
	#Wisp
	if beControlled == null:
		velocity.y = 0
		
		if Input.is_action_pressed("run"):
			run = 400
		elif Input.is_action_just_released("run"):
			run = 0
	
		if Input.is_action_pressed("jump") or Input.is_action_pressed("fly up"):
			velocity.y = -600
		
		if Input.is_action_pressed("crouch") and not is_on_floor():
			velocity.y = 600
	#Slime
	elif beControlled is Enemy1:
		speed = 300
		
		if Input.is_action_pressed("run"):
			run = 400
		elif Input.is_action_just_released("run"):
			run = 0
			
		if Input.is_action_just_pressed("jump"):
			if ownsDoubleJump == true and !is_on_floor():
				if doubleJump == false:
					velocity.y = -1600
					doubleJump = true
			else:
				if is_on_floor():
					velocity.y = -1600
					
		
		
	#Pixie
	elif beControlled is Enemy2:
		velocity.y = 0
		speed = 400
		
		if Input.is_action_pressed("run"):
			run = 300
		elif Input.is_action_just_released("run"):
			run = 0
	
		if Input.is_action_pressed("jump") or Input.is_action_pressed("fly up"):
			velocity.y = -600
		
		if Input.is_action_pressed("crouch") and not is_on_floor():
			velocity.y = 600
		
	#Acorn Enemy
	elif beControlled is Enemy3:
		speed = 400
		
		if Input.is_action_pressed("run"):
			run = 650
		elif Input.is_action_just_released("run"):
			run = 0
			
		if Input.is_action_just_pressed("jump"):
			if ownsDoubleJump == true and !is_on_floor():
				if doubleJump == false:
					velocity.y = -1200
					doubleJump = true
			else:
				if is_on_floor():
					velocity.y = -1200
		
	#Rock Guy
	elif beControlled is Enemy4:
		speed = 350
		
		if Input.is_action_just_pressed("jump"):
			if ownsDoubleJump == true and !is_on_floor():
				if doubleJump == false:
					velocity.y = -1100
					doubleJump = true
			else:
				if is_on_floor():
					velocity.y = -1100
		
	#Wiard
	elif beControlled is Enemy5:
		speed = 400
		
		if Input.is_action_pressed("run"):
			run = 450
		elif Input.is_action_just_released("run"):
			run = 0
			
		if Input.is_action_just_pressed("toggleFly"):
			toggleFly = !toggleFly
		
		if toggleFly == true:
			velocity.y = 0
			if Input.is_action_pressed("jump") or Input.is_action_pressed("fly up"):
				velocity.y = -800
		
			if Input.is_action_pressed("crouch") and not is_on_floor():
				velocity.y = 800
		elif toggleFly == false:
			if Input.is_action_just_pressed("jump"):
				if ownsDoubleJump == true and !is_on_floor():
					if doubleJump == false:
						velocity.y = -1200
						doubleJump = true
				else:
					if is_on_floor():
						velocity.y = -1200
		
		
		
	if dashing:
		velocity.x = lastDirection.x * DASH_SPEED
	else:
		if direction:
			velocity.x = direction * (speed + run + moreSpeed)
			lastDirection = Vector2(direction, 0)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	rotateMesh()




func start_dash(dash_dir: Vector2) -> void:
	dashing = true
	canDash = false
	lastDirection = dash_dir
	await get_tree().create_timer(DASH_DURATION).timeout
	dashing = false
	velocity.x = 0  # Reset velocity to avoid jitter
	await get_tree().create_timer(DASH_COOLDOWN).timeout
	canDash = true




func rotateMesh() -> void:
	if lastDirection.x < 0:
		wisp.scale.x = -abs(wisp.scale.x)
		playerDetector.scale.x = -abs(playerDetector.scale.x)
	elif lastDirection.x > 0 :
		wisp.scale.x = abs(wisp.scale.x)
		playerDetector.scale.x = abs(playerDetector.scale.x)




func _input(_event: InputEvent) -> void:
	
	#Runs the Switches the character to enemy if the possess button is clicked
	if Input.is_action_pressed("switch") and enemyToSwitch != null and isNearEnemy and enemyToSwitch.isDead:
		switchChar(enemyToSwitch)
		enemyToSwitch = null
	
	if Input.is_action_pressed("truekill") and enemyToSwitch != null and isNearEnemy and enemyToSwitch.isDead:
		killChar(enemyToSwitch)
		enemyToSwitch = null
			
	#Releases the currently possessed enemy if the release button is clicked
	if Input.is_action_pressed("release") and isPlayerInvisible == true and beControlled != null:
		#print(beControlled)
		releaseChar(beControlled, false)

	
	if Input.is_action_just_pressed("attack") and beControlled == null and canAttack == true:
		shootProjectile()


#Possesses an enemy in the Player Detector box
#TODO: Add possession to the closest enemy to the character, not the most recent to be in the Area
func switchChar(enemyToSwitch: CharacterBody2D) -> void:
	if beControlled != null:
		return
		
	wispHealth = healthComponent.health
	healthComponent.health = enemyToSwitch.healthComponent.health
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

	var enemyCollisionShape: Shape2D = enemyToSwitch.get_node("WorldCollision").shape
	
	#TODO: Remove this when  combat function is added, Enemy collision should be updated when they die, not be possessed
	enemyToSwitch.set_collision_layer_value(1, false)
	updateCollisionShape(enemyCollisionShape)

	enemyToSwitch.global_position = global_position




func releaseChar(enemyToRelease: CharacterBody2D, trueDeath: bool):

	enemyToRelease.isControlled = false
	healthComponent.health = wispHealth
	if trueDeath:
		enemyToRelease.queue_free()
	else:
		enemyToRelease.reparent(Globals.main)
		
	wisp.visible = true
	isPlayerInvisible = false
	beControlled = null
	updateCollisionShape(wisp.wispCollision.shape)




func die() -> void:
	if healthComponent.health <= 0:
		if isPlayerInvisible == true:
			releaseChar(beControlled, true)
			healthComponent.health = wispHealth
		else:
			print("Player is Dead")
			healthComponent.health = 100
			global_position = Vector2(241, 522)




func shootProjectile() -> void:
	
	canAttack = false
	var wispProjectile: Area2D = wispProjectileScene.instantiate()
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	var mousePosition = get_global_mouse_position()
	var direction = (mousePosition - global_position).normalized()

	projectilesNode.add_child(wispProjectile)
	
	wispProjectile.position = global_position
	wispProjectile.velocity = direction
	wispProjectile.rotation = direction.angle()

	await get_tree().create_timer(.4).timeout
	canAttack = true




func killChar(enemyToKill: CharacterBody2D) -> void:
	var spawnPosition: Vector2 = enemyToKill.position
	var randNum: int = randi_range(0, 4)
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	
	if randNum == 1:
		return
	elif  randNum == 2 or randNum == 3:
		var heart1: Area2D = heartPiece.instantiate()
		projectilesNode.add_child(heart1)
		heart1.position = spawnPosition
	elif randNum == 4:
		var heart2: Area2D = heartContainer.instantiate()
		projectilesNode.add_child(heart2)
		heart2.position = spawnPosition
	enemyToKill.queue_free()



	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		print("Enemy entered: ", area.get_parent())
		isNearEnemy = true
		enemyToSwitch = area.get_parent().get_parent() as CharacterBody2D 




func _on_area_2d_area_exited(_area: Area2D) -> void:
	isNearEnemy = false
	enemyToSwitch = null
