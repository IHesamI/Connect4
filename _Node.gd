extends Object
class_name _Node
var state:Array
var successors:Array
var heads:Array
var col:int
var score:int
func _init(state,col,heads) -> void:
	self.state=state
	self.heads=heads
#	self.heads[col]+=1
	self.col=col
	self.score=0
	

