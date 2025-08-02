extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 14.5
@export var ROTATE_SPEED = 25
@export var Countdown = 100
@export var winAmount = 1200
var isPlaying = true
@export var vegetable = {
	"tomato": preload("res://slice.tscn"),
	"broccoli": preload("res://greenSlice.tscn")
	}
	
	
var knifeCollider
#@onready var tomato = preload("res://slice.tscn")
var rotationalAmount = 0
func vegetableDone():
	$Empty/Camera3D/Display.visible = true
	await get_tree().create_timer(1).timeout
	$Empty/Camera3D/Display.visible = false
	
func _ready() -> void:
	knifeCollider = $Empty/Armature/Skeleton3D/Cube/KnifeBlade3d
	Action.pushSlice.connect(throw) 
	Action.complete.connect(vegetableDone)
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_pressed("rotateL"):
		
			
		var degree = ROTATE_SPEED * delta
		$Empty.transform = $Empty.transform.rotated(Vector3.UP,-degree)
		rotationalAmount += -degree
		
	if Input.is_action_pressed("rotateR"):
		
		var degree = ROTATE_SPEED * delta
		$Empty.transform = $Empty.transform.rotated(Vector3.UP,degree)
		rotationalAmount += degree

	velocity = velocity.rotated(Vector3.UP,rotationalAmount)
	move_and_slide()




func throw(veggie):
	var thrown = vegetable[veggie].instantiate()

	var start = position
	#var forward : Vector3 = -global_transform.basis.x
	var forward : Vector3 = -$Empty.basis.x
	start.y = position.y + 3
	thrown.position = start
	
	$SliceSound.play()
	
	get_tree().root.add_child(thrown)
	thrown.scale = Vector3.ONE * randf_range(1,0)
	#print(forward*50, "thrown")
	thrown.apply_impulse(forward * 20.0)

	if isPlaying:
		var score = int($Empty/Camera3D/Label.text) + 5
		$Empty/Camera3D/Label.text = "Score: "+str(score)
		if score >= winAmount:
			$"Empty/Camera3D/You Win".visible = true
			$Timer.stop()
			$"../AudioStreamPlayer".stop()
			isPlaying = false
		

func _on_timer_timeout() -> void:
	Countdown -= 1
	$Empty/Camera3D/PC/Label2.text = str(Countdown)
	
	if Countdown == 0 :
		$Timer.stop()
		$"../AudioStreamPlayer".stop()
		isPlaying = false
		
