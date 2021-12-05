extends Node2D

var health:int = 4809;
var wireHealth:int = 100;
var aimPipis:bool = false;
var animateBody:bool = true;
var animateTorso:bool = true;
var animateWings:bool = true;
var animateArms:bool = true;
var animateLegs:bool = true;

var ringring:bool = false;
var ringringTimer:float = 0.0;
var ringringPickUpThePhone:bool = false;

var chainedHeart:bool = false;
var chainedHeartSpringTimer:float = 0.0;
var chainedHeartBounceDir:int = 0;
var chainedHeartYOffset:int = 0;

var infTimer:float = 0.0;

func _ready():
	pass # Replace with function body.

func _process(delta):
	$spriteJoint/String1.points[0].x = sin(infTimer * 5) * 1.5;
	$spriteJoint/String2.points[0].x = sin(infTimer * 3) * 1.5;
	$spriteJoint/String3.points[0].x = sin(infTimer * 2) * 1.5;
	
	if (ringring):
		ringringTimer += delta
		$ringring/phone.offset.y = -abs(sin(ringringTimer * 3.0) * 5.0);
		$ringring/phone.transform.origin.y = lerp($ringring/phone.transform.origin.y, -10, 8 * delta);
		$ringring/Line2D.points[1].y = $ringring/phone.transform.origin.y;
		
		if (round($ringring/phone.transform.origin.y) == -10.0):
			ringringPickUpThePhone = true;
		
		if (ringringPickUpThePhone && ringringTimer < 4.0):
			$ringring/phone.transform.origin.y = -26;
			$ringring/phone.visible = false;
			$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation, deg2rad(145), 20 * delta);
			$spriteJoint/headJoint/head.frame = 0;
			$spriteJoint/armRJoint/areyouserious.visible = true;
			$ringring/WHAT.visible = true;
			$ringring/ITSFORYOU.visible = false;
			$ringring/WHAT.offset.y = sin(ringringTimer*5.0) * 2.0;
		
		if (ringringPickUpThePhone && ringringTimer >= 4.0):
			$ringring/Line2D.points[0].x = lerp($ringring/Line2D.points[0].x,-22, 20 * delta);
			$ringring/Line2D.points[1].x = lerp($ringring/Line2D.points[1].x,-22, 20 * delta);
			$ringring/phone.transform.origin.y = -26;
			$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation, deg2rad(90), 20 * delta);
			$spriteJoint/headJoint/head.frame = 1;
			$spriteJoint/armRJoint/areyouserious.visible = false;
			$spriteJoint/armRJoint/ITSFORYOU.visible = true;
			
			$ringring/WHAT.visible = false;
			$ringring/ITSFORYOU.visible = true;
			$ringring/ITSFORYOU.offset = Vector2(rand_range(-2.0,2.0),rand_range(-2.0,2.0));
		
		if (ringringPickUpThePhone && ringringTimer >= 5.0):
			$spriteJoint.transform.origin.x = lerp($spriteJoint.transform.origin.x, 120, 4 * delta);
			$ringring/ITSFORYOU.visible = false;
			$ringring/phone.transform.origin.y = -70;
			
		
	else:
		ringringTimer = 0.0;
		ringringPickUpThePhone = false;
		$ringring/phone.transform.origin.y = -70;
		$ringring/Line2D.points[1].y = -70;
		$ringring/Line2D.points[0].x = -17;
		$ringring/Line2D.points[1].x = -17;
		$spriteJoint/armRJoint/areyouserious.visible = false;
		$spriteJoint/armRJoint/ITSFORYOU.visible = false;
		$ringring/phone.visible = true;
		$ringring/WHAT.visible = false;
		$ringring/ITSFORYOU.visible = false;
	
	if (aimPipis && !ringringPickUpThePhone):
		$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation,deg2rad(90), 20 * delta);
		$spriteJoint/armRJoint/armR.frame = 1;
	else:
		$spriteJoint/armRJoint/armR.frame = 0;
	
	if (!chainedHeart):
		$spriteJoint/chainedHeart.visible = false;
		$spriteJoint/chainedHeart/heart.transform.origin = Vector2.ZERO;
		$spriteJoint/chainedHeart/chain0.transform.origin = Vector2.ZERO;
		$spriteJoint/chainedHeart/chain1.transform.origin = Vector2.ZERO;
		$spriteJoint/chainedHeart/chain2.transform.origin = Vector2.ZERO;
		chainedHeartSpringTimer = 0.0;
		chainedHeartBounceDir = 0;
		chainedHeartYOffset = 0;
		if (!ringring): $spriteJoint.transform.origin.x += (-$spriteJoint.transform.origin.x) * (6 * delta);
		
		if (animateBody):
			$spriteJoint/headJoint/head.playing = true;
			infTimer += delta;
			
			if (animateTorso):
				$spriteJoint/torsoJoint/torso.offset.y = (sin(infTimer * 4) * 1.5);
			
			if (animateWings):
				$spriteJoint/wingLJoint/wingL.offset.y = (sin(infTimer * 4) * 2);
				$spriteJoint/wingRJoint/wingR.offset.y = (sin(infTimer * 6) * 2);
			
			if (animateArms):
				$spriteJoint/armLJoint/armL.offset.y = abs(sin(infTimer * 2) * 2);
				$spriteJoint/armRJoint/armR.offset.y = abs(sin(infTimer * 3) * 2);
				$spriteJoint/armLJoint.rotation = (sin(infTimer * 3) * 0.3);
				if (!aimPipis && !ringringPickUpThePhone):
					#$spriteJoint/armRJoint.rotation = (sin(infTimer * 4) * 0.3);
					$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation,(sin(infTimer * 4) * 0.3), 20 * delta);
			
			if (animateLegs):
				$spriteJoint/legLJoint.rotation = (sin(infTimer * 3.2) * 0.3);
				$spriteJoint/legRJoint.rotation = (sin(infTimer * 4.2) * 0.3);
		else:
			$spriteJoint/headJoint/head.playing = false;
			$spriteJoint/headJoint/head.frame = 2;
	else:
		$spriteJoint/chainedHeart.visible = true;
		$spriteJoint/headJoint/head.playing = false;
		chainedHeartSpringTimer += delta;
		
		if (chainedHeartBounceDir == 0):
			if (chainedHeartSpringTimer >= 0.75):
				chainedHeartSpringTimer = 0.0;
				chainedHeartBounceDir = 1;
		if (chainedHeartBounceDir == 1):
			if (chainedHeartSpringTimer >= 1.1):
				chainedHeartSpringTimer = 0.0;
				chainedHeartBounceDir = 0;
				chainedHeartYOffset = rand_range(-30,30);
		
		if (chainedHeartBounceDir == 0):
			$spriteJoint/headJoint/head.frame = 0;
			$spriteJoint/armLJoint.rotation = lerp_angle($spriteJoint/armLJoint.rotation, deg2rad(60), 20 * delta);
			$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation, deg2rad(60), 20 * delta);
			$spriteJoint/legLJoint.rotation = lerp_angle($spriteJoint/legLJoint.rotation, deg2rad(60), 20 * delta);
			$spriteJoint/legRJoint.rotation = lerp_angle($spriteJoint/legRJoint.rotation, deg2rad(60), 20 * delta);
			$spriteJoint.transform.origin.x += (60 - $spriteJoint.transform.origin.x) * (6 * delta);
			
			$spriteJoint/chainedHeart/heart.transform.origin = lerp($spriteJoint/chainedHeart/heart.transform.origin, Vector2(0,0), 6 * delta);
			$spriteJoint/chainedHeart/chain0.transform.origin = lerp($spriteJoint/chainedHeart/chain0.transform.origin, Vector2(0,0), 6 * delta);
			$spriteJoint/chainedHeart/chain1.transform.origin = lerp($spriteJoint/chainedHeart/chain1.transform.origin, Vector2(0,0), 6 * delta);
			$spriteJoint/chainedHeart/chain2.transform.origin = lerp($spriteJoint/chainedHeart/chain2.transform.origin, Vector2(0,0), 6 * delta);
			$spriteJoint/chainedHeart/chain3.transform.origin = lerp($spriteJoint/chainedHeart/chain3.transform.origin, Vector2(0,0), 6 * delta);
		
		if (chainedHeartBounceDir == 1):
			$spriteJoint/headJoint/head.frame = 2;
			$spriteJoint/armLJoint.rotation = lerp_angle($spriteJoint/armLJoint.rotation, deg2rad(-60), 20 * delta);
			$spriteJoint/armRJoint.rotation = lerp_angle($spriteJoint/armRJoint.rotation, deg2rad(-60), 20 * delta);
			$spriteJoint/legLJoint.rotation = lerp_angle($spriteJoint/legLJoint.rotation, deg2rad(-60), 20 * delta);
			$spriteJoint/legRJoint.rotation = lerp_angle($spriteJoint/legRJoint.rotation, deg2rad(-60), 20 * delta);
			$spriteJoint.transform.origin.x += (0 - $spriteJoint.transform.origin.x) * (6 * delta);
			
			$spriteJoint/chainedHeart/heart.transform.origin = lerp($spriteJoint/chainedHeart/heart.transform.origin, Vector2(-50,chainedHeartYOffset), 6 * delta);
			$spriteJoint/chainedHeart/chain0.transform.origin = lerp($spriteJoint/chainedHeart/chain0.transform.origin, Vector2(-50,chainedHeartYOffset) * 0.75, 6 * delta);
			$spriteJoint/chainedHeart/chain1.transform.origin = lerp($spriteJoint/chainedHeart/chain1.transform.origin, Vector2(-50,chainedHeartYOffset) * 0.5, 6 * delta);
			$spriteJoint/chainedHeart/chain2.transform.origin = lerp($spriteJoint/chainedHeart/chain2.transform.origin, Vector2(-50,chainedHeartYOffset) * 0.25, 6 * delta);
			$spriteJoint/chainedHeart/chain3.transform.origin = lerp($spriteJoint/chainedHeart/chain3.transform.origin, Vector2(0,0), 6 * delta);

func ToggleAnimation():
	animateBody = !animateBody;
