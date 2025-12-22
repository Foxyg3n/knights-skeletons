extends TextureButton
class_name ActionButton

func _ready() -> void:
    pressed.connect(_on_press)

# Override
func _on_press():
    pass