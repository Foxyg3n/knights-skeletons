extends CanvasLayer

@export var container: Control
@export var font_size: int

func _ready() -> void:
    if not container:
        container = $Container

var labels: Dictionary = Dictionary()

func get_or_add_label(label_name: String) -> Label:
    if is_label(label_name):
        return get_label(label_name)
    else:
        return add_label(label_name)

func add_label(label_name: String) -> Label:
    var new_label: Label = Label.new()
    new_label.position.y = labels.size() * (font_size + 1)
    new_label.add_theme_font_size_override("font_size", font_size)
    labels[label_name] = new_label
    container.add_child(new_label)
    return new_label

func is_label(label_name: String) -> bool:
    return labels.has(label_name)

func get_label(label_name: String) -> Label:
    return labels[label_name]
