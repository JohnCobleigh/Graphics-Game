extends Area2D
class_name HitboxComponent

@export var person: CharacterBody2D
@export var healthComponent: HealthComponent
@export var collisionShape: CollisionShape2D
#@export var master: CharacterBody2D


func damage(damageDealt):
	if healthComponent:
		healthComponent.takeDamage(damageDealt)

func heal(damageDealt):
	if healthComponent:
		healthComponent.heal(damageDealt)
