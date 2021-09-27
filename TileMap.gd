extends TileMap

# Horizontal size of the map.
const SIZE_X: int = 5
# Vertical size of the map.
const SIZE_Y: int = 4
# moves previously played.
var moves = []
# map a cell number to :
# - true if the cell has *not* been played
# - false else
var available_cells = {}

func _ready():
	for x in range(0, SIZE_X):
		for y in range(0, SIZE_Y):
			var number = self.position_to_number(Vector2(x, y))
			available_cells[number] = true

# Convert a position on the board to the number it represents
func position_to_number(position: Vector2) -> int:
	return int(position.x + position.y * SIZE_X + 1)

# Apply the given move to the map (aka change a tile).
func make_move(move: Vector2) -> void:
	if self.get_cell(move.x, move.y) == 0:
		if not moves.empty():
			var previous = moves.back()
			self.set_cell(
				previous.x,
				previous.y,
				2,
				false,
				false,
				false,
				previous
			)
		self.set_cell(move.x, move.y, 1, false, false, false, move)
		moves.push_back(move)
		self.available_cells[self.position_to_number(move)] = false

# Returns `false` if the move is invalid.
func check_move(move: Vector2) -> bool:
	if moves.empty():
		return true
	var move_int = self.position_to_number(move)
	var previous_move = self.position_to_number(moves.back())
	if (previous_move % move_int == 0 or move_int % previous_move == 0):
		return true
	else:
		return false

# Revert back to the previous move.
func undo_move() -> void:
	if not moves.empty():
		var current = moves.pop_back()
		self.set_cell(current.x, current.y, 0, false, false, false, current)
		self.available_cells[self.position_to_number(current)] = true
		if not moves.empty():
			var previous = moves.back()
			self.set_cell(previous.x, previous.y, 1, false, false, false, previous)

# Returns `true` if we can still play a move.
func can_move() -> bool:
	if self.moves.empty():
		return true
	var previous_move = self.position_to_number(self.moves.back())
	for cell in self.available_cells.keys():
		if self.available_cells[cell]:
			if (previous_move % cell == 0 or cell % previous_move == 0):
				return true
	return false
