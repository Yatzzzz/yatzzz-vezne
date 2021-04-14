soygun = false
soygun1 = false
ara1 = false

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(250)
    end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(250)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local sleep = 3000

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(10)
        perform = false       
        for k,v in pairs(Config.arananyerler) do
            if Vdist2(GetEntityCoords(PlayerPedId(), false), Config.arananyerler.x, Config.arananyerler.y, Config.arananyerler.z) < 1.5 then
                perform = true
                TriggerEvent('yatzzz-vezne:ara')               
            end
            if perform then
                sleep = 5
            elseif not perform then
                sleep = 5000
            end
        end
    end
end)

RegisterNetEvent('yatzzz-vezne:ara')
AddEventHandler('yatzzz-vezne:ara', function()
    if soygun == true then
        if ara1 == false then 
            DrawText3D(Config.arananyerler.x, Config.arananyerler.y, Config.arananyerler.z, 'Ara')
            if IsControlJustPressed(0, 38) then
                TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
                TriggerEvent("mythic_progbar:client:progress", {
                    name = "packaging_taco",
                    duration = 8300,
                    label = "Aranıyor...",
                    useWhileDead = false,
                    canCancel = true,
                    controlDisables = {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    },               
                }, function(status)
                    if not status then
                        ClearPedTasks(PlayerPedId())
                        local ItemMiktar = math.random(1, 5)
                        if ItemMiktar == 1 then 
                            item = Config.Item1
                            count = Config.Miktar
                            itemname = "nakit"
                            TriggerEvent('notification', count.." tane "..itemname.." buldun.", 2)
                            TriggerServerEvent("yatzzz-itemver", item, count)
                        end
                        if ItemMiktar == 2 then 
                            item = Config.Item2
                            count = Config.Miktar
                            itemname = "nakit"
                            TriggerEvent('notification', count.." tane "..itemname.." buldun.", 2)
                            TriggerServerEvent("yatzzz-itemver", item, count)
                        end
                        if ItemMiktar == 3 then 
                            item = Config.Item3
                            count = Config.Miktar
                            itemname = "nakit"
                            TriggerEvent('notification', count.." tane "..itemname.." buldun.", 2)
                            TriggerServerEvent("yatzzz-itemver", item, count)
                        end
                        if ItemMiktar == 4 then 
                            item = Config.Item4
                            count = Config.Miktar
                            itemname = "nakit"
                            TriggerEvent('notification', count.." tane "..itemname.." buldun.", 2)
                            TriggerServerEvent("yatzzz-itemver", item, count)
                        end
                        if ItemMiktar == 5 then 
                            item = Config.Item1
                            count = Config.Miktar
                            itemname = "nakit"
                            TriggerEvent('notification', count.." tane "..itemname.." buldun.", 2)
                            TriggerServerEvent("yatzzz-itemver", item, count)
                        end
                        ara1 = true
                    else
                        exports["mythic_notify"]:DoHudText("error", "İşlem iptal edildi.")
                    end
                end)
            end
        end 
    end
end)

DrawText3D = function(x, y, z, text)
    local onScreen,x,y = World3dToScreen2d(x, y, z)
    local factor = #text / 370

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x,y)
        DrawRect(x,y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 120)
    end
end

RegisterNetEvent('yatzzz-vezne:kapiac')
AddEventHandler('yatzzz-vezne:kapiac', function()
    if soygun == false then 
        ESX.TriggerServerCallback('yatzzz-vezne:gerekliItem', function(quantity)
            if quantity >= 1 then
                ESX.TriggerServerCallback('yatzzz-vezne:polisgerekli', function(count)
                    if count >= Config.PoliceCount then
                      --  TriggerEvent('police:veznerobbery')
                        loadAnimDict('veh@break_in@0h@p_m_one@')
                        TaskPlayAnim(PlayerPedId(), "veh@break_in@0h@p_m_one@", "low_force_entry_ds", 1.0, 1.0, 1.0, 1, 0.0, 0, 0, 0)
                        FreezeEntityPosition(PlayerPedId(), true)
                        TriggerEvent("mythic_progbar:client:progress", {
                            name = "kapi_ac",
                            duration = 4700,
                            label = "Kapıyı açıyorsun...",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = false,
                                disableMouse = false,
                                disableCombat = true,
                            },                                                     
                        }, function(status)
                            if not status then
                                TriggerEvent('yatzzz-vezne:kapiaciliyor')
                                ClearPedTasks(PlayerPedId())
                                FreezeEntityPosition(PlayerPedId(), false)
                                soygun = true
                                soygun1 = true
                                sure = 600000
                            else
                                exports["mythic_notify"]:DoHudText("error", "İşlem iptal edildi.")
                            end
                        end)
                    else 
                        TriggerEvent('notification', "Yeterince polis yok!", 2)
                    end
                end)
            else 
                TriggerEvent('notification', "Maymuncugun Yok!", 2)
            end
        end, 'advancedlockpick')
    else
        TriggerEvent('notification', "Şuanda Banka Soyamazsın", 2)
    end
end)

RegisterCommand('secure', function()
    if PlayerData.job.name == 'polis' or  PlayerData.job.name == 'sheriff' then 
        TriggerEvent("mythic_progbar:client:progress", {
            name = "guvenlik",
            duration = 5000,
            label = "Güvenlik sağlanıyor...",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            },
        }, function(status)
            if not status then
                soygun1 = false
            else
                exports["mythic_notify"]:DoHudText("error", "İşlem iptal edildi.")
            end
        end)	
    else
        TriggerEvent('notification', "Bu Komutu Sadece Polis yada Sherifler Kullanabilir", 2)
    end
end)

RegisterNetEvent('yatzzz-vezne:kapiaciliyor')
AddEventHandler('yatzzz-vezne:kapiaciliyor', function()
    local playerPed		= PlayerPedId()
    local coords		= GetEntityCoords(playerPed)
    for _, kapi in pairs(Config.kapikordinat) do
        local bankDoor = GetClosestObjectOfType(kapi.x, kapi.y, kapi.z, 1.0, 4163212883, 0, 0, 0)
        local distance = GetDistanceBetweenCoords(kapi.x, kapi.y, kapi.z, coords.x, coords.y, coords.z, true)
        if distance < 0.50 then
            TriggerServerEvent('yatzzz-vezne:kapiyiac', kapi.id)
            SetEntityHeading(bankDoor, kapi.oh)
        end
    end
end)

RegisterNetEvent('yatzzz-vezne:sendBanking')
AddEventHandler('yatzzz-vezne:sendBanking', function(banks)
    Config.Banks = banks
end)

function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(7)
    end
end