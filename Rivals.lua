-- ====================================================================
-- 👑 SAKA HUB | RIVALS (ULTIMATE PURE EDITION V13.0)
-- 🚀 100% NATIVE HIGH-SPEED ENGINE (CLEAN & PURE ZERO-LAG)
-- 🎯 COMBAT | 👁️ VISUALS & ESP | ⚡ MOVEMENT | 🚀 TELEPORT | 🎁 MISC
-- 🔴 RED TOP-SCREEN BORDER & RED AIM LOCK TRACER
-- 💾 PERSISTENT AUTO-SAVE & AUTO-LOAD SYSTEM
-- ⌨️ GUI TOGGLE: Press [RightControl] or Click Floating Logo / Buttons
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
-- ⚙️ CONFIGURATION & VERIFIED PERSISTENT AUTO-SAVE
-- ====================================================================
local ConfigFileName = "SAKAHUB_RIVALS_Settings.json"

local Config = {
    -- 🎯 Combat
    AimLock = true,
    StickyLock = true,
    TriggerMode = "Hold Key (Shift)", -- "Hold Key (Shift)", "Hold RMB (Right Click)", "Always On"
    Key = Enum.KeyCode.LeftShift,
    Smoothness = 65, -- 10 to 100%
    Priority = "Closest Distance", -- "Closest Distance", "Closest Crosshair"
    Bone = "Head", -- "Head", "Torso"
    ShowFOV = true,
    FOVRadius = 180, -- 20 to 400 px
    ShowAimTracer = true, -- 🔴 Red Line from top of screen to current target

    -- 👁️ Visuals & ESP
    ShowTopLine = true,
    ESP = false,
    ESPBoxes = true,
    ESPNames = true,
    ESPHealth = true,
    ESPSnaplines = false,
    MaxDist = 350,
    FPSBooster = true,
    AntiFlashbang = true,

    -- ⚡ Movement
    Speed = false,
    WalkSpeed = 28,
    InfJump = false
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
local loadedSuccessfully = false
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
            loadedSuccessfully = true
        end
    end
end)

-- 🚀 2. MAP & GRAPHICS PERFORMANCE BOOSTER
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
    local blindEffect = ReplicatedStorage:FindFirstChild("Remotes") and 
                        ReplicatedStorage.Remotes:FindFirstChild("Replication") and 
                        ReplicatedStorage.Remotes.Replication:FindFirstChild("Fighter") and 
                        ReplicatedStorage.Remotes.Replication.Fighter:FindFirstChild("BlindedEffect")
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
end)

local isAiming = false
local currentTarget = nil

-- ====================================================================
-- 🔴 RED TOP-SCREEN BORDER GUI (0% CPU COST)
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
if not TopBarGui.Parent then pcall(function() TopBarGui.Parent = LocalPlayer.PlayerGui end) end

local TopRedLine = Instance.new("Frame")
TopRedLine.Name = "TopRedLine"
TopRedLine.Size = UDim2.new(1, 0, 0, 2)
TopRedLine.Position = UDim2.new(0, 0, 0, 0)
TopRedLine.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
TopRedLine.BorderSizePixel = 0
TopRedLine.Visible = Config.ShowTopLine ~= false
TopRedLine.Parent = TopBarGui

-- ====================================================================
-- 🎯 ULTRA-LIGHT DRAWING OBJECTS
-- ====================================================================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 45, 55)
FOVCircle.Transparency = 0.85
FOVCircle.Filled = false
FOVCircle.Visible = false
table.insert(_G.SakaHubDrawings, FOVCircle)

-- 🔴 Red Lock Tracer from top of screen to target
local LockTracer = Drawing.new("Line")
LockTracer.Thickness = 2.0
LockTracer.Color = Color3.fromRGB(255, 45, 55)
LockTracer.Transparency = 0.95
LockTracer.Visible = false
table.insert(_G.SakaHubDrawings, LockTracer)

local function getTargetPart(char)
    if not char then return nil end
    local head = char:FindFirstChild("Head")
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    return Config.Bone == "Head" and (head or root) or (root or head)
end

