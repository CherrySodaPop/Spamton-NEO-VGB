extends Area2D

var lifeTimer:float = 0.0;
var sndBigShot = preload("res://objects/sounds/sndBigShot.tscn");

func _ready():
	connect("area_entered",self,"_TouchingArea");
	var tmpObj = sndBigShot.instance();
	get_tree().current_scene.add_child(tmpObj);
	get_tree().current_scene.soulBigshots += 1;

func _process(delta):
	lifeTimer += delta;
	transform.origin.x += 120.0 * delta;
	if (lifeTimer >= 6.0): queue_free();
	if (global_transform.origin.x >= 90): queue_free();

func _TouchingArea(area:Area2D):
	if (area.has_meta("projectileType") && area.get_meta("projectileType") == "ENEMY"):
		if ("hitCount" in area): area.hitCount += 1;
		if ("hit" in area): area.hit = true;
		if ("chargeHit" in area): area.chargeHit = true;
		if (area.has_meta("destroyBigShot") && area.get_meta("destroyBigShot") == true): queue_free();
