extends Node

const LEVEL1_SCENE = preload("res://Scenes/level1.tscn")
const LEVEL2_SCENE = preload("res://Scenes/level2.tscn")

@onready var player = $Player
@onready var current_level: Node = null
@onready var current_level_scene: PackedScene = null


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
	
	current_level_scene = LEVEL1_SCENE
	
func _on_player_fell(body) -> void:
	if body == player:
		player.reset_to_start()
		
func _on_player_dead() -> void:
	restart_level()
		
func restart_level() -> void:
	if current_level:
		current_level.queue_free()
	var new_level = current_level_scene.instantiate()
	add_child(new_level)
	current_level = new_level
	
	if current_level.has_signal("player_fell"):
		current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	if current_level.has_signal("all_coins_collected"):
		current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	if current_level.has_signal("player_dead"):
		current_level.connect("player_dead", Callable(self, "_on_player_dead"))

	$Player.global_position = Vector2(0,0)
	

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


		
func _load_new_level(_next_level_path: String) -> void:
	#var scene = load(next_level_path)
	var new_level = LEVEL2_SCENE.instantiate()
	add_child(new_level)
	current_level = new_level

	
	if current_level.has_signal("player_fell"):
		current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	if current_level.has_signal("all_coins_collected"):
		current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	if current_level.has_signal("player_dead"):
		current_level.connect("player_dead", Callable(self, "_on_player_dead"))


	$Player.global_position = Vector2(0,0)
	current_level_scene = LEVEL2_SCENE

#func change_level(path: String) -> void:
	#if current_level and current_level.is_inside_tree():
		#current_level.queue_free()
#
	#var scene = load(path)
	#var new_level = scene.instantiate()
#
	#add_child(new_level)
	#current_level = new_level
	#
	#if current_level.has_signal("player_fell"):
		#current_level.connect("player_fell", Callable(self, "_on_player_fell"))
	#if current_level.has_signal("all_coins_collected"):
		#current_level.connect("all_coins_collected", Callable(self, "_on_all_coins_collected"))
	#if current_level.has_signal("player_dead"):
		#current_level.connect("player_dead", Callable(self, "_on_player_dead"))
#
	#
	#$Player.global_position = Vector2(0,0)
	
