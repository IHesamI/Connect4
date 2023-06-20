extends Node2D

var CurrnetTurn:int = 1 # 1 means player turn and 0 means Ai turn  

var board:=[]
var Heads=[0,0,0,0,0,0,0]

var X_BASE=292
var X_differ=79

var Y_BASE=50

const Textures=['res://Assets/images/coinDiamond.png'
			   ,'res://Assets/images/coinGold.png']
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	for row in range(6):
		var rowArr:=[]
		for column in range(7):
			rowArr.append(-1)
		board.append(rowArr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_coins(column,turn):
	var coin=preload('res://Coins.tscn').instantiate()
	coin.set_Sprite_texture(Textures[turn])
	coin.position=Vector2(X_BASE +column*X_differ,Y_BASE)
	add_child(coin)


func wining_check(board):
	for row in range(6):
		for column in range(4):
			if board[row][column]== board[row][column+1] and board[row][column]==board[row][column+2] and board[row][column]==board[row][column+3] and board[row][column]!=-1:
				return board[row][column] 

	for column in range(7):
		for row in range(3):
			if board[row][column]== board[row+1][column] and board[row][column]==board[row+2][column] and board[row][column]==board[row+3][column] and board[row][column]!=-1:
				return board[row][column] 
	return -1

func check_game_status():
	var is_win=wining_check(board)
	if is_win!=-1:
		return is_win
	for head in Heads:
		if head !=6:
			return -1 		
	return 2 # when the board is full and no one wins
func update_board(col:int,turn:int):
	var col_head=Heads[col]
	Heads[col]+=1
	board[col_head][col]=turn

func board_actions(col):
	update_board(col,CurrnetTurn)
	add_coins(col,CurrnetTurn)
	#print(check_game_status()) #
	CurrnetTurn=(CurrnetTurn+1)%2 # resests the turn with this expression	

func handle_mouse_event(event:InputEvent,col:int) -> void :
	if event is InputEventMouseButton and event.pressed and CurrnetTurn==1:
		board_actions(col)
		Agent_turn()
		

		
func _on_col_1_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,0)


func _on_col_2_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,1)


func _on_col_3_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,2)


func _on_col_4_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,3)


func _on_col_5_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,4)


func _on_col_6_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,5)


func _on_col_7_gui_input(event: InputEvent) -> void:
	handle_mouse_event(event,6)
