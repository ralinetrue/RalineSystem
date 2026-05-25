--[[

🧠 RALINE UI SYSTEM (FULL IMPROVED)
✔ More Faster
✔ More Lightweight
✔ Better Stability
✔ Optimized Render
✔ Better ESP
✔ Better Crosshair
✔ Stable Reverse Walk
✔ Better Hide Players
✔ God Mode
✔ FX Optimizer
✔ Cleaned System

]]

-------------------------------------------------
-- SERVICES
-------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")

-------------------------------------------------
-- PLAYER
-------------------------------------------------

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Root = Character:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(char)

    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    Root = char:WaitForChild("HumanoidRootPart")

end)

-------------------------------------------------
-- RAYFIELD
-------------------------------------------------

local Rayfield = loadstring(
    game:HttpGet("https://sirius.menu/rayfield")
)()

local Window = Rayfield:CreateWindow({
    Name = "👑 Raline UI System",
    LoadingTitle = "Raline UI",
    LoadingSubtitle = "Full Improved",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RalineUI",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false,
})

-------------------------------------------------
-- STATE
-------------------------------------------------

local State = {

    Speed = {
        Enabled = false,
        Value = 17
    },

    Jump = {
        Enabled = false,
        Value = 51
    },

    InfiniteJump = false,
    Noclip = false,
    ReverseWalk = false,
    GodMode = false,

    Visual = {
        Crosshair = false,
        Fullbright = false,
        Brightness = 5,
        HidePlayers = false,
        Shadows = false,
        FX = false,
        Zoom = 70,
    },

    ESP = {
        Box = false,
        Names = false,
        Distance = false,
    },
}

-------------------------------------------------
-- NOTIFY
-------------------------------------------------

local function Notify(title, text)

    Rayfield:Notify({
        Title = title,
        Content = text,
        Duration = 4,
    })

end

-------------------------------------------------
-- HOME TAB
-------------------------------------------------

local HomeTab = Window:CreateTab("🏠 Home", 4483362458)

HomeTab:CreateSection("👑 Welcome Dashboard")

HomeTab:CreateParagraph({
    Title = "👑 Welcome",
    Content = "Welcome back, "..LocalPlayer.Name
})

HomeTab:CreateLabel("Username : "..LocalPlayer.Name)

local device = UIS.TouchEnabled and "Mobile" or "PC"

HomeTab:CreateLabel("Device : "..device)

local FPSLabel = HomeTab:CreateLabel("FPS : 0")
local PingLabel = HomeTab:CreateLabel("Ping : 0")

task.spawn(function()

    while task.wait(1) do

        FPSLabel:Set(
            "FPS : "..math.floor(
                Workspace:GetRealPhysicsFPS()
            )
        )

        pcall(function()

            PingLabel:Set(
                "Ping : "..math.floor(
                    Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                ).."ms"
            )

        end)
    end
end)

HomeTab:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end,
})

HomeTab:CreateButton({
    Name = "⛔ Disable UI",
    Callback = function()
        Rayfield:Destroy()
    end,
})

-------------------------------------------------
-- PLAYER TAB
-------------------------------------------------

local PlayerTab = Window:CreateTab("⚡ Player", 4483362458)

-------------------------------------------------
-- SPEED
-------------------------------------------------

PlayerTab:CreateSection("🏃 Speed")

PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,

    Callback = function(v)
        State.Speed.Enabled = v
    end,
})

PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {17,45},
    Increment = 1,
    CurrentValue = 17,

    Callback = function(v)
        State.Speed.Value = v
    end,
})

-------------------------------------------------
-- JUMP
-------------------------------------------------

PlayerTab:CreateSection("🦘 Jump")

PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,

    Callback = function(v)
        State.Jump.Enabled = v
    end,
})

PlayerTab:CreateSlider({
    Name = "Jump Value",
    Range = {51,65},
    Increment = 1,
    CurrentValue = 51,

    Callback = function(v)
        State.Jump.Value = v
    end,
})

-------------------------------------------------
-- INFINITE JUMP
-------------------------------------------------

PlayerTab:CreateToggle({
    Name = "♾ Infinite Jump",
    CurrentValue = false,

    Callback = function(v)
        State.InfiniteJump = v
    end,
})

UIS.JumpRequest:Connect(function()

    if State.InfiniteJump and Humanoid then

        Humanoid:ChangeState(
            Enum.HumanoidStateType.Jumping
        )

    end
end)

-------------------------------------------------
-- NOCLIP
-------------------------------------------------

PlayerTab:CreateToggle({
    Name = "👻 Noclip",
    CurrentValue = false,

    Callback = function(v)
        State.Noclip = v
    end,
})

-------------------------------------------------
-- GOD MODE
-------------------------------------------------

PlayerTab:CreateToggle({
    Name = "🛡 God Mode",
    CurrentValue = false,

    Callback = function(v)

        State.GodMode = v

        Notify(
            "God Mode",
            v and "Enabled" or "Disabled"
        )
    end,
})

