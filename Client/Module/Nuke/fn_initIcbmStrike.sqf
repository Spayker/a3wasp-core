params ["_object", "_cruise"];
private ["_xpos", "_ypos"];

waitUntil {!alive _cruise};

_xpos = getpos _object select 0;
_ypos = getpos _object select 1;

argt_nuclear_radius = 1500;
argt_nuclear_blow_speed = 100;
argt_nuclear_half_life = 10 * 60;
argt_nuclear_radiation_damage = 0.03;
argt_nuclear_car_armour = 1 / 4;

sleep 4;

[_xpos, _ypos] execVM "Client\Module\Nuke\scripts\glare.sqf";
[_xpos, _ypos] execVM "Client\Module\Nuke\scripts\light.sqf";

[_xpos, _ypos] exec "Client\Module\Nuke\scripts\hat.sqs";
[_xpos, _ypos] execVM "Client\Module\Nuke\scripts\ears.sqf";
[_xpos, _ypos] execVM "Client\Module\Nuke\scripts\aperture.sqf";

sleep 0.5;
[_xpos, _ypos] exec "Client\Module\Nuke\scripts\hatnod.sqs";

[_xpos, _ypos] exec "Client\Module\Nuke\scripts\blast1.sqs";
[_xpos, _ypos] exec "Client\Module\Nuke\scripts\blast2.sqs";
sleep 0.4;
[_xpos, _ypos] exec "Client\Module\Nuke\scripts\blast3.sqs";

execVM "Client\Module\Nuke\scripts\weather.sqf";

sleep 20;
[_xpos, _ypos] execVM "Client\Module\Nuke\scripts\dust.sqf";

sleep 60;
[_xpos, _ypos] exec "Client\Module\Nuke\scripts\ring1.sqs";
sleep 6;
[_xpos, _ypos] exec "Client\Module\Nuke\scripts\ring2.sqs";