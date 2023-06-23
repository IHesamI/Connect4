extends Node2D

var X_BASE=292
var X_differ=79

var Agent:Ai
var Y_BASE=50

const Textures=['','res://Assets/images/coinGold.png','res://Assets/images/coinDiamond.png']

func _ready() -> void:
	var init_state=[]
	for row in range(6):
		var rowArr:=[]
		for column in range(7):
			rowArr.append(0)
		init_state.append(rowArr)
	Agent=Ai.new(init_state)
	Agent.Game_OVER.connect(_on_game_over)
func _on_game_over(message:String):
	$MSG.text=message
	set_process(false)
func _process(delta: float) -> void:
	pass

func add_coins(column,turn):
	var coin=preload('res://Coins.tscn').instantiate()
	coin.set_Sprite_texture(Textures[turn])
	coin.position=Vector2(X_BASE +column*X_differ,Y_BASE)
	add_child(coin)
	check_for_game_over_state()
func check_for_game_over_state():
	var score_and_wining=Agent.wining_check(Agent.Main_Node.state)
	if score_and_wining[0]:
		if score_and_wining[1]>0:
			Agent.emit_signal('Game_OVER','YOU LOSE')
		else:
			Agent.emit_signal('Game_OVER','YOU Win')
	if is_Draw(Agent.Main_Node.state):
		Agent.emit_signal('Game_OVER','Draw')

func is_Draw(state:Array):
	for row in state:
		for column in row:
			if column !=0:
				return false
	return true	
func board_actions(col):
	Agent.update_board(col,Agent.CurrnetTurn)
	add_coins(col,Agent.CurrnetTurn)
	Agent.updateTurn()

func Agent_turn():
	var col=Agent.Make_move()
	add_coins(col,Agent.CurrnetTurn)
	Agent.updateTurn()
#	Check_game_is_over()
	
func handle_mouse_event(event:InputEvent,col:int) -> void :
	if event is InputEventMouseButton and event.pressed and Agent.CurrnetTurn==1:
		board_actions(col)
		$Timer.start()
		await  $Timer.timeout
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
