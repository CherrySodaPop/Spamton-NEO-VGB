extends Area2D

var hitCount:int = 0;
var prevHitCount:int = 0;

func _ready():
	set_meta("projectileType","ENEMY");
	connect("area_entered",self,"_TouchingArea");

func _process(delta):
	pass

func _TouchingArea(area:Area2D):
	if (area.name == "HitboxCollisionSoul"):
		get_tree().current_scene.get_node("USER_SOUL").health = 0;
