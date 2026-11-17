
extends CharacterBody2D

@onready var SPRITE: AnimatedSprite2D = $Sprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -200.0

var maximale_hp: int = 5
var hp: int = 5

var spring_speel: bool = false
var land_speel: bool = false
var pijn_speel: bool = false
var vorige_vloer: bool = true

signal hp_verandering(hp_dat_het_nu_is)
signal dood


func _ready() -> void:
	SPRITE.animation_finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if SPRITE.animation == "spring":
		spring_speel = false
	elif SPRITE.animation == "land":
		land_speel = false
	elif SPRITE.animation == "pijn":
		pijn_speel = false


func change_animation(animation: String) -> void:
	if SPRITE.animation != animation:
		SPRITE.play(animation)


func shade_genomen():
	hp -= 1
	print("ik nam schade")
	
	if hp <= 0:
		dood.emit()
	else:
		hp_verandering.emit(hp)


func _physics_process(delta: float) -> void:
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction: float = Input.get_axis("links", "rechts")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if position.y > 400:
		position = Vector2.ZERO
		velocity = Vector2.ZERO
	
	if velocity.x < 0:
		SPRITE.flip_h = true
	elif velocity.x > 0:
		SPRITE.flip_h = false
	if Input.is_action_just_pressed("spring") and is_on_floor() and not pijn_speel:
		velocity.y = JUMP_VELOCITY
		spring_speel = true
		change_animation("spring")
	move_and_slide()
	var on_floor := is_on_floor()
	if on_floor and not vorige_vloer and not spring_speel and not pijn_speel:
		if abs(velocity.x) > 40:
			land_speel = false
			change_animation("lopen")
		else:
			land_speel = true
			change_animation("land")
	vorige_vloer = on_floor
	if not on_floor:
		if not spring_speel and not pijn_speel:
			if velocity.y < -20:
				change_animation("omhoog")
			elif velocity.y > 20:
				change_animation("val")
			else:
				change_animation("top")
	else:
		if not spring_speel and not land_speel and not pijn_speel:
			if abs(velocity.x) > 40:
				change_animation("lopen")
			else:
				change_animation("idle")