-------------------------------------------------
-- REVERSE WALK
-------------------------------------------------

PlayerTab:CreateToggle({
    Name = "🔄 Reverse Walk",
    CurrentValue = false,

    Callback = function(v)

        State.ReverseWalk = v

        Humanoid.AutoRotate = not v

        Notify(
            "Reverse Walk",
            v and "Enabled" or "Disabled"
        )
    end,
})

-------------------------------------------------
-- VISUAL TAB
-------------------------------------------------

local VisualTab = Window:CreateTab("👁 Visual", 4483362458)

-------------------------------------------------
-- ESP
-------------------------------------------------

VisualTab:CreateSection("📦 ESP")

VisualTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,

    Callback = function(v)
        State.ESP.Box = v
    end,
})

VisualTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = false,

    Callback = function(v)
        State.ESP.Names = v
    end,
})

VisualTab:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = false,

    Callback = function(v)
        State.ESP.Distance = v
    end,
})

-------------------------------------------------
-- CROSSHAIR
-------------------------------------------------

VisualTab:CreateToggle({
    Name = "✚ Crosshair",
    CurrentValue = false,

    Callback = function(v)
        State.Visual.Crosshair = v
    end,
})

-------------------------------------------------
-- FULLBRIGHT
-------------------------------------------------

VisualTab:CreateToggle({
    Name = "💡 Fullbright",
    CurrentValue = false,

    Callback = function(v)

        State.Visual.Fullbright = v

        if not v then

            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.Ambient = Color3.fromRGB(128,128,128)

        end
    end,
})

VisualTab:CreateSlider({
    Name = "Brightness",
    Range = {1,10},
    Increment = 1,
    CurrentValue = 5,

    Callback = function(v)
        State.Visual.Brightness = v
    end,
})

-------------------------------------------------
-- HIDE PLAYERS
-------------------------------------------------

local function SetPlayerVisible(character, visible)

    for _,obj in ipairs(character:GetDescendants()) do

        if obj:IsA("BasePart") then

            obj.LocalTransparencyModifier =
                visible and 0 or 1

        elseif obj:IsA("Decal") then

            obj.Transparency =
                visible and 0 or 1

        elseif obj:IsA("BillboardGui")
        or obj:IsA("SurfaceGui") then

            obj.Enabled = visible
        end
    end
end

VisualTab:CreateToggle({
    Name = "👥 Hide Players",
    CurrentValue = false,

    Callback = function(v)

        State.Visual.HidePlayers = v

        for _,plr in ipairs(Players:GetPlayers()) do

            if plr ~= LocalPlayer
            and plr.Character then

                SetPlayerVisible(
                    plr.Character,
                    not v
                )
            end
        end

        Notify(
            "Hide Players",
            v and "Players Hidden"
            or "Players Visible"
        )
    end,
})

-------------------------------------------------
-- SHADOWS
-------------------------------------------------

VisualTab:CreateToggle({
    Name = "🌑 Remove Shadows",
    CurrentValue = false,

    Callback = function(v)

        State.Visual.Shadows = v

        Lighting.GlobalShadows = not v
    end,
})

-------------------------------------------------
-- FX REMOVER
-------------------------------------------------

VisualTab:CreateToggle({
    Name = "🌪 Remove FX",
    CurrentValue = false,

    Callback = function(v)

        State.Visual.FX = v

        for _,obj in ipairs(
            Workspace:GetDescendants()
        ) do

            if obj:IsA("ParticleEmitter")
            or obj:IsA("Trail")
            or obj:IsA("Smoke")
            or obj:IsA("Fire") then

                obj.Enabled = not v
            end
        end
    end,
})

-------------------------------------------------
-- ZOOM
-------------------------------------------------

VisualTab:CreateSlider({
    Name = "🔍 Zoom",
    Range = {20,120},
    Increment = 1,
    CurrentValue = 70,

    Callback = function(v)

        State.Visual.Zoom = v

        LocalPlayer.CameraMaxZoomDistance = v

    end,
})

-------------------------------------------------
-- CROSSHAIR
-------------------------------------------------

local CrosshairGui = Instance.new("ScreenGui")

CrosshairGui.Name = "RalineCrosshair"
CrosshairGui.ResetOnSpawn = false
CrosshairGui.Parent = game.CoreGui

local function CreateLine(size, pos)

    local frame = Instance.new("Frame")

    frame.BackgroundColor3 = Color3.new(1,1,1)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5,0.5)
    frame.Position = pos
    frame.Size = size
    frame.Visible = false
    frame.Parent = CrosshairGui

    return frame
end

local Crosshair = {

    CreateLine(
        UDim2.new(0,2,0,10),
        UDim2.new(0.5,0,0.5,-8)
    ),

    CreateLine(
        UDim2.new(0,2,0,10),
        UDim2.new(0.5,0,0.5,8)
    ),

    CreateLine(
        UDim2.new(0,10,0,2),
        UDim2.new(0.5,-8,0.5,0)
    ),

    CreateLine(
        UDim2.new(0,10,0,2),
        UDim2.new(0.5,8,0.5,0)
    )
}

