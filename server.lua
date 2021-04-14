ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('advancedlockpick', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	TriggerClientEvent('yatzzz-vezne:kapiac', _source)

end)

RegisterServerEvent('yatzzz-vezne:kapiyiac')
AddEventHandler('yatzzz-vezne:kapiyiac', function(bankid)
    for _, bank in pairs(Config.Banks) do
        if bank.id == bankid then
            TriggerClientEvent('banking:CloseBank', -1, bank.id)
            bank.cdoor.open = true
            bank.cdoor.opentime = os.time(t)
            bank.cashierlr = os.time(t) + Config.CounterCooldowns.Between
            bank.cashlock = true
        end
    end
    TriggerClientEvent('yatzzz-vezne:sendBanking', -1, Config.Banks)
end)

ESX.RegisterServerCallback('yatzzz-vezne:polisgerekli', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	CopsConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			CopsConnected = CopsConnected + 1
		end
	end
    print(CopsConnected)
	cb(CopsConnected)
end)

ESX.RegisterServerCallback('yatzzz-vezne:gerekliItem', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    
    cb(quantity)
end)