class_name Level_2 extends Node2D

signal player_fell
signal all_coins_collected(next_level_path: String)

@onready var coins_parent = $Coins
var total_coins = 0
var collected_coins = 0
#func _on_DeathZone_body_entered(body):

		
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_coins = coins_parent.get_child_count()
	for coin in coins_parent.get_children():
		coin.connect("collected", Callable(self, "_on_coin_collected"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
func _on_coin_collected() -> void:
	collected_coins += 1
	if collected_coins == total_coins:
		emit_signal("all_coins_collected", "res://Scenes/Level1.tscn")

func _on_death_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_fell", body)
