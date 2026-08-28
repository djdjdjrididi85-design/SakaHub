-- ====================================================================
-- 👑 SAKA HUB | Murder Mystery 2 (MM2) — ZERO LAG ULTRA OPTIMIZED
-- 🚀 144+ FPS, Instant Smooth Aimbot, Clean ESP, Fast Coin Farm
-- ====================================================================

-- 1. Anti-Multiple Execution
if _G.SakaHubMM2Loaded then
    warn("👑 [SAKA HUB] MM2 Script is already running!")
    return
end
_G.SakaHubMM2Loaded = true

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
end)

-- 2. Configuration Table
_G.MM2Config = _G.MM2Config or {
    ["SilentAim"] = true,
    ["HoldRMBLock"] = true,
    ["ShowFOV"] = true,
    ["FOVRadius"] = 120,
    ["FOVColor"] = Color3.fromRGB(255, 215, 0),
    ["KnifeAura"] = false,
    ["ESP_Roles"] = true,
    ["ESP_Distance"] = true,
    ["ESP_GunDrop"] = true,
    ["AutoFarmCoins"] = false,
    ["AutoSafeZoneOnFull"] = true,
    ["FlyFarmSpeed"] = 28,
    ["AutoGrabGun"] = true,
    ["WalkSpeed"] = 16,
    ["JumpPower"] = 50,
    ["NoClip"] = false,
    ["SafeSkyHide"] = false
}

-- 3. Load Orion Library
local OrionLib = nil
local orionUrls = {
    "https://raw.githubusercontent.com/jensonhirst/Orion/main/source",
    "https://pastebin.com/raw/NMEH0WqV"
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
    if OrionLib and type(OrionLib) == "table" and OrionLib.MakeWindow then break end
end

if not OrionLib then
    warn("❌ Failed to load OrionLib GUI!")
    return
end

local Window = OrionLib:MakeWindow({
    Name = "👑 SAKA HUB | Murder Mystery 2",
    HidePremium = true,
    SaveConfig = false,
    ConfigFolder = "SakaHubMM2",
    IntroText = "SAKA HUB | MM2 👑"
})

local CombatTab = Window:MakeTab({Name = "⚔️ Combat & Aimbot", PremiumOnly = false})
local VisualsTab = Window:MakeTab({Name = "👁️ Visuals & ESP", PremiumOnly = false})
local FarmTab = Window:MakeTab({Name = "💰 Auto Farm", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "🧰 Misc & Movement", PremiumOnly = false})

-- ====================================================================
-- 🔍 HIGH-SPEED ROLE & WEAPON TRACKER (ZERO CPU LAG)
-- ====================================================================

local currentRoles = {
    Murderer = nil,
    Sheriff = nil,
    Hero = nil,
    Innocents = {}
}

local inLobbyState = false
local cachedGunDrop = nil

local function isLocalPlayerAliveInMatch()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or hum.Health <= 0 then return false end
    return true
end

local function checkLobbyStatus()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    
    local lobby = Workspace:FindFirstChild("Lobby")
    if lobby then
        local lobbyPos = lobby:GetPivot().Position
        if (hrp.Position - lobbyPos).Magnitude < 350 then
            return true
        end
    end

    -- Check if active match map exists
    local hasActiveMap = false
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "Lobby" and child.Name ~= "Terrain" and not Players:GetPlayerFromCharacter(child) then
            if child:FindFirstChild("CoinContainer") or child:FindFirstChild("Spawns") then
                hasActiveMap = true
                break
            end
        end
    end

    if not hasActiveMap then
        return true
    end

    return false
end

local function isKnifeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = string.lower(tool.Name)
    if name == "knife" or string.find(name, "knife") or tool:FindFirstChild("KnifeServer") or tool:FindFirstChild("KnifeClient") or tool:FindFirstChild("Stab") or tool:FindFirstChild("Slash") or string.find(name, "blade") or string.find(name, "dagger") or string.find(name, "scythe") or string.find(name, "sword") or string.find(name, "axe") or string.find(name, "bat") or string.find(name, "corrupt") or string.find(name, "harvester") then
        return true
    end
    return false
end

local function isGunTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local name = string.lower(tool.Name)
    if name == "gun" or string.find(name, "gun") or tool:FindFirstChild("GunGUI") or tool:FindFirstChild("GunClient") or tool:FindFirstChild("ShootGun") or tool:FindFirstChild("GunServer") or string.find(name, "revolver") or string.find(name, "pistol") or string.find(name, "luger") or string.find(name, "blaster") then
        return true
    end
    return false
end

local function getLocalKnife()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if isKnifeTool(item) then return item end
        end
    end
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if isKnifeTool(item) then return item end
        end
    end
    return nil
end

local function getLocalGun()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if isGunTool(item) then return item end
        end
    end
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if isGunTool(item) then return item end
        end
    end
    return nil
end

local function updateRoles()
    inLobbyState = checkLobbyStatus()
    
    if inLobbyState then
        currentRoles.Murderer = nil
        currentRoles.Sheriff = nil
        currentRoles.Hero = nil
        table.clear(currentRoles.Innocents)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(currentRoles.Innocents, p) end
        end
        return
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local char = p.Character
            local bp = p:FindFirstChild("Backpack")
            
            if char then
                for _, item in ipairs(char:GetChildren()) do
                    if isKnifeTool(item) then currentRoles.Murderer = p end
                    if isGunTool(item) then currentRoles.Sheriff = p end
                end
            end
            
            if bp then
                for _, item in ipairs(bp:GetChildren()) do
                    if isKnifeTool(item) then currentRoles.Murderer = p end
                    if isGunTool(item) then currentRoles.Sheriff = p end
                end
            end
        end
    end

    table.clear(currentRoles.Innocents)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p ~= currentRoles.Murderer and p ~= currentRoles.Sheriff and p ~= currentRoles.Hero then
            table.insert(currentRoles.Innocents, p)
        end
    end
end

-- Lightweight Player Listeners
local function setupPlayerListeners(player)
    local function onChildAdded(child)
        if isKnifeTool(child) or isGunTool(child) then
            task.delay(0.05, updateRoles)
        end
    end
    
    local bp = player:FindFirstChild("Backpack")
    if bp then bp.ChildAdded:Connect(onChildAdded) end
    
    player.ChildAdded:Connect(function(child)
        if child.Name == "Backpack" then
            child.ChildAdded:Connect(onChildAdded)
            updateRoles()
        end
    end)
    
    player.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(onChildAdded)
        task.delay(0.1, updateRoles)
    end)
    if player.Character then player.Character.ChildAdded:Connect(onChildAdded) end
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerListeners(p) end
Players.PlayerAdded:Connect(setupPlayerListeners)

