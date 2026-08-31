local PlaceId = game.PlaceId
local GameId = game.GameId

print("--------------------------------------------------")
print("👑 [SAKA HUB] Universal Multi-Game Loader V3.0")
print("🎮 Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId))
print("--------------------------------------------------")

-- 1. 🎯 RIVALS
if GameId == 6035872082 or PlaceId == 17625359962 or PlaceId == 117398147513099 then
    print("✅ [SAKA HUB] Detected: RIVALS")
    if isfile and isfile("Rivals.lua") then loadstring(readfile("Rivals.lua"))() end

-- 2. 🔫 GUNFIGHT ARENA
elseif PlaceId == 90568084448279 or GameId == 5576721528 then
    print("✅ [SAKA HUB] Detected: GUNFIGHT ARENA")
    if isfile and isfile("GunfightArena.lua") then loadstring(readfile("GunfightArena.lua"))() end

-- 3. ⚔️ BLOX FRUITS
elseif GameId == 994732206 or PlaceId == 2753915549 or PlaceId == 4442272183 or PlaceId == 7449423635 then
    print("✅ [SAKA HUB] Detected: BLOX FRUITS")
    if isfile and isfile("BloxFruits_Sea1.lua") then loadstring(readfile("BloxFruits_Sea1.lua"))() end

-- 4. 🥚 STEAL EGGS / AREA EGG STEALER (อัปเดต ID ใหม่แล้ว)
elseif PlaceId == 107778070777162 or PlaceId == 137233438285284 or GameId == 10209534490 then
    print("✅ [SAKA HUB] Detected: STEAL EGGS (Place: " .. tostring(PlaceId) .. ")")
    if isfile and isfile("MainScript.lua") then loadstring(readfile("MainScript.lua"))() end

-- ❌ UNSUPPORTED
else
    warn("⚠️ [SAKA HUB] This game is not supported yet! (Place ID: " .. tostring(PlaceId) .. ")")
end
