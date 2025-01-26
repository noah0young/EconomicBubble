extends Button

const MIN_TIME_BETWEEN_SFX = 0.1
var canPlaySFX = true;

func _on_button_down() -> void:
	if (canPlaySFX):
		TypeDefs.playSFX(TypeDefs.getRandClickDownSFX(), self)
		waitBeforeNextSFX();

func _on_button_up() -> void:
	if (canPlaySFX):
		TypeDefs.playSFX(TypeDefs.getRandClickUpSFX(), self)
		waitBeforeNextSFX();

func _on_pressed() -> void:
	if (canPlaySFX):
		TypeDefs.playSFX(TypeDefs.getRandClickUpSFX(), self)
		waitBeforeNextSFX();

func waitBeforeNextSFX():
	canPlaySFX = false
	await get_tree().create_timer(MIN_TIME_BETWEEN_SFX).timeout
	canPlaySFX = true
