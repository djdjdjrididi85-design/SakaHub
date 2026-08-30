-- ====================================================================
-- 👑 SAKA HUB | RIVALS (ULTIMATE PURE EDITION V14.0 MASTER)
-- 🎮 Game: RIVALS (Roblox FPS / PVP)
-- 🆔 Universe ID: 6035872082 | Place IDs: 17625359962 / 117398147513099
-- 🚀 100% NATIVE ZERO-LAG ENGINE (LOBBY & IN-MATCH ARENA COMPATIBLE)
-- 🎯 INSTANT HEAD LOCK | 👁️ VISUALS & ESP | ⚡ MOVEMENT | 🚀 TELEPORT | 🎁 MISC
-- 🗕 MINIMIZABLE GUI & FLOATING TOGGLE ICON
-- 🔴 RED NEON TOP SCREEN BAR & TARGET TRACER
-- 💾 PERSISTENT AUTO-SAVE SYSTEM
-- ⌨️ GUI TOGGLE: Press [RightControl] or Click Floating SAKA Icon
-- ====================================================================

-- 1. Full Environment Reset & Cache Purge
pcall(function()
    if cleardrawcache then cleardrawcache() end
end)

if _G.SakaHubCleanup then
    pcall(_G.SakaHubCleanup)
end

if _G.SakaHubConnections then
    for _, c in ipairs(_G.SakaHubConnections) do pcall(function() c:Disconnect() end) end
end
_G.SakaHubConnections = {}

if _G.SakaHubDrawings then
    for _, d in ipairs(_G.SakaHubDrawings) do pcall(function() d:Remove() end) end
end
_G.SakaHubDrawings = {}

pcall(function()
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("SAKA_HUB_GUI") then CoreGui.SAKA_HUB_GUI:Destroy() end
    if CoreGui:FindFirstChild("SAKA_TopRedBar") then CoreGui.SAKA_TopRedBar:Destroy() end
    local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if PlayerGui and PlayerGui:FindFirstChild("SAKA_HUB_GUI") then PlayerGui.SAKA_HUB_GUI:Destroy() end
    if PlayerGui and PlayerGui:FindFirstChild("SAKA_TopRedBar") then PlayerGui.SAKA_TopRedBar:Destroy() end
end)

_G.SakaHubCleanup = function()
    for _, c in ipairs(_G.SakaHubConnections) do pcall(function() c:Disconnect() end) end
    for _, d in ipairs(_G.SakaHubDrawings) do pcall(function() d:Remove() end) end
    pcall(function() if cleardrawcache then cleardrawcache() end end)
    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        if CoreGui:FindFirstChild("SAKA_HUB_GUI") then CoreGui.SAKA_HUB_GUI:Destroy() end
        if CoreGui:FindFirstChild("SAKA_TopRedBar") then CoreGui.SAKA_TopRedBar:Destroy() end
        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if PlayerGui and PlayerGui:FindFirstChild("SAKA_HUB_GUI") then PlayerGui.SAKA_HUB_GUI:Destroy() end
        if PlayerGui and PlayerGui:FindFirstChild("SAKA_TopRedBar") then PlayerGui.SAKA_TopRedBar:Destroy() end
    end)
    _G.SakaHubLoaded = false
end
_G.SakaHubLoaded = true

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- 🚀 1. BUILT-IN FPS UNLOCKER
pcall(function()
    if setfpscap then setfpscap(240) end
end)

-- 🛡️ Anti-AFK
table.insert(_G.SakaHubConnections, LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.zero, Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.zero, Camera.CFrame)
end))

-- ====================================================================
-- ⚙️ CONFIGURATION & AUTO-SAVE
-- ====================================================================
local ConfigFileName = "SAKAHUB_RIVALS_Settings.json"

