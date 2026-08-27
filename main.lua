-- 👑 SAKA HUB - UNIVERSAL LOADER
local PlaceId = game.PlaceId
local GameId = game.GameId

-- ถ้าเล่น King Legacy -> ดึงไฟล์ KingLegacy.lua ที่เราอัปโหลดไว้มาเล่น
if PlaceId == 4520749081 or PlaceId == 6381829480 or PlaceId == 5931540094 or GameId == 1575951504 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/KingLegacy.lua"))()

-- ถ้าเล่น Chicken Farm -> ดึงไฟล์ ChickenFarm.lua ที่เราอัปโหลดไว้มาเล่น
elseif PlaceId == 18337775082 or GameId == 6301323329 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/djdjdjrididi85-design/SakaHub/main/ChickenFarm.lua"))()

else
    warn("⚠️ [SAKA HUB] This game is not supported yet!")
end
