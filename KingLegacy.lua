-- ========================================================
-- 👑 KING LEGACY CLEAN AUTO FARM & KAITUN ENGINE
-- ========================================================
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or game:GetService("Players").LocalPlayer

getgenv().Script_Mode = "Kaitun_Script"

-- ========================================================
-- ⚙️ [AFK & KAITUN CONFIGURATION SETTINGS]
-- ========================================================
_G.Settings_Farm = _G.Settings_Farm or {
    ["Start_Farm"] = true,               -- Auto Farm on execution
    ["Auto_Level"] = true,               -- Auto Quest by player level
    ["Include_Bosses"] = true,           -- Fight bosses when reached level
    ["Fast_Farm"] = true,                -- High speed tween & fast attack
    ["Tween_Speed"] = 250,               -- Flying Tween Speed
    ["Distance_Above"] = 3.5,            -- Hover height above mob (studs)
    ["Auto_Weapon"] = "AUTO_ANY",        -- Weapon name or "AUTO_ANY"
    
    -- [Auto Stats Upgrade]
    ["Auto_Stats"] = {
        ["Enabled"] = true,
        ["Melee"] = false,               -- Combat / Melee
        ["Defense"] = false,             -- Max Health / Defense
        ["Sword"] = true,                -- Sword stat
        ["Fruit"] = false,               -- Devil Fruit stat
        ["Points_Per_Cycle"] = 10,       -- Points to add per cycle
    },

    -- [Auto Skills]
    ["Auto_Skills"] = {
        ["Enabled"] = true,
        ["Use_Z"] = true,
        ["Use_X"] = true,
        ["Use_C"] = true,
        ["Use_V"] = false,
        ["Use_E"] = false,
        ["Use_B"] = false,
        ["Delay"] = 0.5,
    },

    -- [Performance & Anti-Lag Optimization]
    ["Performance"] = {
        ["WhiteScreen"] = false,         -- Black/White screen to reduce GPU
        ["Disabled_Gui"] = false,        -- Hide UI to save RAM
        ["LOCK_FPS"] = false,            -- Lock FPS limit
        ["Amount_FPS"] = 30,             -- Target FPS limit
        ["Anti_Lag"] = true,             -- Low graphics and shadows off
    },

    -- [Smart Auto Progression to Second Sea]
    ["Auto_Advance_Sea2"] = {
        ["Enabled"] = true,               -- ตรวจสอบเงื่อนไขไปโลก 2 อัตโนมัติ
        ["Level_Requirement"] = 2200,      -- เลเวลขั้นต่ำที่ต้องถึง (2200-2250)
        ["Require_Map_Item"] = true,       -- ต้องมีไอเทม Map ก่อนจึงจะเริ่มทำเควสโลก 2
        ["Auto_Execute_Traveler_Quest"] = true, -- ทำเควส 9 ขั้นตอนอัตโนมัติเมื่อพร้อม
        ["Auto_Travel_To_Sea2"] = true,    -- ส่งตัวละครข้ามไปโลก 2 ทันที
    }
}

_G.Quests_Settings = _G.Quests_Settings or {
    ["Auto_Traveler_Quest_Sea2"] = false, -- Run 9-step Traveler quest automatically
    ["Auto_Elite_Pirate_Travel"] = false, -- Talk to Elite Pirate to travel Sea 2
    ["Auto_Travel_Sea3"] = false,         -- Instant travel to Sea 3
    ["Auto_Sea_King"] = false,            -- Sea King auto hunter
    ["Auto_Ghost_Ship"] = false,          -- Ghost Ship auto hunter
    ["Auto_Sea_Serpent"] = false,         -- Hydra / Serpent auto hunter
    ["Auto_Escape_Low_HP"] = true,        -- Fly up when HP < 25%
}

-- 1. Performance Engine (FPS Lock, White Screen & Anti-Lag)
if _G.Settings_Farm["Performance"]["LOCK_FPS"] and setfpscap then
    setfpscap(_G.Settings_Farm["Performance"]["Amount_FPS"] or 30)
end

if _G.Settings_Farm["Performance"]["WhiteScreen"] then
    pcall(function()
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end)
end

local function enableAntiLag()
    if not _G.Settings_Farm["Performance"]["Anti_Lag"] then return end
    pcall(function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 1
        for _, effect in ipairs(lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") then
                effect.Enabled = false
            end
        end
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 0
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end
task.spawn(enableAntiLag)

-- 2. Auto Play / Join Engine (รอ 3 วินาทีหลังจากรันสคริปต์ แล้วกด \ 1 ครั้ง แล้ว Enter)
task.spawn(function()
    task.wait(3)

    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim then
            -- กด \ (BackSlash) 1 ครั้ง เพื่อโฟกัสปุ่ม Play
            vim:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.15)
            vim:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.3)

            -- กด Enter (Return) 1 ครั้ง เพื่อเข้าเกม
            vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.15)
            vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        end
    end)
end)

-- 3. Clear Old UI Windows
pcall(function()
    if getgenv and getgenv().KingLegacyWindow then
        getgenv().KingLegacyWindow:Destroy()
    end
    for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
        if g.Name == "Rayfield" then g:Destroy() end
    end
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        for _, g in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
            if g.Name == "Rayfield" then g:Destroy() end
        end
    end
end)

-- หน่วงเวลา 3 วินาทีก่อนเริ่มโหลด UI ตามที่ผู้ใช้กำหนด
task.wait(3)

-- 4. Orion UI Initialization
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "👑 SAKA HUB | King Legacy",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "SakaHubKingLegacy",
    IntroText = "SAKA HUB | King Legacy 👑",
    Icon = "rbxassetid://4483362458"
})
if getgenv then getgenv().KingLegacyWindow = Window end

-- 5. Main Variables & Bindings from Config Table
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

_G.AutoFarm = _G.Settings_Farm["Start_Farm"]
_G.AutoLevel = true
_G.IncludeBosses = _G.Settings_Farm["Include_Bosses"]
_G.TargetMob = nil
_G.TargetQuest = nil
_G.DistanceAbove = _G.Settings_Farm["Distance_Above"] or 3.5
_G.TweenSpeed = _G.Settings_Farm["Tween_Speed"] or 250
_G.SelectedToolName = _G.Settings_Farm["Auto_Weapon"] or "AUTO_ANY"

local statsConf = _G.Settings_Farm["Auto_Stats"] or {}
_G.AutoMelee = statsConf["Melee"] or false
_G.AutoDefense = statsConf["Defense"] or false
_G.AutoSword = statsConf["Sword"] or false
_G.AutoFruit = statsConf["Fruit"] or false
_G.StatPointsAmount = statsConf["Points_Per_Cycle"] or 10

local skillConf = _G.Settings_Farm["Auto_Skills"] or {}
_G.AutoSkill = skillConf["Enabled"] or true
_G.UseSkill_Z = skillConf["Use_Z"] ~= nil and skillConf["Use_Z"] or true
_G.UseSkill_X = skillConf["Use_X"] ~= nil and skillConf["Use_X"] or true
_G.UseSkill_C = skillConf["Use_C"] ~= nil and skillConf["Use_C"] or true
_G.UseSkill_V = skillConf["Use_V"] or false
_G.UseSkill_E = skillConf["Use_E"] or false
_G.UseSkill_B = skillConf["Use_B"] or false
_G.SkillDelay = skillConf["Delay"] or 0.5

_G.AutoSeaKing = _G.Quests_Settings["Auto_Sea_King"] or false
_G.AutoGhostShip = _G.Quests_Settings["Auto_Ghost_Ship"] or false
_G.AutoSeaSerpent = _G.Quests_Settings["Auto_Sea_Serpent"] or false
_G.AutoEscapeLowHP = _G.Quests_Settings["Auto_Escape_Low_HP"] ~= nil and _G.Quests_Settings["Auto_Escape_Low_HP"] or true

local lockTargetCFrame = nil
local lastKnownMobCFrame = nil
local cachedPlayerLevel = 1
local lockedTargetMob = nil
local lockedTargetQuest = nil
local lastTargetChangeTime = 0
local currentTargetEnemy = nil
local findMonster = nil
local doAttack = nil

-- ฟังก์ชันวาร์ปตรงถึงพิกัด 0 วินาที (Instant Teleport)
local function flyTo(cframe)
    if not cframe then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    local bv = hrp:FindFirstChild("CleanVelocity")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "CleanVelocity"
        bv.Velocity = Vector3.zero
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = hrp
    end

    lockTargetCFrame = cframe
    hrp.CFrame = cframe
    hrp.Velocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero
end

-- ระบบบันทึกและโหลดค่าการตั้งค่าแบบอิสระ (Custom JSON Config System)
local HttpService = game:GetService("HttpService")
local CONFIG_FILE = "KingLegacy_CleanConfig.json"

local function saveCustomConfig()
    pcall(function()
        if writefile then
            local data = {
                AutoFarm = _G.AutoFarm,
                AutoLevel = _G.AutoLevel,
                IncludeBosses = _G.IncludeBosses,
                DistanceAbove = _G.DistanceAbove,
                TweenSpeed = _G.TweenSpeed,
                SelectedToolName = _G.SelectedToolName,
                AutoSkill = _G.AutoSkill,
                UseSkill_Z = _G.UseSkill_Z,
                UseSkill_X = _G.UseSkill_X,
                UseSkill_C = _G.UseSkill_C,
                UseSkill_V = _G.UseSkill_V,
                UseSkill_E = _G.UseSkill_E,
                UseSkill_B = _G.UseSkill_B,
                SkillDelay = _G.SkillDelay,
                AutoMelee = _G.AutoMelee,
                AutoDefense = _G.AutoDefense,
                AutoSword = _G.AutoSword,
                AutoFruit = _G.AutoFruit,
                StatPointsAmount = _G.StatPointsAmount,
            }
            writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        end
    end)
end

local function loadCustomConfig()
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local raw = readfile(CONFIG_FILE)
            local data = HttpService:JSONDecode(raw)
            if type(data) == "table" then
                if data.AutoFarm ~= nil then _G.AutoFarm = data.AutoFarm end
                if data.AutoLevel ~= nil then _G.AutoLevel = data.AutoLevel end
                if data.IncludeBosses ~= nil then _G.IncludeBosses = data.IncludeBosses end
                if data.DistanceAbove ~= nil then _G.DistanceAbove = data.DistanceAbove end
                if data.TweenSpeed ~= nil then _G.TweenSpeed = data.TweenSpeed end
                if data.SelectedToolName ~= nil then _G.SelectedToolName = data.SelectedToolName end
                if data.AutoSkill ~= nil then _G.AutoSkill = data.AutoSkill end
                if data.UseSkill_Z ~= nil then _G.UseSkill_Z = data.UseSkill_Z end
                if data.UseSkill_X ~= nil then _G.UseSkill_X = data.UseSkill_X end
                if data.UseSkill_C ~= nil then _G.UseSkill_C = data.UseSkill_C end
                if data.UseSkill_V ~= nil then _G.UseSkill_V = data.UseSkill_V end
                if data.UseSkill_E ~= nil then _G.UseSkill_E = data.UseSkill_E end
                if data.UseSkill_B ~= nil then _G.UseSkill_B = data.UseSkill_B end
                if data.SkillDelay ~= nil then _G.SkillDelay = data.SkillDelay end
                if data.AutoMelee ~= nil then _G.AutoMelee = data.AutoMelee end
                if data.AutoDefense ~= nil then _G.AutoDefense = data.AutoDefense end
                if data.AutoSword ~= nil then _G.AutoSword = data.AutoSword end
                if data.AutoFruit ~= nil then _G.AutoFruit = data.AutoFruit end
                if data.StatPointsAmount ~= nil then _G.StatPointsAmount = data.StatPointsAmount end
            end
        end
    end)
end

-- โหลดการตั้งค่าเก่าที่เคยบันทึกไว้ทันที
loadCustomConfig()

