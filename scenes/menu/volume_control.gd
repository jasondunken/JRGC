class_name VolumeControl
extends HBoxContainer


@export var bus_name: String

@onready var control_name = %Name
@onready var control_slider = %Slider
@onready var control_value = %Value

var bus_index: int


func _ready():
	control_name.text = bus_name
	bus_index = AudioServer.get_bus_index(bus_name)
	control_slider.value_changed.connect(slider_changed)
	set_control(UserIngameSettings.get_value(bus_name))


func slider_changed(value) -> void:
	set_control(value)


func set_control(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	UserIngameSettings.set_value(bus_name, value)
	set_labels()


func set_labels() -> void:
	var vol = get_bus_volume_linear()
	control_slider.value = vol
	control_value.text = str(int(vol * 100))


func get_bus_volume_linear() -> float:
	var value = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(value)
