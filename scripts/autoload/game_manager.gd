extends Node

## Central state management for match configuration and tracking
##
## Handles match settings, player registration, scores, and game state.

# Match configuration
@export var rounds_to_win: int = 3
@export var starting_arrows: int = 3
@export var respawn_delay: float = 2.0

# Player data structure
class PlayerData:
	var player_id: int
	var device_id: int  # -1 for keyboard, >= 0 for joypad
	var score: int = 0
	var is_active: bool = true
	var color: Color = Color.WHITE

	func _init(id: int, device: int, player_color: Color = Color.WHITE) -> void:
		player_id = id
		device_id = device
		color = player_color

# Game state
enum GameState {
	MENU,
	MATCH_SETUP,
	ROUND_COUNTDOWN,
	ROUND_ACTIVE,
	ROUND_END,
	MATCH_END
}

var current_state: GameState = GameState.MENU
var current_round: int = 0
var players: Dictionary = {}  # player_id -> PlayerData
var active_player_count: int = 0

# Player colors for differentiation
const PLAYER_COLORS: Array[Color] = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW
]


func _ready() -> void:
	EventBus.player_died.connect(_on_player_died)
	EventBus.round_ended.connect(_on_round_ended)


func register_player(player_id: int, device_id: int) -> void:
	if player_id >= 0 and player_id < 4:
		var color: Color = PLAYER_COLORS[player_id] if player_id < PLAYER_COLORS.size() else Color.WHITE
		players[player_id] = PlayerData.new(player_id, device_id, color)
		active_player_count += 1


func unregister_player(player_id: int) -> void:
	if players.has(player_id):
		players.erase(player_id)
		active_player_count -= 1


func get_player_data(player_id: int) -> PlayerData:
	return players.get(player_id)


func get_player_color(player_id: int) -> Color:
	var data: PlayerData = get_player_data(player_id)
	return data.color if data else Color.WHITE


func add_score(player_id: int, points: int = 1) -> void:
	if players.has(player_id):
		players[player_id].score += points
		EventBus.score_updated.emit(player_id, players[player_id].score)


func get_score(player_id: int) -> int:
	return players[player_id].score if players.has(player_id) else 0


func reset_scores() -> void:
	for player_data in players.values():
		player_data.score = 0
		EventBus.score_updated.emit(player_data.player_id, 0)


func check_match_winner() -> int:
	for player_data in players.values():
		if player_data.score >= rounds_to_win:
			return player_data.player_id
	return -1


func start_match() -> void:
	current_state = GameState.MATCH_SETUP
	current_round = 0
	reset_scores()
	EventBus.match_started.emit(players.size())


func start_round() -> void:
	current_round += 1
	current_state = GameState.ROUND_COUNTDOWN
	EventBus.round_started.emit(current_round)


func end_round(winner_id: int) -> void:
	current_state = GameState.ROUND_END
	if winner_id >= 0:
		add_score(winner_id)

	var scores: Dictionary = {}
	for player_data in players.values():
		scores[player_data.player_id] = player_data.score

	EventBus.round_ended.emit(winner_id, scores)


func end_match(winner_id: int) -> void:
	current_state = GameState.MATCH_END
	EventBus.match_ended.emit(winner_id)


func _on_player_died(_player: CharacterBody2D, _player_id: int, _killer_id: int) -> void:
	pass


func _on_round_ended(_winner_id: int, _scores: Dictionary) -> void:
	var winner_id: int = check_match_winner()
	if winner_id >= 0:
		end_match(winner_id)
