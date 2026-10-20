extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -800.0
var maximale_hp : int = 5
var hp: int = 5
signal hp_verandering(hp_dat_het_nu_is)
signal dood

func shade_genomen():
	hp -= 1
	print("ik nam schade")
	if hp <= 0:
		dood.emit()
	else:
		hp_verandering.emit(hp)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("spring") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : float = Input.get_axis("links", "rechts")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if position.y > 400:
		position = Vector2(0,0)
	move_and_slide()
