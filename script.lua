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
    
    local framee = Instance.new('Frame')
    framee.AnchorPoint = Vector2.new(0.5, 0.5)
    framee.Position = button.Position
    framee.Size = button.Size
    framee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    framee.BorderSizePixel = 0
    framee.ZIndex = button.ZIndex - 1
    framee.Parent = Library.Holder.Instance
    
    local gradient = Instance.new('UIGradient', framee)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(10/255, 22/255, 22/255)),
        ColorSequenceKeypoint.new(1, Color3.new(15/255, 68/255, 64/255))
    })
    gradient.Enabled = true
    gradient.Rotation = -120
    
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

task.delay(0.05, createUIToggleButton)

-- Create watermark and keybind list
local Watermark = Library:Watermark("Porn Hub")
local KeybindList = Library:KeybindList()

getgenv().Settings = {
    TouchInterest = {
        HBE = false,
        Distance = 0
    },
    GK = {
        DiveHBE = false,
        DiveDistance = 0,
        BoxHBE = false,
        BoxHitbox = 2.5,
        BoxTransparency = 1,
        TransparencyToggle = false
    },
    Box = {
        HBE = false,
        Hitbox = 2.5,
        Transparency = 1,
        TransparencyToggle = false
    },
    Misc = {
        InfStam = false,
        NoCd = false,
        CrossbarPhase = false,
        OpM1 = false,
        M1Power = 110,
        M1INDI = Vector3.new(0,0,0),
        M1ChangeAt = 80,
        NoEndlag = false
    },
    SZLoki = {
        GodspeedHbe = false,
        GodspeedGround = false,
        GodspeedDistance = 20,
        GodspeedHeight = 100,
        GodspeedThing = 9,
        ShotPower = 140
    }
}

getgenv().FootballList = {}
getgenv().DiveList = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hitbox
local noCdEnabled = false

local AbilityController = require(ReplicatedStorage.Controllers.AbilityController)
local AB = require(ReplicatedStorage.AbilityBalancing)
local FlowBalancing = require(ReplicatedStorage.FlowBalancing)
local Knit = require(ReplicatedStorage.Packages.Knit)
local BallController = Knit.GetController("BallController")
local AbilityService = Knit.GetService("AbilityService")
local AbilityUtils = require(ReplicatedStorage.Shared.AbilityUtils)
local AnimationController = require(ReplicatedStorage.Controllers.AnimationController)
local StatesController = require(ReplicatedStorage.Controllers.StatesController)

local originalAbilityCooldown = AbilityController.legacy.AbilityCooldown
local originalExecuteAbilitySlot = AbilityController.ExecuteAbilitySlot

local playerGui = player:WaitForChild("PlayerGui")

local function getGodspeedRange()
    return AB.GodspeedFreeze.Range or 50
end

local function isGodspeedFreeze()
    local abilityLabel = playerGui:FindFirstChild("InGameUI") and playerGui.InGameUI:FindFirstChild("Bottom") and playerGui.InGameUI.Bottom:FindFirstChild("Abilities") and playerGui.InGameUI.Bottom.Abilities:FindFirstChild("2") and playerGui.InGameUI.Bottom.Abilities["2"]:FindFirstChild("AbilityLabel")
    
    if abilityLabel then
        return abilityLabel.Text == "GodSpeed Freeze" or abilityLabel.Text:find("Freeze") ~= nil
    end
    
    return false
end

local function setupCharacter(character)
    hitbox = character:WaitForChild("Hitbox")
    
    character.ChildAdded:Connect(function(child)
        if child.Name == "DiveHitbox" and child:IsA("BasePart") then
            for _, existingDive in ipairs(getgenv().DiveList) do
                if existingDive == child then
                    return
                end
            end
            table.insert(getgenv().DiveList, child)
        end
    end)
    
    character.ChildRemoved:Connect(function(child)
        if child.Name == "DiveHitbox" then
            for i, existingDive in ipairs(getgenv().DiveList) do
                if existingDive == child then
                    table.remove(getgenv().DiveList, i)
                    return
                end
            end
        end
    end)
    
    for _, child in ipairs(character:GetChildren()) do
        if child.Name == "DiveHitbox" and child:IsA("BasePart") then
            table.insert(getgenv().DiveList, child)
        end
    end
end

if player.Character then
    setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

local function addFootball(football)
    if football:FindFirstChild("Hitbox") then
        for _, existingFootball in ipairs(getgenv().FootballList) do
            if existingFootball == football then
                return
            end
        end
        table.insert(getgenv().FootballList, football)
    end
