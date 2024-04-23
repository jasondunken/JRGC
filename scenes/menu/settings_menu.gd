class_name SettingsMenu
extends Control


@onready var volume_controls = %VolumeControls
@onready var keybinds = %Keybinds
@onready var keybinds_reset_button = %ResetButton
@onready var back_button = %BackButton
@onready var fullscreen_check_box = %FullscreenCheckBox as CheckBox
@onready var v_sync_check_box = %VSyncCheckBox
@onready var resolution_options = %ResolutionOptions as OptionButton

var is_remapping: bool = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"up": "Up",
	"down": "Down",
	"left": "Left",
	"right": "Right",
	"jump": "Jump",
	"fire": "Fire",
	"inventory": "Inventory"
}

var display_resolutions: Dictionary = {
	"1920x1080": Vector2i(1920, 1080),
	"1680x1050": Vector2i(1680, 1050),
	"1600x900": Vector2i(1600, 900),
	"1440x900": Vector2i(1440, 900),
	"1400x1050": Vector2i(1400, 1050),
	"1366x768": Vector2i(1366, 768),
	"1360x768": Vector2i(1360, 768),
	"1280x1024": Vector2i(1280, 1024),
	"1280x960": Vector2i(1280, 960),
	"1280x800": Vector2i(1280, 800),
	"1280x768": Vector2i(1280, 768),
	"1280x720": Vector2i(1280, 720),
	"1280x600": Vector2i(1280, 600),
	"1152x864": Vector2i(1152, 864),
	"1024x768": Vector2i(1024, 768),
	"800x600": Vector2i(800, 600)
}

var keybind_control: PackedScene = preload("res://scenes/menu/keybind_control.tscn")

func _ready():
	setup_keybind_menu()
	keybinds_reset_button.pressed.connect(reset_keybinds)
	fullscreen_check_box.pressed.connect(toggle_fullscreen)
	v_sync_check_box.pressed.connect(toggle_vsync)
	setup_resolution_options()
	resolution_options.item_selected.connect(select_resolution)
	back_button.pressed.connect(go_back)
	


func setup_keybind_menu() -> void:
	for item in keybinds.get_children():
		item.queue_free()
	
	for action in input_actions:
		var button = keybind_control.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		action_label.text = input_actions[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		keybinds.add_child(button)
		button.pressed.connect(remap_keybind.bind(button, action))


func remap_keybind(button, action) -> void:
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."


func _input(event) -> void:
	if is_remapping:
		if (event is InputEventKey || (event is InputEventMouseButton && event.pressed)):
			# don't allow double click to be bound
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			accept_event()


func _update_action_list(button, event) -> void:
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func reset_keybinds() -> void:
	InputMap.load_from_project_settings()
	setup_keybind_menu()


func toggle_fullscreen() -> void:
	if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func toggle_vsync() -> void:
	if DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func setup_resolution_options() -> void:
	var current_resolution = DisplayServer.window_get_size()
	var id: int = 0
	for resolution in display_resolutions:
		resolution_options.add_item(resolution, id)
		var res = display_resolutions[resolution]
		resolution_options.set_item_metadata(id, res)
		if current_resolution == res:
			resolution_options.select(id)
		id += 1


func select_resolution(_index) -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	fullscreen_check_box.button_pressed = false
	set_resolution(resolution_options.get_selected_metadata())


func set_resolution(resolution) -> void:
	DisplayServer.window_set_size(resolution, 0)


func go_back() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")
