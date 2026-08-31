-- ========================================================
-- 🐣 CHICKEN FARM PRO AUTO FARM ENGINE (BASE ONLY + MULTIPLIER + CASH MODES)
-- Game: Chicken Farm 🐣 (PlaceId: 137233438285284)
-- ========================================================
if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")

-- ========================================================
-- ⚙️ CONFIGURATION SETTINGS
-- ========================================================
_G.ChickenFarmConfig = {
    ["AutoFarmLoop"] = true,
    ["WalkSpeed"] = 32,
    ["AutoDepositEggs"] = true,
    ["OnlyDepositOnTargetMultiplier"] = true,
    ["TargetDepositMultiplier"] = 1.30,
    ["CollectCashMode"] = "Every X Seconds",
    ["CashCollectInterval"] = 6,
    ["AutoLuckyBlock"] = true,
    ["AntiAFK"] = true,
}

-- ========================================================
-- 🛡️ 1. ANTI-AFK ENGINE
-- ========================================================
pcall(function()
    LocalPlayer.Idled:Connect(function()
        if _G.ChickenFarmConfig["AntiAFK"] then
            local vu = game:GetService("VirtualUser")
            if vu then
                vu:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
            end
        end
    end)
end)

-- ========================================================
-- 🐣 2. ORION UI INITIALIZATION
-- ========================================================
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    for _, g in ipairs(CoreGui:GetChildren()) do
        if g.Name == "Orion" or string.find(string.lower(g.Name), "orion") then
            g:Destroy()
        end
    end
    local pgui = LocalPlayer:FindFirstChild("PlayerGui")
    if pgui then
        for _, g in ipairs(pgui:GetChildren()) do
            if g.Name == "Orion" or string.find(string.lower(g.Name), "orion") then
                g:Destroy()
            end
        end
    end
end)

local OrionLib = nil
local orionUrls = {
    "https://raw.githubusercontent.com/shlexware/Orion/main/source",
    "https://raw.githubusercontent.com/thanhdat4461/OrionMoblie/main/source",
    "https://raw.githubusercontent.com/jensonhirst/Orion/main/source"
}

for _, url in ipairs(orionUrls) do
    pcall(function()
        if not OrionLib or type(OrionLib) ~= "table" or not OrionLib.MakeWindow then
            local src = game:HttpGet(url)
            if src and #src > 100 then
                OrionLib = loadstring(src)()
            end
        end
    end)
    if OrionLib and type(OrionLib) == "table" and OrionLib.MakeWindow then
        break
    end
end

local Window = OrionLib:MakeWindow({
    Name = "👑 SAKA HUB | Chicken Farm Tycoon",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "SakaHubChickenFarm",
    IntroText = "SAKA HUB | Chicken Farm Tycoon 👑"
})

local MainTab = Window:MakeTab({Name = "🌾 Auto Farm", PremiumOnly = false})
local CashTab = Window:MakeTab({Name = "💰 Auto Collect Cash", PremiumOnly = false})
local BaseTab = Window:MakeTab({Name = "🏠 My Base", PremiumOnly = false})
local SpeedTab = Window:MakeTab({Name = "⚡ Settings & Speed", PremiumOnly = false})

-- ========================================================
-- 🌾 TAB 1: AUTO FARM
-- ========================================================
MainTab:AddSection({Name = "🥚 Base Egg Farm & AFK"})

MainTab:AddToggle({
    Name = "🚀 Enable Auto Farm (Collect Eggs in Base)",
    Default = _G.ChickenFarmConfig["AutoFarmLoop"],
    Callback = function(Value)
        _G.ChickenFarmConfig["AutoFarmLoop"] = Value
        if not Value then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("FarmVelocity") then
                char.HumanoidRootPart.FarmVelocity:Destroy()
            end
        end
    end
})

MainTab:AddButton({
    Name = "📌 Lock Current Position (Set as Egg Drop Pit)",
    Callback = function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            _G.CustomDropPitPosition = char.HumanoidRootPart.Position
            OrionLib:MakeNotification({Name = "📌 Spot Locked", Content = "Locked egg collection to current spot!", Time = 3})
        end
    end
})

MainTab:AddSection({Name = "🧺 Deposit Eggs & Multiplier Settings"})

MainTab:AddToggle({
    Name = "🧺 Auto Deposit Eggs (Walk to Deposit Stall)",
    Default = _G.ChickenFarmConfig["AutoDepositEggs"],
    Callback = function(Value)
        _G.ChickenFarmConfig["AutoDepositEggs"] = Value
    end
})