-- Efficient GunDrop Tracker
Workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "GunDrop" and obj:IsA("BasePart") then
        cachedGunDrop = obj
    end
end)

Workspace.DescendantRemoving:Connect(function(obj)
    if obj == cachedGunDrop then cachedGunDrop = nil end
end)

-- Background Role Scanner (Runs every 1s — Zero CPU impact)
task.spawn(function()
    while task.wait(1.0) do
        pcall(updateRoles)
    end
end)

-- ====================================================================
-- ⭕ FOV CIRCLE & SNAPLINE (VISUALS)
-- ====================================================================
local fovCircle = nil
local snapLine = nil

pcall(function()
    if Drawing and Drawing.new then
        fovCircle = Drawing.new("Circle")
        fovCircle.Thickness = 2
        fovCircle.NumSides = 48
        fovCircle.Radius = _G.MM2Config["FOVRadius"] or 120
        fovCircle.Filled = false
        fovCircle.Visible = _G.MM2Config["ShowFOV"]
        fovCircle.Color = _G.MM2Config["FOVColor"] or Color3.fromRGB(255, 215, 0)
        fovCircle.Transparency = 0.8

        snapLine = Drawing.new("Line")
        snapLine.Thickness = 1.5
        snapLine.Color = Color3.fromRGB(255, 50, 50)
        snapLine.Transparency = 0.9
        snapLine.Visible = false
    end
end)

-- ====================================================================
-- 🎯 100% ACCURATE AIMBOT (DIRECT HEAD/TORSO LOCK + SILENT AIM)
-- ====================================================================

local function getSilentAimTarget()
    local candidates = {}
    local myChar = LocalPlayer.Character
    local isLocalMurderer = myChar and isKnifeTool(myChar:FindFirstChildWhichIsA("Tool"))

    if isLocalMurderer then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then table.insert(candidates, p) end
            end
        end
    else
        if currentRoles.Murderer and currentRoles.Murderer.Character and currentRoles.Murderer.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(candidates, currentRoles.Murderer)
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then table.insert(candidates, p) end
                end
            end
        end
    end

    local mousePos = UserInputService:GetMouseLocation()
    local bestTarget = nil
    local shortestDist = _G.MM2Config["FOVRadius"] or 120

    for _, p in ipairs(candidates) do
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist <= shortestDist then
                    shortestDist = dist
                    bestTarget = p
                end
            end
        end
    end

    return bestTarget
