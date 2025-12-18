extends GutTest

## Unit tests for GameManager singleton


func before_each() -> void:
	# Clear any existing players
	GameManager.players.clear()
	GameManager.active_player_count = 0
	GameManager.current_round = 0
	GameManager.current_state = GameManager.GameState.MENU


func test_register_player() -> void:
	GameManager.register_player(0, -1)
	assert_eq(GameManager.active_player_count, 1, "Should have 1 active player")
	assert_true(GameManager.players.has(0), "Should have player with ID 0")


func test_register_multiple_players() -> void:
	GameManager.register_player(0, -1)
	GameManager.register_player(1, -2)
	GameManager.register_player(2, 0)

	assert_eq(GameManager.active_player_count, 3, "Should have 3 active players")
	assert_eq(GameManager.players.size(), 3, "Should have 3 players in dictionary")


func test_unregister_player() -> void:
	GameManager.register_player(0, -1)
	GameManager.unregister_player(0)

	assert_eq(GameManager.active_player_count, 0, "Should have 0 active players")
	assert_false(GameManager.players.has(0), "Should not have player with ID 0")


func test_get_player_data() -> void:
	GameManager.register_player(0, -1)
	var data: GameManager.PlayerData = GameManager.get_player_data(0)

	assert_not_null(data, "Should return player data")
	assert_eq(data.player_id, 0, "Player ID should be 0")
	assert_eq(data.device_id, -1, "Device ID should be -1")


func test_get_player_color() -> void:
	GameManager.register_player(0, -1)
	var color: Color = GameManager.get_player_color(0)

	assert_eq(color, Color.RED, "Player 0 should be red")


func test_add_score() -> void:
	GameManager.register_player(0, -1)
	GameManager.add_score(0, 1)

	assert_eq(GameManager.get_score(0), 1, "Player 0 should have score of 1")


func test_reset_scores() -> void:
	GameManager.register_player(0, -1)
	GameManager.register_player(1, -2)
	GameManager.add_score(0, 3)
	GameManager.add_score(1, 2)

	GameManager.reset_scores()

	assert_eq(GameManager.get_score(0), 0, "Player 0 score should be reset")
	assert_eq(GameManager.get_score(1), 0, "Player 1 score should be reset")


func test_check_match_winner_no_winner() -> void:
	GameManager.register_player(0, -1)
	GameManager.add_score(0, 2)

	var winner: int = GameManager.check_match_winner()
	assert_eq(winner, -1, "Should have no winner yet")


func test_check_match_winner_has_winner() -> void:
	GameManager.register_player(0, -1)
	GameManager.add_score(0, 3)

	var winner: int = GameManager.check_match_winner()
	assert_eq(winner, 0, "Player 0 should be the winner")


func test_start_match() -> void:
	GameManager.register_player(0, -1)
	GameManager.register_player(1, -2)

	GameManager.start_match()

	assert_eq(GameManager.current_state, GameManager.GameState.MATCH_SETUP, "Should be in match setup state")
	assert_eq(GameManager.current_round, 0, "Round should be 0")


func test_start_round() -> void:
	GameManager.start_round()

	assert_eq(GameManager.current_round, 1, "Should be round 1")
	assert_eq(GameManager.current_state, GameManager.GameState.ROUND_COUNTDOWN, "Should be in countdown state")
