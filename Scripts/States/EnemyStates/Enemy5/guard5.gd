extends State
class_name Enemy5Guard


@export var enemy: Enemy5
@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var moveSpeed: float = 1000
var player: CharacterBody2D
var isGuarded: bool = false
var guardTime: float
var playerPosition: Vector2
var recentlyAttacked: bool = false

func randomizeGuardTime() -> void:
	guardTime = randf_range(3, 6)
	print(guardTime)
	
func enter() -> void:
	animatedSprite.play("Idle")
	isGuarded = true
	player = enemy.detectedPlayer
	randomizeGuardTime()
	
	
func exit() -> void:
	isGuarded = false
	guardTime = -1


func _process(delta: float) -> void:
	if enemy.isDead:
		return
	
	if isGuarded == false:
		return
	
	if guardTime > 0:
		#print(guardTime)
		if enemy.detectedPlayer == null:
			stateMachine.Transitioned.emit(self, "Wander")
			
		if player:
			playerPosition = player.global_position
			var distance = playerPosition.distance_to(enemy.global_position)
			
			if distance < 300:
				if randBoolGen() and recentlyAttacked  == false:
					recentlyAttacked = true
					stateMachine.Transitioned.emit(self, "Attack")
				else:
					print("TELEPORT")
					var teleportDistance = 300
	
					#Generate a random direction (normalized vector)
					var randomDirection = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized()
				
					# Calculate the potential new position
					var newPosition = enemy.global_position + randomDirection * teleportDistance
				
					# Create a collision shape (e.g., a small circle) for testing
					var shape = CircleShape2D.new()
					shape.radius = 5  # Adjust radius as needed

					var query_parameters = PhysicsShapeQueryParameters2D.new()
					query_parameters.shape = shape
					query_parameters.transform = Transform2D().translated(newPosition)
					query_parameters.collision_mask = 1  # Adjust mask if needed

					# Use the physics space to check if the area is clear
					var spaceState = enemy.get_world_2d().direct_space_state

					# Perform the collision check
					var result = spaceState.intersect_shape(query_parameters, 1)

					# Only teleport if the area is not occupied
					if result.size() == 0:
						enemy.global_position = newPosition
						
					recentlyAttacked = false
			
	else:
		print("E")
		stateMachine.Transitioned.emit(self, "Attack")
			

	guardTime = guardTime - delta

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

	
func randBoolGen() -> bool:
	return randi() % 2 == 0
