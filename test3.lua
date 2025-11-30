local Drawing = {}

local native_drawings = false
pcall(function()
    local test = Drawing.new("Line")
    test:Remove()
    native_drawings = true
end)

if native_drawings then
    print("[DrawingLib] Native Drawing API detected - using executor Drawing")
    
    Drawing.Fonts = Drawing.Fonts or {
        UI = 0,
        System = 1,
        Plex = 2,
        Monospace = 3,
        Pixel = 4,
    }
    
    Drawing.Font = Drawing.Font or {}
    Drawing.Font.new = Drawing.Font.new or function(name, data)
        print("[DrawingLib] Custom font registration not required on this executor")
    end
    
    return Drawing
end

print("[DrawingLib] No native Drawing API detected → using GUI fallback")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DrawingFallbackLib"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999999
screenGui.Parent = PlayerGui

Drawing.Clear = function()
    screenGui:ClearAllChildren()
end

Drawing.Fonts = {
    UI = 0,
    System = 1,
    Plex = 2,
    Monospace = 3,
    Pixel = 4,
}

local FontMap = {
    [0] = Font.new(Enum.Font.Gotham),          -- UI
    [1] = Font.new(Enum.Font.GothamBold),      -- System
    [2] = Font.new(Enum.Font.SourceSansPro),    -- Plex (closest)
    [3] = Font.new(Enum.Font.RobotoMono),     -- Monospace
    [4] = Font.new(Enum.Font.Arcade),         -- Pixel
}

if not Enum.Font.RobotoMono then
    FontMap[3] = Font.new(Enum.Font.Code)
end

local registeredFonts = {}

Drawing.Font = {}
function Drawing.Font.new(name: string, data: string): Font?
    local assetId = data:match("^rbxassetid://(%d+)") or data:match("^rbxasset://.*/(%d+)") or (tonumber(data) and tonumber(data))
    if assetId then
        local ok, font = pcall(Font.fromId, assetId)
        if ok then
            registeredFonts[name] = font
            return font
        end
    end
    
    warn(`[DrawingLib] Failed to load custom font '{name}' — only rbxassetid:// URLs supported in fallback`)
    return Font.new(Enum.Font.Gotham)
end

local function makeLineGui()
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BorderSizePixel = 0
    frame.BackgroundColor3 = Color3.new(1, 1, 1)
    frame.Parent = screenGui
    return frame
end

local function updateLineGui(lineGui, from: Vector2, to: Vector2, thickness: number, color: Color3, transparency: number, zindex: number)
    if from == to or transparency >= 1 then
        lineGui.Visible = false
        return
    end

    local direction = to - from
    local center = from + direction / 2
    local length = direction.Magnitude

    lineGui.Size = UDim2.fromOffset(length, thickness)
    lineGui.Position = UDim2.fromOffset(center.X, center.Y)
    lineGui.Rotation = math.deg(math.atan2(direction.Y, direction.X))
    lineGui.BackgroundColor3 = color
    lineGui.BackgroundTransparency = transparency
    lineGui.ZIndex = zindex
    lineGui.Visible = true
end