end

local function getTargetPosition(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return nil end
    local char = targetPlayer.Character
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    local targetPart = head or torso
    if not targetPart then return nil end
    return targetPart.Position
end

local function alignCameraToMouseFOV(targetPos, mousePos)
    local camPos = Camera.CFrame.Position
    local targetDir = (targetPos - camPos).Unit

    local mouseRay = Camera:ViewportPointToRay(mousePos.X, mousePos.Y)
    local localMouseDir = Camera.CFrame:VectorToObjectSpace(mouseRay.Direction).Unit

    local targetRotCenter = CFrame.lookAt(Vector3.zero, targetDir)
    local mouseOffsetRot = CFrame.lookAt(Vector3.zero, localMouseDir)

    local finalRotation = targetRotCenter * mouseOffsetRot:Inverse()
    Camera.CFrame = CFrame.new(camPos) * finalRotation.Rotation
end

_G.MM2Config["AimLockKey"] = Enum.KeyCode.E
local isAimLockActive = false

-- RenderStepped: Lightweight FOV & Keybind / RMB Lock
RunService.RenderStepped:Connect(function()
    local isRMBHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local isLockActive = isAimLockActive or (_G.MM2Config["HoldRMBLock"] and isRMBHeld)
    local showFOV = _G.MM2Config["ShowFOV"]
    
    if not showFOV and not isLockActive then
        if fovCircle then fovCircle.Visible = false end
        if snapLine then snapLine.Visible = false end
        return
    end

    local mousePos = UserInputService:GetMouseLocation()
    local target = getSilentAimTarget()

    if fovCircle then
        fovCircle.Position = mousePos
        fovCircle.Radius = _G.MM2Config["FOVRadius"] or 120
        fovCircle.Visible = showFOV
        fovCircle.Color = target and Color3.fromRGB(255, 60, 60) or (_G.MM2Config["FOVColor"] or Color3.fromRGB(255, 215, 0))
    end

    if snapLine then
        if showFOV and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local sp, vis = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            if vis then
                snapLine.From = mousePos
                snapLine.To = Vector2.new(sp.X, sp.Y)
                snapLine.Visible = true
            else
                snapLine.Visible = false
            end
        else
            snapLine.Visible = false
        end
    end

    -- Camera Aimbot (Locks enemy directly into the center of the Yellow Mouse FOV Circle on Custom Key or RMB)
    if target and isLockActive then
        local tPos = getTargetPosition(target)
        if tPos then
            alignCameraToMouseFOV(tPos, mousePos)
        end
    end
end)

-- Metamethod Hooks for 100% Reliable Shooting & Bullet Redirect (Ultra-Fast)
pcall(function()
    if hookmetamethod and newcclosure then
        local SHOOT_REMOTES = {
            ["GunBeam"] = true,
            ["GunFired"] = true,
            ["ShootGun"] = true,
            ["KnifeServer"] = true,
            ["KnifeKill"] = true,
            ["Throw"] = true
        }

        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if not checkcaller() and _G.MM2Config["SilentAim"] then
                local method = getnamecallmethod()
                if method == "FireServer" or method == "fireServer" then
                    local sName = self.Name
                    if SHOOT_REMOTES[sName] then
                        local target = getSilentAimTarget()
                        if target then
                            local tPos = getTargetPosition(target)
                            if tPos then
                                local args = {...}
                                local v3Count = 0
                                for i = 1, #args do
                                    if typeof(args[i]) == "Vector3" then v3Count = v3Count + 1 end
                                end

                                local currentV3 = 0
                                for i = 1, #args do
                                    if typeof(args[i]) == "Vector3" then
                                        currentV3 = currentV3 + 1
                                        if v3Count == 1 or currentV3 == v3Count then
                                            args[i] = tPos
                                        end
                                    elseif typeof(args[i]) == "CFrame" then
                                        args[i] = CFrame.new(tPos)
                                    elseif typeof(args[i]) == "table" then
                                        for k, v in pairs(args[i]) do
                                            if typeof(v) == "Vector3" then args[i][k] = tPos end
                                        end
                                    end
                                end
                                return oldNamecall(self, unpack(args))
                            end
                        end
                    end
                end
            end
            return oldNamecall(self, ...)
        end))

        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            -- ULTRA-FAST CHECK: Pass through instantly if key is not Hit or Target
            if key == "Hit" or key == "hit" or key == "Target" or key == "target" then
                if not checkcaller() and _G.MM2Config["SilentAim"] then
                    local target = getSilentAimTarget()
                    if target and target.Character then
                        if key == "Hit" or key == "hit" then
                            local tPos = getTargetPosition(target)
                            if tPos then return CFrame.new(tPos) end
                        elseif key == "Target" or key == "target" then
                            return target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
                        end
                    end
                end
            end
            return oldIndex(self, key)
        end))
    end
