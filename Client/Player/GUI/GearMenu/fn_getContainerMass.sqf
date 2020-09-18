//--- Get the mass of/from/in a container
private["_container", "_container_capacity", "_container_items_mass", "_container_mass", "_items"];

_container = _this select 0;
_items = _this select 1;

_container_mass = (_container) call WFCL_fnc_getGenericItemMass;
_container_capacity = (_container) call WFCL_fnc_getContainerMassCapacity;
_container_items_mass = (_items) call WFCL_fnc_getItemsMass;

[_container_mass, _container_items_mass, _container_capacity]