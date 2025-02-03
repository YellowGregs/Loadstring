-- esp.lua
--// Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera
local cache = {}

local bones = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

--// Settings
local ESP_SETTINGS = {
    BoxOutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    Teamcheck = false,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeletons = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1), 
    TracerThickness = 2,
    SkeletonsColor = Color3.new(1, 1, 1),
    TracerPosition = "Bottom",
}

local function create(class, properties)
    local drawing = Drawing.new(class)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function createEsp(player)
    local esp = {
        tracer = create("Line", {
            Thickness = ESP_SETTINGS.TracerThickness,
            Color = ESP_SETTINGS.TracerColor,
            Transparency = 0.5
        }),
        boxOutline = create("Square", {
            Color = ESP_SETTINGS.BoxOutlineColor,
            Thickness = 3,
            Filled = false
        }),
        box = create("Square", {
            Color = ESP_SETTINGS.BoxColor,
            Thickness = 1,
            Filled = false
        }),
        name = create("Text", {
            Color = ESP_SETTINGS.NameColor,
            Outline = true,
            Center = true,
            Size = 13
        }),
        healthOutline = create("Line", {
            Thickness = 3,
            Color = ESP_SETTINGS.HealthOutlineColor
        }),
        health = create("Line", {
            Thickness = 1
        }),
        distance = create("Text", {
            Color = Color3.new(1, 1, 1),
            Size = 12,
            Outline = true,
            Center = true
        }),
        boxLines = {},
        skeletonlines = {}
    }

    cache[player] = esp
end

local function isPlayerBehindWall(player)
    local character = player.Character
    if not character then return false end

    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end

    local ray = Ray.new(camera.CFrame.Position, (rootPart.Position - camera.CFrame.Position).Unit * (rootPart.Position - camera.CFrame.Position).Magnitude)
    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {localPlayer.Character, character})
    
    return hit and hit:IsA("Part")
end

local function removeEsp(player)
    local esp = cache[player]
    if not esp then return end

    for _, drawing in pairs(esp) do
        if typeof(drawing) == "table" then
            for _, line in ipairs(drawing) do
                line:Remove()
            end
        else
            drawing:Remove()
        end
    end

    cache[player] = nil
end

