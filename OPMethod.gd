# class Optimal Path
# member variables here, example:
var sizeX = 10
var sizeY = 10

var cellStat = []
var cellData = []
var path = []

func _init(sx, sy):
	sizeX = sx
	sizeY = sy
	
	cellStat.resize(sx * sy)
	cellData.resize(sx)
	
func createMaze():
	var end = false
	var idxSrc
	var idxDsc
	var dir = 0
	var newCell = []
	var actCell = []
	var stack = []
	
	#initialize array
	for i in range(sizeX):
		var array = []
		array.resize(sizeY)
		for j in range(sizeY):
			array[j] = 0
			cellStat[i + j * sizeX] = -1
		cellData[i] = array
	
	actCell.resize(3)
	actCell[0] = randi()%sizeX
	actCell[1] = randi()%sizeY
	actCell[2] = 0

	# main cicle
	while(true):
		if(actCell[2] == 15):
			while(actCell[2] == 15):
				actCell = stack[stack.size() - 1]
				stack.pop_back()
				if(stack.size() == 0):
					end = true
					break
			
			if(end):
				break
		else:
			while(actCell[2] != 15):
				dir = int(pow(2, randi()%4));
				if((actCell[2] & dir) == 0):
					break
			
			actCell[2] |= dir
			idxSrc = actCell[0] + actCell[1] * sizeX
			
			# left
			if(dir == 1 && actCell[0] > 0):
				idxDsc = actCell[0] - 1 + actCell[1] * sizeX
				var bs = baseCell(idxSrc)
				var bd = baseCell(idxDsc)
				if(bs != bd):
					cellStat[bd] = bs
					cellData[actCell[0]][actCell[1]] |= 2
					
					newCell = copyCell(actCell)
					stack.push_back(newCell)
					actCell[0] -= 1
					actCell[2] = 0
			
			# right
			if(dir == 2 && actCell[0] < sizeX - 1):
				idxDsc = actCell[0] + 1 + actCell[1] * sizeX
				var bs = baseCell(idxSrc)
				var bd = baseCell(idxDsc)
				if(bs != bd):
					cellStat[bd] = bs
					cellData[actCell[0] + 1][actCell[1]] |= 2
					
					newCell = copyCell(actCell)
					stack.push_back(newCell)
					actCell[0] += 1
					actCell[2] = 0
			
			# up
			if(dir == 4 && actCell[1] > 0):
				idxDsc = actCell[0] + (actCell[1] - 1) * sizeX
				var bs = baseCell(idxSrc)
				var bd = baseCell(idxDsc)
				if(bs != bd):
					cellStat[bd] = bs
					cellData[actCell[0]][actCell[1]] |= 1
					
					newCell = copyCell(actCell)
					stack.push_back(newCell)
					actCell[1] -= 1
					actCell[2] = 0
			
			# down
			if(dir == 8 && actCell[1] < sizeY - 1):
				idxDsc = actCell[0] + (actCell[1] + 1) * sizeX
				var bs = baseCell(idxSrc)
				var bd = baseCell(idxDsc)
				if(bs != bd):
					cellStat[bd] = bs
					cellData[actCell[0]][actCell[1] + 1] |= 1
					
					newCell = copyCell(actCell)
					stack.push_back(newCell)
					actCell[1] += 1
					actCell[2] = 0
	
	return cellData

# serach base cell
func baseCell(idx):
	while(cellStat[idx] >= 0):
		idx = cellStat[idx]
	
	return idx

# copy a cell
func copyCell(act):
	var cell = []
	cell.resize(3)
	cell[0] = act[0]
	cell[1] = act[1]
	cell[2] = act[2]
	
	return cell

