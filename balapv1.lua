--====================================================
-- 🇮🇩 RALINE LITE | NO-LINK EDITION (UPDATED WITH KEYBINDS)
--====================================================

-- SERVICES
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- SETTINGS TABLE
local Settings = {
    Speed = false, Jump = false, SpeedVal = 17, JumpVal = 51.5,
    Bright = false, HidePlayers = false, CleanVisuals = false, Boost = false,
    Crosshair = false, Moonwalk = false, Spin = false
}

local ComfortLightingConn = nil
local CrosshairGui = nil
local IsDragging = false
local DragInput, DragStart, startPos

-- Variabel untuk menyimpan referensi tombol Moonwalk di UI (agar bisa diubah warnanya via keybind)
local MoonwalkButtonRef = nil

--====================================================
-- 🧠 MASTER CONTROLLER (LOGIC UTAMA)
--====================================================
RunService.RenderStepped:Connect(function()
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChild("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    
    if not Humanoid or not RootPart then return end

    -- 1. SPEED & JUMP
    if Settings.Speed then
        if Humanoid.WalkSpeed ~= Settings.SpeedVal then Humanoid.WalkSpeed = Settings.SpeedVal end
    else
        if Humanoid.WalkSpeed ~= 17 then Humanoid.WalkSpeed = 17 end
    end

    if Settings.Jump then
        if Humanoid.JumpPower ~= Settings.JumpVal then Humanoid.JumpPower = Settings.JumpVal end
    else
        if Humanoid.JumpPower ~= 51.5 then Humanoid.JumpPower = 51.5 end
    end

    -- 2. MOONWALK
    if Settings.Moonwalk then
        Humanoid.AutoRotate = false
        if Humanoid.MoveDirection.Magnitude > 0 then
            local CameraCF = Workspace.CurrentCamera.CFrame
            local lookVector = CameraCF.LookVector * Vector3.new(1, 0, 1) * -1
            local goalCF = CFrame.lookAt(RootPart.Position, RootPart.Position + lookVector)
            RootPart.CFrame = RootPart.CFrame:Lerp(goalCF, 0.2)
        end
    else
        if not Settings.Spin then Humanoid.AutoRotate = true end
    end

    -- 3. SPIN SLOW
    if Settings.Spin then
        Humanoid.AutoRotate = false
        if Humanoid.MoveDirection.Magnitude > 0 then
            RootPart.CFrame = RootPart.CFrame * CFrame.Angles(0, math.rad(-4), 0)
        end
    end
end)

-- FUNGSI FITUR TAMBAHAN
local function UpdateCrosshair()
    if CrosshairGui then CrosshairGui:Destroy() end
    if Settings.Crosshair then
        local gui = Instance.new("ScreenGui")
        gui.Name = "RalineCrosshair"
        gui.ResetOnSpawn = false
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 6, 0, 6)
        frame.Position = UDim2.new(0.5, -3, 0.5, -3)
        frame.BackgroundColor3 = Color3.new(1, 1, 1)
        frame.BorderSizePixel = 0
        frame.ZIndex = 10
        frame.Parent = gui
        CrosshairGui = gui
    end
end

local function ApplyBrightness()
    if not Settings.Bright then return end
    if Lighting.ClockTime >= 6 and Lighting.ClockTime <= 18 then
        Lighting.Brightness = 1.5; Lighting.Ambient = Color3.fromRGB(150, 150, 150)
        Lighting.GlobalShadows = true; Lighting.FogEnd = 1000
    else
        Lighting.Brightness = 2.5; Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        Lighting.GlobalShadows = false; Lighting.FogEnd = 10000
    end
end

local function UpdatePlayerVisibility(Char)
    if not Char then return end
    local target = Settings.HidePlayers and 1 or 0
    task.spawn(function()
        for _, obj in pairs(Char:GetDescendants()) do
            if obj:IsA("BasePart") then obj.LocalTransparencyModifier = target
            elseif obj:IsA("Decal") then obj.Transparency = target end
        end
    end)
end

local function SetupPlayerMonitor(plr)
    if plr == LocalPlayer then return end
    if plr.Character then UpdatePlayerVisibility(plr.Character) end
    plr.CharacterAdded:Connect(UpdatePlayerVisibility)
