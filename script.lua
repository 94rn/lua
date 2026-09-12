getgenv().Cosmetic = "Frozen Aura"

getgenv().Cosmetic = "Cape"

local Event = game:GetService("ReplicatedStorage")
    .Packages.Knit.Services.CustomizationService.RE.Customize

while true do
Event:FireServer(
    "Cosmetics",
    getgenv().Cosmetic,
    "1"
)
task.wait(1)
Event:FireServer(
    "Cosmetics",
    getgenv().Cosmetic,
    "1"
)
end