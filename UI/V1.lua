-- test
local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new(parent)
    local self = setmetatable({}, UILibrary)
    self.parent = parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    self.gui = Instance.new("ScreenGui", self.parent)
    return self
end

-- Button 
function UILibrary:Button(text, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 50)
    button.Text = text
    button.MouseButton1Click:Connect(onClick)
    button.Parent = self.gui
    return button
end

-- Toggle 
function UILibrary:Toggle(text, initialState, onToggle)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 100, 0, 50)
    toggle.Text = initialState and text .. " ON" or text .. " OFF"
    toggle.MouseButton1Click:Connect(function()
        initialState = not initialState
        toggle.Text = initialState and text .. " ON" or text .. " OFF"
        if onToggle then
            onToggle(initialState)
        end
    end)
    toggle.Parent = self.gui
    return toggle
end

-- ColorPicker 
function UILibrary:ColorPicker(text, initialColor, onColorChange)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 100, 0, 100)
    frame.BackgroundColor3 = initialColor
    frame.Parent = self.gui

    local picker = Instance.new("TextButton")
    picker.Size = UDim2.new(1, 0, 0.1, 0)
    picker.Position = UDim2.new(0, 0, 0.9, 0)
    picker.Text = text
    picker.Parent = frame

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
