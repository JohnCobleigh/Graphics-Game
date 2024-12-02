extends State
class_name Enemy5Attack


@export var enemy: Enemy5
@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var fireballProjectile = preload("res://Alive/Enemy5/Fireball.tscn")
var lightningBoltProjectile = preload("res://Alive/Enemy5/LightningBolt.tscn")
var swordSwingProjectile = preload("res://Alive/Enemy5/swordSwing.tscn")

var player: CharacterBody2D
var playerPosition: Vector2
var attackDone: bool = false
var currentPosition: Vector2

func enter() -> void:
	print("GOING TO ATTACK")
	if enemy.isDead:
		return
	
	player = enemy.detectedPlayer
	if player != null:
		playerPosition = player.global_position
		var direction = (playerPosition - enemy.global_position).normalized()
		currentPosition = enemy.get_global_position()
		var whichAttack = randi_range(1, 3)
		print(whichAttack)
		if whichAttack == 1:
			shootFireball(direction)
		elif whichAttack == 2:
			shootLightningBolt(direction)
		elif whichAttack == 3:
			swingSword(direction, playerPosition)
	else:
		enemy.stateMachine.Transitioned.emit(self, "Wander")
		

func exit() -> void:
	attackDone = false


func _process(_delta: float) -> void:
	if enemy.isDead:
		return
		
	if(enemy.stateMachine.currentState != stateMachine.states.attack):
		return
	
	currentPosition = enemy.get_global_position()
	var distance = playerPosition - enemy.global_position
	
	if distance > Vector2(1000, 1000):
		enemy.stateMachine.Transitioned.emit(self, "Wander")
		
	if attackDone:
		enemy.stateMachine.Transitioned.emit(self, "Guard")
	
	
	
func shootFireball(direction: Vector2) -> void:
	print("Fire Attack")
	lookAtPlayer()
	animatedSprite.play("Fire Attack")
	await get_tree().create_timer(.4).timeout
	
	var fireball: Area2D = fireballProjectile.instantiate()
	addToProjectiles(fireball)
	
	fireball.position = enemy.global_position
	fireball.velocity = direction.normalized() * 3
	fireball.rotation = direction.angle()
	
	
	await get_tree().create_timer(.5).timeout	
	attackDone = true
	
	
func shootLightningBolt(direction: Vector2) -> void:
	print("Lightning Attack")
	lookAtPlayer()
	animatedSprite.play("Lightning Attack")
	await get_tree().create_timer(.6).timeout
	
	var lightningBolt: Area2D = lightningBoltProjectile.instantiate()
	addToProjectiles(lightningBolt)
	
	lightningBolt.position = enemy.global_position
	if direction.x > 0:
		lightningBolt.scale.x = abs(lightningBolt.scale.x)
	elif direction.x < 0:
		lightningBolt.scale.x = -abs(lightningBolt.scale.x)
	
	
	await get_tree().create_timer(.5).timeout	
	attackDone = true
	
func swingSword(direction: Vector2, playerPosition: Vector2) -> void:
	print("Sword Attack")
	lookAtPlayer()
	animatedSprite.play("Sword Attack")
	await get_tree().create_timer(.6).timeout
	
	var sword: Area2D = swordSwingProjectile.instantiate()
	addToProjectiles(sword)
	
	sword.position = playerPosition
	if direction.x > 0:
		sword.scale.x = abs(sword.scale.x)
	elif direction.x < 0:
		sword.scale.x = -abs(sword.scale.x)
	
	
	await get_tree().create_timer(.5).timeout	
	attackDone = true
	

func lookAtPlayer() -> void:
	var direction_to_player = playerPosition - enemy.global_position
	
	if direction_to_player.x < 0:
		animatedSprite.flip_h = false
		enemy.enemyDetector.scale.x = -abs(enemy.enemyDetector.scale.x)
	elif direction_to_player.x > 0:
		animatedSprite.flip_h = true
		enemy.enemyDetector.scale.x = abs(enemy.enemyDetector.scale.x)



func addToProjectiles(itemToAdd: Area2D) -> void:
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	projectilesNode.add_child(itemToAdd)
	
