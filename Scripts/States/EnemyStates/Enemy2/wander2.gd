extends State
class_name Enemy2Wander

@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

@export var enemy: Enemy2


var moveDirection: Vector2
var wanderTime: float
var wanderSpeed: float

func randomizeWanderTime() -> void:
	moveDirection = Vector2(randf_range(-1, 1), randf_range(-1, 1)) 
	if moveDirection == Vector2(0, 0):
		randomizeWanderTime()
	
	wanderTime = randf_range(1,6)
	wanderSpeed = randf_range(50,100)


func enter() -> void:
	animatedSprite.play("Pixie Idle")
	randomizeWanderTime()
	
	
func exit() -> void:
	wanderSpeed = 0
	wanderTime  = -1
	moveDirection = Vector2(0, 0)
	#print("STOPOSPOSPSPSPO")
	

func _process(delta: float) -> void:
	if wanderTime == -1:
		return
		
	if wanderTime > 0:
		wanderTime = wanderTime - delta
	else: 
		stateMachine.Transitioned.emit(self, "Idle")
		
		
	if enemy.isControlled:
		stateMachine.Transitioned.emit(self, "IsControlled")
		
	return
		
func _physics_process(_delta: float) -> void:
	
	if enemy:
		enemy.velocity = moveDirection * wanderSpeed
		#print(enemy.velocity)
		
	#if not enemy.is_on_floor():
		#enemy.velocity.y += enemy.gravity * delta
		
		
	
	return
