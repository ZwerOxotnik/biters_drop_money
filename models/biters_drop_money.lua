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

	local force_index = force.index
	local force_money = call("EasyAPI", "get_force_money", force_index)
	if force_money then
		loot.remove(data_for_removing)
		call("EasyAPI", "set_force_money_by_index", force_index, force_money + money)
	end
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
		local setting_name = event.setting
		if setting_name ~= "BSMOND_auto_collect" then return end

		if settings.global[setting_name].value then
			add_on_entity_died_event()
		else
			script.on_event(defines.events.on_entity_died, nil)
		end
	end
)

script.on_init(function()
	if settings.global.BSMOND_auto_collect.value then
		add_on_entity_died_event()
	end
end)

script.on_load(function()
	if settings.global.BSMOND_auto_collect.value then
		add_on_entity_died_event()
	end
end)
