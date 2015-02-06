/*
	BTK STHUD Tags main init.
*/


// Wait for player
waitUntil {(isDedicated) || !(isNull player)};


// No dedicated
if (isDedicated) exitWith {};


// Userconfig
[] call (compile (preprocessFileLineNumbers "\userconfig\btk\btk_sthudnametags.hpp"));


// Userconfig not found
if (isNil "btk_sthudnametags_enabled") then {
	[] call (compile (preprocessFileLineNumbers "btk_sthudnametags\btk_sthudnametags.hpp"));
	[] spawn { sleep 1; hint parseText format["<t align='left'><t color='#ff0000'>WARNING</t><br />BTK STHUD Name Tags userconfig is missing!<br />Using default settings...</t>"]; };
};


// Exit if already initialized or disabled
if (!(isNil "btk_sthudnametags_init") || !(btk_sthudnametags_enabled)) exitWith {};


// Init flag
btk_sthudnametags_init = true;


// Note
player createDiarySubject ["BTK", "BTK"];
player createDiaryRecord ["BTK", ["BTK STHUD Name Tags", format["<br /><font color='%2'>Addon:</font> BTK STHUD Name Tags<br /><font color='%2'>Version:</font> 1.0.0<br /><font color='%2'>Author:</font> sxp2high (BTK) (btk@arma3.cc)<br /><br /><font color='%2'>Readme, Changelog, License</font> <br />https://github.com/sxp2high/BTK-STHUD-Name-Tags<br /><br /><font color='%2'>Key bindings</font><br />None", ([(profileNamespace getVariable ["GUI_BCG_RGB_R", 0.3843]), (profileNamespace getVariable ["GUI_BCG_RGB_G", 0.7019]), (profileNamespace getVariable ["GUI_BCG_RGB_B", 0.8862]), (profileNamespace getVariable ["GUI_BCG_RGB_A", 0.7])] call BIS_fnc_colorRGBAtoHTML), "#c9cacc"]]];


// Register layer
btk_sthudnametags_rsc_layer = ["btk_sthudnametags_rsc_layer_1"] call BIS_fnc_rscLayer;


// Main flow
[] spawn {

	// Wait until ingame
	waituntil {!(isNull (finddisplay 46))};
	sleep 1;

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
		_show = if ((_vehicle == cursorTarget) && ((player distance _vehicle) < btk_sthudnametags_distance) && ((_vehicle isKindOf "Man") || ((count (crew (_vehicle))) > 0)) && ((_vehicle isKindOf "Man") || (_unit in _vehicle)) && (alive player) && (alive cursorTarget) && ((side _unit) == (side player))) then { true; } else { false; };

		// Checks while looking at it
		while {(_vehicle == cursorTarget) && ((player distance _vehicle) < btk_sthudnametags_distance) && ((_vehicle isKindOf "Man") || ((count (crew (_vehicle))) > 0)) && ((_vehicle isKindOf "Man") || (_unit in _vehicle)) && (alive player) && (alive cursorTarget) && ((group _unit) == (group player))} do {

			_playerPos = getPosATL player;
			_vehiclePos = getPosATL _vehicle;

			// Get color
			_color = switch (true) do {
				case ((_playerPos distance _vehiclePos) <= 3) : { "#ff7800"; };
				case (((_playerPos distance _vehiclePos) > 3) && ((_playerPos distance _vehiclePos) <= 15)) : { "#00ff00"; };
				default { "#ffffff"; };
			};

			// Show text
			[_name, _color] spawn btk_sthudnametags_fnc_showText;

			sleep 0.1; // Loop while looking at it

		};

		// Cut out
		if (_show) then {
			btk_sthudnametags_rsc_layer cutText ["", "PLAIN", 0.1];
		};

		sleep 0.13; // Wait

	};

};


true