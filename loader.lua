local HttpGet = game.HttpGet
local PlaceId = game.PlaceId
local GameId = game.GameId

local function notify(title, message, duration)
    duration = duration or 6
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "[PandoraHub] " .. tostring(title),
            Text = tostring(message),
            Duration = duration,
        })
    end)
end

local function httpGetRetry(url, tries)
    tries = tries or 3
    for attempt = 1, tries do
        local ok, body = pcall(HttpGet, game, url)
        if ok and type(body) == "string" and #body > 0 then
            return body
        end
        if attempt < tries then task.wait(2) end
    end
    return nil
end

local Players = game:GetService("Players")
local username = ""
pcall(function()
    local lp = Players.LocalPlayer
    if lp then username = tostring(lp.Name) end
end)

local function urlEncode(s)
    return (s:gsub("[^A-Za-z0-9_]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local gamelistUrl = "https://ponggohub.netlify.app/gamelist.lua"
if username ~= "" then
    gamelistUrl = gamelistUrl .. "?u=" .. urlEncode(username)
end

local glSrc = httpGetRetry(gamelistUrl, 3)
if not glSrc then
    notify("Loader Error", "Failed to fetch gamelist from server. Check your internet.", 8)
    return
end
local ok, gamelist = pcall(function() return loadstring(glSrc)() end)
if not ok or type(gamelist) ~= "table" then
    notify("Loader Error", "Failed to fetch gamelist from server. Check your internet.", 8)
    return
end

local URL = gamelist[PlaceId] or gamelist[GameId]
if not URL then
    notify("Game Not Supported", "This game is not in our script list.", 8)
    return
end

local scriptSrc = httpGetRetry(URL, 3)
if not scriptSrc then
    notify("Load Failed", "Could not fetch the game script. Check your internet.", 8)
    return
end
local ok2, err = pcall(function() loadstring(scriptSrc)() end)
if not ok2 then
    notify("Load Failed", "Could not load the game script: " .. tostring(err), 8)
end
