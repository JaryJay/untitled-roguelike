extends Control

const WORLD_SCENE_PATH: String = "world/world.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(WORLD_SCENE_PATH)

func _process(_delta: float) -> void:
	var status: = ResourceLoader.load_threaded_get_status(WORLD_SCENE_PATH)
	if status == ResourceLoader.THREAD_LOAD_LOADED:
		$NewRunButton.disabled = false

func _on_new_run_button_pressed() -> void:
	var world_scene: = ResourceLoader.load_threaded_get(WORLD_SCENE_PATH)
	if world_scene is PackedScene:
		get_tree().change_scene_to_packed(world_scene)
	else:
		printerr("you dun goofed")
