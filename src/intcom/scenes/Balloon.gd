tool
extends IC_Sequencer
class_name IC_Baloon

export(String, MULTILINE) var text = "" setget _set_text
export(float,0,1) var text_percent_visible = 1.0 setget _set_text_percent_visible
export(int) var padding_left = 0 setget _set_padding_left
export(int) var padding_right = 0 setget _set_padding_right
export(int) var padding_top = 0 setget _set_padding_top
export(int) var padding_bottom = 0 setget _set_padding_bottom
export var size: Vector2 = Vector2(200.0, 200.0) setget set_size
export var style:StyleBox = StyleBoxFlat.new() setget set_stylebox
export var font_size:int = 20 setget set_font_size
export var font_face:DynamicFontData = null setget set_font_face
export var font_color:Color = Color.black setget set_font_color
var _rect: Rect2
var _font_face: DynamicFont


onready var text_node := $body/margin/text
onready var margin_node := $body/margin
onready var body_node := $body

func _set_text(new_text:String):
	text = new_text
	if not text_node:
		yield(self,"ready")
	text_node.text = new_text

func _set_text_percent_visible(val:float):
	text_percent_visible = val
	if not text_node:
		yield(self,"ready")
	print(val)
	text_node.percent_visible = text_percent_visible


func _set_padding_left(val:int):
	padding_left = val
	if not margin_node:
		yield(self,"ready")
	margin_node.add_constant_override("margin_left", val)
	update()

func _set_padding_right(val:int):
	padding_right = val
	if not margin_node:
		yield(self,"ready")
	margin_node.add_constant_override("margin_right", val)
	update()

func _set_padding_top(val:int):
	padding_top = val
	if not margin_node:
		yield(self,"ready")
	margin_node.add_constant_override("margin_top", val)
	update()

func _set_padding_bottom(val:int):
	padding_bottom = val
	if not margin_node:
		yield(self,"ready")
	margin_node.add_constant_override("margin_bottom", val)
	update()

func set_stylebox(s:StyleBox):
	style = s
	if not body_node:
		yield(self,"ready")
	body_node.add_stylebox_override("panel", s)

func set_font_face(f:DynamicFontData):
	font_face = f
	_regenerate_font()
	pass

func set_font_size(s:int):
	font_size = s
	_regenerate_font()
	pass

func set_font_color(c:Color):
	font_color = c
	if not text_node:
		yield(self, "ready")
	text_node.add_color_override("font_color", c)

func _regenerate_font():
	var new_font = DynamicFont.new()
	new_font.size = font_size
	new_font.font_data = font_face
	_font_face = new_font
	if not text_node:
		yield(self,"ready")
	text_node.add_font_override("font", _font_face)

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

func set_size(value: Vector2) -> void:
	size = value
	_recalculate_rect()
	if not body_node:
		yield(self,"ready")
	body_node.rect_size = size
	body_node.set_anchors_preset(Control.PRESET_CENTER)
	body_node.rect_position = -body_node.rect_size/2 
	

func _recalculate_rect():
	_rect = Rect2(-1.0 * size / 2, size)


func has_point(point: Vector2) -> bool:
	var rect_global = Rect2(global_position + _rect.position, _rect.size)
	return rect_global.has_point(point)
