tool
extends CanvasLayer

export(Texture) var texture_prev setget set_texture_prev, get_texture_prev
export(Texture) var texture_next setget set_texture_next, get_texture_next
export(int,0,100) var margin  = 5 setget set_margin, get_margin
onready var margin_container = $margin
onready var prev_button = $margin/base/prev
onready var next_button = $margin/base/next

var initialized = false

func _ready():
	initialized = true


func set_texture_prev(tex):
	texture_prev = tex
	if initialized:
		prev_button.texture_normal = tex
	
func get_texture_prev():
	return texture_prev
	
func set_texture_next(tex):
	texture_next = tex
	if initialized:
		next_button.texture_normal = tex

func get_texture_next():
	return texture_next

func set_margin(value:int):
	margin = value
	if initialized:
		margin_container.set("custom_constants/margin_right", margin)
		margin_container.set("custom_constants/margin_left", margin)
	
func get_margin():
	return margin

func register_input(target):
	owner.register_input(target)
