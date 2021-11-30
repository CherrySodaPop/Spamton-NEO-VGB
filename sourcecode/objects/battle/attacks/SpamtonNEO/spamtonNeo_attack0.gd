extends Node2D

var lifeTimer:float = 0.0;

func _ready():
	pass

func _process(delta):
	lifeTimer += delta;
	if (lifeTimer > 8.0):
		get_tree().current_scene.ExitAttack();
		queue_free();
	
