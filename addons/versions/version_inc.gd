@tool
extends Control

const PRESETS_PATH = "res://export_presets.cfg"

var selected_phase: String = "-alpha"
var current_version_base: String = "0.1.0"

var btn_alpha: Button
var btn_beta: Button
var btn_rc: Button
var btn_release: Button
var lbl_preview: Label

func _enter_tree() -> void:
	btn_alpha = Button.new()
	btn_beta = Button.new()
	btn_rc = Button.new()
	btn_release = Button.new()
	lbl_preview = Label.new()

	var vbox = VBoxContainer.new()
	add_child(vbox)
	
	var hbox = HBoxContainer.new()
	vbox.add_child(hbox)
	
	_setup_button(btn_alpha, "Alpha (-alpha)", "-alpha", hbox)
	_setup_button(btn_beta, "Beta (-beta)", "-beta", hbox)
	_setup_button(btn_rc, "Release Candidate (-rc)", "-rc", hbox)
	_setup_button(btn_release, "Full Release", "", hbox)
	
	vbox.add_child(lbl_preview)
	_read_current_base_version()
	_update_ui()

func _setup_button(btn: Button, btn_text: String, phase: String, parent: Node) -> void:
	btn.text = btn_text
	btn.toggle_mode = true
	btn.pressed.connect(func(): _on_phase_selected(phase, btn))
	parent.add_child(btn)

func _on_phase_selected(phase: String, pressed_btn: Button) -> void:
	selected_phase = phase
	if btn_alpha and btn_beta and btn_rc and btn_release:
		for btn in [btn_alpha, btn_beta, btn_rc, btn_release]:
			if btn != pressed_btn:
				btn.button_pressed = false
	_update_ui()
	_save_metadata()

func _read_current_base_version() -> void:
	var config = ConfigFile.new()
	if config.load(PRESETS_PATH) == OK:
		var full_v = config.get_value("preset.0.options", "application/version", "0.1.0")
		current_version_base = full_v.split("-")[0]

func _update_ui() -> void:
	if lbl_preview:
		lbl_preview.text = "Target Version Preview: " + current_version_base + selected_phase

func _save_metadata() -> void:
	var f = FileAccess.open("user://version_build_settings.tmp", FileAccess.WRITE)
	if f:
		f.store_line(selected_phase)