-- ฟังก์ชันดึงเลเวลผู้เล่นจริง 100% (ตรงตามโครงสร้างเกม: PlayerStats.lvl & BaseFrame.Frame.Lvl)
local function getPlayerLevel()
    local detectedLevel = 1
    pcall(function()
        -- 1. ตรวจสอบ PlayerStats.lvl โดยตรง (ตรงตามผล Diagnostic 100%)
        if LocalPlayer:FindFirstChild("PlayerStats") and LocalPlayer.PlayerStats:FindFirstChild("lvl") then
            local v = tonumber(LocalPlayer.PlayerStats.lvl.Value)
            if v and v > detectedLevel and v <= 4000 then
                detectedLevel = v
            end
        end

        -- 2. ตรวจสอบ TextLabel BaseFrame.Frame.Lvl ใน PlayerGui
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if pgui and pgui:FindFirstChild("MainGui") then
            for _, bName in ipairs({"BaseFrame", "BaseFrameOG"}) do
                local base = pgui.MainGui:FindFirstChild(bName)
                if base and base:FindFirstChild("Frame") and base.Frame:FindFirstChild("Lvl") then
                    local v = tonumber(base.Frame.Lvl.Text)
                    if v and v > detectedLevel and v <= 4000 then
                        detectedLevel = v
                    end
                end
            end
        end

        -- 3. สแกนหา ValueObject ทั้งหมดใน LocalPlayer (Fallback)
        for _, obj in ipairs(LocalPlayer:GetDescendants()) do
            if obj:IsA("ValueBase") then
                local n = string.lower(obj.Name)
                if n == "lvl" or n == "level" or n == "lv" or n == "playerlevel" then
                    local v = tonumber(obj.Value)
                    if v and v > detectedLevel and v <= 4000 then
                        detectedLevel = v
                    end
                end
            end
        end
    end)

    if detectedLevel > (cachedPlayerLevel or 1) then
        cachedPlayerLevel = detectedLevel
    end

    return cachedPlayerLevel or detectedLevel or 1
end

-- ฟังก์ชันตรวจสอบว่าผู้เล่นมีไอเทม Map / เข็มทิศเดินทางไปโลก 2 หรือไม่
local function hasMapItem()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local function checkName(str)
        if not str then return false end
        local s = string.lower(tostring(str))
        return string.find(s, "map") or string.find(s, "compass") or string.find(s, "traveler") or string.find(s, "second sea") or string.find(s, "sea 2")
    end
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and checkName(t.Name) then return true end
        end
    end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and checkName(t.Name) then return true end
        end
    end
    local pStats = LocalPlayer:FindFirstChild("PlayerStats") or LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("leaderstats")
    if pStats then
        for _, v in ipairs(pStats:GetDescendants()) do
            if (v:IsA("StringValue") or v:IsA("BoolValue") or v:IsA("IntValue")) and checkName(v.Name) then
                if v:IsA("BoolValue") and v.Value then return true end
                if v:IsA("IntValue") and v.Value > 0 then return true end
                if v:IsA("StringValue") and v.Value ~= "" then return true end
            end
        end
    end
    return false
end

-- ฟังก์ชันตรวจสอบชื่อมอนสเตอร์แบบ Smart Fuzzy Matcher (รองรับทั้งเอกพจน์/พหูพจน์ และตัดสัญลักษณ์พิเศษ 100%)
local function isMobNameMatching(modelName, targetMobName)
    if not modelName or not targetMobName then return false end
    local mName = string.lower(tostring(modelName))
    local tName = string.lower(tostring(targetMobName))
    
    local cleanModel = string.match(mName, "^(.-)%s*%[") or mName
    local cleanTarget = string.match(tName, "^(.-)%s*%[") or tName
    
    cleanModel = string.gsub(cleanModel, "[%s%p]", "")
    cleanTarget = string.gsub(cleanTarget, "[%s%p]", "")
    
    if cleanModel == cleanTarget then return true end
    
    -- จัดการกรณีพหูพจน์มี 's' ต่อท้าย (เช่น Fighter Fishman vs Fighter Fishmans)
    if cleanModel:sub(-1) == "s" and cleanModel:sub(1, -2) == cleanTarget then return true end
    if cleanTarget:sub(-1) == "s" and cleanTarget:sub(1, -2) == cleanModel then return true end
    
    return false
end

-- ตารางเควสมาตรฐานโลก 1 แม่นยำตามเลเวล 100%
local QuestDatabase = {
    { Level = 0,    Mob = "Soldier",              Quest = "Kill 4 Soldiers",            IsBoss = false, Pos = CFrame.new(-2076, 49, -4562) },
    { Level = 10,   Mob = "Clown Pirate",         Quest = "Kill 5 Clown Pirates",       IsBoss = false, Pos = CFrame.new(-685, 44, -3446) },
    { Level = 20,   Mob = "Smoky",                Quest = "Kill 1 Smoky",               IsBoss = true,  Pos = CFrame.new(-2120, 55, -4520) },
    { Level = 30,   Mob = "Tashi",                Quest = "Kill 1 Tashi",               IsBoss = true,  Pos = CFrame.new(-2050, 50, -4580) },
    { Level = 50,   Mob = "Clown Swordman",       Quest = "Kill 6 Clown Swordman",      IsBoss = false, Pos = CFrame.new(-750, 44, -3400) },
    { Level = 75,   Mob = "The Clown",            Quest = "Kill 1 The Clown",           IsBoss = true,  Pos = CFrame.new(-660, 45, -3420) },
    { Level = 100,  Mob = "Commander",            Quest = "Kill 4 Commander",           IsBoss = false, Pos = CFrame.new(1533, 19, 944) },
    { Level = 120,  Mob = "Captain",              Quest = "Kill 1 Captain",             IsBoss = true,  Pos = CFrame.new(1550, 25, 960) },
    { Level = 145,  Mob = "The Barbaric",         Quest = "Kill 1 The Barbaric",        IsBoss = true,  Pos = CFrame.new(-685, 44, -3446) },
    { Level = 180,  Mob = "Fighter Fishman",      Quest = "Kill 4 Fighter Fishmans",    IsBoss = false, Pos = CFrame.new(-1716, 40, 6315) },
    { Level = 200,  Mob = "Karate Fishman",       Quest = "Kill 1 Karate Fishman",      IsBoss = true,  Pos = CFrame.new(-1700, 42, 6330) },
    { Level = 250,  Mob = "Trainer Chef",         Quest = "Kill 4 Trainer Chef",        IsBoss = false, Pos = CFrame.new(-4149, 17, -3063) },
    { Level = 300,  Mob = "Dark Leg",             Quest = "Kill 1 Dark Leg",            IsBoss = true,  Pos = CFrame.new(-4149, 25, -3063) },
    { Level = 350,  Mob = "Dory",                 Quest = "Kill 1 Dory",                IsBoss = true,  Pos = CFrame.new(-4100, 20, -3080) },
    { Level = 400,  Mob = "Snow Soldier",         Quest = "Kill 5 Snow Soldier",        IsBoss = false, Pos = CFrame.new(-5436, 29, -1297) },
    { Level = 450,  Mob = "King Snow",            Quest = "Kill 1 King Snow",           IsBoss = true,  Pos = CFrame.new(-5400, 35, -1320) },
    { Level = 500,  Mob = "Little Dear",          Quest = "Kill 1 Little Dear",         IsBoss = true,  Pos = CFrame.new(-5450, 30, -1280) },
    { Level = 525,  Mob = "Candle Man",           Quest = "Kill 1 Candle Man",          IsBoss = true,  Pos = CFrame.new(-5420, 30, -1310) },
    { Level = 575,  Mob = "Sand Bandit",          Quest = "Kill 4 Sand Bandit",         IsBoss = false, Pos = CFrame.new(-2743, 42, -752) },
    { Level = 625,  Mob = "Bomb Man",             Quest = "Kill 1 Bomb Man",            IsBoss = true,  Pos = CFrame.new(-2720, 45, -730) },
    { Level = 675,  Mob = "Desert Marauder",      Quest = "Kill 4 Desert Marauder",     IsBoss = false, Pos = CFrame.new(-2700, 42, -780) },
    { Level = 725,  Mob = "King of Sand",         Quest = "Kill 1 King of Sand",        IsBoss = true,  Pos = CFrame.new(-2750, 50, -760) },
    { Level = 800,  Mob = "Sky Soldier",          Quest = "Kill 4 Sky Soldier",         IsBoss = false, Pos = CFrame.new(-4322, 384, 1243) },
    { Level = 850,  Mob = "Ball Man",             Quest = "Kill 1 Ball Man",            IsBoss = true,  Pos = CFrame.new(-4300, 390, 1200) },
    { Level = 900,  Mob = "Cloud Warrior",        Quest = "Kill 4 Cloud Warrior",       IsBoss = false, Pos = CFrame.new(-4322, 384, 1243) },
    { Level = 950,  Mob = "Rumble Man",           Quest = "Kill 1 Rumble Man",          IsBoss = true,  Pos = CFrame.new(-4350, 400, 1250) },
    { Level = 1000, Mob = "Elite Soldier",        Quest = "Kill 4 Elite Soldiers",      IsBoss = false, Pos = CFrame.new(1533, 19, 944) },
    { Level = 1050, Mob = "High-class Soldier",   Quest = "Kill 4 High-class Soldier",  IsBoss = false, Pos = CFrame.new(1533, 19, 944) },
    { Level = 1100, Mob = "Leader",               Quest = "Kill 1 Leader",              IsBoss = true,  Pos = CFrame.new(1533, 19, 944) },
    { Level = 1150, Mob = "Pasta",                Quest = "Kill 1 Pasta",               IsBoss = true,  Pos = CFrame.new(1560, 25, 950) },
    { Level = 1200, Mob = "Naval personnel",      Quest = "Kill 4 Naval personnel",     IsBoss = false, Pos = CFrame.new(-1215, 21, 2103) },
    { Level = 1250, Mob = "Wolf",                 Quest = "Kill 1 Wolf",                IsBoss = true,  Pos = CFrame.new(-1215, 21, 2103) },
    { Level = 1300, Mob = "Giraffe",              Quest = "Kill 1 Giraffe",             IsBoss = true,  Pos = CFrame.new(-1230, 25, 2120) },
    { Level = 1350, Mob = "Nautical soldier",     Quest = "Kill 4 Nautical soldier",    IsBoss = false, Pos = CFrame.new(-1215, 21, 2103) },
    { Level = 1400, Mob = "Naval soldier",        Quest = "Kill 4 Naval soldier",       IsBoss = false, Pos = CFrame.new(-1215, 21, 2103) },
    { Level = 1450, Mob = "Leo",                  Quest = "Kill 1 Leo",                 IsBoss = true,  Pos = CFrame.new(-1200, 25, 2080) },
    { Level = 1500, Mob = "Zombie",               Quest = "Kill 5 Zombies",             IsBoss = false, Pos = CFrame.new(-2806, 20, 4238) },
    { Level = 1550, Mob = "Elite Zombie",         Quest = "Kill 4 Elite Zombies",       IsBoss = false, Pos = CFrame.new(-2820, 20, 4220) },
    { Level = 1600, Mob = "Revenant",             Quest = "Kill 4 Revenant",            IsBoss = false, Pos = CFrame.new(-2850, 25, 4200) },
    { Level = 1650, Mob = "Shadow Master",        Quest = "Kill 1 Shadow Master",       IsBoss = true,  Pos = CFrame.new(-2806, 30, 4238) },
    { Level = 1700, Mob = "New World Pirate",     Quest = "Kill 4 New World Pirates",   IsBoss = false, Pos = CFrame.new(2402, 56, -1822) },
    { Level = 1750, Mob = "Cutlass Pirate",       Quest = "Kill 4 Cutlass Pirates",     IsBoss = false, Pos = CFrame.new(2402, 56, -1822) },
    { Level = 1850, Mob = "True Karate Fishman",  Quest = "Kill 1 True Karate Fishman", IsBoss = true,  Pos = CFrame.new(-1700, 42, 6330) },
    { Level = 1925, Mob = "Quake Woman",          Quest = "Kill 1 Quake Woman",         IsBoss = true,  Pos = CFrame.new(2402, 56, -1822) },
    { Level = 2000, Mob = "Fishman",              Quest = "Kill 4 Fishmans",            IsBoss = false, Pos = CFrame.new(-1716, 40, 6315) },
    { Level = 2050, Mob = "Combat Fishman",       Quest = "Kill 1 Combat Fishman",      IsBoss = true,  Pos = CFrame.new(-1750, 42, 6280) },
    { Level = 2100, Mob = "Sword Fishman",        Quest = "Kill 1 Sword Fishman",       IsBoss = true,  Pos = CFrame.new(-1760, 42, 6250) },
    { Level = 2150, Mob = "Soldier Fishman",      Quest = "Kill 4 Soldier Fishman",     IsBoss = false, Pos = CFrame.new(-1716, 40, 6315) },
    { Level = 2200, Mob = "Seasoned Fishman",     Quest = "Kill 1 Seasoned Fishman",    IsBoss = true,  Pos = CFrame.new(-1716, 40, 6315) }
}

