extends Node2D

var lifeTimer:float = 0.0;
var sparkleTick:float = 0.0;

var sndHeal = preload("res://objects/sounds/sndHeal.tscn")
var effectSparkle = preload("res://objects/battle/projectiles/SpamtonNEO/projF1HelpSparkle.tscn");

func _ready():
	pass # Replace with function body.

func _process(delta):
	lifeTimer += delta;
	sparkleTick += delta;
	if (sparkleTick >= 0.1):
		var tmpObj = effectSparkle.instance();
		get_tree().current_scene.add_child(tmpObj);
		tmpObj.global_transform.origin = $kris.global_transform.origin;
		tmpObj = effectSparkle.instance();
		get_tree().current_scene.add_child(tmpObj);
		tmpObj.global_transform.origin = $susie.global_transform.origin;
		tmpObj = effectSparkle.instance();
		get_tree().current_scene.add_child(tmpObj);
		tmpObj.global_transform.origin = $ralsei.global_transform.origin;
		sparkleTick = 0.0;
	
	var vecOffset = Vector2(10,-16);
	$kris.global_transform.origin = lerp($kris.global_transform.origin, get_tree().current_scene.get_node("world/kris").global_transform.origin + vecOffset, 3 * delta);
	$susie.global_transform.origin = lerp($susie.global_transform.origin, get_tree().current_scene.get_node("world/susie").global_transform.origin + vecOffset, 3 * delta);
	$ralsei.global_transform.origin = lerp($ralsei.global_transform.origin, get_tree().current_scene.get_node("world/ralsei").global_transform.origin + vecOffset, 3 * delta);
	
	if (lifeTimer >= 1.0):
		$kris.visible = true;
		$susie.visible = true;
		$ralsei.visible = true;
	
	if (lifeTimer >= 2.0):
		get_tree().current_scene.add_child(sndHeal.instance());
		get_tree().current_scene.get_node("USER_SOUL").health += 80;
		queue_free();
