extends Node2D

var jevil_fight_force:bool = false; # WARNING!!!!!!!!! VERY BUGGY! BIG WORK IN PROGRESS

var BEGIN:bool = false;
var HESITATE:float = 0.0;
var DELAY:float = 0.0;
var GLOW:float = 0.0;
var ALLOW_CHOICE:int = -1;
var USER_CHOICE:int = 0;
var IMPATIENT:int = 0;
var IMPATIENTDELAY:float = 0.0;

var OBJDEPTH = preload("res://rooms/init/DEPTH.tscn");

func _ready():
	#get_tree().change_scene("res://rooms/spamtonNeoFight/spamtonFight.tscn")
	pass

func _process(delta):
	HESITATE += delta;
	
	if (ALLOW_CHOICE != 2 && Input.is_action_just_pressed("confirm")):
		IMPATIENT += 1;
		IMPATIENTDELAY = 0.0;
	
	if (IMPATIENT >= 8):
		get_tree().change_scene("res://rooms/spamtonNeoFight/spamtonFight.tscn");
		
	if (IMPATIENT != 0):
		IMPATIENTDELAY += delta;
	
	if (IMPATIENTDELAY > 0.5):
		IMPATIENT = 0;
		IMPATIENTDELAY = 0.0;
	
	$SOUL.offset.y = cos(HESITATE*2.0) * 2.0;
	
	if (HESITATE >= 2.0): $VOICE0.SPEAK = true;
	if (HESITATE >= 8.0): $VOICE1.SPEAK = true;
	if (HESITATE >= 20.0): $VOICE2.SPEAK = true;
	if (HESITATE >= 35.0): $VOICE3.SPEAK = true;
	if (HESITATE >= 48.0): $VOICE4.SPEAK = true;
	
	if (HESITATE >= 45.0):
		if (GLOW == 0.0): $SOUL_APPEAR.playing = true;
		if (GLOW <= PI / 2):
			GLOW += delta;
			$SOULGLOW.scale.x = sin(GLOW * 2.0);
		else:
			$SOULGLOW.scale.x = 0;
		if (GLOW >= PI / 4):
			$SOUL.visible = true;
	
	if (HESITATE >= 55.0):
		$HIM.pitch_scale = clamp($HIM.pitch_scale + (delta / 6.0),0.0,0.9);
		DELAY += delta;
		if (DELAY >= 1.0):
			DELAY = 0.0;
			var TEMPORARY = OBJDEPTH.instance();
			add_child(TEMPORARY);
			TEMPORARY.transform.origin = Vector2.ZERO;
		if (HESITATE >= 57.0):
			$CHOICES.modulate.a = clamp($SOUL.modulate.a + delta,0.0,1.0);
			if (ALLOW_CHOICE == -1): ALLOW_CHOICE = 1;
		
		if (USER_CHOICE == 0):
			$SOUL.transform.origin = lerp($SOUL.transform.origin, Vector2(-20,-12), 10 * delta);
		else:
			$SOUL.transform.origin = lerp($SOUL.transform.origin, Vector2(-20,12), 10 * delta);
		
		if (ALLOW_CHOICE == 1):
			if (Input.is_action_just_pressed("moveUp")):
				USER_CHOICE = 0;
			if (Input.is_action_just_pressed("moveDown")):
				USER_CHOICE = 1;
			if (Input.is_action_just_pressed("confirm")):
				ALLOW_CHOICE = 2;
			
		if (ALLOW_CHOICE == 2):
			if (modulate.a == 1.0): $HIM_SHORT.playing = true;
			modulate.a = clamp(modulate.a - (delta/2), 0.0, 1.0);
			$HIM.volume_db = lerp($HIM.volume_db, -60, 30 * delta);
			if (modulate.a == 0.0):
				if (USER_CHOICE == 0):
					get_tree().change_scene("res://rooms/spamtonNeoFight/spamtonFight.tscn");
				if (USER_CHOICE == 1):
					get_tree().quit();
	if (jevil_fight_force):
		get_tree().change_scene("res://rooms/jevilFight/jevilFight.tscn");
