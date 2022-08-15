extends KinematicBody2D

const UP = Vector2(0, 1)
const GRAVITY = 3
export (PackedScene) var Plasmashoot
var velocity = Vector2.ZERO
var input = Vector2.ZERO
var max_speed = 180
var acceleration = 20
var friction = 10
var jetpack_energy = 10		#the fuel of the jetpack
var max_jetpack_energy = 10
var jetpack_power = 5		#the power of the jetpack
var jetpackTimer_started = false
var fuel_burn = false
var oxygen = 200
var max_oxygen = 200
var health = 100
var max_health = 100
var uses_oxygen = true
var weapon_in_cooldown = false


func _ready():
	pass


func _physics_process(delta):
	update_gui()
	apply_gravity()
	check_for_input()
	set_correct_JetpackTimer()
	check_for_flip()
	arm_movement()
	velocity = move_and_slide(velocity, UP)


func check_for_input():
	check_for_flight()
	movement_on_x_axis()
	check_for_firing()


func check_for_firing():
	if Input.is_action_pressed("shoot"):
		if weapon_in_cooldown == false:
			fire()


func fire():
	$FiringSound.play()
	var shoot = Plasmashoot.instance()
	owner.add_child(shoot)
	shoot.transform = $Arm/EndOfGunPosition.global_transform
	weapon_in_cooldown = true
	$WeaponTimer.start()


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, friction)


func apply_acceleration(strength):
	velocity.x = move_toward(velocity.x, max_speed * strength, acceleration)


func movement_on_x_axis():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
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
	if fuel_burn == true and jetpack_energy > 1:
		$JetpackTimer.wait_time = 0.1
	else:
		$JetpackTimer.wait_time = 1


func _on_JetpackTimer_timeout():
	if fuel_burn == false:
		if jetpack_energy < max_jetpack_energy:
			jetpack_energy += 1
	elif fuel_burn == true:
		jetpack_energy -= 1
	$JetpackTimer.start()


func update_gui():
	get_tree().call_group("GUI", "update_jetpack", jetpack_energy, max_jetpack_energy)
	get_tree().call_group("GUI", "update_health", health, max_health)
	get_tree().call_group("GUI", "update_oxygen", oxygen, max_oxygen)
	get_tree().call_group("GUI", "update_weapon_status", weapon_in_cooldown)


func _on_OxygenTimer_timeout():
	if uses_oxygen == true and oxygen > 0:
		oxygen -= 1
	elif uses_oxygen == true and oxygen == 0:
		health -= 1
	$OxygenTimer.start()


func _on_WeaponTimer_timeout():
	weapon_in_cooldown = false


func check_for_flip():
	if get_global_mouse_position().x < global_position.x:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false


func arm_movement():
	$Arm.look_at(get_global_mouse_position())
	if get_global_mouse_position().x < $Arm.global_position.x:
		$Arm.flip_v = true
	else:
		$Arm.flip_v = false


func hurt(damage):
	health -= damage
