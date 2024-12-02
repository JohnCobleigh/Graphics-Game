extends State
class_name Enemy2IsControlled


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var enemy: Enemy2

var pixieAttackCircle = preload("res://Alive/Enemy2/pixieAttackCircle.tscn") 

var hasDied = false
var lastDirection: bool = true
var canAttack: bool = true
var bodyHealth: float = 100

func enter() ->  void:
	healthComponent.health = bodyHealth
	animatedSprite.play("Pixie Idle")
	hasDied = true

func exit() -> void:
	healthComponent.health  = bodyHealth
	
func _process(_delta: float) -> void:
	if hasDied == true and !enemy.isControlled:
		stateMachine.Transitioned.emit(self, "IsDead")
		
	if !enemy.isControlled:
		return

	bodyHealth = enemy.get_parent().healthComponent.health
	if Input.is_action_just_pressed("attack") and canAttack == true:
		doAttack()


func _physics_process(_delta: float) -> void:
	if !enemy.isControlled:
		return
	
	if get_parent().get_parent().get_parent().velocity.x > 0:
		lastDirection = false
	elif get_parent().get_parent().get_parent().velocity.x < 0:
		lastDirection = true
		
	if canAttack:
		faceForward()

func doAttack() -> void:
	canAttack = false
	animatedSprite.play("Pixie Attack")
	
	await  get_tree().create_timer(.4).timeout
	var attack_circle: Area2D = pixieAttackCircle.instantiate()
	
	attack_circle.position = enemy.global_position
	get_tree().current_scene.add_child(attack_circle)
	
	await  get_tree().create_timer(.4).timeout
	canAttack = true
	animatedSprite.play("Pixie Idle")
	
	
func faceForward() -> void:
	if lastDirection:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
