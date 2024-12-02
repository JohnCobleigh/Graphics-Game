extends State
class_name Enemy3Wander

@export var enemy: Enemy
#@export var moveSpeed: float = 10

@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var moveDirection: int
var wanderTime: float
var wanderSpeed: float
var isWandering: bool = false

func randomizeWanderTime() -> void:
	moveDirection = randi_range(-1, 1)
	if moveDirection == 0:
		randomizeWanderTime()
	
	wanderTime = randf_range(1,6)
	wanderSpeed = randf_range(50,100)


func enter() -> void:
	animatedSprite.play("Acorn Wander")
	randomizeWanderTime()
	isWandering = true
	
	
func exit() -> void:
	wanderSpeed = 0
	wanderTime  = -1
	moveDirection = 0
	isWandering = false
	enemy.velocity.x = 0
	#print("STOPOSPOSPSPSPO")
	

func _process(delta: float) -> void:
	if !isWandering:
		return
		
	if wanderTime > 0:
		wanderTime = wanderTime - delta
	else: 
		stateMachine.Transitioned.emit(self, "Idle")
		
		
	if enemy.isControlled:
		stateMachine.Transitioned.emit(self, "IsControlled")
		
	return
		
func _physics_process(delta: float) -> void:
	if !isWandering:
		return
	
	if enemy:
		enemy.velocity.x = moveDirection * wanderSpeed
		#print(enemy.velocity)
		
	if not enemy.is_on_floor():
		enemy.velocity.y += enemy.gravity * delta
		
		
	
