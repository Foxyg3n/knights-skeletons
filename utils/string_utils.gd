extends Node
class_name StringUtils

static func pascal_to_snake(text: String) -> String:
    var result := ""
    for i in range(text.length()):
        var character: String = text[i]
        if character == character.to_upper():
            if i > 0:
                result += "_"
            result += character.to_lower()
        else:
            result += character
    return result