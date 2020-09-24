Config = {}

Config.Locale = 'hr'

Config.Delays = {
	WeedProcessing = 1000 * 10
}

Config.DrugDealerItems = {
	marijuana = 1500
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. Requires esx_license

Config.LicensePrices = {
	weed_processing = {label = _U('license_weed'), price = 5000}
}

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	Prodaja = {coords = vector3(-1361.9998779297, -758.69036865234, 22.500738143921), name = _U('blip_weedfield'), color = 6, sprite = 378, radius = 25.0},
	WeedProcessing = {coords = vector3(-110.52914428711, -14.212184906006, 70.519645690918), name = _U('blip_weedprocessing'), color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(-1172.02, -1571.98, 4.66), name = _U('blip_drugdealer'), color = 6, sprite = 378, radius = 25.0}
}