end
for _, plr in pairs(Players:GetPlayers()) do SetupPlayerMonitor(plr) end
Players.PlayerAdded:Connect(SetupPlayerMonitor)

local function ToggleParticles(state)
    task.spawn(function()
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Trail") then
                obj.Enabled = state
            end
        end
    end)
end

-- Fungsi Notifikasi Sederhana
local function Notify(text)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Parent = CoreGui
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 200, 0, 40)
    notifFrame.Position = UDim2.new(0, 20, 0, 20)
    notifFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notifFrame.Parent = notifGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notifFrame
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.TextColor3 = Color3.new(1,1,1)
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Parent = notifFrame
    local tween = TweenService:Create(notifFrame, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 20, 0, -50), BackgroundTransparency = 1})
    tween:Play()
    tween.Completed:Connect(function() notifGui:Destroy() end)
end

--====================================================
-- 🎨 UI MANUAL (CUSTOM MADE - NO LIBRARY)
--====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RalineLiteUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 430, 0, 540)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = false -- Kita buat manual drag

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 100, 100)
Stroke.Thickness = 1
Stroke.Parent = MainFrame

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1
Header.Text = "🚗 RALINE LITE | KEYBIND: K & F"
Header.TextColor3 = Color3.fromRGB(255, 255, 255)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 16
Header.Parent = MainFrame
Header.TextWrapped = true

-- Helper to make elements
local yOffset = 50
local function CreateToggle(Name, Callback, StoreRef)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 30)
    Frame.Position = UDim2.new(0, 10, 0, yOffset)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Frame.BorderSizePixel = 0
    Frame.Parent = MainFrame
    
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 6)
    FCorner.Parent = Frame

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, -40, 1, 0)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Color3.fromRGB(200, 200, 200)
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame
    Text.Position = UDim2.new(0, 10, 0, 0)

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 30, 0, 16)
    Btn.Position = UDim2.new(1, -35, 0.5, -8)
    Btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Btn.BorderSizePixel = 0
    Btn.Parent = Frame
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = Btn

    local State = false
    
    -- Fungsi internal untuk update visual dan callback
    local function ToggleLogic(newState)
        State = newState
        Btn.BackgroundColor3 = State and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 100)
        Callback(State)
    end

    Btn.MouseButton1Click:Connect(function()
        ToggleLogic(not State)
    end)
    
    -- Simpan referensi tombol jika diminta (untuk Moonwalk)
    if StoreRef then
        StoreRef({
            SetState = function(val) ToggleLogic(val) end,
            GetState = function() return State end
        })
    end
    
    yOffset = yOffset + 35
end

local function CreateSlider(Name, Min, Max, Default, Callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -20, 0, 40)
    Frame.Position = UDim2.new(0, 10, 0, yOffset)
    Frame.BackgroundTransparency = 1
    Frame.Parent = MainFrame

    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, 0, 0, 20)
    Text.Text = Name .. ": " .. Default
    Text.TextColor3 = Color3.fromRGB(200, 200, 200)
    Text.Font = Enum.Font.Gotham
    Text.TextSize = 13
    Text.TextXAlignment = Enum.TextXAlignment.Left
    Text.Parent = Frame

    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(1, 0, 0, 10)
    Slider.Position = UDim2.new(0, 0, 0, 25)
    Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    Slider.BorderSizePixel = 0
    Slider.Text = ""
    Slider.Parent = Frame
    local SCorner = Instance.new("UICorner")
    SCorner.CornerRadius = UDim.new(0, 4)
    SCorner.Parent = Slider

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Slider
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 4)
    FCorner.Parent = Fill

    Slider.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local scale = math.clamp((input.Position.X - Slider.AbsolutePosition.X) / Slider.AbsoluteSize.X, 0, 1)
                local val = math.floor(Min + (Max - Min) * scale)
                Fill.Size = UDim2.new(scale, 0, 1, 0)
                Text.Text = Name .. ": " .. val
                Callback(val)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                moveConn:Disconnect()
            end
        end)
    end)
    
    yOffset = yOffset + 45
end

