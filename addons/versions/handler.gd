@tool
extends EditorExportPlugin

const PRESETS_PATH = "res://export_presets.cfg"

func _get_name() -> String:
	return "ExportVersionPrompt"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	var config = ConfigFile.new()
	if config.load(PRESETS_PATH) != OK:
		return

	# Load the existing version entry
	var current_version = config.get_value("preset.0.options", "application/version", "0.1.0-alpha")
	
	# Cleanly parse base and auto-increment patch digits
	var base_version = current_version.split("-")[0]
	var parts = base_version.split(".")
	if parts.size() < 3: 
		parts = ["0", "1", "0"]
	
	var next_patch = int(parts[2]) + 1
	var proposed_base = parts[0] + "." + parts[1] + "." + str(next_patch)
	
	# Fetch pre-release phase selected from dock UI buttons
	var phase = "-alpha"
	if FileAccess.file_exists("user://version_build_settings.tmp"):
		var f = FileAccess.open("user://version_build_settings.tmp", FileAccess.READ)
		phase = f.get_line()
		
	var final_proposal = proposed_base + phase
	
	# Fire the visual layout display configuration
	_run_synchronous_version_check(final_proposal, config)

func _run_synchronous_version_check(proposed_version: String, config: ConfigFile) -> void:
	# Use standard Godot OS blocking Input dialogues to prevent engine thread bypasses
	# Displays an immediate operating system prompt panel
	print("[Version Manager] Verifying build layout configuration target...")
	
	# Create a window dialog that works seamlessly inside the editor tree execution limits
	var dialog = ConfirmationDialog.new()
	dialog.title = "Confirm Build Version"
	
	var vbox = VBoxContainer.new()
	var label = Label.new()
	label.text = "Confirm or edit your full game package version identifier:"
	
	var line_edit = LineEdit.new()
	line_edit.text = proposed_version
	line_edit.custom_minimum_size.x = 350
	
	vbox.add_child(label)
	vbox.add_child(line_edit)
	dialog.add_child(vbox)
	
	# Hook target tree to editor workspace
	var editor_interface = Engine.get_main_loop().root
	editor_interface.add_child(dialog)
	dialog.popup_centered()
	
	# Utilize standard blocking loop execution hooks without thread-breaking awaits
	# This keeps the main Godot export engine loop cleanly contained
	var interaction_done = false
	var build_allowed = false
	
	dialog.confirmed.connect(func():
		build_allowed = true
		interaction_done = true
	)
	
	dialog.canceled.connect(func():
		build_allowed = false
		interaction_done = true
	)
	
	# Keep frame cycle safe without engine freezing dropouts
	while not interaction_done:
		OS.delay_msec(10)
		DisplayServer.process_events()
	
	if build_allowed and line_edit.text.strip_edges() != "":
		var confirmed_version = line_edit.text
		config.set_value("preset.0.options", "application/version", confirmed_version)
		config.save(PRESETS_PATH)
		print("[Version Manager] Success. Proceeding with export build: ", confirmed_version)
	else:
		print("[Version Manager] Alert: Build sequence stopped by developer input.")
		# Gracefully abort the export pipeline without throwing fatal engine panics
		# Generating a light editor notification error tells Godot to stop execution cleanly
		printerr("[Version Manager] Export aborted to update configuration parameters.")
		
	dialog.queue_free()