function Drawing.new(Type: string)
    local typeLower = Type:lower()
    local obj = {
        Visible = true,
        Color = Color3.new(1, 1, 1),
        Transparency = 0,
        ZIndex = 1,
        Remove = function(self)
            if self._gui then self._gui:Destroy() end
            if self._lines then
                for _, line in self._lines do line:Destroy() end
            end
            self = nil
        end,
        Destroy = function(self) self:Remove() end,
    }

    local gui
    local uicorner, uistroke
    local lines = {} -- for triangle/quad
    local update

    if typeLower == "line" then
        gui = makeLineGui()

        obj.Thickness = 1
        obj.From = Vector2.new(0, 0)
        obj.To = Vector2.new(0, 0)

        update = function()
            updateLineGui(gui, obj.From, obj.To, obj.Thickness, obj.Color, obj.Transparency, obj.ZIndex)
        end

    elseif typeLower == "circle" then
        gui = Instance.new("Frame")
        gui.BorderSizePixel = 0
        gui.Parent = screenGui

        uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(1, 0)
        uicorner.Parent = gui

        uistroke = Instance.new("UIStroke")
        uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uistroke.Parent = gui

        obj.Position = Vector2.new(300, 300)
        obj.Radius = 50
        obj.Thickness = 2
        obj.Filled = true
        obj.NumSides = 100

        update = function()
            if not obj.Visible then gui.Visible = false return end

            local diameter = obj.Radius * 2
            gui.Size = UDim2.fromOffset(diameter, diameter)
            gui.Position = UDim2.fromOffset(obj.Position.X - obj.Radius, obj.Position.Y - obj.Radius)
            gui.ZIndex = obj.ZIndex
            gui.BackgroundColor3 = obj.Color
            gui.BackgroundTransparency = obj.Filled and obj.Transparency or 1
            uistroke.Color = obj.Color
            uistroke.Transparency = obj.Transparency
            uistroke.Thickness = obj.Thickness
            uistroke.Enabled = not obj.Filled

            if obj.NumSides and obj.NumSides < 64 then
                warn("[DrawingLib] Low NumSides not supported in fallback — using smooth circle")
            end
        end

    elseif typeLower == "square" or typeLower == "rect" then
        gui = Instance.new("Frame")
        gui.BorderSizePixel = 0
        gui.Parent = screenGui

        uicorner = Instance.new("UICorner")
        uicorner.Parent = gui

        uistroke = Instance.new("UIStroke")
        uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uistroke.Parent = gui

        obj.Position = Vector2.new(0, 0)
        obj.Size = Vector2.new(100, 100)
        obj.Filled = true
        obj.Thickness = 2
        obj.Rounding = 0

        update = function()
            if not obj.Visible then gui.Visible = false return end

            gui.Position = UDim2.fromOffset(obj.Position.X, obj.Position.Y)
            gui.Size = UDim2.fromOffset(obj.Size.X, obj.Size.Y)
            gui.ZIndex = obj.ZIndex
            gui.BackgroundColor3 = obj.Color
            gui.BackgroundTransparency = obj.Filled and obj.Transparency or 1
            uistroke.Color = obj.Color
            uistroke.Transparency = obj.Transparency
            uistroke.Thickness = obj.Thickness
            uistroke.Enabled = not obj.Filled
            uicorner.CornerRadius = UDim.new(0, obj.Rounding)
        end

    elseif typeLower == "text" then
        gui = Instance.new("TextLabel")
        gui.BackgroundTransparency = 1
        gui.TextColor3 = obj.Color
        gui.TextTransparency = obj.Transparency
        gui.TextSize = 14
        gui.FontFace = FontMap[0]
        gui.Text = "Text"
        gui.Parent = screenGui

        uistroke = Instance.new("UIStroke")
        uistroke.Thickness = 3
        uistroke.Parent = gui

        obj.Text = "Text"
        obj.Size = 14
        obj.TextSize = 14
        obj.Center = false
        obj.Outline = false
        obj.OutlineColor = Color3.new(0, 0, 0)
        obj.Font = Drawing.Fonts.UI

        update = function()
            if not obj.Visible then gui.Visible = false return end

            gui.Position = UDim2.fromOffset(obj.Position.X, obj.Position.Y)
            gui.AnchorPoint = obj.Center and Vector2.new(0.5, 0.5) or Vector2.new(0, 0)
            gui.Text = obj.Text
            gui.TextColor3 = obj.Color
            gui.TextTransparency = obj.Transparency
            gui.TextSize = obj.TextSize or obj.Size
            gui.ZIndex = obj.ZIndex

            -- Font handling
            if typeof(obj.Font) == "number" then
                gui.FontFace = FontMap[obj.Font] or Font.new(Enum.Font.Gotham)
            elseif typeof(obj.Font) == "string" then
                gui.FontFace = registeredFonts[obj.Font] or Font.new(Enum.Font.Gotham)
            elseif typeof(obj.Font) == "Font" then
                gui.FontFace = obj.Font
            end

            uistroke.Enabled = obj.Outline
            uistroke.Color = obj.OutlineColor
            uistroke.Transparency = obj.Transparency
        end

        -- Readonly TextBounds
        getmetatable(obj).__index = function(t, k)
            if k == "TextBounds" then
                return gui.TextBounds
            end
            return rawget(t, k)
        end

    elseif typeLower == "image" then
        gui = Instance.new("ImageLabel")
        gui.BackgroundTransparency = 1
        gui.ImageColor3 = obj.Color
        gui.ImageTransparency = obj.Transparency
        gui.ResampleMode = Enum.ResamplerMode.Pixelated
        gui.Parent = screenGui

        uicorner = Instance.new("UICorner")
        uicorner.Parent = gui

        obj.Position = Vector2.new(0, 0)
        obj.Size = Vector2.new(100, 100)
        obj.Data = ""
        obj.Uri = ""
        obj.Rounding = 0

        update = function()
            if not obj.Visible then gui.Visible = false return end

            gui.Position = UDim2.fromOffset(obj.Position.X, obj.Position.Y)
            gui.Size = UDim2.fromOffset(obj.Size.X, obj.Size.Y)
            gui.ZIndex = obj.ZIndex
            gui.ImageColor3 = obj.Color
            gui.ImageTransparency = obj.Transparency
            uicorner.CornerRadius = UDim.new(0, obj.Rounding)

            if obj.Data ~= "" then
                warn("[DrawingLib] Image.Data (base64/file) not supported in fallback — use Uri with rbxassetid:// or http(s)://")
            end

            if obj.Uri ~= "" then
                local uri = obj.Uri
                if uri:match("^https?://") then
                    if HttpService.HttpEnabled then
                        gui.Image = uri
                    else
                        warn("[DrawingLib] HttpEnabled = false — cannot load image URL: "..uri)
                        gui.Image = ""
                    end
                else
                    gui.Image = uri:gsub("^rbxasset://", "rbxassetid://")
                end
            end
        end

    elseif typeLower == "triangle" then
        obj.PointA = Vector2.new(100, 100)
        obj.PointB = Vector2.new(200, 100)
        obj.PointC = Vector2.new(150, 200)
        obj.Thickness = 2
        obj.Filled = false

        local line1 = makeLineGui()
        local line2 = makeLineGui()
        local line3 = makeLineGui()
        obj._lines = {line1, line2, line3}

        if obj.Filled then
            warn("[DrawingLib] Filled triangles not supported in fallback")
            obj.Filled = false
        end

        update = function()
            if not obj.Visible or obj.Transparency >= 1 then
                for _, line in obj._lines do line.Visible = false end
                return
            end

            for _, line in obj._lines do
                line.BackgroundColor3 = obj.Color
                line.BackgroundTransparency = obj.Transparency
                line.ZIndex = obj.ZIndex
                line.Visible = true
            end

            updateLineGui(line1, obj.PointA, obj.PointB, obj.Thickness)
            updateLineGui(line2, obj.PointB, obj.PointC, obj.Thickness)
            updateLineGui(line3, obj.PointC, obj.PointA, obj.Thickness)
        end

    elseif typeLower == "quad" then
        obj.PointA = Vector2.new(100, 100)
        obj.PointB = Vector2.new(200, 100)
        obj.PointC = Vector2.new(200, 200)
        obj.PointD = Vector2.new(100, 200)
        obj.Thickness = 2
        obj.Filled = false

        local line1 = makeLineGui()
        local line2 = makeLineGui()
        local line3 = makeLineGui()
        local line4 = makeLineGui()
        obj._lines = {line1, line2, line3, line4}

        if obj.Filled then
            warn("[DrawingLib] Filled quads not supported in fallback")
            obj.Filled = false
        end

        update = function()
            if not obj.Visible or obj.Transparency >= 1 then
                for _, line in obj._lines do line.Visible = false end
                return
            end

            for _, line in obj._lines do
                line.BackgroundColor3 = obj.Color
                line.BackgroundTransparency = obj.Transparency
                line.ZIndex = obj.ZIndex
                line.Visible = true
            end

            updateLineGui(line1, obj.PointA, obj.PointB, obj.Thickness)
            updateLineGui(line2, obj.PointB, obj.PointC, obj.Thickness)
            updateLineGui(line3, obj.PointC, obj.PointD, obj.Thickness)
            updateLineGui(line4, obj.PointD, obj.PointA, obj.Thickness)
        end

    else
        error("Invalid Drawing type: "..Type)
    end

    local mt = {
        __index = obj,
        __newindex = function(t, k, v)
            obj[k] = v
            if update then update() end
        end,
    }

    local proxy = setmetatable({}, mt)

    update()

    return proxy
end

return Drawing
