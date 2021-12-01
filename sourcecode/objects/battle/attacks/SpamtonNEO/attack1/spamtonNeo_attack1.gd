extends Node2D

var lifeTimer:float = 0.0;

var pellet = preload("res://objects/battle/projectiles/SpamtonNEO/projSpamtonPellet.tscn")

func _ready():
	get_tree().current_scene.get_node("spamtonNEO").chainedHeart = true;

func _process(delta):
	lifeTimer += delta;