local Config = {
    -- 🎯 Combat
    AimLock = true,
    InstantSnap = true,         -- ⚡ 0ms Lock Head
    StickyLock = true,
    TriggerMode = "Hold Key (Shift)", -- "Hold Key (Shift)", "Hold RMB (Right Click)", "Always On"
    Key = Enum.KeyCode.LeftShift,
    Smoothness = 0,             -- 0 = Instant, 10-100 = Smooth
    Priority = "Closest Crosshair", -- "Closest Distance", "Closest Crosshair"
    Bone = "Head",              -- "Head", "Torso"
    HeadOffset = 0.15,
    Prediction = true,
    ShowFOV = true,
    FOVRadius = 220,
    ShowAimTracer = true,

    -- 👁️ Visuals & ESP
    ShowTopLine = true,
    ESP = true,
    ESPBoxes = true,
    ESPNames = true,
    ESPHealth = true,
    ESPSnaplines = false,
    MaxDist = 600,
    FPSBooster = true,
    AntiFlashbang = true,

    -- ⚡ Movement
    Speed = false,
    WalkSpeed = 32,
    InfJump = false,
    Noclip = false
}

-- Safe Async Auto-Save
local savePending = false
local function RequestSaveSettings()
    if savePending then return end
    savePending = true
    task.delay(0.4, function()
        savePending = false
        pcall(function()
            if writefile then
                local data = {}
                for k, v in pairs(Config) do
                    if typeof(v) == "EnumItem" then
                        data[k] = { __type = "Enum", enumType = tostring(v.EnumType), name = v.Name }
                    else
                        data[k] = v
                    end
                end
                writefile(ConfigFileName, HttpService:JSONEncode(data))
            end
        end)
    end)
end

-- Safe Load
pcall(function()
    if isfile and isfile(ConfigFileName) and readfile then
        local raw = readfile(ConfigFileName)
        local decoded = HttpService:JSONDecode(raw)
        if type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if type(v) == "table" and v.__type == "Enum" then
                    if Enum[v.enumType] and Enum[v.enumType][v.name] then
                        Config[k] = Enum[v.enumType][v.name]
                    end
                elseif Config[k] ~= nil then
                    Config[k] = v
                end
            end
        end
    end
end)

-- 🚀 2. PERFORMANCE BOOSTER
local function applyFPSBoost()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 2
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostProcessEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
    end)
end
if Config.FPSBooster then applyFPSBoost() end

-- 🛡️ Anti-Flashbang / Anti-Blind Hook
pcall(function()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if remotes then
        local rep = remotes:FindFirstChild("Replication")
        if rep then
            local fighter = rep:FindFirstChild("Fighter")
            if fighter then
                local blindEffect = fighter:FindFirstChild("BlindedEffect")
                if blindEffect and blindEffect:IsA("RemoteEvent") then
                    table.insert(_G.SakaHubConnections, blindEffect.OnClientEvent:Connect(function()
                        if Config.AntiFlashbang then
                            local pGui = LocalPlayer:FindFirstChild("PlayerGui")
                            if pGui then
                                for _, g in ipairs(pGui:GetChildren()) do
                                    if string.find(string.lower(g.Name), "flash") or string.find(string.lower(g.Name), "blind") then
                                        g.Enabled = false
                                    end
                                end
                            end
                        end
                    end))
                end
            end
        end
    end
end)

-- ====================================================================
-- 🔴 RED TOP-SCREEN BORDER GUI
-- ====================================================================
local TopBarGui = Instance.new("ScreenGui")
TopBarGui.Name = "SAKA_TopRedBar"
TopBarGui.ResetOnSpawn = false
TopBarGui.DisplayOrder = 999999
TopBarGui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(TopBarGui)
        TopBarGui.Parent = CoreGui
    elseif gethui then
        TopBarGui.Parent = gethui()
    else
        TopBarGui.Parent = CoreGui
    end
end)
if not TopBarGui.Parent then pcall(function() TopBarGui.Parent = LocalPlayer:WaitForChild("PlayerGui", 2) or CoreGui end) end

