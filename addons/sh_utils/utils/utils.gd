extends Node


## Smoothly interpolates a value towards a target using exponential decay.
## Useful for frame-rate independent smoothing.
## [param a]: The current value.
## [param b]: The target value.
## [param decay]: The decay rate (higher is faster).
## [param delta]: Time elapsed since last frame.
func exp_decay(a: Variant, b: Variant, decay: float, delta: float) -> Variant:
	return b + (a - b) * exp(-decay * delta)


## Smoothly moves a value towards a target using a fixed exponential curve.
## Effectively the same as [method exp_decay] with a decay of 1.0.
## [param a]: The current value.
## [param b]: The target value.
## [param delta]: Time elapsed since last frame.
func move_towards_smooth(a: Variant, b: Variant, delta: float) -> Variant:
	return lerp(a, b, - (exp(-delta) - 1))


## Converts an array into a string representation, with each element on a new line.
## [param array]: The array to convert.
func array_to_string(array: Array) -> String:
	var string: String
	for member: Variant in array:
		string += "%s\n" % member
	return string


## Converts a dictionary into a string representation, with each element on a new line.
## [param dictionary]: The dictionary to convert.
func dictionary_to_string(dictionary: Dictionary) -> String:
	var string: String
	for member: String in dictionary:
		string += "%s: %s\n" % [member, dictionary[member]]
	return string


## Converts a boolean value to a custom string.
## [param boolean]: The boolean value to check.
## [param true_string]: The string to return if [param boolean] is true.
## [param false_string]: The string to return if [param boolean] is false.
func bool_to_string(boolean: bool, true_string: String = "True", false_string: String = "False") -> String:
	return true_string if boolean else false_string


func vector2i_to_string(vec: Vector2i, separator: String = "x") -> String:
	return "%d%s%d" % [vec.x, separator, vec.y]