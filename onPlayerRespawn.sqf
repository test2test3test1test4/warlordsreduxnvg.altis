params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];
0 spawn KS_fnc_unflipVehicleAddAction;

private _grp = (_newUnit getVariable ["MRTM_currentGroup", (createGroup (side _newUnit))]);
[_newUnit] joinSilent _grp;
private _leader = (leader _grp);

if (count ((units _newUnit) select {!(isPlayer _x)}) > 0) then {
	[group _newUnit, _newUnit] remoteExec ["selectLeader", (groupOwner group _newUnit)];
};

if ((_newUnit != _leader) && {(alive _leader) && {((_oldUnit distance _leader) < 100) && {isPlayer _leader}}}) then {
	0 spawn BIS_fnc_WL2_orderLastLoadout;
	_newUnit setVehiclePosition [getPosATL _leader, [], 2, "NONE"];
};

{
	if (isNull _x) then {
		missionNamespace setVariable [(format ["BIS_WL_%1_ownedVehicles", getPlayerUID player]), ((missionNamespace getVariable [format ["BIS_WL_%1_ownedVehicles", getPlayerUID player], []]) - [_x])];
	};
} forEach (missionNamespace getVariable (format ["BIS_WL_%1_ownedVehicles", getPlayerUID player]));

["Died"] spawn MRTM_fnc_statTracker;

player addAction [
	"10K CP", 
	{[player, "10k"] remoteExec ["BIS_fnc_WL2_handleClientRequest", 2]} 
];