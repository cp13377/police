-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
local seconds, minutes = 1000, 60000
Config = {}

-------------------------------------------------------------------
-- TO MODIFY NOTIFICATIONS TO YOUR OWN CUSTOM NOTIFICATIONS:-------
-------------- Navigate to wasabi_bridge/customize/ ---------------
-------------------------------------------------------------------
Config.CheckForUpdates = true -- Check for updates? Who would not want to know updates!?

-- Language Options are
-- 'en' (English)
-- 'fr' (French)
-- 'cn' (Chinese Simplified)
-- 'tw' (Chinese Traditional)
-- 'de' (German)
-- 'it' (Italian)
-- 'jp' (Japanese)
-- 'ko' (Korean)
-- 'pl' (Polish)
-- 'pt' (Portuguese)
-- 'es' (Spanish)
-- 'hi' (Hindi)
-- 'nl' (Dutch)
-- 'da' (Danish)
-- 'cs' (Czech)
-- If you would like us to add a language, join our discord and create a ticket!
-- All locale strings can be found in /game/configuration/locales/
Config.Language = 'de'
Config.UIColor = '#0390fc'   -- Can be 'red', 'blue', or a hex '#FF0000'

Config.jobMenu = 'F6'        -- Default job menu key
Config.useTarget = true      -- Enable target for police functions (Supports ox_target / qb-target)
Config.MobileMenu = {        -- THIS WILL USE A REGULAR MENU RATHER THAN A CONTEXT STYLE MENU!
    enabled = false,         -- Use a mobile menu rather than context? (Use arrow keys to navigate menu rather than mouse)
    position =
    'bottom-right'           -- Choose where menu is positioned. Options : 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
}
Config.UseRadialMenu = false -- Enable use of radial menu built in to ox_lib? (REQUIRES OX_LIB - Editable in client/radial.lua)

Config.customCarlock = false -- If you use wasabi_carlock OR qb-carlock set to true(Add your own carlock system in wasabi_bridge/customize/client/carlock.lua)
Config.billingSystem =
'esx'                    -- Current options: false (Disabled) / 'default' (For built-in System)/'esx' (For esx_billing) / 'qb' (QBCore) / 'okok' (For okokBilling) (Easy to add more/fully customize in client/cl_customize.lua)