-- 3.4 ตรวจสอบว่ามอนสเตอร์/บอสกำลังเกิดอยู่บนเซิร์ฟเวอร์จริงหรือไม่
local function isMobAliveInWorkspace(mobKeyword)
    if not mobKeyword or mobKeyword == "" then return false end
    local function checkAlive(mob)
        if mob and mob:IsA("Model") and not Players:GetPlayerFromCharacter(mob) then
            if isMobNameMatching(mob.Name, mobKeyword) then
                local hum = mob:FindFirstChildOfClass("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChild("Torso") or mob.PrimaryPart or mob:FindFirstChildOfClass("BasePart")
                if hrp and ((hum and hum.Health > 0) or (not hum and mob.Parent ~= nil)) then
                    return true
                end
            end
        end
        return false
    end

    local monsterRoot = workspace:FindFirstChild("Monster") or workspace:FindFirstChild("MONSTER") or workspace:FindFirstChild("Mob") or workspace:FindFirstChild("Enemies")
    if monsterRoot then
        for _, child in ipairs(monsterRoot:GetDescendants()) do
            if checkAlive(child) then return true end
        end
    end
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and checkAlive(obj) then return true end
    end
    return false
end

-- 3.5 ตรวจสอบเลเวลผู้เล่นและเลือกเป้าหมายล็อคตามเลเวลจริง 100% (ไม่สลับเป้าไปมอนอื่นตอนรอมอนเกิด)
local function getTargetByLevel()
    local lvl = getPlayerLevel() or 1
    local best = nil

    for _, q in ipairs(QuestDatabase) do
        if lvl >= q.Level then
            if not q.IsBoss or _G.IncludeBosses then
                best = q
            end
        else
            break
        end
    end

    return best or QuestDatabase[1]
end

-- 3.5.5 ฟังก์ชันตรวจสอบว่ามีเควสที่กำลังทำอยู่หรือไม่
local function isQuestActive()
    local active = false
    pcall(function()
        -- 1. เช็คจาก Value ในตัวผู้เล่น
        local qVal = LocalPlayer:FindFirstChild("CurrentQuest") or LocalPlayer:FindFirstChild("Quest")
        if qVal and tostring(qVal.Value) ~= "" and tostring(qVal.Value) ~= "None" then
            active = true
            return
        end
        
        -- 2. เช็คจาก PlayerGui (Quest Frame / Quest Text)
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if pgui then
            local mainGui = pgui:FindFirstChild("MainGui") or pgui:FindFirstChild("QuestGui") or pgui:FindFirstChild("Quest")
            if mainGui then
                for _, obj in ipairs(mainGui:GetDescendants()) do
                    if obj:IsA("TextLabel") and obj.Visible and obj.Text ~= "" then
                        local txt = string.lower(obj.Text)
                        if (string.find(txt, "kill") or string.find(txt, "defeat") or string.find(txt, "/")) and not string.find(txt, "skills") then
                            active = true
                            return
                        end
                    end
                end
            end
        end
    end)
    return active
end

-- 3.6 ฟังก์ชันยกเลิกเควสเก่าที่ไม่ตรงกับเลเวลปัจจุบัน (ปลอดภัย 100% ตรงตามโครงสร้าง King Legacy)
local function cancelMismatchQuest()
    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
        if remotes then
            if remotes:FindFirstChild("Events") and remotes.Events:FindFirstChild("CancelQuestRemote") then
                remotes.Events.CancelQuestRemote:FireServer()
            end
            if remotes:FindFirstChild("Functions") and remotes.Functions:FindFirstChild("Quest") then
                remotes.Functions.Quest:InvokeServer("Abandon")
            end
        end
    end)
end

-- 3.7 ส่งคำสั่งรับเควส
local lastTakeTime = 0
local function takeQuest(questName)
    if not questName or questName == "" then return end
    if tick() - lastTakeTime < 1.5 then return end
    lastTakeTime = tick()
    
    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
        if remotes then
            if remotes:FindFirstChild("Functions") and remotes.Functions:FindFirstChild("Quest") then
                remotes.Functions.Quest:InvokeServer("take", questName)
                if _G.TargetMob and _G.TargetMob ~= questName then
                    remotes.Functions.Quest:InvokeServer("take", _G.TargetMob)
                end
            end
            if remotes:FindFirstChild("Functions") and remotes.Functions:FindFirstChild("QuestAction") then
                remotes.Functions.QuestAction:InvokeServer("TakeQuest", questName)
            end
            if remotes:FindFirstChild("Events") and remotes.Events:FindFirstChild("Quest") then
                remotes.Events.Quest:FireServer("TakeQuest", questName)
            end
        end
    end)
end

-- ฟังก์ชันอ่านเงิน Beli ในตัว
local function getPlayerMoney()
    local beli = 0
    pcall(function()
        for _, obj in ipairs(LocalPlayer:GetDescendants()) do
            if obj:IsA("ValueBase") then
                local n = string.lower(obj.Name)
                if n == "beli" or n == "money" or n == "cash" or n == "gold" then
                    local v = tonumber(obj.Value)
                    if v and v > beli then
                        beli = v
                    end
                end
            end
        end
    end)
    return beli
end

-- ระบบวิเคราะห์เลเวลและบล็อกการฟาร์มผิดจุด 100% (Strict Startup Level Guard ตามข้อตกลง)
local isLevelSyncDone = false
local function ensureAccuratePlayerLevel()
    local t0 = tick()
    while (tick() - t0) < 5 do
        local lvl = getPlayerLevel()
        if lvl and lvl > 1 then
            isLevelSyncDone = true
            return lvl
        end
        task.wait(0.2)
    end
    
    local money = getPlayerMoney()
    if money > 500 then
        local t1 = tick()
        while (tick() - t1) < 3 do
            local lvl = getPlayerLevel()
            if lvl and lvl > 1 then
                isLevelSyncDone = true
                return lvl
            end
            task.wait(0.2)
        end
    end
    
    isLevelSyncDone = true
    return getPlayerLevel() or 1
end

-- 4. UI Tabs Setup (OrionLib)
local Tab = Window:MakeTab({Name = "⚔️ Main Farm", PremiumOnly = false})
local StatsTab = Window:MakeTab({Name = "📊 Auto Stats", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "🚀 Teleports", PremiumOnly = false})
local SeaTravelTab = Window:MakeTab({Name = "🌊 Sea Travel", PremiumOnly = false})
local SeaEventsTab = Window:MakeTab({Name = "🐉 Sea Events", PremiumOnly = false})
local ShopTab = Window:MakeTab({Name = "🛒 Shop & Skills", PremiumOnly = false})
local ConfigTab = Window:MakeTab({Name = "⚙️ Configs & Presets", PremiumOnly = false})

-- ฟังก์ชันหยุดฟาร์มและคืนค่าตัวละครทันที 0ms (Smooth Instant Stop)
local function stopAutoFarm()
    _G.AutoFarm = false
    lockTargetCFrame = nil
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hrp:FindFirstChild("CleanVelocity") then
            hrp.CleanVelocity:Destroy()
        end
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- [Tab 1: Main Farm]
local autoFarmToggle
autoFarmToggle = Tab:AddToggle({
   Name = "Enable Auto Farm",
   Default = false,
   Callback = function(Value)
      _G.AutoFarm = Value
      if Value then
         _G.AutoLevel = true
         -- รีเซ็ต lock เพื่อให้ farm loop คำนวณเป้าหมายใหม่ตามเลเวลจริง
         lockedTargetMob = nil
         lockedTargetQuest = nil
         lastKnownMobCFrame = nil
         currentTargetEnemy = nil
         lockTargetCFrame = nil

         local target = getTargetByLevel()
         if target then
            _G.TargetMob = target.Mob
            _G.TargetQuest = target.Quest
            lockedTargetMob = target.Mob
            lockedTargetQuest = target.Quest
            lastKnownMobCFrame = target.Pos
            cancelMismatchQuest()
            takeQuest(target.Quest)
            if target.Pos then
                task.spawn(function()
                    task.wait(0.1)
                    flyTo(CFrame.new(target.Pos.Position + Vector3.new(0, 15, 0)))
                end)
            end
         end
      else
         stopAutoFarm()
      end
   end,
})



-- NoClip Engine
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.PlatformStand then
                hum.PlatformStand = false
            end
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

Tab:AddSection({Name = "🗡️ Weapon Settings"})



local function getAllPlayerTools()
    local list = {"⚡ Auto Equip Any Tool"}
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and not table.find(list, t.Name) then
                table.insert(list, t.Name)
            end
        end
    end
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and not table.find(list, t.Name) then
                table.insert(list, t.Name)
            end
        end
    end
    return list
end

local toolList = getAllPlayerTools()

local weaponDropdown = Tab:AddDropdown({
   Name = "Select Farm Weapon",
   Default = toolList[1],
   Options = toolList,
   Callback = function(selected)
      if string.find(selected, "Auto Equip Any") or string.find(selected, "AUTO_ANY") then
          _G.SelectedToolName = "AUTO_ANY"
      else
          _G.SelectedToolName = selected
          local char = LocalPlayer.Character
          local bp = LocalPlayer:FindFirstChild("Backpack")
          if char and char:FindFirstChild("Humanoid") and bp then
             local targetTool = bp:FindFirstChild(_G.SelectedToolName)
             if targetTool then
                char.Humanoid:EquipTool(targetTool)
             end
          end
      end
   end,
})

Tab:AddButton({
   Name = "🔄 Refresh Weapon List",
   Callback = function()
      local newList = getAllPlayerTools()
      pcall(function()
         weaponDropdown:Refresh(newList, true)
      end)
      OrionLib:MakeNotification({
         Name = "🔄 Refresh Weapons",
         Content = "Updated tools in backpack (" .. #newList .. " items)",
         Image = "rbxassetid://4483362458",
         Time = 2
      })
   end,
})

Tab:AddSection({Name = "⚡ Auto Skills"})

Tab:AddToggle({
   Name = "Enable Auto Skills",
   Default = _G.AutoSkill,
   Callback = function(Value)
      _G.AutoSkill = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ Z ]",
   Default = _G.UseSkill_Z,
   Callback = function(Value)
      _G.UseSkill_Z = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ X ]",
   Default = _G.UseSkill_X,
   Callback = function(Value)
      _G.UseSkill_X = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ C ]",
   Default = _G.UseSkill_C,
   Callback = function(Value)
      _G.UseSkill_C = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ V ]",
   Default = _G.UseSkill_V,
   Callback = function(Value)
      _G.UseSkill_V = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ E ]",
   Default = _G.UseSkill_E,
   Callback = function(Value)
      _G.UseSkill_E = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "Use Skill [ B ]",
   Default = _G.UseSkill_B,
   Callback = function(Value)
      _G.UseSkill_B = Value
      saveCustomConfig()
   end,
})

