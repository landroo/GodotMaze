
extends Node2D

# member variables here, example:
var op
var data
var s
var h
var w

func _ready():
	s = 10
	h = int(get_viewport().get_rect().size.height / s) - 1
	w = int(get_viewport().get_rect().size.width / s) - 1
	
	var OPMethod = load("OPMethod.gd")
	op = OPMethod.new(w, h)
	data = op.createMaze()
	

func _draw():
	drawMaze(data, w, h, s, s)
	print("draw")

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