local function findBestTarget()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or Camera.CFrame.Position
    local mousePos = UserInputService:GetMouseLocation()
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector

    local best = nil
    local bestScore = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = getTargetPart(plr.Character)
                if part and (part.Position - camPos):Dot(camLook) > 0 then
                    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local fovDist = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if fovDist <= Config.FOVRadius then
                            local score = Config.Priority == "Closest Distance" and (part.Position - myPos).Magnitude or fovDist
                            if score < bestScore then
                                bestScore = score
                                best = part
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
-- 👁️ LIGHTWEIGHT ESP
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

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = false
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Visible = false
    table.insert(_G.SakaHubDrawings, name)

    local health = Drawing.new("Line")
    health.Thickness = 2
    health.Color = Color3.fromRGB(0, 255, 120)
    health.Visible = false
    table.insert(_G.SakaHubDrawings, health)

    local snap = Drawing.new("Line")
    snap.Thickness = 1.5
    snap.Color = Color3.fromRGB(255, 45, 55)
    snap.Transparency = 0.85
    snap.Visible = false
    table.insert(_G.SakaHubDrawings, snap)

    ESPTable[plr] = {Box = box, Name = name, Health = health, Snap = snap, Active = false}
end

for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
table.insert(_G.SakaHubConnections, Players.PlayerAdded:Connect(addESP))
table.insert(_G.SakaHubConnections, Players.PlayerRemoving:Connect(function(p)
    if ESPTable[p] then
        pcall(function()
            ESPTable[p].Box:Remove()
            ESPTable[p].Name:Remove()
            ESPTable[p].Health:Remove()
            ESPTable[p].Snap:Remove()
        end)
        ESPTable[p] = nil
    end
end))

-- ====================================================================
-- ⚡ 144+ FPS UNIFIED RENDER LOOP
-- ====================================================================
table.insert(_G.SakaHubConnections, RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    local vp = Camera.ViewportSize
    local topOrigin = Vector2.new(vp.X / 2, 0)
    local camPos = Camera.CFrame.Position
    local camLook = Camera.CFrame.LookVector

    -- 1. FOV Circle
    if Config.ShowFOV and Config.AimLock then
        FOVCircle.Position = mousePos
        FOVCircle.Radius = Config.FOVRadius
        if not FOVCircle.Visible then FOVCircle.Visible = true end
    else
        if FOVCircle.Visible then FOVCircle.Visible = false end
    end

    -- 2. Aim Lock Engine
    local activeLock = isLockActive()
    if activeLock then
        local target = nil
        if Config.StickyLock and currentTarget and currentTarget.Parent and currentTarget:IsA("BasePart") then
            local model = currentTarget.Parent
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and (currentTarget.Position - camPos):Dot(camLook) > 0 then
                local _, onScreen = Camera:WorldToViewportPoint(currentTarget.Position)
                if onScreen then target = currentTarget end
            end
        end

        if not target then
            target = findBestTarget()
            currentTarget = target
        end

        if target then
            local sp, onScreen = Camera:WorldToViewportPoint(target.Position)
            if onScreen then
                -- 🔴 Red Lock Tracer from Top of Screen to Target
                if Config.ShowAimTracer then
                    LockTracer.From = topOrigin
                    LockTracer.To = Vector2.new(sp.X, sp.Y)
                    if not LockTracer.Visible then LockTracer.Visible = true end
                else
                    if LockTracer.Visible then LockTracer.Visible = false end
                end

                local dx = sp.X - mousePos.X
                local dy = sp.Y - mousePos.Y
                local smooth = math.clamp(Config.Smoothness / 100, 0.05, 1.0)

                if mousemoverel then
                    local moveX = math.clamp(dx * smooth, -30, 30)
                    local moveY = math.clamp(dy * smooth, -30, 30)
                    mousemoverel(moveX, moveY)
                else
                    local targetCF = CFrame.lookAt(camPos, target.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCF, smooth)
                end
            else
                if LockTracer.Visible then LockTracer.Visible = false end
            end
        else
            if LockTracer.Visible then LockTracer.Visible = false end
        end
    else
        currentTarget = nil
        if LockTracer.Visible then LockTracer.Visible = false end
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
                        local h = math.clamp(1900 / sp.Z, 12, 380)
                        local w = h * 0.62
                        local themeCol = Color3.fromRGB(255, 45, 55)

                        -- Snaplines
                        if Config.ESPSnaplines then
                            esp.Snap.From = topOrigin
                            esp.Snap.To = Vector2.new(sp.X, sp.Y - h / 2)
                            esp.Snap.Color = themeCol
                            esp.Snap.Visible = true
                        else
                            esp.Snap.Visible = false
                        end

                        -- Boxes
                        if Config.ESPBoxes then
                            esp.Box.Size = Vector2.new(w, h)
                            esp.Box.Position = Vector2.new(sp.X - w / 2, sp.Y - h / 2)
                            esp.Box.Color = themeCol
                            esp.Box.Visible = true
                        else
                            esp.Box.Visible = false
                        end

                        -- Names & Distance
                        if Config.ESPNames then
                            esp.Name.Text = string.format("%s [%dm]", plr.DisplayName, math.floor(dist))
                            esp.Name.Color = themeCol
                            esp.Name.Position = Vector2.new(sp.X, sp.Y - h / 2 - 15)
                            esp.Name.Visible = true
                        else
                            esp.Name.Visible = false
                        end

                        -- Health Bar
                        if Config.ESPHealth then
                            local hpPct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                            esp.Health.From = Vector2.new(sp.X - w / 2 - 4, sp.Y + h / 2)
                            esp.Health.To = Vector2.new(sp.X - w / 2 - 4, (sp.Y + h / 2) - (h * hpPct))
                            esp.Health.Color = Color3.fromRGB(math.floor(255 * (1 - hpPct)), math.floor(255 * hpPct), 60)
                            esp.Health.Visible = true
                        else
                            esp.Health.Visible = false
                        end

                        esp.Active = true
                    else
                        if esp.Active then
                            esp.Box.Visible = false
                            esp.Name.Visible = false
                            esp.Health.Visible = false
                            esp.Snap.Visible = false
                            esp.Active = false
                        end
                    end
                else
                    if esp.Active then
                        esp.Box.Visible = false
                        esp.Name.Visible = false
                        esp.Health.Visible = false
                        esp.Snap.Visible = false
                        esp.Active = false
                    end
                end
            else
                if esp.Active then
                    esp.Box.Visible = false
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
                esp.Name.Visible = false
                esp.Health.Visible = false
                esp.Snap.Visible = false
                esp.Active = false
            end
        end
    end
end))

