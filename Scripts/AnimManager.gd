extends Node2D
class_name AnimManager

@export var dayStartAnimPlayer : AnimationPlayer;
@export var newsAnimPlayer : AnimationPlayer;

func playDayStartAnim():
	dayStartAnimPlayer.play("DayStart");
	await get_tree().create_timer(3.5).timeout

func showNews(newsTitle : String, newsText : String):
	print("Show News")
	newsAnimPlayer.play("ShowNews");
	await get_tree().create_timer(1).timeout

func hideNews():
	print("Hide News")
	newsAnimPlayer.play("HideNews");
	await get_tree().create_timer(1).timeout