local TopRedLine = Instance.new("Frame")
TopRedLine.Name = "TopRedLine"
TopRedLine.Size = UDim2.new(1, 0, 0, 2)
TopRedLine.Position = UDim2.new(0, 0, 0, 0)
TopRedLine.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
TopRedLine.BorderSizePixel = 0
TopRedLine.Visible = Config.ShowTopLine ~= false
TopRedLine.Parent = TopBarGui

-- ====================================================================
-- 🎯 DRAWING OBJECTS (FOV CIRCLE & AIM TRACER)
-- ====================================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 45, 55)
FOVCircle.Transparency = 0.85
FOVCircle.Filled = false
FOVCircle.Visible = false
table.insert(_G.SakaHubDrawings, FOVCircle)

local LockTracer = Drawing.new("Line")
LockTracer.Thickness = 2.0
LockTracer.Color = Color3.fromRGB(255, 45, 55)
LockTracer.Transparency = 0.95
LockTracer.Visible = false
table.insert(_G.SakaHubDrawings, LockTracer)

local LockText = Drawing.new("Text")
LockText.Size = 14
LockText.Center = true
LockText.Outline = true
LockText.Color = Color3.fromRGB(255, 60, 70)
LockText.OutlineColor = Color3.fromRGB(0, 0, 0)
LockText.Visible = false
table.insert(_G.SakaHubDrawings, LockText)

-- ====================================================================
-- 🔍 TARGET ACQUISITION (IN-MATCH & LOBBY TARGET FINDER)
-- ====================================================================
local isAiming = false
local currentTarget = nil

local function getTargetPart(char)
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    return Config.Bone == "Head" and (head or root) or (root or head)
end

local function getPredictedPos(targetPart)
    if not targetPart then return nil end
    local pos = targetPart.Position
    if Config.Bone == "Head" then
        pos = pos + Vector3.new(0, Config.HeadOffset or 0.15, 0)
    end
    if Config.Prediction and targetPart.AssemblyLinearVelocity then
        local myPos = Camera.CFrame.Position
        local dist = (pos - myPos).Magnitude
        local leadTime = dist / 1800
        pos = pos + (targetPart.AssemblyLinearVelocity * leadTime)
    end
    return pos
end

