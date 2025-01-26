extends Button

@export var image : TextureRect;
var imageOrigPos : Vector2;

const MIN_TIME_BETWEEN_SFX = 0.1
var canPlaySFX = true;

func _ready() -> void:
	if (image):
		imageOrigPos = image.position

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

func raiseImage():
	if (image):
		image.set_position(image.position + Vector2(0, -50))

func lowerImage():
	if (image):
		image.set_position(imageOrigPos)


func _on_mouse_entered() -> void:
	raiseImage()


func _on_mouse_exited() -> void:
	lowerImage()