--ONLY IF USING 'default' BILLING SYSTEM
Config.billingData = {
    chargeAccount = 'bank', --Cash or bank (The default method to charge player)

    -- Credit police society for fines?
    -- (If true, fines will be credited to whichever police job sent the fine)
    -- (If false, fines will be deducted from the player but credited to no where)
    -- (Set to string of specific account if you wish for a singular account to receive all fine recoveries)
    creditSociety = true,

    fines = { --Fine presets
    { label = 'Körperverletzung, 10 HE', amount = 15000 },
    { label = 'Schwere Körperverletzung, 15 HE', amount = 25000 },
    { label = 'Versuchter Mord, max. 30 HE', amount = 40000 },
    { label = 'Mord, max. 80 HE', amount = 80000 },
    { label = 'Gefährliche Körperverletzung, 20 HE', amount = 20000 },
    { label = 'Freiheitsberaubung/Entführung, max. 20 HE', amount = 30000 },
    { label = 'Erpressung, max. 10 HE', amount = 10000 },
    { label = 'Beleidigung', amount = 10000 },
    { label = 'Üble Nachrede, max. 20 HE', amount = 10000 },
    { label = 'Drohung', amount = 15000 },
    { label = 'Morddrohung, max. 10 HE', amount = 20000 },
    { label = 'Geiselnahme, max. 60 HE', amount = 60000 },
    { label = 'Hausordnungsverstoß, max. 25 HE', amount = 4000 },
    { label = 'Verleumdung, max. 10 HE', amount = 15000 },
    { label = 'Falsche Verdächtigung, max. 20 HE', amount = 50000 },
    { label = 'Nötigung', amount = 30000 },
    { label = 'Versuchter Diebstahl, max. 10 HE', amount = 10000 },
    { label = 'Diebstahl, max. 15 HE', amount = 20000 },
    { label = 'Versuchter Raub, max. 20 HE', amount = 20000 },
    { label = 'Raub, max. 25 HE', amount = 30000 },
    { label = 'Sachbeschädigung', amount = 20000 },
    { label = 'Schwarzgeldbesitz, max. 25 HE', amount = 30000 },
    { label = 'Vermummungsverbot', amount = 10000 },
    { label = 'Vortäuschen einer Straftat', amount = 40000 },
    { label = 'Falschaussage', amount = 25000 },
    { label = 'Meineid, max. 60 HE', amount = 100000 },
    { label = 'Auflagenverstoß, max. 5 HE', amount = 15000 },
    { label = 'Belästigung', amount = 20000 },
    { label = 'Betrug', amount = 50000 },
    { label = 'Erschleichen von Leistungen', amount = 50000 },
    { label = 'Volksverhetzung', amount = 20000 },
    { label = 'Unterlassene Hilfeleistung', amount = 10000 },
    { label = 'Behinderung staatlicher Organe, max. 5 HE', amount = 20000 },
    { label = 'Widerstand gegen Staatsgewalt, max. 30 HE', amount = 30000 },
    { label = 'Entziehung polizeilicher Maßnahmen, max. 20 HE', amount = 15000 },
    { label = 'Angriffe gegen staatliche Organisationen, max. 45 HE', amount = 50000 },
    { label = 'Befreiung von Verdächtigen, max. 30 HE', amount = 20000 },
    { label = 'Ausbruchsdelikte, max. 60 HE', amount = 20000 },
    { label = 'Bestechung, max. 50 HE', amount = 25000 },
    { label = 'Korruption, max. 100 HE, Berufsverbot', amount = 200000 },
    { label = 'Amtsanmaßung, max. 60 HE', amount = 75000 },
    { label = 'Hausfriedensbruch, max. 10 HE', amount = 30000 },
    { label = 'Landfriedensbruch, max. 100 HE', amount = 150000 },
    { label = 'Identitätsverweigerung, max. 50 HE', amount = 25000 },
    { label = 'Nicht genehmigte Versammlung (Teilnahme)', amount = 10000 },
    { label = 'Nicht genehmigte Versammlung (Organisation)', amount = 40000 },
    { label = 'Umweltverschmutzung', amount = 25000 },
    { label = 'Öffentliches Ärgernis, max. 15 HE', amount = 45000 },
    { label = 'Betreten von Sperrzonen, max. 20 HE', amount = 35000 },
    { label = 'Urkundenfälschung, max. 50 HE', amount = 60000 },
    { label = 'Nachstellung, max. 10 HE', amount = 10000 },
    { label = 'Wucher', amount = 40000 },
    { label = 'Missbrauch von Notrufen, max. 10 HE', amount = 20000 },
    { label = 'Offenbarung von Staatsgeheimnissen, 80 HE', amount = 100000 },
    { label = 'Verletzung des höchstpersönlichen Lebensbereichs, max. 50 HE', amount = 50000 },
    { label = 'Strafvereitelung, max. 50 HE', amount = 30000 },
    { label = 'Beihilfe, max. 30 HE', amount = 30000 },
    { label = 'Fahren ohne Führerschein/Fahrzeugpapiere', amount = 5000 },
    { label = 'Führerschein ohne Fahrerlaubnis', amount = 5000 },
    { label = 'Fahrzeug ohne Versicherung', amount = 5000 },
    { label = 'Lärmbelästigung', amount = 5000 },
    { label = 'Fahren ohne ordnungsgemäßen Zustand', amount = 5000 },
    { label = 'Baufahrzeuge ohne Genehmigung', amount = 5000 },
    { label = 'Organisieren eines illegalen Straßenrennens, max. 15 HE', amount = 20000 },
    { label = 'Teilnehmen an illegalem Straßenrennen', amount = 10000 },
    { label = 'Fahren unter Drogeneinfluss, max. 10 HE', amount = 10000 },
    { label = 'Unerlaubtes Entfernen vom Unfallort, max. 5 HE', amount = 5000 },
    { label = 'Unerlaubtes Entfernen bei Personenschaden, max. 10 HE', amount = 10000 },
    { label = 'Unerlaubte Fahrzeugmodifikationen', amount = 10000 },
    { label = 'Fahren mit nicht zugelassenem Fahrzeug', amount = 5000 },
    { label = 'Fahren mit verkehrsuntauglichem Fahrzeug', amount = 5000 },
    { label = 'Fernlicht in der Stadt', amount = 2500 },
    { label = 'Parken auf Gehweg', amount = 2500 },
    { label = 'Handy während der Fahrt', amount = 5000 },
    { label = 'Aus-/Einsteigen auf der Straße', amount = 2500 },
    { label = 'Geschwindigkeitsüberschreitung', amount = 15000 },
    { label = 'Unzureichender Sicherheitsabstand', amount = 15000 },
    { label = 'Schwerer Eingriff in den Straßenverkehr', amount = 27500 },
    { label = 'Kein Platz bei Blaulicht/Einsatzhorn', amount = 30000 },
    { label = 'Illegale Kurzwaffen, max. 15 HE', amount = 25000 },
    { label = 'Illegale Langwaffen, max. 25 HE', amount = 40000 },
    { label = 'Mehrere Waffen ohne Waffenschein, max. 10 HE', amount = 15000 },
    { label = 'Staatswaffenbesitz, max. 25 HE', amount = 35000 },
    { label = 'Wurfwaffen, max. 15 HE', amount = 10000 },
    { label = 'Verkauf/Kauf illegaler Waffen, max. 25 HE', amount = 30000 },
    { label = 'Verkauf von Staatswaffen, max. 25 HE', amount = 20000 },
    { label = 'Ankauf illegaler Waffe, max. 20 HE', amount = 25000 },
    { label = 'Ankauf ohne Waffenschein, max. 15 HE', amount = 20000 },
    { label = 'Ankauf von Staatswaffen, härtestes Strafmaß', amount = 25000 },
    { label = 'Anbau von Betäubungsmitteln, max. 25 HE', amount = 40000 },
    { label = 'Herstellung von Betäubungsmitteln, max. 20 HE', amount = 40000 },
    { label = 'Besitz von Betäubungsmitteln, max. 15 HE', amount = 25000 },
    { label = 'Erwerb von Betäubungsmitteln, max. 15 HE', amount = 25000 },
    { label = 'Verkauf von Betäubungsmitteln, max. 20 HE (Verdoppelung bei schweren Fällen/Wiederholung möglich)', amount = 35000 },
    { label = 'Konsum von Betäubungsmitteln', amount = 10000 },                                    
    }
}