Tab:AddSlider({
   Name = "Skill Delay",
   Min = 0.2,
   Max = 2.0,
   Default = _G.SkillDelay or 0.5,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 0.1,
   ValueName = "Seconds",
   Callback = function(Value)
      _G.SkillDelay = Value
      saveCustomConfig()
   end,
})

Tab:AddSection({Name = "⚙️ Farm Settings"})

Tab:AddToggle({
   Name = "Auto Quest by Level (Auto Level)",
   Default = _G.AutoLevel,
   Callback = function(Value)
      _G.AutoLevel = Value
      saveCustomConfig()
   end,
})

Tab:AddToggle({
   Name = "👑 Include Bosses in Auto Level",
   Default = _G.IncludeBosses,
   Callback = function(Value)
      _G.IncludeBosses = Value
      saveCustomConfig()
   end,
})

local allMobList = {}
for _, q in ipairs(QuestDatabase) do
    local displayName = (q.IsBoss and "👑 [BOSS] " or "👾 ") .. q.Mob .. " [Lv. " .. q.Level .. "]"
    table.insert(allMobList, displayName)
end

Tab:AddDropdown({
   Name = "Select Specific Target Mob",
   Default = allMobList[1],
   Options = allMobList,
   Callback = function(selected)
      for _, q in ipairs(QuestDatabase) do
          local displayName = (q.IsBoss and "👑 [BOSS] " or "👾 ") .. q.Mob .. " [Lv. " .. q.Level .. "]"
          if displayName == selected then
              _G.TargetMob = q.Mob
              _G.TargetQuest = q.Quest
              _G.AutoLevel = false
              saveCustomConfig()
              break
          end
      end
   end,
})

Tab:AddSlider({
   Name = "Distance Above Target",
   Min = 4,
   Max = 15,
   Default = _G.DistanceAbove or 7.5,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 0.5,
   ValueName = "Studs",
   Callback = function(Value)
      _G.DistanceAbove = Value
      saveCustomConfig()
   end,
})

Tab:AddSlider({
   Name = "Flight Tween Speed",
   Min = 150,
   Max = 350,
   Default = _G.TweenSpeed or 250,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 10,
   ValueName = "Speed",
   Callback = function(Value)
      _G.TweenSpeed = Value
      saveCustomConfig()
   end,
})

-- [Tab 2: Auto Stats]
StatsTab:AddSection({Name = "⚙️ Stats Settings"})

StatsTab:AddSlider({
   Name = "Points Per Upgrade Cycle",
   Min = 1,
   Max = 100,
   Default = _G.StatPointsAmount or 1,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 1,
   ValueName = "Points",
   Callback = function(Value)
      _G.StatPointsAmount = Value
      saveCustomConfig()
   end,
})

StatsTab:AddSection({Name = "📈 Auto Stats Selector"})

StatsTab:AddToggle({
   Name = "💪 Auto Melee (Combat)",
   Default = _G.AutoMelee,
   Callback = function(Value)
      _G.AutoMelee = Value
      saveCustomConfig()
   end,
})

StatsTab:AddToggle({
   Name = "🛡️ Auto Defense (Health)",
   Default = _G.AutoDefense,
   Callback = function(Value)
      _G.AutoDefense = Value
      saveCustomConfig()
   end,
})

StatsTab:AddToggle({
   Name = "🗡️ Auto Sword",
   Default = _G.AutoSword,
   Callback = function(Value)
      _G.AutoSword = Value
      saveCustomConfig()
   end,
})

StatsTab:AddToggle({
   Name = "🍎 Auto Devil Fruit",
   Default = _G.AutoFruit,
   Callback = function(Value)
      _G.AutoFruit = Value
      saveCustomConfig()
   end,
})

StatsTab:AddSection({Name = "⚡ Instant Upgrade All Points"})

local function upgradeStatViaGUI(statName, times)
    times = times or 1
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    
    local statAliases = {
        ["Sword"] = {"sword", "swords", "swordstat"},
        ["Melee"] = {"combat", "melee", "combatstat", "fist"},
        ["Defense"] = {"defense", "health", "defensestat", "def"},
        ["Fruit"] = {"fruit", "devilfruit", "power"}
    }
    local targets = statAliases[statName] or {string.lower(statName)}

    -- 1. Try In-Game Remote Functions
    pcall(function()
        local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("Functions") then
            if remotes.Functions:FindFirstChild("UpgradeStat") then
                remotes.Functions.UpgradeStat:InvokeServer(statName, times)
            elseif remotes.Functions:FindFirstChild("StatsFunction") then
                remotes.Functions.StatsFunction:InvokeServer("Upgrade", statName, times)
            end
        end
    end)

    -- 2. GUI Clicker fallback
    if pgui then
        pcall(function()
            local mainGui = pgui:FindFirstChild("MainGui") or pgui
            for _, btn in ipairs(mainGui:GetDescendants()) do
                if btn:IsA("GuiButton") and btn.Visible then
                    local bName = string.lower(btn.Name)
                    local pName = string.lower(btn.Parent and btn.Parent.Name or "")
                    local isMatch = false
                    if not string.find(pName, "shop") and not string.find(pName, "setting") and not string.find(pName, "inventory") then
                        for _, alias in ipairs(targets) do
                            if (string.find(bName, alias) or string.find(pName, alias)) and (string.find(bName, "add") or string.find(bName, "plus") or string.find(bName, "button") or string.find(bName, "btn") or bName == "button") then
                                isMatch = true
                                break
                            end
                        end
                    end
                    if isMatch then
                        for i = 1, times do
                            if firesignal then
                                firesignal(btn.MouseButton1Click)
                                firesignal(btn.Activated)
                            end
                            pcall(function() btn.MouseButton1Click:Fire() end)
                        end
                        return
                    end
                end
            end
        end)
    end
end

local function manualUpgrade(statName)
    local points = 0
    pcall(function()
        if LocalPlayer:FindFirstChild("PlayerStats") and LocalPlayer.PlayerStats:FindFirstChild("Points") then
            points = tonumber(LocalPlayer.PlayerStats.Points.Value) or 0
        end
    end)
    if points > 0 then
        upgradeStatViaGUI(statName, points)
        OrionLib:MakeNotification({
            Name = "📊 Stats Upgraded",
            Content = "Added all " .. points .. " points into " .. statName .. "!",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    else
        OrionLib:MakeNotification({
            Name = "⚠️ No Available Points",
            Content = "You have 0 available stat points.",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

StatsTab:AddButton({
   Name = "💪 Add All Points to Melee",
   Callback = function() manualUpgrade("Melee") end,
})

StatsTab:AddButton({
   Name = "🛡️ Add All Points to Defense",
   Callback = function() manualUpgrade("Defense") end,
})

StatsTab:AddButton({
   Name = "🗡️ Add All Points to Sword",
   Callback = function() manualUpgrade("Sword") end,
})

StatsTab:AddButton({
   Name = "🍎 Add All Points to Fruit",
   Callback = function() manualUpgrade("Fruit") end,
})

-- [Tab 3: Island Teleports]
local IslandLocations = {
    ["🏝️ Starter Island"] = CFrame.new(-2076, 49, -4562),
    ["🎪 Pirate Island (Buggy)"] = CFrame.new(-685, 44, -3446),
    ["🦈 Fishman Island"] = CFrame.new(-1716, 40, 6315),
    ["🍳 Baratie Island"] = CFrame.new(-4149, 17, -3063),
    ["❄️ Snow Island"] = CFrame.new(-5436, 29, -1297),
    ["🏜️ Desert Island"] = CFrame.new(-2743, 42, -752),
    ["☁️ Sky Island"] = CFrame.new(-4322, 384, 1243),
    ["⚓ Marine Island"] = CFrame.new(1533, 19, 944),
    ["🏛️ Naval Base (Enies Lobby)"] = CFrame.new(-1215, 21, 2103),
    ["🧟 Zombie Island (Thriller Bark)"] = CFrame.new(-2806, 20, 4238),
    ["⚔️ War Island (Marineford)"] = CFrame.new(2402, 56, -1822)
}

local islandList = {}
for name, _ in pairs(IslandLocations) do
    table.insert(islandList, name)
end

TeleportTab:AddDropdown({
   Name = "Select Target Island",
   Default = islandList[1],
   Options = islandList,
   Callback = function(selected)
      local targetCF = IslandLocations[selected]
      if targetCF then
         local char = LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = targetCF + Vector3.new(0, 10, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
            char.HumanoidRootPart.RotVelocity = Vector3.zero
            OrionLib:MakeNotification({
               Name = "🚀 Teleported",
               Content = "Arrived at " .. selected .. "!",
               Image = "rbxassetid://4483362458",
               Time = 3
            })
         end
      end
   end,
})

TeleportTab:AddSection({Name = "⚡ Quick Island Teleports"})

for name, cf in pairs(IslandLocations) do
    TeleportTab:AddButton({
       Name = name,
       Callback = function()
          local char = LocalPlayer.Character
          if char and char:FindFirstChild("HumanoidRootPart") then
             char.HumanoidRootPart.CFrame = cf + Vector3.new(0, 10, 0)
             char.HumanoidRootPart.Velocity = Vector3.zero
             char.HumanoidRootPart.RotVelocity = Vector3.zero
             OrionLib:MakeNotification({
                Name = "🚀 Teleported",
                Content = "Arrived at " .. name .. "!",
                Image = "rbxassetid://4483362458",
                Time = 2
             })
          end
       end,
    })
end

-- [Tab 4: Sea Travel]
SeaTravelTab:AddSection({Name = "🌊 Sea Travel & Quests"})

-- 9-Step Second Sea Traveler Quest Function
local function notifyStep(stepNum, stepTitle, stepDesc)
    print(string.format("📌 [Traveler Quest %d/9] %s: %s", stepNum, stepTitle, stepDesc))
    OrionLib:MakeNotification({
        Name = string.format("📌 Step %d/9: %s", stepNum, stepTitle),
        Content = stepDesc,
        Image = "rbxassetid://4483362458",
        Time = 2.5
    })
end

local function runSecondSeaTravelerQuest()
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5))
        if not hrp then return end

        local vim = game:GetService("VirtualInputManager")
        local allNpc = workspace:FindFirstChild("AllNPC")
        local traveler = allNpc and allNpc:FindFirstChild("Traveler")
        local tPos = traveler and traveler:GetPivot().Position or Vector3.new(2587.55, 96.09, -1879.06)

        OrionLib:MakeNotification({
            Name = "🚀 Second Sea Quest",
            Content = "Starting 9-step sequence automatically...",
            Image = "rbxassetid://4483362458",
            Time = 3
        })

        -- Face NPC
        hrp.CFrame = CFrame.lookAt(tPos + Vector3.new(0, 0, 2), tPos)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
        workspace.CurrentCamera.CFrame = CFrame.lookAt(tPos + Vector3.new(0, 1, 4), tPos)
        task.wait(1.5)

        local vSize = workspace.CurrentCamera.ViewportSize
        local cx = vSize.X / 2
        local cy = vSize.Y / 2

        -- 1. Click screen to interact
        notifyStep(1, "Talk to NPC", "Clicking screen center to open Traveler dialog")
        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.08)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        task.wait(0.5)

        -- 2. Zoom in (Scroll Wheel Up 5x)
        notifyStep(2, "Zoom Camera", "Zooming into NPC (Scroll Up 5 times)")
        for i = 1, 5 do
            vim:SendMouseWheelEvent(cx, cy, true, game)
            task.wait(0.05)
        end
        task.wait(0.5)

        -- 3. Send keys: \ -> S -> Enter
        notifyStep(3, "Accept Quest Keys", "Pressing [ \\ ] -> [ S ] -> [ Enter ]")
        vim:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.S, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.6)

        -- 4. Click screen to close dialog
        notifyStep(4, "Close Dialog", "Clicking screen to close quest dialog")
        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.08)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        task.wait(0.5)

        -- 5. Warp 20 studs left & press \ 1x
        notifyStep(5, "Warp 20 Studs & Press \\", "Warping 20 studs left and pressing [ \\ ] 1 time")
        local leftPos = tPos - Vector3.new(20, 0, 0)
        if traveler then
            pcall(function()
                local npcPivot = traveler:GetPivot()
                leftPos = npcPivot.Position - (npcPivot.RightVector * 20) + Vector3.new(0, 1, 0)
            end)
        end
        hrp.CFrame = CFrame.new(leftPos)
        hrp.Velocity = Vector3.zero
        task.wait(0.5)

        vim:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.4)

        -- 6. Warp back to quest NPC
        notifyStep(6, "Warp Back to NPC", "Returning to Traveler NPC position")
        local frontPos = tPos + Vector3.new(0, 0, 2)
        hrp.CFrame = CFrame.lookAt(frontPos, tPos)
        hrp.Velocity = Vector3.zero
        workspace.CurrentCamera.CFrame = CFrame.lookAt(tPos + Vector3.new(0, 1, 4), tPos)
        task.wait(1.0)

        -- 7. Click screen to talk
        notifyStep(7, "Turn In Quest", "Clicking screen to open turn-in dialog")
        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.08)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        task.wait(0.5)

        -- 8. Zoom in (Scroll Wheel Up 5x)
        notifyStep(8, "Zoom Camera", "Zooming into NPC (Scroll Up 5 times)")
        for i = 1, 5 do
            vim:SendMouseWheelEvent(cx, cy, true, game)
            task.wait(0.05)
        end
        task.wait(0.5)

        -- 9. Send keys: \ -> S -> D (3x) -> A (1x) -> Enter
        notifyStep(9, "Submit Quest", "Pressing [ \\ ] -> [ S ] -> [ D (3x) ] -> [ A (1x) ] -> [ Enter ]")
        vim:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.S, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        task.wait(0.15)

        for i = 1, 3 do
            vim:SendKeyEvent(true, Enum.KeyCode.D, false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.D, false, game)
            task.wait(0.15)
        end

        vim:SendKeyEvent(true, Enum.KeyCode.A, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.A, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.4)

        -- Zoom out
        for i = 1, 10 do
            vim:SendMouseWheelEvent(cx, cy, false, game)
            task.wait(0.04)
        end

        OrionLib:MakeNotification({
            Name = "🎉 Quest Completed!",
            Content = "Traveler Second Sea quest completed successfully 100%!",
            Image = "rbxassetid://4483362458",
            Time = 5
        })
    end)
