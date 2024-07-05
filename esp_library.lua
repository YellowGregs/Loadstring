-- esp_library.lua

local ESP = {}

ESP.Settings = {
    Enabled = false,
    Arrow = {
        Enable = false,
        TeamCheck = true,
        DistFromCenter = 80,
        TriangleHeight = 16,
        TriangleWidth = 16,
        TriangleFilled = true,
        TriangleTransparency = 0,
        TriangleThickness = 1,
        TriangleColor = Color3.fromRGB(255, 255, 255),
        AntiAliasing = false
    },
    Box = {
        Enable = false,
        TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 255, 255),
        BoxThickness = 1,
        BoxTransparency = 1
    },
    Cham = {
        Enable = false,
        TeamCheck = true,
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
        Color = Color3.fromRGB(255, 0, 0),
        TeamColor = false
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
    },
    Highlight = {
        Enable = false,
        FillColor = Color3.fromRGB(175, 25, 255),
        DepthMode = "AlwaysOnTop",
        FillTransparency = 0.5,
        OutlineColor = Color3.fromRGB(255, 255, 255),
        OutlineTransparency = 0
    }
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
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
        arrow = create("Triangle", {
            Thickness = ESP.Settings.Arrow.TriangleThickness,
            Color = ESP.Settings.Arrow.TriangleColor,
            Transparency = 1 - ESP.Settings.Arrow.TriangleTransparency,
            Filled = ESP.Settings.Arrow.TriangleFilled,
            Visible = false
        }),
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
        highlight = Instance.new("Highlight", CoreGui:FindFirstChild("Highlight_Storage") or Instance.new("Folder", CoreGui))
    }
    
    for i = 1, 16 do
        table.insert(esp.cornerBox, create("Line", {
            Thickness = 1,
            Color = ESP.Settings.CornerBox.BoxColor,
            Transparency = 1,
            Visible = false
        }))
    end
    
    esp.highlight.FillColor = ESP.Settings.Highlight.FillColor
    esp.highlight.DepthMode = ESP.Settings.Highlight.DepthMode
    esp.highlight.FillTransparency = ESP.Settings.Highlight.FillTransparency
    esp.highlight.OutlineColor = ESP.Settings.Highlight.OutlineColor
    esp.highlight.OutlineTransparency = ESP.Settings.Highlight.OutlineTransparency
    esp.highlight.Adornee = player.Character
    
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

    esp.highlight:Destroy()
    cache[player] = nil
end

local function GetRelative(pos, char)
    if not char then return Vector2.new(0, 0) end

    local rootP = char.PrimaryPart.Position
    local camP = Camera.CFrame.Position
    local relative = CFrame.new(Vector3.new(rootP.X, camP.Y, rootP.Z), camP):PointToObjectSpace(pos)

    return Vector2.new(relative.X, relative.Z)
end

local function RelativeToCenter(v)
    return Camera.ViewportSize / 2 - v
end

local function RotateVect(v, a)
    a = math.rad(a)
    local x = v.x * math.cos(a) - v.y * math.sin(a)
    local y = v.x * math.sin(a) + v.y * math.cos(a)

    return Vector2.new(x, y)
end

local function DrawTriangle(color)
    local l = Drawing.new("Triangle")
    l.Visible = false
    l.Color = color
    l.Filled = ESP.Settings.Arrow.TriangleFilled
    l.Thickness = ESP.Settings.Arrow.TriangleThickness
    l.Transparency = 1 - ESP.Settings.Arrow.TriangleTransparency
    return l
end

local function AntiA(v)
    if not ESP.Settings.Arrow.AntiAliasing then return v end
    return Vector2.new(math.round(v.x), math.round(v.y))
end