-- Keybind Listeners
table.insert(_G.SakaHubConnections, UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.Key then
        isAiming = true
    end
end))

table.insert(_G.SakaHubConnections, UserInputService.InputEnded:Connect(function(input, gp)
    if input.KeyCode == Config.Key then
        isAiming = false
    end
end))

-- Movement Hooks
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
end))

table.insert(_G.SakaHubConnections, UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))

-- ====================================================================
-- 🖥️ NATIVE ULTRA-FAST GUI WITH MINIMIZE & EXPAND SYSTEM
-- ====================================================================
local Gui = Instance.new("ScreenGui")
Gui.Name = "SAKA_HUB_GUI"
Gui.ResetOnSpawn = false
Gui.DisplayOrder = 99999

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
if not Gui.Parent then pcall(function() Gui.Parent = LocalPlayer.PlayerGui end) end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 390)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 45, 55)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Floating Mini Logo (When minimized)
local MiniLogo = Instance.new("TextButton")
MiniLogo.Name = "MiniLogo"
MiniLogo.Size = UDim2.new(0, 50, 0, 50)
MiniLogo.Position = UDim2.new(0, 20, 0.5, -25)
MiniLogo.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
MiniLogo.Font = Enum.Font.GothamBold
MiniLogo.Text = "👑"
MiniLogo.TextSize = 24
MiniLogo.Visible = false
MiniLogo.Active = true
MiniLogo.Draggable = true
MiniLogo.Parent = Gui
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 25)
MiniCorner.Parent = MiniLogo
local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(255, 45, 55)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniLogo

MiniLogo.MouseButton1Click:Connect(function()
    MiniLogo.Visible = false
    MainFrame.Visible = true
end)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -95, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "👑 SAKA HUB | RIVALS PRO ⚡"
TitleLabel.TextColor3 = Color3.fromRGB(255, 45, 55)
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- ➖ Minimize Button [-]
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -72, 0, 6)
MinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 16
MinBtn.Parent = TitleBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinBtn

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniLogo.Visible = true
end)

