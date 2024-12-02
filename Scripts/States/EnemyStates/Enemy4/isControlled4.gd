extends State
class_name Enemy4IsControlled


@onready var stateMachine: StateMachine = %StateMachine
@onready var animatedSprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var healthComponent: HealthComponent = %HealthComponent

@export var enemy: Enemy

var bombProjectile = preload("res://Alive/Enemy4/Bomb.tscn")

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
	if enemy.get_parent().velocity == Vector2(0, 0):
		animatedSprite.play("Idle")
	else:
		animatedSprite.play("Wander")
		
		
	if Input.is_action_just_pressed("attack") and canAttack == true:
		var mousePos: Vector2 = owner.get_global_mouse_position()
		var direction: Vector2 = (mousePos - enemy.global_position).normalized()
		throwSpear(direction, mousePos)

func _physics_process(_delta: float) -> void:
	if !enemy.isControlled:
		return
	
	if get_parent().get_parent().get_parent().velocity.x > 0:
		lastDirection = false
	elif get_parent().get_parent().get_parent().velocity.x < 0:
		lastDirection = true

	if canAttack == true:
		faceForward()

func throwSpear(direction: Vector2, mousePos: Vector2):
	canAttack = false
	
	if direction.x < 0:
		animatedSprite.flip_h = false
	elif direction.x > 0:
		animatedSprite.flip_h = true
	
	var bomb: Area2D = bombProjectile.instantiate()
	var main: Node2D = get_tree().root.get_node("main")
	var projectilesNode: Node = main.get_projectiles_node()
	projectilesNode.add_child(bomb)
	
	bomb.hitboxComponent.set_collision_layer_value(8, false)
	bomb.hitboxComponent.set_collision_mask_value(8, false)
	bomb.hitboxComponent.set_collision_layer_value(9, true)
	bomb.hitboxComponent.set_collision_mask_value(9, true)
	
	bomb.position = enemy.global_position
	bomb.velocity = direction.normalized() * 3
	bomb.rotation = direction.angle()
	
	var distance = bomb.position.distance_to(mousePos)
	print(distance)
	var travelTime = distance / bomb.speed / 3.2
	bomb.lifetime = travelTime
	await get_tree().create_timer(.9).timeout
	
	canAttack = true
	
func faceForward() -> void:
	if lastDirection:
		animatedSprite.flip_h = false
	else:
		animatedSprite.flip_h = true