end)

-- ====================================================================
-- ⚔️ TAB 1: COMBAT & AIMBOT
-- ====================================================================
CombatTab:AddSection({Name = "🎯 FOV Circle & Aimbot"})

CombatTab:AddToggle({
    Name = "🔒 Hold Right-Click to Lock (คลิกขวาค้างเพื่อล็อกเป้า)",
    Default = _G.MM2Config["HoldRMBLock"],
    Callback = function(Value) _G.MM2Config["HoldRMBLock"] = Value end
})

CombatTab:AddBind({
    Name = "⌨️ Custom Aim Lock Key (ปุ่มล็อกเป้าเสริม)",
    Default = _G.MM2Config["AimLockKey"] or Enum.KeyCode.E,
    Hold = true,
    Callback = function(Value)
        isAimLockActive = Value
    end
})

CombatTab:AddToggle({
    Name = "🎯 Enable Silent Aim (กระสุนดูดเข้าเป้า)",
    Default = _G.MM2Config["SilentAim"],
    Callback = function(Value) _G.MM2Config["SilentAim"] = Value end
})

CombatTab:AddToggle({
    Name = "⭕ Show FOV Circle",
    Default = _G.MM2Config["ShowFOV"],
    Callback = function(Value) _G.MM2Config["ShowFOV"] = Value end
})

CombatTab:AddSlider({
    Name = "FOV Circle Radius",
    Min = 30,
    Max = 300,
    Default = _G.MM2Config["FOVRadius"] or 120,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 5,
    ValueName = "Pixels",
    Callback = function(Value) _G.MM2Config["FOVRadius"] = Value end
})

CombatTab:AddSection({Name = "🔪 Murderer Automation"})

CombatTab:AddToggle({
    Name = "⚔️ Knife Aura (Auto Slash Nearby)",
    Default = _G.MM2Config["KnifeAura"],
    Callback = function(Value) _G.MM2Config["KnifeAura"] = Value end
})

CombatTab:AddButton({
    Name = "💀 Kill All (Instant Slash All Players)",
    Callback = function()
        local char = LocalPlayer.Character
        local knife = getLocalKnife()
        if not knife then
            OrionLib:MakeNotification({Name = "❌ Not Murderer", Content = "You must be Murderer with a knife!", Time = 3})
            return
        end

        if char and knife.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(knife) end
            task.wait(0.12)
        end

        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local originalCFrame = hrp.CFrame
        local kills = 0

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = p.Character.HumanoidRootPart
                local targetHum = p.Character:FindFirstChildOfClass("Humanoid")

                if targetHum and targetHum.Health > 0 then
                    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, -1.0)
                    hrp.Velocity = Vector3.zero
                    task.wait(0.06)

                    knife:Activate()

                    pcall(function()
                        local r = ReplicatedStorage:FindFirstChild("Remotes")
                        if r and r:FindFirstChild("Gameplay") and r.Gameplay:FindFirstChild("KnifeKill") then
                            r.Gameplay.KnifeKill:FireServer(targetHrp.Position)
                        end
                    end)

                    if firetouchinterest then
                        for _, kPart in ipairs(knife:GetDescendants()) do
                            if kPart:IsA("BasePart") then
                                for _, bPart in ipairs(p.Character:GetChildren()) do
                                    if bPart:IsA("BasePart") then
                                        firetouchinterest(kPart, bPart, 0)
                                        firetouchinterest(kPart, bPart, 1)
                                    end
                                end
                            end
                        end
                    end
                    kills = kills + 1
                    task.wait(0.06)
                end
            end
        end

        hrp.CFrame = originalCFrame
        OrionLib:MakeNotification({Name = "💀 Kill All", Content = "Finished wiping " .. tostring(kills) .. " players!", Time = 3})
    end
})

