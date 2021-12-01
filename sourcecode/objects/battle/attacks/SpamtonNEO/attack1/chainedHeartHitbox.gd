extends Area2D

var hit:bool = false;
var hitCount:int = 0;

func _ready():
	set_meta("projectileType","ENEMY");

func _process(delta):
	pass