local function findBestTarget()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or Camera.CFrame.Position
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector

    local best = nil
    local bestScore = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                -- Check team
                local isEnemy = true
                if LocalPlayer.Team and plr.Team and LocalPlayer.Team == plr.Team then
                    isEnemy = false
                end
                if isEnemy then
                    local part = getTargetPart(plr.Character)
                    if part and (part.Position - camPos):Dot(camLook) > 0 then
                        local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                        if onScreen and sp.Z > 0 then
                            local fovDist = (Vector2.new(sp.X, sp.Y) - screenCenter).Magnitude
                            local dist3D = (part.Position - myPos).Magnitude

                            if fovDist <= Config.FOVRadius and dist3D <= Config.MaxDist then
                                local score = Config.Priority == "Closest Crosshair" and fovDist or dist3D
                                if score < bestScore then
                                    bestScore = score
                                    best = {
                                        Part = part,
                                        Player = plr,
                                        Humanoid = hum,
                                        Character = plr.Character
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return best
end

local function isLockActive()
    if not Config.AimLock then return false end
    if Config.TriggerMode == "Always On" then return true end
    if Config.TriggerMode == "Hold RMB (Right Click)" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    end
    return isAiming
end

-- ====================================================================
-- 👁️ LIGHTWEIGHT ESP ENGINE
-- ====================================================================
local ESPTable = {}

local function addESP(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Filled = false
    box.Color = Color3.fromRGB(255, 45, 55)
    box.Visible = false
    table.insert(_G.SakaHubDrawings, box)

    local boxOutline = Drawing.new("Square")
    boxOutline.Thickness = 3
    boxOutline.Filled = false
    boxOutline.Color = Color3.fromRGB(0, 0, 0)
    boxOutline.Visible = false
    table.insert(_G.SakaHubDrawings, boxOutline)

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Visible = false
    table.insert(_G.SakaHubDrawings, name)

    local health = Drawing.new("Text")
    health.Size = 12
    health.Center = true
    health.Outline = true
    health.Color = Color3.fromRGB(80, 255, 120)
    health.Visible = false
    table.insert(_G.SakaHubDrawings, health)

    local snap = Drawing.new("Line")
    snap.Thickness = 1.5
    snap.Color = Color3.fromRGB(255, 45, 55)
    snap.Transparency = 0.85
    snap.Visible = false
    table.insert(_G.SakaHubDrawings, snap)

    ESPTable[plr] = {Box = box, BoxOutline = boxOutline, Name = name, Health = health, Snap = snap, Active = false}
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
table.insert(_G.SakaHubConnections, Players.PlayerAdded:Connect(addESP))
table.insert(_G.SakaHubConnections, Players.PlayerRemoving:Connect(function(p)
    if ESPTable[p] then
        pcall(function()
            ESPTable[p].Box:Remove()
            ESPTable[p].BoxOutline:Remove()
            ESPTable[p].Name:Remove()
            ESPTable[p].Health:Remove()
            ESPTable[p].Snap:Remove()
        end)
        ESPTable[p] = nil
    end
end))

-- ====================================================================
-- 🔄 MAIN RUNSERVICE RENDER PIPELINE
-- ====================================================================
table.insert(_G.SakaHubConnections, RunService.RenderStepped:Connect(function()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local topOrigin = Vector2.new(Camera.ViewportSize.X / 2, 0)
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector

    -- 1. FOV Circle
    if Config.ShowFOV and Config.AimLock then
        FOVCircle.Position = screenCenter
        FOVCircle.Radius = Config.FOVRadius
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end

    -- 2. Aim Lock Engine
    local activeLock = isLockActive()
    if activeLock then
        local target = nil
        if Config.StickyLock and currentTarget and currentTarget.Character and currentTarget.Character.Parent and currentTarget.Humanoid and currentTarget.Humanoid.Health > 0 then
            local part = getTargetPart(currentTarget.Character)
            if part and (part.Position - camPos):Dot(camLook) > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then target = currentTarget end
            end
        end

        if not target then
            target = findBestTarget()
            currentTarget = target
        end

        if target and target.Part then
            local targetPos = getPredictedPos(target.Part)
            if targetPos then
                local currentCFrame = Camera.CFrame
                local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)

                if Config.InstantSnap or Config.Smoothness <= 2 then
                    Camera.CFrame = targetCFrame
                else
                    local smooth = math.clamp((100 - Config.Smoothness) / 100, 0.1, 1.0)
                    Camera.CFrame = currentCFrame:Lerp(targetCFrame, smooth)
                end

                -- Tracer Line
                if Config.ShowAimTracer then
                    local sp, onScreen = Camera:WorldToViewportPoint(targetPos)
                    if onScreen then
                        LockTracer.From = topOrigin
                        LockTracer.To = Vector2.new(sp.X, sp.Y)
                        LockTracer.Visible = true

                        LockText.Position = Vector2.new(sp.X, sp.Y - 22)
                        LockText.Text = string.format("💀 [HEAD LOCK] %s | %d HP", target.Player.DisplayName or target.Player.Name, math.floor(target.Humanoid.Health))
                        LockText.Visible = true
                    else
                        LockTracer.Visible = false
                        LockText.Visible = false
                    end
                end
            end
        else
            LockTracer.Visible = false
            LockText.Visible = false
        end
    else
        currentTarget = nil
        LockTracer.Visible = false
        LockText.Visible = false
    end

    -- 3. ESP Engine
    if Config.ESP then
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myPos = myRoot and myRoot.Position

        for plr, esp in pairs(ESPTable) do
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))

            if hum and hum.Health > 0 and root and (root.Position - camPos):Dot(camLook) > 0 then
                local dist = myPos and (myPos - root.Position).Magnitude or 100
                if dist <= Config.MaxDist then
                    local sp, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen and sp.Z > 1 then
                        local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 2.7, 0))
                        local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height * 0.65
                        local boxPos = Vector2.new(sp.X - width / 2, headPos.Y)

                        -- Snaplines
                        if Config.ESPSnaplines then
                            esp.Snap.From = topOrigin
                            esp.Snap.To = Vector2.new(sp.X, headPos.Y)
                            esp.Snap.Visible = true
                        else
                            esp.Snap.Visible = false
                        end

                        -- Boxes
                        if Config.ESPBoxes then
                            esp.BoxOutline.Size = Vector2.new(width, height)
                            esp.BoxOutline.Position = boxPos
                            esp.BoxOutline.Visible = true

                            esp.Box.Size = Vector2.new(width, height)
                            esp.Box.Position = boxPos
                            esp.Box.Visible = true
                        else
                            esp.BoxOutline.Visible = false
                            esp.Box.Visible = false
                        end

                        -- Names
                        if Config.ESPNames then
                            esp.Name.Text = string.format("%s [%dm]", plr.DisplayName or plr.Name, math.floor(dist))
                            esp.Name.Position = Vector2.new(sp.X, boxPos.Y - 16)
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end

                        -- Health
                        if Config.ESPHealth then
                            local hp = math.floor(hum.Health)
                            esp.Health.Text = string.format("%d HP", hp)
                            esp.Health.Position = Vector2.new(sp.X, boxPos.Y + height + 2)
                            esp.Health.Color = hp > 50 and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 60, 70)
                            esp.Health.Visible = true
                        else
                            esp.Health.Visible = false
                        end

                        esp.Active = true
                    else
                        esp.Box.Visible = false
                        esp.BoxOutline.Visible = false
                        esp.Name.Visible = false
                        esp.Health.Visible = false
                        esp.Snap.Visible = false
                        esp.Active = false
                    end
                else
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.Name.Visible = false
                    esp.Health.Visible = false
                    esp.Snap.Visible = false
                    esp.Active = false
                end
            else
                if esp.Active then
                    esp.Box.Visible = false
                    esp.BoxOutline.Visible = false
                    esp.Name.Visible = false
                    esp.Health.Visible = false
                    esp.Snap.Visible = false
                    esp.Active = false
                end
            end
        end
    else
        for _, esp in pairs(ESPTable) do
            if esp.Active then
                esp.Box.Visible = false
                esp.BoxOutline.Visible = false
                esp.Name.Visible = false
                esp.Health.Visible = false
                esp.Snap.Visible = false
                esp.Active = false
            end
        end
    end
