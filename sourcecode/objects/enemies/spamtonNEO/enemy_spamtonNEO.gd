extends Node2D

var health:int = 4809;
var wireHealth:int = 100;
var aimPipis:bool = true;
var animateBody:bool = true;
var animateTorso:bool = true;
var animateWings:bool = true;
var animateArms:bool = true;
var animateLegs:bool = true;
var infTimer:float = 0.0;

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	$String1.points[0].x = sin(infTimer * 5) * 1.5;
	$String2.points[0].x = sin(infTimer * 3) * 1.5;
	$String3.points[0].x = sin(infTimer * 2) * 1.5;
	
	if (aimPipis):
		$armRJoint.rotation = lerp_angle($armRJoint.rotation,deg2rad(90),0.5);
		$armRJoint/armR.frame = 1;
	else:
		$armRJoint/armR.frame = 0;
	
	if (animateBody):
		$headJoint/head.playing = true;
		infTimer += delta;
		
		if (animateTorso):
			$torsoJoint/torso.offset.y = (sin(infTimer * 4) * 1.5);
		
		if (animateWings):
			$wingLJoint/wingL.offset.y = (sin(infTimer * 4) * 2);
			$wingRJoint/wingR.offset.y = (sin(infTimer * 6) * 2);
		
		if (animateArms):
			$armLJoint/armL.offset.y = abs(sin(infTimer * 2) * 2);
			$armRJoint/armR.offset.y = abs(sin(infTimer * 3) * 2);
			$armLJoint.rotation = (sin(infTimer * 3) * 0.3);
			if (!aimPipis):
				#$armRJoint.rotation = (sin(infTimer * 4) * 0.3);
				$armRJoint.rotation = lerp_angle($armRJoint.rotation,(sin(infTimer * 4) * 0.3),0.5);
		
		if (animateLegs):
			$legLJoint.rotation = (sin(infTimer * 3.2) * 0.3);
			$legRJoint.rotation = (sin(infTimer * 4.2) * 0.3);
	else:
		$headJoint/head.playing = false;
		$headJoint/head.frame = 2;

func ToggleAnimation():
	animateBody = !animateBody;
