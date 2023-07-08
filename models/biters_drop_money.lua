local call = remote.call


local _coin_stack = {
	name = "coin",
	count = 4000000000, -- It's not safe to set count above ~4000000000
}
local _coinX50_stack = {
	name = "coinX50",
	count = 4000000000, -- It's not safe to set count above ~4000000000
}
local _coinX2500_stack = {
	name = "coinX2500",
	count = 4000000000, -- It's not safe to set count above ~4000000000
}
local function on_entity_died(event)
	local force = event.force
	if not force then return end
	local force_money = call("EasyAPI", "get_force_money", force.index)
	if force_money then return end
	local loot = event.loot
	local get_item_count = loot.get_item_count

	local count = get_item_count("coin")
	local money = count
	if count > 0 then
		loot.remove(_coin_stack)
	end
	count = get_item_count("coinX50")
	if count > 0 then
		money = money + count * 50
		loot.remove(_coinX50_stack)
	end
	count = get_item_count("coinX2500")
	if count > 0 then
		money = money + count * 2500
		loot.remove(_coinX2500_stack)
	end
	if money == 0 then return end

	call("EasyAPI", "set_force_money_by_index", force.index, force_money + money)
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
