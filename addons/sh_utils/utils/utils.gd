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
	var str: String
	for member: Variant in array:
		str += "%s\n" % member
	return str


## Converts a dictionary into a string representation, with each element on a new line.
## [param dictionary]: The dictionary to convert.
func dictionary_to_string(dictionary: Array) -> String:
	var str: String
	for member: String in dictionary:
		str += "%s: %s\n" % [member, dictionary[member]]
	return str