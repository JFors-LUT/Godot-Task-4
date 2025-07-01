class_name Spike extends Area2D

signal player_death
var can_trigger = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.global_position = Vector2(0, 0)
		emit_signal("player_death")
		
		
