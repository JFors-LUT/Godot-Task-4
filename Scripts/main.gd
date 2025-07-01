extends Node

const LEVEL1_SCENE = preload("res://Scenes/level1.tscn")
const LEVEL2_SCENE = preload("res://Scenes/level2.tscn")

@onready var player = $Player
@onready var current_level: Node = null


func _ready():
	var new_level = LEVEL1_SCENE.instantiate()
	add_child(new_level)
	current_level = new_level
	
	if current_level.has_signal("player_fell"):
		current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	if current_level.has_signal("all_coins_collected"):
		current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	if current_level.has_signal("player_dead"):
		current_level.connect("player_dead", Callable(self, "_on_player_dead"))
	
func _on_player_fell(body) -> void:
	if body == player:
		player.reset_to_start()
		
func _on_player_dead(path: String) -> void:
	change_level(path)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_all_coins_collected(next_level_path: String) -> void:
	call_deferred("_change_level_deferred", next_level_path)

func _change_level_deferred(next_level_path: String) -> void:
	if current_level and current_level.is_inside_tree():
		current_level.queue_free()
		await get_tree().process_frame 
		call_deferred("_load_new_level", next_level_path)

func _load_new_level(next_level_path: String) -> void:
	var scene = load(next_level_path)
	var new_level = scene.instantiate()
	add_child(new_level)
	current_level = new_level

	
	if current_level.has_signal("player_fell"):
		current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	if current_level.has_signal("all_coins_collected"):
		current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	if current_level.has_signal("player_dead"):
		current_level.connect("player_dead", Callable(self, "_on_player_dead"))
		
	for child in get_tree().root.get_child(0).get_children():
		print(child.name)	
	$Player.global_position = Vector2(0,0)

func change_level(path: String) -> void:
	if current_level and current_level.is_inside_tree():
		current_level.queue_free()

	var scene = load(path)
	var new_level = scene.instantiate()

	add_child(new_level)
	current_level = new_level
	
	if current_level.has_signal("player_fell"):
		current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	if current_level.has_signal("all_coins_collected"):
		current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	if current_level.has_signal("player_dead"):
		current_level.connect("player_dead", Callable(self, "_on_player_dead"))

	
	$Player.global_position = Vector2(0,0)
	
