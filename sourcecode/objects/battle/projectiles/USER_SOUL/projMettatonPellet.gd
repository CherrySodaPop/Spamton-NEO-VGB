extends Area2D

var lifeTimer:float = 0.0;
var sndPew = preload("res://objects/sounds/sndSoulMettatonFire.tscn");

func _ready():
	connect("area_entered",self,"_TouchingArea");
	var tmpObj = sndPew.instance();
	get_tree().current_scene.add_child(tmpObj);

func _process(delta):
	lifeTimer += delta;
	transform.origin.x += 120.0 * delta;
	if (lifeTimer >= 6.0): queue_free();
	if (global_transform.origin.x >= 90): queue_free();

func _TouchingArea(area:Area2D):
	if (area.has_meta("projectileType") && area.get_meta("projectileType") == "ENEMY"):
		if ("requiresChargedShot" in area):
			if (!area.requiresChargedShot): 
				if ("hitCount" in area): area.hitCount += 1;
		else:
			if ("hitCount" in area): area.hitCount += 1;
			if ("hit" in area): area.hit = true;
		if (area.has_meta("blockPellet")):
			if (area.get_meta("blockPellet") == true):
				queue_free();
		else:
			queue_free();
