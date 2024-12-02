extends State
class_name Enemy1IsControlled


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var enemy: Enemy

var spearProjectile = preload("res://Alive/Enemy1/spearProjectile.tscn")

var hasDied: bool = false
var lastDirection: bool = false
var canAttack: bool = true
var bodyHealth: float = 100

func enter() -> void:
	healthComponent.health = bodyHealth
	animatedSprite.play("Idle")
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
		var mousePos = owner.get_global_mouse_position()
		var direction = (mousePos - enemy.global_position).normalized()
		throwSpear(direction)
	
	
func _physics_process(_delta: float) -> void:
	if !enemy.isControlled:
		return
	
	if get_parent().get_parent().get_parent().velocity.x > 0:
		lastDirection = false
	elif get_parent().get_parent().get_parent().velocity.x < 0:
		lastDirection = true
		
	if canAttack:
		faceForward()

func throwSpear(direction: Vector2):
	canAttack = false
	
	if direction.x < 0:
		animatedSprite.flip_h = false
	elif direction.x > 0:
		animatedSprite.flip_h = true
		
	animatedSprite.play("Attack")
	await get_tree().create_timer(.5).timeout
	
	var spear: Area2D = spearProjectile.instantiate()
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	projectilesNode.add_child(spear)
	
	spear.hitboxComponent.set_collision_layer_value(8, false)
	spear.hitboxComponent.set_collision_mask_value(8, false)
	spear.hitboxComponent.set_collision_layer_value(9, true)
	spear.hitboxComponent.set_collision_mask_value(9, true)
	
	spear.position = enemy.global_position
	spear.velocity = direction.normalized() * 3
	spear.rotation = direction.angle()
	
	animatedSprite.play("Idle")
	canAttack = true

func faceForward() -> void:
	if lastDirection:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
