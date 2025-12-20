extends Node
class_name ArrayUtils

static func difference(array1: Array[Variant], array2: Array[Variant]) -> Array[Variant]:
    var difference_array := []
    for element in array1:
        if not element in array2:
            difference_array.append(element)
    return difference_array

static func trait_matches(array: Array, get_trait: Callable) -> bool:
    if array.is_empty(): return false

    var member_trait = get_trait.call(array.front())
    return array.all(func(member): return get_trait.call(member) == member_trait)