end

local function removeFootball(football)
    for i, existingFootball in ipairs(getgenv().FootballList) do
        if existingFootball == football then
            table.remove(getgenv().FootballList, i)
            return
        end
    end
end

for _, descendant in ipairs(workspace:GetDescendants()) do
    if descendant.Name == "Football" then
        addFootball(descendant)
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Name == "Football" then
        addFootball(descendant)
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if descendant.Name == "Football" then
        removeFootball(descendant)
    end
end)

-- Create pages
local MainPage = Window:Page({Name = "Central", SubPages = true})
local StylePage = Window:Page({Name = "Style Editor", SubPages = true})
local SettingsPage = Library:CreateSettingsPage(Window, Watermark, KeybindList)

do -- Central Page
    local PlayerSubPage = MainPage:SubPage({Name = "Player", Columns = 2})
    local GKSubPage = MainPage:SubPage({Name = "Goalkeeper", Columns = 2})
    local MiscSubPage = MainPage:SubPage({Name = "Misc", Columns = 2})
    
    do -- Player SubPage
        local TISection = PlayerSubPage:Section({Name = "TouchInterest HBE", Side = 1})
        
        TISection:Toggle({
            Name = "HBE",
            Flag = "HBETOGGLE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.TouchInterest.HBE = Value
                getgenv().TIhbe = Value
            end
        })
        
        TISection:Textbox({
            Name = "Distance",
            Flag = "HBEDISTANCE",
            Placeholder = "0",
            Default = "0",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.TouchInterest.Distance = tonumber(Value) or 0
            end
        })
        
        local BoxSection = PlayerSubPage:Section({Name = "Box HBE", Side = 2})
        
        BoxSection:Toggle({
            Name = "HBE",
            Flag = "BOXTOGGLE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Box.HBE = Value
            end
        })
        
        BoxSection:Toggle({
            Name = "Transparency",
            Flag = "TRANSPARENCYTOGGLE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Box.TransparencyToggle = Value
            end
        })
        
        BoxSection:Textbox({
            Name = "Hitbox Size",
            Flag = "BOXHITBOX",
            Placeholder = "2.5",
            Default = "2.5",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.Box.Hitbox = tonumber(Value) or 2.5
            end
        })
        
        BoxSection:Textbox({
            Name = "Transparency Value",
            Flag = "BOXTRANS",
            Placeholder = "1",
            Default = "1",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.Box.Transparency = tonumber(Value) or 1
            end
        })
    end
    
    do -- GK SubPage
        local GKBoxSection = GKSubPage:Section({Name = "Dive Box HBE", Side = 1})
        
        GKBoxSection:Toggle({
            Name = "Dive HBE",
            Flag = "DIVEHBE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.GK.BoxHBE = Value
            end
        })
        
        GKBoxSection:Toggle({
            Name = "Dive Transparency",
            Flag = "DIVETRANSTOGGLE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.GK.TransparencyToggle = Value
            end
        })
        
        GKBoxSection:Textbox({
            Name = "Dive Hitbox Size",
            Flag = "DIVEDISTANCE",
            Placeholder = "5",
            Default = "5",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.GK.BoxHitbox = tonumber(Value) or 5
            end
        })
        
        GKBoxSection:Textbox({
            Name = "Dive Transparency Value",
            Flag = "DIVETRANSVAL",
            Placeholder = "1",
            Default = "1",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.GK.BoxTransparency = tonumber(Value) or 1
            end
        })
        
        local GKTISection = GKSubPage:Section({Name = "Dive TouchInterest HBE", Side = 2})
        
        GKTISection:Toggle({
            Name = "GK HBE",
            Flag = "GKDIVE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.GK.DiveHBE = Value
            end
        })
        
        GKTISection:Textbox({
            Name = "GK Distance",
            Flag = "GKDISTANCE",
            Placeholder = "0",
            Default = "0",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.GK.DiveDistance = tonumber(Value) or 0
            end
        })
    end
    
    do -- Misc SubPage
        local MiscSection = MiscSubPage:Section({Name = "Usual Stuff", Side = 1})
        
        MiscSection:Toggle({
            Name = "Infinite Stamina",
            Flag = "INFSTAM",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Misc.InfStam = Value
            end
        })
        
        MiscSection:Toggle({
            Name = "No Cooldown",
            Flag = "NOCD",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Misc.NoCd = Value
            end
        })
        
        MiscSection:Toggle({
            Name = "Crossbar Phase",
            Flag = "CROSSBARPHASE",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Misc.CrossbarPhase = Value
            end
        })

        MiscSection:Toggle({
            Name = "Remove Ability Endlag",
            Flag = "AbilityStateToggle",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Toggles.AbilityState = Value
                if Value then
                    task.spawn(function()
                        while getgenv().Settings.Misc.NoEndlag do
                            task.wait()
                            StatesController.States.Ability = false
                        end
                    end)
                end
            end
        })
        
        local OpM1Section = MiscSubPage:Section({Name = "OP M1 STUFF", Side = 2})
        
        OpM1Section:Toggle({
            Name = "Op M1",
            Flag = "OPM1",
            Default = false,
            Callback = function(Value)
                getgenv().Settings.Misc.OpM1 = Value
            end
        })
        
        OpM1Section:Textbox({
            Name = "Change At",
            Flag = "ChangeAt",
            Placeholder = "When To Change",
            Default = "80",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.Misc.M1ChangeAt = tonumber(Value) or 80
            end
        })
        
        OpM1Section:Textbox({
            Name = "Power Buff",
            Flag = "PowerBuff",
            Placeholder = "PowerBuff",
            Default = "110",
            Numeric = true,
            Callback = function(Value)
                getgenv().Settings.Misc.M1Power = tonumber(Value) or 110
            end
        })
        
        OpM1Section:Textbox({
            Name = "Indi",
            Flag = "Indi",
            Placeholder = "0, 0, 0 = ground bug",
            Default = "0, 0, 0",
            Numeric = false,
            Callback = function(Value)
                local x, y, z = Value:match("([%d.-]+)%s*,%s*([%d.-]+)%s*,%s*([%d.-]+)")
                if x and y and z then
                    getgenv().Settings.Misc.M1INDI = Vector3.new(tonumber(x), tonumber(y), tonumber(z))
                else
                    getgenv().Settings.Misc.M1INDI = Vector3.new(0, 0, 0)
                end
            end
        })
    end
