local QBCore = exports['qb-core']:GetCoreObject()

props = {}
Targets = {}
peds = {}

CreateThread(function()
	-- Add Map Blips
	if Config.Blips then
		for k, v in pairs(Config.Locations) do
			if Config.Locations[k].blipTrue then
				local blip = AddBlipForCoord(v.location)
				SetBlipAsShortRange(blip, true)
				SetBlipSprite(blip, 527)
				SetBlipColour(blip, 81)
				SetBlipScale(blip, 0.7)
				SetBlipDisplay(blip, 6)
				BeginTextCommandSetBlipName('STRING')
				if Config.BlipNamer then AddTextComponentString(Config.Locations[k].name)
				else AddTextComponentString(tostring(Loc[Config.Lan].info["blip_seashells"])) end
				EndTextCommandSetBlipName(blip)
			end
		end
	end
	-- Spawn peds
	if Config.Pedspawn then
		for k, v in pairs(Config.PedList) do
			RequestModel(v.model) while not HasModelLoaded(v.model) do Wait(0) end
			peds[#peds+1] = CreatePed(0, v.model, v.coords.x, v.coords.y, v.coords.z, v.coords[4], false, false)
			SetEntityInvincible(peds[#peds], true)
			SetBlockingOfNonTemporaryEvents(peds[#peds], true)
			FreezeEntityPosition(peds[#peds], true)
			TaskStartScenarioInPlace(peds[#peds], v.scenario, 0, true)
			if Config.Debug then print("Ped Spawned") end
		end
	end
	Targets["DelPerro"] =
	exports['qb-target']:AddCircleZone("DelPerro", vector3(Config.Locations['DelPerroMarket'].location.x, Config.Locations['DelPerroMarket'].location.y, Config.Locations['DelPerroMarket'].location.z), 2.0, { name="DelPerro", debugPoly=Config.Debug, useZ=true, }, 
	{ options = { { event = "seashell-digging:openShop", icon = "fas fa-certificate", label = Loc[Config.Lan].info["browse_store"], }, { event = "seashell-digging:SeashellSell", icon = "fas fa-certificate", label = Loc[Config.Lan].info["seashellbuyer"], }, }, 
		distance = 2.0 })
	Targets["Vespucci"] =
	exports['qb-target']:AddCircleZone("Vespucci", vector3(Config.Locations['VespucciMarket'].location.x, Config.Locations['VespucciMarket'].location.y, Config.Locations['VespucciMarket'].location.z), 2.0, { name="Vespucci", debugPoly=Config.Debug, useZ=true, }, 
	{ options = { { event = "seashell-digging:openShop", icon = "fas fa-certificate", label = Loc[Config.Lan].info["browse_store"], }, { event = "seashell-digging:SeashellSell", icon = "fas fa-certificate", label = Loc[Config.Lan].info["seashellbuyer"], }, },
		distance = 2.0
	})
	-- Seashell pick-up
	for k,v in pairs(Config.SeashellPositions) do
		Targets["seashell"..k] =
		exports['qb-target']:AddCircleZone("seashell"..k, v.coords, 2.0, { name="seashell"..k, debugPoly=Config.Debug, useZ=true, }, 
		{ options = { { event = "seashell-digging:DigSeashells", icon = "fas fa-certificate", label = Loc[Config.Lan].info["dig_seashells"], }, },
			distance = 2.5
		})
	end
end)

--------------------------------------------------------
-- Seashell market Opening
RegisterNetEvent('seashell-digging:openShop', function() TriggerServerEvent("inventory:server:OpenInventory", "shop", "Seashell Market", Config.Items) end)

------------------------------------------------------------
-- Dig seashells Command / Animations
function loadAnimDict(dict) while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end 

RegisterNetEvent('seashell-digging:DigSeashells', function ()
	local p = promise.new()	QBCore.Functions.TriggerCallback("QBCore:HasItem", function(cb) p:resolve(cb) end, "beach_shovel")
	if Citizen.Await(p) then
		local pos = GetEntityCoords(PlayerPedId())
		loadAnimDict("switch@trevor@digging")
		TaskPlayAnim(PlayerPedId(), 'switch@trevor@digging', '001433_01_trvs_26_digging_exit' , 3.0, 3.0, -1, 1, 0, false, false, false)
		local pos = GetEntityCoords(PlayerPedId(), true)
		local shovelObject = CreateObject(`prop_tool_shovel`, pos.x, pos.y, pos.z, true, true, true)
		AttachEntityToEntity(shovelObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
		QBCore.Functions.Progressbar("dig_seashells", Loc[Config.Lan].info["digging_seashells"], math.random(10000,15000), false, true, {
			disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
			StopAnimTask(PlayerPedId(), "switch@trevor@digging", "001433_01_trvs_26_digging_exit", 1.0)
			SetEntityAsMissionEntity(shovelObject)--necessary for gta to even trigger DetachEntity
			Wait(5)
			DetachEntity(shovelObject, true, true)
			Wait(5)
			DeleteObject(shovelObject)
			TriggerServerEvent('seashell-digging:DiggingReward')
		end, function() -- Cancel
			StopAnimTask(PlayerPedId(), "switch@trevor@digging", "001433_01_trvs_26_digging_exit", 1.0)
			DetachEntity(shovelObject, true, true)
			Wait(5)
			DeleteObject(shovelObject)
		end)
	else
		TriggerEvent('QBCore:Notify', Loc[Config.Lan].error["no_beach_shovel"], 'error')
	end
end)

------------------------------------------------------------
-- Sell All Seashells
RegisterNetEvent('seashell-digging:SellAnim', function()
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('seashell-digging:Selling') -- Had to slip in the sell command during the animation command
	for k,v in pairs (peds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)		
			break
		end
	end
	TriggerEvent('seashell-digging:SeashellSell')
end)

-- Sell Individual Seashells
RegisterNetEvent('seashell-digging:SellAnim:Seashells', function(data)
	local pid = PlayerPedId()
	loadAnimDict("mp_common")
	TriggerServerEvent('seashell-digging:SellSeashell', data) -- Had to slip in the sell command during the animation command
	for k,v in pairs (peds) do
        pCoords = GetEntityCoords(PlayerPedId())
        ppCoords = GetEntityCoords(v)
		ppRot = GetEntityRotation(v)
        dist = #(pCoords - ppCoords)
        if dist < 2 then 
			TaskPlayAnim(pid, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            TaskPlayAnim(v, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
            Wait(1500)
            StopAnimTask(pid, "mp_common", "givetake2_a", 1.0)
            StopAnimTask(v, "mp_common", "givetake2_a", 1.0)
            RemoveAnimDict("mp_common")
			SetEntityRotation(v, 0,0,ppRot.z,0,0,false)
			break
		end
	end	
	if string.find(data, "seashell_1") or string.find(data, "seashell_2") or string.find(data, "seashell_3") or string.find(data, "seashell_4") or string.find(data, "seashell_5") then TriggerEvent('seashell-digging:SeashellSell:Seashell')
	else TriggerEvent('seashell-digging:SeashellSell') end
end)

------------------------
-- Beach Market Main Menu
RegisterNetEvent('seashell-digging:SeashellSell', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["seashell_buyer"], txt = Loc[Config.Lan].info["sell_seashells"], isMenuHeader = true }, 
		{ header = "", txt = Loc[Config.Lan].info["close"], params = { event = "seashell-digging:SellMenu:Close" } },
		{ header = Loc[Config.Lan].info["seashells"], txt = Loc[Config.Lan].info["see_options"], params = { event = "seashell-digging:SeashellSell:Seashell", } },
	})
end)
-- Beach Market - Seashell Selling Menu
RegisterNetEvent('seashell-digging:SeashellSell:Seashell', function()
    exports['qb-menu']:openMenu({
		{ header = Loc[Config.Lan].info["seashell_buyer"], txt = Loc[Config.Lan].info["sell_seashells"], isMenuHeader = true }, 
		{ header = "", txt = Loc[Config.Lan].info["return"], params = { event = "seashell-digging:SeashellSell", } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["seashell_1"].image.." width=30px>"..Loc[Config.Lan].info["seashell_1"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['seashell_1'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "seashell-digging:SellAnim:Seashells", args = 'seashell_1' } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["seashell_2"].image.." width=30px>"..Loc[Config.Lan].info["seashell_2"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['seashell_2'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "seashell-digging:SellAnim:Seashells", args = 'seashell_2' } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["seashell_3"].image.." width=30px>"..Loc[Config.Lan].info["seashell_3"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['seashell_3'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "seashell-digging:SellAnim:Seashells", args = 'seashell_3' } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["seashell_4"].image.." width=30px>"..Loc[Config.Lan].info["seashell_4"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['seashell_4'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "seashell-digging:SellAnim:Seashells", args = 'seashell_4' } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["seashell_5"].image.." width=30px>"..Loc[Config.Lan].info["seashell_5"], txt = Loc[Config.Lan].info["sell_all"].." "..Config.SellItems['seashell_5'].." "..Loc[Config.Lan].info["sell_each"], params = { event = "seashell-digging:SellAnim:Seashells", args = 'seashell_5' } },
		{ header = "<img src=nui://"..Config.img..QBCore.Shared.Items["moneybag"].image.." width=30px>"..Loc[Config.Lan].info["sell_everything"], txt = Loc[Config.Lan].info["sell_everything_detail"], params = { event = "seashell-digging:SellAnim" } },
	})
end)

------------------------
RegisterNetEvent('seashell-digging:SellMenu:Close', function() exports['qb-menu']:closeMenu() end)

------------------------
AddEventHandler('onResourceStop', function(resource) 
	if resource == GetCurrentResourceName() then 
		for k, v in pairs(Targets) do exports['qb-target']:RemoveZone(k) end		
		for k, v in pairs(peds) do DeletePed(peds[k]) end
		for i = 1, #props do DeleteObject(props[i]) end
	end
end)
