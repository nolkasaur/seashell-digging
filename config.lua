print("Seashell Digging script by nolkasaur")

Loc = {}
Config = {}

Config = {
	Debug = false, -- Debug mode?
	Blips = true, -- Blips?
	BlipNamer = false, -- Name Blips different things, disable if you already have too many blips as this will group them together
	Pedspawn = true, -- Spawn peds?
	img = "qb-inventory/html/images/", --Set this to the image directory of your inventory script
	Lan = "en", -- Language (as of this moment, there's "en" and "pt")
}

-- Each one has individual blip enablers
Config.Locations =  {
	['DelPerroMarket'] = { name = "Seashell Market", location = vector4(-1791.87, -856.24, 8.2, 113.33), blipTrue = false }, -- The location of the Del Perro Beach seashell market
	['VespucciMarket'] = { name = "Seashell Market", location = vector4(-1462.85, -1389.72, 3.14, 110.09), blipTrue = false }, -- The location of the Vespucci Beach seashell market
}

------------------------------------------------------------
-- Seashell digging locations
Config.SeashellPositions = {
	--- Del Perro Beach
	{ coords = vector3(-1829.62, -921.85, 1.38), },
	{ coords = vector3(-1832.6, -913.39, 1.53), },
	{ coords = vector3(-1836.59, -904.83, 1.64), },
	{ coords = vector3(-1840.76, -898.2, 1.61), },
	{ coords = vector3(-1847.78, -883.88, 1.92), },
	{ coords = vector3(-1858.07, -879.07, 1.12), },
	{ coords = vector3(-1865.4, -868.86, 1.15), },
	{ coords = vector3(-1870.49, -858.11, 1.59), },
	{ coords = vector3(-1878.14, -852.61, 1.19), },
	{ coords = vector3(-1884.04, -846.5, 1.06), },
	--- Vespucci Beach
	{ coords = vector3(-1497.0, -1431.94, 1.05), },
	{ coords = vector3(-1499.12, -1426.74, 1.03), },
	{ coords = vector3(-1501.66, -1419.64, 1.06), },
	{ coords = vector3(-1505.51, -1409.47, 1.04), },
	{ coords = vector3(-1510.28, -1399.52, 0.91), },
	{ coords = vector3(-1513.82, -1386.18, 1.07), },
	{ coords = vector3(-1515.68, -1374.09, 1.25), },
	{ coords = vector3(-1518.85, -1362.97, 1.28), },
	{ coords = vector3(-1523.53, -1350.11, 1.21), },
	{ coords = vector3(-1525.52, -1335.57, 1.39), },
}

-----------------------------------------------------------
-- Rewards from digging
Config.RewardPool = {
	[1] = "seashell_1",
	[2] = "seashell_2",
	[3] = "seashell_3",
	[4] = "seashell_4",
	[5] = "seashell_5",
}

------------------------------------------------------------
-- Selling Prices
Config.SellItems = {
	['seashell_1'] = 100,
	['seashell_2'] = 120,
	['seashell_3'] = 150,
	['seashell_4'] = 80,
	['seashell_5'] = 70,

}

------------------------------------------------------------
-- Peds to spawn
Config.PedList = {
	{ model = `a_f_y_beach_01`, coords = Config.Locations['DelPerroMarket'].location, gender = "male", scenario = "WORLD_HUMAN_DRUG_DEALER", }, -- Del Perro Beach
	{ model = `a_m_m_beach_02`, coords = Config.Locations['VespucciMarket'].location, gender = "male", scenario = "WORLD_HUMAN_DRUG_DEALER", }, -- Vespucci Beach
}

------------------------------------------------------------
-- Beach Store Items
Config.Items = {
    label = "Beach Store",  slots = 1,
    items = {
		[1] = { name = "water_bottle", price = 50, amount = 20, info = {}, type = "item", slot = 1, },
		[2] = { name = "beach_shovel", price = 100, amount = 20, info = {}, type = "item", slot = 2, },
	}		
}
