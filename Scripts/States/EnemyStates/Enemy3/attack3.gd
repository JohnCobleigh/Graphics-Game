extends State
class_name Enemy3Attack


@export var enemy: Enemy
@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var acornProjectile = preload("res://Alive/Enemy3/acornProjectile.tscn")

var player: CharacterBody2D
var playerPosition: Vector2
var attackDone: bool = false
var currentPosition: Vector2

func enter() -> void:
	if enemy.isDead:
		return
	
	player = enemy.detectedPlayer
	playerPosition = player.global_position
	var direction = (playerPosition - enemy.global_position).normalized()
	currentPosition = enemy.get_global_position()
	throwSpear(direction)
	

func exit() -> void:
	attackDone = false


func _process(_delta: float) -> void:
	if enemy.isDead:
		return
		
	if(enemy.stateMachine.currentState != stateMachine.states.attack):
		return
	
	currentPosition = enemy.get_global_position()
	var distance = playerPosition - enemy.global_position
	
	if distance >  Vector2(1000, 1000):
		enemy.stateMachine.Transitioned.emit(self, "Wander")
		
	if attackDone:
		enemy.stateMachine.Transitioned.emit(self, "Guard")
	
	
	
func throwSpear(direction: Vector2) -> void:
	var direction_to_player = playerPosition - enemy.global_position
	
	if direction_to_player.x < 0:
		animatedSprite.flip_h = false
		enemy.enemyDetector.scale.x = -abs(enemy.enemyDetector.scale.x)
	elif direction_to_player.x > 0:
		animatedSprite.flip_h = true
		enemy.enemyDetector.scale.x = abs(enemy.enemyDetector.scale.x)
		
	animatedSprite.play("Acorn Attack")
	await get_tree().create_timer(.5).timeout
	
	var acorn: Area2D = acornProjectile.instantiate()
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	projectilesNode.add_child(acorn)
	
	acorn.position = enemy.global_position
	acorn.velocity = direction.normalized() * 3
	acorn.rotation = direction.angle()
	
	await get_tree().create_timer(.5).timeout
	attackDone = true
	#enemy.stateMachine.Transitioned.emit(self, "Guard")