end

do -- Style Editor Page
    local SZLokiSubPage = StylePage:SubPage({Name = "SubZeroLoki", Columns = 1})
    
    local SZLokiSection = SZLokiSubPage:Section({Name = "Godspeed Freeze", Side = 1})
    
    SZLokiSection:Toggle({
        Name = "Godspeed Toggle",
        Flag = "GODSPEEDHBE",
        Default = false,
        Callback = function(Value)
            getgenv().Settings.SZLoki.GodspeedHbe = Value
        end
    })
    
    SZLokiSection:Toggle({
        Name = "Catch Grounded",
        Flag = "GODSPEEDGROUND",
        Default = false,
        Callback = function(Value)
            getgenv().Settings.SZLoki.GodspeedGround = Value
        end
    })
    
    SZLokiSection:Textbox({
        Name = "Hitbox Range",
        Flag = "SZLokiHBE",
        Placeholder = "Hitbox",
        Default = "20",
        Numeric = true,
        Callback = function(Value)
            getgenv().Settings.SZLoki.GodspeedDistance = tonumber(Value) or 20
        end
    })
    
    SZLokiSection:Textbox({
        Name = "Height",
        Flag = "SZHeight",
        Placeholder = "Height",
        Default = "100",
        Numeric = true,
        Callback = function(Value)
            getgenv().Settings.SZLoki.GodspeedHeight = tonumber(Value) or 100
        end
    })
    
    SZLokiSection:Textbox({
        Name = "Shot Power",
        Flag = "SZShotPower",
        Placeholder = "ShotPower",
        Default = "140",
        Numeric = true,
        Callback = function(Value)
            getgenv().Settings.SZLoki.ShotPower = tonumber(Value) or 140
        end
    })
end

-- Heartbeat loops
task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not getgenv().Settings.TouchInterest.HBE then return end
        if not hitbox or not hitbox.Parent then return end

        for _, football in ipairs(getgenv().FootballList) do
            if football and football.Parent and football:FindFirstChild("Hitbox") then
                local footballHitbox = football.Hitbox
                if footballHitbox and footballHitbox ~= hitbox then
                    if (hitbox.Position - footballHitbox.Position).Magnitude <= getgenv().Settings.TouchInterest.Distance then
                        firetouchinterest(hitbox, footballHitbox, 0)
                        firetouchinterest(hitbox, footballHitbox, 1)
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    RunService.Heartbeat:Connect(function()
        if not getgenv().Settings.GK.DiveHBE then return end
        if not hitbox or not hitbox.Parent then return end

        for _, diveHitbox in ipairs(getgenv().DiveList) do
            if diveHitbox and diveHitbox.Parent then
                if diveHitbox ~= hitbox then
                    if (hitbox.Position - diveHitbox.Position).Magnitude <= getgenv().Settings.GK.DiveDistance then
                        firetouchinterest(hitbox, diveHitbox, 0)
                        firetouchinterest(hitbox, diveHitbox, 1)
                    end
                end
            end
        end
    end)
