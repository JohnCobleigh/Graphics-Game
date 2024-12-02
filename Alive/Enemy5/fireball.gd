extends Area2D

@onready var hitboxComponent: HitboxComponent = $HitboxComponent
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D


var velocity: Vector2 = Vector2.ZERO
var speed = 200
var canHit: bool = true


func _ready() -> void:
	animatedSprite.play("Fireball")

func _process(delta: float) -> void:
	position += velocity * speed * delta


func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Player:
		var hitbox: HitboxComponent = area
		hitbox.damage(25)
		queue_free()
	
	if  area.get_parent().get_parent() is Enemy and hitboxComponent.get_collision_layer_value(9):
		canHit = false
		var hitbox: HitboxComponent = area
		hitbox.damage(40)
		queue_free()