MainTab:AddToggle({
    Name = "🎯 Filter by Multiplier (Deposit on Target)",
    Default = _G.ChickenFarmConfig["OnlyDepositOnTargetMultiplier"],
    Callback = function(Value)
        _G.ChickenFarmConfig["OnlyDepositOnTargetMultiplier"] = Value
    end
})

MainTab:AddSlider({
    Name = "Target Multiplier Threshold (Min 0.50x - 1.50x)",
    Min = 50,
    Max = 150,
    Default = 130,
    Color = Color3.fromRGB(255, 200, 50),
    Increment = 1,
    ValueName = "x 0.01",
    Callback = function(Value)
        _G.ChickenFarmConfig["TargetDepositMultiplier"] = Value / 100
    end
})

MainTab:AddSection({Name = "📦 Lucky Block Automation"})

MainTab:AddToggle({
    Name = "📦 Auto Handle Lucky Block (Buy / Discard if Low Cash)",
    Default = _G.ChickenFarmConfig["AutoLuckyBlock"],
    Callback = function(Value)
        _G.ChickenFarmConfig["AutoLuckyBlock"] = Value
    end
})

-- ========================================================
-- 💰 TAB 2: AUTO COLLECT CASH
-- ========================================================
CashTab:AddSection({Name = "💰 3-Mode Auto Collect Cash System"})

CashTab:AddDropdown({
    Name = "Select Collect Cash Mode",
    Default = _G.ChickenFarmConfig["CollectCashMode"] or "Every X Seconds",
    Options = {
        "1. Every X Seconds (Timed Interval)",
        "2. Always Collect (Instant After Deposit)",
        "3. Only on Max Multiplier (1.35x - 1.50x)"
    },
    Callback = function(Value)
        if string.find(Value, "Every") then
            _G.ChickenFarmConfig["CollectCashMode"] = "Every X Seconds"
        elseif string.find(Value, "Always") then
            _G.ChickenFarmConfig["CollectCashMode"] = "Always"
        elseif string.find(Value, "Max") then
            _G.ChickenFarmConfig["CollectCashMode"] = "Only on Max Multiplier"
        end
    end
})

CashTab:AddSlider({
    Name = "Collection Interval (For Mode 1)",
    Min = 2,
    Max = 30,
    Default = _G.ChickenFarmConfig["CashCollectInterval"] or 6,
    Color = Color3.fromRGB(100, 255, 100),
    Increment = 1,
    ValueName = "Seconds",
    Callback = function(Value)
        _G.ChickenFarmConfig["CashCollectInterval"] = Value
    end
})

-- ========================================================
-- 🏠 TAB 3: MY BASE & TELEPORTS
-- ========================================================
BaseTab:AddSection({Name = "🏠 Base Information & Actions"})

local function getMyPlot()
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        return plots:FindFirstChild(LocalPlayer.Name)
    end
    return nil
end

local function getDepositEggsPart()
    local myPlot = getMyPlot()
    if myPlot then
        for _, obj in ipairs(myPlot:GetDescendants()) do
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                for _, lbl in ipairs(obj:GetDescendants()) do
                    if lbl:IsA("TextLabel") and string.find(string.lower(lbl.Text), "deposit") then
                        if obj.Adornee and obj.Adornee:IsA("BasePart") then
                            return obj.Adornee
                        elseif obj.Parent and obj.Parent:IsA("BasePart") then
                            return obj.Parent
                        end
                    end
                end
            end
        end

        for _, obj in ipairs(myPlot:GetDescendants()) do
            if obj:IsA("BasePart") then
                local nameLower = string.lower(obj.Name)
                if string.find(nameLower, "deposit") or string.find(nameLower, "stand") or string.find(nameLower, "seller") then
                    return obj
                end
                if (obj.BrickColor.Name == "Bright yellow" or obj.BrickColor.Name == "New Yeller" or obj.BrickColor.Name == "Cool yellow") and obj.Size.X >= 4 and obj.Size.Z >= 4 then
                    return obj
                end
            end
        end
    end
    return nil
end