local function ShowArrow(PLAYER)
    local Arrow = DrawTriangle(ESP.Settings.Arrow.TriangleColor)

    local function Update()
        local c; c = RunService.RenderStepped:Connect(function()
            if PLAYER and PLAYER.Character then
                local CHAR = PLAYER.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")

                if HUM and CHAR.PrimaryPart and HUM.Health > 0 then
                    local _, vis = Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if not vis then
                        local rel = GetRelative(CHAR.PrimaryPart.Position, LocalPlayer.Character)
                        local direction = rel.unit

                        local base = direction * ESP.Settings.Arrow.DistFromCenter
                        local sideLength = ESP.Settings.Arrow.TriangleWidth / 2
                        local baseL = base + RotateVect(direction, 90) * sideLength
                        local baseR = base + RotateVect(direction, -90) * sideLength

                        local tip = direction * (ESP.Settings.Arrow.DistFromCenter + ESP.Settings.Arrow.TriangleHeight)

                        Arrow.PointA = AntiA(RelativeToCenter(baseL))
                        Arrow.PointB = AntiA(RelativeToCenter(baseR))
                        Arrow.PointC = AntiA(RelativeToCenter(tip))

                        Arrow.Visible = true
                    else
                        Arrow.Visible = false
                    end
                else
                    Arrow.Visible = false
                end
            else
                Arrow.Visible = false

                if not PLAYER or not PLAYER.Parent then
                    Arrow:Remove()
                    c:Disconnect()
                end
            end
        end)
    end

    coroutine.wrap(Update)()
end

local function updateEsp()
    for player, esp in pairs(cache) do
        local character, team = player.Character, player.Team
        if character and (not ESP.Settings.Box.TeamCheck or (team and team ~= LocalPlayer.Team)) then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            local shouldShow = ESP.Settings.Enabled

            if rootPart and head and humanoid and shouldShow then
                local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local hrp2D = Camera:WorldToViewportPoint(rootPart.Position)
                    local charSize = (Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.8 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    if ESP.Settings.Arrow.Enable and ESP.Settings.Enabled then
                        ShowArrow(player)
                    else
                        esp.arrow.Visible = false
                    end

                    if ESP.Settings.Box.Enable and ESP.Settings.Enabled then
                        esp.box.Size = boxSize
                        esp.box.Position = boxPosition
                        esp.box.Color = ESP.Settings.Box.BoxColor
                        esp.box.Visible = true
                    else
                        esp.box.Visible = false
                    end

                    if ESP.Settings.Cham.Enable and ESP.Settings.Enabled then
                        esp.highlight.Adornee = character
                        esp.highlight.Enabled = true
                    else
                        esp.highlight.Enabled = false
                    end

                    if ESP.Settings.Health.Enable and ESP.Settings.Enabled then
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

                    if ESP.Settings.Distance.Enable and ESP.Settings.Enabled then
                        local distance = (Camera.CFrame.p - rootPart.Position).Magnitude
                        esp.distance.Text = string.format("%.1f studs", distance)
                        esp.distance.Position = Vector2.new(boxPosition.X + boxSize.X / 2, boxPosition.Y + boxSize.Y + 5)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end

                    if ESP.Settings.Tracer.Enable and ESP.Settings.Enabled then
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

                    if ESP.Settings.CornerBox.Enable and ESP.Settings.Enabled then
                        local lineW = (boxSize.X / 5)
                        local lineH = (boxSize.Y / 6)
                        local lineT = 1

                        local boxLines = esp.cornerBox
                        -- top left
                        boxLines[1].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y - lineT)
                        boxLines[1].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y - lineT)

                        boxLines[2].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y - lineT)
                        boxLines[2].To = Vector2.new(boxPosition.X - lineT, boxPosition.Y + lineH)

                        -- top right
                        boxLines[3].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y - lineT)
                        boxLines[3].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y - lineT)

                        boxLines[4].From = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y - lineT)
                        boxLines[4].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + lineH)

                        -- bottom left
                        boxLines[5].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y - lineH)
                        boxLines[5].To = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y + lineT)

                        boxLines[6].From = Vector2.new(boxPosition.X - lineT, boxPosition.Y + boxSize.Y + lineT)
                        boxLines[6].To = Vector2.new(boxPosition.X + lineW, boxPosition.Y + boxSize.Y + lineT)

                        -- bottom right
                        boxLines[7].From = Vector2.new(boxPosition.X + boxSize.X - lineW, boxPosition.Y + boxSize.Y + lineT)
                        boxLines[7].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y + lineT)

                        boxLines[8].From = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y - lineH)
                        boxLines[8].To = Vector2.new(boxPosition.X + boxSize.X + lineT, boxPosition.Y + boxSize.Y + lineT)

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
