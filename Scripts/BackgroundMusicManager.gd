extends Node
class_name BackgroundMusicManager

@export var lightBackgroundMusicPlayer : AudioStreamPlayer2D;
@export var darkBackgroundMusicPlayer : AudioStreamPlayer2D;
var musicVol = 1;
const MIN_TIME_BETWEEN_TALK_SFX : float = 0.5
var isWaitingToTalk : bool = false;

## If we are currently fading out the music
var fadeOut = false;
var darkTargetFadeOutVol = OFF_VOLUME;
var lightTargetFadeOutVol = OFF_VOLUME;
const FADE_SPEED = 500
const OFF_VOLUME = -100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lightBackgroundMusicPlayer.play();
	lightBackgroundMusicPlayer.volume_db = OFF_VOLUME;
	darkBackgroundMusicPlayer.play();
	darkBackgroundMusicPlayer.volume_db = OFF_VOLUME;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fadeOutMusicUpdate(delta)

func startMusic(isDark : bool):
	fadeOut = false
	if (isDark):
		setTargetVolFade(true, 0) # sets dark to play
		setTargetVolFade(false, OFF_VOLUME) # sets light to off
	else:
		setTargetVolFade(false, 0) # sets light to play
		setTargetVolFade(true, OFF_VOLUME) # sets dark to off

func setTargetVolFade(isDark : bool, toVolume : float = OFF_VOLUME):
	if (isDark):
		darkTargetFadeOutVol = toVolume
	else:
		lightTargetFadeOutVol = toVolume

func fadeOutMusicUpdateFor(delta : float, musicPlayer : AudioStreamPlayer2D, target):
	if (musicPlayer.volume_db > target):
		musicPlayer.volume_db -= FADE_SPEED * delta;
		if (musicPlayer.volume_db <= target):
			musicPlayer.volume_db = target
	elif (musicPlayer.volume_db < target):
		musicPlayer.volume_db += FADE_SPEED * delta;
		if (musicPlayer.volume_db >= target):
			musicPlayer.volume_db = target

func fadeOutMusicUpdate(delta : float):
	fadeOutMusicUpdateFor(delta, darkBackgroundMusicPlayer, darkTargetFadeOutVol)
	fadeOutMusicUpdateFor(delta, lightBackgroundMusicPlayer, lightTargetFadeOutVol)

func playMoneySFX(isPositive : bool) -> void:
	if (isPositive):
		TypeDefs.playSFX(TypeDefs.moneyUpSFX, self)
	else:
		TypeDefs.playSFX(TypeDefs.moneyDownSFX, self)

func playTalkSound(charID : String):
	var sfx : AudioStream;
	var useWaitTime : bool;
	if (charID == "CheeseMan"):
		sfx = TypeDefs.getRandCheeseManSFX()
		useWaitTime = true;
	else:
		# No Char Matched, so play nothing
		return;
	if (useWaitTime):
		if (not isWaitingToTalk):
			TypeDefs.playSFX(sfx, self)
			isWaitingToTalk = true
			await get_tree().create_timer(MIN_TIME_BETWEEN_TALK_SFX).timeout
			isWaitingToTalk = false
	else:
		TypeDefs.playSFX(sfx, self)
