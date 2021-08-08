extends Node

const SEMI_PI               : float = PI * .5
const QUART_PI              : float = SEMI_PI * .5
const EIGHT_PI              : float = QUART_PI * .5

const MAX_PLAYER_RINGS      : int = 999
const MAX_PLAYER_LOSS_RINGS : int = 30

const PLAYER_ENEMY_SCORE    : int = 100
const MAX_SCORE             : int = 9999999999999999

const PLAYER_MAX_UNDERWATER_SECONDS : float = 5.0

const INVINCIBLE_POST_DAMAGE_TIME : float = 4.0
const INVINCIBLE_POWERUP_TIME     : float = 30.0

const BONUS_PER_RING        : int = 100
const BONUS_PER_RANK_S      : int = 10000

const DEFAULT_GAME_FOLDER   : String = "res://Game/"
const INGAME_SCENE          : String = "res://Engine/MainScenes/Ingame/Ingame.tscn"
const ZONE_COMPLETED_SCENE  : String = "res://Engine/MainScenes/ZoneCompleted/ZoneCompleted.tscn"
const GAME_OVER_SCENE       : String = "res://Engine/MainScenes/GameOver/GameOver.tscn"
const START_MENU_SCENE      : String = "res://Engine/MainScenes/StartMenu/StartMenu.tscn"
const MENU_LEVEL_SELECTOR_SCENE : String = "res://Engine/MainScenes/LevelSelector/LevelSelector.tscn"


enum RelightedEngineShieldTypes {
	BASIC,
	FIRE,
	ELECTRIC,
	BUBBLE,
	ICE
}

enum RelightedEngineSlideMaterial {
	ICE,
	OIL
}
