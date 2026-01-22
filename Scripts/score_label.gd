extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ui字体脚本运行中") # 看控制台有没有输出 
	text = "分数 :" + str(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	text = "分数 :" + str(Global.score_board)  
