--====================================================
-- 🇮🇩 RALINE INSTANT-LITE | 0 FPS DROP EDITION
--====================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--====================================================
-- ⚙️ SERVICES & VARIABLES
--====================================================
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid", 10)

-- Auto Respawn
LocalPlayer.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid", 10)
end)

local Settings = {
    Speed = false, Jump = false, SpeedVal = 17, JumpVal = 51.5,
    Bright = false, Dark = false, HidePlayers = false, 
    CleanVisuals = false, Boost = false
}

--====================================================
-- 🖥️ UI SETUP
--====================================================
local Window = Rayfield:CreateWindow({
   Name = "🚗 Raline Lite | Pandera",
   LoadingTitle = "Fast Load",
   LoadingSubtitle = "No Lag",
   ConfigurationSaving = {Enabled = false},
   KeySystem = false
})

local MainTab = Window:CreateTab("🎯 Main", 4483362458)

--====================================================
-- 🏃 MOVEMENT
--====================================================
MainTab:CreateSection("🏃 Movement")

MainTab:CreateToggle({
    Name = "Speed",
    CurrentValue = false,
    Callback = function(v) 
        Settings.Speed = v 
        Humanoid.WalkSpeed = v and Settings.SpeedVal or 17
    end
})

MainTab:CreateSlider({
    Name = "Speed Value",
    Range = {17, 40}, Increment = 0.5, CurrentValue = 17,
    Callback = function(v) 
        Settings.SpeedVal = v 
        if Settings.Speed then Humanoid.WalkSpeed = v end
    end
})

MainTab:CreateToggle({
    Name = "Jump Power",
    CurrentValue = false,
    Callback = function(v) 
        Settings.Jump = v 
        Humanoid.JumpPower = v and Settings.JumpVal or 51.5
    end
})

MainTab:CreateSlider({
    Name = "Jump Value",
    Range = {51.5, 75}, Increment = 0.5, CurrentValue = 51.5,
    Callback = function(v) 
        Settings.JumpVal = v 
        if Settings.Jump then Humanoid.JumpPower = v end
    end
})

-- Anti reset dari game (Tanpa loop, sangat ringan)
Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if Settings.Speed and Humanoid.WalkSpeed ~= Settings.SpeedVal then Humanoid.WalkSpeed = Settings.SpeedVal end
end)
Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
    if Settings.Jump and Humanoid.JumpPower ~= Settings.JumpVal then Humanoid.JumpPower = Settings.JumpVal end
end)

--====================================================
-- 👁️ VISUALS & HIDING
--====================================================
MainTab:CreateSection("👁️ Visuals & Hiding")

-- FULL BRIGHTNESS
ToggleBright = MainTab:CreateToggle({
    Name = "💡 Full Brightness",
    CurrentValue = false,
    Callback = function(v)
        Settings.Bright = v
        if v then
            if Settings.Dark then ToggleDark:Set(false) end -- Matikan Dark Mode
            Lighting.Brightness = 3
            Lighting.ClockTime = 14
            Lighting.FogEnd = 9e9
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(1,1,1)
        else
            -- Kembalikan ke default
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5,0.5,0.5)
        end
    end
})

-- DARK MODE (MINUS BRIGHTNESS)
ToggleDark = MainTab:CreateToggle({
    Name = "🌙 Dark Mode (Gelap)",
    CurrentValue = false,
    Callback = function(v)
        Settings.Dark = v
        if v then
            if Settings.Bright then ToggleBright:Set(false) end -- Matikan Brightness
            Lighting.Brightness = -1      -- Brightness Minus di sini
            Lighting.ClockTime = 0        -- Malam hari
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true -- Bayangan dinyalakan agar gelap
            Lighting.Ambient = Color3.new(0.1, 0.1, 0.1) -- Ambient sangat redup
        else
            -- Kembalikan ke default
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 1000
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.new(0.5,0.5,0.5)
        end
    end
})

-- HIDE PLAYERS
MainTab:CreateToggle({
    Name = "🙈 Hide Other Players",
    CurrentValue = false,
    Callback = function(v)
        Settings.HidePlayers = v
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then obj.LocalTransparencyModifier = v and 1 or 0 end
                    if obj:IsA("Decal") then obj.Transparency = v and 1 or 0 end
                end
            end
        end
    end
})

-- HIDE PARTICLES
MainTab:CreateToggle({
    Name = "🌪️ Hide Particles (Asep/Debu/Api/Air)",
    CurrentValue = false,
    Callback = function(v)
        Settings.CleanVisuals = v
        if v then
            task.spawn(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Beam") then
                        obj.Enabled = false
                    end
                end
            end)
        end
    end
})

-- FPS BOOST
MainTab:CreateToggle({
    Name = "🚀 FPS Boost (Anti Lag)",
    CurrentValue = false,
    Callback = function(v)
        Settings.Boost = v
        settings().Rendering.QualityLevel = v and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = not v
    end
})

--====================================================
-- 🗑️ SYSTEM
--====================================================
MainTab:CreateSection("🗑️ System")

MainTab:CreateButton({
    Name = "❌ Destroy & Reset Script",
    Callback = function()
        -- Reset ke default
        Humanoid.WalkSpeed = 17; Humanoid.JumpPower = 51.55
        Lighting.Brightness = 2; Lighting.ClockTime = 14
        Lighting.FogEnd = 1000; Lighting.GlobalShadows = true
        Lighting.Ambient = Color3.new(0.5,0.5,0.5)
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        
        -- Tampilkan pemain kembali
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, obj in pairs(plr.Character:GetDescendants()) do
                    if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 0 end
                    if obj:IsA("Decal") then obj.Transparency = 0 end
                end
            end
        end
        
        Rayfield:Destroy()
    end
})

--====================================================
-- 🧠 EVENT LISTENERS (Pengganti Loop, 0% Lag)
--====================================================

-- Tangkap partikel yang baru spawn
Workspace.DescendantAdded:Connect(function(obj)
    if Settings.CleanVisuals then
        if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Beam") then
            obj.Enabled = false
        end
    end
end)

-- Tangkap pemain yang baru spawn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        if Settings.HidePlayers then
            for _, obj in pairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 1 end
                if obj:IsA("Decal") then obj.Transparency = 1 end
            end
        end
    end)
end)
