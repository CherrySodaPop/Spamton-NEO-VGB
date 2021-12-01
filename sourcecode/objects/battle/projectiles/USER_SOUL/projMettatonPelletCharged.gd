extends Area2D

var lifeTimer:float = 0.0;

func _ready():
	connect("area_entered",self,"_TouchingArea");

func _process(delta):
	lifeTimer += delta;
	transform.origin.x += 120.0 * delta;
	if (lifeTimer >= 6.0): queue_free();

func _TouchingArea(area:Area2D):
	if (area.has_meta("projectileType") && area.get_meta("projectileType") == "ENEMY"):
		if ("hitCount" in area): area.hitCount += 1;
		if ("hit" in area): area.hit = true;