end

-- Function to talk to Elite Pirate to travel to Sea 2
local function talkToElitePirateSea2()
    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 5))
        if not hrp then return end

        local vim = game:GetService("VirtualInputManager")
        local allNpc = workspace:FindFirstChild("AllNPC")
        local elite = allNpc and (allNpc:FindFirstChild("Elite Pirate") or allNpc:FindFirstChild("ElitePirate") or allNpc:FindFirstChild("Traveler"))
        local ePos = elite and elite:GetPivot().Position or Vector3.new(2402, 56, -1822)

        OrionLib:MakeNotification({
            Name = "🏴‍☠️ Elite Pirate",
            Content = "Interacting with Elite Pirate to travel to Sea 2...",
            Image = "rbxassetid://4483362458",
            Time = 3
        })

        -- Move and face Elite Pirate NPC
        hrp.CFrame = CFrame.lookAt(ePos + Vector3.new(0, 0, 2), ePos)
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
        workspace.CurrentCamera.CFrame = CFrame.lookAt(ePos + Vector3.new(0, 1, 4), ePos)
        task.wait(1.2)

        local vSize = workspace.CurrentCamera.ViewportSize
        local cx = vSize.X / 2
        local cy = vSize.Y / 2

        -- Step 1: Click screen to talk
        notifyStep(1, "Talk to Elite Pirate", "Clicking screen center to open dialog")
        vim:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
        task.wait(0.08)
        vim:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
        task.wait(0.5)

        -- Step 2: Zoom in (Scroll Up 5x)
        notifyStep(2, "Zoom Camera", "Zooming into NPC (Scroll Up 5 times)")
        for i = 1, 5 do
            vim:SendMouseWheelEvent(cx, cy, true, game)
            task.wait(0.05)
        end
        task.wait(0.5)

        -- Step 3: Send keys: \ -> S -> D (3x) -> A (1x) -> Enter
        notifyStep(3, "Submit Travel Keys", "Pressing [ \\ ] -> [ S ] -> [ D (3x) ] -> [ A (1x) ] -> [ Enter ]")
        vim:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.S, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.S, false, game)
        task.wait(0.15)

        for i = 1, 3 do
            vim:SendKeyEvent(true, Enum.KeyCode.D, false, game)
            task.wait(0.1)
            vim:SendKeyEvent(false, Enum.KeyCode.D, false, game)
            task.wait(0.15)
        end

        vim:SendKeyEvent(true, Enum.KeyCode.A, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.A, false, game)
        task.wait(0.15)

        vim:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait(0.4)

        -- Zoom out
        for i = 1, 10 do
            vim:SendMouseWheelEvent(cx, cy, false, game)
            task.wait(0.04)
        end

        OrionLib:MakeNotification({
            Name = "🌊 Sent Travel Request!",
            Content = "Elite Pirate interaction complete. Traveling to Second Sea!",
            Image = "rbxassetid://4483362458",
            Time = 5
        })
    end)
end

SeaTravelTab:AddSection({Name = "🤖 Auto Progression to Sea 2 (Smart Level & Map Check)"})

local sea2Conf = _G.Settings_Farm["Auto_Advance_Sea2"] or {
    ["Enabled"] = true,
    ["Level_Requirement"] = 2200,
    ["Require_Map_Item"] = true,
    ["Auto_Execute_Traveler_Quest"] = true,
    ["Auto_Travel_To_Sea2"] = true
}

SeaTravelTab:AddToggle({
    Name = "🤖 Enable Auto Advance to Sea 2 (Lv. 2200 + Map)",
    Default = sea2Conf["Enabled"] ~= nil and sea2Conf["Enabled"] or true,
    Callback = function(Value)
        _G.Settings_Farm["Auto_Advance_Sea2"]["Enabled"] = Value
        saveCustomConfig()
    end
})

SeaTravelTab:AddButton({
    Name = "🔍 Check Sea 2 Status (Level & Map Verification)",
    Callback = function()
        local cLvl = getPlayerLevel() or 1
        local hasMap = hasMapItem()
        local reqLvl = tonumber(_G.Settings_Farm["Auto_Advance_Sea2"]["Level_Requirement"]) or 2200
        local isReady = (cLvl >= reqLvl) and (not _G.Settings_Farm["Auto_Advance_Sea2"]["Require_Map_Item"] or hasMap)

        OrionLib:MakeNotification({
            Name = isReady and "✅ Ready for Sea 2!" or "⏳ Sea 2 Incomplete",
            Content = string.format("Level: %d / %d | Map: %s\nStatus: %s", 
                cLvl, reqLvl, 
                hasMap and "✅ Found" or "❌ Missing", 
                isReady and "Ready to Advance!" or "Still Farming..."),
            Image = "rbxassetid://4483362458",
            Time = 5
        })
    end
})

SeaTravelTab:AddSection({Name = "⚡ Manual Sea Travel & Quests"})

SeaTravelTab:AddButton({
    Name = "🔥 Traveler Quest Sea 2 (Auto 9 Steps Sequence)",
    Callback = function()
        runSecondSeaTravelerQuest()
    end
})

SeaTravelTab:AddButton({
    Name = "🏴‍☠️ Talk to Elite Pirate (Travel to Sea 2)",
    Callback = function()
        talkToElitePirateSea2()
    end
})

SeaTravelTab:AddButton({
    Name = "⚡ Instant Direct Travel Sea 2",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "🌊 Travel to Sea 2",
            Content = "Teleporting character to Second Sea...",
            Image = "rbxassetid://4483362458",
            Time = 4
        })
        pcall(function()
            local etc = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest.Remotes.Functions:FindFirstChild("EtcFunction")
            if etc then
                etc:InvokeServer("TeleportToSecondSea")
                etc:InvokeServer("TravelSea2")
            end
        end)
        task.wait(0.5)
        pcall(function()
            game:GetService("TeleportService"):Teleport(4520749081, LocalPlayer)
        end)
    end
})

SeaTravelTab:AddButton({
    Name = "🌌 Instant Direct Travel Sea 3",
    Callback = function()
        pcall(function()
            local etc = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest.Remotes.Functions:FindFirstChild("EtcFunction")
            if etc then
                etc:InvokeServer("TeleportToThirdSea")
                etc:InvokeServer("TravelSea3")
            end
            OrionLib:MakeNotification({
                Name = "🌌 Travel to Sea 3",
                Content = "Teleporting character to Third Sea...",
                Image = "rbxassetid://4483362458",
                Time = 4
            })
        end)
    end
})

-- Smart Auto Progression Background Watchdog
local sea2AdvancementTriggered = false
task.spawn(function()
    while task.wait(4) do
        local advConf = _G.Settings_Farm["Auto_Advance_Sea2"]
        if advConf and advConf["Enabled"] and not sea2AdvancementTriggered then
            local curLvl = getPlayerLevel() or 1
            local targetLvl = tonumber(advConf["Level_Requirement"]) or 2200
            local needsMap = advConf["Require_Map_Item"]
            local gotMap = hasMapItem()

            if curLvl >= targetLvl then
                if not needsMap or gotMap then
                    sea2AdvancementTriggered = true
                    print(string.format("🎉 [AUTO PROGRESSION] Player reached Lv.%d & has Map! Starting Second Sea quest...", curLvl))
                    OrionLib:MakeNotification({
                        Name = "🌊 Auto Sea 2 Progression",
                        Content = string.format("Level %d reached & Map verified! Starting Second Sea quest now...", curLvl),
                        Image = "rbxassetid://4483362458",
                        Time = 6
                    })

                    -- Pause normal farm
                    _G.AutoFarm = false
                    stopAutoFarm()
                    task.wait(1.5)

                    -- Run 9-step Traveler quest
                    if advConf["Auto_Execute_Traveler_Quest"] then
                        runSecondSeaTravelerQuest()
                        task.wait(12)
                    end

                    -- Talk to Elite Pirate to travel
                    if advConf["Auto_Travel_To_Sea2"] then
                        task.wait(2)
                        talkToElitePirateSea2()
                    end
                end
            end
        end
    end
end)

-- Auto-Trigger Sea Quests from Config (Manual overrides)
task.spawn(function()
    task.wait(3)
    if _G.Quests_Settings["Auto_Traveler_Quest_Sea2"] then
        runSecondSeaTravelerQuest()
    elseif _G.Quests_Settings["Auto_Elite_Pirate_Travel"] then
        talkToElitePirateSea2()
    elseif _G.Quests_Settings["Auto_Travel_Sea3"] then
        pcall(function()
            local etc = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest.Remotes.Functions:FindFirstChild("EtcFunction")
            if etc then
                etc:InvokeServer("TeleportToThirdSea")
                etc:InvokeServer("TravelSea3")
            end
        end)
    end
end)

-- [Tab 5: Sea Events]


SeaEventsTab:AddSection({Name = "🐉 Sea Events Auto Hunter"})

SeaEventsTab:AddToggle({
    Name = "👑 Auto Sea King",
    Default = _G.AutoSeaKing,
    Callback = function(Value)
        _G.AutoSeaKing = Value
        saveCustomConfig()
    end
})

SeaEventsTab:AddToggle({
    Name = "🚢 Auto Ghost Ship",
    Default = _G.AutoGhostShip,
    Callback = function(Value)
        _G.AutoGhostShip = Value
        saveCustomConfig()
    end
})

