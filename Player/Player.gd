extends KinematicBody2D

const UP = Vector2(0, 1)
const GRAVITY = 4
var velocity = Vector2.ZERO
var input = Vector2.ZERO
var max_speed = 180
var acceleration = 20
var friction = 10
var jetpack_energy = 10		#the fuel of the jetpack
var max_jetpack_energy = 10
var jetpack_power = 5		#the power of the jetpack
var jetpackTimer_started = false
var jetpack_in_cooldown = false
var fuel_burn = false


func _ready():
	$JetpackTimer.start()


func _physics_process(delta):
	apply_gravity()
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	movement_on_x_axis()
	check_for_flight()
	set_correct_JetpackTimer()
	velocity = move_and_slide(velocity, UP)


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, friction)


func apply_acceleration(strength):
	velocity.x = move_toward(velocity.x, max_speed * strength, acceleration)


func movement_on_x_axis():
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)


func apply_gravity():
	velocity.y += GRAVITY


func check_for_flight():
	if Input.is_action_pressed("jetpack") and jetpack_energy >= 1:
		jetpack_active()
	else:
		apply_gravity()
		fuel_burn = false


func jetpack_active():
	velocity.y -= jetpack_power
	fuel_burn = true


func set_correct_JetpackTimer():
	if fuel_burn == true:
		$JetpackTimer.wait_time = 0.1
	else:
		$JetpackTimer.wait_time = 1


func _on_JetpackTimer_timeout():
	if fuel_burn == false:
		if jetpack_energy < max_jetpack_energy:
			jetpack_energy += 1
	elif fuel_burn == true:
		if jetpack_in_cooldown:
			pass
		else:	
			jetpack_energy -= 1
	print(jetpack_energy)
	$JetpackTimer.start()

