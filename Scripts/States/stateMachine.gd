extends Node
class_name StateMachine


@onready var enemyDetector: Area2D = %EnemyDetector

@export var enemy: Enemy
@export var initialState: State

var currentState: State
var states: Dictionary =  {}

signal Transitioned


func _ready() -> void:
	Transitioned.connect(onChildTransition)
	
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child

	if initialState:
		initialState.enter()
		currentState = initialState


func _process(delta: float) -> void:
	if currentState:
		currentState._process(delta)
	
	
func _physics_process(delta: float) -> void:
	if currentState:
		currentState._physics_process(delta)


func onChildTransition(state, newStateName):
	if state != currentState:
		return
		
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
		
	if currentState:
		currentState.exit()
		
	newState.enter()
	currentState = newState

	
	
	
	