-- ❌ Close Button [X]
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Parent = TitleBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Notification Banner (Bottom of GUI)
local NotifyLabel = Instance.new("TextLabel")
NotifyLabel.Size = UDim2.new(1, -20, 0, 20)
NotifyLabel.Position = UDim2.new(0, 10, 1, -25)
NotifyLabel.BackgroundTransparency = 1
NotifyLabel.Font = Enum.Font.GothamMedium
NotifyLabel.Text = loadedSuccessfully and "💾 โหลดการตั้งค่าล่าสุดสำเร็จ! (Persistent Saved)" or "⚡ SAKA HUB Ready! Press [RightControl] to Toggle"
NotifyLabel.TextColor3 = loadedSuccessfully and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(180, 180, 180)
NotifyLabel.TextSize = 11
NotifyLabel.Parent = MainFrame

-- Sidebar Tabs
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(0, 120, 1, -80)
TabBar.Position = UDim2.new(0, 10, 0, 48)
TabBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
TabBar.BorderSizePixel = 0
TabBar.Parent = MainFrame
local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 8)
TabCorner.Parent = TabBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -145, 1, -80)
ContentArea.Position = UDim2.new(0, 135, 0, 48)
ContentArea.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentArea

local TabPages = {}
local TabButtons = {}

local function CreateTab(name, icon)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(255, 45, 55)
    page.Visible = false
    page.Parent = ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.Parent = page
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Parent = TabBar

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(TabPages) do p.Visible = false end
        for _, b in pairs(TabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            b.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        page.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    TabPages[name] = page
    TabButtons[name] = btn
    return page
end

-- 1. ADD TOGGLE COMPONENT
local function AddToggle(page, label, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.Parent = page
    local crn = Instance.new("UICorner")
    crn.CornerRadius = UDim.new(0, 6)
    crn.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -60, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamMedium
    txt.Text = label
    txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = frame

    local state = default
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -50, 0.5, -11)
    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(255, 45, 55) or Color3.fromRGB(50, 50, 60)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Text = state and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Parent = frame
    local tcrn = Instance.new("UICorner")
    tcrn.CornerRadius = UDim.new(0, 4)
    tcrn.Parent = toggleBtn

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(255, 45, 55) or Color3.fromRGB(50, 50, 60)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
        RequestSaveSettings()
        NotifyLabel.Text = "💾 บันทึกการตั้งค่าล่าสุดแล้ว!"
        NotifyLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
    end)
end

-- 2. ADD SLIDER COMPONENT
local function AddSlider(page, label, min, max, default, unit, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.Parent = page
    local crn = Instance.new("UICorner")
    crn.CornerRadius = UDim.new(0, 6)
    crn.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.6, 0, 0, 20)
    txt.Position = UDim2.new(0, 10, 0, 4)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamMedium
    txt.Text = label
    txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = frame

    local valTxt = Instance.new("TextLabel")
    valTxt.Size = UDim2.new(0.35, 0, 0, 20)
    valTxt.Position = UDim2.new(0.6, 0, 0, 4)
    valTxt.BackgroundTransparency = 1
    valTxt.Font = Enum.Font.GothamBold
    valTxt.Text = tostring(default) .. " " .. unit
    valTxt.TextColor3 = Color3.fromRGB(255, 45, 55)
    valTxt.TextSize = 11
    valTxt.TextXAlignment = Enum.TextXAlignment.Right
    valTxt.Parent = frame

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 28)
    sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = frame
    local sbCrn = Instance.new("UICorner")
    sbCrn.CornerRadius = UDim.new(0, 3)
    sbCrn.Parent = sliderBar

    local fill = Instance.new("Frame")
    local pct = math.clamp((default - min) / (max - min), 0, 1)
    fill.Size = UDim2.new(pct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 45, 55)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBar
    local fCrn = Instance.new("UICorner")
    fCrn.CornerRadius = UDim.new(0, 3)
    fCrn.Parent = fill

    local dragging = false
    local function updateSlider(input)
        local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local newPct = relativeX / sliderBar.AbsoluteSize.X
        fill.Size = UDim2.new(newPct, 0, 1, 0)
        local value = math.floor(min + (max - min) * newPct)
        valTxt.Text = tostring(value) .. " " .. unit
        callback(value)
        RequestSaveSettings()
        NotifyLabel.Text = "💾 บันทึกการตั้งค่าล่าสุดแล้ว!"
        NotifyLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
    end

    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
end

