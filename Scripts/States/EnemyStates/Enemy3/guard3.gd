extends State
class_name Enemy3Guard


@export var enemy: Enemy
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
	animatedSprite.play("Acorn Guard")
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

	if guardTime > 0:	

		if enemy.detectedPlayer == null:
			stateMachine.Transitioned.emit(self, "Wander")
			
		if player:
			playerPosition = player.global_position
			
		guardTime = guardTime - delta
	else:
		stateMachine.Transitioned.emit(self, "Attack")

	return


func _physics_process(_delta: float) -> void:
	if isGuarded == false:
		return
	
	facePlayer()



func facePlayer() -> void:
	var direction_to_player = playerPosition - enemy.global_position
	
	if direction_to_player.x < 0:
		animatedSprite.flip_h = false
		enemy.enemyDetector.scale.x = -abs(enemy.enemyDetector.scale.x)
	elif direction_to_player.x > 0:
		animatedSprite.flip_h = true
		enemy.enemyDetector.scale.x = abs(enemy.enemyDetector.scale.x)
	
