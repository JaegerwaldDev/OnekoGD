# This is literally just a port of oneko.js
# Like, 1:1 but just in another language.

# There might be some weird code because I ported the
# solutions to weird JS stuff to Godot. If you find
# anything like that, just make a PRQ with a fix.

extends Node2D

var nekoPosX = 32
var nekoPosY = 32

var mousePosX = 0
var mousePosY = 0

var frameCount = 0
var idleTime = 0
var idleAnimation = null
var idleAnimationFrame = 0

var nekoSpeed = 10
var spriteSets = {
	"idle": [24],
	"alert": [31],
	"scratchSelf": [
		28,
		29,
		30
	],
	"scratchWallN": [
		16,
		17
	],
	"scratchWallS": [
		20,
		21
	],
	"scratchWallE": [
		18,
		19
	],
	"scratchWallW": [
		22,
		23
	],
	"tired": [25],
	"sleeping": [
		26,
		27
	],
	"N": [
		0,
		1
	],
	"NE": [
		2,
		3
	],
	"E": [
		4,
		5
	],
	"SE": [
		6,
		7
	],
	"S": [
		8,
		9
	],
	"SW": [
		10,
		11
	],
	"W": [
		12,
		13
	],
	"NW": [
		14,
		15
	]
}

var lastFrameTimestamp

func onAnimationFrame(timestamp):
	visible = true
	$Neko.visible = true
	if !lastFrameTimestamp:
		lastFrameTimestamp = timestamp
	if timestamp-lastFrameTimestamp > 100:
		lastFrameTimestamp = timestamp
		frame()

func setSprite(name, frame):
	var sprite = spriteSets[name][frame % len(spriteSets[name])]
	$Neko.frame = sprite

func resetIdleAnimation():
	idleAnimation = null;
	idleAnimationFrame = 0;

func idle():
	idleTime += 1

	var rng = RandomNumberGenerator.new()

	# every ~ 20 seconds
	if idleTime > 10 and floor(rng.randi_range(0, 200)) == 0 and idleAnimation == null:
		var avalibleIdleAnimations = ["sleeping", "scratchSelf"];
		if nekoPosX < 32:
			avalibleIdleAnimations.append("scratchWallW")
		if nekoPosY < 32:
			avalibleIdleAnimations.append("scratchWallN")
		if nekoPosX > DisplayServer.screen_get_size()[0] - 32:
			avalibleIdleAnimations.append("scratchWallE")
		if nekoPosY > DisplayServer.screen_get_size()[1] - 96:
			avalibleIdleAnimations.append("scratchWallS")
			
		idleAnimation = avalibleIdleAnimations[
			floor(rng.randi_range(0, len(avalibleIdleAnimations)-1))
		]

	match idleAnimation:
		"sleeping":
			if idleAnimationFrame < 8:
				setSprite("tired", 0)
				pass
			setSprite("sleeping", floor(idleAnimationFrame / 4))
			if idleAnimationFrame > 192:
				resetIdleAnimation()
			pass
		"scratchWallN", "scratchWallS", "scratchWallE", "scratchWallW", "scratchSelf":
			setSprite(idleAnimation, idleAnimationFrame)
			if idleAnimationFrame > 9:
				resetIdleAnimation()
			pass
		_:
			setSprite("idle", 0)
			pass
	idleAnimationFrame += 1;

func frame():
	frameCount += 1
	var diffX = nekoPosX - mousePosX
	var diffY = nekoPosY - mousePosY
	
	var distance = sqrt(diffX ** 2 + diffY ** 2)

	if distance < nekoSpeed or distance < 96:
		idle()
	else:
		idleAnimation = null;
		idleAnimationFrame = 0

		if idleTime > 1:
			setSprite("alert", 0)
			# count down after being alerted before moving
			idleTime = min(idleTime, 7)
			idleTime -= 1
		else:
			var direction
			direction = "N" if diffY / distance > 0.5 else ""
			direction += "S" if diffY / distance < -0.5 else ""
			direction += "W" if diffX / distance > 0.5 else ""
			direction += "E" if diffX / distance < -0.5 else ""
			setSprite(direction, frameCount);

			nekoPosX -= (diffX / distance) * nekoSpeed;
			nekoPosY -= (diffY / distance) * nekoSpeed;

			nekoPosX = min(max(16, nekoPosX), DisplayServer.screen_get_size()[0] - 16)
			nekoPosY = min(max(16, nekoPosY), DisplayServer.screen_get_size()[1] - 64)

			get_window().position = Vector2(nekoPosX, nekoPosY)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size = Vector2(32, 32)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mousePosX = get_window().position[0] + get_global_mouse_position()[0]
	mousePosY = min(max(0, get_window().position[1] + get_global_mouse_position()[1]), DisplayServer.screen_get_size()[1] - 64)
	onAnimationFrame(Time.get_ticks_msec())
