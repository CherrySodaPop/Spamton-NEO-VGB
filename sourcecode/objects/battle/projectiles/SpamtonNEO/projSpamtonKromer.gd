extends Area2D

var lifeTime:float = 0.0;
var moveAmp:float = 0.0;
var nonKromer:bool = false;
export (Vector2) var moveDir:Vector2 = Vector2.ZERO;

func _ready():
	set_meta("projectileType", "ENEMY");
	set_meta("damageAmount", 10);
	set_meta("blockPellet", false);

func _process(delta):
	lifeTime += delta;
	
	# this is done as in godot 3 you cant precache particles, causing a temporary stutter, i dont like that so:
	$kromer.visible = !nonKromer;
	$pellet.visible = nonKromer;
	$CollisionShape2D.disabled = nonKromer;
	
	moveAmp = clamp(moveAmp + (45 * delta),0.0,60);
	moveDir = (get_parent().get_node("BIGSHOT/head").global_transform.origin - transform.origin).normalized() * moveAmp;
	transform.origin += moveDir * delta;
	
	if (lifeTime > 8.0): queue_free();
