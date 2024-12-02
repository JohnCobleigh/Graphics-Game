extends State
class_name Enemy2Attack


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

@export var enemy: Enemy2

var player: CharacterBody2D
var playerPosition: Vector2
var attackDone: bool = false
var currentPosition: Vector2

func enter() -> void:
	if enemy.isDead:
		return
	
	player = enemy.detectedPlayer
	playerPosition = player.global_position
	currentPosition = enemy.get_global_position()
	doAttack()
	

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


func doAttack() -> void:
	
	await  get_tree().create_timer(1).timeout
	animatedSprite.play("Pixie Attack")
	await  get_tree().create_timer(.5).timeout
	
	if player.global_position.distance_to(enemy.global_position) < 120:
		player.healthComponent.health -= 30
		
	await  get_tree().create_timer(.3).timeout
	attackDone = true
	pass
