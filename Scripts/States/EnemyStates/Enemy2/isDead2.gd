extends State
class_name Enemy2IsDead


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var enemy: Enemy2

var firstTime: bool = true

func enter() -> void:
	if firstTime == true:
		healthComponent.health = 100
		firstTime = false
	animatedSprite.play("Still")
	enemy.isDead = true
	enemy.set_collision_mask_value(2, false)
	enemy.hitboxComponent.set_collision_mask_value(2, false)
	enemy.set_collision_layer_value(3, false)
	enemy.hitboxComponent.set_collision_mask_value(3, false)
	enemy.hitboxComponent.set_collision_layer_value(4, false)
	enemy.hitboxComponent.set_collision_layer_value(9, false)
	enemy.hitboxComponent.set_collision_mask_value(10, false)
	enemy.enemyDetector.set_collision_mask_value(8, false)
	enemy.enemyDetector.set_collision_mask_value(10, false)
	

func _process(_delta: float) -> void:
	if enemy.isControlled:
		stateMachine.Transitioned.emit(self, "IsControlled")

func _physics_process(delta: float) -> void:
	if enemy.isDead and enemy.isControlled == false:
		enemy.velocity.y += 8000 * delta