Config.OldQBManagement = false -- If you use older qb-management(Unrelated to ESX)

Config.AdvancedParking = 'jg' -- Delete vehicles with their exports(Script named advanced parking)

Config.Jail = {
    enabled = true, -- Enable jail feature?
    input = true,    -- Enable input? Some needs it
    jail = 'pickles',       -- Current options: 'qb' (For qb-prison) / 'rcore' (For rcore-prison) / 'tk_jail' (For tk_jail) / 'hd_jail' (For hd_jail) / 'myPrison' (For myPrison) / 'qalle-jail' (For qalle-jail) / 'plouffe ' (For Plouffe Jail) / 'mx' (For mxJail) / 'custom' (For custom)
}
-- NOTE: If using qb-prison, you must make one small change to qb-prison.
-- SEE https://docs.wasabiscripts.com/scripts/wasabi_police/customizations#qb-prison-integration

Config.searchPlayers = true     -- Allow police jobs to search players for items (Must have inventory in bridge or one already supported in cl_customize.lua - or add your own!)
Config.weaponsAsItems = true     -- (If you're unsure leave as true!)This is typically for older ESX and inventories that still use weapons as weapons and not items

Config.spikeStripsEnabled = true -- Enable functionality of spike strips (Disable if you use difference script for spike strips)

--[[ These resources can trigger:
    wasabi_police:handcuffPlayer
    wasabi_police:escortPlayer
    wasabi_police:inVehiclePlayer
    wasabi_police:outVehiclePlayer
]]
Config.AllowedResources = {
    'qb-core',
    'qb-radialmenu', -- For civilians to be able to use radial menu features(Already had compatibility without edit)
}

Config.AllowedJobs = { -- THIS HAS NOTHING TO DO with Config.policeJobs, only with triggering events above
    --'bloods'
}

Config.GrantWeaponLicenses = {
    enabled = true,          -- If you want police to have option to grant/revoke weapons licenses
    license_name = 'weapon', -- Name of license
    minGrade = 0,            -- Min grade to use this function
    menuPosition =
    'bottom-right'           -- Choose where menu of player select is positioned. Options : 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'
}

Config.RadarPosts = {           -- Radar posts for speed detection

    enabled = true,             -- Enable radar posts (Shows option in job menu for approved jobs)?
    saveToDatabase = true,      -- Save radar data to database? (If false, data will be stored in server memory/reset on server restarts)

    disableCameraFlash = false, -- Disable camera flash effect when player is caught speeding?

    measurement = 'kmh',        -- Measurement of speed (Options: 'mph' / 'kmh')

    jobs = {                    -- Jobs & minimum ranks that can add/modify/delete radar posts
        -- Must be in Config.policeJobs as well
        police = 0,             -- Job 'police' with minimum rank 0
        sheriff = 2,            -- Job 'sheriff' with minimum rank 2
    },

    whitelistJobs = { -- Jobs that do not get fined for speeding
        -- Do not worry about jobs from Config.policeJobs, they are automatically whitelisted
        'ambulance',

    },

    chargeAccount = 'bank',       -- Cash or bank (The default method to charge player
    allowNegativeBalance = false, -- Allow players to go into negative balance? (If false, player must have enough money to pay fine)

    -- Credit police society for fines?
    -- (If true, fines will be credited to whichever police job placed the radar post that detected speeding)
    -- (If false, fines will be deducted from the speeder but credited to no where)
    -- (Set to string of specific account if you wish for a singular account to receive all fine recoveries)
    creditSociety = true,

    thresholds = {   -- Speed thresholds for fines
        [5] = 50,    -- 5 over = $50 fine
        [10] = 100,  -- 10 over = $100 fine
        [20] = 500,  -- 20 over = $500 fine
        [30] = 1000, -- 30 over = $1000 fine
        [40] = 2000, -- 40 over = $2000 fine
        [50] = 5000, -- 50 over = $5000 fine
    },

    blip = {
        enabled = false,      -- Enable blips for radar posts?
        label = 'Radar Post', -- Blip label
        sprite = 184,         -- Blip sprite
        color = 5,            -- Blip color
        scale = 0.5,          -- Blip scale
        short = false,        -- Short range blip?
    },

    options = {
        {
            label = 'Radar Post #1',     -- Label of radar post
            prop = 'prop_cctv_pole_01a', -- Prop name
        },
        {
            label = 'Radar Post #2',
            prop = 'prop_cctv_pole_02',
        },
        {
            label = 'Radar Post #3',
            prop = 'prop_cctv_pole_03',
        },
        {
            label = 'Radar Post #4',
            prop = 'prop_cctv_pole_04',
        },
    }
}

Config.GSR = {                 -- Gunshot residue settings
    enabled = false,           -- Enabled?
    cleanInWater = true,       -- Can clean GSR while in water?
    timeToClean = 5 * seconds, -- How long to clean GSR in water if enabled
    autoClean = 600,           -- (IN SECONDS)How long before residue clears itself? Set to false if undesired to auto clean GSR
    command = 'gsr'            -- Command for testing for GSR? Set to false if undesired
}

Config.tackle = {
    enabled = true,    -- Enable tackle?
    policeOnly = true, -- Police jobs only use tackle?
    hotkey = 'G'       -- What key to press while sprinting to start tackle of target
}

Config.seizeCash = {  -- ONLY FOR QBCORE WITHOUT CASH AS ITEM
    enabled = false,  -- Enabled?
    item = 'moneybag' -- Item to add after seizedCash
}

Config.handcuff = {                             -- Config in regards to cuffing
    defaultCuff = 'hard',                       -- Default cuff type (Options: 'soft' / 'hard') Changing this will be the default hotkey cuff type
    persistentCuff = true,                      -- Verify player's cuffed status during login (Install '_EXTRA_ESX_INSTALL/ESX_PERSISTENT_CUFF.sql' if using ESX)
    timer = 20 * minutes,                       -- Time before player is automatically unrestrained(Set to false if not desired)
    hotkey = 'J',                               -- What key to press to handcuff people(Set to false for no hotkey)
    skilledEscape = {
        enabled = true,                         -- Allow criminal to simulate resisting by giving them a chance to break free from cuffs via skill check
        difficulty = { 'hard', 'hard', 'hard' } -- Options: 'easy' / 'medium' / 'hard' (Can be stringed along as they are in config)
    },
    cuffItem = {                                -- Have handcuffs as usable item? (ITEM NAME MUST BE IN ITEMS / YOU MUST ADD YOURSELF)
        enabled = false,                        -- Enable a handcuff usable item?? Must be in items table/database with name defined below
        required = true,                        -- Requires handcuff item to be in inventory when any handcuff function is used
        item = 'handcuffs'                      -- Item name (DONT FORGET to make sure its in your items)
    },
    lockpicking = {                             -- Lockpicking someone else out of handcuffs
        enabled = false,                        -- Enable handcuffs to be able to be lockpicked off(MUST HAVE LOCKPICK ITEM IN ITEMS)
        item = 'bobby_pin',
        breakChance = 50,                       -- Chance of lockpick breaking if failed (Set to 100 for 100% or 0 for never breaking)
        difficulty = { 'hard', 'hard', 'hard' } -- Options: 'easy' / 'medium' / 'hard' (Can be stringed along as they are in config)
    }
}

Config.policeJobs = { -- Police jobs
    'police',
    --    'sheriff'
    'reporter'
}

Config.GPSBlips = {
    enabled = true,     -- Enabled?
    item = true,        -- Item required? Note: You have to use it then
    sprites = {
        none = 1,        -- Blip for when not in a vehicle
        car = 56,        -- Blip for when in vehicles
        bike = 226,      -- Blip for when on bikes
        boat = 427,      -- Blip for when in boats
        helicopter = 43, -- Blip for when in helicopters
        plane = 307,     -- Blip for when in planes
    },
    settings = {
        color = 3,
        scale = 0.75,
        short = false,
        category = 7
    }
}

Config.Props = { -- What props are avaliable in the "Place Objects" section of the job menu

    {
        title = 'Barrier',             -- Label
        description = '',              -- Description (optional)
        model = `prop_barrier_work05`, -- Prop name within `
        freeze = true,                 -- Make prop unmovable
        groups = {                     -- ['job_name'] = min_rank
            ['police'] = 0,
            --            ['sheriff'] = 0,
        }
    },
    {
        title = 'Barricade',
        description = '',
        model = `prop_mp_barrier_01`,
        freeze = true, -- Make prop unmovable
        groups = {
            ['police'] = 0,
            --            ['sheriff'] = 0,
        }
    },
    {
        title = 'Traffic Cones',
        description = '',
        model = `prop_roadcone02a`,
        freeze = false, -- Make prop unmovable
        groups = {
            ['police'] = 0,
            --            ['sheriff'] = 0,
        }
    },
    {
        title = 'Spike Strip',
        description = '',
        model = `p_ld_stinger_s`,
        freeze = true, -- Make prop unmovable
        groups = {
            ['police'] = 0,
            --            ['sheriff'] = 0,
        }
    },

}

Config.Locations = {
    LSPD = {
        blip = {
            enabled = true,
            coords = vec3(464.57, -992.0, 30.69),
            sprite = 60,
            color = 29,
            scale = 1.0,
            string = 'Mission Row PD'
        },

        clockInAndOut = {
            enabled = true,                        -- Enable clocking in and out at a set location? (If using ESX you must have a off duty job for each e.x. offpolice for police offsheriff for sheriff AND have grades for each pd grade - QBCORE REQUIRES NOTHING)
            jobLock = 'police',                    -- This must be set to which job will be utilizing (ESX MUST HAVE OFF DUTY JOB / GRADES FOR THIS - ex. offpolice or offsheriff)
            coords = vec3(464.87, -977.37, 30.69), -- Location of where to go on and off duty(If not using target)
            label = '[E] - Go On/Off Duty',        -- Text to display(If not using target)
            distance = 3.0,                        -- Distance to display text UI(If not using target)
            target = {
                enabled = false,                   -- If enabled, the location and distance above will be obsolete
                label = 'Go On/Off Duty',
                coords = vec3(464.87, -977.37, 30.69),
                heading = 91.06,
                distance = 2.5,
                width = 2.0,
                length = 1.0,
                minZ = 30.69 - 0.9,
                maxZ = 30.69 + 0.9
            }
        },

        bossMenu = {
            enabled = false,                        -- Enable boss menu?
            jobLock = 'police',                    -- Lock to specific police job? Set to false if not desired
            coords = vec3(460.64, -985.64, 30.73), -- Location of boss menu (If not using target)
            label = '[E] - Access Boss Menu',      -- Text UI label string (If not using target)
            distance = 3.0,                        -- Distance to allow access/prompt with text UI (If not using target)
            target = {
                enabled = false,                   -- If enabled, the location and distance above will be obsolete
                label = 'Access Boss Menu',
                coords = vec3(460.64, -985.64, 30.73),
                heading = 269.85,
                distance = 2.0,
                width = 2.0,
                length = 1.0,
                minZ = 30.73 - 0.9,
                maxZ = 30.73 + 0.9
            }
        },

        armoury = {
            enabled = true,                                                                              -- Set to false if you don't want to use
            coords = vec3(480.32, -996.67, 30.69 - 0.9),                                                 -- Coords of armoury
            heading = 86.95,                                                                             -- Heading of armoury NPC
            ped = 's_f_y_cop_01',                                                                        -- Ped model or false for no ped
            label = '[E] - Access Armoury',                                                              -- String of text ui
            jobLock = 'police',                                                                          -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            weapons = {
                [0] = {                                                                                  -- Grade number will be the name of each table(this would be grade 0)
                    { name = 'WEAPON_PISTOL',     label = 'Pistol',      multiple = false, price = 75 }, -- Set price to false if undesired
                    { name = 'WEAPON_NIGHTSTICK', label = 'Night Stick', multiple = false, price = 50 },
                    { name = 'ammo-9' , label = '9mm Ammo', multiple = true, price = 10 }, -- Set multiple to true if you want ability to purchase more than one at a time
                    { name = 'armour', label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example

                },
                [1] = { -- This would be grade 1
                    { name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', multiple = false, price = 150 },
                    { name = 'WEAPON_NIGHTSTICK',   label = 'Night Stick',   multiple = false, price = 50 },
                    { name = 'ammo-9', label = '9mm Ammo', multiple = true, price = 10 }, -- Example
                    { name = 'armour', label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
                [2] = { -- This would be grade 2
                    { name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', multiple = false, price = 150 },
                    { name = 'WEAPON_STUNGUN', label = 'Tazer', multiple = false, price = 150 },
                    { name = 'WEAPON_NIGHTSTICK',   label = 'Night Stick',   multiple = false, price = 50 },
                    { name = 'WEAPON_ASSAULTRIFLE', label = 'Assault Rifle', multiple = false, price = 1100 },
                    { name = 'ammo-9', label = '9mm Ammo', multiple = true, price = 10 }, -- Set multiple to true if you want ability to purchase more than one at a time
                    { name = 'ammo-rifle2', label = '5.56 Ammo', multiple = true, price = 20 }, -- Example
                    { name = 'armour', label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
                [3] = { -- This would be grade 3
                    { name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', multiple = false, price = 150 },
                    { name = 'WEAPON_STUNGUN', label = 'Tazer', multiple = false, price = 150 },
                    { name = 'WEAPON_NIGHTSTICK',   label = 'Night Stick',   multiple = false, price = 50 },
                    { name = 'WEAPON_ASSAULTRIFLE', label = 'Assault Rifle', multiple = false, price = 1100 },
                    { name = 'ammo-9', label = '9mm Ammo', multiple = true, price = 10 }, -- Set multiple to true if you want ability to purchase more than one at a time
                    { name = 'ammo-rifle2', label = '5.56 Ammo', multiple = true, price = 20 }, -- Example
                    { name = 'armour', label = 'Bulletproof Vest', multiple = false, price = 100 }, -- Example
                },
            }
        },

        cloakroom = {
            enabled = true,                        -- WILL NOT SHOW IN QBCORE INSTEAD USE QB-CLOTHING CONFIG! Set to false if you don't want to use (Compatible with esx_skin & wasabi fivem-appearance fork)
            jobLock = 'police',                    -- Allow only one of Config.policeJob listings / Set to false if allow all Config.policeJobs
            coords = vec3(462.36, -999.62, 30.69), -- Coords of cloakroom
            label = '[E] - Change Clothes',        -- String of text ui of cloakroom
            range = 2.0,                           -- Range away from coords you can use.
            uniforms = {                           -- Uniform choices
                [1] = {                            -- Order it will display
                    label = 'Patrol',              -- Name of outfit that will display in menu
                    minGrade = 0,                  -- Min grade level that can access? Set to 0 or false for everyone to use
                    male = {                       -- Male variation
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 204,  texture = 0 }, -- Torso
                            { component = 8,  drawable = 83, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 136,  texture = 0 }, -- Pants
                            { component = 6,  drawable = 145, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 0,  texture = 0 }, -- Arms
                            { component = 9,  drawable = 23,  texture = 0 }, -- vest
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    },
                    female = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 195,  texture = 2 }, -- Torso
                            { component = 8,  drawable = 163, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 215, texture = 0 }, -- Pants
                            { component = 6,  drawable = 175, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 14,  texture = 0 }, -- Arms
                            { component = 9,  drawable = 50,  texture = 0 }, -- vest
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    }
                },
                [2] = {              -- Order it will display
                    label = 'Outfit Veste', -- Name of outfit that will display in menu
                    minGrade = 0,    -- Min grade level that can access? Set to 0 or false for everyone to use
                    male = {         -- Male variation
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C  DAS WAR ICH
                            { component = 8, drawable = 57, texture = 0 },-- tshirt
                            { component = 3, drawable = 41, texture = 0 }, -- Arme
                            { component = 10, drawable = 8, texture = 2 }, -- Badge
                            { component = 4, drawable = 10, texture = 0 }, --beine
                            { component = 6, drawable = 25, texture = 0 }, --schuhe
                            { component = 9, drawable = 2, texture = 0 }, --kevlar veste
                            { component = 11, drawable = 55, texture = 0 }, --Oberkörper
                            
                            
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                                { component = 6, drawable = 0, texture = 0 }, -- watch
                        }
                    },
                    female = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 4,  texture = 0 }, -- Torso
                            { component = 8,  drawable = 15, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 25, texture = 0 }, -- Pants
                            { component = 6,  drawable = 16, texture = 4 }, -- Shoes
                            { component = 3,  drawable = 4,  texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    }
                },
                [3] = {              -- Order it will display
                    label = 'Chief', -- Name of outfit that will display in menu
                    minGrade = 0,    -- Min grade level that can access? Set to 0 or false for everyone to use
                    male = {         -- Male variation
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 15, texture = 0 }, -- Torso
                            { component = 8,  drawable = 58, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 35, texture = 0 }, -- Pants
                            { component = 6,  drawable = 24, texture = 0 }, -- Shoes
                            { component = 3,  drawable = 15, texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    },
                    female = {
                        clothing = {
                            -- Components / 0: Face 1: Mask 2: Hair 3: Torso 4: Leg 5: Parachute / bag 6: Shoes 7: Accessory 8: Undershirt 9: Kevlar 10: Badge 11: Torso 2
                            -- https://docs.fivem.net/natives/?_0xD4F7B05C
                            { component = 11, drawable = 4,  texture = 0 }, -- Torso
                            { component = 8,  drawable = 15, texture = 0 }, -- Shirt
                            { component = 4,  drawable = 25, texture = 0 }, -- Pants
                            { component = 6,  drawable = 16, texture = 4 }, -- Shoes
                            { component = 3,  drawable = 4,  texture = 0 }, -- Arms
                        },
                        props = {
                            -- Components / 0: Hats 1: Glasses 2: Ears 6: Watches 7: Bracelets
                            -- https://docs.fivem.net/natives/?_0x93376B65A266EB5F

                            --    { component = 0, drawable = 0, texture = 0 }, -- Hats
                        }
                    }
                },
            }
        },

        -- Personal Locker. Supports inventories: ox_inventory, qb-inventory, and qs-inventory
        --        Custom inventories can easily be added in wasabi_bridge/inventories/
        personalLocker = {
            enabled = false,                       -- Enable personal locker for this station?
            jobLock = 'police',                    -- Job lock?
            coords = vec3(463.205627, -996.437927, 30.689518), -- Area to prompt personal locker
            range = 2.0,                           -- Range it will prompt from coords above
            label = '[E] - Access Personal Locker',
            target = {
                enabled = false, -- If enabled, the location above will be obsolete
                label = 'Access Personal Locker',
                coords = vec3(463.205627, -996.437927, 30.689518),
                heading = 354.94,
                distance = 2.5,
                width = 2.0,
                length = 1.0,
                minZ = 30.69 - 0.9,
                maxZ = 30.69 + 0.9
            }
        },

        evidenceLocker = {
            enabled = false,                      -- Enable evidence locker for this station?
            jobLock = 'police',                   -- Job lock?
            coords = vec3(472.5, -991.21, 26.27), -- Area to prompt personal locker
            range = 2.0,                          -- Range it will prompt from coords above
            label = '[E] - Access Evidence Locker',
            target = {
                enabled = false, -- If enabled, the location above will be obsolete
                label = 'Access Evidence Locker',
                coords = vec3(472.5, -991.21, 26.27),
                heading = 266.23,
                distance = 2.5,
                width = 2.0,
                length = 1.0,
                minZ = 26.27 - 0.9,
                maxZ = 26.27 + 0.9
            }
        },


        vehicles = {                                   -- Vehicle Garage
            enabled = false,                            -- Enable? False if you have you're own way for medics to obtain vehicles.
            jobLock = 'police',                        -- Job lock? or access to all police jobs by using false
            zone = {
                coords = vec3(463.69, -1019.72, 28.1), -- Area to prompt vehicle garage
                range = 5.5,                           -- Range it will prompt from coords above
                label = '[E] - Access Garage',
                return_label = '[E] - Return Vehicle'
            },
            spawn = {
                land = {
                    coords = vec3(449.37, -1025.46, 28.59), -- Coords of where land vehicle spawn/return
                    heading = 3.68
                },
                air = {
                    coords = vec3(449.29, -981.76, 43.69), -- Coords of where air vehicles spawn/return
                    heading = 0.01
                }
            },
            options = {

                [0] = {                    -- Job grade as table name
                    ['police'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = {        -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },

                [1] = {                    -- Job grade as table name
                    ['police'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = {        -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },

                [2] = {                    -- Job grade as table name
                    ['police'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = {        -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },

                [3] = {                    -- Job grade as table name
                    ['police'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['police2'] = {        -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Police Cruiser #2',
                        category = 'land', -- Options are 'land' and 'air'
                    },
                    ['polmav'] = {         -- Car/Helicopter/Vehicle Spawn Code/Model Name
                        label = 'Maverick',
                        category = 'air',  -- Options are 'land' and 'air'
                    },
                },
            }
        }
    },
}
