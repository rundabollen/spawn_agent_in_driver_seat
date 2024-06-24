//The following file is 100% shamelessly stolen from Tuntematon's M1 Abrams loader script with a few variable changes

tun_fnc_addLoader = {
	params ["_tank"];
	private _agent = createAgent ["vn_o_men_nva_65_36", getPosWorld _tank, [], 0, "NONE"]; //The first value inside qoutes in the square bracket is the classname of the crewman to spawn. He should probably be from the same side as the players
	_agent moveInDriver _tank;
	_agent assignAsDriver _tank;
	_agent addEventHandler ["GetOutMan", {
		params ["_unit", "_role", "_vehicle", "_turret"];
		_vehicle deleteVehicleCrew _unit;
		_vehicle setVariable ["tun_tankAgent", objNull];
	}];
	_agent addEventHandler ["SeatSwitchedMan", {
		params ["_unit1", "_unit2", "_vehicle"];
		_vehicle deleteVehicleCrew _unit1;
		_vehicle setVariable ["tun_tankAgent", objNull];
	}];
	_tank setVariable ["tun_tankAgent", _agent];
};

tun_fnc_deleteLoader = {
	params ["_tank"];
	private _agent = _tank getVariable "tun_tankAgent";
	_tank deleteVehicleCrew _agent;
	_tank setVariable ["tun_tankAgent", objNull];
};

if (hasInterface) then {
//-1 refers to the driver's seat, modify this value if you would like the agent to take another seat
//Creates action for creation of agent driver
	_createAgent = ["Create Driver", "Create Driver", "", { [_target] remoteExecCall ["tun_fnc_addLoader", 2]; }, { isNull(_target getVariable ["tun_tankAgent", objNull]) && isNull(vehicle _target turretUnit  [0,-1]) }, {}, [], [0, 0, 0], 2, [false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
	["vn_o_armor_pt76b_01_nva65", 1, ["ACE_SelfActions"], _createAgent] call ace_interact_menu_fnc_addActionToClass; //Replace with classname of the vehicle that you want to use!

//Creates action for removal of agent driver
	_deleteAgent = ["Delete Driver", "Delete Driver", "", { [_target] call tun_fnc_deleteLoader; }, {!isNull(_target getVariable ["tun_tankAgent", objNull])}, {}, [], [0, 0, 0], 2, [false, true, false, false, false]] call ace_interact_menu_fnc_createAction;
	["vn_o_armor_pt76b_01_nva65", 1, ["ACE_SelfActions"], _deleteAgent] call ace_interact_menu_fnc_addActionToClass; //Replace with classname of the vehicle that you want to use!
};
