extends State
class_name Enemy2Idle


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

@export var enemy:Enemy2

var stillTime: float


func randomizezStillTime()  -> void:
	stillTime = randf_range(0, 4)
	
	
func enter() -> void:
	animatedSprite.play("Pixie Idle")
	randomizezStillTime()
	
	 
func exit()	->void:
	stillTime = 0
	
func _process(delta: float) -> void:
	if enemy.isDead:	
		return
		
	

	if stillTime > 0:
		stillTime = stillTime - delta
	else:
		stateMachine.Transitioned.emit(self, "Wander")
		
	return
