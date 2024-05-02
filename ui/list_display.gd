extends VBoxContainer

var get_items: Callable
var render_item: Callable

func _process(_delta):
	var items = get_items.call()
	if items.size() != get_child_count():
		_clear_children()
		
		for item in items:
			var list_item = render_item.call(item)
			add_child(list_item)

func _clear_children():
	for child in get_children():
		remove_child(child)

func render_label(prop_name: String):
	render_item = func(x):
		var item = Label.new()
		item.text = x[prop_name]
		return item