end)

task.spawn(function()
    while true do
        for _, football in ipairs(getgenv().FootballList) do
            if football and football.Parent and football:FindFirstChild("Hitbox") then
                local footballHitbox = football.Hitbox
                
                if getgenv().Settings.Box.HBE then
                    footballHitbox.Size = Vector3.new(
                        getgenv().Settings.Box.Hitbox, 
                        getgenv().Settings.Box.Hitbox, 
                        getgenv().Settings.Box.Hitbox
                    )
                else
                    footballHitbox.Size = Vector3.new(2.5, 2.5, 2.5)
                end
                
                if getgenv().Settings.Box.TransparencyToggle then
                    footballHitbox.Transparency = getgenv().Settings.Box.Transparency
                else
                    footballHitbox.Transparency = 1
                end
            end
        end
        
        for _, diveHitbox in ipairs(getgenv().DiveList) do
            if diveHitbox and diveHitbox.Parent then
                if getgenv().Settings.GK.BoxHBE then
                    diveHitbox.Size = Vector3.new(
                        getgenv().Settings.GK.BoxHitbox, 
                        getgenv().Settings.GK.BoxHitbox, 
                        getgenv().Settings.GK.BoxHitbox
                    )
                else
                    diveHitbox.Size = Vector3.new(2.5, 2.5, 2.5)
                end
                
                if getgenv().Settings.GK.TransparencyToggle then
                    diveHitbox.Transparency = getgenv().Settings.GK.BoxTransparency
                else
                    diveHitbox.Transparency = 1
                end
            end
        end
        
        task.wait()
    end
end)

task.spawn(function()
    while true do
        local canCollide = not getgenv().Settings.Misc.CrossbarPhase
        
        if workspace:FindFirstChild("Goals") then
            local goal1 = workspace.Goals:FindFirstChild("Goal")
            local goal2 = workspace.Goals:FindFirstChild("Goal2")
            
            if goal1 and goal1:FindFirstChild("Model") then
                for _, child in ipairs(goal1.Model:GetChildren()) do
                    if child.Name == "MeshPart" then
                        child.CanCollide = canCollide
                    end
                end
            end
            
            if goal2 and goal2:FindFirstChild("Model") then
                for _, child in ipairs(goal2.Model:GetChildren()) do
                    if child.Name == "MeshPart" then
                        child.CanCollide = canCollide
                    end
                end
            end
        end
        
        task.wait()
    end
end)

task.spawn(function()
    local stats = player:WaitForChild("PlayerStats")
    local stamina = stats:WaitForChild("Stamina")
    
    while true do
        if getgenv().Settings.Misc.InfStam then
            if stamina.Value < 100 then
                stamina.Value = 100
            end
        end
        task.wait()
    end
end)

task.spawn(function()
    while true do
        if getgenv().Settings.Misc.NoCd then
            if not noCdEnabled then
                noCdEnabled = true
                AbilityController.legacy.AbilityCooldown = function(s, n, ...)
                    return originalAbilityCooldown(s, n, 0, ...)
                end
            end
        else
            if noCdEnabled then
                noCdEnabled = false
                AbilityController.legacy.AbilityCooldown = originalAbilityCooldown
            end
        end
        
        task.wait()
    end
end)

task.spawn(function()
    local Event = ReplicatedStorage.Packages.Knit.Services.BallService.RE.Shoot
    
    local mtHook
    mtHook = hookmetamethod(game, "__namecall", function(...)
        local self = ...
        
        if getgenv().Settings.Misc.OpM1 then
            if rawequal(self, Event) and getnamecallmethod() == "FireServer" then
                local Args = table.pack(...)
                
                local power = Args[2]
                local direction = Args[5]
                
                if power >= getgenv().Settings.Misc.M1ChangeAt then
                    power = getgenv().Settings.Misc.M1Power
                    direction = getgenv().Settings.Misc.M1INDI
                end
                
                local Result = table.pack(mtHook(self, power, Args[3], Args[4], direction))
                return table.unpack(Result, 1, Result.n)
            end
        end
        
        return mtHook(...)
    end)
end)

local function GroundedCheck()
    if getgenv().Settings.SZLoki.GodspeedGround then
        return 0
    else
        return 9
    end
end