local function getCollectCashPart()
    local myPlot = getMyPlot()
    if myPlot then
        for _, obj in ipairs(myPlot:GetDescendants()) do
            if obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                for _, lbl in ipairs(obj:GetDescendants()) do
                    if lbl:IsA("TextLabel") and string.find(string.lower(lbl.Text), "collect") and string.find(string.lower(lbl.Text), "cash") then
                        if obj.Adornee and obj.Adornee:IsA("BasePart") then
                            return obj.Adornee
                        elseif obj.Parent and obj.Parent:IsA("BasePart") then
                            return obj.Parent
                        end
                    end
                end
            end
        end

        for _, obj in ipairs(myPlot:GetDescendants()) do
            if obj:IsA("BasePart") then
                local nameLower = string.lower(obj.Name)
                if string.find(nameLower, "cash") or string.find(nameLower, "basket") or string.find(nameLower, "collectcash") then
                    return obj
                end
            end
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            for _, lbl in ipairs(obj:GetDescendants()) do
                if lbl:IsA("TextLabel") and string.find(string.lower(lbl.Text), "collect cash") then
                    local target = obj.Adornee or obj.Parent
                    if target and target:IsA("BasePart") and myPlot and target:IsDescendantOf(myPlot) then
                        return target
                    end
                end
            end
        end
    end
    return nil
end

local function getCurrentMultiplier()
    local mult = 1.0

    local rs = game:GetService("ReplicatedStorage")
    local multVal = rs:FindFirstChild("EggMultiplier")
    if multVal and tonumber(multVal.Value) then
        return tonumber(multVal.Value)
    end

    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("EggMultiplierPart") then
        pcall(function()
            local text = workspace.Map.EggMultiplierPart.UI.Multi.Text
            local num = string.match(text, "(%d+%.?%d*)")
            if num then mult = tonumber(num) end
        end)
        if mult and mult >= 0.4 then return mult end
    end

    local myPlot = getMyPlot()
    if myPlot then
        for _, gui in ipairs(myPlot:GetDescendants()) do
            if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
                for _, lbl in ipairs(gui:GetDescendants()) do
                    if lbl:IsA("TextLabel") then
                        local txt = lbl.Text
                        local num = string.match(txt, "Multiplier:%s*(%d+%.?%d*)") or 
                                    string.match(txt, "[xX](%d+%.?%d*)") or 
                                    string.match(txt, "(%d+%.?%d*)[xX]")
                        if num then
                            local val = tonumber(num)
                            if val and val >= 0.4 and val <= 2.5 then
                                return val
                            end
                        end
                    end
                end
            end
        end
    end

    return mult or 1.0
end

-- ========================================================
-- 📦 LUCKY BLOCK AUTO BUY / DISCARD
-- ========================================================
local function parseCurrency(str)
    if not str then return 0 end
    local clean = string.gsub(tostring(str), "[$,%s]", "")
    local numStr, unit = string.match(clean, "(%d+%.?%d*)([kKmMbBtT]?)")
    if not numStr then return 0 end
    local num = tonumber(numStr) or 0
    unit = string.lower(unit or "")
    if unit == "k" then num = num * 1e3
    elseif unit == "m" then num = num * 1e6
    elseif unit == "b" then num = num * 1e9
    elseif unit == "t" then num = num * 1e12 end
    return num
end

local function getPlayerCash()
    local cash = 0
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if pgui and pgui:FindFirstChild("Main") then
            for _, obj in ipairs(pgui.Main:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Visible then
                    local t = obj.Text
                    if string.match(t, "^%$%d+%.?%d*[kKmMbBtT]?$") or string.match(t, "^%d+%.?%d*[kKmMbBtT]?%$?$") then
                        local parsed = parseCurrency(t)
                        if parsed > cash then cash = parsed end
                    end
                end
            end
        end
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats") or LocalPlayer:FindFirstChild("PlayerStats")
        if leaderstats then
            for _, v in ipairs(leaderstats:GetChildren()) do
                if string.find(string.lower(v.Name), "cash") or string.find(string.lower(v.Name), "money") then
                    local val = tonumber(v.Value) or parseCurrency(v.Value)
                    if val > cash then cash = val end
                end
            end
        end
    end)
    return cash
end

