extends State
class_name Enemy4Idle

@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D

@export var enemy:Enemy

var isIdle: bool = false
var stillTime: float


func randomizezStillTime()  -> void:
	stillTime = randf_range(0, 9)
	
	
func enter() -> void:
	animatedSprite.play("Idle")
	randomizezStillTime()
	isIdle = true
	
	 
func exit()	->void:
	stillTime = 0
	isIdle = false
	
func _process(delta: float) -> void:
	if !isIdle:
		return


	if stillTime > 0:
		stillTime = stillTime - delta
	else:
		stateMachine.Transitioned.emit(self, "Wander")