-- Knife Aura Loop
task.spawn(function()
    while task.wait(0.2) do
        if _G.MM2Config["KnifeAura"] then
            pcall(function()
                local char = LocalPlayer.Character
                local knife = getLocalKnife()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not knife or not hrp or knife.Parent ~= char then return end

                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local targetHrp = p.Character.HumanoidRootPart
                        local targetHum = p.Character:FindFirstChildOfClass("Humanoid")
                        local dist = (hrp.Position - targetHrp.Position).Magnitude

                        if targetHum and targetHum.Health > 0 and dist <= 18 then
                            knife:Activate()

                            pcall(function()
                                local r = ReplicatedStorage:FindFirstChild("Remotes")
                                if r and r:FindFirstChild("Gameplay") and r.Gameplay:FindFirstChild("KnifeKill") then
                                    r.Gameplay.KnifeKill:FireServer(targetHrp.Position)
                                end
                            end)

                            if firetouchinterest then
                                for _, kPart in ipairs(knife:GetDescendants()) do
                                    if kPart:IsA("BasePart") then
                                        for _, bPart in ipairs(p.Character:GetChildren()) do
                                            if bPart:IsA("BasePart") then
                                                firetouchinterest(kPart, bPart, 0)
                                                firetouchinterest(kPart, bPart, 1)
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
    end
end)

CombatTab:AddSection({Name = "🔫 Sheriff Automation"})

CombatTab:AddButton({
    Name = "🔫 Shoot Murderer Instantly",
    Callback = function()
        if not currentRoles.Murderer or not currentRoles.Murderer.Character then
            OrionLib:MakeNotification({Name = "⚠️ Notice", Content = "Murderer not found!", Time = 3})
            return
        end

        local char = LocalPlayer.Character
        local gun = (char and char:FindFirstChild("Gun")) or (LocalPlayer.Backpack:FindFirstChild("Gun"))
        if not gun then
            OrionLib:MakeNotification({Name = "❌ No Gun", Content = "You don't have a gun!", Time = 3})
            return
        end

        if gun.Parent ~= char then
            char.Humanoid:EquipTool(gun)
            task.wait(0.1)
        end

        local targetHrp = currentRoles.Murderer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp then
            local predPos = targetHrp.Position + (targetHrp.Velocity * 0.1)

            local knifeServer = gun:FindFirstChild("KnifeServer")
            local shootRemote = (knifeServer and knifeServer:FindFirstChild("ShootGun")) or gun:FindFirstChild("ShootGun")
            if shootRemote and shootRemote:IsA("RemoteEvent") then
                shootRemote:FireServer(1, predPos, "AH2")
            else
                gun:Activate()
            end
            OrionLib:MakeNotification({Name = "🔫 Shot Fired", Content = "Targeted Murderer!", Time = 2})
        end
    end
})

-- ====================================================================
-- 👁️ TAB 2: VISUALS & ESP (ZERO LAG IMPLEMENTATION)
-- ====================================================================
VisualsTab:AddSection({Name = "🏷️ Role ESP & Highlights"})

VisualsTab:AddToggle({
    Name = "👁️ Enable Role ESP (Chams / Highlights)",
    Default = _G.MM2Config["ESP_Roles"],
    Callback = function(Value) _G.MM2Config["ESP_Roles"] = Value end
})

VisualsTab:AddToggle({
    Name = "🟡 Dropped Gun ESP",
    Default = _G.MM2Config["ESP_GunDrop"],
    Callback = function(Value) _G.MM2Config["ESP_GunDrop"] = Value end
})

VisualsTab:AddToggle({
    Name = "📏 Show Player Distance & Role Tags",
    Default = _G.MM2Config["ESP_Distance"],
    Callback = function(Value) _G.MM2Config["ESP_Distance"] = Value end
})

-- Lightweight ESP Renderer with Property Throttling
local function applyESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local role = "Innocent"
    local color = Color3.fromRGB(0, 255, 0)
    
    if not inLobbyState then
        if currentRoles.Murderer == player then
            role = "Murderer"
            color = Color3.fromRGB(255, 0, 0)
        elseif currentRoles.Sheriff == player or currentRoles.Hero == player then
            role = "Sheriff"
            color = Color3.fromRGB(0, 150, 255)
        end
    end

    -- Highlight (Only change property if different!)
    local hl = char:FindFirstChild("SakaMM2Highlight")
    if _G.MM2Config["ESP_Roles"] then
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "SakaMM2Highlight"
            hl.Adornee = char
            hl.FillTransparency = 0.5
            hl.OutlineTransparency = 0
            hl.FillColor = color
            hl.OutlineColor = color
            hl.Parent = char
        elseif hl.FillColor ~= color then
            hl.FillColor = color
            hl.OutlineColor = color
        end
    elseif hl then
        hl:Destroy()
    end

    -- Distance Tag (Only change text if different!)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local bg = hrp and hrp:FindFirstChild("SakaMM2Tag")
    if _G.MM2Config["ESP_Distance"] and hrp then
        if not bg then
            bg = Instance.new("BillboardGui")
            bg.Name = "SakaMM2Tag"
            bg.Adornee = hrp
            bg.Size = UDim2.new(0, 120, 0, 30)
            bg.StudsOffset = Vector3.new(0, 3, 0)
            bg.AlwaysOnTop = true
            local lbl = Instance.new("TextLabel", bg)
            lbl.Name = "Label"
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = color
            lbl.TextStrokeTransparency = 0
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 13
            bg.Parent = hrp
        end
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local dist = myHrp and math.floor((myHrp.Position - hrp.Position).Magnitude) or 0
        local lbl = bg:FindFirstChild("Label")
        if lbl then
            local newTxt = string.format("[%s] %s (%dm)", role, player.DisplayName or player.Name, dist)
            if lbl.Text ~= newTxt then
                lbl.Text = newTxt
                lbl.TextColor3 = color
            end
        end
    elseif bg then
        bg:Destroy()
    end
end

-- ESP Background Loop (Runs smoothly at 5Hz — Zero Lag)
task.spawn(function()
    while task.wait(0.2) do
        if _G.MM2Config["ESP_Roles"] or _G.MM2Config["ESP_Distance"] then
            for _, p in ipairs(Players:GetPlayers()) do
                pcall(function() applyESP(p) end)
            end
        end

        if cachedGunDrop and cachedGunDrop.Parent then
            local gHl = cachedGunDrop:FindFirstChild("SakaGunHighlight")
            if _G.MM2Config["ESP_GunDrop"] then
                if not gHl then
                    gHl = Instance.new("Highlight", cachedGunDrop)
                    gHl.Name = "SakaGunHighlight"
                    gHl.FillColor = Color3.fromRGB(255, 215, 0)
                    gHl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    gHl.FillTransparency = 0.3
                end
            elseif gHl then
                gHl:Destroy()
            end
        end
    end
end)

-- ====================================================================
-- 💰 TAB 3: AUTO FARM COINS
-- ====================================================================
FarmTab:AddSection({Name = "🪙 Smooth Fly Coin Farm"})

FarmTab:AddToggle({
    Name = "🪙 Enable Smooth Fly Coin Farm",
    Default = _G.MM2Config["AutoFarmCoins"],
    Callback = function(Value)
        _G.MM2Config["AutoFarmCoins"] = Value
        if not Value then
            pcall(function()
                if _G.CurrentCoinTween then _G.CurrentCoinTween:Cancel() end
            end)
        end
    end
})

FarmTab:AddToggle({
    Name = "🛡️ Auto Safe Sky Hide (When No Coins Left)",
    Default = _G.MM2Config["AutoSafeZoneOnFull"],
    Callback = function(Value) _G.MM2Config["AutoSafeZoneOnFull"] = Value end
})

FarmTab:AddSlider({
    Name = "Fly Speed",
    Min = 15,
    Max = 60,
    Default = _G.MM2Config["FlyFarmSpeed"] or 28,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 2,
    ValueName = "Studs/s",
    Callback = function(Value) _G.MM2Config["FlyFarmSpeed"] = Value end
})

-- Smooth Tween Function with NoClip
local function smoothTweenTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local flySpeed = speed or _G.MM2Config["FlyFarmSpeed"] or 28
    local duration = math.clamp(dist / flySpeed, 0.1, 4.0)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    _G.CurrentCoinTween = tween
    tween:Play()

    local completed = false
    local conn
    conn = tween.Completed:Connect(function()
        completed = true
        if conn then conn:Disconnect() end
    end)

    local elapsed = 0
    while not completed and elapsed < duration + 0.5 do
        if not _G.MM2Config["AutoFarmCoins"] or not isLocalPlayerAliveInMatch() then
            tween:Cancel()
            if conn then conn:Disconnect() end
            return false
        end
        task.wait(0.08)
        elapsed = elapsed + 0.08
    end

    hrp.Velocity = Vector3.zero
    return true
end

-- Fast Coin Scanner (Zero Full-Workspace Iteration)
local function getAllMM2Coins()
    local coins = {}
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "Lobby" and child.Name ~= "Terrain" and not Players:GetPlayerFromCharacter(child) then
            local container = child:FindFirstChild("CoinContainer") or child
            for _, obj in ipairs(container:GetDescendants()) do
                if obj.Name == "Coin_Server" and obj:IsA("BasePart") then
                    table.insert(coins, obj)
                end
            end
        end
    end
    return coins
end

-- Read MM2 Coin Bag Count from UI (if available)
local function getMM2CoinBagCount()
    local pGui = LocalPlayer:FindFirstChild("PlayerGui")
    if pGui then
        local mainGui = pGui:FindFirstChild("MainGUI")
        if mainGui then
            local gameGui = mainGui:FindFirstChild("Game")
            if gameGui then
                local coinBag = gameGui:FindFirstChild("CoinBag") or gameGui:FindFirstChild("Coins")
                if coinBag then
                    local lbl = coinBag:FindFirstChildWhichIsA("TextLabel", true)
                    if lbl and lbl.Text then
                        local cur = string.match(lbl.Text, "(%d+)/%d+") or string.match(lbl.Text, "(%d+)")
                        if cur then return tonumber(cur) end
                    end
                end
            end
        end
    end
    return nil
end

local coinsCollectedThisRound = 0
local isBagFullAfk = false

-- Smooth Fly Coin Farm Loop (With 40-Coin AFK & Pre-Match Idle Guard)
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.MM2Config["AutoFarmCoins"] then
            pcall(function()
                -- If not in active match or in lobby: Stay completely still and reset counter!
                if not isLocalPlayerAliveInMatch() or inLobbyState then
                    coinsCollectedThisRound = 0
                    isBagFullAfk = false
                    return
                end

                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local uiCoins = getMM2CoinBagCount()
                local totalCoins = uiCoins or coinsCollectedThisRound

                -- 🛡️ RULE: If bag has reached 40 coins -> Float up 20 studs and AFK!
                if totalCoins >= 40 then
                    if not isBagFullAfk then
                        isBagFullAfk = true
                        smoothTweenTo(hrp.CFrame + Vector3.new(0, 20, 0), 20)
                        hrp.Velocity = Vector3.zero
                        OrionLib:MakeNotification({Name = "🪙 Bag Full (40/40)", Content = "Collected 40 coins! Floating 20 studs up AFK.", Time = 4})
                    else
                        hrp.Velocity = Vector3.zero
                    end
                    task.wait(1.5)
                    return
                end

                local coins = getAllMM2Coins()
                if #coins > 0 then
                    table.sort(coins, function(a, b)
                        return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
                    end)

                    for _, coinPart in ipairs(coins) do
                        if not _G.MM2Config["AutoFarmCoins"] then break end
                        if not isLocalPlayerAliveInMatch() or inLobbyState then break end
                        if (getMM2CoinBagCount() or coinsCollectedThisRound) >= 40 then break end

                        if coinPart and coinPart.Parent then
                            local success = smoothTweenTo(coinPart.CFrame + Vector3.new(0, 0.5, 0))
                            if success and coinPart and coinPart.Parent then
                                if firetouchinterest then
                                    firetouchinterest(hrp, coinPart, 0)
                                    task.wait(0.04)
                                    firetouchinterest(hrp, coinPart, 1)
                                end
                                coinsCollectedThisRound = coinsCollectedThisRound + 1
                                task.wait(0.12)
                            end
                        end
                    end
                else
                    -- If no coins exist in map / match loading: Stay completely still on the ground!
                    task.wait(1.5)
                end
            end)
        end
    end
end)

