
extends Node2D

var op
var data
var path
var size = 90
var h
var w
var pipe0
var pipe1
var pipe2
var pipe3
var pipe4

func _ready():
	h = int(get_viewport().get_rect().size.height / size) - 1
	w = int(get_viewport().get_rect().size.width / size) - 1
	
	var OPMethod = load("res://scripts/OPMethod.gd")
	op = OPMethod.new(w, h)
	data = op.createMaze()
	path = op.solveMaze(0, 0, w - 1, h - 1)
	
	pipe0 = load("res://graphics/pipe24.png")
	pipe1 = load("res://graphics/pipe1.png")
	pipe2 = load("res://graphics/pipe2.png")
	pipe3 = load("res://graphics/pipe3.png")
	pipe4 = load("res://graphics/pipe4.png")
	
	print("block ready")

func _draw():
	drawMaze(data, w, h, size, size)
	print("block draw")
	
func drawMaze(data, sizeX, sizeY, width, height):
	var color = Color(1.0, 0.0, 0.0)
	var ox = (get_viewport().get_rect().size.width - sizeX * width) / 2
	var oy = (get_viewport().get_rect().size.height - sizeY * height) / 2
	var pipe = [pipe0, pipe0, pipe0, pipe0, 
				pipe2, pipe2, 
				pipe3, pipe3, pipe3, pipe3, 
				pipe1, pipe1, pipe1, pipe1, 
				pipe4]
	var angles = [0, 270, 180, 90, 
				0, 90, 
				0, 90, 270, 180, 
				180, 0, 270, 90, 
				0]
	
	for i in range(sizeX):
		for j in range(sizeY):
			var type = getMazeType(data, i, j, sizeX, sizeY)
			var texture = pipe[type - 1]
			var angle = angles[type - 1]
			var pnt = Vector2(ox + width * i + width / 2, oy + height * j + height / 2)
			
			var sprite = Sprite.new()
			sprite.set_texture(texture)
			sprite.set_pos(pnt)
			sprite.set_rotd(angle)
			sprite.set_name(str("pipe", i, j))
			self.add_child(sprite)
	
# acoount the types
func getMazeType(data, x, y, width, height):
	var left
	var right
	var up
	var down
	var type = 0
	
	if((data[x][y] & 2) == 0):
		left = true
	
	if(x + 1 == width): 
		right = true
	elif((data[x + 1][y] & 2) == 0):
		right = true
		
	if((data[x][y] & 1) == 0):
		up = true
		
	if(y + 1 == height):
		down = true
	elif((data[x][y + 1] & 1) == 0):
		down = true
		
	# L from right to down way, left up wall
	if(left && !right && up && !down):
		type = 1
	#L from left to down way, right, up wall
	if(!left && right && up && !down):
		type = 2
	# L from up to left way, right up wall
	if(!left && right && !up && down):
		type = 3
	# L from up to right way, left down wall
	if(left && !right && !up && down):
		type = 4
		
	# I horizontal way, up, down wall
	if(!left && !right && up && down):
		type = 5
	# I vertical way left, right wall
	if(left && right && !up && !down):
		type = 6
		
	# T left, down and right way, up wall
	if(!left && !right && up && !down):
		type = 7
	# T up, right and down way, left wall
	if(left && !right && !up && !down):
		type = 8
	# T up, left and down way, right wall
	if(!left && right && !up && !down):
		type = 9
	# T up, right and left way, down wall
	if(!left && !right && !up && down):
		type = 10
		
	# E way from right
	if(!left && right && up && down):
		type = 11
	# E way from left
	if(left && !right && up && down):
		type = 12
	# E way from down
	if(left && right && up && !down):
		type = 13
	# E way from up
	if(left && right && !up && down):
		type = 14
		
	# X no wall
	if(!left && !right && !up && !down):
		type = 15
		
	return type
	
	
	

	