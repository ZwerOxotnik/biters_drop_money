if script.active_mods.EasyAPI == nil then return end
if not settings.startup.BSMOND_health_for_coin.value then return end

require("models/biters_drop_money")
