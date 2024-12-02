extends CharacterBody2D
class_name Enemy


@export var isControlled: bool = false

@onready var isDead: bool = false
@onready var worldCollision: CollisionShape2D = null 
@onready var stateMachine: StateMachine = null
