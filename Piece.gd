extends RigidBody2D
class_name Piece

#signal clicked
#signal released

# onready var le_sprite: Sprite = $Sprite
# var le_sprite: Sprite

var held: bool = false
var initial_mouse_distance: Vector2
var top_value = 0
var bottom_value = 0

func _ready():
	#le_sprite = $Sprite
	pass

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position() - initial_mouse_distance

func pickup():
	#self.mode = MODE_CHARACTER
	held = true
	initial_mouse_distance = get_global_mouse_position() - global_transform.origin

func drop():
	#self.mode = MODE_RIGID
	held = false

func el_rotate(deg: float):
	var le_sprite: Sprite = $Sprite
	print('rotate')
	self.rotate(deg2rad(deg))

func set_values(a, b):
	var le_sprite: Sprite = $Sprite
	
	top_value = a
	bottom_value = b

	var x = max(a, b) * 32
	var y = min(a, b) * 64

	if le_sprite:
		#print("set_piece: "+str(a)+"-"+str(b)+" YES")
		le_sprite.region_rect = Rect2(Vector2(x, y), Vector2(32, 64))
	else:
		#print("set_piece: "+str(a)+"-"+str(b)+" NO")
		pass

func set_selected(selected: bool) -> void:
	var le_sprite: Sprite = $Sprite

	le_sprite.modulate = Color(1, 0, 0) if selected else Color(1, 1, 1)

func _input_event(viewport, event, shape_idx):
	return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				emit_signal("clicked", self)
				get_tree().set_input_as_handled()
			else:
				emit_signal("released", self)
				get_tree().set_input_as_handled()
