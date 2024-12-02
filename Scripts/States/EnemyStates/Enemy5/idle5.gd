extends State
class_name Enemy5Idle


@export var enemy:Enemy5

@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

var isIdle: bool = false
var stillTime: float


func randomizezStillTime()  -> void:
	stillTime = randf_range(0, 9)
	
	
func enter() -> void:
	randomizezStillTime()
	isIdle = true
	
	 
func exit()	->void:
	stillTime = 0
	isIdle = false
	
func _process(delta: float) -> void:
	if !isIdle:
		return
		
	
	#if enemy.isDead:
		#return
	
	
	if stillTime > 0:
		animatedSprite.play("Idle")
		stillTime = stillTime - delta
	else:
		stateMachine.Transitioned.emit(self, "Wander")
		
	return
