local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/94rn/lua/refs/heads/main/library.lua"))()

-- Create the window
local Window = Library:Window({
    Logo = "124454910007637",  -- Your logo asset ID
    FadeTime = 0.3,
})

    local function createUIToggleButton()
        local button = Instance.new('ImageButton')
        button.AnchorPoint = Vector2.new(1, 0.5)
        button.Position = UDim2.new(1, 0, 0.5, 0)
        button.Size = UDim2.new(0.08, 0, 0.087, 0)
        button.SizeConstraint = Enum.SizeConstraint.RelativeYY
        button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        button.BackgroundTransparency = 1
        button.Image = getgenv().UILogo or "rbxassetid://0"
        button.ScaleType = Enum.ScaleType.Fit
        button.Parent = Library.Holder.Instance
        
        -- Add a frame behind it for glow effect (optional)
        local framee = Instance.new('Frame')
        framee.AnchorPoint = Vector2.new(0.5, 0.5)
        framee.Position = button.Position
        framee.Size = button.Size
        framee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        framee.BorderSizePixel = 0
        framee.ZIndex = button.ZIndex - 1
        framee.Parent = Library.Holder.Instance
        
        -- Add gradient to the frame
        local gradient = Instance.new('UIGradient', framee)
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(10/255, 22/255, 22/255)),
            ColorSequenceKeypoint.new(1, Color3.new(15/255, 68/255, 64/255))
        })
        gradient.Enabled = true
        gradient.Rotation = -120
        
        -- Add stroke to the button
        local stroke = Instance.new('UIStroke', button)
        stroke.LineJoinMode = 0
        stroke.Thickness = 4
        stroke.Enabled = true
        stroke.ApplyStrokeMode = 1
        stroke.Color = Color3.new(1, 1, 1)
        local gradient2 = Instance.new('UIGradient', stroke)
        gradient2.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.new(120/255, 90/255, 40/255)),
            ColorSequenceKeypoint.new(1, Color3.new(214/255, 159/255, 64/255))
        }
        
        -- Make the button draggable
        local dragging, dragInput, dragStart, startPos
        
        local function update(input)
            local delta = input.Position - dragStart
            local parentHeight = button.Parent.AbsoluteSize.Y
            local startOffsetY = startPos.Y.Scale * parentHeight + startPos.Y.Offset
            local newPosY = math.clamp(startOffsetY + delta.Y, 0, parentHeight - button.AbsoluteSize.Y)
            button.Position = UDim2.new(1, 0, 0, newPosY)
            framee.Position = button.Position
        end
        
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = button.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        
        button.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        game:GetService("RunService").RenderStepped:Connect(function()
            if dragging and dragInput then
                update(dragInput)
            end
        end)
    
        button.MouseButton1Click:Connect(function()
            if Window then
                Window:SetOpen(not Window.IsOpen)
            end
        end)
    end

    -- Create the button after a short delay
    task.delay(0.05, createUIToggleButton)

-- Create watermark and keybind list
local Watermark = Library:Watermark("Porn Hub")
local KeybindList = Library:KeybindList()

-- Create pages
local MainPage = Window:Page({Name = "Central", SubPages = true})
local StylePage = Window:Page({Name = "Style Editor", SubPages = true})
local SettingsPage = Library:CreateSettingsPage(Window, Watermark, KeybindList)

do
    local MainSubPage = MainPage:SubPage({Name = "Player", Columns = 2})
    local MainSubPage2 = MainPage:SubPage({Name = "Goalkeeper", Columns = 2})
    
    do
        local TISection = MainSubPage:Section({Name = "TouchInterest", Side = 1})
        

    end
    
    do
        local GKTISection = MainSubPage2:Section({Name = "Silent Aim", Side = 1})
        

    end
end
-- Notification when loaded
Library:Notification("Loaded!", "Your script loaded successfully!", 5)