end))

-- ====================================================================
-- ⌨️ INPUT BINDINGS & MOVEMENT HOOKS
-- ====================================================================
table.insert(_G.SakaHubConnections, UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Config.TriggerMode == "Hold Key (Shift)" and input.KeyCode == Config.Key then
        isAiming = true
    end
    if Config.InfJump and input.KeyCode == Enum.KeyCode.Space then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

table.insert(_G.SakaHubConnections, UserInputService.InputEnded:Connect(function(input, gp)
    if Config.TriggerMode == "Hold Key (Shift)" and input.KeyCode == Config.Key then
        isAiming = false
    end
end))

table.insert(_G.SakaHubConnections, RunService.Heartbeat:Connect(function()
    if Config.Speed and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.Unit.X * Config.WalkSpeed,
                root.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Unit.Z * Config.WalkSpeed
            )
        end
    end

    if Config.Noclip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
            end
        end
    end
end))

-- ====================================================================
-- 👑 CRASH-PROOF MODERN SAKA RED NEON USER INTERFACE
-- ====================================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "SAKA_HUB_GUI"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 99999
Gui.IgnoreGuiInset = true

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(Gui)
        Gui.Parent = CoreGui
    elseif gethui then
        Gui.Parent = gethui()
    else
        Gui.Parent = CoreGui
    end
