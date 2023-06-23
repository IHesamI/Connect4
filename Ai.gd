extends Object
class_name Ai
var CurrnetTurn:int
var Main_Node:_Node
var Q_table:Array
func _init(initial_State:Array) -> void:
	self.CurrnetTurn=1
	self.Main_Node=_Node.new(initial_State,-1,[0,0,0,0,0,0,0])
	self.Q_table=self.Q_learning('res://Assets/Q_table/q_table.csv')
	
# make the agent makes it's move and put a coin in the board
func Make_move():
	# if the turn is for agent make move
	if self.CurrnetTurn==-1:
#		var choose_column=self.Best_Seccessor(self.Main_Node,self.CurrnetTurn).col
#		print(choose_column)
		var choose_column=self.best_move_by_q_table(self.Main_Node.state)
		update_board(choose_column,self.CurrnetTurn) 
		return choose_column
func best_move_by_q_table(state):
#	print_board(state)
	var state_str=self.str_converter(state)
	print(state_str)
	
	for S_A in self.Q_table:
		if S_A[0]== state_str:
			print('zarp')
			return get_the_max_value(S_A[1])
	
	return randi()	% 7

func get_the_max_value(list_of_scores:Array):
	var max_val =list_of_scores.max()
	
	if list_of_scores.count(max_val)	==1:
		return  list_of_scores.bsearch(max_val)
	else:
		var options=[]
		for i in range(list_of_scores.size()):
			if list_of_scores[i]==max_val:
				options.append(i)
				
		return options[self.random_move(0,options.size())]

func str_converter(state:Array):
	var result=''
	for row in state:
		for column in row:
			result+=str(column)
	return result
func random_move(upper_range,lower_range):
	var random=RandomNumberGenerator.new()
	return random.randi_range(lower_range,upper_range)
	
func Q_learning(filepath):
	var csv_data=[]
	var file=FileAccess.open(filepath,FileAccess.READ)
	while (!file.eof_reached()):
		var line =file.get_line()
		var row =line.split(',')
		if row.size()>1:
			var scores:=[]
			for i in range(1,8):
				scores.append(float(row[i]))
			csv_data.append([row[0],scores])
	return csv_data

func update_board(col:int,turn:int):
	var col_head=self.Main_Node.heads[col]
	self.Main_Node.heads[col]+=1
	self.Main_Node.state[col_head][col]=turn
# set the turn for new move 	
func updateTurn():
	self.CurrnetTurn=self.CurrnetTurn*-1
	
func print_board(theboard):
	print('[')
	for row in theboard:
		print(row)
	print(']')

# MIN MAX Algorithm
func minmax(list_of_states:Array,turn:int):
	if list_of_states.size()==1:
		return list_of_states[0].col
	var new_length=ceil(list_of_states.size()/2)
	var new_list_of_states=[]
	for state in list_of_states:
		var best_state_seccessor=Best_Seccessor(state,turn)
		new_list_of_states.append(best_state_seccessor)
	if turn==1: # Player Turn ==> need the state with minimum score
		new_list_of_states.sort_custom(func(a:_Node,b:_Node):return a.score<b.score)
		return minmax(new_list_of_states.slice(0,new_length),turn*-1)
				
	else:
		new_list_of_states.sort_custom(func(a:_Node,b:_Node):return a.score>b.score)
		return minmax(new_list_of_states.slice(0,new_length),turn*-1)
			
func Best_Seccessor(root_node:_Node,turn:int)->_Node:
	var successors=self.Successors(root_node,turn)
	var max_score=-1
	var best_sueccessor:int
	var index=0
	for s in successors:		
		var score=0
		s.score=self.Evaluation(s,turn)
		if max_score<s.score:
			best_sueccessor=index
		index+=1
	return successors[best_sueccessor]
	
# create the successors for the board state 
func Successors(Node_Board:_Node,turn)->Array:
	var temp_states=[]
	for i in range(7):
		var suc_heads=Node_Board.heads.duplicate(true)
		var head=suc_heads[i]
		suc_heads[i]+=1
		var temp_board=Node_Board.state.duplicate(true)
		if head <6:
			temp_board[head][i]=turn
			var successorNode=_Node.new(temp_board,i,suc_heads)
			temp_states.append(
			successorNode
			)
	return temp_states

func possible_game_status_(node_state:Array,turn:int):
	var winflag=wining_check(node_state)
	if winflag.has(turn):
		return true
	return false


func Evaluation(Node_state:_Node,turn:int)->int:
	var score =0 
	if player_win(Node_state.state,turn):
		score+=300
	if enemy_can_win_with_this_successor(Node_state,turn*-1):
		score-=100
	return score

func enemy_can_win_with_this_successor(Node_state:_Node,enemy_turn:int):
	var heads=Node_state.heads
	var index=0
	for column_head in heads:
		if column_head<6:
			var temp_board=Node_state.state.duplicate(true)
			temp_board[column_head][index]=enemy_turn
			if possible_game_status_(temp_board,enemy_turn):
				return true
		index+=1
	return false
			

func player_win(board:Array,turn:int)->bool:
	return possible_game_status_(board,turn)	

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
	if count_1==4 :
			return [true,-1] # agent can win with this move 
	elif count1==4:
			return [true,1] # player can win with this move 

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
