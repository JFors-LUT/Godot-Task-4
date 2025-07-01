extends Node

@onready var player = $Player

var current_level: Node = null

func _ready():
	change_level("res://Scenes/Level1.tscn")

func _on_player_fell(body) -> void:
	if body == player:
		player.reset_to_start()
		
func _on_player_dead(path: String) -> void:
	change_level(path)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_all_coins_collected(next_level_path: String) -> void:
	change_level(next_level_path)

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
	