-- ====================================================================
-- 🧰 TAB 4: MISC & MOVEMENT
-- ====================================================================
MiscTab:AddSection({Name = "🔫 Auto Grab Gun & Safety"})

MiscTab:AddToggle({
    Name = "🔫 Auto Grab Dropped Gun (Instant Hero)",
    Default = _G.MM2Config["AutoGrabGun"],
    Callback = function(Value) _G.MM2Config["AutoGrabGun"] = Value end
})

MiscTab:AddToggle({
    Name = "🛡️ Safe Sky Hide (Teleport to Sky)",
    Default = _G.MM2Config["SafeSkyHide"],
    Callback = function(Value)
        _G.MM2Config["SafeSkyHide"] = Value
        if Value then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 95, 0)
                hrp.Velocity = Vector3.zero
                OrionLib:MakeNotification({Name = "🛡️ Safe Sky", Content = "Teleported to sky!", Time = 2})
            end
        end
    end
})

-- Auto Grab Dropped Gun Engine
local lastGunGrabAttempt = 0

task.spawn(function()
    while task.wait(0.4) do
        if _G.MM2Config["AutoGrabGun"] then
            pcall(function()
                if not isLocalPlayerAliveInMatch() or inLobbyState then return end

                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                -- 🛡️ RULE: Do NOT grab gun if we are Murderer or already have a knife/gun!
                if getLocalKnife() ~= nil or currentRoles.Murderer == LocalPlayer then return end
                if getLocalGun() ~= nil or char:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return end

                local gunDrop = cachedGunDrop
                if gunDrop and gunDrop.Parent then
                    local dist = (hrp.Position - gunDrop.Position).Magnitude
                    if dist > 350 then return end

                    -- 🛡️ RULE: Do NOT grab gun if Murderer is camping near the gun (within 5 studs)!
                    if currentRoles.Murderer and currentRoles.Murderer.Character then
                        local mHrp = currentRoles.Murderer.Character:FindFirstChild("HumanoidRootPart")
                        if mHrp then
                            local mDistToGun = (mHrp.Position - gunDrop.Position).Magnitude
                            if mDistToGun <= 5 then
                                return -- Wait until Murderer moves farther than 5 studs away!
                            end
                        end
                    end

                    if tick() - lastGunGrabAttempt < 3 then return end
                    lastGunGrabAttempt = tick()

                    local originalPos = hrp.CFrame

                    -- 🛡️ Submerge underneath the gun (-3.2 studs under ground) to safely grab without getting slashed
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end

                    hrp.CFrame = gunDrop.CFrame * CFrame.new(0, -3.2, 0)
                    hrp.Velocity = Vector3.zero

                    if firetouchinterest then
                        firetouchinterest(hrp, gunDrop, 0)
                        task.wait(0.04)
                        firetouchinterest(hrp, gunDrop, 1)
                    end
                    task.wait(0.08)
                    hrp.CFrame = originalPos
                    hrp.Velocity = Vector3.zero
                    OrionLib:MakeNotification({Name = "🔫 Gun Grabbed", Content = "You sneaked under the gun and became Hero!", Time = 3})
                end
            end)
        end
    end
end)

