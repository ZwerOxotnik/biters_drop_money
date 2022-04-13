biters_drop_money = {}


local floor = math.floor
local DEFAULT_MAX_COINS = settings.startup.BSMOND_max_coins.value
local HEALTH_FOR_COIN = settings.startup.BSMOND_health_for_coin.value
local COINS_FOR_KILLING_SPAWNER = settings.startup.BSMOND_coins_for_killing_spawner.value


biters_drop_money.add_coins = function(prototype, coins, max_coins)
	max_coins = max_coins or DEFAULT_MAX_COINS
	prototype.loot = prototype.loot or {}
	local loot = prototype.loot
	local count = coins or floor(prototype.max_health / HEALTH_FOR_COIN)
	if count > max_coins then
		count = max_coins
	elseif count == 0 then
		return
	end
	loot[#loot+1] = {item = "coin", probability = 1, count_min = count, count_max = count}
end

if HEALTH_FOR_COIN > 0 then
	for _, prototype in pairs(data.raw["unit"]) do
		local autoplace = prototype.autoplace
		if prototype.pollution_to_join_attack or
			prototype.build_base_evolution_requirement or
			autoplace and autoplace.force == "enemy"
		then
			biters_drop_money.add_coins(prototype)
		end
	end
	for _, prototype in pairs(data.raw["turret"]) do
		local autoplace = prototype.autoplace
		if autoplace and autoplace.force == "enemy" then
			biters_drop_money.add_coins(prototype)
		end
	end
end

if COINS_FOR_KILLING_SPAWNER > 0 then
	for _, prototype in pairs(data.raw["unit-spawner"]) do
		local autoplace = prototype.autoplace
		if autoplace and autoplace.force == "enemy" then
			biters_drop_money.add_coins(prototype, COINS_FOR_KILLING_SPAWNER, COINS_FOR_KILLING_SPAWNER)
		end
	end
end