-- 3. ADD CHOICE/DROPDOWN COMPONENT
local function AddChoice(page, label, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -5, 0, 34)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    frame.Parent = page
    local crn = Instance.new("UICorner")
    crn.CornerRadius = UDim.new(0, 6)
    crn.Parent = frame

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0.5, 0, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamMedium
    txt.Text = label
    txt.TextColor3 = Color3.fromRGB(230, 230, 230)
    txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = frame

    local currentIdx = 1
    for i, opt in ipairs(options) do
        if opt == default then currentIdx = i break end
    end

    local choiceBtn = Instance.new("TextButton")
    choiceBtn.Size = UDim2.new(0.45, 0, 0, 24)
    choiceBtn.Position = UDim2.new(0.52, 0, 0.5, -12)
    choiceBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
    choiceBtn.Font = Enum.Font.GothamBold
    choiceBtn.Text = options[currentIdx]
    choiceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    choiceBtn.TextSize = 10
    choiceBtn.Parent = frame
    local cCrn = Instance.new("UICorner")
    cCrn.CornerRadius = UDim.new(0, 4)
    cCrn.Parent = choiceBtn

    choiceBtn.MouseButton1Click:Connect(function()
        currentIdx = currentIdx + 1
        if currentIdx > #options then currentIdx = 1 end
        choiceBtn.Text = options[currentIdx]
        callback(options[currentIdx])
        RequestSaveSettings()
        NotifyLabel.Text = "💾 บันทึกการตั้งค่าล่าสุดแล้ว!"
        NotifyLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
    end)
end

