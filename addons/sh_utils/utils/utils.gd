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


## Converts an array into a string representation.
## [param array]: The array to convert.
## [param members_separator]: Specified separator to include between members, "\n" by default.
func str_from_array(array: Array, members_separator: String = "\n") -> String:
	var string: String
	for member: Variant in array:
		string += "%s%s" % [member, members_separator]
	return string


## Converts a dictionary into a string representation.
## [param dict]: The dictionary to convert.
## [param members_separator]: Specified separator to include between members, "\n" by default.
func str_from_dict(dict: Dictionary, members_separator: String = "\n") -> String:
	var string: String
	for member: String in dict:
		string += "%s: %s%s" % [member, dict[member], members_separator]
	return string


## Converts a boolean value to a custom string.
## [param boolean]: The boolean value to check.
## [param true_string]: The string to return if [param boolean] is true.
## [param false_string]: The string to return if [param boolean] is false.
func str_from_bool(boolean: bool, true_string: String = "True", false_string: String = "False") -> String:
	return true_string if boolean else false_string


## Converts a vector (Vector2, Vector3, Vector4 or integer variants) to a string representation.
## [param vec]: The vector to convert.
## [param separator]: The separator string to use between components.
func str_from_vec(vec: Variant, separator: String = "x") -> String:
	match typeof(vec):
		TYPE_VECTOR2:
			return "%f%s%f" % [vec.x, separator, vec.y]
		TYPE_VECTOR2I:
			return "%d%s%d" % [vec.x, separator, vec.y]
		TYPE_VECTOR3:
			return "%f%s%f%s%f" % [vec.x, separator, vec.y, separator, vec.z]
		TYPE_VECTOR3I:
			return "%d%s%d%s%d" % [vec.x, separator, vec.y, separator, vec.z]
		TYPE_VECTOR4:
			return "%f%s%f%s%f%s%f" % [vec.x, separator, vec.y, separator, vec.z, separator, vec.w]
		TYPE_VECTOR4I:
			return "%d%s%d%s%d%s%d" % [vec.x, separator, vec.y, separator, vec.z, separator, vec.w]
	return ""