extends Node2D

onready var piece_scene = load("res://Piece.tscn")
var selected_piece: Piece = null

var click_handled: bool = false
var pieces = []

func _ready() -> void:
	var pos_x = 100
	var pos_y = 100
	var index = 0

	for i in range(7):
		for j in range(7):
			var piece = add_piece(pos_x, pos_y, i, j) #.modulate = Color(1, 1, 0, 0.6)
			piece.z_index = index
			index += 1
			pos_x += 100
		pos_x = 100
		pos_y += 100
	
	#$Piece.connect("clicked", self, "_on_Piece_clicked")
	#$Piece.connect("released", self, "_on_Piece_released")

func add_piece(x, y, n1, n2) -> Piece:
	# var piece_scene = load("res://Piece.tscn")
	var piece: Piece = piece_scene.instance()
	#var piece: Piece = Piece.new()	

	piece.position = Vector2(x, y)
	piece.set_values(n1, n2)
	piece.name = str(n1)+'x'+str(n2)
	
	pieces.push_front(piece)
	add_child(piece)
	
	#piece.connect("clicked", self, "_on_Piece_clicked")
	#piece.connect("released", self, "_on_Piece_released")
	
	return piece

func _on_Piece_released(piece: Piece):
	print('release')
	
	click_handled = false
	
	if selected_piece:
		selected_piece.drop()
		selected_piece = null

func _on_Piece_clicked(piece: Piece):
	if click_handled:
		return

	print('clic '+piece.name)

	click_handled = true
	
	if selected_piece:
		selected_piece.set_selected(false)
		selected_piece.drop()
		selected_piece = null

	if !selected_piece:
		selected_piece = piece
		selected_piece.pickup()
		selected_piece.set_selected(true)

func _input(event):
	if not event is InputEventMouseButton:
		return
	
	if event.button_index == BUTTON_RIGHT and event.is_pressed():
		if !selected_piece:
			selected_piece = get_clicked_piece()

		if selected_piece:
			selected_piece.el_rotate(90)

	if event.button_index == BUTTON_LEFT:
		get_tree().set_input_as_handled()
		print('in '+str(event.is_pressed()))

		if event.pressed:
			print('qui: ')
			if selected_piece:
				selected_piece.drop()
				selected_piece.set_selected(false)
			
			selected_piece = get_clicked_piece()
			
			if selected_piece:
				print('s-> '+selected_piece.name)
				selected_piece.pickup()
				selected_piece.set_selected(true)
			else:
				print('s-> none')
		else:
			if selected_piece:
				selected_piece.drop()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print('un '+str(event.to_string()))

		if selected_piece:
			selected_piece.set_selected(false)
			selected_piece.drop()
			selected_piece = null

func get_clicked_piece() -> Piece:
	var result = null
	
	var space_state = get_world_2d().get_direct_space_state()
	var dict_coliders = space_state.intersect_point(get_global_mouse_position(), 1000)
	
	for el in dict_coliders:
		var piece: Piece = el.collider;
		
		if not result or piece.z_index > result.z_index :
			#print('col: '+piece.name+' z '+str(piece.z_index))
			result = piece
	
	return result
