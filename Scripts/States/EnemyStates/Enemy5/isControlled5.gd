extends State
class_name Enemy5IsControlled


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var enemy: Enemy5


var fireballProjectile = preload("res://Alive/Enemy5/Fireball.tscn")
var lightningBoltProjectile = preload("res://Alive/Enemy5/LightningBolt.tscn")
var swordSwingProjectile = preload("res://Alive/Enemy5/swordSwing.tscn")

var hasDied: bool = false
var lastDirection: bool = false
var canAttack: bool = true
var bodyHealth: float = 100

func enter() -> void:
	healthComponent.health = bodyHealth
	animatedSprite.play("Idle")
	hasDied = true
	
	
func exit() -> void:
	healthComponent.health  = bodyHealth
	
	
func _process(_delta: float) -> void:
	if hasDied == true and !enemy.isControlled:
		stateMachine.Transitioned.emit(self, "IsDead")
		
	if !enemy.isControlled:
		return

	bodyHealth = enemy.get_parent().healthComponent.health
	var mousePos = owner.get_global_mouse_position()
	var direction = (mousePos - enemy.global_position).normalized()
	
	if Input.is_action_just_pressed("attack") and canAttack  == true:
		canAttack = false
		shootFireball(direction)
	
	if Input.is_action_just_pressed("attack3") and canAttack == true:
		canAttack = false
		shootLightning(direction)
	
	if Input.is_action_just_pressed("attack2") and canAttack == true:
		canAttack = false
		swingSword(direction, mousePos)
	
	if canAttack == true:
		faceForward()

func _physics_process(_delta: float) -> void:
	if !enemy.isControlled:
		return
		
	if get_parent().get_parent().get_parent().velocity.x > 0:
		lastDirection = false
	elif get_parent().get_parent().get_parent().velocity.x < 0:
		lastDirection = true


func shootFireball(direction: Vector2) -> void:
	faceAttack(direction)
	animatedSprite.play("Fire Attack")
	
	var fireball: Area2D = fireballProjectile.instantiate()
	addToProjectiles(fireball)
	setCollision(fireball)
	
	fireball.position = enemy.global_position
	fireball.velocity = direction.normalized() * 3
	fireball.rotation = direction.angle()
	
	await get_tree().create_timer(.9).timeout	
	animatedSprite.play("Idle")
	canAttack = true
	
	
func shootLightning(direction: Vector2) -> void:
	faceAttack(direction)
	animatedSprite.play("Lightning Attack")
	
	var lightningBolt: Area2D = lightningBoltProjectile.instantiate()
	addToProjectiles(lightningBolt)
	setCollision(lightningBolt)
	lightningBolt.isEvil = false
	
	lightningBolt.position = enemy.global_position
	if direction.x > 0:
		lightningBolt.scale.x = abs(lightningBolt.scale.x)
	elif direction.x < 0:
		lightningBolt.scale.x = -abs(lightningBolt.scale.x)
		
	await get_tree().create_timer(1).timeout
	animatedSprite.play("Idle")
	canAttack = true
	
	
func swingSword(direction: Vector2, mousePos: Vector2) -> void:
	faceAttack(direction)
	animatedSprite.play("Sword Attack")
		
	var sword: Area2D = swordSwingProjectile.instantiate()
	addToProjectiles(sword)
	
	sword.position = mousePos
	await get_tree().create_timer(.35).timeout
	setCollision(sword)
	sword.isEvil = false

	if direction.x > 0:
		sword.scale.x = abs(sword.scale.x)
	elif direction.x < 0:
		sword.scale.x = -abs(sword.scale.x)
		
	await get_tree().create_timer(.6).timeout	
	animatedSprite.play("Idle")
	canAttack = true


func faceForward() -> void:
	if lastDirection:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true

func faceAttack(direction: Vector2) -> void:
	canAttack = false
	
	if direction.x < 0:
		animatedSprite.flip_h = false
	elif direction.x > 0:
		animatedSprite.flip_h = true

func addToProjectiles(itemToAdd: Area2D) -> void:
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	projectilesNode.add_child(itemToAdd)
	
func setCollision(projectile: Area2D) -> void:
	projectile.hitboxComponent.set_collision_layer_value(8, false)
	projectile.hitboxComponent.set_collision_mask_value(8, false)
	projectile.hitboxComponent.set_collision_layer_value(9, true)
	projectile.hitboxComponent.set_collision_mask_value(9, true)
