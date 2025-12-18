@tool
extends EditorScript

## Tool script to generate placeholder textures
## Run this from Editor → Run Script

func _run() -> void:
	print("Generating placeholder textures...")

	# Generate platform tile texture
	var platform_texture: Image = Image.create(32, 32, false, Image.FORMAT_RGBA8)

	# Fill with gray color
	platform_texture.fill(Color(0.4, 0.4, 0.4, 1.0))

	# Add a border for visibility
	for x in range(32):
		platform_texture.set_pixel(x, 0, Color.WHITE)
		platform_texture.set_pixel(x, 31, Color.BLACK)
	for y in range(32):
		platform_texture.set_pixel(0, y, Color.WHITE)
		platform_texture.set_pixel(31, y, Color.BLACK)

	# Save the texture
	var result: Error = platform_texture.save_png("res://resources/sprites/platform_tile.png")
	if result == OK:
		print("✓ Created platform_tile.png")
	else:
		print("✗ Failed to create platform_tile.png: ", result)

	print("Done! Reimport assets and restart the editor.")
