local DrawingLib = {}

-- Helper functions
local function convertTransparency(transparency)
    return math.clamp(1 - transparency, 0, 1)
end

local function getFontFromIndex(fontIndex)
    return {
        [0] = Font.fromEnum(Enum.Font.Roboto),
        [1] = Font.fromEnum(Enum.Font.Legacy),
        [2] = Font.fromEnum(Enum.Font.SourceSans),
        [3] = Font.fromEnum(Enum.Font.RobotoMono)
    }[fontIndex]
end

local baseDrawingObj = {
    Visible = true,
    ZIndex = 0,
    Transparency = 1,
    Color = Color3.new(),
    Remove = function(self)
        setmetatable(self, nil)
    end,
    Destroy = function(self)
        setmetatable(self, nil)
    end
}

DrawingLib.Fonts = {
    ["UI"] = 0,
    ["System"] = 1,
    ["Plex"] = 2,
    ["Monospace"] = 3
}

local coreGui = game:GetService("CoreGui")
local drawingUI = Instance.new("ScreenGui")
drawingUI.Name = "Drawing"
drawingUI.IgnoreGuiInset = true
drawingUI.DisplayOrder = 0x7FFFFFFF
drawingUI.Parent = coreGui

local drawingIndex = 0

local function createDrawingObject(template)
    drawingIndex += 1
    return setmetatable(template, {
        __index = baseDrawingObj,
        __newindex = function(_, index, value)
            if template[index] == nil then
                warn("Invalid property: " .. tostring(index))
                return
            end
            template[index] = value
        end,
        __tostring = function() return "Drawing" end
    })
end

