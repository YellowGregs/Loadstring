local UiLib = Instance.new("ScreenGui")
UiLib.Name = "UiLib"
UiLib.Parent = game.CoreGui
UiLib.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function getNextWindowPos()
	local biggest = 0
	local ok = nil
	for i, v in pairs(UiLib:GetChildren()) do
		if v.Position.X.Offset > biggest then
			biggest = v.Position.X.Offset
			ok = v
		end
	end
	if biggest == 0 then
		biggest = biggest + 15
	else
		biggest = biggest + ok.Size.X.Offset + 10
	end

	return biggest
end

local Library = {}

function Library:Window(title)
	local Top = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local Container = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Line = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Minimize = Instance.new("ImageButton")

	Top.Name = "Top"
	Top.Parent = UiLib
	Top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Top.BorderSizePixel = 0
	Top.Position = UDim2.new(0, getNextWindowPos(), 0.01, 0)
	Top.Size = UDim2.new(0, 300, 0, 40)
	Top.Active = true
	Top.Draggable = true

	UICorner.CornerRadius = UDim.new(0, 4)
	UICorner.Parent = Top

	Container.Name = "Container"
	Container.Parent = Top
	Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Container.BackgroundTransparency = 1.000
	Container.ClipsDescendants = true
	Container.Position = UDim2.new(0, 0, 1, 0)
	Container.Size = UDim2.new(0, 300, 0, 800)

	UIListLayout_2.Parent = Container
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	Line.Name = "Line"
	Line.Parent = Top
	Line.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Line.BorderSizePixel = 0
	Line.Position = UDim2.new(0, 0, 0.892857134, 0)
	Line.Size = UDim2.new(0, 300, 0, 3)

	Title.Name = "Title"
	Title.Parent = Top
	Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.0245098043, 0, 0.142857149, 0)
	Title.Size = UDim2.new(0, 260, 0, 28)
	Title.Font = Enum.Font.GothamSemibold
	Title.Text = title
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.TextScaled = true
	Title.TextSize = 14.000
	Title.TextWrapped = true
	Title.TextXAlignment = Enum.TextXAlignment.Left

	Minimize.Name = "Minimize"
	Minimize.Parent = Top
	Minimize.BackgroundTransparency = 1.000
	Minimize.Position = UDim2.new(0.877451003, 0, 0, 0)
	Minimize.Rotation = 90.000
	Minimize.Size = UDim2.new(0, 25, 0, 25)
	Minimize.ZIndex = 2
	Minimize.Image = "rbxassetid://3926307971"
	Minimize.ImageColor3 = Color3.fromRGB(0, 255, 102)
	Minimize.ImageRectOffset = Vector2.new(764, 244)
	Minimize.ImageRectSize = Vector2.new(36, 36)

	local function UZVNGAL_fake_script()
		local script = Instance.new('Script', Minimize)

		script.Parent.MouseButton1Click:Connect(function()
			if script.Parent.Parent.Container.Size == UDim2.new(0, 300, 0, 800) then 
				game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 180}):Play()
				game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(255, 0, 68)}):Play()
				script.Parent.Parent.Container:TweenSize(UDim2.new(0, 300, 0, 0), "InOut", "Sine", 0.25, true)
				wait(0.25)
				script.Parent.Parent.Line.Visible = false
			else
				game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 90}):Play()
				game:GetService("TweenService"):Create(script.Parent, TweenInfo.new(0.25), {ImageColor3 = Color3.fromRGB(0, 255, 102)}):Play()
				script.Parent.Parent.Container:TweenSize(UDim2.new(0, 300, 0, 800), "InOut", "Sine", 0.2, true)
				script.Parent.Parent.Line.Visible = true
			end
		end)
	end
	coroutine.wrap(UZVNGAL_fake_script)()
	
	local Lib = {}
	
	function Lib:Button(name, callback)
		local ButtonContainer = Instance.new("Frame")
		local Button = Instance.new("TextButton")
		local ButtonAni = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local ButtonName = Instance.new("TextLabel")
		
		ButtonContainer.Name = "ButtonContainer"
		ButtonContainer.Parent = Container
		ButtonContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ButtonContainer.BorderSizePixel = 0
		ButtonContainer.Size = UDim2.new(0, 300, 0, 40)
		
		Button.Name = "Button"
		Button.Parent = ButtonContainer
		Button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Button.BackgroundTransparency = 1.000
		Button.Size = UDim2.new(0, 300, 0, 40)
		Button.Font = Enum.Font.SourceSans
		Button.Text = ""
		Button.TextColor3 = Color3.fromRGB(0, 0, 0)
		Button.TextSize = 14.000
		Button.MouseButton1Click:Connect(function()
			callback()
		end)
		
		ButtonAni.Name = "ButtonAni"
		ButtonAni.Parent = Button
		ButtonAni.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
		ButtonAni.Position = UDim2.new(0.0245098043, 0, 0.0714285746, 0)
		
		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ButtonAni
		
		UIListLayout.Parent = Button
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		
		ButtonName.Name = "ButtonName"
		ButtonName.Parent = ButtonContainer
		ButtonName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ButtonName.BackgroundTransparency = 1.000
		ButtonName.Position = UDim2.new(0.0245098043, 0, 0.142857149, 0)
		ButtonName.Size = UDim2.new(0, 280, 0, 28)
		ButtonName.ZIndex = 3
		ButtonName.Font = Enum.Font.GothamSemibold
		ButtonName.Text = name
		ButtonName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ButtonName.TextScaled = true
		ButtonName.TextSize = 14.000
		ButtonName.TextWrapped = true
		
		local function ZNVYM_fake_script()
			local script = Instance.new('Script', Button)
			
			script.Parent.MouseButton1Click:Connect(function()
				script.Parent.ButtonAni:TweenSize(UDim2.new(0, 280,0, 36), 'InOut', "Sine", 0.3, true)
				wait(0.45)
				script.Parent.ButtonAni:TweenSize(UDim2.new(0, 0, 0, 0), "InOut", "Sine", 0.3, true)
			end)
		end
		coroutine.wrap(ZNVYM_fake_script)()
	end
	
	function Lib:Toggle(name, callback)
		local ToggleContainer = Instance.new("Frame")
		local ToggleName = Instance.new("TextLabel")
		local Toggle = Instance.new("TextButton")
		local UICorner_3 = Instance.new("UICorner")
		local Off = Instance.new("ImageLabel")
		local On = Instance.new("ImageLabel")
		
		ToggleContainer.Name = "ToggleContainer"
		ToggleContainer.Parent = Container
		ToggleContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ToggleContainer.BorderSizePixel = 0
		ToggleContainer.Size = UDim2.new(0, 300, 0, 40)
		
		ToggleName.Name = "ToggleName"
		ToggleName.Parent = ToggleContainer
		ToggleName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ToggleName.BackgroundTransparency = 1.000
		ToggleName.Position = UDim2.new(0.0245098043, 0, 0.142857105, 0)
		ToggleName.Size = UDim2.new(0, 250, 0, 28)
		ToggleName.Font = Enum.Font.GothamSemibold
		ToggleName.Text = name
		ToggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ToggleName.TextScaled = true
		ToggleName.TextSize = 14.000
		ToggleName.TextWrapped = true
		ToggleName.TextXAlignment = Enum.TextXAlignment.Left
		
		Toggle.Name = "Toggle"
		Toggle.Parent = ToggleContainer
		Toggle.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		Toggle.BorderColor3 = Color3.fromRGB(27, 42, 53)
		Toggle.Position = UDim2.new(0.852941215, 0, 0.0666666627, 0)
		Toggle.Size = UDim2.new(0, 30, 0, 28)
		Toggle.AutoButtonColor = false
		Toggle.Font = Enum.Font.SourceSans
		Toggle.Text = ""
		Toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.TextSize = 14.000
		local Toggled = false
		Toggle.MouseButton1Click:Connect(function()
			if Toggled == false then
				Toggled = true
			else
				Toggled = false
			end
			callback(Toggled)
		end)
		
		UICorner_3.CornerRadius = UDim.new(0, 3)
		UICorner_3.Parent = Toggle
		
		Off.Name = "Off"
		Off.Parent = Toggle
		Off.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Off.BackgroundTransparency = 1.000
		Off.Size = UDim2.new(0, 30, 0, 30)
		Off.Image = "rbxassetid://3926305904"
		Off.ImageColor3 = Color3.fromRGB(255, 0, 68)
		Off.ImageRectOffset = Vector2.new(924, 724)
		Off.ImageRectSize = Vector2.new(36, 36)
		
		On.Name = "On"
		On.Parent = Toggle
		On.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		On.BackgroundTransparency = 1.000
		On.Size = UDim2.new(0, 30, 0, 30)
		On.Visible = false
		On.Image = "rbxassetid://3926305904"
		On.ImageColor3 = Color3.fromRGB(0, 255, 102)
		On.ImageRectOffset = Vector2.new(312, 4)
		On.ImageRectSize = Vector2.new(24, 24)
		
		local function XLZZDX_fake_script()
			local script = Instance.new('Script', Toggle)
			
			script.Parent.MouseButton1Click:Connect(function()
				if script.Parent.Off.Rotation == 0 then
					script.Parent.On.Rotation = 0
					game:GetService("TweenService"):Create(script.Parent.Off, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 360}):Play()
					wait(0.3)
					script.Parent.Off.Visible = false
					script.Parent.On.Visible = true
				else
					script.Parent.Off.Rotation = 0
					game:GetService("TweenService"):Create(script.Parent.On, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = -360}):Play()
					wait(0.3)
					script.Parent.On.Visible = false
					script.Parent.Off.Visible = true
				end
			end)
		end
		coroutine.wrap(XLZZDX_fake_script)()
	end
	
	function Lib:Dropdown(name, options, callback)
		local DropdownContainer = Instance.new("Frame")
		local Dropdown = Instance.new("TextButton")
		local DropdownName = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")
		local DropdownList = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		
		DropdownContainer.Name = "DropdownContainer"
		DropdownContainer.Parent = Container
		DropdownContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		DropdownContainer.BorderSizePixel = 0
		DropdownContainer.Size = UDim2.new(0, 300, 0, 40)
		
		Dropdown.Name = "Dropdown"
		Dropdown.Parent = DropdownContainer
		Dropdown.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		Dropdown.BorderSizePixel = 0
		Dropdown.Position = UDim2.new(0, 0, 0.142857149, 0)
		Dropdown.Size = UDim2.new(0, 300, 0, 40)
		Dropdown.Font = Enum.Font.SourceSans
		Dropdown.Text = ""
		Dropdown.TextColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.TextSize = 14.000
		Dropdown.AutoButtonColor = false
		
		DropdownName.Name = "DropdownName"
		DropdownName.Parent = DropdownContainer
		DropdownName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownName.BackgroundTransparency = 1.000
		DropdownName.Position = UDim2.new(0.0245098043, 0, 0.142857149, 0)
		DropdownName.Size = UDim2.new(0, 250, 0, 28)
		DropdownName.Font = Enum.Font.GothamSemibold
		DropdownName.Text = name
		DropdownName.TextColor3 = Color3.fromRGB(255, 255, 255)
		DropdownName.TextScaled = true
		DropdownName.TextSize = 14.000
		DropdownName.TextWrapped = true
		DropdownName.TextXAlignment = Enum.TextXAlignment.Left
		
		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Dropdown
		
		DropdownList.Name = "DropdownList"
		DropdownList.Parent = DropdownContainer
		DropdownList.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		DropdownList.BorderSizePixel = 0
		DropdownList.Position = UDim2.new(0, 0, 1.5, 0)
		DropdownList.Size = UDim2.new(0, 300, 0, 0)
		DropdownList.ClipsDescendants = true
		
		UIListLayout.Parent = DropdownList
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		
		Dropdown.MouseButton1Click:Connect(function()
			if DropdownList.Size == UDim2.new(0, 300, 0, 0) then
				DropdownList:TweenSize(UDim2.new(0, 300, 0, #options * 40), "Out", "Quad", 0.3, true)
			else
				DropdownList:TweenSize(UDim2.new(0, 300, 0, 0), "Out", "Quad", 0.3, true)
			end
		end)
		
		for i,v in pairs(options) do
			local Option = Instance.new("TextButton")
			Option.Parent = DropdownList
			Option.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
			Option.BorderSizePixel = 0
			Option.Size = UDim2.new(0, 300, 0, 40)
			Option.Font = Enum.Font.GothamSemibold
			Option.Text = v
			Option.TextColor3 = Color3.fromRGB(255, 255, 255)
			Option.TextSize = 14.000
			Option.TextWrapped = true
			Option.MouseButton1Click:Connect(function()
				DropdownName.Text = v
				callback(v)
				DropdownList:TweenSize(UDim2.new(0, 300, 0, 0), "Out", "Quad", 0.3, true)
			end)
		end
	end
	
	function Lib:Slider(name, min, max, callback)
		local SliderContainer = Instance.new("Frame")
		local SliderName = Instance.new("TextLabel")
		local Slider = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local Bar = Instance.new("Frame")
		local Fill = Instance.new("Frame")
		local Value = Instance.new("TextLabel")
		
		SliderContainer.Name = "SliderContainer"
		SliderContainer.Parent = Container
		SliderContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		SliderContainer.BorderSizePixel = 0
		SliderContainer.Size = UDim2.new(0, 300, 0, 60)
		
		SliderName.Name = "SliderName"
		SliderName.Parent = SliderContainer
		SliderName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SliderName.BackgroundTransparency = 1.000
		SliderName.Position = UDim2.new(0.0245098043, 0, 0.142857105, 0)
		SliderName.Size = UDim2.new(0, 250, 0, 28)
		SliderName.Font = Enum.Font.GothamSemibold
		SliderName.Text = name
		SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
		SliderName.TextScaled = true
		SliderName.TextSize = 14.000
		SliderName.TextWrapped = true
		SliderName.TextXAlignment = Enum.TextXAlignment.Left
		
		Slider.Name = "Slider"
		Slider.Parent = SliderContainer
		Slider.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		Slider.BorderSizePixel = 0
		Slider.Position = UDim2.new(0.0245098043, 0, 0.642857149, 0)
		Slider.Size = UDim2.new(0, 250, 0, 10)
		Slider.AutoButtonColor = false
		Slider.Font = Enum.Font.SourceSans
		Slider.Text = ""
		Slider.TextColor3 = Color3.fromRGB(0, 0, 0)
		Slider.TextSize = 14.000
		
		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = Slider
		
		Bar.Name = "Bar"
		Bar.Parent = Slider
		Bar.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
		Bar.BorderSizePixel = 0
		Bar.Position = UDim2.new(0, 0, 0.5, -5)
		Bar.Size = UDim2.new(1, 0, 0, 10)
		
		Fill.Name = "Fill"
		Fill.Parent = Bar
		Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 102)
		Fill.BorderSizePixel = 0
		Fill.Size = UDim2.new(0, 0, 1, 0)
		
		Value.Name = "Value"
		Value.Parent = SliderContainer
		Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value.BackgroundTransparency = 1.000
		Value.Position = UDim2.new(0.924509823, 0, 0.142857105, 0)
		Value.Size = UDim2.new(0, 50, 0, 28)
		Value.Font = Enum.Font.GothamSemibold
		Value.Text = tostring(min)
		Value.TextColor3 = Color3.fromRGB(255, 255, 255)
		Value.TextScaled = true
		Value.TextSize = 14.000
		Value.TextWrapped = true
		Value.TextXAlignment = Enum.TextXAlignment.Left
		
		local dragging = false
		Slider.MouseButton1Down:Connect(function()
			dragging = true
		end)
		
		game:GetService("UserInputService").InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end)
		
		game:GetService("RunService").RenderStepped:Connect(function()
			if dragging then
				local mouse = game:GetService("Players").LocalPlayer:GetMouse()
				local percent = math.clamp((mouse.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
				local value = math.floor(min + ((max - min) * percent))
				Fill.Size = UDim2.new(percent, 0, 1, 0)
				Value.Text = tostring(value)
				callback(value)
			end
		end)
	end
	
	function Lib:ColorPicker(name, defaultColor, callback)
		local ColorPickerContainer = Instance.new("Frame")
		local ColorPickerName = Instance.new("TextLabel")
		local ColorDisplay = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")
		local PickerFrame = Instance.new("Frame")
		local PickerUICorner = Instance.new("UICorner")
		local ColorWheel = Instance.new("ImageButton")
		local WheelImage = "rbxassetid://698052001"

		ColorPickerContainer.Name = "ColorPickerContainer"
		ColorPickerContainer.Parent = Container
		ColorPickerContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		ColorPickerContainer.BorderSizePixel = 0
		ColorPickerContainer.Size = UDim2.new(0, 300, 0, 40)

		ColorPickerName.Name = "ColorPickerName"
		ColorPickerName.Parent = ColorPickerContainer
		ColorPickerName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorPickerName.BackgroundTransparency = 1.000
		ColorPickerName.Position = UDim2.new(0.0245098043, 0, 0.142857105, 0)
		ColorPickerName.Size = UDim2.new(0, 250, 0, 28)
		ColorPickerName.Font = Enum.Font.GothamSemibold
		ColorPickerName.Text = name
		ColorPickerName.TextColor3 = Color3.fromRGB(255, 255, 255)
		ColorPickerName.TextScaled = true
		ColorPickerName.TextSize = 14.000
		ColorPickerName.TextWrapped = true
		ColorPickerName.TextXAlignment = Enum.TextXAlignment.Left

		ColorDisplay.Name = "ColorDisplay"
		ColorDisplay.Parent = ColorPickerContainer
		ColorDisplay.BackgroundColor3 = defaultColor
		ColorDisplay.BorderSizePixel = 0
		ColorDisplay.Position = UDim2.new(0.852941215, 0, 0.0666666627, 0)
		ColorDisplay.Size = UDim2.new(0, 30, 0, 28)

		UICorner.CornerRadius = UDim.new(0, 3)
		UICorner.Parent = ColorDisplay

		PickerFrame.Name = "PickerFrame"
		PickerFrame.Parent = ColorPickerContainer
		PickerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		PickerFrame.Position = UDim2.new(0, 0, 1, 0)
		PickerFrame.Size = UDim2.new(0, 300, 0, 300)
		PickerFrame.Visible = false

		PickerUICorner.CornerRadius = UDim.new(0, 5)
		PickerUICorner.Parent = PickerFrame

		ColorWheel.Name = "ColorWheel"
		ColorWheel.Parent = PickerFrame
		ColorWheel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ColorWheel.BackgroundTransparency = 1.000
		ColorWheel.Position = UDim2.new(0.05, 0, 0.05, 0)
		ColorWheel.Size = UDim2.new(0.9, 0, 0.9, 0)
		ColorWheel.Image = WheelImage

		local function openColorPicker()
			PickerFrame.Visible = not PickerFrame.Visible
		end

		ColorDisplay.MouseButton1Click:Connect(openColorPicker)

		ColorWheel.MouseButton1Click:Connect(function()
			local mouse = game.Players.LocalPlayer:GetMouse()
			local color = Color3.fromHSV((mouse.X - ColorWheel.AbsolutePosition.X) / ColorWheel.AbsoluteSize.X, (mouse.Y - ColorWheel.AbsolutePosition.Y) / ColorWheel.AbsoluteSize.Y, 1)
			ColorDisplay.BackgroundColor3 = color
			callback(color)
		end)
	end
	
	return Lib
end

return Library
