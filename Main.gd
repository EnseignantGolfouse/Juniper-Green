extends Node2D

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		var pos: Vector2 = event.position
		var x = floor(pos.x / $TileMap.cell_size.x)
		var y = floor(pos.y / $TileMap.cell_size.y)
		if x < 5 and y < 4:
			$Erreurs.text = ""
			var move = Vector2(x, y)
			if $TileMap.check_move(move):
				$TileMap.make_move(move)
				if not $TileMap.can_move():
					$Erreurs.text = "Fini !"
			else:
				var previous_move = $TileMap.position_to_number($TileMap.moves.back())
				$Erreurs.text = "Le prochain nombre doit être un multiple ou diviseur de " + String(previous_move) + "."
	elif (event is InputEventKey):
		if (event.scancode == KEY_Z and Input.is_key_pressed(KEY_Z)):
			$Erreurs.text = ""
			$TileMap.undo_move()