AbilityController.ExecuteAbilitySlot = function(self, slot, p3)
    if not getgenv().Settings.SZLoki.GodspeedHbe then 
        return originalExecuteAbilitySlot(self, slot, p3) 
    end
    
    if slot ~= 2 then return originalExecuteAbilitySlot(self, slot, p3) end
    
    if not isGodspeedFreeze() then
        return originalExecuteAbilitySlot(self, slot, p3)
    end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if not AbilityUtils.rules.offball() or not AbilityUtils.rules.slotReady(2) then
        return
    end

    local i = AbilityController.legacy
    if i.AbilityTwo > tick() then return end
    if i.ABC then i.ABC:Clean() end

    i:AbilityCooldown("2", AB.GodspeedFreeze.Cooldown)
    i.StatesController.States.Ability = true
    i.Animations:StopAnims()

    local startAnim = AnimationController:GetTrack("Abilities", "GodspeedFreezeStart")
    startAnim:Play()
    startAnim:AdjustSpeed(2)

    task.delay(0.375, function()
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
        bodyVelocity.P = 100000
        bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 30 + Vector3.new(0, getgenv().Settings.SZLoki.GodspeedHeight, 0)
        bodyVelocity.Parent = humanoidRootPart

        for _ = 1, 8 do
            local velocity = bodyVelocity.Velocity
            bodyVelocity.Velocity = Vector3.new(velocity.X, velocity.Y * 0.9, velocity.Z)
            task.wait(0.02)
        end

        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity:Destroy()
    end)

    AbilityService.Ability:Fire("GodspeedFreeze")

    local abilityController = i.ABC

    abilityController:Add(task.delay(1.5, function()
        abilityController:Clean()
    end))

    abilityController:Add(AbilityService.Ability:Connect(function(ball, action)
        if not ball or action ~= "Start" then
            return
        end

        local startTime = tick()
        local range = getgenv().Settings.SZLoki.GodspeedDistance
        local groundThreshold = GroundedCheck()
        
        local checkConnection
        checkConnection = RunService.Heartbeat:Connect(function()
            local ballInRange = character.Values.HasBall.Value 
                or (ball.Char.Value == nil or ball.Char.Value.Values.HasBall.Value == false) 
                and ((humanoidRootPart.Position - ReplicatedStorage.Football.Value.Position).Magnitude <= range
                and ReplicatedStorage.Football.Value.Position.Y - groundThreshold >= 5)
            
            if ballInRange or tick() - startTime >= 0.3 then
                checkConnection:Disconnect()
                
                if ballInRange then
                    AbilityService.Ability:Fire("GodspeedFreeze", "Hit")
                    startAnim:Stop(0)

                    local hitAnim = AnimationController:GetTrack("Abilities", "GodspeedFreezeHit")
                    hitAnim:Play(0)
                    hitAnim:AdjustSpeed(1.5)

                    humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    AbilityUtils.clearMovers(character)

                    local hitVelocity = Instance.new("BodyVelocity")
                    hitVelocity.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
                    hitVelocity.P = 100000
                    hitVelocity.Velocity = humanoidRootPart.CFrame.LookVector * 10 + Vector3.new(0, 10, 0)
                    hitVelocity.Parent = humanoidRootPart

                    task.delay(0.55, function()
                        hitVelocity.Velocity = Vector3.new(0, 0, 0)
                    end)

                    task.wait(1.0333333333333334)

                    if hitVelocity then
                        hitVelocity:Destroy()
                    end

                    local friendlyTarget = AbilityUtils.rules.friendlyTarget(1000, true, false)
                    if friendlyTarget then
                        local targetDirection = (friendlyTarget.HumanoidRootPart.Position - humanoidRootPart.Position).Unit + Vector3.new(0, 0.1, 0)
                        local targetDistance = (friendlyTarget.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude * 1.5
                        ball.AssemblyLinearVelocity = targetDirection * math.clamp(targetDistance, 0, 150)
                    else
                        ball.AssemblyLinearVelocity = workspace.CurrentCamera.CFrame.LookVector * getgenv().Settings.SZLoki.ShotPower + AB.GodspeedFreeze.ShotTiltVector
                    end

                    i.BallController:DragBall(ball)

                    if abilityController then
                        abilityController:Clean()
                        return
                    end
                elseif abilityController then
                    abilityController:Clean()
                end
            end
        end)
    end))

    abilityController:Add(function()
        abilityController:Destroy()
        i.StatesController.States.Ability = false
    end)
end

Library:Notification("Loaded!", "Porn Hub loaded successfully!", 5)