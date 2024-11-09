-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
if not wsb then return print((Strings.no_wsb):format(GetCurrentResourceName())) end
local ESX = nil
if wsb.framework == 'esx' then ESX = exports['es_extended']:getSharedObject() end
----------------------------------------------------------------
-- Customize text ui, notifications, target and more with the --
-- "wasabi_bridge" dependency in the "customize" directory    --
-- "wasabi_bridge/customize/cl_customize.lua"                 --
----------------------------------------------------------------

--Send to jail
RegisterNetEvent('wasabi_police:sendToJail', function()
    if not wsb.hasGroup(Config.policeJobs) then return end
    local target, time

    if Config.Jail.input then
        local coords = GetEntityCoords(cache.ped)
        local player = lib.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
        if not player then
            TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        else
            local input = lib.inputDialog(Strings.minutes_dialog, {Strings.minutes_dialog_field})
            if not input then return end
            local input1 = tonumber(input[1])
            if type(input1) ~= 'number' then return end
            local quantity = math.floor(input1)
            if quantity < 1 then
                TriggerEvent('wasabi_bridge:notify', Strings.invalid_amount, Strings.invalid_amount_desc, 'error')
            else
                target, time = GetPlayerServerId(player), quantity
            end
        end
    end
    if Config.Jail.jail == 'rcore' then
        ExecuteCommand('jail '..target..' jailed '..time..' Sentenced')
    elseif Config.Jail.jail == 'tk_jail' then
        if wsb.framework == 'esx' then
            exports.esx_tk_jail:jail(target, time)
        elseif wsb.framework == 'qb' then
            exports.qb_tk_jail:jail(target, time)
        end
    elseif Config.Jail.jail == 'hd_jail' then
TriggerServerEvent('HD_Jail:sendToJail', target, 'Prison', time, 'Sentenced', 'Police')
    elseif Config.Jail.jail == 'myPrison' then
        ExecuteCommand('jail')
    elseif Config.Jail.jail == 'qalle-jail' then
        TriggerServerEvent('esx-qalle-jail:jailPlayer', target, time, 'Sentenced')
    elseif Config.Jail.jail == 'plouffe' then
        exports.plouffe_jail:Set(target, time)
    elseif Config.Jail.jail == 'mx' then
        TriggerServerEvent('mx_jail:jailPlayer', target, time, target)
        TriggerServerEvent('mx_jail:setTime', target, time)
    elseif Config.Jail.jail == 'pickles' then
        TriggerServerEvent("pickle_prisons:jailPlayer", target, time)
    elseif Config.Jail.jail == 'custom' then
        -- Custom logic here?
    end
end)

--Impound Vehicle
impoundSuccessful = function(vehicle)
    if not DoesEntityExist(vehicle) then return end
    SetEntityAsMissionEntity(vehicle, false, false)
    if Config.AdvancedParking == 'jg' then
        TriggerEvent('jg-advancedgarages:client:ImpoundVehicle')
    else
        DeleteVehicle(vehicle)
    end
    if not DoesEntityExist(vehicle) then
        TriggerEvent('wasabi_bridge:notify', Strings.success, Strings.car_impounded_desc, 'success')
    end
end

--Death check
deathCheck = function(serverId)
    serverId = serverId or GetPlayerServerId(PlayerId())
    local ped = GetPlayerPed(GetPlayerFromServerId(serverId)) or PlayerPedId()
    return Player(serverId).state.dead
        or IsPedFatallyInjured(ped)
        or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
        or IsEntityPlayingAnim(ped, 'mini@cpr@char_b@cpr_def', 'cpr_pumpchest_idle', 3)
end

-- Personal locker access
function OpenPersonalStash(station)
    if not Config.Locations[station] or not Config.Locations[station].personalLocker then return end
    if #(GetEntityCoords(PlayerPedId()) - Config.Locations[station].personalLocker.coords) > Config.Locations[station].personalLocker.range then return end
    if not wsb.inventorySystem then return end
    if not wsb.hasGroup(Config.policeJobs) then return end

    station = station .. '_' .. wsb.getIdentifier()

    wsb.inventory.openStash({
        name = station,
        maxWeight = 50000,
        slots = 30
    })
end

