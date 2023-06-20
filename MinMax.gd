extends Object
class _Node:
	var state:Array
	var successors:Array
	

func Agent_turn():
	if CurrnetTurn==0:
		await  get_tree().create_timer(1).timeout
		board_actions(Agent_Result())
			

func probability_of_wining(board):
	for row in range(6):
		for column in range(5):
			if board[row][column]== board[row][column+1] and board[row][column]==board[row][column+2] and board[row][column]!=-1:
				return board[row][column] 

	for column in range(7):
		for row in range(4):
			if board[row][column]== board[row+1][column] and board[row][column]==board[row+2][column] and board[row][column]!=-1:
				return board[row][column] 
	return -1


	

	

func print_board(theboard):
	print('[')
	for row in theboard:
		print(row)
	print(']')


func Successors():
	var temp_states=[]
	for i in range(7):
		var head=Heads[i]
		var temp_board=board.duplicate(true)
		if head !=6:
			temp_board[head][i]=0
			temp_states.append(
			temp_board
			)
	return temp_states

func Evaluation(state,turn):
	var score =0 
	var result=probability_of_wining(state)	
	if -1!=result:
		if result==turn:
			score+=100
		else: 
			score-=100	
#	score+=check_for_block(state,turn)
	return score
func check_for_block(board,turn):
	var result_score=0
	for row in range(6):
		for column in range(4):
				result_score+=count_blocks([ board[row][column]==turn,turn== board[row][column+1] , turn== board[row][column+2] ,turn==board[row][column+3]])
	for column in range(7):
		for row in range(3):
				result_score+=count_blocks([board[row][column]==turn,turn== board[row+1][column] , turn==board[row+2][column] ,  turn==board[row+3][column]])
	return result_score

	
func count_blocks(expressions)->int:
	var true_count=0
#	var bias=2
	for expression in expressions:
		if expression:
			true_count+=5
#			bias^=2
		else : 
			true_count-=1
#			bias/=2
	return true_count
	
func Agent_Result():
	var Options=Successors()
	var Scores=[]
	for option_state in Options:
		Scores.append(Evaluation(option_state,CurrnetTurn))
	print(Scores)
	var treeDepth=ceili(log(Options.size())/log(2))
	print(Options.size(),treeDepth)
	var result_of_min_max=minimax(0,0,true,Scores,treeDepth)
	print(result_of_min_max)
	return result_of_min_max[1]

func get_max(obj1,obj2):
#	print(obj1,obj2)
	if obj1[0]> obj2[0]:
		return obj1
	else:
		return obj2
		
func get_min(obj1,obj2):
#	print(obj1,obj2)
	if obj1[0]> obj2[0]:
		return obj2
	else:
		return obj1

func minimax (curDepth, nodeIndex,
			 maxTurn, scores,
			 targetDepth):
	# base case : targetDepth reached
	if (curDepth == targetDepth):
#		print(nodeIndex)
		if nodeIndex<scores.size():
			return [scores[nodeIndex],nodeIndex]
		else:
			return [scores[nodeIndex-1],nodeIndex-1]
	
	if (maxTurn):	
		return get_max(minimax(curDepth + 1, nodeIndex * 2,
					false, scores, targetDepth),
				   minimax(curDepth + 1, nodeIndex * 2 + 1,
					false, scores, targetDepth))
	else:
		return get_min(minimax(curDepth + 1, nodeIndex * 2,
					 true, scores, targetDepth),
				   minimax(curDepth + 1, nodeIndex * 2 + 1,
					 true, scores, targetDepth))
