/*
	File: fn_switchMove.sqf
	Author: sxp2high (BTK) (btk@arma3.cc)

	Description:
	Shows the names. (Based on BIS_fnc_dynamicText)

	Parameter(s):
		0: STRING - Text
		1: STRING - Text color

	Returns:
	NIL

	Syntax:
	["Name", "#ffffff"] call btk_sthudnametags_fnc_showText;
*/


private ["_text","_x","_y","_w","_h","_delay","_fade","_moveY","_layer"];


// For rsc
disableSerialization;


// Parameter
_name = _this select 0;
_color = _this select 1;


// Variables
_text = format["<t align='center' size='%2'><t color='%3'><t shadow='1'>%1</t></t></t>", _name, btk_sthudnametags_font_size, _color];
_x = -1;
_y = btk_sthudnametags_position_y;
_w = -1;
_h = -1;
_delay = 0.1;
_fade = 0;
_moveY = 0;
_layer = btk_sthudnametags_rsc_layer;


// Width
if (typename _x == typename []) then {
	_array = _x;
	_x = _array select 0;
	_w = _array select 1;
};


// Height
if (typename _y == typename []) then {
	_array = _y;
	_y = _array select 0;
	_h = _array select 1;
};


// Show
_layer cutRsc ["rscDynamicText","plain"];
_display = uiNamespace getVariable "BIS_dynamicText";


// Get ctrl
_control = _display displayCtrl 9999;
_control ctrlsetfade 1;
_control ctrlcommit 0;
_pos = ctrlPosition _control;


// Set pos
if (_x != -1) then {_pos set [0,_x]};
if (_y != -1) then {_pos set [1,_y]};
if (_w != -1) then {_pos set [2,_w]};
if (_h != -1) then {_pos set [3,_h]};
_control ctrlSetPosition _pos;


// Set text
if (typeName _text == typeName "") then {
	_control ctrlsetstructuredtext parseText _text;
} else {
	_control ctrlsetstructuredtext _text;
};


// Commit
_control ctrlcommit 0;
_control ctrlsetfade 0;
_control ctrlcommit _fade;


// Wait
waituntil {ctrlcommitted _control};


// Correct Y
if (_moveY != 0) then {
	_y = _pos select 1;
	_pos set [1,_y + _moveY];
	_control ctrlsetposition _pos;
	_control ctrlcommit _delay;
};


// Thread
_spawn = missionNamespace getVariable format["btk_sthudnametags_spawn_%1", _layer];
if (!(isNil "_spawn")) then  { terminate _spawn; };


// Main flow
_spawn = [_control,_delay,_fade,_moveY,_layer] spawn {

	// For rsc
	disableSerialization;

	// Parameter
	_control = _this select 0;
	_delay = _this select 1;
	_fade = _this select 2;
	_moveY = _this select 3;
	_layer = _this select 4;

	// Correct Y
	if (_moveY != 0) then { waitUntil {ctrlCommitted _control}; } else { sleep _delay; };

	// Commit
	_control ctrlSetFade 1;
	_control ctrlCommit 1;
	waituntil {ctrlCommitted _control};

	// Close
	_layer cutText ["", "PLAIN"];

};


// Set variable
missionNamespace setVariable [format["btk_sthudnametags_spawn_%1", _layer], _spawn];


// Done
waituntil {(scriptDone _spawn)};