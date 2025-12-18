extends Node

## Utility for generating simple textures programmatically


static func create_square_texture(size: int = 32, color: Color = Color.WHITE) -> ImageTexture:
	var image: Image = Image.create(size, size, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)


static func create_player_placeholder(size: int = 32) -> ImageTexture:
	return create_square_texture(size, Color.WHITE)