-------------------------------------------------
-- ESP SYSTEM
-------------------------------------------------

local ESPContainer = {}

local function CreateESP(player)

    if player == LocalPlayer then
        return
    end

    local function Setup(character)

        local head = character:FindFirstChild("Head")

        if not head then
            return
        end

        if ESPContainer[player] then

            for _,v in pairs(
                ESPContainer[player]
            ) do

                if v then
                    v:Destroy()
                end
            end
        end

        local billboard = Instance.new("BillboardGui")

        billboard.Size = UDim2.new(0,200,0,40)
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0,2.5,0)
        billboard.Parent = head

        local label = Instance.new("TextLabel")

        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1,0,1,0)
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
        label.TextStrokeTransparency = 0
        label.TextColor3 = Color3.new(1,1,1)
        label.Parent = billboard

        local highlight = Instance.new("Highlight")

        highlight.FillTransparency = 1
        highlight.OutlineColor = Color3.fromRGB(0,255,255)
        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        highlight.Parent = character

        ESPContainer[player] = {
            Billboard = billboard,
            Label = label,
            Highlight = highlight
        }
    end

    if player.Character then
        Setup(player.Character)
    end

    player.CharacterAdded:Connect(Setup)
end

for _,plr in ipairs(Players:GetPlayers()) do
    CreateESP(plr)
end

Players.PlayerAdded:Connect(CreateESP)

-------------------------------------------------
-- GOD MODE SYSTEM
-------------------------------------------------

local function EnableGodMode()

    if not Humanoid then
        return
    end

    Humanoid.Health = Humanoid.MaxHealth

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.FallingDown,
        false
    )

    Humanoid:SetStateEnabled(
        Enum.HumanoidStateType.Ragdoll,
        false
    )

    Humanoid.BreakJointsOnDeath = false
end

-------------------------------------------------
-- MAIN LOOP
-------------------------------------------------

RunService.RenderStepped:Connect(function()

    -------------------------------------------------
    -- SPEED
    -------------------------------------------------

    Humanoid.WalkSpeed =
        State.Speed.Enabled
        and State.Speed.Value
        or 16

    -------------------------------------------------
    -- JUMP
    -------------------------------------------------

    Humanoid.UseJumpPower = true

    Humanoid.JumpPower =
        State.Jump.Enabled
        and State.Jump.Value
        or 50

    -------------------------------------------------
    -- GOD MODE
    -------------------------------------------------

    if State.GodMode then
        EnableGodMode()
    end

    -------------------------------------------------
    -- NOCLIP
    -------------------------------------------------

    if State.Noclip then

        for _,v in ipairs(
            Character:GetChildren()
        ) do

            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -------------------------------------------------
    -- REVERSE WALK
    -------------------------------------------------

    if State.ReverseWalk then

        local move = Humanoid.MoveDirection

        if move.Magnitude > 0 then

            local look =
                Camera.CFrame.LookVector

            local dir =
                Vector3.new(
                    look.X,
                    0,
                    look.Z
                ).Unit

            Root.CFrame = Root.CFrame:Lerp(

                CFrame.lookAt(
                    Root.Position,
                    Root.Position + dir
                ) * CFrame.Angles(
                    0,
                    math.rad(180),
                    0
                ),

                0.15
            )
        end
    end

    -------------------------------------------------
    -- FULLBRIGHT
    -------------------------------------------------

    if State.Visual.Fullbright then

        Lighting.Brightness =
            State.Visual.Brightness

        Lighting.ClockTime = 14

        Lighting.Ambient =
            Color3.new(1,1,1)
    end

    -------------------------------------------------
    -- ESP
    -------------------------------------------------

    for player,data in pairs(
        ESPContainer
    ) do

        local char = player.Character

        local rootPart =
            char and char:FindFirstChild(
                "HumanoidRootPart"
            )

        if rootPart then

            local distance = math.floor(

                (Root.Position -
                rootPart.Position).Magnitude

            )

            data.Highlight.Enabled =
                State.ESP.Box

            if State.ESP.Names
            and State.ESP.Distance then

                data.Label.Text =
                    player.Name..
                    " | "..distance.."m"

            elseif State.ESP.Names then

                data.Label.Text =
                    player.Name

            elseif State.ESP.Distance then

                data.Label.Text =
                    distance.."m"

            else
                data.Label.Text = ""
            end

            data.Billboard.Enabled =
                State.ESP.Names
                or State.ESP.Distance
        end
    end

    -------------------------------------------------
    -- CROSSHAIR
    -------------------------------------------------

    for _,v in ipairs(Crosshair) do
        v.Visible = State.Visual.Crosshair
    end
end)

-------------------------------------------------
-- STARTUP
-------------------------------------------------

Notify(
    "Raline UI",
    "Full Improved Loaded"
)
