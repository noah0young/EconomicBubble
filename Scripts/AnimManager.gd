extends Node2D
class_name AnimManager

@export var uiAnimPlayer : AnimationPlayer;
@export var winLoseAnimPlayer : AnimationPlayer;
@export var dayStartAnimPlayer : AnimationPlayer;
@export var newsAnimPlayer : AnimationPlayer;

@export var dayTextLabel : RichTextLabel;
@export var newsTextLabel : RichTextLabel;

func playDayStartAnim(dayNum : int):
	dayTextLabel.set_text("[font_size={200}][center]Day " + str(dayNum))
	dayStartAnimPlayer.play("DayStart");
	await get_tree().create_timer(3.5).timeout

func showNews(newsTitle : String, newsText : String):
	newsTextLabel.set_text("[font_size={100}][center]" + newsText);
	newsAnimPlayer.play("ShowNews");
	await get_tree().create_timer(1).timeout

func contShowNews(newsTitle : String, newsText : String):
	newsTextLabel.set_text("[font_size={100}][center]" + newsText);
	newsAnimPlayer.play("Continue Show News");
	await get_tree().create_timer(1).timeout

func contHideNews():
	newsAnimPlayer.play("Continue Hide News");
	await get_tree().create_timer(1).timeout

func hideNews():
	newsAnimPlayer.play("HideNews");
	await get_tree().create_timer(1).timeout

func playWinAnim():
	winLoseAnimPlayer.play("Win")

func playLoseAnim():
	winLoseAnimPlayer.play("Lose")

func playShowUIPrompt():
	uiAnimPlayer.play("SlideTextBoxIn")
	await get_tree().create_timer(1).timeout

func playShowUIReplies():
	uiAnimPlayer.play("SlideRepliesIn")
	await get_tree().create_timer(1).timeout
	
func playHideUIPrompt():
	uiAnimPlayer.play("SlideTextBoxOut")
	await get_tree().create_timer(1).timeout