local function CreateButton(Name, Callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, yOffset)
    Btn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn.Text = Name
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBold
    Btn.BorderSizePixel = 0
    Btn.Parent = MainFrame
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = Btn
    Btn.MouseButton1Click:Connect(Callback)
    yOffset = yOffset + 40
end

local function CreateSection(Name)
    yOffset = yOffset + 5
    local Text = Instance.new("TextLabel")
    Text.Size = UDim2.new(1, 0, 0, 20)
    Text.Position = UDim2.new(0, 0, 0, yOffset)
    Text.BackgroundTransparency = 1
    Text.Text = Name
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 14
    Text.Parent = MainFrame
    yOffset = yOffset + 25
end

-- DRAG LOGIC
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = true
        DragStart = input.Position
        startPos = MainFrame.Position
    end
end)
Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        IsDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and IsDragging then
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- BUILD UI
CreateSection("⚡ MOVEMENT")
CreateToggle("Speed Hack", function(v) Settings.Speed = v end)
CreateSlider("Speed Value", 17, 45, 17, function(v) Settings.SpeedVal = v end)
CreateToggle("Jump Power", function(v) Settings.Jump = v end)
CreateSlider("Jump Value", 51.5, 100, 51.5, function(v) Settings.JumpVal = v end)

CreateSection("👁️ VISUALS")
CreateToggle("Auto Brightness", function(v)
    Settings.Bright = v
    if v then
        ApplyBrightness()
        ComfortLightingConn = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(ApplyBrightness)
    else
        if ComfortLightingConn then ComfortLightingConn:Disconnect() end
        Lighting.Brightness = 2; Lighting.FogEnd = 1000; Lighting.GlobalShadows = true
    end
end)
CreateToggle("Hide Players", function(v)
    Settings.HidePlayers = v
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then UpdatePlayerVisibility(plr.Character) end
    end
end)
CreateToggle("Clean Particles", function(v)
    Settings.CleanVisuals = v
    ToggleParticles(not v)
end)
CreateToggle("FPS Boost", function(v)
    Settings.Boost = v
    settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
    Lighting.GlobalShadows = not v
end)

CreateSection("🤪 FUN / SEPUH")
CreateToggle("Crosshair", function(v)
    Settings.Crosshair = v
    UpdateCrosshair()
end)

-- Buat Toggle Moonwalk dengan Referensi (StoreRef) agar bisa diakses keybind
CreateToggle("Moonwalk [KEY: F]", function(v) Settings.Moonwalk = v end, function(ref)
    MoonwalkButtonRef = ref
end)

CreateToggle("Slow Spin (Sepuh)", function(v) Settings.Spin = v end)

CreateSection("🗑️ SYSTEM")
CreateButton("❌ DESTROY & RESET", function()
    for k, _ in pairs(Settings) do Settings[k] = false end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 17; hum.JumpPower = 51.5; hum.AutoRotate = true end
    end
    if ComfortLightingConn then ComfortLightingConn:Disconnect() end
    Lighting.Brightness = 2; Lighting.FogEnd = 1000; Lighting.GlobalShadows = true
    settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then UpdatePlayerVisibility(plr.Character) end
    end
    ToggleParticles(true)
    if CrosshairGui then CrosshairGui:Destroy() end
    ScreenGui:Destroy()
end)

--====================================================
-- ⌨️ KEYBIND SYSTEM (K & F)
--====================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Mencegah keybind aktif saat sedang mengetik di chat
    if gameProcessed then return end

    -- KEYBIND K: Toggle UI
    if input.KeyCode == Enum.KeyCode.K then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    -- KEYBIND F: Toggle Moonwalk
    if input.KeyCode == Enum.KeyCode.F then
        if MoonwalkButtonRef then
            -- Dapatkan state saatini dari tombol UI lalu balik (Toggle)
            local currentState = MoonwalkButtonRef.GetState()
            local newState = not currentState
            
            -- Set state baru lewat referensi (ini akan update warna tombol & logic)
            MoonwalkButtonRef.SetState(newState)
            
            -- Tampilkan notifikasi
            if newState then
                Notify("🚶 MOONWALK: ON")
            else
                Notify("🚶 MOONWALK: OFF")
            end
        end
    end
end)
