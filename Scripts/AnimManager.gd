extends Node2D
class_name AnimManager

@export var dayStartAnimPlayer : AnimationPlayer;

func playDayStartAnim():
	dayStartAnimPlayer.play();
