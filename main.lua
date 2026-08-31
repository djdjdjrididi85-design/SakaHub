--[[
    ═══════════════════════════════════════════════════════════════
    👑 SAKA HUB - UNIVERSAL MULTI-GAME AUTO LOADER (V3.0 MASTER)
    🌐 Repository: djdjdjrididi85-design/SakaHub
    🚀 Automatically routes to the correct script based on GameId & PlaceId
    ═══════════════════════════════════════════════════════════════
--]]

local PlaceId = game.PlaceId
local GameId = game.GameId

print("--------------------------------------------------")
print("👑 [SAKA HUB] Universal Multi-Game Loader V3.0")
print("🎮 Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId))
print("--------------------------------------------------")

local BaseUrl = "https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/"

local function executeGameScript(fileName)
    -- 1. ลองโหลดจากไฟล์ Local ในเครื่องก่อน (ถ้ามี)
    if isfile and isfile(fileName) and readfile then
        print("⚡ [SAKA HUB] Loading local file: " .. fileName)
        local success, err = pcall(function()
            local fn, loadErr = loadstring(readfile(fileName))
            if fn then fn() else error(loadErr) end
        end)
        if success then return true end
        warn("⚠️ Local load failed: " .. tostring(err) .. ", trying remote fallback...")
    end

    -- 2. ดึงโค้ดออนไลน์จาก GitHub
    local url = BaseUrl .. fileName
    print("🌐 [SAKA HUB] Fetching from: " .. url)
    local success, err = pcall(function()
        local src = game:HttpGet(url)
        local fn, loadErr = loadstring(src)
        if fn then
            fn()
        else
            error("Failed to compile " .. fileName .. ": " .. tostring(loadErr))
        end
    end)
    if success then return true end
    warn("⚠️ Remote load failed: " .. tostring(err))
    return false
end

-- ═══════════════════════════════════════════════════════════════
-- 🎮 GAME ROUTING TABLE (MATCHES UNIVERSE ID & PLACE IDS)
-- ═══════════════════════════════════════════════════════════════

-- 1. 🎯 RIVALS (Roblox FPS / PVP)
if GameId == 6035872082 or PlaceId == 17625359962 or PlaceId == 117398147513099 then
    print("✅ [SAKA HUB] Detected: RIVALS (Place: " .. tostring(PlaceId) .. ")")
    executeGameScript("Rivals.lua")

-- 2. 🔫 GUNFIGHT ARENA (FPS / PVP & Bots)
elseif PlaceId == 90568084448279 or GameId == 5576721528 then
    print("✅ [SAKA HUB] Detected: GUNFIGHT ARENA (Place: " .. tostring(PlaceId) .. ")")
    executeGameScript("GunfightArena.lua")

-- 3. ⚔️ BLOX FRUITS (Sea 1, 2, 3)
elseif GameId == 994732206 or PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
    print("✅ [SAKA HUB] Detected: BLOX FRUITS (Sea 1/2/3)")
    executeGameScript("BloxFruits_Sea1.lua")

-- 4. 🐣 CHICKEN FARM TYCOON / AREA EGG STEALER
elseif PlaceId == 107778070777162 or PlaceId == 137233438285284 or GameId == 10209534490 then
    print("✅ [SAKA HUB] Detected: CHICKEN FARM TYCOON (Place: " .. tostring(PlaceId) .. ")")
    executeGameScript("MainScript.lua")

-- ❌ UNSUPPORTED GAME
else
    local msg = string.format("⚠️ [SAKA HUB] This game is not supported yet! (Place ID: %s | Game ID: %s)", tostring(PlaceId), tostring(GameId))
    warn(msg)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "👑 SAKA HUB",
            Text = "Game not supported yet! (ID: " .. tostring(PlaceId) .. ")",
            Duration = 5
        })
    end)
end