MiscTab:AddSection({Name = "🏃 Player Speeds & NoClip"})

MiscTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 120,
    Default = _G.MM2Config["WalkSpeed"] or 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 2, ValueName = "Speed",
    Callback = function(Value)
        _G.MM2Config["WalkSpeed"] = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end
})

MiscTab:AddSlider({
    Name = "JumpPower",
    Min = 50, Max = 200,
    Default = _G.MM2Config["JumpPower"] or 50,
    Color = Color3.fromRGB(255, 215, 0),
    Increment = 5, ValueName = "Power",
    Callback = function(Value)
        _G.MM2Config["JumpPower"] = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.JumpPower = Value end
    end
})

MiscTab:AddToggle({
    Name = "👻 NoClip (Walk Through Walls)",
    Default = _G.MM2Config["NoClip"],
    Callback = function(Value) _G.MM2Config["NoClip"] = Value end
})

-- NoClip & Speed Engine (Zero Lag)
RunService.Stepped:Connect(function()
    if _G.MM2Config["NoClip"] then
        local char = LocalPlayer.Character
        if char then
            for _, p in ipairs(char:GetChildren()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

MiscTab:AddSection({Name = "🌐 Server Utilities"})

MiscTab:AddButton({
    Name = "🔄 Rejoin Server (เข้าเซิร์ฟเดิมใหม่)",
    Callback = function()
        OrionLib:MakeNotification({Name = "🔄 Rejoining...", Content = "Connecting back to the server...", Time = 3})
        task.wait(0.5)
        pcall(function()
            if #Players:GetPlayers() <= 1 then
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)
    end
})

MiscTab:AddButton({
    Name = "🔀 Server Hop (สุ่มย้ายเซิร์ฟเวอร์ใหม่)",
    Callback = function()
        OrionLib:MakeNotification({Name = "🔀 Server Hop", Content = "Searching for an active server...", Time = 3})
        task.wait(0.5)
        pcall(function()
            local apiUrl = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
            local response = game:HttpGet(apiUrl)
            local data = HttpService:JSONDecode(response)
            if data and data.data then
                for _, server in ipairs(data.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
                        return
                    end
                end
            end
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end
})

-- Anti-AFK
pcall(function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.zero, Workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.zero, Workspace.CurrentCamera.CFrame)
    end)
end)

OrionLib:MakeNotification({
    Name = "👑 SAKA HUB",
    Content = "MM2 Ultra-Optimized build ready!",
    Time = 4
})

OrionLib:Init()
