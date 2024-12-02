extends State
class_name Enemy2Guard


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

@export var enemy: Enemy2
@export var AttackDistance: float = 80

var moveSpeed: float = 1000
var player: CharacterBody2D
var isGuarded: bool = false

var playerPosition: Vector2

func enter() -> void:
	isGuarded = true
	player = enemy.detectedPlayer
	animatedSprite.play("Pixie Idle")

	
func exit() -> void:
	isGuarded = false


func _process(delta: float) -> void:
	if enemy.isDead:
		return

	if isGuarded == false:
		return

	if enemy.detectedPlayer == null:
		stateMachine.Transitioned.emit(self, "Wander")
		return 

	if player:
		playerPosition = player.global_position
		

		move_towards_player(delta)
		print(playerPosition.distance_to(enemy.global_position))

		if playerPosition.distance_to(enemy.global_position) <= AttackDistance:
			stateMachine.Transitioned.emit(self, "Attack")


func _physics_process(_delta: float) -> void:
	if isGuarded == false:
		return
	
	facePlayer()


func facePlayer() -> void:
	var directionToPlayer = playerPosition - enemy.global_position
	
	if directionToPlayer.x < 0:
		animatedSprite.flip_h = false
		enemy.enemyDetector.scale.x = -abs(enemy.enemyDetector.scale.x)
	elif directionToPlayer.x > 0:
		animatedSprite.flip_h = true
		enemy.enemyDetector.scale.x = abs(enemy.enemyDetector.scale.x)
	
	
func move_towards_player(delta: float) -> void:
	if player:
		var direction_to_player = (player.global_position - enemy.global_position).normalized()
		enemy.global_position += direction_to_player * 100 * delta
