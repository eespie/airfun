@tool
extends Node

var callbacks := {}

const PERSIST = 0 
const DEFERRED = 1 
const ONE_SHOT = 2

## Register a listener for an event
## The callback will be either _on_<event> or <event> function
##
## flags : a combination of
## Events.PERSIST
## Default
##
## Events.DEFERRED
## Deferred connections trigger their Callables on idle time, rather than instantly.
##
## Events.ONE_SHOT
## One-shot connections disconnect themselves after emission.
##
func register(event: String, node: Node, flags: int = Events.PERSIST) -> void:
	var list := {}
	if callbacks.has(event):
		list = callbacks[event]
	
	list[node] = flags
	callbacks[event] = list

func unregister(event: String, node: Node) -> void:
	if (callbacks.has(event)):
		var list := callbacks[event] as Dictionary
		list.erase(node)

func unregister_node(node: Node):
	for event in callbacks:
		if callbacks[event].has(node):
			callbacks[event].erase(node)

func trigger(event:String, data1=null, data2=null, data3=null):
	print(str("Trigger: ", event, " Data: ", data1, ", ", data2, ", ", data3))
	if callbacks.has(event):
		for node in callbacks[event]:
			var flags := callbacks[event][node] as int
			var method := event
			if node.has_method(str("_on_", method)):
				method = str("_on_", method)
			if node.has_method(method):
				if data3 != null:
					if flags & Events.DEFERRED:
						node.call_deferred(method, data1, data2, data3)
					else:
						node.call(method, data1, data2, data3)
				elif data2 != null:
					if flags & Events.DEFERRED:
						node.call_deferred(method, data1, data2)
					else:
						node.call(method, data1, data2)
				elif data1 != null:
					if flags & Events.DEFERRED:
						node.call_deferred(method, data1)
					else:
						node.call(method, data1)
				else:
					if flags & Events.DEFERRED:
						node.call_deferred(method)
					else:
						node.call(method)
				if flags & Events.ONE_SHOT:
					unregister(event, node)