local lastLuckyBlockHandled = 0
local function handleLuckyBlock()
    if not _G.ChickenFarmConfig["AutoLuckyBlock"] then return end
    if tick() - lastLuckyBlockHandled < 0.6 then return end
    
    pcall(function()
        local pgui = LocalPlayer:FindFirstChild("PlayerGui")
        if not pgui then return end
        
        for _, gui in ipairs(pgui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled then
                for _, luckyFrame in ipairs(gui:GetDescendants()) do
                    if (luckyFrame:IsA("Frame") or luckyFrame:IsA("ImageLabel") or luckyFrame:IsA("CanvasGroup")) and string.lower(luckyFrame.Name) == "luckyblock" and luckyFrame.Visible then
                        local cost = 0
                        local costLabel = nil
                        
                        for _, lbl in ipairs(luckyFrame:GetDescendants()) do
                            if lbl:IsA("TextLabel") and lbl.Visible and string.find(string.lower(lbl.Text), "cost") then
                                cost = parseCurrency(lbl.Text)
                                costLabel = lbl.Text
                                break
                            end
                        end
                        
                        local myCash = getPlayerCash()
                        local buttonsHolder = luckyFrame:FindFirstChild("Buttons") or luckyFrame
                        
                        local function clickGuiButton(btn)
                            if not btn then return end
                            lastLuckyBlockHandled = tick()
                            
                            pcall(function()
                                if firesignal then
                                    firesignal(btn.MouseButton1Down)
                                    firesignal(btn.MouseButton1Click)
                                    firesignal(btn.Activated)
                                    firesignal(btn.MouseButton1Up)
                                end
                            end)
                            
                            pcall(function()
                                local vim = game:GetService("VirtualInputManager")
                                if vim then
                                    local absPos = btn.AbsolutePosition + (btn.AbsoluteSize / 2)
                                    vim:SendMouseButtonEvent(absPos.X, absPos.Y, 0, true, game, 1)
                                    task.wait(0.04)
                                    vim:SendMouseButtonEvent(absPos.X, absPos.Y, 0, false, game, 1)
                                end
                            end)
                        end
                        
                        if myCash >= cost and cost > 0 then
                            for _, btn in ipairs(buttonsHolder:GetDescendants()) do
                                if btn:IsA("GuiButton") and btn.Visible then
                                    local bName = string.lower(btn.Name)
                                    local btnText = ""
                                    for _, t in ipairs(btn:GetDescendants()) do
                                        if t:IsA("TextLabel") then btnText = btnText .. " " .. string.lower(t.Text) end
                                    end
                                    
                                    local isUnlock = string.find(bName, "unlock") or string.find(btnText, "unlock") or string.find(bName, "open") or string.find(btnText, "open") or (string.find(bName, "buy") and not string.find(bName, "robux") and not string.find(btnText, "robux"))
                                    local isRobux = string.find(bName, "robux") or string.find(btnText, "robux") or string.find(btnText, "r%$")
                                    
                                    if isUnlock and not isRobux then
                                        clickGuiButton(btn)
                                        OrionLib:MakeNotification({
                                            Name = "📦 Lucky Block Unlocked!",
                                            Content = string.format("Unlocked box successfully! (%s)", tostring(costLabel or "OK")),
                                            Time = 3
                                        })
                                        return
                                    end
                                end
                            end
                        else
                            for _, btn in ipairs(buttonsHolder:GetDescendants()) do
                                if btn:IsA("GuiButton") and btn.Visible then
                                    local bName = string.lower(btn.Name)
                                    local btnText = ""
                                    for _, t in ipairs(btn:GetDescendants()) do
                                        if t:IsA("TextLabel") then btnText = btnText .. " " .. string.lower(t.Text) end
                                    end
                                    
                                    if string.find(bName, "discard") or string.find(btnText, "discard") then
                                        clickGuiButton(btn)
                                        OrionLib:MakeNotification({
                                            Name = "🗑️ Discard Lucky Block",
                                            Content = string.format("Low Cash (%s) -> Discarded!", tostring(costLabel or "Low Cash")),
                                            Time = 3
                                        })
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.3) do
        handleLuckyBlock()
    end
end)

BaseTab:AddButton({
    Name = "🏠 Teleport to My Base Center",
    Callback = function()
        local myPlot = getMyPlot()
        local char = LocalPlayer.Character
        if myPlot and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = myPlot:GetPivot() + Vector3.new(0, 5, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
            OrionLib:MakeNotification({Name = "🏠 Teleport", Content = "Arrived at your Base!", Time = 2})
        end
    end
})

BaseTab:AddButton({
    Name = "🧺 Teleport to [Deposit Eggs] Stall",
    Callback = function()
        local depPart = getDepositEggsPart()
        local char = LocalPlayer.Character
        if depPart and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = depPart.CFrame + Vector3.new(0, 3, 0)
            char.HumanoidRootPart.Velocity = Vector3.zero
            OrionLib:MakeNotification({Name = "🧺 Deposit Eggs", Content = "Arrived at Deposit Eggs Stall!", Time = 2})
        end
    end
})

-- ========================================================
-- ⚡ TAB 4: SETTINGS & SPEED
-- ========================================================
SpeedTab:AddSection({Name = "🏃 Player Speeds & NoClip"})

SpeedTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 120,
    Default = _G.ChickenFarmConfig["WalkSpeed"] or 32,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 2,
    ValueName = "Speed",
    Callback = function(Value)
        _G.ChickenFarmConfig["WalkSpeed"] = Value
    end
})

