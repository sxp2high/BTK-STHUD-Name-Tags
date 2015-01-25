/*
	BTK STHUD Tags main init.
*/


private ["_path"];


// Wait for player
waitUntil {(isDedicated) || !(isNull player)};


// No dedicated
if (isDedicated) exitWith {};


// Userconfig
_path = if (isClass (configFile >> "CfgPatches" >> "btk_sthudtags")) then { "\userconfig\btk_sthudtags\config.hpp"; } else { "btk_sthudtags\config.hpp"; };
[] call (compile (preprocessFileLineNumbers _path));


// Exit if already initialized or disabled
if (!(isNil "btk_sthudtags_init") || !(btk_sthudtags_enabled)) exitWith {};


// Note
player createDiarySubject ["BTK", "BTK"];
player createDiaryRecord ["BTK", ["BTK STHUD Tags", format["<br /><font color='%2'>BTK STHUD Tags</font><br /><br /><font color='%2'>Version:</font> 1.0.0<br /><font color='%2'>Author:</font> sxp2high (BTK) (btk@arma3.cc)<br /><font color='%2'>Source:</font> https://github.com/sxp2high/BTK-STHUD-Tags<br /><br /><font color='%2'>Description</font><br />Unit nametags for the ShackTac Fireteam HUD (STHUD).", ([(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML), "#c9cacc"]]];


// Main flow
[] spawn {

	// Register layer
	btk_sthudtags_rsc_layer = ["btk_sthudtags_rsc_layer_1"] call BIS_fnc_rscLayer;

	// Wait until ingame
	waituntil {!(isNull (finddisplay 46))};
	sleep 0.1;

	// Main loop
	while {true} do {

		// Wait for player being alive
		waitUntil {(alive player)};

		// Wait for cursor target and criteria
		waitUntil {!(isNull cursorTarget) && (alive player) && (alive cursorTarget) && (((vehicle cursorTarget) isKindOf "Man") || ((count (crew (vehicle cursorTarget))) > 0))};

		// Get variables
		_target = cursorTarget;
		_vehicle = (vehicle _target);
		_isMan = if (_vehicle isKindOf "Man") then { true; } else { false; };
		_unit = if (_isMan) then { _target; } else { if ((count (crew _target)) > 0) then { ((crew _target) select 0); } else { _target; }; };
		_name = if (alive _unit) then { (name _unit); } else { "Unknown"; };

		// Check for crew
		_show = if ((_vehicle == cursorTarget) && ((player distance _vehicle) < btk_sthudtags_distance) && ((_vehicle isKindOf "Man") || ((count (crew (_vehicle))) > 0)) && ((_vehicle isKindOf "Man") || (_unit in _vehicle)) && (alive player) && (alive cursorTarget) && ((side _unit) == (side player))) then { true; } else { false; };

		// Checks while looking at it
		while {(_vehicle == cursorTarget) && ((player distance _vehicle) < btk_sthudtags_distance) && ((_vehicle isKindOf "Man") || ((count (crew (_vehicle))) > 0)) && ((_vehicle isKindOf "Man") || (_unit in _vehicle)) && (alive player) && (alive cursorTarget) && ((group _unit) == (group player))} do {

			_playerPos = getPosATL player;
			_vehiclePos = getPosATL _vehicle;

			// Get color
			_color = switch (true) do {
				case ((_playerPos distance _vehiclePos) <= 3) : { "#ff7800"; };
				case (((_playerPos distance _vehiclePos) > 3) && ((_playerPos distance _vehiclePos) <= 15)) : { "#00ff00"; };
				default { "#ffffff"; };
			};

			// Show text
			[_name, _color] spawn BTK_sthudtags_fnc_showText;

			sleep 0.1; // Loop while looking at it

		};

		// Cut out
		if (_show) then {
			btk_sthudtags_rsc_layer cutText ["", "PLAIN", 0.1];
		};

		sleep 0.13; // Wait

	};

};


// All done
btk_sthudtags_init = true;