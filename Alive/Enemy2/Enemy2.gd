extends Enemy
class_name Enemy2


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var hitboxComponent: HitboxComponent = $Components/HitboxComponent
@onready var enemyDetector: Area2D = %EnemyDetector
@onready var detectedPlayer: CharacterBody2D
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var spawnPosition: Vector2 = Vector2(0,0)


var detectedHitbox: Area2D
var offset: Vector2


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")





func _ready():
	isControlled = false
	worldCollision = %WorldCollision
	stateMachine = %StateMachine


func _physics_process(_delta):
	if isControlled == true:
		return
		
		
	
	if stateMachine.currentState != stateMachine.states.guard and stateMachine.currentState != stateMachine.states.attack:
		rotateMesh()
		
		
	move_and_slide()

func die() -> void:
	
	stateMachine.Transitioned.emit(stateMachine.currentState, "isDead")
	#queue_free()


func rotateMesh() -> void:
	var lastDirection: float = 0
	lastDirection = velocity.x
	if lastDirection < 0:
		animatedSprite.flip_h = false
		enemyDetector.scale.x = -abs(enemyDetector.scale.x)
	elif lastDirection > 0 :
		animatedSprite.flip_h = true
		enemyDetector.scale.x = abs(enemyDetector.scale.x)

	
	


func _on_enemy_detector_area_entered(area: Area2D) -> void:
	
	#print("IN AREA")
	if area is HitboxComponent and area.get_parent().get_parent() is Player and stateMachine.currentState != stateMachine.states.isdead:
		detectedPlayer = area.get_parent().get_parent() as CharacterBody2D
		#print(detectedPlayer)
		#print("GUARD")
		stateMachine.Transitioned.emit(stateMachine.currentState, "Guard")



func _on_enemy_detector_area_exited(area: Area2D) -> void:
	if area is HitboxComponent and area.get_parent().get_parent() is Player:
		detectedPlayer = null 
