biters_drop_money = {}


local floor = math.floor
local DEFAULT_MAX_COINS = settings.startup.BSMOND_max_coins.value
local HEALTH_FOR_COIN = settings.startup.BSMOND_health_for_coin.value
local COINS_FOR_KILLING_SPAWNER = settings.startup.BSMOND_coins_for_killing_spawner.value


biters_drop_money.add_coins = function(prototype, coins, max_coins)
	if prototype.max_health == nil then return end

	max_coins = max_coins or DEFAULT_MAX_COINS
	prototype.loot = prototype.loot or {}
	local loot = prototype.loot
	local count = coins or floor(prototype.max_health / HEALTH_FOR_COIN)
	if count > max_coins then
		count = max_coins
	elseif count == 0 then
		return
	end

	if EasyAPI then
		local coin_count = math.floor(count / 2500)
		if coin_count > 0 then
			loot[#loot+1] = {item = "coinX2500", probability = 1, count_min = coin_count, count_max = coin_count}
			count = count - coin_count * 2500
		end
		coin_count = math.floor(count / 50)
		if coin_count > 0 then
			loot[#loot+1] = {item = "coinX50", probability = 1, count_min = coin_count, count_max = coin_count}
			count = count - coin_count * 50
		end
		if count > 0 then
			loot[#loot+1] = {item = "coin", probability = 1, count_min = count, count_max = count}
		end
	else
		loot[#loot+1] = {item = "coin", probability = 1, count_min = count, count_max = count}
	end
end
biters_drop_money._add_coins = biters_drop_money.add_coins

if HEALTH_FOR_COIN > 0 then
	for _, prototype in pairs(data.raw["unit"]) do
		local autoplace = prototype.autoplace
		if prototype.subgroup == "enemies" then
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
