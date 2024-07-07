-- esp_library.lua
-- BROKEN DONT USE

local ESP = {}

ESP.Settings = {
    Enabled = false,
    Box = {
        Enable = false,
        TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        BoxThickness = 1,
        BoxTransparency = 1
    },
    Tracer = {
        Enable = false,
        TeamCheck = true,
        TracerColor = Color3.new(1, 1, 1),
        TracerThickness = 2,
        TracerPosition = "Bottom"
    },
    Health = {
        Enable = false,
        TeamCheck = true,
        HealthOutlineColor = Color3.new(0, 0, 0),
        HealthHighColor = Color3.new(0, 1, 0),
        HealthLowColor = Color3.new(1, 0, 0)
    },
    Distance = {
        Enable = false,
        TeamCheck = true,
        DistanceColor = Color3.new(1, 1, 1)
    },
    CornerBox = {
        Enable = false,
        TeamCheck = true,
        BoxOutlineColor = Color3.new(0, 0, 0),
        BoxColor = Color3.new(1, 1, 1),
        BoxThickness = 1
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local cache = {}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(player)
    local esp = {
        box = create("Square", {
            Color = ESP.Settings.Box.BoxColor,
            Thickness = ESP.Settings.Box.BoxThickness,
            Transparency = ESP.Settings.Box.BoxTransparency,
            Filled = false,
            Visible = false
        }),
        tracer = create("Line", {
            Thickness = ESP.Settings.Tracer.TracerThickness,
            Color = ESP.Settings.Tracer.TracerColor,
            Transparency = 1,
            Visible = false
        }),
        healthOutline = create("Line", {
            Thickness = 3,
            Color = ESP.Settings.Health.HealthOutlineColor,
            Visible = false
        }),
        health = create("Line", {
            Thickness = 1,
            Visible = false
        }),
        distance = create("Text", {
            Color = ESP.Settings.Distance.DistanceColor,
            Size = 12,
            Outline = true,
            Center = true,
            Visible = false
        }),
        cornerBox = {},
    }
    
    for i = 1, 8 do
        table.insert(esp.cornerBox, create("Line", {
            Thickness = ESP.Settings.CornerBox.BoxThickness,
            Color = ESP.Settings.CornerBox.BoxColor,
            Transparency = 1,
            Visible = false
        }))
    end
    
    cache[player] = esp
end

local function removeEsp(player)
    local esp = cache[player]
    if not esp then return end

    for _, drawing in pairs(esp) do
        if type(drawing) == "table" then
            for _, line in pairs(drawing) do
                line:Remove()
            end
        else
            drawing:Remove()
        end
    end

    cache[player] = nil
end

local function updateEsp()
    if not ESP.Settings.Enabled then
        for player, esp in pairs(cache) do
            for _, drawing in pairs(esp) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line.Visible = false
                    end
                else
                    drawing.Visible = false
                end
            end
        end
        return
    end

    for player, esp in pairs(cache) do
        local character, team = player.Character, player.Team
        if character and (not ESP.Settings.Box.TeamCheck or (team and team ~= LocalPlayer.Team)) then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")

            if rootPart and head and humanoid then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen and position.Z > 0 then
                    local hrp2D = Camera:WorldToViewportPoint(rootPart.Position)
                    local charSize = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.8 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    if ESP.Settings.Box.Enable then
                        esp.box.Size = boxSize
                        esp.box.Position = boxPosition
                        esp.box.Color = ESP.Settings.Box.BoxColor
                        esp.box.Visible = true
                    else
                        esp.box.Visible = false
                    end

                    if ESP.Settings.Health.Enable then
                        esp.healthOutline.Visible = true
                        esp.health.Visible = true
                        local healthPercentage = humanoid.Health / humanoid.MaxHealth
                        esp.healthOutline.From = Vector2.new(boxPosition.X - 6, boxPosition.Y + boxSize.Y)
                        esp.healthOutline.To = Vector2.new(esp.healthOutline.From.X, esp.healthOutline.From.Y - boxSize.Y)
                        esp.health.From = Vector2.new((boxPosition.X - 5), boxPosition.Y + boxSize.Y)
                        esp.health.To = Vector2.new(esp.health.From.X, esp.health.From.Y - (humanoid.Health / humanoid.MaxHealth) * boxSize.Y)
                        esp.health.Color = ESP.Settings.Health.HealthLowColor:Lerp(ESP.Settings.Health.HealthHighColor, healthPercentage)
                    else
                        esp.healthOutline.Visible = false
                        esp.health.Visible = false
                    end

                    if ESP.Settings.Distance.Enable then
                        local distance = (Camera.CFrame.p - rootPart.Position).Magnitude
                        esp.distance.Text = string.format("%.1f studs", distance)
                        esp.distance.Position = Vector2.new(boxPosition.X + boxSize.X / 2, boxPosition.Y + boxSize.Y + 5)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end

                    if ESP.Settings.Tracer.Enable then
                        local tracerY
                        if ESP.Settings.Tracer.TracerPosition == "Top" then
                            tracerY = 0
                        elseif ESP.Settings.Tracer.TracerPosition == "Middle" then
                            tracerY = Camera.ViewportSize.Y / 2
                        else
                            tracerY = Camera.ViewportSize.Y
                        end
                        esp.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, tracerY)
                        esp.tracer.To = Vector2.new(hrp2D.X, hrp2D.Y)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end

                    if ESP.Settings.CornerBox.Enable then
                        local lineW = (boxSize.X / 4)
                        local lineH = (boxSize.Y / 6)

                        local boxLines = esp.cornerBox
                        -- top left
                        boxLines[1].From = Vector2.new(boxPosition.X, boxPosition.Y)
                        boxLines[1].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y)

                        boxLines[2].From = Vector2.new(boxPosition.X, boxPosition.Y)
                        boxLines[2].To = Vector2.new(boxPosition.X, boxPosition.Y + lineH)

                        -- top right
                        boxLines[3].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y)
                        boxLines[3].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y)

                        boxLines[4].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y)
                        boxLines[4].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + lineH)

                        -- bottom left
                        boxLines[5].From = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y - lineH)
                        boxLines[5].To = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y)

                        boxLines[6].From = Vector2.new(boxPosition.X, boxPosition.Y + boxSize.Y)
                        boxLines[6].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y + boxSize.Y)

                        -- bottom right
                        boxLines[7].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y + boxSize.Y)
                        boxLines[7].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y)

                        boxLines[8].From = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y - lineH)
                        boxLines[8].To = Vector2.new(boxPosition.X + boxSize.X, boxPosition.Y + boxSize.Y)

                        for _, line in ipairs(boxLines) do
                            line.Visible = true
                        end
                    else
                        for _, line in ipairs(esp.cornerBox) do
                            line.Visible = false
                        end
                    end
                else
                    for _, drawing in pairs(esp) do
                        drawing.Visible = false
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    drawing.Visible = false
                end
            end
        else
            for _, drawing in pairs(esp) do
                drawing.Visible = false
            end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeEsp(player)
end)

RunService.RenderStepped:Connect(updateEsp)
return ESP
