--[[
    ═══════════════════════════════════════════════════════════════
    👑 SAKA HUB - UNIVERSAL MULTI-GAME LOADER (MAIN.LUA)
    🌐 Repository: djdjdjrididi85-design/SakaHub
    ═══════════════════════════════════════════════════════════════
--]]

local PlaceId = game.PlaceId
local GameId = game.GameId

print("--------------------------------------------------")
print("👑 [SAKA HUB] Universal Multi-Game Loader")
print("🎮 Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId))
print("--------------------------------------------------")

local BaseUrl = "https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/"

local function loadScript(fileName)
    local url = BaseUrl .. fileName
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("⚠️ Remote load failed, attempting local file read...")
        if isfile and isfile(fileName) and readfile then
            pcall(function()
                loadstring(readfile(fileName))()
            end)
        end
    end
end

-- 1. 🎯 RIVALS (Universe ID: 6035872082 | ทั้ง Lobby และห้องแข่งขัน)
if GameId == 6035872082 or PlaceId == 17625359962 or PlaceId == 117398147513099 then
    print("✅ [SAKA HUB] Detected Game: RIVALS")
    loadScript("Rivals.lua")

-- 2. 🔫 GUNFIGHT ARENA
elseif PlaceId == 90568084448279 or GameId == 5576721528 then
    print("✅ [SAKA HUB] Detected Game: GUNFIGHT ARENA")
    loadScript("GunfightArena.lua")

-- 3. ⚔️ BLOX FRUITS
elseif GameId == 994732206 or PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
    print("✅ [SAKA HUB] Detected Game: BLOX FRUITS")
    loadScript("BloxFruits_Sea1.lua")

-- 4. 🥚 STEAL EGGS
elseif PlaceId == 107778070777162 then
    print("✅ [SAKA HUB] Detected Game: STEAL EGGS")
    loadScript("MainScript.lua")

-- ❌ UNSUPPORTED
else
    warn("⚠️ [SAKA HUB] This game is not supported yet! (Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId) .. ")")
end
