tool
extends IC_Sequencer

export(String, MULTILINE) var text = "" setget _set_text
export(float,0,1) var text_percent_visible = 1 setget _set_text_percent_visible
export(int) var padding_left = 0 setget _set_padding_left
export(int) var padding_right = 0 setget _set_padding_right
export(int) var padding_top = 0 setget _set_padding_top
export(int) var padding_bottom = 0 setget _set_padding_bottom

onready var text_node := $body/margin/text
onready var margin_node := $body/margin

func _set_text(new_text:String):
	text = new_text
	if text_node:
		text_node.text = new_text

func _set_text_percent_visible(val:float):
	text_percent_visible = val
	if text_node:
		text_node.percent_visible = text_percent_visible


func _set_padding_left(val:int):
	padding_left = val
	if margin_node:
		margin_node.add_constant_override("margin_left", val)
		update()
		
func _set_padding_right(val:int):
	padding_right = val
	if margin_node:
		margin_node.add_constant_override("margin_right", val)
		update()

func _set_padding_top(val:int):
	padding_top = val
	if margin_node:
		margin_node.add_constant_override("margin_top", val)
		update()

func _set_padding_bottom(val:int):
	padding_bottom = val
	if margin_node:
		margin_node.add_constant_override("margin_bottom", val)
		update()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _get_property_list():
	var properties = []
	properties.append({
		name = "Text Padding",
		type = TYPE_NIL,
		hint_string = "padding_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE 
	})
	return properties
	
#func _draw():
#	if not get_node_or_null("body"):
#		return
#	var padding = Rect2(padding_left,padding_top, $body/margin.rect_size.x - padding_right, $body/margin.rect_size.y - padding_bottom  )
#	padding.position -= 0.5 * $body/margin.rect_size
#	draw_rect(padding, Color.red, false,2)
#	pass
