
extends Node2D

# member variables here, example:
var op
var data
var path
var size = 10
var h
var w

func _ready():
	h = int(get_viewport().get_rect().size.height / size) - 1
	w = int(get_viewport().get_rect().size.width / size) - 1
	
	var OPMethod = load("res://scripts/OPMethod.gd")
	op = OPMethod.new(w, h)
	data = op.createMaze()
	path = op.solveMaze(0, 0, w - 1, h - 1)
	print("line ready")

func _draw():
	drawMaze(data, w, h, size, size)
	drawSolve(path, w, h, size, size)
	print("line draw")

func drawMaze(data, sizeX, sizeY, width, height):
	var color = Color(1.0, 0.0, 0.0)
	var ox = (get_viewport().get_rect().size.width - sizeX * width) / 2
	var oy = (get_viewport().get_rect().size.height - sizeY * height) / 2
	for i in range(sizeX):
		for j in range(sizeY):
			# horisontal
			if((data[i][j] & 1) == 0):
				var point1 = Vector2(ox + width * i, oy + height * j)
				var point2 = Vector2(ox + width * (i + 1), oy + height * j)
				draw_line(point1, point2, color, 2)
			
			#vertical
			if((data[i][j] & 2) == 0):
				var point1 = Vector2(ox + width * i, oy + height * j)
				var point2 = Vector2(ox + width * i, oy + height * (j + 1))
				draw_line(point1, point2, color, 2)
	
	draw_line(Vector2(ox, oy + sizeY * height), Vector2(ox + sizeX * width, oy + sizeY * height), color, 2)
	draw_line(Vector2(ox + sizeX * width, oy), Vector2(ox + sizeX * width, oy + sizeY * height), color, 2)

func drawSolve(path, sizeX, sizeY, width, height):
	var color = Color(0.0, 1.0, 0.0)
	var ox = (get_viewport().get_rect().size.width - sizeX * width) / 2
	var oy = (get_viewport().get_rect().size.height - sizeY * height) / 2
	for i in range(path.size() - 1):
		var cell1 = path[i]
		var cell2 = path[i + 1]
		var point1 = Vector2(ox + width * cell1[0] + width / 2, oy + height * cell1[1] + height / 2)
		var point2 = Vector2(ox + width * cell2[0] + width / 2, oy + height * cell2[1] + height / 2)
		draw_line(point1, point2, color, 2)

