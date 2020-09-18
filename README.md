# ARMA3WARFARE_CORE
Core module: client and common scripts, mission resources

## Project structure
````
\Client
	\Base			- faction base management tools
		\baserep	- base repair feature that is allowed only or current com
	\Economy		- money & suppluy utility functions
	\Module			- extra modules to control weather conditions, vehicle features 
		\Engines	- stealth engine feature that applies to almost all vehicles in mission 
		\Jumper		- inantry related feature to make high jump from flying air units
		\Nuke		- a custom module to launch ICBMs in game
			\scripts- a set of scripts responsible or nuke related effects in game
		\Valhalla	- a set of scripts to enable low gear feature or almost vehicles in game 
		\Weather	- a set o scripts that modifies weather conditions in every match
	\Player			- tools to control player entity in game
		\Action		- mission related set of actions appliable to each player
		\Chat		- chat functions to notify about certain in-game events
		\Commander	- base commander set of functions
		\GUI		- GUI screens for player
			\BuyUnitsMenu		- buy units including vehicles menu
			\CommanderVoteMenu	- vote menu that is available for current base commander in-game
			\CommandMenu		- a menu that allows to command certain squads on map
			\EasaMenu		- easa module that extends posibilities of air combat unit's re-arming
			\EconomyMenu		- economy menu that allows to sell bases and set taxes or player's income
			\FundsMenu		- a menu or money transferring
			\GearMenu		- a gear menu for equipment purchasing 
			\HelpMenu		- a secondary menu with game mode common info
			\ParametersMenu		- a menu that displays current mission start parameters
			\RespawnMenu		- a menu that allows to choose where a dead player will spawn next time
			\RolesMenu		- a menu to select player's role on battlefield
			\ServiceMenu		- a menu to service vehicles (repair, rearm, refuel), inantry (healing)
			\TacticalMenu		- a menu to run uavs, paratroopers, fire support
			\TankMagsMenu		- a menu to rearm armored combat units
			\TeamMenu		- a menu with common set o eatures that player can apply on its squad and on himself
			\UnitCameraMenu		- a menu that allows to observe in irst camera view mode player's units and side team mates
			\UpgradeMenu		- a menu that allows or base commander to perform upgrades
			\VoteMenu		- a common base commander voting menu available or each player
			\WarfareMenu		- a main warare menu
		\Init	- a set of init scripts
		\Map	- map related functions
		\Skill	- a set o functions with skill definitions
	\Task		- in game task management
	\Unit		- unit related control functions
	\Warfare	- game mode related functions
		\Camp	- a set of functions for camp object managemant
		\Town	- a set of functions for town object managemant

Common
	Array			- extra functions to operate with arrays and its data inside
	Base			- faction base management tools
	Economy			- money & suppluy utility functions
	Logging			- functions to provide logging of different technical and in game events
	Map				- map control functions 
	Module			- extra modules to control weather conditions, vehicle features 
		CIPHER		- a set of sorting functions
		Kb			- kb module for radio commands
		Role		- set of functions that forms feature o player roles in game
		Weather		- a set o scripts that modifies weather conditions in every match
	Object			- function array to work with gear, unit, vehicle entities
		Gear		- a set of functions that operates on gear objects
		Unit		- a set of functions that operates on unit (infantry) objects
		Vehicle		- a set of functions that operates on vehicle objects
	Player			- tools to control player entity in game
	Utils			- extra utility functions to work with warfare related config files and in game locations
		Config		- a set of functions that operates on object's config
		Location	- a set of functions that operates on location definitions in game's space
	Warfare			- game mode related functions
		Camp		- a set of functions for camp object managemant
		Config		- a set of functions that orms in game config base of units, gear, base structures, artillery and so on
		Town		- a set of functions for town object managemant
RSC	- a folder of additional resources
	Pictures - a folder of additional images
sounds - a set of sounds for radio transmissions
	warfareEN
	warfareTK
````