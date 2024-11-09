-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

ESX = exports['es_extended']:getSharedObject()
if not wsb then return print((Strings.no_wsb):format(GetCurrentResourceName())) end

-- Customize the way it pulls user identification info?
wsb.registerCallback('wasabi_police:checkPlayerId', function(source, cb, target)
    local data = wsb.getPlayerIdentity(target)
    cb(data)
end)

-- Customize the way it deposits LEO fines, etc
function PaySociety(accountName, amount)
    if wsb.framework == 'qb' then
        local management = Config.OldQBManagement and 'qb-management' or 'qb-banking'
        exports[management]:AddMoney(accountName, amount)
        return
    end
    -- If not QB, assume esx
    TriggerEvent('esx_addonaccount:getSharedAccount', accountName, function(account)
        if account then
            account.addMoney(amount)
            return
        end
        -- if account doesn't exist, try adding society_ prefix
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..accountName, function(societyAccount)
            if not societyAccount then
                print(Strings.no_society_account:format(accountName))
                return
            end
            societyAccount.addMoney(amount)
        end)
    end)
end

--Death check
deathCheck = function(serverId)
    local player = wsb.getPlayer(serverId)
    if not player then return end
    local state = Player(serverId).state
    return state.dead or
        state.isDead or
        player?.PlayerData?.metadata?['isdead'] or
        false
end

wsb.registerCallback('wasabi_police:revokeLicense', function(source, cb, id, license)
    if not wsb.hasLicense(id, license) then return cb(false) end
    wsb.revokeLicense(id, license)
    cb(true)
end)

if wsb.framework == 'qb' then
    wsb.registerCallback('wasabi_police:isPlayerDead', function(source, cb, id)
        local player = wsb.getPlayer(id)
        if not player then
            cb(false)
            return
        end
        cb(player.PlayerData.metadata['isdead'])
    end)
end

if wsb.framework == 'esx' then
    CreateThread(function()
        for i = 1, #Config.policeJobs do
            TriggerEvent('esx_society:registerSociety', Config.policeJobs[i], Config.policeJobs[i],
                'society_' .. Config.policeJobs[i], 'society_' .. Config.policeJobs[i], 'society_' ..
                Config.policeJobs[i], { type = 'public' })
        end
    end)
end

wsb.registerCallback('wasabi_police:getIdentifier', function(source, cb, target)
    if not wsb.getPlayer(target) then return cb(false) end
    cb(wsb.getIdentifier(target))
end)

RegisterServerEvent('wasabi_police:storeFine')
AddEventHandler('wasabi_police:storeFine', function(targetId, fineAmount, description, base64Image)
    local officerId = source
    local xPlayer = ESX.GetPlayerFromId(targetId)
    local officerPlayer = ESX.GetPlayerFromId(officerId)

    -- Überprüfen, ob sowohl der Spieler als auch der Officer existieren
    if xPlayer and officerPlayer then
        -- Hole die Character-IDs von Spieler und Officer
        local targetCharId = xPlayer.getIdentifier() -- Charakter-ID des Zielspielers
        local officerCharId = officerPlayer.getIdentifier()

        -- Prüfen, ob das Mugshot bereits für diesen Charakter existiert
        MySQL.Async.fetchScalar('SELECT mugshot_base64 FROM player_mugshots WHERE char_identifier = @char_identifier', {
            ['@char_identifier'] = targetCharId
        }, function(existingMugshot)
            if not existingMugshot and base64Image and #base64Image > 0 then
                -- Wenn das Mugshot noch nicht existiert und ein Bild übergeben wurde, speichere es in der neuen Tabelle
                MySQL.Async.execute('INSERT INTO player_mugshots (char_identifier, mugshot_base64) VALUES (@char_identifier, @mugshot_base64)', {
                    ['@char_identifier'] = targetCharId,
                    ['@mugshot_base64'] = base64Image
                }, function(rowsInserted)
                    if rowsInserted > 0 then
                        print('Mugshot für Spieler ' .. targetCharId .. ' erfolgreich gespeichert.')
                    end
                end)
            end

            -- Bußgeld in der player_fines Tabelle speichern
            MySQL.Async.execute('INSERT INTO player_fines (player_id, officer_id, fine_amount, description) VALUES (@player_id, @officer_id, @fine_amount, @description)', {
                ['@player_id'] = targetCharId,
                ['@officer_id'] = officerCharId,
                ['@fine_amount'] = fineAmount,
                ['@description'] = description
            }, function(rowsChanged)
                if rowsChanged > 0 then
                    TriggerClientEvent('wasabi_bridge:notify', officerId, 'Bußgeld erfolgreich ausgestellt.', 'Der Spieler wurde mit einem Bußgeld belegt.', 'success')
                else
                    TriggerClientEvent('wasabi_bridge:notify', officerId, 'Fehler beim Ausstellen des Bußgelds.', 'Das Bußgeld konnte nicht in der Datenbank gespeichert werden.', 'error')
                end
            end)
        end)
    else
        TriggerClientEvent('wasabi_bridge:notify', officerId, 'Spieler oder Officer nicht gefunden.', 'Entweder der Spieler oder der Officer konnten nicht gefunden werden.', 'error')
    end
end)


