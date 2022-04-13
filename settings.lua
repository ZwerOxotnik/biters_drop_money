local auto_collect_setting =	{
	type = "bool-setting", name = "BSMOND_auto_collect",
	setting_type = "runtime-global",
	default_value = true
}
if mods.EasyAPI == nil then
	auto_collect_setting.localised_name = {"mod-setting-name.BSMOND_auto_collect_no_EasyAPI"}
end

data:extend({
	{
		type = "int-setting", name = "BSMOND_health_for_coin",
		setting_type = "startup",
		default_value = 100, minimal_value = 0, maximal_value = 8e4
	},
	{
		type = "int-setting", name = "BSMOND_max_coins",
		setting_type = "startup",
		default_value = 100, minimal_value = 1, maximal_value = 2000
	},
	{
		type = "int-setting", name = "BSMOND_coins_for_killing_spawner",
		setting_type = "startup",
		default_value = 100, minimal_value = 0, maximal_value = 2000
	},
	auto_collect_setting
})
