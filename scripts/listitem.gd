extends Control

@onready var label = $Label

signal entered

func setup(txt):
	label.text = txt

func _on_focus_entered():
	entered.emit()

func highlight(on : bool):
	$ColorRect.visible = on
