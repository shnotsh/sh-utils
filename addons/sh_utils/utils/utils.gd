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


func capture_screenshot() -> void:
	var screenshots_dir: String = "user://screenshots"
	var real_dir: String = ProjectSettings.globalize_path(screenshots_dir)
	if not DirAccess.dir_exists_absolute(screenshots_dir):
		DirAccess.open("user://").make_dir("screenshots")

	var timestamp: String = Time.get_datetime_string_from_system(false, true)
	timestamp = timestamp.replace(":", "-").replace(" ", "_")
	var filename: String = "Screenshot_%s.png" % timestamp
	var filepath: String = screenshots_dir.path_join(filename)

	var image: Image = get_viewport().get_texture().get_image()
	var error: Error = image.save_png(filepath)

	if error == OK:
		print("%s saved: %s" % [filename, real_dir])
	else:
		print("Failed to save screenshot: %s" % real_dir)
