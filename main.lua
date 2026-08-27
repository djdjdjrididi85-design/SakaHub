-- ====================================================================
-- 👑 SAKA HUB - UNIVERSAL MULTI-GAME LOADER
-- ====================================================================

local PlaceId = game.PlaceId
local GameId = game.GameId
local gameName = game:GetService("MarketplaceService"):GetProductInfo(PlaceId).Name or ""

print("==================================================")
print("👑 [SAKA HUB] Universal Multi-Game Loader")
print("🎮 Game Name: " .. tostring(gameName))
print("📌 Place ID:  " .. tostring(PlaceId))
print("🎲 Game ID:   " .. tostring(GameId))
print("==================================================")

local lowerName = string.lower(gameName)

-- 1. Chicken Farm Tycoon (ตรวจจับทั้งจาก PlaceId และชื่อแมพ Chicken Farm)
if string.find(lowerName, "chicken") or PlaceId == 18337775082 or GameId == 6301323329 then
    print("🚀 [SAKA HUB] Loading Chicken Farm Tycoon Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/ChickenFarm.lua"))()

-- 2. King Legacy (Sea 1, Sea 2, Sea 3)
elseif string.find(lowerName, "king legacy") or PlaceId == 4520749081 or PlaceId == 6381829480 or PlaceId == 5931540094 or GameId == 1575951504 then
    print("🚀 [SAKA HUB] Loading King Legacy Script...")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/KingLegacy.lua"))()

-- 3. แมพอื่นๆ ที่ยังไม่รองรับ
else
    warn("⚠️ [SAKA HUB] This game is not supported yet! (Place ID: " .. tostring(PlaceId) .. " | Name: " .. gameName .. ")")
end
