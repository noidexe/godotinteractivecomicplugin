extends CanvasLayer

"""
This can be added to any scene and be use to show some properties for debug purposes
"""

export(bool) var enabled = true setget _set_enabled, _get_enabled
export(NodePath) var path_to_node = null
export(Array, String) var properties = []
export(Array, String) var signals = []
var signal_message_queue = []

var node :Node = Node.new()
var node_script :Script

onready var stats_text = $Control/HBoxContainer/stats
onready var signals_text = $Control/HBoxContainer/signals

# Called when the node enters the scene tree for the first time.
func _ready():
	if path_to_node is NodePath:
		node = get_node(path_to_node)
		node_script = node.get_script()
	if enabled:
		_set_enabled(true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var output = ""
	for property in properties:
		if not property in node:
			printerr("Property %s not found in %s" % [property, node])
			properties.erase(property)
			continue
		output += property + ": " + str(node[property]) + "\n"
	stats_text.text = output
	pass

func _set_enabled(value):
	enabled = value
	if value == true:
		$Control.show()
		_connect_signals()
		set_process(true)
	else:
		$Control.hide()
		_disconnect_signals()
		set_process(false)
	
func _get_enabled():
	return enabled

func _connect_signals():

	for sig in signals:
		if not (node.has_signal(sig) or node.has_user_signal(sig) or node_script.has_script_signal(sig)):
			printerr("Signal %s not found in %s" % [sig, node])
			continue
# warning-ignore:return_value_discarded
		node.connect(sig, self, "_on_signal_emitted", [sig])
	pass
	
func _disconnect_signals():
	for sig in signals:
		if not (node.has_signal(sig) or node.has_user_signal(sig) or (node_script and node_script.has_script_signal(sig)) ):
			continue
		node.disconnect(sig, self, "_on_signal_emitted")
	pass

func _on_signal_emitted(a=null,b=null,c=null,d=null,e=null,f=null):
	var signame = ""
	for arg in [f,e,d,c,b,a]:
		if typeof(arg) == TYPE_STRING:
			signame = arg
			continue
	if signal_message_queue.size() == 5:
		signal_message_queue.pop_front()
	signal_message_queue.append(signame)
	var output = ""
	for s in signal_message_queue:
		output += s + "\n"
	output.rstrip("\n")
	signals_text.text = output
	pass