-- Evidence locker access
function OpenEvidenceLocker(station)
    if not Config.Locations[station] or not Config.Locations[station].evidenceLocker then return end
    if #(GetEntityCoords(PlayerPedId()) - Config.Locations[station].evidenceLocker.coords) > Config.Locations[station].evidenceLocker.range then return end
    if not wsb.inventorySystem then return end
    if not wsb.hasGroup(Config.policeJobs) then return end

    local input = wsb.inputDialog(Strings.evidence_storage, { Strings.locker_number }, Config.UIColor)
    if not input or not input[1] then
        TriggerEvent('wasabi_bridge:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
        return
    end
    input = tonumber(input[1])
    if type(input) ~= 'number' then
        TriggerEvent('wasabi_bridge:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
        return
    end
    if input < 1 then
        TriggerEvent('wasabi_bridge:notify', Strings.invalid_entry, Strings.invalid_entry_desc, 'error')
        return
    end

    input = math.floor(input)

    station = station .. '_evidence_' .. input

    wsb.inventory.openStash({
        name = station,
        maxWeight = 500000,
        slots = 100
    })
end

--Search player
searchPlayer = function(player)
    if not wsb.inventorySystem then
        if GetResourceState('mf-inventory') == 'started' then
            local identifier = wsb.awaitServerCallback('wasabi_police:getIdentifier', GetPlayerServerId(player))
            exports['mf-inventory']:openOtherInventory(identifier)
        elseif GetResourceState('inventory') == 'started' then --Chezza using inventory as their folder name
            TriggerEvent('inventory:openPlayerInventory', GetPlayerServerId(player), true)
        else
            print('NO INVENTORY FOUND CONFIG YOUR INV IN CL_CUSTOMIZE.LUA')
        end
    else
        wsb.inventory.openPlayerInventory(GetPlayerServerId(player))
    end
end

exports('searchPlayer', searchPlayer)

DisableInventory = function(bool) -- Disable inventory when cuffed, enable when released
    if wsb.inventorySystem ~= 'qs-inventory' then return end
    exports['qs-inventory']:setInventoryDisabled(bool)
end

--Change clothes(Cloakroom)
AddEventHandler('wasabi_police:changeClothes', function(data)
    local gender = wsb.getGender()
    if not gender or gender == 0 or gender == 'm' then gender = 'male' end
    if gender == 'f' or gender == 1 then gender = 'female' end
    if data == 'civ_wear' then
        RemoveClothingProps()
        RequestCivilianOutfit()
        return
    end
    if type(data) ~= 'table' then return end
    SaveCivilianOutfit()
    RemoveClothingProps()
    if data[gender] and data[gender].clothing and next(data[gender].clothing) then
        for _, clothing in pairs(data[gender].clothing) do
            SetPedComponentVariation(wsb.cache.ped, clothing.component, clothing.drawable, clothing.texture, 0)
        end
    end
    if data[gender] and data[gender].props and next(data[gender].props) then
        for _, prop in pairs(data[gender].props) do
            SetPedPropIndex(wsb.cache.ped, prop.component, prop.drawable, prop.texture, true)
        end
    end
end)
local currentCallback = nil
-- Registere den NUI-Callback nur einmal außerhalb der GetMugShotBase64-Funktion
RegisterNUICallback('receiveBase64', function(data, cb)
    print("receiveBase64 Client")
    if data.base64Image and currentCallback then
        currentCallback(data.base64Image)
        currentCallback = nil -- Setze den Callback zurück
    end
    cb('ok')
end)

-- Lokale Variable für den aktuellen Callback


local function GetMugShotBase64(targetId, callback)
    local ped = GetPlayerPed(GetPlayerFromServerId(targetId))

    if not DoesEntityExist(ped) then
        print("Fehler: Das Ziel-Ped existiert nicht.")
        return
    end

    print("Starte Mugshot-Erstellung für Target ID:", targetId)

    -- Temporär Maske entfernen, falls vorhanden
    local oldMask = GetPedDrawableVariation(ped, 1)
    local hasMask = oldMask ~= 0
    if hasMask then
        SetPedComponentVariation(ped, 1, 0, 0, 2) -- Maske entfernen
    end

    -- Mugshot erstellen
    local headShotHandle = RegisterPedheadshotTransparent(ped)
    if not IsPedheadshotValid(headShotHandle) then
        headShotHandle = RegisterPedheadshot(ped)
    end

    local attempts = 0
    while not IsPedheadshotReady(headShotHandle) and attempts < 50 do
        Citizen.Wait(100)
        attempts = attempts + 1
    end

    if IsPedheadshotReady(headShotHandle) and IsPedheadshotValid(headShotHandle) then
        local mugshotTxd = GetPedheadshotTxdString(headShotHandle)
        print("Mugshot TXD:", mugshotTxd)

        -- Speichere den aktuellen Callback, damit er im NUI-Callback aufgerufen wird
        currentCallback = callback

        -- Sende die TXD an NUI für die Konvertierung in Base64
        SendNUIMessage({
            action = "convertToBase64",
            txd = mugshotTxd
        })

        -- Mugshot freigeben
        UnregisterPedheadshot(headShotHandle)
    else
        print("Mugshot konnte nicht erstellt werden.")
        callback(nil)
    end

    if hasMask then
        SetPedComponentVariation(ped, 1, oldMask, GetPedTextureVariation(ped, 1), 2) -- Maske wiederherstellen
    end
end


AddEventHandler('wasabi_police:finePlayer', function()
    print("wasabi_police:finePlayer Event Triggered")

    if not wsb.hasGroup(Config.policeJobs) then return end
    local hasJob, _grade = wsb.getGroup()
    local coords = GetEntityCoords(wsb.cache.ped)
    local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
    local targetId = GetPlayerServerId(player)

    if not player then
        TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        return
    end

    -- Erstelle eine Liste der verfügbaren Strafgründe mit den Beträgen für das Dropdown
    local fineOptions = {}
    for i, fine in ipairs(Config.billingData.fines) do
        fineOptions[#fineOptions + 1] = {
            value = i,
            label = fine.label .. " - $" .. fine.amount  -- Anzeige der Strafe mit dem Betrag
        }
    end

    local input = lib.inputDialog('Wähle die Strafe aus', {
        {
            type = 'select',
            label = 'Strafgrund',
            options = fineOptions -- Übergebe die Strafoptionen für das Dropdown
        }
    })
    
    print("Input result: " .. tostring(input[1]))
    

    if not input or not input[1] then return end -- Wenn keine Auswahl getroffen wurde, abbrechen

    local fineIndex = tonumber(input[1]) -- Index der ausgewählten Strafe
    local selectedFineData = Config.billingData.fines[fineIndex]
    local amount = selectedFineData.amount
    local fineReason = selectedFineData.label

    -- Logik für die verschiedenen Billing-Systeme
    local jobLabel = wsb.playerData.job.label
    if Config.billingSystem == 'okok' then
        TriggerEvent('okokBilling:ToggleCreateInvoice')
    else
        -- Abwicklung der Strafe basierend auf dem Billing-System
        if Config.billingSystem == 'pefcl' then
            TriggerServerEvent('wasabi_police:billPlayer', targetId, wsb.playerData.job, amount)
            GetMugShotBase64(targetId)
            TriggerServerEvent('wasabi_police:storeFine', targetId, amount, fineReason)

        elseif Config.billingSystem == 'qb' then
            TriggerServerEvent('wasabi_police:qbBill', targetId, amount, wsb.playerData.job.name)
            local gender = Strings.mr
            if wsb.playerData.charinfo.gender == 1 then
                gender = Strings.mrs
            end
            local charinfo = wsb.playerData.charinfo
            TriggerServerEvent('wasabi_police:sendQBEmail', targetId, {
                sender = wsb.playerData.job.label,
                subject = Strings.debt_collection,
                message = (Strings.db_email):format(gender, charinfo.lastname, amount),
                button = {}
            })
         --   TriggerServerEvent('wasabi_police:storeFine', targetId, amount, fineReason)

        elseif Config.billingSystem == 'esx' then
            -- Erzeuge das Mugshot und speichere dann die Strafe
            GetMugShotBase64(targetId, function(base64Image)
                if base64Image then
                    -- Mugshot erfolgreich generiert, Strafe und Bild speichern
                    print("Sending fine to server with amount: " .. amount .. " and reason: " .. fineReason)

                    TriggerServerEvent('wasabi_police:storeFine', targetId, amount, fineReason, base64Image)
                    -- Rechnung senden
                    TriggerServerEvent('esx_billing:sendBill', targetId, 'society_' .. hasJob, jobLabel, amount)
                else
                    print("Fehler: Mugshot konnte nicht erstellt werden.")
                    -- Optional: Strafe auch ohne Mugshot speichern und Rechnung senden
                    TriggerServerEvent('esx_billing:sendBill', targetId, 'society_' .. hasJob, jobLabel, amount)
                    TriggerServerEvent('wasabi_police:storeFine', targetId, amount, fineReason, nil)
                end
            end)
        
        elseif Config.billingSystem == 'default' then
            FineSuspect(targetId)
            TriggerServerEvent('wasabi_police:storeFine', targetId, amount, fineReason)
        else
            -- Fallback für nicht unterstützte Billing-Systeme
            print('^0[^3WARNING^0] No proper billing system selected in configuration!')
        end
    end
end)

local tablet = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

function ToggleTablet(toggle)
    if toggle and not tablet then
        tablet = true

        Citizen.CreateThread(function()
            RequestAnimDict(tabletDict)

            while not HasAnimDictLoaded(tabletDict) do
                Citizen.Wait(150)
            end

            RequestModel(tabletProp)

            while not HasModelLoaded(tabletProp) do
                Citizen.Wait(150)
            end

            local playerPed = PlayerPedId()
            local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
            local tabletBoneIndex = GetPedBoneIndex(playerPed, tabletBone)

            SetCurrentPedWeapon(playerPed, `weapon_unarmed`, true)
            AttachEntityToEntity(tabletObj, playerPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
            SetModelAsNoLongerNeeded(tabletProp)

            while tablet do
                Citizen.Wait(100)
                playerPed = PlayerPedId()

                if not IsEntityPlayingAnim(playerPed, tabletDict, tabletAnim, 3) then
                    TaskPlayAnim(playerPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
                end
            end

            ClearPedSecondaryTask(playerPed)

            Citizen.Wait(450)

            DetachEntity(tabletObj, true, false)
            DeleteEntity(tabletObj)
        end)
    elseif not toggle and tablet then
        tablet = false
    end
end

function ShowPlayerFinesAkte(fines, fullName, personalInfo, mugshotBase64)
    ToggleTablet(true)
    Citizen.Wait(500)
    -- Überprüfen der persönlichen Informationen
    if not personalInfo or not personalInfo.name then
        personalInfo = {name = "Unbekannt", birthdate = "Unbekannt", job = "Unbekannt"}
    end

    -- Fallback für das Mugshot-Bild
    local mugshotImage = mugshotBase64 and #mugshotBase64 > 0 and mugshotBase64 or 'https://via.placeholder.com/120x160.png'

    -- Sende die Informationen an die NUI (HTML)
    SendNuiMessage(json.encode({
        type = "setPlayerFines",
        fines = json.encode(fines),
        personalInfo = personalInfo,
        mugshotBase64 = mugshotImage
    }))

    -- Aktiviere den NUI-Fokus
    SetNuiFocus(true, true)
end


RegisterNetEvent('wasabi_police:showPlayerFines')
AddEventHandler('wasabi_police:showPlayerFines', function(fines, fullName, personalInfo, mugshotBase64)

    -- Rufe die Funktion auf, um die Informationen in der NUI anzuzeigen
    ShowPlayerFinesAkte(fines, fullName, personalInfo, mugshotBase64)
end)


-- Funktion zum Schließen der Akte
RegisterNUICallback('closeAkte', function()
    ClosePlayerFinesAkte()
end)

-- Funktion zum Schließen der Akte
function ClosePlayerFinesAkte()
    -- Entferne den Fokus von der NUI
    SetNuiFocus(false, false)
    
    -- Sende Nachricht an die NUI, um die Akte zu schließen
    SendNuiMessage(json.encode({
        type = "closeAkte"
    }))
    ToggleTablet(false)
end

-- Überwache, ob die Escape-Taste gedrückt wird (wenn nicht im NUI)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        -- Escape-Taste ist Control ID 322 für GTA 5
        if IsControlJustPressed(0, 322) then -- Escape-Taste (ID 322)
            ClosePlayerFinesAkte() -- Schließe die Akte
        end
    end
end)


-- Event-Handler für Akten Einsicht
RegisterNetEvent('wasabi_police:viewFiles')
AddEventHandler('wasabi_police:viewFiles', function()
    local coords = GetEntityCoords(wsb.cache.ped)
    local player = wsb.getClosestPlayer(vec3(coords.x, coords.y, coords.z), 2.0, false)
    local targetId = GetPlayerServerId(player)

    if not player then
        TriggerEvent('wasabi_bridge:notify', Strings.no_nearby, Strings.no_nearby_desc, 'error')
        return
    end

    -- Trigger das Server-Event, um Verstöße zu holen
    TriggerServerEvent('wasabi_police:fetchPlayerFines', targetId)
end)

-- Job menu
openJobMenu = function()
    local job, grade = wsb.hasGroup(Config.policeJobs)
    if not job or not grade then return end
    if not wsb.isOnDuty() then return end
    local jobLabel = Strings.police
    local Options = {}
    if Config.searchPlayers then
        Options[#Options + 1] = {
            title = Strings.search_player,
            description = Strings.search_player_desc,
            icon = 'magnifying-glass',
            arrow = false,
            event = 'wasabi_police:searchPlayer',
        }
    end
    if Config.seizeCash.enabled then
        Options[#Options + 1] = {
            title = Strings.seize_cash_title,
            description = Strings.seize_cash_label,
            icon = 'fa-sack-dollar',
            arrow = false,
            event = 'wasabi_police:seizeCash',
        }
    end
    Options[#Options + 1] = {
        title = Strings.check_id,
        description = Strings.check_id_desc,
        icon = 'id-card',
        arrow = true,
        event = 'wasabi_police:checkId',
    }
    if Config?.GrantWeaponLicenses?.enabled and tonumber(grade or 0) >= Config.GrantWeaponLicenses.minGrade then
        Options[#Options + 1] = {
            title = Strings.grant_license,
            description = Strings.grant_license_desc,
            icon = 'id-card',
            arrow = true,
            event = 'wasabi_police:grantLicense',
        }
    end
    if Config.Jail.enabled then
        Options[#Options + 1] = {
            title = Strings.jail_player,
            description = Strings.jail_player_desc,
            icon = 'lock',
            arrow = false,
            event = 'wasabi_police:sendToJail',
        }
    end
-- Menü Option für Akten Einsicht
Options[#Options + 1] = {
    title = 'Akten Einsicht', 
    description = 'Einsicht in die Akten nehmen', 
    icon = 'folder-open', 
    arrow = false, 
    event = 'wasabi_police:viewFiles' -- Anstelle einer Funktion rufen wir nun das Client-Event auf
}
    Options[#Options + 1] = {
        title = Strings.handcuff_soft_player,
        description = Strings.handcuff_soft_player_desc,
        icon = 'hands-bound',
        arrow = false,
        args = { type = 'soft' },
        event = 'wasabi_police:handcuffPlayer',
    }
    Options[#Options + 1] = {
        title = Strings.handcuff_hard_player,
        description = Strings.handcuff_hard_player_desc,
        icon = 'hands-bound',
        arrow = false,
        args = { type = 'hard' },
        event = 'wasabi_police:handcuffPlayer',
    }
    Options[#Options + 1] = {
        title = Strings.escort_player,
        description = Strings.escort_player_desc,
        icon = 'hand-holding-hand',
        arrow = false,
        event = 'wasabi_police:escortPlayer',
    }
    if Config.GSR.enabled then
        Options[#Options + 1] = {
            title = Strings.gsr_test,
            description = Strings.gsr_test_desc,
            icon = 'gun',
            arrow = false,
            event = 'wasabi_police:gsrTest',
        }
    end
    Options[#Options + 1] = {
        title = Strings.put_in_vehicle,
        description = Strings.put_in_vehicle_desc,
        icon = 'arrow-right-to-bracket',
        arrow = false,
        event = 'wasabi_police:inVehiclePlayer',
    }
    Options[#Options + 1] = {
        title = Strings.take_out_vehicle,
        description = Strings.take_out_vehicle_desc,
        icon = 'arrow-right-from-bracket',
        arrow = false,
        event = 'wasabi_police:outVehiclePlayer',
    }
    Options[#Options + 1] = {
        title = Strings.vehicle_interactions,
        description = Strings.vehicle_interactions_desc,
        icon = 'car',
        arrow = true,
        event = 'wasabi_police:vehicleInteractions',
    }
    if Config.RadarPosts and Config.RadarPosts.enabled and Config.RadarPosts.jobs[job] and tonumber(grade or 0) >= Config.RadarPosts.jobs[job] then
        Options[#Options + 1] = {
            title = Strings.menu_radar_posts,
            description = Strings.menu_radar_posts_desc,
            icon = 'gauge-high',
            arrow = true,
            event = 'wasabi_police:radarPosts',
        }
    end
    Options[#Options + 1] = {
        title = Strings.place_object,
        description = Strings.place_object_desc,
        icon = 'box',
        arrow = true,
        event = 'wasabi_police:placeObjects',
    }
    if Config.billingSystem then
        Options[#Options + 1] = {
            title = Strings.fines,
            description = Strings.fines_desc,
            icon = 'file-invoice',
            arrow = false,
            event = 'wasabi_police:finePlayer',
        }
    end

    if Config.MobileMenu.enabled then
        wsb.showMenu({
            id = 'pd_job_menu',
            color = Config.UIColor,
            title = jobLabel,
            position = Config.MobileMenu.position,
            options = Options
        })
        return
    end

    wsb.showContextMenu({
        id = 'pd_job_menu',
        color = Config.UIColor,
        title = jobLabel,
        options = Options

    })
end
