-- ====================================================================
-- 👑 SAKA HUB - UNIVERSAL MULTI GAME LOADER
-- ====================================================================

local PlaceId = game.PlaceId
local GameId = game.GameId

print("--------------------------------------------------")
print("👑 [SAKA HUB] Universal Multi-Game Loader")
print("🎮 Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId))
print("--------------------------------------------------")

-- 1. Chicken Farm Tycoon
if PlaceId == 137233438285284 or GameId == 18209534490 or PlaceId == 18337775882 or GameId == 6301323329 then
    print("🐔 [SAKA HUB] Loading Chicken Farm Tycoon Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/ChickenFarm.lua?t=" .. tick()))()

-- 2. King Legacy (Sea 1, Sea 2, Sea 3)
elseif PlaceId == 4520749081 or PlaceId == 6381829480 or PlaceId == 5931540094 or GameId == 1575951504 then
    print("⚔️ [SAKA HUB] Loading King Legacy Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/KingLegacy.lua?t=" .. tick()))()

-- 3. Murder Mystery 2 (MM2)
elseif PlaceId == 142823291 or GameId == 66654135 then
    print("🔪 [SAKA HUB] Loading Murder Mystery 2 Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/MM2.lua?t=" .. tick()))()

-- 4. เกมอื่นๆ ที่ยังไม่รองรับ
else
    warn("⚠️ [SAKA HUB] This game is not supported yet! (Place ID: " .. tostring(PlaceId) .. " | Game ID: " .. tostring(GameId) .. ")")
end