end)
if not Gui.Parent then pcall(function() Gui.Parent = LocalPlayer:WaitForChild("PlayerGui", 2) or CoreGui end) end

-- 🔘 Floating Draggable Toggle Button
local FloatToggle = Instance.new("TextButton")
FloatToggle.Name = "SakaFloatLogo"
FloatToggle.Size = UDim2.new(0, 48, 0, 48)
FloatToggle.Position = UDim2.new(0.02, 0, 0.45, 0)
FloatToggle.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
FloatToggle.BorderSizePixel = 0
FloatToggle.Text = "👑"
FloatToggle.TextSize = 24
FloatToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatToggle.AutoButtonColor = false
FloatToggle.Parent = Gui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 24)
FloatCorner.Parent = FloatToggle

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 45, 55)
FloatStroke.Thickness = 2.0
FloatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
FloatStroke.Parent = FloatToggle

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 45, 55)
MainStroke.Thickness = 1.8
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Draggable Handlers
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

-- Float Toggle Drag & Click
local fDragging, fDragInput, fDragStart, fStartPos
FloatToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = FloatToggle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then fDragging = false end
        end)
    end
end)
FloatToggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        fDragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == fDragInput and fDragging then
        local delta = input.Position - fDragStart
        FloatToggle.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
    end
end)

FloatToggle.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Top Header
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(0, 350, 1, 0)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "👑 SAKA HUB <font color='#FF2D37'>RIVALS PRO</font> (V14.0 MASTER)"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 15
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -36, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "MinBtn"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -72, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(28, 30, 40)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinBtn.TextSize = 16
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

-- Left Sidebar Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 140, 1, -42)
Sidebar.Position = UDim2.new(0, 0, 0, 42)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 17, 24)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, -140, 1, -42)
TabContainer.Position = UDim2.new(0, 140, 0, 42)
TabContainer.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
TabContainer.BorderSizePixel = 0
TabContainer.Parent = MainFrame

-- Minimize Handler
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MinBtn.Text = "▢"
        Sidebar.Visible = false
        TabContainer.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 42)
        }):Play()
    else
        MinBtn.Text = "−"
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 420)
        }):Play()
        task.delay(0.18, function()
            if not isMinimized then
                Sidebar.Visible = true
                TabContainer.Visible = true
            end
        end)
    end
end)

local TabButtons = {}
local TabPages = {}

local function createTab(tabName, icon)
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Btn"
    btn.Size = UDim2.new(1, -16, 0, 36)
    btn.Position = UDim2.new(0, 8, 0, #TabButtons * 42 + 10)
    btn.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
    btn.BorderSizePixel = 0
    btn.Text = icon .. " " .. tabName
    btn.TextColor3 = Color3.fromRGB(180, 180, 190)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = Sidebar

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Name = tabName .. "Page"
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 55)
    page.Visible = false
    page.Parent = TabContainer

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.Parent = page

    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
    end)

    btn.MouseButton1Click:Connect(function()
        for name, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
            b.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        for name, p in pairs(TabPages) do
            p.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
    end)

    table.insert(TabButtons, btn)
    TabButtons[tabName] = btn
    TabPages[tabName] = page
    return page
end

