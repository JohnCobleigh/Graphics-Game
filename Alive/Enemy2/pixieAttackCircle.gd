extends Area2D

@onready var hitboxCollision: CollisionShape2D = $HitboxComponent/HitboxCollision

@export var targetScale: Vector2 = Vector2(200, 200)
@export var growDuration: float = .2

var canHit: bool = true
var initialScale: Vector2 = Vector2.ZERO
var elapsedTime: float = 0.0


func _ready() -> void:
	scale = initialScale
	
func _process(delta: float) -> void:
	if elapsedTime < growDuration:
		elapsedTime += delta
		hitboxCollision.scale = hitboxCollision.scale + Vector2(100000, 100000)
	else:
		if canHit:
			canHit = false
			queue_free()



func _on_hitbox_component_area_entered(area: Area2D) -> void:
	if area.get_parent().get_parent() is Enemy and canHit:
		var hitbox: HitboxComponent = area
		hitbox.damage(34)
		queue_free()
