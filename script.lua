getgenv().Cosmetic = "Frozen Aura"

getgenv().Cosmetic2 = "Cape"

local Event = game:GetService("ReplicatedStorage")
    .Packages.Knit.Services.CustomizationService.RE.Customize

while true do
Event:FireServer(
    "Cosmetics",
    getgenv().Cosmetic,
    "1"
)
task.wait(0)
Event:FireServer(
    "Cosmetics",
    getgenv().Cosmetic2,
    "1"
)
end