-- ====================================================================
-- 🛠️ UI COMPONENT BUILDERS (TOGGLES, SLIDERS, BUTTONS)
-- ====================================================================
local function addToggle(page, labelText, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -6, 0, 36)
    container.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    container.BorderSizePixel = 0
    container.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBtn.BackgroundColor3 = defaultVal and Color3.fromRGB(255, 45, 55) or Color3.fromRGB(35, 38, 50)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = container

    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 11)
    tCorner.Parent = toggleBtn

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 16, 0, 16)
    dot.Position = defaultVal and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.BorderSizePixel = 0
    dot.Parent = toggleBtn

    local dCorner = Instance.new("UICorner")
    dCorner.CornerRadius = UDim.new(0, 8)
    dCorner.Parent = dot

    local state = defaultVal
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(255, 45, 55) or Color3.fromRGB(35, 38, 50)
        dot.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        callback(state)
        RequestSaveSettings()
    end)
end

local function addSlider(page, labelText, minVal, maxVal, defaultVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -6, 0, 46)
    container.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    container.BorderSizePixel = 0
    container.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 50, 0, 20)
    valLabel.Position = UDim2.new(1, -60, 0, 4)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(defaultVal)
    valLabel.TextColor3 = Color3.fromRGB(255, 60, 70)
    valLabel.TextSize = 13
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = container

    local barBg = Instance.new("TextButton")
    barBg.Size = UDim2.new(1, -24, 0, 8)
    barBg.Position = UDim2.new(0, 12, 0, 28)
    barBg.BackgroundColor3 = Color3.fromRGB(35, 38, 50)
    barBg.BorderSizePixel = 0
    barBg.Text = ""
    barBg.AutoButtonColor = false
    barBg.Parent = container

    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 4)
    bCorner.Parent = barBg

    local fill = Instance.new("Frame")
    local initRatio = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
    fill.Size = UDim2.new(initRatio, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
    fill.BorderSizePixel = 0
    fill.Parent = barBg

    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 4)
    fCorner.Parent = fill

    local sDragging = false
    local function updateSlider(input)
        local posX = math.clamp(input.Position.X - barBg.AbsolutePosition.X, 0, barBg.AbsoluteSize.X)
        local ratio = posX / barBg.AbsoluteSize.X
        local val = math.floor(minVal + (maxVal - minVal) * ratio)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        valLabel.Text = tostring(val)
        callback(val)
        RequestSaveSettings()
    end

    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sDragging = true
            updateSlider(input)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then sDragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local function addButton(page, text, btnColor, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 36)
    btn.BackgroundColor3 = btnColor or Color3.fromRGB(25, 28, 38)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    btn.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- ====================================================================
-- 📄 BUILD TABS & CONTENT
-- ====================================================================
local combatPage = createTab("Combat", "🎯")
local visualsPage = createTab("Visuals", "👁️")
local movePage = createTab("Movement", "⚡")
local tpPage = createTab("Teleport", "🚀")
local miscPage = createTab("Settings", "⚙️")

-- 🎯 COMBAT PAGE (HEAD LOCK MASTER)
addToggle(combatPage, "Master Aim Lock", Config.AimLock, function(v) Config.AimLock = v end)
addToggle(combatPage, "⚡ Instant Snap (0ms Head Lock)", Config.InstantSnap, function(v) Config.InstantSnap = v end)
addToggle(combatPage, "📌 Sticky Lock (เกาะเป้าไม่หลุด)", Config.StickyLock, function(v) Config.StickyLock = v end)
addToggle(combatPage, "🔮 Target Prediction (ดักความเร็ว)", Config.Prediction, function(v) Config.Prediction = v end)
addToggle(combatPage, "Show FOV Circle", Config.ShowFOV, function(v) Config.ShowFOV = v end)
addToggle(combatPage, "Red Aim Lock Tracer Line", Config.ShowAimTracer, function(v) Config.ShowAimTracer = v end)
addSlider(combatPage, "FOV Radius (Pixels)", 50, 450, Config.FOVRadius, function(v) Config.FOVRadius = v end)
addSlider(combatPage, "Smoothness (0 = Instant 100%)", 0, 100, Config.Smoothness, function(v) Config.Smoothness = v end)

