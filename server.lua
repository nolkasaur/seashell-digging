local QBCore = exports['qb-core']:GetCoreObject()

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then 
		for k, v in pairs(Config.SellItems) do if not QBCore.Shared.Items[k] then print("Missing Item from QBCore.Shared.Items: '"..k.."'") end end		
		for i = 1, #Config.RewardPool do if not QBCore.Shared.Items[Config.RewardPool[i]] then print("Missing Item from QBCore.Shared.Items: '"..Config.RewardPool[i].."'") end end
	end
end)

RegisterServerEvent('seashell-digging:DiggingReward', function()
	local Player = QBCore.Functions.GetPlayer(source)
	local randomChance = math.random(1, 2)
	local randItem = Config.RewardPool[math.random(1, #Config.RewardPool)]
    Player.Functions.AddItem(randItem, randomChance, false, {})
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[randItem], "add", randomChance)
end)

RegisterNetEvent("seashell-digging:Selling", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentitem = data
	local count = 0
	for k, v in pairs(Config.SellItems) do
		if Player.Functions.GetItemByName(k) ~= nil then
			count = count + 1
			local amount = Player.Functions.GetItemByName(k).amount
			local pay = (amount * v)
			Player.Functions.RemoveItem(k, amount)
			Player.Functions.AddMoney('cash', pay)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[k], 'remove', amount)
		end
	end
	if count == 0 then TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have_any"], "error") end
end)

RegisterNetEvent("seashell-digging:SellSeashell", function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local currentitem = data
    if Player.Functions.GetItemByName(data) ~= nil then
        local amount = Player.Functions.GetItemByName(data).amount
        local pay = (amount * Config.SellItems[data])
        Player.Functions.RemoveItem(data, amount)
        Player.Functions.AddMoney('cash', pay)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[data], 'remove', amount)
    else
        TriggerClientEvent("QBCore:Notify", src, Loc[Config.Lan].error["dont_have"].." "..QBCore.Shared.Items[data].label, "error")
    end
end)
