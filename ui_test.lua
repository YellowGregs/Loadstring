local UILibrary = {}

UILibrary.__index = UILibrary

local function createInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

function UILibrary.new(title)
    local self = setmetatable({}, UILibrary)

    self.screenGui = createInstance("ScreenGui", {Name = title, ResetOnSpawn = false})
    self.mainFrame = createInstance("Frame", {
        Parent = self.screenGui,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(0.5, -200, 0.5, -150)
    })
    
    self.mainFrame.ClipsDescendants = true
    
    self.titleLabel = createInstance("TextLabel", {
        Parent = self.mainFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24
    })
    
    self.uiElements = {}
    self.sections = {}
    
    self.screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    return self
end

function UILibrary:createSection(title)
    local section = createInstance("Frame", {
        Parent = self.mainFrame,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(1, 0, 0, 200),
        Position = UDim2.new(0, 0, 0, 30 + (#self.sections * 210))
    })

    local sectionTitle = createInstance("TextLabel", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20
    })
    
    table.insert(self.sections, section)
    return section
end

function UILibrary:createButton(section, title, callback)
    local button = createInstance("TextButton", {
        Parent = section,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })

    button.MouseButton1Click:Connect(callback)
    return button
end

function UILibrary:createToggle(section, title, default, callback)
    local frame = createInstance("Frame", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40)
    })
    
    local label = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local toggleButton = createInstance("TextButton", {
        Parent = frame,
        BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Text = default and "On" or "Off",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })

    toggleButton.MouseButton1Click:Connect(function()
        default = not default
        toggleButton.Text = default and "On" or "Off"
        toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(default)
    end)

    return frame
end

function UILibrary:createSlider(section, title, min, max, default, callback)
    local frame = createInstance("Frame", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40)
    })

    local label = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.4, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local slider = createInstance("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        Size = UDim2.new(0.6, -30, 0.6, 0),
        Position = UDim2.new(0.4, 15, 0.2, 0),
        Text = "",
    })

    local fill = createInstance("Frame", {
        Parent = slider,
        BackgroundColor3 = Color3.fromRGB(0, 200, 200),
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    })

    local valueLabel = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.2, 0, 1, 0),
        Position = UDim2.new(0.8, 0, 0, 0),
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseMove, mouseUp
            mouseMove = game:GetService("UserInputService").InputChanged:Connect(function(move)
                if move.UserInputType == Enum.UserInputType.MouseMovement then
                    local newSize = math.clamp((move.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(newSize, 0, 1, 0)
                    local newValue = math.floor(min + (newSize * (max - min)))
                    valueLabel.Text = tostring(newValue)
                    callback(newValue)
                end
            end)
            mouseUp = game:GetService("UserInputService").InputEnded:Connect(function(up)
                if up.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouseMove:Disconnect()
                    mouseUp:Disconnect()
                end
            end)
        end
    end)

    return frame
end

function UILibrary:createDropdown(section, title, options, callback)
    local frame = createInstance("Frame", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40)
    })

    local label = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local dropdown = createInstance("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Text = "Select",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })

    local dropFrame = createInstance("Frame", {
        Parent = dropdown,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(1, 0, 0, #options * 30),
        Position = UDim2.new(0, 0, 1, 0),
        Visible = false
    })
    
    local layout = createInstance("UIListLayout", {Parent = dropFrame})

    for i, option in ipairs(options) do
        local optionButton = createInstance("TextButton", {
            Parent = dropFrame,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Size = UDim2.new(1, 0, 0, 30),
            Text = option,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18
        })
        
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Text = option
            dropFrame.Visible = false
            callback(option)
        end)
    end

    dropdown.MouseButton1Click:Connect(function()
        dropFrame.Visible = not dropFrame.Visible
    end)

    return frame
end

function UILibrary:createColorPicker(section, title, default, callback)
    -- Simplified color picker for brevity
    local frame = createInstance("Frame", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40)
    })

    local label = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local colorButton = createInstance("TextButton", {
        Parent = frame,
        BackgroundColor3 = default,
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Text = "",
    })

    colorButton.MouseButton1Click:Connect(function()
        -- Simple color picker behavior (using color palette not implemented here)
        local newColor = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        colorButton.BackgroundColor3 = newColor
        callback(newColor)
    end)

    return frame
end

function UILibrary:createKeybind(section, title, defaultKey, callback)
    local frame = createInstance("Frame", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40)
    })

    local label = createInstance("TextLabel", {
        Parent = frame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local keybindButton = createInstance("TextButton", {
        Parent = frame,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        Text = defaultKey,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18
    })

    keybindButton.MouseButton1Click:Connect(function()
        keybindButton.Text = "..."
        local inputBeganConn
        inputBeganConn = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybindButton.Text = input.KeyCode.Name
                callback(input.KeyCode)
                inputBeganConn:Disconnect()
            end
        end)
    end)

    return frame
end

function UILibrary:createLabel(section, text)
    local label = createInstance("TextLabel", {
        Parent = section,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40 + (#section:GetChildren() - 1) * 40),
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    return label
end

return UILibrary
