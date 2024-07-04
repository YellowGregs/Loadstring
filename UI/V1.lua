local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new()
    local self = setmetatable({}, UILibrary)
    self.gui = Instance.new("ScreenGui")
    self.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0, 300, 0, 400)
    self.mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.mainFrame.BorderSizePixel = 0
    self.mainFrame.Parent = self.gui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = self.mainFrame

    return self
end

--Button
function UILibrary:Button(text, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 260, 0, 50)
    button.Position = UDim2.new(0.5, -130, 0, 20)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.Parent = self.mainFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = button

    button.MouseButton1Click:Connect(onClick)

    return button
end

-- Toggle
function UILibrary:Toggle(text, initialState, onToggle)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 260, 0, 50)
    toggle.Position = UDim2.new(0.5, -130, 0, 90)
    toggle.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Text = text .. (initialState and " ON" or " OFF")
    toggle.Parent = self.mainFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = toggle

    toggle.MouseButton1Click:Connect(function()
        initialState = not initialState
        toggle.Text = text .. (initialState and " ON" or " OFF")
        toggle.BackgroundColor3 = initialState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        if onToggle then
            onToggle(initialState)
        end
    end)

    return toggle
end

--  ColorPicker
function UILibrary:ColorPicker(text, initialColor, onColorChange)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 100)
    frame.Position = UDim2.new(0.5, -130, 0, 160)
    frame.BackgroundColor3 = initialColor
    frame.Parent = self.mainFrame

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local picker = Instance.new("TextButton")
    picker.Size = UDim2.new(1, 0, 0.2, 0)
    picker.Position = UDim2.new(0, 0, 0.8, 0)
    picker.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    picker.TextColor3 = Color3.fromRGB(255, 255, 255)
    picker.Text = text
    picker.Parent = frame

    local pickerUiCorner = Instance.new("UICorner")
    pickerUiCorner.CornerRadius = UDim.new(0, 10)
    pickerUiCorner.Parent = picker

    picker.MouseButton1Click:Connect(function()
        local newColor = Color3.new(math.random(), math.random(), math.random())
        frame.BackgroundColor3 = newColor
        if onColorChange then
            onColorChange(newColor)
        end
    end)

    return frame
end

return UILibrary
