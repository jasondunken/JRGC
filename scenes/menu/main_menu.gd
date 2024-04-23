class_name MainMenu
extends Control


@onready var start_button = %StartButton as Button
@onready var settings_button = %SettingsButton as Button
@onready var exit_button = %ExitButton as Button


func _ready():
	start_button.pressed.connect(start_pressed)
	settings_button.pressed.connect(settings_pressed)
	exit_button.pressed.connect(exit_pressed)


func _process(_delta):
	pass


func start_pressed() -> void:
	print("start pressed")


func settings_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/settings_menu.tscn")


func exit_pressed() -> void:
	get_tree().quit()