-- 👁️ VISUALS PAGE
addToggle(visualsPage, "Master Player ESP", Config.ESP, function(v) Config.ESP = v end)
addToggle(visualsPage, "2D Bounding Boxes", Config.ESPBoxes, function(v) Config.ESPBoxes = v end)
addToggle(visualsPage, "Name & Distance ESP", Config.ESPNames, function(v) Config.ESPNames = v end)
addToggle(visualsPage, "Health Bar & Number ESP", Config.ESPHealth, function(v) Config.ESPHealth = v end)
addToggle(visualsPage, "Snaplines (Tracer to Target)", Config.ESPSnaplines, function(v) Config.ESPSnaplines = v end)
addSlider(visualsPage, "Max ESP Distance (Studs)", 50, 800, Config.MaxDist, function(v) Config.MaxDist = v end)

-- ⚡ MOVEMENT PAGE
addToggle(movePage, "Speed Boost Enabled", Config.Speed, function(v) Config.Speed = v end)
addSlider(movePage, "WalkSpeed Value", 16, 80, Config.WalkSpeed, function(v) Config.WalkSpeed = v end)
addToggle(movePage, "Infinite Jump in Air", Config.InfJump, function(v) Config.InfJump = v end)
addToggle(movePage, "Noclip (Walk Through Walls)", Config.Noclip, function(v) Config.Noclip = v end)
addButton(movePage, "🔄 Instant Respawn", Color3.fromRGB(180, 50, 50), function()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if remotes and remotes:FindFirstChild("Replication") and remotes.Replication:FindFirstChild("Fighter") then
            local r = remotes.Replication.Fighter:FindFirstChild("ResetCharacter")
            if r then r:FireServer() end
        end
    end)
end)

-- 🚀 TELEPORT PAGE (LOBBY & ARENA)
local Spawns = {
    ["Hub Center"] = CFrame.new(109, -680, 1184),
    ["Duels Spawn"] = CFrame.new(186, -677.5, 1184),
    ["Shooting Range"] = CFrame.new(1407, -714, 1044),
    ["Waiting Room"] = CFrame.new(120, -636, 1965),
    ["NPC: SenseiWarrior (Market)"] = CFrame.new(122, -676, 1295),
    ["NPC: Nosniy (Weapons)"] = CFrame.new(86, -676, 1110)
}
for name, cf in pairs(Spawns) do
    addButton(tpPage, "🚀 TP: " .. name, Color3.fromRGB(28, 30, 40), function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = cf + Vector3.new(0, 3, 0) end
    end)
end

-- ⚙️ SETTINGS PAGE
addToggle(miscPage, "FPS Booster (Max Performance)", Config.FPSBooster, function(v)
    Config.FPSBooster = v
    if v then applyFPSBoost() end
end)
addToggle(miscPage, "Anti-Flashbang / Anti-Blind", Config.AntiFlashbang, function(v)
    Config.AntiFlashbang = v
end)
addToggle(miscPage, "Top Red Screen Line", Config.ShowTopLine, function(v)
    Config.ShowTopLine = v
    TopRedLine.Visible = v
end)
addButton(miscPage, "💾 Save Settings Now", Color3.fromRGB(30, 140, 70), function()
    RequestSaveSettings()
end)
addButton(miscPage, "🧹 Unload & Clean SAKA HUB", Color3.fromRGB(180, 40, 40), function()
    if _G.SakaHubCleanup then _G.SakaHubCleanup() end
end)

-- Default Active Tab
TabButtons["Combat"].BackgroundColor3 = Color3.fromRGB(255, 45, 55)
TabButtons["Combat"].TextColor3 = Color3.fromRGB(255, 255, 255)
TabPages["Combat"].Visible = true

-- Toggle Keybind [RightControl]
table.insert(_G.SakaHubConnections, UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end))

print("👑 [SAKA HUB] RIVALS V14.0 Master (Match & Lobby Edition) Successfully Loaded!")
