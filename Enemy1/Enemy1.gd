extends Enemy
class_name Enemy1

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
#const isControllable: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isDead = false





func _ready():
	print(get_class())
	#Globals.enemy1 = self
	isControlled = false



#func _physics_process(delta):
	#if isControlled == false:
		#return
		#
		#
#
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("left", "right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)

	#move_and_slide()


func ai() -> void:
	pass
