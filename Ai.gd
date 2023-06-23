extends Object
class_name Ai
var CurrnetTurn:int
var Main_Node:_Node
var Q_table:Array
var OPPONENT_WIN_SCORE=-500
var OPPONENT_WIN_CHANCE=-50
var AGENT_WIN_SCORE=5000
var AGENT_WIN_CHANCE=50
signal Game_OVER(message:String)
func _init(initial_State:Array) -> void:
	self.CurrnetTurn=1
	self.Main_Node=_Node.new(initial_State,-1,[0,0,0,0,0,0,0])
	self.Q_table=self.Q_learning('res://Assets/Q_table/q_table.csv')
	
# make the agent makes it's move and put a coin in the board
func Make_move():
	# if the turn is for agent make move
	if self.CurrnetTurn==-1:
		var choose_column=self.Best_Seccessor(self.Main_Node,self.CurrnetTurn).col
#		var choose_column=self.minmax(self.Successors(self.Main_Node,self.CurrnetTurn),-INF,INF,self.CurrnetTurn,0,2)
#		print(choose_column)
#		var choose_column=self.best_move_by_q_table(self.Main_Node.state)
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
func minmax(list_of_states:Array,alpha,beta,turn:int,currentDepth,treeDepth)->int:
	if list_of_states.size()==1 or currentDepth==treeDepth:
		return list_of_states[0].col
	var new_length=ceil(list_of_states.size()/2)
	var new_list_of_states=[]
	if turn==1: # Player Turn ==> need the state with minimum score
		var value = -INF
		for state in list_of_states:
			var best_state_seccessor=Best_Seccessor(state,turn)
			var seccessor_score=best_state_seccessor.score
			if seccessor_score > value:
				value =seccessor_score
				new_list_of_states.append(best_state_seccessor)
			alpha=max(alpha,value)
			if alpha >=beta:
				break
		new_list_of_states.sort_custom(func(a:_Node,b:_Node):return a.score<b.score)
		return minmax(new_list_of_states.slice(0,new_length),alpha,beta,turn*-1,currentDepth+1,treeDepth)
	else:
		var value=INF
		for state in list_of_states:
			var best_state_seccessor=Best_Seccessor(state,turn)
			var seccessor_score=best_state_seccessor.score
			if seccessor_score < value:
				value =seccessor_score
				new_list_of_states.append(best_state_seccessor)
			beta=min(beta,value)
			if alpha >=beta:
				break
			
		new_list_of_states.sort_custom(func(a:_Node,b:_Node):return a.score>b.score)
		return minmax(new_list_of_states.slice(0,new_length),alpha,beta,turn*-1,currentDepth+1,treeDepth)
			
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
			max_score=s.score
		index+=1
	return successors[best_sueccessor]
	
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


func Evaluation(Node_state:_Node,turn:int):
	var score =wining_check(Node_state.state)
	return score[1]

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
	if count0==1:
		if count_1==3:
			return [false,AGENT_WIN_CHANCE]
		elif  count1==3:
			return [false,OPPONENT_WIN_CHANCE]
	elif count0==2:
		if count_1==2:
			return [false,AGENT_WIN_CHANCE/2]
		elif  count1==2:
			return [false,OPPONENT_WIN_CHANCE/2]
	if count_1==4 :
			return [true,AGENT_WIN_SCORE] # agent can win with this move 
	elif count1==4:
			return [true,OPPONENT_WIN_SCORE] # player can win with this move 
	elif count1 ==3 and count_1 ==1:
			return [false,AGENT_WIN_CHANCE/2]
	return [false,0]

func wining_check(board)-> Array:
	var Winings=[]
	var someone_can_win=false
	for row in range(6):
		for column in range(4):
			var obj1=wining_probability_helper([board[row][column], board[row][column+1] ,board[row][column+2] ,board[row][column+3]])
			someone_can_win= someone_can_win or obj1[0]
			Winings.append(obj1[1])

	for column in range(7):
		for row in range(3):
			var obj1=wining_probability_helper([board[row][column], board[row+1][column] ,board[row+2][column]  ,board[row+3][column]])
			someone_can_win= someone_can_win or obj1[0]
			Winings.append(obj1[1])
	return [someone_can_win,sum(Winings)]

func sum(scores:Array)->int:
	var result=0
	for i in scores:
		result+=i
	return result	
