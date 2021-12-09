extends Node2D

var HESITATE:float = 0.0;
var DEFEAT:bool = false;
var ALLOW_CHOICE:int = -1;
var USER_CHOICE:int = 0;
var HESITATEFINAL:float = 0.0;
var USER_SOUL_SHATTERED:bool = false;
var USER_SOUL_POS:Vector2 = Vector2.ZERO;

var PIECES = preload("res://rooms/anEnd/USER_SOUL_PIECE.tscn");

func _ready():
	$USER_SOUL.transform.origin = Persistant.get_node("controller").USER_SOUL_POS;

func _process(delta):
	HESITATE += delta;
	
	if (HESITATE >= 1.0 && !USER_SOUL_SHATTERED):
		$SHATTER.playing = true;
		$USER_SOUL.visible = false;
		var tmpObj = PIECES.instance();
		add_child(tmpObj);
		tmpObj.transform.origin = $USER_SOUL.transform.origin;
		tmpObj = PIECES.instance();
		add_child(tmpObj);
		tmpObj.transform.origin = $USER_SOUL.transform.origin;
		tmpObj = PIECES.instance();
		add_child(tmpObj);
		tmpObj.transform.origin = $USER_SOUL.transform.origin;
		tmpObj = PIECES.instance();
		add_child(tmpObj);
		tmpObj.transform.origin = $USER_SOUL.transform.origin;
		USER_SOUL_SHATTERED = true;
	
	if (HESITATE >= 3.0 && !DEFEAT):
		$DEFEAT.playing = true;
		DEFEAT = true;
	
	if (HESITATE >= 3.0): $DIALOGUE0.SPEAK = true;
	if (HESITATE >= 11.0): $DIALOGUE1.SPEAK = true;
	
	if (HESITATE >= 17.0 && ALLOW_CHOICE != 2):
		$CHOICES.modulate.a = clamp($CHOICES.modulate.a + delta,0.0,1.0);
		if (ALLOW_CHOICE == -1): ALLOW_CHOICE = 1;
	
	if (ALLOW_CHOICE == 1):
		if (Input.is_action_just_pressed("moveLeft")):
			USER_CHOICE = 0;
		if (Input.is_action_just_pressed("moveRight")):
			USER_CHOICE = 1;
		if (Input.is_action_just_pressed("confirm")):
			ALLOW_CHOICE = 2;
	
	if (USER_CHOICE == 0):
		$CHOICES/SOUL.transform.origin.x = lerp($CHOICES/SOUL.transform.origin.x, -32, 10 * delta);
	else:
		$CHOICES/SOUL.transform.origin.x = lerp($CHOICES/SOUL.transform.origin.x, 36, 10 * delta);
	
	if (ALLOW_CHOICE == 2):
		$DEFEAT.playing = false;
		$CHOICES.visible = false;
		HESITATEFINAL += delta;
		
		if (USER_CHOICE == 0):
			$DIALOGUE2.SPEAK = true;
		else:
			$DIALOGUE3.SPEAK = true;
		
		if (9.0 >= HESITATEFINAL && HESITATEFINAL >= 8.0):
			if (USER_CHOICE == 0):
				get_tree().change_scene("res://rooms/spamtonNeoFight/spamtonFight.tscn");
			else:
				if (!$DARKER.playing): $DARKER.playing = true;
		if (HESITATEFINAL >= 9.0 && !$DARKER.playing):
			get_tree().quit();
