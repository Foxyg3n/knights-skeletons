class_name SpaceUtils

static func screen_to_world_point(point: Vector2, camera2d: Camera2D) -> Vector2:
    return point * camera2d.get_canvas_transform()

static func screen_to_world_rect(rect: Rect2, camera2d: Camera2D) -> Rect2:
    var canvas_to_world: Transform2D = camera2d.get_canvas_transform()

    var top_left: Vector2 = canvas_to_world * rect.position
    var bottom_right: Vector2 = canvas_to_world * (rect.position + rect.size)

    return Rect2(top_left, bottom_right - top_left)
