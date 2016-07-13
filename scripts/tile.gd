extends Node2D

var op
var data
var path
var size = 32
var h
var w
var wall
var green

func _ready():
	h = int(get_viewport().get_rect().size.height / size) - 1
	w = int(get_viewport().get_rect().size.width / size) - 1
	
	var OPMethod = load("res://scripts/OPMethod.gd")
	op = OPMethod.new(w / 2, h / 2)
	data = op.createMaze()
	path = op.solveMaze(0, 0, w / 2 - 1, h / 2 - 1)
	
	wall = load("res://graphics/tile.png")
	green = load("res://graphics/green.png")
	
	print("tile ready")

func _draw():
	drawMaze(data, w, h, size, size)
	#drawPath(path, w, h, size, size)
	print("title draw")
	
func drawMaze(data, sizeX, sizeY, width, height):
	var ox = (get_viewport().get_rect().size.width - sizeX * width) / 2
	var oy = (get_viewport().get_rect().size.height - sizeY * height) / 2
	# walls
	for j in range(0, sizeY - 1, 2):
		for i in range(0, sizeX - 1, 2):
			var pnt = Vector2(ox + i * width, oy + j * height)
			draw_texture(wall, pnt)
	for i in range(sizeX / 2):
		for j in range(sizeY / 2):
			# up wall
			if((data[i][j] & 1) == 0):
				var pnt = Vector2(ox + width * i * 2 + width, oy + height * j * 2)
				draw_texture(wall, pnt)
			# left wall
			if((data[i][j] & 2) == 0):
				var pnt = Vector2(ox + width * i * 2, oy + height * j * 2 + height)
				draw_texture(wall, pnt)
	# bottom
	for i in range(sizeX - 1):
		var pnt = Vector2(ox + i * width, oy + (sizeY - 1) * height)
		draw_texture(wall, pnt)
	#right
	for i in range(sizeY):
		var pnt = Vector2(ox + (sizeX - 1) * width, oy + i * height)
		draw_texture(wall, pnt)
		
func drawPath(path, sizeX, sizeY, width, height):
	var ox = (get_viewport().get_rect().size.width - sizeX * width) / 2
	var oy = (get_viewport().get_rect().size.height - sizeY * height) / 2
	for i in range(path.size()):
		var cell = path[i]
		var pnt = Vector2(ox + width * cell[0] * 2 + width, oy + height * cell[1] * 2 + height)
		draw_texture(green, pnt)