local function formatUnixTimestamp(unixTimestamp)
    return os.date('%d.%m.%Y %H:%M:%S', unixTimestamp)
end

-- Funktion zum Vergleich von zwei Timestamps mit einem Zeitfenster
local function isTimestampClose(fineTimestamp, billTimestamp, allowedDiffInSeconds)
    -- Berechne die Differenz in Sekunden
    local diff = math.abs(fineTimestamp - billTimestamp)
    return diff <= allowedDiffInSeconds
end

RegisterServerEvent('wasabi_police:fetchPlayerFines')
AddEventHandler('wasabi_police:fetchPlayerFines', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    local src = source
    print("Nehme Akteneinsicht für Spieler mit targetId:", targetId)

    if xPlayer then
        -- Holen der Character-ID
        local targetCharId = xPlayer.getIdentifier()
        print("Character ID für Spieler:", targetCharId)

        -- Sicherstellen, dass die Character-ID nicht leer ist
        if not targetCharId then
            print("Character-ID nicht gefunden für targetId:", targetId)
            TriggerClientEvent('wasabi_bridge:notify', src, 'Character-ID nicht gefunden', 'Die Character-ID konnte nicht ermittelt werden.', 'error')
            return
        end

        print("SQL-Abfrage wird ausgeführt mit player_id:", targetCharId)

        -- Führe die Abfrage für die Benutzerinformationen durch
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, job FROM users WHERE identifier = @identifier', {
            ['@identifier'] = targetCharId
        }, function(playerInfo)
            if not playerInfo or #playerInfo == 0 then
                print("Keine Benutzerinformationen gefunden für player_id:", targetCharId)
                TriggerClientEvent('wasabi_bridge:notify', src, 'Keine Benutzerinformationen gefunden', 'Die Benutzerinformationen konnten nicht abgerufen werden.', 'error')
                return
            end

            -- Debug-Ausgabe: Anzeigen der abgerufenen Benutzerinformationen
            print("Benutzerinformationen:", playerInfo[1].firstname, playerInfo[1].lastname, playerInfo[1].dateofbirth, playerInfo[1].job)

            -- Führe die Bußgeldabfragen durch
            MySQL.Async.fetchAll('SELECT fine_amount, UNIX_TIMESTAMP(fine_date) AS fine_timestamp, description FROM player_fines WHERE player_id = @player_id', {
                ['@player_id'] = targetCharId
            }, function(fines)
                if not fines or #fines == 0 then
                    print("Keine Verstöße gefunden für player_id:", targetCharId)
                    TriggerClientEvent('wasabi_bridge:notify', src, 'Keine Verstöße', 'Dieser Spieler hat keine Verstöße.', 'info')
                    return
                end

                -- Unbezahlte Bußgelder aus der billing-Tabelle abfragen
                MySQL.Async.fetchAll('SELECT amount, label, reason, invoice_type, UNIX_TIMESTAMP(created_at) AS bill_timestamp FROM billing WHERE identifier = @identifier', {
                    ['@identifier'] = targetCharId
                }, function(bills)
                    -- Vergleich der fines mit den bills
                 -- Vergleich der fines mit den bills
for i, fine in ipairs(fines) do
    fine.fine_date = formatUnixTimestamp(fine.fine_timestamp)  -- Formatierung des Timestamps zu einem lesbaren Datum
    fine.paid = true -- Standardmäßig annehmen, dass die Strafe bezahlt wurde

    print(string.format("Überprüfe Strafe %d: Betrag = %d, Timestamp = %d", i, fine.fine_amount, fine.fine_timestamp))

    -- Vergleiche fines mit unbezahlten bills
    for _, bill in ipairs(bills) do
        print(string.format("Vergleiche mit Rechnung: Betrag = %d, Timestamp = %d", bill.amount, bill.bill_timestamp))

        if bill.amount == fine.fine_amount and bill.label == "LSPD" then
            -- Die Toleranz von 10 Sekunden für den Vergleich der Timestamps verwenden
            if isTimestampClose(fine.fine_timestamp, bill.bill_timestamp, 10) then
                print(string.format("Unbezahlte Strafe gefunden: Fine Timestamp = %d, Bill Timestamp = %d", fine.fine_timestamp, bill.bill_timestamp))
                fine.paid = false -- Falls Betrag und Timestamp nahe genug sind, ist die Strafe nicht bezahlt
                break
            else
                print(string.format("Timestamps zu unterschiedlich: Fine Timestamp = %d, Bill Timestamp = %d", fine.fine_timestamp, bill.bill_timestamp))
            end
        else
            print(string.format("Betrag oder Rechnungstyp stimmen nicht überein: Fine Amount = %d, Bill Amount = %d, Bill Invoice Type = %s", fine.fine_amount, bill.amount, bill.invoice_type))
        end
    end

    -- Debug-Ausgabe, ob die Strafe als bezahlt oder nicht bezahlt angesehen wird
    if fine.paid then
        print(string.format("Strafe %d als bezahlt angesehen.", i))
    else
        print(string.format("Strafe %d als nicht bezahlt angesehen.", i))
    end
end


                    -- Mugshot aus der neuen player_mugshots-Tabelle abrufen
                    MySQL.Async.fetchScalar('SELECT mugshot_base64 FROM player_mugshots WHERE char_identifier = @char_identifier', {
                        ['@char_identifier'] = targetCharId
                    }, function(mugshotBase64)
                        if not mugshotBase64 then
                            mugshotBase64 = '' -- Fallback, wenn kein Mugshot vorhanden ist
                        end

                        -- Debug-Ausgabe für jede Strafe
                        for i, fine in ipairs(fines) do
                            if fine.paid then
                                print(string.format("Verstoß %d: Betrag = %d, bezahlt", i, fine.fine_amount))
                            else
                                print(string.format("Verstoß %d: Betrag = %d, nicht bezahlt", i, fine.fine_amount))
                            end
                        end

                        -- Benutzerinformationen für den Client aufbereiten
                        local fullName = playerInfo[1].firstname .. " " .. playerInfo[1].lastname
                        local birthdate = playerInfo[1].dateofbirth
                        local job = playerInfo[1].job

                        -- Sende die Verstöße, die persönlichen Informationen und das Mugshot an den Client
                        print("Sende Verstöße, Informationen und Mugshot an den Client für Spieler:", fullName)

                        local personalInfo = {
                            name = fullName,
                            birthdate = birthdate,
                            job = job
                        }

                        -- TriggerEvent an den Client mit MugshotBase64
                        TriggerClientEvent('wasabi_police:showPlayerFines', src, fines, fullName, personalInfo, mugshotBase64)
                    end)
                end)
            end)
        end)
    else
        print("Spieler nicht gefunden mit targetId:", targetId)
        TriggerClientEvent('wasabi_bridge:notify', src, 'Spieler nicht gefunden', 'Dieser Spieler konnte nicht gefunden werden.', 'error')
    end
end)