SeaEventsTab:AddToggle({
    Name = "🐍 Auto Sea Serpent / Hydra",
    Default = _G.AutoSeaSerpent,
    Callback = function(Value)
        _G.AutoSeaSerpent = Value
        saveCustomConfig()
    end
})

SeaEventsTab:AddSection({Name = "🛡️ Safety & Server Tools"})



SeaEventsTab:AddToggle({
    Name = "🚑 Auto Escape Low HP (Below 25%)",
    Default = _G.AutoEscapeLowHP,
    Callback = function(Value)
        _G.AutoEscapeLowHP = Value
        saveCustomConfig()
    end
})

SeaEventsTab:AddButton({
    Name = "🔄 Rejoin Current Server",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "🔄 Rejoining Server",
            Content = "Reconnecting to current server...",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
        task.wait(0.5)
        pcall(function()
            local ts = game:GetService("TeleportService")
            if #game:GetService("Players"):GetPlayers() <= 1 then
                LocalPlayer:Kick("\n[Auto Rejoin] Rejoining server...")
                task.wait(0.5)
                ts:Teleport(game.PlaceId, LocalPlayer)
            else
                ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)
    end
})

SeaEventsTab:AddButton({
    Name = "🌐 Random Server Hop",
    Callback = function()
        pcall(function()
            local ts = game:GetService("TeleportService")
            local http = game:GetService("HttpService")
            local placeId = game.PlaceId
            local servers = http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=50"))
            if servers and servers.data then
                for _, s in ipairs(servers.data) do
                    if s.playing and s.playing < s.maxPlayers and s.id ~= game.JobId then
                        ts:TeleportToPlaceInstance(placeId, s.id, LocalPlayer)
                        break
                    end
                end
            end
        end)
    end
})

