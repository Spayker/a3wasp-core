// by ALIAS
_snow_fog = "#particlesource" createVehicleLocal [_this#0,_this#1,_this#2];
_snow_fog setParticleCircle [5+random 10,[0,0,0]];
_snow_fog setParticleRandom [1,[1,1,0.1],[0,0,0],0,0.01,[0,0,0,0.01],1,1];
_snow_fog setParticleParams [["\A3\data_f\cl_basic",1,0,1],"","Billboard",1,5,[0,0,0],[vit_x,vit_y,0],15,10,8,0.07,[1,5,10],[[1,1,1,0.01],[1,1,1,0.02],[1,1,1,0]],[1],1,0,"","",[_this#0,_this#1,_this#2]];
_snow_fog setDropInterval 0.01;
[_snow_fog] spawn {params["_snow_fog"];sleep 0.4;deleteVehicle _snow_fog};

_snow_cloud = "#particlesource" createVehicleLocal [_this#0,_this#1,_this#2];
_snow_cloud setParticleCircle [3,[0,0,0]];
_snow_cloud setParticleRandom [0.1,[1,1,0.1],[0,0,0],0,0.01,[0,0,0,0.01],1,0];
_snow_cloud setParticleParams [["\A3\data_f\ParticleEffects\Universal\Universal",16,13,6,0],"","Billboard",1,2,[0,0,0],[vit_x,vit_y,0],7+random 33,1.2,1,0.02+random 0.09,[1,1,5,8],[[1,1,1,0],[1,1,1,0],[1,1,1,0.1],[1,1,1,0]],[1000],1,0,"","",[_this#0,_this#1,_this#2]];
_snow_cloud setDropInterval 0.1;
[_snow_cloud] spawn {params["_snow_cloud"];sleep 1;deleteVehicle _snow_cloud};