-- 4. ADD BUTTON COMPONENT
local function AddButton(page, label, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -5, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Parent = page
    local crn = Instance.new("UICorner")
    crn.CornerRadius = UDim.new(0, 6)
    crn.Parent = btn

    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- ====================================================================
-- 📑 CREATE TABS & ADD ALL CONTROLS
-- ====================================================================
local CombatPage = CreateTab("Combat", "🎯")
local VisualsPage = CreateTab("Visuals", "👁️")
local MovementPage = CreateTab("Move", "⚡")
local TeleportPage = CreateTab("Teleport", "🚀")
local MiscPage = CreateTab("Misc", "🎁")

-- --------------------------------------------------------------------
-- 🎯 TAB 1: COMBAT
-- --------------------------------------------------------------------
AddToggle(CombatPage, "Master Aim Lock", Config.AimLock, function(v) Config.AimLock = v end)
AddToggle(CombatPage, "Sticky Lock (ล็อคติดแน่นไม่หลุด)", Config.StickyLock, function(v) Config.StickyLock = v end)
AddChoice(CombatPage, "Target Bone", {"Head", "Torso"}, Config.Bone, function(v) Config.Bone = v end)
AddChoice(CombatPage, "Trigger Mode", {"Hold Key (Shift)", "Hold RMB (Right Click)", "Always On"}, Config.TriggerMode, function(v) Config.TriggerMode = v end)
AddChoice(CombatPage, "Priority Mode", {"Closest Distance", "Closest Crosshair"}, Config.Priority, function(v) Config.Priority = v end)
AddSlider(CombatPage, "Lock Speed (Smoothness)", 10, 100, Config.Smoothness, "%", function(v) Config.Smoothness = v end)
AddToggle(CombatPage, "Show FOV Circle", Config.ShowFOV, function(v) Config.ShowFOV = v end)
AddSlider(CombatPage, "FOV Circle Radius", 20, 400, Config.FOVRadius, "px", function(v) Config.FOVRadius = v end)
AddToggle(CombatPage, "Aim Lock Tracer (เส้นชี้เป้า)", Config.ShowAimTracer, function(v) Config.ShowAimTracer = v end)

-- --------------------------------------------------------------------
-- 👁️ TAB 2: VISUALS & ESP
-- --------------------------------------------------------------------
AddToggle(VisualsPage, "Red Top Screen Bar", Config.ShowTopLine, function(v)
    Config.ShowTopLine = v
    TopRedLine.Visible = v
end)
AddToggle(VisualsPage, "Master Player ESP", Config.ESP, function(v) Config.ESP = v end)
AddToggle(VisualsPage, "ESP Boxes (กรอบสี่เหลี่ยม)", Config.ESPBoxes, function(v) Config.ESPBoxes = v end)
AddToggle(VisualsPage, "ESP Names & Distance (ชื่อ & ระยะ)", Config.ESPNames, function(v) Config.ESPNames = v end)
AddToggle(VisualsPage, "ESP Health Bar (หลอดเลือด)", Config.ESPHealth, function(v) Config.ESPHealth = v end)
AddToggle(VisualsPage, "ESP Snaplines (เส้นจากขอบจอบน)", Config.ESPSnaplines, function(v) Config.ESPSnaplines = v end)
AddSlider(VisualsPage, "ESP Max Distance", 100, 700, Config.MaxDist, "Studs", function(v) Config.MaxDist = v end)
AddToggle(VisualsPage, "🚀 FPS & Map Booster", Config.FPSBooster, function(v)
    Config.FPSBooster = v
    if v then applyFPSBoost() end
end)
AddToggle(VisualsPage, "🛡️ Anti-Flashbang / Anti-Blind", Config.AntiFlashbang, function(v) Config.AntiFlashbang = v end)

-- --------------------------------------------------------------------
-- ⚡ TAB 3: MOVEMENT
-- --------------------------------------------------------------------
AddToggle(MovementPage, "Speed Hack", Config.Speed, function(v) Config.Speed = v end)
AddSlider(MovementPage, "WalkSpeed Value", 16, 80, Config.WalkSpeed, "Speed", function(v) Config.WalkSpeed = v end)
AddToggle(MovementPage, "Infinite Jump", Config.InfJump, function(v) Config.InfJump = v end)
AddButton(MovementPage, "🔄 Instant Respawn", function()
    pcall(function()
        local r = ReplicatedStorage.Remotes.Replication.Fighter.ResetCharacter
        if r then r:FireServer() end
    end)
end)

-- --------------------------------------------------------------------
-- 🚀 TAB 4: TELEPORTS
-- --------------------------------------------------------------------
local Spawns = {
    ["Hub Center"] = CFrame.new(109, -680, 1184),
    ["Duels Spawn"] = CFrame.new(186, -677.5, 1184),
    ["Shooting Range"] = CFrame.new(1407, -714, 1044),
    ["Waiting Room"] = CFrame.new(120, -636, 1965),
    ["NPC: SenseiWarrior (Market)"] = CFrame.new(122, -676, 1295),
    ["NPC: Nosniy (Weapons)"] = CFrame.new(86, -676, 1110)
}
for name, cf in pairs(Spawns) do
    AddButton(TeleportPage, "🚀 TP: " .. name, function()
        local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = cf + Vector3.new(0, 3, 0) end
    end)
end

-- --------------------------------------------------------------------
-- 🎁 TAB 5: MISC
-- --------------------------------------------------------------------
AddButton(MiscPage, "🎁 Claim All Free Gifts & Pass", function()
    pcall(function()
        local remotes = ReplicatedStorage.Remotes.Data
        if remotes:FindFirstChild("ClaimBattlePassReward") then remotes.ClaimBattlePassReward:FireServer() end
        if remotes:FindFirstChild("ClaimWelcomeBackGift") then remotes.ClaimWelcomeBackGift:FireServer() end
        if remotes:FindFirstChild("ClaimGroupReward") then remotes.ClaimGroupReward:FireServer() end
        if remotes:FindFirstChild("ClaimLikeReward") then remotes.ClaimLikeReward:FireServer() end
        if remotes:FindFirstChild("ClaimFavoriteReward") then remotes.ClaimFavoriteReward:FireServer() end
        if remotes:FindFirstChild("ClaimNotificationsReward") then remotes.ClaimNotificationsReward:FireServer() end
    end)
end)

AddButton(MiscPage, "🔀 Server Hop (สุ่มย้ายเซิร์ฟเวอร์)", function()
    pcall(function()
        local res = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        if res and res.data then
            for _, s in ipairs(res.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                    return
                end
            end
        end
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

AddButton(MiscPage, "🔄 Rejoin Current Server", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

AddButton(MiscPage, "💾 Save Settings to Disk", function()
    RequestSaveSettings()
end)

AddButton(MiscPage, "🔄 Reset Settings to Default", function()
    pcall(function()
        if delfile and isfile and isfile(ConfigFileName) then delfile(ConfigFileName) end
    end)
end)

-- Default Open Combat Tab
TabPages["Combat"].Visible = true
TabButtons["Combat"].BackgroundColor3 = Color3.fromRGB(255, 45, 55)
TabButtons["Combat"].TextColor3 = Color3.fromRGB(255, 255, 255)

-- Toggle Menu Key (RightControl)
table.insert(_G.SakaHubConnections, UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
        if MainFrame.Visible then MiniLogo.Visible = false end
    end
end))

print("👑 [SAKA HUB] RIVALS Pure Edition V13.0 Loaded Successfully!")
