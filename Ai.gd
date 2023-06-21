extends Object
class_name Ai
var CurrnetTurn:int
var Main_Node:_Node
func _init(initial_State:Array) -> void:
	self.CurrnetTurn=1
	self.Main_Node=_Node.new(initial_State,-1,[0,0,0,0,0,0,0])
# make the agent makes it's move and put a coin in the board
func Make_move():
	# if the turn is for agent make move
	if self.CurrnetTurn==0:
		var choose_column=self.MiniMax(self.Main_Node,self.CurrnetTurn)
		print(self.Main_Node.heads)
		update_board(2,self.CurrnetTurn) 
		return 2

# Update the board after making the move 

func update_board(col:int,turn:int):
	var col_head=self.Main_Node.heads[col]
	self.Main_Node.heads[col]+=1
	self.Main_Node.state[col_head][col]=turn
# set the turn for new move 	
func updateTurn():
	self.CurrnetTurn=(self.CurrnetTurn+1)%2
	
func print_board(theboard):
	print('[')
	for row in theboard:
		print(row)
	print(']')

# MIN MAX Algorithm
func MiniMax(root_node:_Node,turn:int):
	var successors=self.Successors(root_node,turn)
	for s in successors:
		var score=0
		self.print_board(s.state)
		print(self.Evaluation(s,turn))

# create the successors for the board state 
func Successors(Node_Board:_Node,turn)->Array:
	var temp_states=[]
	for i in range(7):
		var suc_heads=Node_Board.heads.duplicate(true)
		var head=suc_heads[i]
		suc_heads[i]+=1
		var temp_board=Node_Board.state.duplicate(true)
		if head !=6:
			temp_board[head][i]=turn
			var successorNode=_Node.new(temp_board,i,suc_heads)
			temp_states.append(
			successorNode
			)
	return temp_states

func wining(node_state:_Node,turn:int):
	var winflag=wining_check(node_state.state)
	print(winflag)
	
	if winflag.has(-1):
		if winflag==turn:
			return +1
		else :
			return -1
	return 0


func Evaluation(Node_state:_Node,turn:int):
	var score =0 
	score+=wining(Node_state,turn)
#	for successor in node_successors:
#		score+=0
	return score


func wining_probability_helper(expressions):
	var count0=0
	var count1=0
	var count_1=0
	for expr in expressions:
		if expr==0:
			count0+=1
		elif expr==1:
			count1+=1
		else:
			count_1+=1
	if count_1==1:
		if count1==0 :
			print('zarp')
			return [true,0]
		elif count0==0:
			print('zorp')
			return [true,1]
	return [false,null]

func wining_check(board)-> Array:
	var Winings=[]
	for row in range(6):
		for column in range(4):
			var obj1=wining_probability_helper([board[row][column], board[row][column+1] ,board[row][column+2] ,board[row][column+3]])
			if (obj1[0]):
				Winings.append(obj1[1])

	for column in range(7):
		for row in range(3):
			var obj1=wining_probability_helper([board[row][column], board[row+1][column] ,board[row+2][column]  ,board[row+3][column]])
			if obj1[0]:
				Winings.append(obj1[1])
	return Winings