local function updateEsp()
    for player, esp in pairs(cache) do
        local character, team = player.Character, player.Team
        if character and (not ESP_SETTINGS.Teamcheck or (team and team ~= localPlayer.Team)) then
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local head = character:FindFirstChild("Head")
            local humanoid = character:FindFirstChild("Humanoid")
            local isBehindWall = ESP_SETTINGS.WallCheck and isPlayerBehindWall(player)
            local shouldShow = not isBehindWall and ESP_SETTINGS.Enabled
            
            if rootPart and head and humanoid and shouldShow then
                local position, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local hrp2D = camera:WorldToViewportPoint(rootPart.Position)
                    local charSize = (camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0)).Y - camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 2.6, 0)).Y) / 2
                    local boxSize = Vector2.new(math.floor(charSize * 1.8), math.floor(charSize * 1.9))
                    local boxPosition = Vector2.new(math.floor(hrp2D.X - charSize * 1.8 / 2), math.floor(hrp2D.Y - charSize * 1.6 / 2))

                    -- Name ESP
                    if ESP_SETTINGS.ShowName then
                        esp.name.Visible = true
                        esp.name.Text = string.lower(player.Name)
                        esp.name.Position = Vector2.new(boxSize.X / 2 + boxPosition.X, boxPosition.Y - 16)
                        esp.name.Color = ESP_SETTINGS.NameColor
                    else
                        esp.name.Visible = false
                    end

                    -- Box ESP
                    if ESP_SETTINGS.ShowBox then
                        if ESP_SETTINGS.BoxType == "2D" then
                            -- Add Later
                            esp.boxOutline.Size = boxSize
                            esp.boxOutline.Position = boxPosition
                            esp.box.Size = boxSize
                            esp.box.Position = boxPosition
                            esp.box.Color = ESP_SETTINGS.BoxColor
                            esp.box.Visible = true
                            esp.boxOutline.Visible = true
                            for _, line in ipairs(esp.boxLines) do line:Remove() end
                            esp.boxLines = {}
                        elseif ESP_SETTINGS.BoxType == "Corner Box Esp" then
                            -- Add later
                        elseif ESP_SETTINGS.BoxType == "3D" then
                            local rootPos = rootPart.Position
                            local headPos = head.Position
                            
                            -- Calculate 3D box dimensions
                            local bottom = rootPos.Y - 3
                            local top = headPos.Y + 0.5
                            local width = 2.5
                            local depth = 2.5

                            -- 8 corners of the 3D box
                            local corners = {
                                Vector3.new(rootPos.X - width, bottom, rootPos.Z - depth), -- 1
                                Vector3.new(rootPos.X + width, bottom, rootPos.Z - depth), -- 2
                                Vector3.new(rootPos.X + width, bottom, rootPos.Z + depth), -- 3
                                Vector3.new(rootPos.X - width, bottom, rootPos.Z + depth), -- 4
                                Vector3.new(rootPos.X - width, top, rootPos.Z - depth),    -- 5
                                Vector3.new(rootPos.X + width, top, rootPos.Z - depth),    -- 6
                                Vector3.new(rootPos.X + width, top, rootPos.Z + depth),    -- 7
                                Vector3.new(rootPos.X - width, top, rootPos.Z + depth),    -- 8
                            }

                            -- Convert to screen space
                            local screenCorners = {}
                            for i, corner in ipairs(corners) do
                                local screenPos, onScreen = camera:WorldToViewportPoint(corner)
                                screenCorners[i] = onScreen and Vector2.new(screenPos.X, screenPos.Y) or nil
                            end

                            -- edges
                            local edges = {
                                {1, 2}, {2, 3}, {3, 4}, {4, 1},  -- Bottom square
                                {5, 6}, {6, 7}, {7, 8}, {8, 5},  -- Top square
                                {1, 5}, {2, 6}, {3, 7}, {4, 8},  -- Vertical edges
                            }

                            if #esp.boxLines ~= 24 then
                                for _, line in ipairs(esp.boxLines) do line:Remove() end
                                esp.boxLines = {}
                                for i = 1, 24 do
                                    esp.boxLines[i] = create("Line", {
                                        Thickness = i <= 12 and 3 or 1,
                                        Color = i <= 12 and ESP_SETTINGS.BoxOutlineColor or ESP_SETTINGS.BoxColor,
                                        Transparency = 1
                                    })
                                end
                            end

                            -- Update lines
                            for i, edge in ipairs(edges) do
                                local outline = esp.boxLines[i]
                                local main = esp.boxLines[i + 12]
                                local fromCorner = screenCorners[edge[1]]
                                local toCorner = screenCorners[edge[2]]

                                if fromCorner and toCorner then
                                    outline.From = fromCorner
                                    outline.To = toCorner
                                    outline.Visible = true
                                    main.From = fromCorner
                                    main.To = toCorner
                                    main.Visible = true
                                else
                                    outline.Visible = false
                                    main.Visible = false
                                end
                            end
                            esp.box.Visible = false
                            esp.boxOutline.Visible = false
                        end
                    else
                        esp.box.Visible = false
                        esp.boxOutline.Visible = false
                        for _, line in ipairs(esp.boxLines) do line:Remove() end
                        esp.boxLines = {}
                    end

                    -- Health bar
                    if ESP_SETTINGS.ShowHealth then
                        local healthPercentage = humanoid.Health / humanoid.MaxHealth
                        esp.healthOutline.From = Vector2.new(boxPosition.X - 6, boxPosition.Y + boxSize.Y)
                        esp.healthOutline.To = Vector2.new(boxPosition.X - 6, boxPosition.Y)
                        esp.health.From = Vector2.new(boxPosition.X - 5, boxPosition.Y + boxSize.Y)
                        esp.health.To = Vector2.new(boxPosition.X - 5, boxPosition.Y + boxSize.Y - (boxSize.Y * healthPercentage))
                        esp.health.Color = ESP_SETTINGS.HealthLowColor:Lerp(ESP_SETTINGS.HealthHighColor, healthPercentage)
                        esp.healthOutline.Visible = true
                        esp.health.Visible = true
                    else
                        esp.healthOutline.Visible = false
                        esp.health.Visible = false
                    end

                    -- Distance
                    if ESP_SETTINGS.ShowDistance then
                        local distance = (camera.CFrame.p - rootPart.Position).Magnitude
                        esp.distance.Text = string.format("%.1f studs", distance)
                        esp.distance.Position = Vector2.new(boxPosition.X + boxSize.X / 2, boxPosition.Y + boxSize.Y + 5)
                        esp.distance.Visible = true
                    else
                        esp.distance.Visible = false
                    end

                    -- Skeleton
                    if ESP_SETTINGS.ShowSkeletons then
                        for _, lineData in ipairs(esp.skeletonlines) do lineData[1]:Remove() end
                        esp.skeletonlines = {}
                        
                        for _, bonePair in ipairs(bones) do
                            local parent = character:FindFirstChild(bonePair[1])
                            local child = character:FindFirstChild(bonePair[2])
                            if parent and child then
                                local line = create("Line", {
                                    Thickness = 1,
                                    Color = ESP_SETTINGS.SkeletonsColor,
                                    Transparency = 1
                                })
                                table.insert(esp.skeletonlines, {line, parent, child})
                            end
                        end
                        
                        for _, lineData in ipairs(esp.skeletonlines) do
                            local line, parent, child = unpack(lineData)
                            local parentPos = camera:WorldToViewportPoint(parent.Position)
                            local childPos = camera:WorldToViewportPoint(child.Position)
                            
                            line.From = Vector2.new(parentPos.X, parentPos.Y)
                            line.To = Vector2.new(childPos.X, childPos.Y)
                            line.Visible = true
                        end
                    else
                        for _, lineData in ipairs(esp.skeletonlines) do lineData[1]:Remove() end
                        esp.skeletonlines = {}
                    end

                    -- Tracer
                    if ESP_SETTINGS.ShowTracer then
                        local tracerY = ESP_SETTINGS.TracerPosition == "Top" and 0 
                            or ESP_SETTINGS.TracerPosition == "Middle" and camera.ViewportSize.Y/2 
                            or camera.ViewportSize.Y
                        
                        esp.tracer.From = Vector2.new(camera.ViewportSize.X/2, tracerY)
                        esp.tracer.To = Vector2.new(hrp2D.X, hrp2D.Y)
                        esp.tracer.Visible = true
                    else
                        esp.tracer.Visible = false
                    end
                else
                    for _, drawing in pairs(esp) do
                        if drawing ~= esp.boxLines and drawing ~= esp.skeletonlines then
                            drawing.Visible = false
                        end
                    end
                end
            else
                for _, drawing in pairs(esp) do
                    if drawing ~= esp.boxLines and drawing ~= esp.skeletonlines then
                        drawing.Visible = false
                    end
                end
            end
        else
            for _, drawing in pairs(esp) do
                if drawing ~= esp.boxLines and drawing ~= esp.skeletonlines then
                    drawing.Visible = false
                end
            end
        end
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= localPlayer then
        createEsp(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= localPlayer then
        createEsp(player)
    end
end)

Players.PlayerRemoving:Connect(removeEsp)

RunService.RenderStepped:Connect(updateEsp)
return ESP_SETTINGS
