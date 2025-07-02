extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Явно указываем тип и проверяем нод
@onready var animated_sprite: AnimatedSprite2D = get_node("AnimatedSprite")

func _ready():
	add_to_group("player")
	if not animated_sprite:
		push_error("AnimatedSprite node not found!") # Выведет ошибку, если нод отсутствует


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		if animated_sprite and animated_sprite.animation in ["jump1", "jump2"]:
			animated_sprite.play("idle")
	if Input.is_action_pressed("ui_push") and is_on_floor():
		$AnimatedSprite.play("push")
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if animated_sprite:
			animated_sprite.play("jump1")

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if animated_sprite:
			animated_sprite.flip_h = direction < 0
			if is_on_floor():
				animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if animated_sprite and is_on_floor():
			animated_sprite.play("idle")

	if velocity.y > 0 and not is_on_floor() and animated_sprite:
		animated_sprite.play("jump2")

	move_and_slide()
