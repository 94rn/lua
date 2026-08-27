local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/94rn/lua/refs/heads/main/library.lua"))()

-- Create the window
local Window = Library:Window({
    Logo = "124454910007637",  -- Your logo asset ID
    FadeTime = 0.3,
})

-- Create watermark and keybind list
local Watermark = Library:Watermark("Porn Hub")
local KeybindList = Library:KeybindList()

-- Create pages
local CombatPage = Window:Page({Name = "Combat", SubPages = true})
local PlayerPage = Window:Page({Name = "Player", Columns = 2})
local VisualsPage = Window:Page({Name = "Visuals", Columns = 2})
local PlayersPage = Window:Page({Name = "Players", Columns = 2})
local SettingsPage = Library:CreateSettingsPage(Window, Watermark, KeybindList)

-- === COMBAT PAGE ===
do
    local WeaponSubPage = CombatPage:SubPage({Name = "Weapon", Columns = 2})
    local AimbotSubPage = CombatPage:SubPage({Name = "Aimbot", Columns = 2})
    
    -- Weapon Subpage
    do
        local RangedWeaponSection = WeaponSubPage:Section({Name = "Ranged Weapons", Side = 1})
        
        RangedWeaponSection:Toggle({
            Name = "Enabled",
            Flag = "RangedWeaponEnabled",
            Default = false,
            Callback = function(Value)
                print("Ranged Weapon Enabled:", Value)
                -- Your code here
            end
        })
        
        RangedWeaponSection:Toggle({
            Name = "Instant hit",
            Flag = "RangedWeaponInstantHit",
            Default = false,
            Callback = function(Value)
                print("Instant Hit:", Value)
                -- Your code here
            end
        })
        
        RangedWeaponSection:Toggle({
            Name = "Rapid fire",
            Flag = "RangedWeaponRapidFire",
            Default = false,
            Callback = function(Value)
                print("Rapid Fire:", Value)
                -- Your code here
            end
        })
        
        RangedWeaponSection:Toggle({
            Name = "Full auto",
            Flag = "RangedWeaponFullAuto",
            Default = false,
            Callback = function(Value)
                print("Full Auto:", Value)
                -- Your code here
            end
        })
        
        RangedWeaponSection:Slider({
            Name = "Reload time",
            Flag = "RangedWeaponReloadTime",
            Min = 0,
            Suffix = "s",
            Max = 5,
            Default = 0,
            Decimals = 0.01,
            Callback = function(Value)
                print("Reload Time:", Value)
                -- Your code here
            end
        })
        
        RangedWeaponSection:Dropdown({
            Name = "Mode",
            Items = {"Burst", "Auto", "Single"},
            Flag = "RangedWeaponMode",
            Default = "Burst",
            Multi = false,
            Callback = function(Value)
                print("Mode:", Value)
                -- Your code here
            end
        })
        
        local Button = RangedWeaponSection:Button()
        Button:Add("Apply", function()
            print("Apply button pressed")
            -- Your code here
        end)
        Button:Add("Reset", function()
            print("Reset button pressed")
            -- Your code here
        end)
    end
    
    -- Aimbot Subpage
    do
        local SilentAimSection = AimbotSubPage:Section({Name = "Silent Aim", Side = 1})
        
        SilentAimSection:Toggle({
            Name = "Enabled",
            Flag = "SilentAimEnabled",
            Default = false,
            Callback = function(Value)
                print("Silent Aim Enabled:", Value)
                -- Your code here
            end
        })
        
        local Toggle = SilentAimSection:Toggle({
            Name = "FoV Circle",
            Flag = "SilentAimFoVEnabled",
            Default = false,
            Callback = function(Value)
                print("FoV Circle:", Value)
                -- Your code here
            end
        })
        
        Toggle:Colorpicker({
            Name = "FoV Color",
            Flag = "SilentAimFoV",
            Default = Library.Theme.Accent,
            Alpha = 0,
            Callback = function(Value)
                print("FoV Color:", Value)
                -- Your code here
            end
        })
        
        Toggle:Colorpicker({
            Name = "FoV Outline",
            Flag = "SilentAimFoVOutline",
            Default = Color3.fromRGB(0, 0, 0),
            Alpha = 0,
            Callback = function(Value)
                print("FoV Outline:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Dropdown({
            Name = "Bone",
            Flag = "SilentAimBone",
            Default = "Head",
            Multi = false,
            Items = {"Head", "Chest", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"},
            Callback = function(Value)
                print("Bone:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Toggle({
            Name = "Manipulation",
            Flag = "SilentAimManipulation",
            Default = false,
            Callback = function(Value)
                print("Manipulation:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Slider({
            Name = "Radius",
            Flag = "FoVRadius",
            Min = 1,
            Suffix = "px",
            Max = 500,
            Default = 75,
            Decimals = 1,
            Callback = function(Value)
                print("FoV Radius:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Toggle({
            Name = "Wall Check",
            Flag = "SilentAimWallCheck",
            Default = false,
            Callback = function(Value)
                print("Wall Check:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Toggle({
            Name = "Team Check",
            Flag = "SilentAimTeamCheck",
            Default = false,
            Callback = function(Value)
                print("Team Check:", Value)
                -- Your code here
            end
        })
        
        SilentAimSection:Toggle({
            Name = "Death Check",
            Flag = "SilentAimDeathCheck",
            Default = false,
            Callback = function(Value)
                print("Death Check:", Value)
                -- Your code here
            end
        })
        
        local AimbotSection = AimbotSubPage:Section({Name = "Camera", Side = 2})
        
        AimbotSection:Toggle({
            Name = "Enabled",
            Flag = "AimbotEnabled",
            Default = false,
            Callback = function(Value)
                print("Aimbot Enabled:", Value)
                -- Your code here
            end
        }):Keybind({
            Flag = "AimbotKeybind",
            Default = Enum.KeyCode.E,
            Mode = "Toggle",
            Callback = function(Value)
                print("Aimbot Keybind Toggled:", Value)
                -- Your code here
            end
        })
        
        AimbotSection:Searchbox({
            Name = "Targets",
            Flag = "AimbotTargets",
            Items = {"Player 1", "Player 2", "Player 3", "Player 4", "Player 5"},
            Multi = false,
            Default = "Player 1",
            Callback = function(Value)
                print("Target:", Value)
                -- Your code here
            end
        })
    end
end

-- === PLAYER PAGE ===
do
    -- Add your player page elements here
    local PlayerSection = PlayerPage:Section({Name = "Player Settings", Side = 1})
    
    PlayerSection:Toggle({
        Name = "God Mode",
        Flag = "GodMode",
        Default = false,
        Callback = function(Value)
            print("God Mode:", Value)
            -- Your code here
        end
    })
    
    PlayerSection:Slider({
        Name = "Walk Speed",
        Flag = "WalkSpeed",
        Min = 16,
        Suffix = " studs/s",
        Max = 100,
        Default = 16,
        Decimals = 1,
        Callback = function(Value)
            print("Walk Speed:", Value)
            -- Your code here
        end
    })
end

-- === VISUALS PAGE ===
do
    -- Add your visual page elements here
    local VisualSection = VisualsPage:Section({Name = "Visual Settings", Side = 1})
    
    VisualSection:Toggle({
        Name = "ESP",
        Flag = "ESP",
        Default = false,
        Callback = function(Value)
            print("ESP:", Value)
            -- Your code here
        end
    })
    
    VisualSection:Colorpicker({
        Name = "ESP Color",
        Flag = "ESPColor",
        Default = Color3.fromRGB(255, 0, 0),
        Alpha = 0,
        Callback = function(Value)
            print("ESP Color:", Value)
            -- Your code here
        end
    })
end

-- === PLAYERS PAGE ===
do
    -- Add your players page elements here
    local PlayersSection = PlayersPage:Section({Name = "Player List", Side = 1})
    
    -- You can add dropdowns, toggles, etc. for player-specific settings
    PlayersSection:Dropdown({
        Name = "Select Player",
        Flag = "SelectedPlayer",
        Items = {"Player 1", "Player 2", "Player 3"},
        Default = "Player 1",
        Multi = false,
        Callback = function(Value)
            print("Selected Player:", Value)
            -- Your code here
        end
    })
end

-- Notification when loaded
Library:Notification("Loaded!", "Your script loaded successfully!", 5)