-- [Tab 6: Shop & Skills]
local function buyFromNPC(npcCode, displayName)
    pcall(function()
        local npc = workspace:FindFirstChild("AllNPC") and workspace.AllNPC:FindFirstChild(npcCode)
        local char = LocalPlayer.Character
        if npc and char and char:FindFirstChild("HumanoidRootPart") then
            local pivot = npc:GetPivot()
            char.HumanoidRootPart.CFrame = pivot + Vector3.new(0, 3, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
            char.HumanoidRootPart.RotVelocity = Vector3.zero
        end
        
        task.delay(0.2, function()
            pcall(function()
                local dialogueModule = require(LocalPlayer.PlayerGui.MainGui.Dialogue.DialogueModule)
                if dialogueModule and dialogueModule.Init then
                    dialogueModule.Init(npcCode)
                end
            end)
        end)
    end)
end

local function equipFightingStyle(styleName, isV2)
    pcall(function()
        local remote = game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction
        local remoteMethod = isV2 and "EquipFightingStyleV2" or "EquipFightingStyle"
        remote:InvokeServer(remoteMethod, { FightingStyleName = styleName })
    end)
end

ShopTab:AddSection({Name = "🛍️ Buy Fighting Styles"})

local buyStyles = {
    { Name = "🔥 Dark Leg ($150k)", Code = "DarkLegShop" },
    { Name = "🦾 Cyborg ($1M)", Code = "CyborgShop" },
    { Name = "🌊 Water Style ($1.5M)", Code = "WaterStyleShop" },
    { Name = "🐉 Dragon Claw ($1.25M)", Code = "DragonClawShop" },
}

for _, bs in ipairs(buyStyles) do
    ShopTab:AddButton({
        Name = bs.Name,
        Callback = function()
            buyFromNPC(bs.Code, bs.Name)
        end
    })
end

ShopTab:AddSection({Name = "🛡️ Buy Haki & Skills"})

local buyHakis = {
    { Name = "🖤 Busoshoku Haki ($500k)", Code = "BusoShop" },
    { Name = "👁️ Kenbunshoku Haki ($1.5M)", Code = "KenShop" },
    { Name = "⚡ Soru / Flash Step ($100k)", Code = "SoruShop" },
    { Name = "🎨 Random Armament Shade", Code = "ARandomArmamentShade" }
}

for _, bh in ipairs(buyHakis) do
    ShopTab:AddButton({
        Name = bh.Name,
        Callback = function()
            buyFromNPC(bh.Code, bh.Name)
        end
    })
end

ShopTab:AddSection({Name = "🗡️ Buy Swords & Upgrades"})

ShopTab:AddButton({
    Name = "⚔️ Open Sword Shop",
    Callback = function()
        buyFromNPC("SwordShop", "Sword Shop")
    end
})

ShopTab:AddButton({
    Name = "🔨 Blacksmith (Upgrade Weapon)",
    Callback = function()
        buyFromNPC("Blacksmith", "Blacksmith")
    end
})

ShopTab:AddSection({Name = "🍎 Devil Fruit & Utility"})

ShopTab:AddButton({
    Name = "🎲 Random Devil Fruit (NPC)",
    Callback = function()
        buyFromNPC("ARandomFruit", "Random Fruit")
    end
})

ShopTab:AddButton({
    Name = "🛒 Devil Fruit Shop",
    Callback = function()
        buyFromNPC("DFruitShop", "DFruit Shop")
    end
})

ShopTab:AddButton({
    Name = "🗑️ Remove Current Fruit Power",
    Callback = function()
        buyFromNPC("A Fruit Remover", "Fruit Remover")
    end
})

ShopTab:AddButton({
    Name = "🔄 Reset Stats Shop",
    Callback = function()
        buyFromNPC("ResetStatsShop", "Reset Stats")
    end
})

ShopTab:AddButton({
    Name = "🧬 Reroll Race with Gems",
    Callback = function()
        buyFromNPC("RaceRerollsGem", "Race Rerolls")
    end
})

ShopTab:AddSection({Name = "🥋 Instant Equip Fighting Styles"})

local allFightingStyles = {
    { Name = "🔥 Dark Leg", Code = "DarkLeg" },
    { Name = "🦾 Cyborg", Code = "Cyborg" },
    { Name = "🌊 Water Style", Code = "WaterStyle" },
    { Name = "🐉 Dragon Claw", Code = "DragonClaw" },
    { Name = "⚡ Electro", Code = "Electro" },
    { Name = "⚽ Striker", Code = "Striker" },
    { Name = "🃏 Trickster", Code = "Trickster" },
    { Name = "🌪️ Gale Fist", Code = "GaleFist" },
    { Name = "⚖️ Justice Fist", Code = "JusticeFist" }
}

for _, fs in ipairs(allFightingStyles) do
    ShopTab:AddButton({
        Name = "Equip: " .. fs.Name,
        Callback = function()
            equipFightingStyle(fs.Code, false)
        end
    })
end

-- [Tab 7: Configs & Presets]
ConfigTab:AddSection({Name = "⚡ 1-Click Fast Presets (God Mode)"})

ConfigTab:AddButton({
    Name = "🚀 Fast Auto Level Farm (All-in-One)",
    Callback = function()
        _G.AutoFarm = true
        _G.AutoLevel = true
        _G.IncludeBosses = true
        _G.AutoSkill = true
        _G.UseSkill_Z = true
        _G.UseSkill_X = true
        _G.UseSkill_C = true
        _G.AutoMelee = true
        _G.AutoDefense = true
        saveCustomConfig()
        OrionLib:MakeNotification({
            Name = "🚀 Fast Auto Level",
            Content = "Preset Activated: Auto Farm + Level + Skills + Stats Enabled!",
            Image = "rbxassetid://4483362458",
            Time = 4
        })
    end
})

ConfigTab:AddButton({
    Name = "🗡️ Sword Master Preset (Sword Farm + Stats)",
    Callback = function()
        _G.AutoFarm = true
        _G.AutoLevel = true
        _G.AutoSword = true
        _G.AutoSkill = true
        _G.UseSkill_Z = true
        _G.UseSkill_X = true
        saveCustomConfig()
        OrionLib:MakeNotification({
            Name = "🗡️ Sword Master",
            Content = "Preset Activated: Sword Auto Farm + Sword Stats Enabled!",
            Image = "rbxassetid://4483362458",
            Time = 4
        })
    end
})

ConfigTab:AddButton({
    Name = "🐉 Sea Events Hunter Preset",
    Callback = function()
        _G.AutoSeaKing = true
        _G.AutoGhostShip = true
        _G.AutoSeaSerpent = true
        _G.AutoEscapeLowHP = true
        _G.AutoSkill = true
        saveCustomConfig()
        OrionLib:MakeNotification({
            Name = "🐉 Sea Events Hunter",
            Content = "Preset Activated: Sea King + Ghost Ship + Hydra Hunter Enabled!",
            Image = "rbxassetid://4483362458",
            Time = 4
        })
    end
})

ConfigTab:AddButton({
    Name = "🛑 Stop All (Instant Farm Disable)",
    Callback = function()
        stopAutoFarm()
        _G.AutoSeaKing = false
        _G.AutoGhostShip = false
        _G.AutoSeaSerpent = false
        _G.AutoMelee = false
        _G.AutoDefense = false
        _G.AutoSword = false
        _G.AutoFruit = false
        saveCustomConfig()
        OrionLib:MakeNotification({
            Name = "🛑 Stopped All",
            Content = "All auto farming & hunting modes turned off.",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end
})

ConfigTab:AddSection({Name = "💾 Config Profile Management"})

ConfigTab:AddButton({
    Name = "💾 Save Current Settings as Default Profile",
    Callback = function()
        saveCustomConfig()
        OrionLib:MakeNotification({
            Name = "💾 Config Saved",
            Content = "Saved current settings to KingLegacy_CleanConfig.json!",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end
})

ConfigTab:AddButton({
    Name = "📂 Load Saved Default Profile",
    Callback = function()
        loadCustomConfig()
        OrionLib:MakeNotification({
            Name = "📂 Config Restored",
            Content = "Restored settings from KingLegacy_CleanConfig.json!",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end
})

-- ========================================================
-- ⚡ FPS CONFIG PERSISTENT STORAGE
-- ========================================================
local function saveFPSConfig(fpsVal, dropdownText)
    pcall(function()
        if writefile then
            local HttpService = game:GetService("HttpService")
            local data = {
                FPS = fpsVal,
                DropdownText = dropdownText
            }
            writefile("KingLegacy_FPS_Config.json", HttpService:JSONEncode(data))
        end
    end)
end

local function loadSavedFPSConfig()
    local savedFPS = 60
    local savedText = "60 FPS (ลื่นไหลปกติ)"
    pcall(function()
        if isfile and readfile and isfile("KingLegacy_FPS_Config.json") then
            local HttpService = game:GetService("HttpService")
            local content = readfile("KingLegacy_FPS_Config.json")
            if content and #content > 0 then
                local data = HttpService:JSONDecode(content)
                if data and data.FPS then
                    savedFPS = tonumber(data.FPS) or 60
                    savedText = data.DropdownText or (tostring(savedFPS) .. " FPS")
                end
            end
        end
    end)
    return savedFPS, savedText
end

local initialSavedFPS, initialSavedFPSText = loadSavedFPSConfig()
pcall(function()
    if setfpscap then
        setfpscap(initialSavedFPS)
    end
end)

ConfigTab:AddSection({Name = "⚡ FPS Limiter (ลดแลค & ประหยัด CPU)"})

ConfigTab:AddDropdown({
    Name = "Select Max FPS (จำกัด FPS)",
    Default = initialSavedFPSText,
    Options = {
        "15 FPS (ประหยัดพลังงานสูงสุด / จอเบา)",
        "30 FPS (ปานกลาง / ประหยัด CPU)",
        "60 FPS (ลื่นไหลปกติ)"
    },
    Callback = function(Value)
        local fps = 60
        if string.find(Value, "15") then
            fps = 15
        elseif string.find(Value, "30") then
            fps = 30
        elseif string.find(Value, "60") then
            fps = 60
        end
        _G.TargetFPS = fps
        pcall(function()
            if setfpscap then
                setfpscap(fps)
            end
        end)
        saveFPSConfig(fps, Value)
        OrionLib:MakeNotification({
            Name = "⚡ FPS Limiter",
            Content = "Saved & set Game FPS cap to " .. tostring(fps) .. " FPS!",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end
})



-- 5.3 ตรวจสอบว่ามีเควสที่ตรงกับเป้าหมายอยู่หรือไม่ (อ่านตรงจาก LocalPlayer.CurrentQuest 100%)
local function isQuestActive()
    if LocalPlayer:FindFirstChild("CurrentQuest") then
        local qVal = tostring(LocalPlayer.CurrentQuest.Value)
        if qVal ~= "" and qVal ~= "None" then
            if _G.TargetMob and string.find(string.lower(qVal), string.lower(_G.TargetMob)) then
                return true
            end
            if _G.TargetQuest and string.find(string.lower(qVal), string.lower(_G.TargetQuest)) then
                return true
            end
            return false
        end
    end

    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return false end
    for _, label in ipairs(gui:GetDescendants()) do
        if label:IsA("TextLabel") and label.Visible and string.find(string.upper(label.Text), "PROGRESS") then
            local container = (label.Parent and label.Parent.Parent) or label.Parent
            if container and _G.TargetMob then
                for _, sub in ipairs(container:GetDescendants()) do
                    if sub:IsA("TextLabel") and sub ~= label then
                        if isMobNameMatching(sub.Text, _G.TargetMob) or string.find(string.lower(sub.Text), string.lower(_G.TargetMob)) then
                            return true
                        end
                    end
                end
            end
            return false
        end
    end
    return false
end



-- 5.5 ค้นหามอนสเตอร์และบอส (ค้นหาเฉพาะมอนสเตอร์ที่ตรงตามเควส 100% ไม่ตีมั่ว)
findMonster = function(mobKeyword)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    if not mobKeyword or mobKeyword == "" then return nil end

    local bestEnemy = nil
    local minDistance = math.huge

    local function checkModel(mob)
        if not mob or not mob:IsA("Model") then return end
        if mob == char then return end
        if Players:GetPlayerFromCharacter(mob) then return end
        
        local hrp = mob:FindFirstChild("HumanoidRootPart") 
            or mob:FindFirstChild("Torso") 
            or mob:FindFirstChild("UpperTorso") 
            or mob.PrimaryPart 
            or mob:FindFirstChild("Head") 
            or mob:FindFirstChildOfClass("BasePart")
            
        local hum = mob:FindFirstChildOfClass("Humanoid")
        
        if isMobNameMatching(mob.Name, mobKeyword) then
            if hrp then
                lastKnownMobCFrame = hrp.CFrame
                local isAlive = (hum and hum.Health > 0) or (not hum and mob.Parent ~= nil)
                if isAlive then
                    local dist = (myPos - hrp.Position).Magnitude
                    if dist < minDistance then
                        minDistance = dist
                        bestEnemy = { Root = hrp, Hum = hum, Model = mob }
                    end
                end
            end
        end
    end

    -- 1. ตรวจใน Workspace.Monster
    local monsterRoot = workspace:FindFirstChild("Monster") or workspace:FindFirstChild("MONSTER") or workspace:FindFirstChild("Mob") or workspace:FindFirstChild("Enemies")
    if monsterRoot then
        for _, child in ipairs(monsterRoot:GetDescendants()) do
            if child:IsA("Model") then
                checkModel(child)
            end
        end
    end

    -- 2. ตรวจใน Workspace โดยตรง (ใช้การเทียบชื่อแบบตรงตัว 100% ปลอดภัย ไม่ตีมอนมั่ว)
    if not bestEnemy then
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                checkModel(obj)
            end
        end
    end

    -- 3. หากยังไม่พบตัว ให้ดึงพิกัดเกาะของมอนสเตอร์ตัวนั้นเพื่อบินไปรอ
    if not bestEnemy and not lastKnownMobCFrame then
        for _, q in ipairs(QuestDatabase) do
            if isMobNameMatching(q.Mob, mobKeyword) and q.Pos then
                lastKnownMobCFrame = q.Pos
                break
            end
        end
    end

    return bestEnemy
end



-- ล็อกพิกัดใน Heartbeat (วาร์ปและตรึงพิกัดแบบสมบูรณ์ 100%)
RunService.Heartbeat:Connect(function()
    if _G.AutoFarm and lockTargetCFrame then
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = lockTargetCFrame
                hrp.Velocity = Vector3.zero
                hrp.RotVelocity = Vector3.zero
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end
end)

-- 5.7 ปล่อยสกิลอัตโนมัติแบบ Hybrid Maru Engine (ยิง Remote SkillAction + Keypress Trigger 100%)
local lastSkillTime = 0
local currentSkillIndex = 1

local function useSkills(enemy)
    if not _G.AutoSkill or not enemy or not enemy.Root then return end
    local delayTime = _G.SkillDelay or 0.5
    if tick() - lastSkillTime < delayTime then return end

    local activeKeys = {}
    if _G.UseSkill_Z then table.insert(activeKeys, "Z") end
    if _G.UseSkill_X then table.insert(activeKeys, "X") end
    if _G.UseSkill_C then table.insert(activeKeys, "C") end
    if _G.UseSkill_V then table.insert(activeKeys, "V") end
    if _G.UseSkill_E then table.insert(activeKeys, "E") end
    if _G.UseSkill_B then table.insert(activeKeys, "B") end

    if #activeKeys == 0 then return end

    if currentSkillIndex > #activeKeys then
        currentSkillIndex = 1
    end

    local key = activeKeys[currentSkillIndex]
    currentSkillIndex = currentSkillIndex + 1
    lastSkillTime = tick()

    task.spawn(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            local currentTool = char:FindFirstChildOfClass("Tool")
            local toolName = (currentTool and currentTool.Name) or _G.SelectedToolName or "Tashi Blade"
            
            -- 🎯 1. AUTO TARGET LOCK-ON (หันหน้าตัวละคร, หันมุมกล้อง และล็อกเมาส์ไปที่ตัวมอนสเตอร์ 100%)
            if enemy and enemy.Root then
                local enemyPos = enemy.Root.Position
                
                -- หันตัวละครตรงเข้าหามอนสเตอร์
                hrp.CFrame = CFrame.lookAt(hrp.Position, enemyPos)
                
                -- หันมุมกล้องเล็งตรงเข้าหาเป้าหมาย
                local camera = workspace.CurrentCamera
                if camera then
                    camera.CFrame = CFrame.lookAt(camera.CFrame.Position, enemyPos)
                    
                    -- ขยับพิกัดเมาส์ไปยังตำแหน่งมอนสเตอร์บนหน้าจอแบบเป๊ะๆ
                    local screenPos, onScreen = camera:WorldToViewportPoint(enemyPos)
                    local vim = game:GetService("VirtualInputManager")
                    if vim and onScreen then
                        vim:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
                    end
                end
            end

            -- ⚡ 2. กดปุ่มสกิลผ่าน VirtualInputManager
            local vim = game:GetService("VirtualInputManager")
            if vim and Enum.KeyCode[key] then
                vim:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                task.wait(0.06)
                vim:SendKeyEvent(false, Enum.KeyCode[key], false, game)
            end

            -- 📡 3. ยิงผ่าน SkillAction Remote พร้อมส่งพิกัดล็อกเป้าหมาย (Locked Payload)
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("Functions") and remotes.Functions:FindFirstChild("SkillAction") then
                local targetPos = (enemy and enemy.Root and enemy.Root.Position) or (hrp.Position + hrp.CFrame.LookVector * 10)
                local payload = {
                    Target = enemy and (enemy.Model or enemy.Root),
                    Hit = targetPos,
                    Position = targetPos,
                    CFrame = CFrame.lookAt(hrp.Position, targetPos),
                    Direction = (targetPos - hrp.Position).Unit
                }
                
                local lowerName = string.lower(toolName)
                if string.find(lowerName, "sword") or string.find(lowerName, "blade") or string.find(lowerName, "katana") or string.find(lowerName, "saber") or string.find(lowerName, "pole") then
                    remotes.Functions.SkillAction:InvokeServer("SW_" .. toolName .. "_" .. key, payload)
                elseif string.find(lowerName, "fruit") or string.find(lowerName, "df") then
                    remotes.Functions.SkillAction:InvokeServer("DF_" .. toolName .. "_" .. key, payload)
                elseif string.find(lowerName, "combat") or string.find(lowerName, "fist") or string.find(lowerName, "leg") or string.find(lowerName, "style") then
                    remotes.Functions.SkillAction:InvokeServer("FS_" .. toolName .. "_" .. key, payload)
                else
                    remotes.Functions.SkillAction:InvokeServer(toolName .. "_" .. key, payload)
                end
            end
        end)
    end)
end

-- ========================================================
-- 🛡️ ระบบเสริมสำหรับการเปิดฟาร์มระยะยาว (Long-Session Farm Engine)
-- ========================================================

-- 1. ระบบป้องกันการถูกเตะเมื่อ AFK 20 นาที (Anti-AFK 100%)
pcall(function()
    LocalPlayer.Idled:Connect(function()
        local vu = game:GetService("VirtualUser")
        if vu then
            vu:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- 2. ระบบเปิดฮาคิเกราะค้างตลอดเวลา (Permanent One-Time Armament per Spawn 100%)
local busoActivatedForThisLife = false

local function forceEnableBuso()
    task.spawn(function()
        pcall(function()
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("Events") and remotes.Events:FindFirstChild("Armament") then
                remotes.Events.Armament:FireServer()
                remotes.Events.Armament:FireServer(true)
                remotes.Events.Armament:FireServer("Buso")
            end
        end)
    end)
end

-- เปิดฮาคิเกราะทันทีเมื่อเกิดใหม่ทุกครั้ง (เปิด 1 ครั้งตอนเกิด และเปิดค้างตลอดชีวิต)
local function onCharSpawn(char)
    busoActivatedForThisLife = false
    task.spawn(function()
        task.wait(1.5) -- รอตัวละครและเอฟเฟกต์โหลดเสร็จสมบูรณ์
        if not busoActivatedForThisLife then
            forceEnableBuso()
            busoActivatedForThisLife = true
        end
    end)
end

if LocalPlayer.Character then
    onCharSpawn(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharSpawn)

-- 5.8 ระบบ Fast Attack แท้จริงแบบ Maru Hub 100% (SkillAction M1 Remote Execution - Network Optimized)
local lastAttack = 0
doAttack = function(enemy)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end

    if not busoActivatedForThisLife then
        forceEnableBuso()
        busoActivatedForThisLife = true
    end

    -- 1. ระบบจัดการอาวุธตามที่ผู้เล่นเลือกหรือถือในมือ (รองรับทั้งหมัดและดาบ 100%)
    local currentTool = char:FindFirstChildOfClass("Tool")
    local bp = LocalPlayer:FindFirstChild("Backpack")
    
    if not currentTool and bp then
        if _G.SelectedToolName and _G.SelectedToolName ~= "AUTO_ANY" then
            local selectedTool = bp:FindFirstChild(_G.SelectedToolName)
            if selectedTool then
                char.Humanoid:EquipTool(selectedTool)
                currentTool = selectedTool
            end
        end
        if not currentTool then
            local anyTool = bp:FindFirstChildOfClass("Tool")
            if anyTool then
                char.Humanoid:EquipTool(anyTool)
                currentTool = anyTool
            end
        end
    end

    -- กำหนดเป้าหมายให้ Fast Attack Engine โจมตีในพื้นหลัง
    currentTargetEnemy = enemy

    -- ปล่อยสกิลอัตโนมัติ
    useSkills(enemy)
end

-- ========================================================
-- ⚡ MARU HUB ASYNC FAST ATTACK ENGINE (0% UI Lag / 100% Guaranteed Hit)
-- ========================================================
task.spawn(function()
    while true do
        task.wait(0.08)
        if _G.AutoFarm then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                local hum = char:FindFirstChildOfClass("Humanoid")
                
                -- 1. ตรวจสอบและถืออาวุธให้พร้อมเสมอ (ไม่บังคับเปลี่ยนหมัดเป็นดาบ)
                local tool = char:FindFirstChildOfClass("Tool")
                if not tool and hum then
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then
                        if _G.SelectedToolName and _G.SelectedToolName ~= "AUTO_ANY" then
                            local sTool = bp:FindFirstChild(_G.SelectedToolName)
                            if sTool then
                                hum:EquipTool(sTool)
                                tool = sTool
                            end
                        end
                        if not tool then
                            local anyTool = bp:FindFirstChildOfClass("Tool")
                            if anyTool then
                                hum:EquipTool(anyTool)
                                tool = anyTool
                            end
                        end
                    end
                end

                -- 2. โจมตีเฉพาะเป้าหมายที่ตรงตามเควส (_G.TargetMob) เท่านั้น
                local target = currentTargetEnemy
                if target and target.Root and target.Hum and target.Hum.Health > 0 then
                    if _G.TargetMob and target.Model and not isMobNameMatching(target.Model.Name, _G.TargetMob) then
                        target = nil
                    end
                else
                    target = nil
                end

                -- 3. โจมตีเป้าหมาย (ใช้โครงสร้างเดียวกับดาบ 100% ครอบคลุมทั้งหมัดและดาบ)
                if target and target.Root and target.Hum and target.Hum.Health > 0 then
                    if tool then
                        tool:Activate()
                    end

                    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Chest") and game.ReplicatedStorage.Chest:FindFirstChild("Remotes")
                    if remotes then
                        local tName = (tool and tool.Name) or "Combat"

                        if remotes:FindFirstChild("Events") then
                            if remotes.Events:FindFirstChild("SwordM1") then
                                remotes.Events.SwordM1:FireServer()
                            end
                            if remotes.Events:FindFirstChild("CombatM1") then
                                remotes.Events.CombatM1:FireServer()
                            end
                            if remotes.Events:FindFirstChild("Hit") then
                                remotes.Events.Hit:FireServer(target.Model or target.Root)
                            end
                        end

                        if remotes:FindFirstChild("Functions") and remotes.Functions:FindFirstChild("SkillAction") then
                            task.spawn(function()
                                pcall(function()
                                    -- ยิงแบบดาบ SW_
                                    remotes.Functions.SkillAction:InvokeServer("SW_" .. tName .. "_M1", {
                                        Target = target.Model or target.Root,
                                        Hit = target.Root.Position,
                                        Position = target.Root.Position
                                    })
                                    -- ยิงแบบหมัด FS_
                                    remotes.Functions.SkillAction:InvokeServer("FS_" .. tName .. "_M1", {
                                        Target = target.Model or target.Root,
                                        Hit = target.Root.Position,
                                        Position = target.Root.Position
                                    })
                                    remotes.Functions.SkillAction:InvokeServer("FS_Combat_M1", {
                                        Target = target.Model or target.Root,
                                        Hit = target.Root.Position,
                                        Position = target.Root.Position
                                    })
                                    remotes.Functions.SkillAction:InvokeServer("Combat_M1", {
                                        Target = target.Model or target.Root,
                                        Hit = target.Root.Position,
                                        Position = target.Root.Position
                                    })
                                end)
                            end)
                        end
                    end
                end
            end)
        end
    end
end)

-- 6. Main Farm Loop (ป้องกันสลับเป้ามั่ว: เช็คเลเวลทุก 2 วินาที ไม่ใช่ทุก frame)


task.spawn(function()
    while task.wait(0.08) do
        if _G.AutoFarm then
            pcall(function()
                -- 0. ระบบความปลอดภัย: ตรวจสอบเลือดต่ำกว่า 25% ให้หนีขึ้นฟ้าเพื่อรีเจน
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if _G.AutoEscapeLowHP and hum and hrp and hum.Health > 0 and (hum.Health / hum.MaxHealth) <= 0.25 then
                    local escapeCFrame = CFrame.new(hrp.Position.X, 1000, hrp.Position.Z)
                    flyTo(escapeCFrame)
                    return
                end

                -- 0.1 ระบบล่าบอสทะเล (Sea Events Auto Hunter: Sea King, Ghost Ship, Sea Serpent)
                local seaBossTarget = nil
                if _G.AutoSeaKing or _G.AutoGhostShip or _G.AutoSeaSerpent then
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
                            local oName = string.lower(obj.Name)
                            if (_G.AutoSeaKing and (string.find(oName, "sea king") or string.find(oName, "seaking"))) or
                               (_G.AutoGhostShip and (string.find(oName, "ghost ship") or string.find(oName, "ghostship") or string.find(oName, "ship"))) or
                               (_G.AutoSeaSerpent and (string.find(oName, "serpent") or string.find(oName, "hydra") or string.find(oName, "kraken"))) then
                                local bRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") or obj:FindFirstChild("Torso") or obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
                                local bHum = obj:FindFirstChildOfClass("Humanoid")
                                if bRoot and ((bHum and bHum.Health > 0) or (not bHum and obj.Parent ~= nil)) then
                                    seaBossTarget = { Root = bRoot, Hum = bHum, Model = obj }
                                    break
                                end
                            end
                        end
                    end
                end

                if seaBossTarget and seaBossTarget.Root then
                    local sPos = seaBossTarget.Root.Position
                    local safeHoverPos = sPos + Vector3.new(0, _G.DistanceAbove or 12, 0)
                    local targetCFrame = CFrame.lookAt(safeHoverPos, sPos)
                    flyTo(targetCFrame)
                    doAttack(seaBossTarget)
                    return
                end

                -- 1. เลือกเป้าหมายตามเลเวลปัจจุบันของผู้เล่นแบบ Real-time
                local target = getTargetByLevel()
                if target then
                    if not lockedTargetMob or lockedTargetMob ~= target.Mob then
                        lockedTargetMob = target.Mob
                        lockedTargetQuest = target.Quest
                        _G.TargetMob = target.Mob
                        _G.TargetQuest = target.Quest
                        lastKnownMobCFrame = target.Pos
                        currentTargetEnemy = nil
                        cancelMismatchQuest()
                        takeQuest(target.Quest)
                        pcall(function()
                            OrionLib:MakeNotification({
                                Name = "🎯 เปลี่ยนเป้าหมาย",
                                Content = "Lv." .. (cachedPlayerLevel or 1) .. " → " .. target.Mob .. " (" .. target.Quest .. ")",
                                Image = "rbxassetid://4483362458",
                                Time = 3
                            })
                        end)
                    end
                end

                if not _G.TargetMob or _G.TargetMob == "" then return end

                -- 2. รับเควส
                if _G.TargetQuest and not isQuestActive() then
                    takeQuest(_G.TargetQuest)
                end

                -- 3. ตีมอนสเตอร์ (วาร์ปล็อกหลังมอนสเตอร์ Safe Behind Angle มอนสเตอร์ตีไม่โดน 100%)
                if not _G.TargetMob or _G.TargetMob == "" then return end
                local enemy = findMonster(_G.TargetMob)
                if enemy and enemy.Root then
                    lastKnownMobCFrame = enemy.Root.CFrame
                    local enemyPos = enemy.Root.Position
                    local enemyLook = enemy.Root.CFrame.LookVector
                    
                    -- ลอยตัวอยู่เหนือหัว/เยื้องหลังมอนสเตอร์ในระยะฟันดาบโดน 100% (Hitbox Range < 4 studs)
                    local safeHoverPos = enemyPos - (enemyLook * 1.5) + Vector3.new(0, _G.DistanceAbove or 3.5, 0)
                    local targetCFrame = CFrame.lookAt(safeHoverPos, enemyPos)
                    flyTo(targetCFrame)
                    doAttack(enemy)
                else
                    -- มอนสเตอร์ตายแล้วยังไม่เกิด: ลอยตัวนิ่งๆ รอมอนสเตอร์เกิดที่จุดเดิม ไม่ไปตีมอนตัวอื่น
                    currentTargetEnemy = nil
                    local waitCFrame = nil
                    if lastKnownMobCFrame then
                        waitCFrame = CFrame.new(lastKnownMobCFrame.Position + Vector3.new(0, 15, 0))
                    else
                        for _, q in ipairs(QuestDatabase) do
                            if isMobNameMatching(q.Mob, _G.TargetMob) and q.Pos then
                                waitCFrame = CFrame.new(q.Pos.Position + Vector3.new(0, 15, 0))
                                break
                            end
                        end
                    end
                    if waitCFrame then
                        flyTo(waitCFrame)
                    end
                end
            end)
        end
    end
end)

-- 7. Auto Stats Loop (แม่นยำ 100% ไม่อัปสเตตัสมั่ว)
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoMelee or _G.AutoDefense or _G.AutoSword or _G.AutoFruit then
            pcall(function()
                local points = 0
                if LocalPlayer:FindFirstChild("PlayerStats") and LocalPlayer.PlayerStats:FindFirstChild("Points") then
                    points = tonumber(LocalPlayer.PlayerStats.Points.Value) or 0
                end
                
                if points > 0 then
                    local enabledStats = {}
                    if _G.AutoSword then table.insert(enabledStats, "Sword") end
                    if _G.AutoDefense then table.insert(enabledStats, "Defense") end
                    if _G.AutoMelee then table.insert(enabledStats, "Melee") end
                    if _G.AutoFruit then table.insert(enabledStats, "Fruit") end

                    if #enabledStats > 0 then
                        local limit = _G.StatPointsAmount or 10
                        local pointsPerStat = math.clamp(math.floor(points / #enabledStats), 1, limit)
                        for _, stat in ipairs(enabledStats) do
                            local curPoints = 0
                            if LocalPlayer:FindFirstChild("PlayerStats") and LocalPlayer.PlayerStats:FindFirstChild("Points") then
                                curPoints = tonumber(LocalPlayer.PlayerStats.Points.Value) or 0
                            end
                            if curPoints > 0 then
                                local toAdd = math.min(curPoints, pointsPerStat)
                                upgradeStatViaGUI(stat, toAdd)
                                task.wait(0.04)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

OrionLib:MakeNotification({
    Name = "👑 King Legacy",
    Content = "Clean Auto Farm Loaded Successfully!",
    Image = "rbxassetid://4483362458",
    Time = 4
})

OrionLib:Init()

-- ระบบเริ่มต้นการทำงานอัตโนมัติ (รอ sync เลเวลก่อนเสมอ)
task.spawn(function()
    -- รอตัวละครโหลดเสร็จ
    local t0 = tick()
    while (tick() - t0) < 15 do
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            break
        end
        task.wait(0.3)
    end
    task.wait(1.5)

    -- Sync เลเวล (รอจนได้เลเวลจริงหรือ timeout 5 วินาที)
    ensureAccuratePlayerLevel()
    task.wait(0.3)

    -- ตรวจสอบเลเวลที่ได้จริง
    local realLevel = getPlayerLevel() or 1
    cachedPlayerLevel = realLevel

    -- รีเซ็ตสถานะทั้งหมดก่อนเริ่ม
    lockedTargetMob = nil
    lockedTargetQuest = nil
    lastKnownMobCFrame = nil
    currentTargetEnemy = nil
    lockTargetCFrame = nil

    -- เปิด Auto Farm ผ่าน Toggle (จะยิง Callback พร้อมเลเวลที่ถูกต้อง)
    _G.AutoFarm = true
    _G.AutoLevel = true
    if autoFarmToggle then
        -- ต้องตั้งเป็น false ก่อนแล้วค่อย true เพื่อให้ Callback ยิงใหม่แน่นอน
        pcall(function() autoFarmToggle:Set(false) end)
        task.wait(0.1)
        pcall(function() autoFarmToggle:Set(true) end)
    end
end)
