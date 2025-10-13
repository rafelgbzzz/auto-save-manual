-- Source.lua - Nexus UI Library sederhana versi contoh

local NexusUI = {}
NexusUI.__index = NexusUI

-- Utilities untuk membuat objek GUI
local function createInstance(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:New(props)
    local self = setmetatable({}, Window)
    -- Create main ScreenGui
    self.ScreenGui = createInstance("ScreenGui", {ResetOnSpawn = false})
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    -- Create Main Frame
    self.Frame = createInstance("Frame", {
        Size = props.Size or UDim2.new(0, 600, 0, 400),
        Position = props.Position or UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = self.ScreenGui,
    })

    -- UIListLayout untuk panel anak
    self.Layout = createInstance("UIListLayout", {Parent = self.Frame, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})

    -- Simpan tab list
    self.Tabs = {}

    return self
end

function Window:AddTab(name)
    local tab = {}
    tab.Name = name
    tab.Parent = self.Frame

    tab.Frame = createInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = #self.Tabs + 1,
        Parent = self.Frame,
    })

    tab.Label = createInstance("TextLabel", {
        Text = name,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = tab.Frame,
    })

    -- Container untuk elemen dalam tab
    tab.Content = createInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 200),
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = self.Frame,
    })

    tab.ContentLayout = createInstance("UIListLayout", {Parent = tab.Content, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder})

    function tab:AddLabel(text)
        local label = createInstance("TextLabel", {
            Text = text,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            TextSize = 18,
            Size = UDim2.new(1, 0, 0, 24),
            Parent = tab.Content,
        })
        return label
    end

    function tab:AddButton(text, callback)
        local button = createInstance("TextButton", {
            Text = text,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundColor3 = Color3.fromRGB(70, 70, 70),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18,
            Size = UDim2.new(1, 0, 0, 30),
            Parent = tab.Content,
        })
        button.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
        return button
    end

    function tab:AddToggle(text, initial, callback)
        local frame = createInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            Parent = tab.Content,
        })

        local label = createInstance("TextLabel", {
            Text = text,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            TextSize = 18,
            Size = UDim2.new(0.75, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame,
        })

        local toggle = createInstance("TextButton", {
            Text = initial and "ON" or "OFF",
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundColor3 = initial and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0),
            Font = Enum.Font.SourceSansBold,
            TextSize = 18,
            Size = UDim2.new(0.25, 0, 1, 0),
            Position = UDim2.new(0.75, 0, 0, 0),
            Parent = frame,
        })

        local value = initial

        toggle.MouseButton1Click:Connect(function()
            value = not value
            toggle.Text = value and "ON" or "OFF"
            toggle.BackgroundColor3 = value and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(150, 0, 0)
            if callback then callback(value) end
        end)

        return frame
    end

    function tab:AddSlider(text, initial, min, max, step, callback)
        local frame = createInstance("Frame", {Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = tab.Content})

        local label = createInstance("TextLabel", {
            Text = string.format("%s: %d", text, initial),
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 1,
            Font = Enum.Font.SourceSans,
            TextSize = 18,
            Size = UDim2.new(1, 0, 0, 24),
            Parent = frame,
        })

        local slider = createInstance("TextButton", {
            Text = "",
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 30),
            Parent = frame,
            AutoButtonColor = false,
        })

        local fill = createInstance("Frame", {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255),
            Size = UDim2.new((initial - min) / (max - min), 0, 1, 0),
            Parent = slider,
        })

        local dragging = false

        local function updateSlider(inputPosX)
            local relativeX = math.clamp(inputPosX - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            local percent = relativeX / slider.AbsoluteSize.X
            local value = math.floor(min + percent * (max - min) + 0.5 / step) * step
            label.Text = string.format("%s: %d", text, value)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            if callback then callback(value) end
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input.Position.X)
            end
        end)

        slider.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input.Position.X)
            end
        end)

        slider.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        return frame
    end

    function tab:AddTextbox(props)
        local box = createInstance("TextBox", {
            ClearTextOnFocus = props.ClearTextOnFocus or false,
            PlaceholderText = props.PlaceholderText or "",
            Text = "",
            TextColor3 = Color3.new(1,1,1),
            BackgroundColor3 = Color3.fromRGB(50,50,50),
            Font = Enum.Font.SourceSans,
            TextSize = 18,
            Size = UDim2.new(1, 0, 0, 30),
            Parent = tab.Content,
        })
        if props.FocusLost then
            box.FocusLost:Connect(props.FocusLost)
        end
        return box
    end

    table.insert(self.Tabs, tab)
    return tab
end

function NexusUI:CreateWindow(props)
    local window = Window:New(props)
    return window
end

return NexusUI
