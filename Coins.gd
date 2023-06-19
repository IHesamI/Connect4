extends CharacterBody2D
func _ready() -> void:
	velocity=Vector2(0,100)


func _process(delta: float) -> void:
	move_and_slide()

func set_Sprite_texture(texture_path):
	$Sprite2D.texture=load(texture_path)
	
