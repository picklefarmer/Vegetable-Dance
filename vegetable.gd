class_name Vegetable
extends RigidBody3D

var isFacing = false
var isDancing = true
@export var amount = 10	
@export var hop = 10
@export var type = "tomato"
@export var jump = 23
var enabled = false
var isbuffer = false
#var vegetableObject = preload("res://broccoli.tscn")
@onready var audio_stream_player : AudioStreamPlayer = $"../AudioStreamPlayer"

var record_bus_index : int
#var record_effect: AudioEffectRecord
var spectrum_analyzer: AudioEffectSpectrumAnalyzerInstance
@export var MIN_DB: int = 68
@export var minimum = 0.25
@export var multiplier : float = 4
@export var deltav : float = 1.0
func _ready() -> void:
	
	#print(AudioServer.get_input_device_list())
	record_bus_index = AudioServer.get_bus_index("recording")
	#record_effect = AudioServer.get_bus_effect(record_bus_index,0)
	spectrum_analyzer = AudioServer.get_bus_effect_instance(record_bus_index,0)
	#record_effect.set_recording_active(true)
	

func _process(delta: float) -> void:
	

	if spectrum_analyzer and enabled:
		var volume_mag = spectrum_analyzer.get_magnitude_for_frequency_range(350.0,3000.0,AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_AVERAGE).length()
		volume_mag = clamp((MIN_DB + linear_to_db(volume_mag))/MIN_DB,0,1)
		print(volume_mag, "volume")
		#print( volume_mag)
		if volume_mag > minimum:
			#print(volume_mag,"Volume")
			#position.x = volume_mag * multiplier
		
			#rotation.z = -volume_mag * multiplier
			linear_velocity.y = volume_mag * multiplier
			#print(position.x , "position")
		else:
			#position.x = 0
			#rotation.z = 0
			linear_velocity = Vector3.ZERO
			position.y = 1 


func _on_body_entered(body: Node) -> void:
	
	if body is Blade:
		if Global.buffer:
			pass
		else:
			isDancing = false
			Global.buffer = true
			if scale.y > .25:
				scale -= Vector3.ONE/6
				var Knife = body
			
				var knifeLoc = Knife.position
			
				Action.pushSlice.emit(type)
	
				look_at(knifeLoc,Vector3.UP)
				rotate(Vector3.UP,PI)
			
				#linear_velocity += Vector3.FORWARD*10
				linear_velocity = global_transform.basis * Vector3(0,0,-jump) 
				#apply_central_force(-global_transform.basis.z*50)
			
				duplicateVeggie(scale.y)
				await get_tree().create_timer(0.125).timeout
				Global.buffer = false
			else:
				Action.complete.emit()
				queue_free()
				
			
		
func duplicateVeggie(veggieScale):
	var veggie = duplicate()
#
	var start = position
	#var forward : Vector3 = -global_transform.basis.z
	#var forward : Vector3 = -$Empty.basis.x
	#start.y = position.y + 3
	#veggie.position = start
	veggie.scale = Vector3.ONE* veggieScale
	##$SliceSound.play()
	#
	get_tree().root.get_node("Main").add_child(veggie)
	#get_tree().root.add_child(veggie)
	#
	#
	
	
	
func _on_timer_timeout() -> void:
	if isDancing:
		if isFacing:
			linear_velocity += Vector3(amount,hop,0)
			isFacing = false
		else:
			linear_velocity += Vector3(-amount,hop,0)
			isFacing = true
	
