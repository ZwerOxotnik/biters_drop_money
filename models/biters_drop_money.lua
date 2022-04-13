local call = remote.call


local data_for_removing = {
	name = "coin",
	count = 4000000000, -- It's not safe to set count above ~4000000000
}
local function on_entity_died(event)
	local loot = event.loot
	local money = loot.get_item_count("coin")
	if money <= 0 then return end
	local force = event.force
	if not (force and force.valid) then return end

	loot.remove(data_for_removing)
	call("EasyAPI", "deposit_force_money_by_index", force.index, money)
end


local function add_on_entity_died_event()
	script.on_event(
		defines.events.on_entity_died,
		on_entity_died,
		{
			{filter = "type", type = "unit", mode = "or"},
			{filter = "type", type = "unit-spawner", mode = "or"},
			{filter = "type", type = "turret", mode = "or"}
		}
	)
end


script.on_event(
	defines.events.on_runtime_mod_setting_changed,
	function(event)
		if event.setting ~= "BSMOND_auto_collect" then return end

		if settings.global["BSMOND_auto_collect"].value == false then
			script.on_event(defines.events.on_entity_died, nil)
		else
			add_on_entity_died_event()
		end
	end
)

if settings.startup.BSMOND_health_for_coin.value then
	add_on_entity_died_event()
end

