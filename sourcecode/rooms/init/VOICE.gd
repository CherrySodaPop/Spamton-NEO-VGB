extends Node2D

var SPEAK:bool = false;
var SPEAKHESITATE:float = 0.0;
export (String, MULTILINE) var WORDS:String = "TEST";
export (float) var SPEED:float = 1.0;

func _ready():
	$TALK0.visible_characters = 1;
	$TALK0.percent_visible = 0.0;
	$TEXTGLOW/TALK1.visible_characters = 0;
	$TEXTGLOW/TALK2.visible_characters = 0;
	$TEXTGLOW/TALK3.visible_characters = 0;
	$TEXTGLOW/TALK4.visible_characters = 0;
	$TALK0.bbcode_text = WORDS;
	$TEXTGLOW/TALK1.bbcode_text = WORDS;
	$TEXTGLOW/TALK2.bbcode_text = WORDS;
	$TEXTGLOW/TALK3.bbcode_text = WORDS;
	$TEXTGLOW/TALK4.bbcode_text = WORDS;

func _process(delta):
	if(SPEAK):
		SPEAKHESITATE += delta * SPEED;
		if (SPEAKHESITATE > 0.25 && $TALK0.percent_visible < 1.0):
			$TALK0.visible_characters += 1;
			$TEXTGLOW/TALK1.visible_characters += 1;
			$TEXTGLOW/TALK2.visible_characters += 1;
			$TEXTGLOW/TALK3.visible_characters += 1;
			$TEXTGLOW/TALK4.visible_characters += 1;
			SPEAKHESITATE = 0.0;
		if (SPEAKHESITATE >= 3.0 && $TALK0.percent_visible >= 1.0):
			modulate.a = clamp(modulate.a - delta,0.0,1.0);
