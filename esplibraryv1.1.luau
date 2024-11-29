--NOTE THIS CODE IS STILL IN DEVELOPMENT AND IS BROKEN AS HELL DONT FUCKING USE IT WHILE IM STILL SCRIPTING IT AND NEEDS TO BE FIX 


--[[

ToDo:
- Fix Corner Esp.
- Add 3D Box -- will take awhile 
- add a Team Table
- Properly fix Arrow Offscreen (broken)
- Improve Skeleton Esp 
- Properly Fix remove_esp funtion
- FIX TO THE GODDAMN VECTOR2 & VECTOR3 ErROR SHIT I KEPT GETTING IN THE CONSOELLOGS
- etc 

- im so fucking pissed since its fucking 3 am in the goddamn morning and i scripted this in 3 hours, while using my and linemaster esp library that has no updates,
  - and i havent slept in 3 days so i dont know if i will remember what i scripted for this esp library shit when i wake up
   - and yes im getting sleep right now so thank god, also fuck this trash esp 

]]

--/ Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

--/ Settings
local Esp_Settings = {
    Enabled = true,
    TeamCheck = true,
    -- Team = { --// will implent this later
    --     Enabled = true,
    --     TeamCheck = false,
    --     FriendlyColor = Color3.fromRGB(0, 255, 0),
    --     EnemyColor = Color3.fromRGB(255, 0, 0),
    -- },
    WallCheck = false,
    
    Box = {
        ShowBox = true,
        BoxOutlineColor = Color3.new(0, 0, 0),
        BoxColor = Color3.new(1, 1, 1),
        BoxType = "2D", -- "2D", "Corner", "3D"
        BoxThickness = 2,
    },

    Name = {
        ShowName = true,
        NameColor = Color3.new(1, 1, 1),
        TextSize = 14,
    },

    Health = {
        ShowHealth = true,
        HealthOutlineColor = Color3.new(0, 0, 0),
        HealthHighColor = Color3.new(0, 1, 0),
        HealthLowColor = Color3.new(1, 0, 0),
        ShowHealthNumber = true,
    },

    Distance = {
        ShowDistance = true,
        DistanceColor = Color3.new(1, 1, 1),
        DistanceTextSize = 12,
    },

    Tracer = {
        ShowTracer = true,
        TracerPosition = "Bottom", -- Bottom, Middle, Top
        TracerColor = Color3.new(1, 1, 1),
        TracerThickness = 2,
    },

    Skeleton = {
        ShowSkeleton = true,
        SkeletonColor = Color3.new(1, 1, 1),
    },

    Arrow = {
        ShowArrow = true,
        ArrowColor = Color3.new(1, 0, 0),
        ArrowSize = 15,
        ArrowThickness = 3,
    },
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function create_esp(player)
    local esp = {
        tracer = create("Line", {
            Thickness = Esp_Settings.Tracer.TracerThickness,
            Color = Esp_Settings.Tracer.TracerColor,
        }),
        box = create("Square", {
            Color = Esp_Settings.Box.BoxColor,
            Thickness = Esp_Settings.Box.BoxThickness,
            Filled = false,
        }),
        boxCorners = {},
        name = create("Text", {
            Color = Esp_Settings.Name.NameColor,
            Outline = true,
            Center = true,
            Size = Esp_Settings.Name.TextSize,
        }),
        distance = create("Text", {
            Color = Esp_Settings.Distance.DistanceColor,
            Size = Esp_Settings.Distance.DistanceTextSize,
            Outline = true,
            Center = true,
        }),
        healthBar = create("Line", {
            Thickness = 2,
        }),
        arrow = create("Triangle", {
            Color = Esp_Settings.Arrow.ArrowColor,
            Thickness = Esp_Settings.Arrow.ArrowThickness,
        }),
    }

    -- CornerBox Lines
    for _ = 1, 4 do
        table.insert(esp.boxCorners, create("Line", {
            Color = Esp_Settings.Box.BoxColor,
            Thickness = Esp_Settings.Box.BoxThickness,
        }))
    end

    cache[player] = esp
end

local function remove_esp(player)
    local esp = cache[player]
    if esp then
        for _, element in pairs(esp) do
            if typeof(element) == "table" then
                for _, line in pairs(element) do
                    if line.Remove then
                        line:Remove()
                    end
                end
            elseif element.Remove then
                element:Remove()
            end
        end
        cache[player] = nil
    end
end

local function get_offscreen_position(screenPos)
    local viewportSize = camera.ViewportSize
    local center = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local direction = (screenPos - center).Unit

    local edgePosition = center + direction * (math.min(viewportSize.X, viewportSize.Y) / 2 - Esp_Settings.Arrow.ArrowSize)
    return edgePosition, direction
end

local function esp_name(player, rootPos, size, distance, onScreen) -- still in development :shrug:
    local esp = cache[player]
    if not esp then return end

    -- Box ESP
    if Esp_Settings.Box.ShowBox then
        if Esp_Settings.Box.BoxType == "2D" then
            esp.box.Position = rootPos - size / 2
            esp.box.Size = size
            esp.box.Visible = true
        elseif Esp_Settings.Box.BoxType == "Corner" then
            local corners = {
                -- stupid does not work
                Vector2.new(rootPos.X - size.X / 2, rootPos.Y - size.Y / 2), -- Top left
                Vector2.new(rootPos.X + size.X / 2, rootPos.Y - size.Y / 2), -- Top right
                Vector2.new(rootPos.X - size.X / 2, rootPos.Y + size.Y / 2), -- Bottom left
                Vector2.new(rootPos.X + size.X / 2, rootPos.Y + size.Y / 2), -- Bottom right
            }
            esp.box.Visible = false
            for i, line in ipairs(esp.boxCorners) do
                line.From = corners[i]
                line.To = corners[(i % 4) + 1]
                line.Visible = true
            end
        end
    else
        esp.box.Visible = false
    end

    -- Name 
    if Esp_Settings.Name.ShowName then
        esp.name.Position = rootPos - Vector2.new(0, size.Y / 2 + 15)
        esp.name.Text = player.Name
        esp.name.Visible = true
    else
        esp.name.Visible = false
    end

    -- Distance
    if Esp_Settings.Distance.ShowDistance then
        esp.distance.Position = rootPos + Vector2.new(0, size.Y / 2 + 15)
        esp.distance.Text = tostring(math.floor(distance)) .. "m"
        esp.distance.Visible = true
    else
        esp.distance.Visible = false
    end

    -- Health
    if Esp_Settings.Health.ShowHealth then
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local healthColor = Esp_Settings.Health.HealthHighColor:Lerp(Esp_Settings.Health.HealthLowColor, 1 - healthPercent)
            esp.healthBar.Color = healthColor
            esp.healthBar.From = rootPos - Vector2.new(size.X / 2 + 5, size.Y / 2)
            esp.healthBar.To = esp.healthBar.From + Vector2.new(0, size.Y * healthPercent)
            esp.healthBar.Visible = true
        end
    else
        esp.healthBar.Visible = false
    end

    -- Arrow (Offscreen) shitty 
    if not onScreen and Esp_Settings.Arrow.ShowArrow then
        local arrowPos, direction = get_offscreen_position(Vector2.new(rootPos.X, rootPos.Y))
        local arrowSize = Esp_Settings.Arrow.ArrowSize

        esp.arrow.PointA = arrowPos
        esp.arrow.PointB = arrowPos + direction * arrowSize
        esp.arrow.PointC = arrowPos + direction:Perpendicular() * arrowSize / 2
        esp.arrow.Visible = true
    else
        esp.arrow.Visible = false
    end
end
-- ahhhhhhhhhhhhhhhhhhh
local function update_esp()
    RunService.RenderStepped:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player == localPlayer then continue end

            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChild("Humanoid")

            if not rootPart or not humanoid or humanoid.Health <= 0 then
                remove_esp(player)
                continue
            end

            if Esp_Settings.TeamCheck and player.Team == localPlayer.Team then
                remove_esp(player)
                continue
            end

            if Esp_Settings.WallCheck and BehindWall(player) then
                remove_esp(player)
                continue
            end

            if not cache[player] then
                create_esp(player)
            end

            local screenPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude

            esp_name(player, Vector2.new(screenPos.X, screenPos.Y), Vector2.new(50, 100), distance, onScreen)
        end
    end)
end

update_esp()

return Esp_Settings
