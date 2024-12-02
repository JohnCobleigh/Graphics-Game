extends State
class_name Enemy1Guard


@export var enemy: Enemy1
@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var moveSpeed: float = 1000
var player: CharacterBody2D
var guardTime: float 
var isGuarded: bool = false

var playerPosition: Vector2

func randomizeGuardTime() -> void:
	guardTime = randf_range(2.5, 6)
	print(guardTime)

func enter() -> void:
	isGuarded = true
	player = enemy.detectedPlayer
	randomizeGuardTime()
	
	
func exit() -> void:
	isGuarded = false
	guardTime = 0


func _process(delta: float) -> void:
	if enemy.isDead:
		return
		
	if enemy.isControlled:
		return
		
	if isGuarded == false:
		return
	
	animatedSprite.play("default")

	if guardTime > 0:	

		if enemy.detectedPlayer == null:
			stateMachine.Transitioned.emit(self, "Wander")
			
		if player:
			playerPosition = player.global_position
			
		guardTime = guardTime - delta
	else:
		print("GOING TO ATTACK")
		stateMachine.Transitioned.emit(self, "Attack")

	return


func _physics_process(_delta: float) -> void:
	if isGuarded == false:
		return
	
	facePlayer()



func facePlayer() -> void:
	var direction_to_player = playerPosition - enemy.global_position
	
	if direction_to_player.x < 0:
		enemy.enemyDetector.scale.x = -abs(enemy.enemyDetector.scale.x)
	elif direction_to_player.x > 0:
		enemy.enemyDetector.scale.x = abs(enemy.enemyDetector.scale.x)
	
	
	return
