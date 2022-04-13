local floor = math.floor

local max_coins = settings.startup.BSMOND_max_coins.value
local health_for_coin = settings.startup.BSMOND_health_for_coin.value
local coins_for_killing_spawner = settings.startup.BSMOND_coins_for_killing_spawner.value
local function add_coin(prototype, coins)
  prototype.loot = prototype.loot or {}
  local loot = prototype.loot
  local count = coins or floor(prototype.max_health / health_for_coin)
  if count > max_coins then
    count = max_coins
  elseif count == 0 then
    return
  end
  loot[#loot+1] = {item = "coin", probability = 1, count_min = count, count_max = count}
end


for _, prototype in pairs(data.raw["unit"]) do
  local autoplace = prototype.autoplace
  if prototype.pollution_to_join_attack or
    prototype.build_base_evolution_requirement or
    autoplace and autoplace.force == "enemy"
  then
    add_coin(prototype)
  end
end

for _, prototype in pairs(data.raw["unit-spawner"]) do
  local autoplace = prototype.autoplace
  if autoplace and autoplace.force == "enemy" then
    add_coin(prototype, coins_for_killing_spawner)
  end
end

for _, prototype in pairs(data.raw["turret"]) do
  local autoplace = prototype.autoplace
  if autoplace and autoplace.force == "enemy" then
    add_coin(prototype)
  end
end
