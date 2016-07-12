# class Optimal Path
# member variables here, example:
var sizeX = 10
var sizeY = 10

var cellStat = []
var cellData = []
var path = []

func _init(sx, sy):
	randomize()
	
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

#
func solveMaze(sx, sy, dx, dy):
	var mazePath = []
	mazePath.resize(sizeX)
	
	var destOK = false
	
	var calcPos = []
	calcPos.resize(2)
	
	var cellPos = []
	cellPos.resize(2)
	cellPos[0] = sx
	cellPos[1] = sy
	
	var state = []
	state.append(cellPos)
	
	var step = 0
	
	for i in range(sizeX):
		var ar = []
		ar.resize(sizeY)
		mazePath[i] = ar
		for j in range(sizeY):
			mazePath[i][j] = -1
	
	mazePath[sx][sy] = step
	
	while(destOK == false && state.size() > 0):
		step = step + 1
		var nextState = []
		
		for i in range(state.size()):
			
			calcPos = state[i]
			
			# up
			if(calcPos[1] > 0 && (mazePath[calcPos[0]][calcPos[1] - 1] == -1 && cellData[calcPos[0]][calcPos[1]] & 1) != 0):
				mazePath[calcPos[0]][calcPos[1] - 1] = step
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = calcPos[0]
				nextPos[1] = calcPos[1] - 1
				nextState.append(nextPos)
				
				if(nextPos[0] == dx && nextPos[1] == dy):
					destOK = true
			
			# left
			if(calcPos[0] > 0 && mazePath[calcPos[0] - 1][calcPos[1]] == -1 && (cellData[calcPos[0]][calcPos[1]] & 2) != 0):
				mazePath[calcPos[0] - 1][calcPos[1]] = step
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = calcPos[0] - 1
				nextPos[1] = calcPos[1]
				nextState.append(nextPos)
				
				if(nextPos[0] == dx && nextPos[1] == dy):
					destOK = true
			
			# down
			if(calcPos[1] < sizeY - 1 && mazePath[calcPos[0]][calcPos[1] + 1] == -1 && (cellData[calcPos[0]][calcPos[1] + 1] & 1) != 0):
				mazePath[calcPos[0]][calcPos[1] + 1] = step
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = calcPos[0]
				nextPos[1] = calcPos[1] + 1
				nextState.append(nextPos)
				
				if(nextPos[0] == dx && nextPos[1] == dy):
					destOK = true
			
			# rigth
			if(calcPos[0] < sizeX - 1 && mazePath[calcPos[0] + 1][calcPos[1]] == -1 && (cellData[calcPos[0] + 1][calcPos[1]] & 2) != 0):
				mazePath[calcPos[0] + 1][calcPos[1]] = step
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = calcPos[0] + 1
				nextPos[1] = calcPos[1]
				nextState.append(nextPos)
				
				if(nextPos[0] == dx && nextPos[1] == dy):
					destOK = true
				
		state = nextState
	
	var tx = dx
	var ty = dy
	var ex = false
	var path = []
	
	if(destOK != false):
		mazePath[dx][dy] = step
		
		var nextPos = []
		nextPos.resize(2)
		nextPos[0] = tx
		nextPos[1] = ty
		path.append(nextPos)
		
		while(tx != sx || ty != sy):
			step = mazePath[tx][ty]
			ex = false
			
			#up
			if(ty > 0 && ex == false && mazePath[tx][ty - 1] == step - 1 && (cellData[tx][ty] & 1) != 0):
				ty = ty - 1
				ex = true
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = tx
				nextPos[1] = ty
				path.append(nextPos)
			
			# left
			if(tx > 0 && ex == false && mazePath[tx - 1][ty] == step - 1 && (cellData[tx][ty] & 2) != 0):
				tx = tx - 1
				ex = true
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = tx
				nextPos[1] = ty
				path.append(nextPos)
			
			#down
			if(ty < sizeY - 1 && ex == false && mazePath[tx][ty + 1] == step - 1 && (cellData[tx][ty + 1] & 1) != 0):
				ty = ty + 1
				ex = true
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = tx
				nextPos[1] = ty
				path.append(nextPos)
			
			# right
			if(tx < sizeX - 1 && ex == false && mazePath[tx + 1][ty] == step - 1 && (cellData[tx + 1][ty] & 2) != 0):
				tx = tx + 1
				ex = true
				var nextPos = []
				nextPos.resize(2)
				nextPos[0] = tx
				nextPos[1] = ty
				path.append(nextPos)
	
	return path