SpeedTab:AddToggle({
    Name = "👻 NoClip (Walk Through Obstacles)",
    Default = _G.ChickenFarmConfig["NoClip"],
    Callback = function(Value)
        _G.ChickenFarmConfig["NoClip"] = Value
    end
})

RunService.Stepped:Connect(function()
    if _G.ChickenFarmConfig["NoClip"] or _G.ChickenFarmConfig["AutoFarmLoop"] then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- ========================================================
-- 🏃 SMOOTH WALKING ENGINE
-- ========================================================
local function walkTo(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char.HumanoidRootPart

    if hrp:FindFirstChild("FarmVelocity") then
        hrp.FarmVelocity:Destroy()
    end

    if hum then
        local speed = _G.ChickenFarmConfig["WalkSpeed"] or 32
        hum.WalkSpeed = speed

        hum:MoveTo(targetPos)
        local t0 = tick()
        while (tick() - t0) < 3.5 do
            local currentPos2D = Vector2.new(hrp.Position.X, hrp.Position.Z)
            local targetPos2D = Vector2.new(targetPos.X, targetPos.Z)
            local dist = (currentPos2D - targetPos2D).Magnitude
            if dist <= 2.5 then break end
            task.wait(0.04)
        end
    end
end

local function getRedLaneParts()
    local myPlot = getMyPlot()
    local redParts = {}
    if myPlot then
        for _, obj in ipairs(myPlot:GetDescendants()) do
            if obj:IsA("BasePart") then
                local c = obj.Color
                local isRed = (c.R > 0.52 and c.G < 0.38 and c.B < 0.38) or 
                              (obj.BrickColor.Name == "Really red" or obj.BrickColor.Name == "Bright red" or obj.BrickColor.Name == "Crimson" or obj.BrickColor.Name == "Rust")
                local nameLower = string.lower(obj.Name)
                if isRed or string.find(nameLower, "conveyor") or string.find(nameLower, "lane") or string.find(nameLower, "drop") or string.find(nameLower, "runway") then
                    if obj.Size.X >= 3 or obj.Size.Z >= 3 then
                        table.insert(redParts, obj)
                    end
                end
            end
        end
    end
    return redParts
end

-- ========================================================
-- 🥚 CENTRAL DROP PIT DETECTION
-- ========================================================
_G.CustomDropPitPosition = nil

local function getDropPitCenter()
    if _G.CustomDropPitPosition then
        return _G.CustomDropPitPosition
    end

    local myPlot = getMyPlot()
    if myPlot then
        local redParts = getRedLaneParts()
        local depPart = getDepositEggsPart()
        local bestPart = nil
        local minDist = 99999

        if depPart and #redParts > 0 then
            for _, rPart in ipairs(redParts) do
                local d = (rPart.Position - depPart.Position).Magnitude
                if d < minDist then
                    minDist = d
                    bestPart = rPart
                end
            end
        end

        if bestPart then
            return bestPart.Position
        elseif #redParts > 0 then
            return redParts[1].Position
        end
    end
    return nil
end

local function isInsideDropPit(eggPos)
    local pitPos = getDropPitCenter()
    if not pitPos then return true end

    local dx = math.abs(eggPos.X - pitPos.X)
    local dz = math.abs(eggPos.Z - pitPos.Z)
    local dy = math.abs(eggPos.Y - pitPos.Y)

    return (dx <= 6.5 and dz <= 6.5 and dy <= 3.5)
end

-- ========================================================
-- 🔄 MAIN BASE FARM, DEPOSIT & CASH COLLECT LOOP
-- ========================================================
task.spawn(function()
    local lastCashCollectTime = 0

    while task.wait(0.06) do
        if _G.ChickenFarmConfig["AutoFarmLoop"] then
            pcall(function()
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                local hrp = char.HumanoidRootPart
                local myPlot = getMyPlot()

                if not myPlot then
                    task.wait(0.5)
                    return
                end

                local pitCenter = getDropPitCenter()
                if not pitCenter then
                    task.wait(0.5)
                    return
                end

                -- [1] ส่งไข่เมื่อตัวคูณถึงเป้าหมาย
                local curMult = getCurrentMultiplier()
                local targetMult = _G.ChickenFarmConfig["TargetDepositMultiplier"] or 1.30
                local isMultiplierReady = not _G.ChickenFarmConfig["OnlyDepositOnTargetMultiplier"] or (curMult >= targetMult)

                if _G.ChickenFarmConfig["AutoDepositEggs"] and isMultiplierReady then
                    local depPart = getDepositEggsPart()
                    if depPart then
                        walkTo(depPart.Position)
                        if firetouchinterest then
                            firetouchinterest(hrp, depPart, 0)
                            task.wait(0.08)
                            firetouchinterest(hrp, depPart, 1)
                        end
                        pcall(function()
                            local rep = ReplicatedStorage:FindFirstChild("Replicator")
                            if rep and rep:FindFirstChild("__replicate") then
                                rep.__replicate:FireServer("Deposit")
                                rep.__replicate:FireServer("DepositEggs")
                                rep.__replicate:FireServer("Sell")
                            end
                        end)
                        task.wait(0.2)
                    end
                end

                -- [2] เก็บไข่ในช่องรวมไข่
                local eggsFolder = workspace:FindFirstChild("Eggs")
                local myEggs = {}

                if eggsFolder then
                    for _, eggModel in ipairs(eggsFolder:GetChildren()) do
                        if eggModel:IsA("Model") then
                            local part = eggModel.PrimaryPart or eggModel:FindFirstChildOfClass("BasePart") or eggModel:FindFirstChild("Hitbox")
                            if part then
                                local pPos = part.Position
                                if isInsideDropPit(pPos) then
                                    table.insert(myEggs, { Part = part, Dist = (hrp.Position - pPos).Magnitude })
                                end
                            end
                        end
                    end
                end

                for _, obj in ipairs(myPlot:GetDescendants()) do
                    if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "egg") and not string.find(string.lower(obj.Name), "deposit") then
                        local pPos = obj.Position
                        if isInsideDropPit(pPos) then
                            table.insert(myEggs, { Part = obj, Dist = (hrp.Position - pPos).Magnitude })
                        end
                    end
                end

                if #myEggs > 0 then
                    table.sort(myEggs, function(a, b) return a.Dist < b.Dist end)
                    local collectedThisRound = 0

                    for _, item in ipairs(myEggs) do
                        if not _G.ChickenFarmConfig["AutoFarmLoop"] then break end
                        if item.Part and item.Part.Parent then
                            if isInsideDropPit(item.Part.Position) then
                                collectedThisRound = collectedThisRound + 1
                                if collectedThisRound > 8 then break end

                                walkTo(item.Part.Position)

                                if firetouchinterest then
                                    firetouchinterest(hrp, item.Part, 0)
                                    firetouchinterest(hrp, item.Part, 1)
                                end
                            end
                        end
                    end
                else
                    walkTo(pitCenter)
                    task.wait(0.25)
                end

                -- [3] เก็บเงินอัตโนมัติ (Collect Cash)
                local mode = _G.ChickenFarmConfig["CollectCashMode"] or "Every X Seconds"
                local shouldCollectCash = false
                local now = tick()

                if mode == "Always" then
                    shouldCollectCash = true
                elseif mode == "Every X Seconds" then
                    if (now - lastCashCollectTime) >= (_G.ChickenFarmConfig["CashCollectInterval"] or 6) then
                        shouldCollectCash = true
                    end
                elseif mode == "Only on Max Multiplier" then
                    local curMult = getCurrentMultiplier()
                    if curMult >= 1.35 then
                        shouldCollectCash = true
                    end
                end

                if shouldCollectCash then
                    local cashPart = getCollectCashPart()
                    if cashPart then
                        walkTo(cashPart.Position)
                        if firetouchinterest then
                            firetouchinterest(hrp, cashPart, 0)
                            task.wait(0.08)
                            firetouchinterest(hrp, cashPart, 1)
                        end
                        pcall(function()
                            local rep = ReplicatedStorage:FindFirstChild("Replicator")
                            if rep and rep:FindFirstChild("__replicate") then
                                rep.__replicate:FireServer("CollectCash")
                                rep.__replicate:FireServer("Cash")
                            end
                        end)
                        lastCashCollectTime = tick()
                        task.wait(0.15)
                    end
                end

            end)
        end
    end
end)

OrionLib:MakeNotification({
    Name = "👑 SAKA HUB",
    Content = "Chicken Farm Tycoon script loaded successfully!",
    Time = 4
})

OrionLib:Init()
