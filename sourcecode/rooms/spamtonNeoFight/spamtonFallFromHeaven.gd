extends Node2D

var lifeTimer:float = 0.0;

func _ready():
	$AnimationPlayer.play("fallFromHeaven");

func _process(delta):
	lifeTimer += delta;
	
	if (lifeTimer >= 10.0):
		get_tree().change_scene("res://rooms/creditsAndMenu/creditsAndMenu.tscn");