function DrawingLib.new(drawingType)
    if drawingType == "Line" then
        local line = Instance.new("Frame")
        line.Name = drawingIndex
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        line.BorderSizePixel = 0
        line.BackgroundTransparency = 1
        line.Parent = drawingUI

        local lineObj = createDrawingObject({
            From = Vector2.zero,
            To = Vector2.zero,
            Thickness = 1,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                line.Parent = parent
            end
        })

        function lineObj:Update()
            local direction = (self.To - self.From)
            local center = (self.To + self.From) / 2
            local distance = direction.Magnitude
            local theta = math.deg(math.atan2(direction.Y, direction.X))

            line.Size = UDim2.new(0, distance, 0, self.Thickness)
            line.Position = UDim2.fromOffset(center.X, center.Y)
            line.Rotation = theta
            line.BackgroundColor3 = self.Color
            line.BackgroundTransparency = convertTransparency(self.Transparency)
            line.ZIndex = self.ZIndex
            line.Visible = self.Visible
        end

        return lineObj
    elseif drawingType == "TextLabel" then
        local label = Instance.new("TextLabel")
        label.Name = drawingIndex
        label.AnchorPoint = Vector2.new(0.5, 0.5)
        label.BorderSizePixel = 0
        label.BackgroundTransparency = 1
        label.Parent = drawingUI

        local labelObj = createDrawingObject({
            Text = "",
            Font = DrawingLib.Fonts.UI,
            Size = 20,
            Position = Vector2.zero,
            Center = false,
            Outline = false,
            OutlineColor = Color3.new(),
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                label.Parent = parent
            end
        })

        function labelObj:Update()
            label.Text = self.Text
            label.FontFace = getFontFromIndex(self.Font)
            label.TextSize = self.Size
            label.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            label.TextColor3 = self.Color
            label.TextTransparency = convertTransparency(self.Transparency)
            label.ZIndex = self.ZIndex
            label.Visible = self.Visible
        end

        return labelObj
    elseif drawingType == "TextBox" then
        local textBox = Instance.new("TextBox")
        textBox.Name = drawingIndex
        textBox.AnchorPoint = Vector2.new(0.5, 0.5)
        textBox.BorderSizePixel = 0
        textBox.BackgroundTransparency = 1
        textBox.Parent = drawingUI

        local textBoxObj = createDrawingObject({
            Text = "",
            Font = DrawingLib.Fonts.UI,
            Size = 20,
            Position = Vector2.zero,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                textBox.Parent = parent
            end
        })

        function textBoxObj:Update()
            textBox.Text = self.Text
            textBox.FontFace = getFontFromIndex(self.Font)
            textBox.TextSize = self.Size
            textBox.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            textBox.TextColor3 = self.Color
            textBox.TextTransparency = convertTransparency(self.Transparency)
            textBox.ZIndex = self.ZIndex
            textBox.Visible = self.Visible
        end

        return textBoxObj
    elseif drawingType == "Circle" then
        local circle = Instance.new("Frame")
        local uiCorner = Instance.new("UICorner")
        local uiStroke = Instance.new("UIStroke")

        circle.Name = drawingIndex
        circle.AnchorPoint = Vector2.new(0.5, 0.5)
        circle.BorderSizePixel = 0

        uiCorner.CornerRadius = UDim.new(1, 0)
        uiCorner.Parent = circle
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = circle

        circle.Parent = drawingUI

        local circleObj = createDrawingObject({
            Radius = 50,
            Position = Vector2.zero,
            Thickness = 1,
            Filled = false,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                circle.Parent = parent
            end
        })

        function circleObj:Update()
            circle.Size = UDim2.fromOffset(self.Radius * 2, self.Radius * 2)
            circle.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            circle.BackgroundColor3 = self.Color
            circle.BackgroundTransparency = self.Filled and convertTransparency(self.Transparency) or 1
            uiStroke.Thickness = self.Thickness
            uiStroke.Transparency = convertTransparency(self.Transparency)
            uiStroke.Color = self.Color
            uiStroke.Enabled = not self.Filled
            circle.ZIndex = self.ZIndex
            circle.Visible = self.Visible
        end

        return circleObj
    elseif drawingType == "Square" then
        local square = Instance.new("Frame")
        local uiStroke = Instance.new("UIStroke")

        square.Name = drawingIndex
        square.BorderSizePixel = 0
        uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        uiStroke.Parent = square

        square.Parent = drawingUI

        local squareObj = createDrawingObject({
            Size = Vector2.new(100, 100),
            Position = Vector2.zero,
            Thickness = 1,
            Filled = false,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                square.Parent = parent
            end
        })

        function squareObj:Update()
            square.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
            square.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            square.BackgroundColor3 = self.Color
            square.BackgroundTransparency = self.Filled and convertTransparency(self.Transparency) or 1
            uiStroke.Thickness = self.Thickness
            uiStroke.Transparency = convertTransparency(self.Transparency)
            uiStroke.Color = self.Color
            uiStroke.Enabled = not self.Filled
            square.ZIndex = self.ZIndex
            square.Visible = self.Visible
        end

        return squareObj
    elseif drawingType == "Image" then
        local image = Instance.new("ImageLabel")
        image.Name = drawingIndex
        image.BorderSizePixel = 0
        image.ScaleType = Enum.ScaleType.Stretch
        image.BackgroundTransparency = 1
        image.Parent = drawingUI

        local imageObj = createDrawingObject({
            DataURL = "rbxassetid://0",
            Size = Vector2.zero,
            Position = Vector2.zero,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new(),
            SetParent = function(_, parent)
                image.Parent = parent
            end
        })

        function imageObj:Update()
            image.Image = self.DataURL
            image.Size = UDim2.fromOffset(self.Size.X, self.Size.Y)
            image.Position = UDim2.fromOffset(self.Position.X, self.Position.Y)
            image.ImageColor3 = self.Color
            image.ImageTransparency = convertTransparency(self.Transparency)
            image.ZIndex = self.ZIndex
            image.Visible = self.Visible
        end

        return imageObj
    elseif drawingType == "Quad" then
        local quadObj = createDrawingObject({
            PointA = Vector2.zero,
            PointB = Vector2.zero,
            PointC = Vector2.zero,
            PointD = Vector2.zero,
            Thickness = 1,
            Filled = false,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new()
        })

        local _linePoints = {
            A = DrawingLib.new("Line"),
            B = DrawingLib.new("Line"),
            C = DrawingLib.new("Line"),
            D = DrawingLib.new("Line")
        }

        function quadObj:Update()
            _linePoints.A.From = self.PointA
            _linePoints.A.To = self.PointB
            _linePoints.B.From = self.PointB
            _linePoints.B.To = self.PointC
            _linePoints.C.From = self.PointC
            _linePoints.C.To = self.PointD
            _linePoints.D.From = self.PointD
            _linePoints.D.To = self.PointA

            for _, linePoint in pairs(_linePoints) do
                linePoint.Thickness = self.Thickness
                linePoint.Color = self.Color
                linePoint.Transparency = convertTransparency(self.Transparency)
                linePoint.ZIndex = self.ZIndex
                linePoint.Visible = self.Visible
            end
        end

        return quadObj
    elseif drawingType == "Triangle" then
        local triangleObj = createDrawingObject({
            PointA = Vector2.zero,
            PointB = Vector2.zero,
            PointC = Vector2.zero,
            Thickness = 1,
            Filled = false,
            Visible = true,
            ZIndex = 0,
            Transparency = 1,
            Color = Color3.new()
        })

        local _linePoints = {
            A = DrawingLib.new("Line"),
            B = DrawingLib.new("Line"),
            C = DrawingLib.new("Line")
        }

        function triangleObj:Update()
            _linePoints.A.From = self.PointA
            _linePoints.A.To = self.PointB
            _linePoints.B.From = self.PointB
            _linePoints.B.To = self.PointC
            _linePoints.C.From = self.PointC
            _linePoints.C.To = self.PointA

            for _, linePoint in pairs(_linePoints) do
                linePoint.Thickness = self.Thickness
                linePoint.Color = self.Color
                linePoint.Transparency = convertTransparency(self.Transparency)
                linePoint.ZIndex = self.ZIndex
                linePoint.Visible = self.Visible
            end
        end

        return triangleObj
    elseif drawingType == "TextButton" then
        local buttonObj = ({
            Text = "Button",
            Font = DrawingLib.Fonts.UI,
            Size = 20,
            Position = UDim2.new(0, 0, 0, 0),
            Color = Color3.new(1, 1, 1),
            BackgroundColor = Color3.new(0.2, 0.2, 0.2),
            Transparency = 0,
            Visible = true,
            ZIndex = 1,
            MouseButton1Click = nil 
        } + baseDrawingObj)

        local button = Instance.new("TextButton")
        button.Name = drawingIndex
        button.Text = buttonObj.Text
        button.FontFace = getFontFromIndex(buttonObj.Font)
        button.TextSize = buttonObj.Size
        button.Position = buttonObj.Position
        button.TextColor3 = buttonObj.Color
        button.BackgroundColor3 = buttonObj.BackgroundColor
        button.BackgroundTransparency = convertTransparency(buttonObj.Transparency)
        button.Visible = buttonObj.Visible
        button.ZIndex = buttonObj.ZIndex

        button.Parent = drawingUI

        local buttonEvents = {}

        return setmetatable({
            Parent = drawingUI,
            Connect = function(_, eventName, callback)
                if eventName == "MouseButton1Click" then
                    if buttonEvents["MouseButton1Click"] then
                        buttonEvents["MouseButton1Click"]:Disconnect()
                    end
                    buttonEvents["MouseButton1Click"] = button.MouseButton1Click:Connect(callback)
                else
                    warn("Invalid event: " .. tostring(eventName))
                end
            end
        }, {
            __newindex = function(_, index, value)
                if buttonObj[index] == nil then
                    warn("Invalid property: " .. tostring(index))
                    return
                end

                if index == "Text" then
                    button.Text = value
                elseif index == "Font" then
                    button.FontFace = getFontFromIndex(math.clamp(value, 0, 3))
                elseif index == "Size" then
                    button.TextSize = value
                elseif index == "Position" then
                    button.Position = value
                elseif index == "Color" then
                    button.TextColor3 = value
                elseif index == "BackgroundColor" then
                    button.BackgroundColor3 = value
                elseif index == "Transparency" then
                    button.BackgroundTransparency = convertTransparency(value)
                elseif index == "Visible" then
                    button.Visible = value
                elseif index == "ZIndex" then
                    button.ZIndex = value
                elseif index == "Parent" then
                    button.Parent = value
                elseif index == "MouseButton1Click" then
                    if typeof(value) == "function" then
                        if buttonEvents["MouseButton1Click"] then
                            buttonEvents["MouseButton1Click"]:Disconnect()
                        end
                        buttonEvents["MouseButton1Click"] = button.MouseButton1Click:Connect(value)
                    else
                        warn("Invalid value for MouseButton1Click: expected function, got " .. typeof(value))
                    end
                end
                buttonObj[index] = value
            end,
            __index = function(self, index)
                if index == "Remove" or index == "Destroy" then
                    return function()
                        button:Destroy()
                        buttonObj:Remove()
                    end
                end
                return buttonObj[index]
            end,
            __tostring = function() return "Drawing" end
        })
    end
end

return DrawingLib
