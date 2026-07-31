-- HYDRA LITE

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Http = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local CS = game:GetService("CollectionService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(char) Character = char end)

local DataService = require(RS.Modules.DataService)
local PetsRemote = RS:WaitForChild("GameEvents"):WaitForChild("PetsService")
local BoostRemote = RS:WaitForChild("GameEvents"):WaitForChild("PetBoostService")
local PetEggService = RS:WaitForChild("GameEvents"):WaitForChild("PetEggService")

local Library
do
 local ok, lib = pcall(function()
 return loadstring(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/HydraMainLibrary.lua"))()
 end)
 if ok and lib then
 Library = lib
 else
 warn("[HydraLite] Failed to load HydraMainLibrary, retrying...")
 task.wait(2)
 local ok2, lib2 = pcall(function()
 return loadstring(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/HydraMainLibrary.lua"))()
 end)
 if ok2 and lib2 then Library = lib2
 else error("[HydraLite] Could not load HydraMainLibrary!") end
 end
end
local UI = Library.new()

if not Library.buildPetList then
 Library.buildPetList = function(self, parent, selected, favs, onClick, getKG2, getInventory2, isFav2, sortFn2)
 local T2 = self.T
 for _, c in ipairs(parent:GetChildren()) do
 if c:IsA("GuiObject") then c:Destroy() end
 end
 local q = string.lower(sortFn2 or "")
 local inv = getInventory2()
 local uuids = {}
 for u in pairs(inv) do table.insert(uuids, u) end
 table.sort(uuids, function(a, b)
 local sa = (selected[a] and 1) or 0
 local sb = (selected[b] and 1) or 0
 if sa ~= sb then return sa > sb end
 return getKG2(a) > getKG2(b)
 end)
 for i, uuid in ipairs(uuids) do
 local pet = inv[uuid]
 if not pet then continue end
 local name = pet.PetType or "?"
 if q ~= "" and not name:lower():find(q, 1, true) then continue end
 local isActive = selected[uuid]
 local isFav2 = favs[uuid] == true
 local level = (pet.PetData and (pet.PetData.Level or 0)) or 0
 local kg = getKG2(uuid)
 local base = (pet.PetData and (pet.PetData.BaseWeight or 0)) or 0
 local favMark = (isFav2 and " *") or ""
 local activeMark = (isActive and " (active)") or ""
 local txt = string.format("%s%s%s | Age %d | %.2f KG | Base %.2f", name, activeMark, favMark, level, kg, base)
 local b = self:button(parent, txt, UDim2.new(1,0,0,26), nil,
 (isActive and T2.SEL_BG) or (isActive and T2.ACTIVE_BG) or Color3.fromRGB(13,13,13),
 (isActive and T2.SEL_TXT) or (isActive and T2.ACTIVE_TXT) or T2.TEXT, 9)
 b.LayoutOrder = i
 b:SetAttribute("uuid", uuid)
 b.TextXAlignment = Enum.TextXAlignment.Left
 self:pad(b, 0, 8, 4, 0)
 self:stroke(b, (isActive and T2.ACCENT) or T2.STROKE, 1)
 b.MouseButton1Click:Connect(function()
 onClick(uuid, b, selected)
 end)
 end
 end
end

local T = {
 BG = Color3.fromRGB(18, 18, 31),
 PANEL = Color3.fromRGB(12, 12, 20),
 BTN = Color3.fromRGB(26, 26, 46),
 SIDEBAR = Color3.fromRGB(14, 14, 24),
 STROKE = Color3.fromRGB(58, 58, 92),
 ACCENT = Color3.fromRGB(127, 119, 221),
 TEXT = Color3.fromRGB(220, 220, 235),
 DIM = Color3.fromRGB(100, 100, 130),
 SEL_BG = Color3.fromRGB(127, 119, 221),
 SEL_TXT = Color3.fromRGB(255, 255, 255),
 SUCCESS = Color3.fromRGB(80, 210, 100),
 ERROR = Color3.fromRGB(215, 70, 70),
 TOGGLE_ON = Color3.fromRGB(127, 119, 221),
 TOGGLE_OFF = Color3.fromRGB(35, 35, 55),
 ACTIVE_BG = Color3.fromRGB(20, 20, 50),
 ACTIVE_TXT = Color3.fromRGB(160, 150, 255),
 DARK_CARD = Color3.fromRGB(10, 10, 18),
 PHASE2 = Color3.fromRGB(180, 120, 255),
}
UI.T = T

local TIMING = {
 EQUIP_DELAY = 0.08,
 UNEQUIP_DELAY = 0.05,
 UNEQUIP_BUFFER = 0.01,
 AH_EQUIP_DELAY = 0.15,
 AH_UNEQUIP_DELAY = 0.1,
 AH_POST_UNEQUIP_BUFFER = 0.5,
 AH_KOI_SAFE_DELAY = 1,
 AH_KOI_POST_HATCH = 1.5,
 AH_SEAL_SAFE_DELAY = 1,
 AH_SEAL_POST_SELL = 2,
 POLL_RATE = 3,
}

local CONFIG_FILE = "HydraLite_Config.json"

local cfg = {
 petTeams = {},
 elephant = {
 levelingTeam = nil,
 elephantTeam = nil,
 targetWeight = 3.5,
 levelThreshold = 50,
 phase2Team = nil,
 phase2Enabled = false,
 phase2Threshold = 50,
 levelTo100 = true,
 gardenSlots = 1,
 gardenMode = "A",
 useExtraPets = false,
 extraPets = {},
 useExtraElePets = false,
 extraElePets = {},
 },
 targets = {},
 placeEggs = {
  enabled = false,
  order = {},
 },
 pickplace = {
 petTimer = 0,
 pickDelay = 0.2,
 placeDelay = 0.1,
 selPets = {},
 },
 petboost = {
 mode1 = { boostOptions = {["Small Toy"] = true}, selPets = {} },
 mode2 = { pairs = {}, boostOptions = {} },
 },
 toggles = {
 autoKG = false,
 pickplace = false,
 mode1boost = false,
 mode2boost = false,
 autoCollect = false,
 hidePlants = false,
 autoRefresh = false,
 autoTradeWorld = false,
 },
 misc = { rsInterval = 19 },
 webhook = { url = "", continueSession = false },
 leveling = {
 mainTeam = nil,
 optTeam = nil,
 optEnabled = false,
 optThreshold = 50,
 targets = {},
 },
 autoCollect = {
 interval = 0.1,
 sellAfter = false,
 selFruits = {},
 selVariants = {},
 stopWhenFull = false,
 maxInv = 200,
 },
 autoHatch = {
 eggName = "Paradise Egg",
 eggCount = 13,
 eggSpacing = 7,
 teamCD = nil,
 teamKoi = nil,
 teamSeal = nil,
 teamBronto = nil,
 brontoEnabled = true,
 brontoThresh = 4,
 sellPets = {},
 sellThresh = 0,
 favDelay = 0.1,
 espEnabled = true,
 running = false,
 autoSellWhenFull = false,
 petInvMax = 200,
 },
 autoTrade = {
 targetPlayer = nil,
 selPets = {},
 kgMode = "Above",
 kgVal = 0,
 ageMode = "Above",
 ageVal = 0,
 autoAccept = false,
 autoGift = false,
 },
}

-- saveConfig
local function saveConfig()
 if not writefile then return end
 pcall(function() writefile(CONFIG_FILE, Http:JSONEncode(cfg)) end)
end

-- loadConfig
local function loadConfig()
 if not readfile or not isfile or not isfile(CONFIG_FILE) then return end
 local ok, data = pcall(function() return Http:JSONDecode(readfile(CONFIG_FILE)) end)
 if not ok or not data then return end
 if data.petTeams then cfg.petTeams = data.petTeams end
 if data.elephant then for k, v in pairs(data.elephant) do cfg.elephant[k] = v end end
 if data.targets then cfg.targets = data.targets end
 if data.placeEggs then for k, v in pairs(data.placeEggs) do cfg.placeEggs[k] = v end end
 if data.pickplace then for k, v in pairs(data.pickplace) do cfg.pickplace[k] = v end end
 if data.petboost then
 if data.petboost.mode1 then
 if type(data.petboost.mode1.boostOptions) == "table" then
 cfg.petboost.mode1.boostOptions = data.petboost.mode1.boostOptions
 elseif data.petboost.mode1.boostOption then
 cfg.petboost.mode1.boostOptions = {[data.petboost.mode1.boostOption] = true}
 end
 if data.petboost.mode1.selPets then cfg.petboost.mode1.selPets = data.petboost.mode1.selPets end
 end
 if data.petboost.mode2 then for k, v in pairs(data.petboost.mode2) do cfg.petboost.mode2[k] = v end end
 end
 if data.toggles then for k, v in pairs(data.toggles) do cfg.toggles[k] = v end end
 if data.misc then for k, v in pairs(data.misc) do cfg.misc[k] = v end end
 if data.webhook then for k, v in pairs(data.webhook) do cfg.webhook[k] = v end end
 if cfg.webhook.continueSession == nil then cfg.webhook.continueSession = false end
 if data.leveling then for k, v in pairs(data.leveling) do cfg.leveling[k] = v end end
 if data.autoHatch then for k, v in pairs(data.autoHatch) do cfg.autoHatch[k] = v end end
 if data.autoTrade then for k, v in pairs(data.autoTrade) do cfg.autoTrade[k] = v end end
 if data.autoNM then
 if not cfg.autoNM then cfg.autoNM = {lvTeam=nil, hsTeam=nil, lvThresh=30, targets={}} end
 for k, v in pairs(data.autoNM) do cfg.autoNM[k] = v end
 end
 if data.autoEV then
 if not cfg.autoEV then cfg.autoEV = {pvTeam=nil, lvTeam=nil, levelTo100=false, autoCleanseFirst=false, targets={}} end
 for k, v in pairs(data.autoEV) do cfg.autoEV[k] = v end
 end
 if data.autoAgeBreaker then
 if not cfg.autoAgeBreaker then cfg.autoAgeBreaker = {targets={}, tumbalKgMax=2, tumbalAgeMax=99, skipEnabled=false} end
 for k, v in pairs(data.autoAgeBreaker) do cfg.autoAgeBreaker[k] = v end
 end
 if cfg.autoAgeBreaker and cfg.autoAgeBreaker.skipEnabled == nil then cfg.autoAgeBreaker.skipEnabled = false end
 if cfg.autoAgeBreaker and cfg.autoAgeBreaker.maxLevel == nil then cfg.autoAgeBreaker.maxLevel = 125 end
 if cfg.autoAgeBreaker and cfg.autoAgeBreaker.autoStart == nil then cfg.autoAgeBreaker.autoStart = false end
 if data.autoMutMachine then
 if not cfg.autoMutMachine then cfg.autoMutMachine = {targets={}, targetMut="Golden", cdTeam=nil, claimTeam=nil, lvTeam=nil, lvThresh=50} end
 for k, v in pairs(data.autoMutMachine) do cfg.autoMutMachine[k] = v end
 end
 if data.autoCollect then
 if type(data.autoCollect.selFruits) == "table" then cfg.autoCollect.selFruits = data.autoCollect.selFruits end
 if type(data.autoCollect.selVariants) == "table" then cfg.autoCollect.selVariants = data.autoCollect.selVariants end
 if data.autoCollect.interval ~= nil then cfg.autoCollect.interval = data.autoCollect.interval end
 if data.autoCollect.sellAfter ~= nil then cfg.autoCollect.sellAfter = data.autoCollect.sellAfter end
 if data.autoCollect.stopWhenFull ~= nil then cfg.autoCollect.stopWhenFull = data.autoCollect.stopWhenFull end
 if data.autoCollect.maxInv ~= nil then cfg.autoCollect.maxInv = data.autoCollect.maxInv end
 end
 cfg.autoHatch.brontoEnabled = true
 if cfg.elephant.levelTo100 == nil then cfg.elephant.levelTo100 = true end
 if cfg.elephant.phase2Enabled == nil then cfg.elephant.phase2Enabled = false end
 if cfg.elephant.phase2Threshold == nil then cfg.elephant.phase2Threshold = 50 end
 if cfg.elephant.gardenSlots == nil then cfg.elephant.gardenSlots = 1 end
 if cfg.elephant.gardenMode == nil then cfg.elephant.gardenMode = "A" end
 if cfg.elephant.useExtraPets == nil then cfg.elephant.useExtraPets = false end
 if cfg.elephant.extraPets == nil then cfg.elephant.extraPets = {} end
 if cfg.elephant.useExtraElePets == nil then cfg.elephant.useExtraElePets = false end
 if cfg.elephant.extraElePets == nil then cfg.elephant.extraElePets = {} end
 if not cfg.petboost.mode1.boostOptions or not next(cfg.petboost.mode1.boostOptions) then
 cfg.petboost.mode1.boostOptions = {["Small Toy"] = true}
 end
 if cfg.leveling.optThreshold == nil then cfg.leveling.optThreshold = 50 end
 if cfg.leveling.optEnabled == nil then cfg.leveling.optEnabled = false end
 if type(cfg.leveling.targets) ~= "table" then cfg.leveling.targets = {} end
 if data.autoHatch and data.autoHatch.specialBronto then
 if not cfg.autoHatch.specialBronto then cfg.autoHatch.specialBronto = {enabled=true, pets={}} end
 if data.autoHatch.specialBronto.enabled ~= nil then cfg.autoHatch.specialBronto.enabled = data.autoHatch.specialBronto.enabled end
 if type(data.autoHatch.specialBronto.pets) == "table" then cfg.autoHatch.specialBronto.pets = data.autoHatch.specialBronto.pets end
 end
 local defaults = {
 eggName="Paradise Egg", eggCount=13, eggSpacing=7, teamCD=nil, teamKoi=nil, teamSeal=nil,
 teamBronto=nil, brontoEnabled=true, brontoThresh=4, sellPets={}, sellThresh=0, favDelay=0.1,
 espEnabled=true, running=false, ahUnequipDelay=0.1, ahEquipDelay=0.15, autoSellWhenFull=false,
 petInvMax=200, postUnequipBuffer=0.5, koiSafeDelay=1, koiPostHatch=1.5, sealSafeDelay=1, sealPostSell=2,
 }
 for k, v in pairs(defaults) do
 if cfg.autoHatch[k] == nil then cfg.autoHatch[k] = v end
 end
end
loadConfig()
if cfg.autoHatch.ahEquipDelay then TIMING.AH_EQUIP_DELAY = cfg.autoHatch.ahEquipDelay end
if cfg.autoHatch.ahUnequipDelay then TIMING.AH_UNEQUIP_DELAY = cfg.autoHatch.ahUnequipDelay end
if cfg.autoHatch.postUnequipBuffer then TIMING.AH_POST_UNEQUIP_BUFFER = cfg.autoHatch.postUnequipBuffer end
if cfg.autoHatch.koiSafeDelay then TIMING.AH_KOI_SAFE_DELAY = cfg.autoHatch.koiSafeDelay end
if cfg.autoHatch.koiPostHatch then TIMING.AH_KOI_POST_HATCH = cfg.autoHatch.koiPostHatch end
if cfg.autoHatch.sealSafeDelay then TIMING.AH_SEAL_SAFE_DELAY = cfg.autoHatch.sealSafeDelay end
if cfg.autoHatch.sealPostSell then TIMING.AH_SEAL_POST_SELL = cfg.autoHatch.sealPostSell end

local PET_UUID_KEY = "PET_UUID"
local FAV_KEY = "d"

local function getInventory()
 local d = DataService:GetData()
 return (d and d.PetsData and d.PetsData.PetInventory.Data) or {}
end

local function getKG(uuid)
 for _, container in ipairs({Backpack, Character}) do
 for _, tool in ipairs(container:GetChildren()) do
 if tool:IsA("Tool") and tool:GetAttribute(PET_UUID_KEY) == uuid then
 local kg = tool:GetAttribute("KG")
 if kg then return kg end
 local m = tool.Name:match("%[(%d+%.?%d*)%s*KG%]")
 if m then return tonumber(m) end
 end
 end
 end
 local inv = getInventory()
 return (inv[uuid] and (inv[uuid].PetData.BaseWeight or 0)) or 0
end

local function getAge(uuid)
 local inv = getInventory()
 return (inv[uuid] and (inv[uuid].PetData.Level or 0)) or 0
end

local function getBase(uuid)
 local inv = getInventory()
 return (inv[uuid] and (inv[uuid].PetData.BaseWeight or 0)) or 0
end

local function getPType(uuid)
 local inv = getInventory()
 return (inv[uuid] and (inv[uuid].PetType or "Unknown")) or "Unknown"
end

local function isFav(uuid)
 for _, container in ipairs({Backpack, Character}) do
 for _, tool in ipairs(container:GetChildren()) do
 if tool:IsA("Tool") and tool:GetAttribute(PET_UUID_KEY) == uuid then
 return tool:GetAttribute(FAV_KEY) == true
 end
 end
 end
 return false
end

local function findPetTool(uuid)
 for _, container in ipairs({Backpack, Character}) do
 for _, tool in ipairs(container:GetChildren()) do
 if tool:IsA("Tool") and tool:GetAttribute(PET_UUID_KEY) == uuid then
 return tool
 end
 end
 end
 return nil
end

local PetJSON = Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/pets.json"))
local AssetIDs = {}
task.spawn(function()
 local ok, data = pcall(function()
 return Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/PetAssetId.json"))
 end)
 if ok and data then AssetIDs = data end
end)
local MutJSON = Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/mutation.json"))

local function getMutName(uuid)
 local inv = getInventory()
 local pet = inv[uuid]
 if not pet or not pet.PetData then return "" end
 local mut = pet.PetData.MutationType or ""
 if mut == "" or mut == "m" then return "" end
 return MutJSON[mut] or mut
end

local trackerToken = "hx_punpsdun_tracker_2024"
local trackerEndpoint = "https://hydra-checker.vercel.app/api/t"
local trackerLoadURL = "https://hydra-checker.vercel.app/api/load-tracker?token=" .. trackerToken
task.spawn(function()
 local ok, data = pcall(function() return loadstring(game:HttpGet(trackerLoadURL))() end)
 if ok and data then
 _HT = data
 _HT.init({username=LocalPlayer.Name, userId=tostring(LocalPlayer.UserId), secret=trackerToken, endpoint=trackerEndpoint})
 end
end)

local function htTrack(event, data)
 if not _HT then return end
 pcall(function() _HT.track(event, data) end)
end

local function getAssetThumbnail(assetId)
 if not assetId then return nil end
 local id = tostring(assetId):match("%d+")
 if not id then return nil end
 local ok, res = pcall(function()
 return Http:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&size=150x150&format=Png&isCircular=false"))
 end)
 if ok and res and res.data and res.data[1] and res.data[1].imageUrl then
 return res.data[1].imageUrl
 end
 return nil
end

local function sendWebhook(embeds)
 local url = cfg.webhook.url
 if not url or url == "" then return end
 if not string.match(url, "^https://discord") and not string.match(url, "^https://ptb.discord") and not string.match(url, "^https://canary.discord") then return end
 task.spawn(function()
 local ok, err = pcall(function()
 local hasSpecial = embeds and embeds[1] and embeds[1].title and embeds[1].title:find("Special Pet")
 local body = Http:JSONEncode({
 username = LocalPlayer.Name,
 avatar_url = "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png",
 content = (hasSpecial and "@everyone") or nil,
 embeds = embeds,
 })
 local req = (syn and syn.request) or (http and http.request) or request
 if req then
 req({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
 else
 Http:PostAsync(url, body, Enum.HttpContentType.ApplicationJson, false)
 end
 end)
 if not ok then warn("[HydraLite Webhook]", err) end
 end)
end

local progressHistory = {}
local function sendCycleWebhook(petName, fromKG, toKG, targetKG, cycleTime, phase, queuePos, queueTotal, petId)
 local pct = math.min((toKG / targetKG) * 100, 100)
 local bar = string.rep("#", math.floor(pct / 10)) .. string.rep("-", 10 - math.floor(pct / 10))
 if petId then
 if not progressHistory[petId] then progressHistory[petId] = {times={}, gains={}} end
 local h = progressHistory[petId]
 table.insert(h.times, cycleTime)
 table.insert(h.gains, toKG - fromKG)
 if #h.times > 5 then table.remove(h.times, 1) end
 if #h.gains > 5 then table.remove(h.gains, 1) end
 end
 local avgTime, avgGain = cycleTime, toKG - fromKG
 if petId and progressHistory[petId] then
 local h = progressHistory[petId]
 local st, sg = 0, 0
 for _, t in ipairs(h.times) do st = st + t end
 for _, g in ipairs(h.gains) do sg = sg + g end
 avgTime = st / #h.times
 avgGain = sg / #h.gains
 end
 local remaining = math.max(targetKG - toKG, 0)
 local cyclesLeft = (avgGain > 0) and math.ceil(remaining / avgGain) or 0
 local eta = cyclesLeft * avgTime
 local estDone = (cyclesLeft > 0) and string.format("~%d cycles (~%s)", cyclesLeft, Library.fmtTime(eta)) or "Almost done!"
 local function fmt3(n) local s = string.format("%.3f", n); return s:gsub("%.?0+$", "") end
 sendWebhook({{title = "Cycle Complete", color = 5793266,
 description = string.format("**%s** | Queue `%d / %d`\n\n`%s` **%.1f%%**", petName, queuePos or 0, queueTotal or 0, bar, pct),
 fields = {
 {name = "Weight", value = string.format("%s -> **%s** kg", fmt3(fromKG), fmt3(toKG)), inline = true},
 {name = "Target", value = string.format("%s kg", fmt3(targetKG)), inline = true},
 {name = "Phase", value = phase or "?", inline = true},
 {name = "Cycle", value = Library.fmtTime(cycleTime), inline = true},
 {name = "Gain", value = string.format("+%s kg", fmt3(toKG - fromKG)), inline = true},
 {name = "Est. Done", value = estDone, inline = true},
 },
 footer = {text = "Hydra Hub  " .. os.date("%d/%m/%Y %H:%M:%S")},
 thumbnail = {url = "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"},
 }})
end

local function sendPetFinishedWebhook(petName, finalKG, totalTime, p2Time, doneCount, totalPets)
 local starCount = math.min(math.floor(finalKG / 1), 5)
 local stars = string.rep("*", starCount) .. string.rep(".", 5 - starCount)
 sendWebhook({{title = "Pet Finished!", color = 5763719,
 description = string.format("**%s** has reached **Level 100**!\n%s", petName, stars),
 fields = {
 {name = "Final Base", value = string.format("**%.3f** kg", finalKG), inline = true},
 {name = "Queue", value = string.format("%d / %d done", doneCount or 0, totalPets or 0), inline = true},
 {name = "Total Time", value = Library.fmtTime(totalTime), inline = false},
 {name = "Phase 2 Time", value = Library.fmtTime(p2Time), inline = true},
 {name = "Phase 1 Time", value = Library.fmtTime(totalTime - p2Time), inline = true},
 },
 footer = {text = "Hydra Hub  " .. os.date("%d/%m/%Y %H:%M:%S")},
 thumbnail = {url = "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"},
 }})
end

local function sendTestWebhook()
 sendWebhook({{title = "Hydra Hub  Connection Test", color = 5793266,
 description = "Webhook Connected!",
 fields = {
 {name = "Status", value = "Online", inline = true},
 {name = "Time", value = os.date("%H:%M:%S"), inline = true},
 {name = "Player", value = LocalPlayer.Name, inline = true},
 },
 footer = {text = "Hydra Hub  v1"},
 }})
end

local function getSpecialTier(brontoKG)
 if brontoKG >= 9 then return "godly" end
 if brontoKG >= 7 then return "titan" end
 if brontoKG >= 5 then return "huge" end
 return nil
end

local function sendSpecialWebhook(petName, kg, brontoKG, age, eggName)
 local url = cfg.webhook.url
 if not url or url == "" then return end
 local tier = ""
 if brontoKG >= 9 then tier = "Godly"
 elseif brontoKG >= 7 then tier = "Titan"
 elseif brontoKG >= 5 then tier = "Huge"
 end
 local assetId = AssetIDs[petName]
 if not assetId then
 local ok2, data2 = pcall(function()
 return Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/PetAssetId.json"))
 end)
 if ok2 and data2 then assetId = data2[petName] end
 end
 local thumb = getAssetThumbnail(assetId) or "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"
 local color = 5793266
 if tier == "Godly" then color = 16766720
 elseif tier == "Titan" then color = 12632256
 elseif tier == "Huge" then color = 5763719
 end
 sendWebhook({{title = "Special Pet Found  " .. petName, color = color,
 fields = {
 {name = "Pet Info", value = ">>> " .. petName .. "\nWeight: " .. string.format("%.2f KG", kg) .. "\nBronto: " .. string.format("%.2f KG", brontoKG) .. "\nAge: Age " .. tostring(age or 0), inline = false},
 {name = "Egg Info", value = ">>> Egg: " .. (eggName or "?") .. "\nTier: " .. ((tier ~= "") and tier or "Normal"), inline = false},
 {name = "Info", value = ">>> Player: ||" .. LocalPlayer.Name .. "||" .. "\nTime: " .. os.date("%d/%m/%Y %H:%M:%S"), inline = false},
 },
 thumbnail = {url = thumb},
 footer = {text = "Hydra Hub  " .. os.date("%d/%m/%Y %H:%M:%S")},
 }})
end

local SESSION_FILE = "HydraLite_Session.json"
local session = {
 startTime = 0, cycleCount = 0, totalHatched = 0,
 eggBefore = 0, eggCurrent = 0,
 koiProc = 0, sealProc = 0, koiLastCycle = 0, sealLastCycle = 0,
 petTypes = {},
 specials = {huge={count=0, pets={}}, titan={count=0, pets={}}, godly={count=0, pets={}}},
}
local function saveSession()
 if not writefile then return end
 pcall(function() writefile(SESSION_FILE, Http:JSONEncode({
 AH = {startTime=session.startTime, cycleCount=session.cycleCount, totalHatched=session.totalHatched,
 eggBefore=session.eggBefore, eggCurrent=session.eggCurrent, koiProc=session.koiProc,
 sealProc=session.sealProc, koiLastCycle=session.koiLastCycle, sealLastCycle=session.sealLastCycle,
 petTypes=session.petTypes, specials=session.specials},
 KG = {startTime=0, doneCount=0, totalPets=0},
 })) end)
end
local function loadSession()
 if not readfile or not isfile or not isfile(SESSION_FILE) then return nil end
 local ok, data = pcall(function() return Http:JSONDecode(readfile(SESSION_FILE)) end)
 if not ok or not data then return nil end
 return data
end
local function deleteSession()
 if not isfile or not isfile(SESSION_FILE) then return end
 pcall(function() if delfile then delfile(SESSION_FILE) end end)
end

local equipState = {IsEquipping = false, PP_Processing = {}, GlobalBoostApplying = false}

local function getActivePets()
 local rep = nil
 if not rep then
 local ok, r = pcall(function()
 local re = require(RS.Modules.ReplicationClass).new("ActivePetsService_Replicator")
 re:YieldUntilData()
 return re
 end)
 if ok then rep = r end
 end
 if not rep then return {} end
 local ok, data = pcall(function() return rep:YieldUntilData().Table end)
 if not ok or not data then return {} end
 local states = data.ActivePetStates
 local myPets = states[LocalPlayer.Name] or states[tonumber(LocalPlayer.Name)] or {}
 local list = {}
 for uuid in pairs(myPets) do table.insert(list, uuid) end
 return list
end

local function unequipAll()
 equipState.IsEquipping = true
 for _, uuid in ipairs(getActivePets()) do
 pcall(function() PetsRemote:FireServer("UnequipPet", uuid) end)
 task.wait(TIMING.UNEQUIP_DELAY)
 end
 task.wait(TIMING.UNEQUIP_BUFFER)
 equipState.IsEquipping = false
end

local function getFarmCF()
 local farm = workspace:FindFirstChild("Farm")
 if farm then
 local myPlot = farm:FindFirstChild(LocalPlayer.Name)
 if myPlot then
 local important = myPlot:FindFirstChild("Important")
 if important then
 local plantLoc = important:FindFirstChild("Plant_Locations")
 if plantLoc then
 local children = plantLoc:GetChildren()
 if #children > 0 then return children[1]:GetPivot() end
 end
 end
 end
 end
end

local function equipList(list)
 equipState.IsEquipping = true
 local cf = getFarmCF()
 for _, uuid in ipairs(list) do
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 equipState.IsEquipping = false
end

local function waitUntilEquipped(targetCount, timeout)
 timeout = timeout or 8
 local t = os.clock()
 while os.clock() - t < timeout do
 if #getActivePets() >= targetCount then return true end
 task.wait(0.2)
 end
 return false
end

local function buildEquip(target, team)
 local list = {target}
 for _, uuid in ipairs(team or {}) do
 if #list >= 8 then break end
 local found = false
 for _, e in ipairs(list) do if e == uuid then found = true; break end end
 if not found then table.insert(list, uuid) end
 end
 return list
end

local currentTarget = nil
local currentTeam = {}
local isKGRunning = false

local teamWatcherRunning = false
local desiredPets = {}

local function startTeamWatcher()
 teamWatcherRunning = true
 task.spawn(function()
 while teamWatcherRunning do
 task.wait(TIMING.POLL_RATE)
 if equipState.IsEquipping or not isKGRunning then continue end
 if not next(desiredPets) then continue end
 local active = getActivePets()
 local toAdd, toRemove = {}, {}
 for uuid in pairs(desiredPets) do
 local found = false
 for _, a in ipairs(active) do
 if a == uuid then found = true; break end
 end
 if not found then table.insert(toAdd, uuid) end
 end
 for _, a in ipairs(active) do
 if not desiredPets[a] then table.insert(toRemove, a) end
 end
 if #toRemove > 0 or #toAdd > 0 then
 equipState.IsEquipping = true
 for _, uuid in ipairs(toRemove) do
 pcall(function() PetsRemote:FireServer("UnequipPet", uuid) end)
 task.wait(TIMING.UNEQUIP_DELAY)
 end
 local cf = getFarmCF()
 for _, uuid in ipairs(toAdd) do
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 equipState.IsEquipping = false
 end
 end
 end)
end

local function stopTeamWatcher()
 teamWatcherRunning = false
 table.clear(desiredPets)
end

local function setDesiredPets(equipList2, teamList)
 table.clear(desiredPets)
 for _, uuid in ipairs(equipList2) do desiredPets[uuid] = true end
 for _, uuid in ipairs(teamList) do desiredPets[uuid] = true end
end

local builtInTeams = {
 {name="7 Mimic + 1 Bald Eagle", desc="Max passive Mimic, 1 Eagle filler",
 slots={{petType="Mimic Octopus",count=7},{petType="Bald Eagle",count=1}}},
 {name="Koi Max Passive", desc="Max hatch rate bonus, highest KG + mutation",
 slots={{petType="Koi",count=8}}},
 {name="Seal Max Passive", desc="Max sell return chance, always 8 Seal",
 slots={{petType="Seal",count=8}}},
 {name="Bronto Max Passive", desc="Max hatch size bonus (~30%), rest filled with Koi",
 slots={{petType="Brontosaurus",count=8},{petType="Koi",count=8}}},
 {name="Magpie Method", desc="1 Mimic, 3 Magpie, 1 Cockatrice, 3 filler priority",
 slots={{petType="Mimic Octopus",count=1},{petType="Magpie",count=3},{petType="Cockatrice",count=1}},
 priorityFiller={"Giant Ant","Red Giant Ant","Silver Monkey","Cape Buffalo"}, fillerCount=3},
}

local function getTeamUUIDs(teamName)
 if not teamName then return {} end
 for _, team in ipairs(builtInTeams) do
 if team.name == teamName then
 local inv = (function() local d = DataService:GetData()
 return (d and d.PetsData and d.PetsData.PetInventory.Data) or {} end)()
 local byType = {}
 for uuid, pet in pairs(inv) do
 local pt = pet.PetType or ""
 if not byType[pt] then byType[pt] = {} end
 table.insert(byType[pt], uuid)
 end
 local mutBonus = {a=0,b=0.1,c=0.2,d=0.3,g=0.5,s=0.05,z=0.08,A=0.22,J=0.01,K=0.03,L=0.045,M=0.06,N=0.07,O=0.07,P=0.3,V=0.2,X=0.3,Y=0.3,Z=0.3,["@"]=0.23,EV=0.3,RJ=0.25}
 local function effKG(uuid)
 local p = inv[uuid]
 if not p or not p.PetData then return 0 end
 local bw = p.PetData.BaseWeight or 0
 local mt = p.PetData.MutationType or "m"
 return bw * (1 + (mutBonus[mt] or 0))
 end
 local function brontoEffKG(uuid)
 local p = inv[uuid]
 if not p or not p.PetData then return 0 end
 local bw = p.PetData.BaseWeight or 0
 local mt = p.PetData.MutationType or "m"
 return (5.35 + (bw * 0.1)) * (1 + (mutBonus[mt] or 0))
 end
 for _, list in pairs(byType) do table.sort(list, function(a,b) return effKG(a) > effKG(b) end) end
 if team.name == "Magpie Method" then
 local result = {}
 for _, slot in ipairs(team.slots) do
 local pts = byType[slot.petType] or {}
 local count = 0
 for _, uuid in ipairs(pts) do
 if #result >= 8 then break end
 if count >= slot.count then break end
 table.insert(result, uuid); count = count + 1
 end
 end
 local fillerCount = 0
 local maxFiller = team.fillerCount or 3
 local fillerPool = {}
 for _, ft in ipairs(team.priorityFiller or {}) do
 for _, uuid in ipairs(byType[ft] or {}) do
 local already = false
 for _, r in ipairs(result) do if r == uuid then already = true; break end end
 if not already then table.insert(fillerPool, uuid) end
 end
 end
 table.sort(fillerPool, function(a,b) return effKG(a) > effKG(b) end)
 for _, uuid in ipairs(fillerPool) do
 if #result >= 8 then break end
 if fillerCount >= maxFiller then break end
 table.insert(result, uuid); fillerCount = fillerCount + 1
 end
 return result
 end
 if team.name == "Bronto Max Passive" then
 local result = {}
 local totalBronto = 0
 local brontos = byType["Brontosaurus"] or {}
 table.sort(brontos, function(a,b) return brontoEffKG(a) > brontoEffKG(b) end)
 for _, uuid in ipairs(brontos) do
 if #result >= 8 then break end
 if totalBronto >= 30 then break end
 table.insert(result, uuid); totalBronto = totalBronto + brontoEffKG(uuid)
 end
 local koi = byType["Koi"] or {}
 for _, uuid in ipairs(koi) do
 if #result >= 8 then break end
 table.insert(result, uuid)
 end
 return result
 end
 local result = {}
 for _, slot in ipairs(team.slots) do
 local pts = byType[slot.petType] or {}
 local count = 0
 for _, uuid in ipairs(pts) do
 if #result >= 8 then break end
 if count >= slot.count then break end
 table.insert(result, uuid); count = count + 1
 end
 end
 if #result < 8 then
 for _, slot in ipairs(team.slots) do
 local pts = byType[slot.petType] or {}
 for _, uuid in ipairs(pts) do
 if #result >= 8 then break end
 local already = false
 for _, r in ipairs(result) do if r == uuid then already = true; break end end
 if not already then table.insert(result, uuid) end
 end
 end
 end
 return result
 end
 end
 return (cfg.petTeams[teamName] and cfg.petTeams[teamName].uuids) or {}
end

local function buildTeamDD(parent, onSelect, current, UI2, cfg2, T2)
 for _, c in ipairs(parent:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 local teamNames = {}
 if _G._NH_BUILTIN_TEAMS then
 for _, t in ipairs(_G._NH_BUILTIN_TEAMS) do table.insert(teamNames, t.name) end
 end
 for name in pairs(cfg2.petTeams) do table.insert(teamNames, name) end
 table.sort(teamNames)
 if #teamNames == 0 then
 local lbl = UI2:label(parent, " (save a team first)", UDim2.new(1,0,0,22), nil, T2.DIM, 9)
 lbl.LayoutOrder = 1
 return 1
 end
 for i, name in ipairs(teamNames) do
 local isSelected = current == name
 local isBuiltin = false
 if _G._NH_BUILTIN_TEAMS then
 for _, bt in ipairs(_G._NH_BUILTIN_TEAMS) do
 if bt.name == name then isBuiltin = true; break end
 end
 end
 local bg = (isBuiltin and Color3.fromRGB(40,20,80)) or Color3.fromRGB(14,14,14)
 local txt = (isBuiltin and Color3.fromRGB(180,160,255)) or T2.TEXT
 local stroke = (isBuiltin and Color3.fromRGB(80,60,160)) or T2.STROKE
 if isSelected then
 bg = (isBuiltin and Color3.fromRGB(80,50,160)) or T2.SEL_BG
 txt = T2.SEL_TXT
 stroke = (isBuiltin and Color3.fromRGB(160,120,255)) or T2.ACCENT
 end
 local btn = UI2:button(parent, name, UDim2.new(1,0,0,22), nil, bg, txt, 9)
 btn.LayoutOrder = i; btn.TextXAlignment = Enum.TextXAlignment.Left
 UI2:pad(btn, 0, 8, 0, 0); UI2:stroke(btn, stroke, 1)
 if isBuiltin then
 local icon = Instance.new("ImageLabel", btn)
 icon.Size = UDim2.new(0,16,0,16); icon.Position = UDim2.new(1,-20,0.5,-8)
 icon.BackgroundTransparency = 1
 icon.Image = "rbxthumb://type=Asset&id=5669312251&w=150&h=150"
 icon.ScaleType = Enum.ScaleType.Fit; icon.ZIndex = btn.ZIndex + 1
 end
 btn.MouseButton1Click:Connect(function() onSelect(name) end)
 end
 return #teamNames
end

local function getExtraPets(excluded, maxCount)
 local inv = getInventory()
 local candidates = {}
 for uuid in pairs(cfg.elephant.extraPets) do
 if not excluded[uuid] and inv[uuid] then table.insert(candidates, uuid) end
 end
 table.sort(candidates, function(a,b) return getKG(a) > getKG(b) end)
 local result = {}
 for i = 1, math.min(maxCount, #candidates) do table.insert(result, candidates[i]) end
 return result
end

 local function getExtraElePets(excluded, maxCount)
 local inv = getInventory()
 local candidates = {}
 for uuid in pairs(cfg.elephant.extraElePets) do
 if not excluded[uuid] and inv[uuid] then table.insert(candidates, uuid) end
 end
 table.sort(candidates, function(a,b) return getKG(a) > getKG(b) end)
 local result = {}
 for i = 1, math.min(maxCount, #candidates) do table.insert(result, candidates[i]) end
 return result
 end

 local function getMyFarm()
 local farm = workspace:FindFirstChild("Farm")
 if not farm then return nil end
 local myPlot = farm:FindFirstChild(LocalPlayer.Name)
 if not myPlot then return nil end
 return myPlot
 end

 local function getEggPositions()
 local plot = getMyFarm()
 if not plot then return {} end
 local important = plot:FindFirstChild("Important")
 if not important then return {} end
 local plantLoc = important:FindFirstChild("Plant_Locations")
 if not plantLoc then return {} end
 local children = plantLoc:GetChildren()
 if #children == 0 then return {} end
 local base = children[1].Position
 local positions = {}
 for i = -2, 2 do
 table.insert(positions, Vector3.new(base.X + (i * 4), base.Y, base.Z - 15))
 end
 for i = -1, 1 do
 table.insert(positions, Vector3.new(base.X + (i * 4), base.Y, base.Z - 19))
 end
 return positions
 end

 local function countPlacedEggs()
 local plot = getMyFarm()
 if not plot then return 0, {} end
 local important = plot:FindFirstChild("Important")
 if not important then return 0, {} end
 local objects = important:FindFirstChild("Objects_Physical")
 if not objects then return 0, {} end
 local count = 0
 local placedPositions = {}
 for _, obj in ipairs(objects:GetChildren()) do
 if obj.Name == "PetEgg" then
 count = count + 1
 local eggPart = obj:FindFirstChild("PetEgg")
 if eggPart then
 table.insert(placedPositions, eggPart.Position)
 end
 end
 end
 return count, placedPositions
 end

 local function getEggToolByName(eggName)
 for _, tool in ipairs(Backpack:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetEggTool") then
 if tool:GetAttribute("h") == eggName then
 return tool
 end
 end
 end
 return nil
 end

local PetBoostRegistry = nil
do
 local ok, reg = pcall(function()
 local folder = RS:WaitForChild("Data", 10)
 if folder then return require(folder:WaitForChild("PetBoostRegistry", 5)) end
 end)
 if ok and reg then PetBoostRegistry = reg end
end

local function hasBoostApplied(uuid, statName, petModelName)
 if not PetBoostRegistry then return false end
 local ok, data = pcall(function() return DataService:GetData() end)
 if not ok or not data then return false end
 local petData = data.PetsData and data.PetsData.PetInventory and data.PetsData.PetInventory.Data
 if not petData or not petData[uuid] then return false end
 local boosts = petData[uuid].PetData and petData[uuid].PetData.Boosts
 if not boosts or not next(boosts) then return false end
 local applied = {}
 for _, boost in pairs(boosts) do
 local bType = boost.BoostType or boost.Type
 local bAmount = boost.BoostAmount or boost.Amount
 local statData = PetBoostRegistry.BoostTypeStatData and PetBoostRegistry.BoostTypeStatData[bType]
 if statData and statData.Amount then
 local modelName = PetBoostRegistry.BoostTypeToPetModelName[bType]
 for stat, amount in pairs(statData.Amount) do
 if amount == bAmount then applied[stat .. " " .. modelName] = true end
 end
 end
 end
 return applied[statName .. " " .. petModelName] == true
end

local function findBoostTool(statName, petModelName)
 for _, tool in ipairs(Backpack:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetBoost") and string.find(tool.Name, statName) and string.find(tool.Name, petModelName) then
 return tool
 end
 end
 return nil
end

local function applyBoost(uuid, statName, petModelName)
 if equipState.GlobalBoostApplying then return false end
 if hasBoostApplied(uuid, statName, petModelName) then return false end
 local tool = findBoostTool(statName, petModelName)
 if not tool then return false end
 equipState.GlobalBoostApplying = true
 for _, t in ipairs(Character:GetChildren()) do
 if t:IsA("Tool") then t.Parent = Backpack end
 end
 task.wait(0.05)
 pcall(function() tool.Parent = Character end)
 task.wait(0.1)
 pcall(function() BoostRemote:FireServer("ApplyBoost", uuid) end)
 task.wait(0.1)
 pcall(function()
 local t = Character:FindFirstChildWhichIsA("Tool")
 if t and CS:HasTag(t, "PetBoost") then t.Parent = Backpack end
 end)
 task.wait(0.5)
 local result = hasBoostApplied(uuid, statName, petModelName)
 equipState.GlobalBoostApplying = false
 return result
end

pcall(function() CoreGui:FindFirstChild("HydraHubUI"):Destroy() end)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HydraHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local viewport = workspace.CurrentCamera.ViewportSize
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local guiW, guiH = 420, 320
local guiScale = 1
if isMobile then
 guiScale = math.clamp((viewport.X / 420) * 0.72, 0.65, 1.4)
end

local mainFrame = UI:frame(ScreenGui, UDim2.new(0, guiW, 0, guiH),
 UDim2.new(0.5, -math.floor(guiW/2), 0.5, -math.floor(guiH/2)), T.BG)
mainFrame.Active = true
UI:corner(mainFrame, 8); UI:stroke(mainFrame, T.ACCENT, 1)
if isMobile and guiScale ~= 1 then
 local scale = Instance.new("UIScale", mainFrame); scale.Scale = guiScale
end

-- TOP BAR
local topBar = UI:frame(mainFrame, UDim2.new(1,0,0,30), nil, T.PANEL)
UI:corner(topBar, 8); UI:stroke(topBar, T.STROKE, 1)
local logo = Instance.new("ImageLabel", topBar)
logo.Size = UDim2.new(0,16,0,16); logo.Position = UDim2.new(0,6,0.5,-8)
logo.BackgroundTransparency = 1
logo.Image = "rbxthumb://type=Asset&id=5669312251&w=150&h=150"
logo.ScaleType = Enum.ScaleType.Fit
UI:label(topBar, "|", UDim2.new(0,8,1,0), UDim2.new(0,24,0,0), T.DIM, 13, Enum.TextXAlignment.Center)
UI:label(topBar, "HYDRA HUB", UDim2.new(1,-80,1,0), UDim2.new(0,34,0,0), T.TEXT, 12)
local closeBtn = UI:button(topBar, "X", UDim2.new(0,24,0,22), UDim2.new(1,-28,0.5,-11), T.ERROR, T.TEXT, 10)
UI:stroke(closeBtn, T.ERROR, 1)
local minimizeBtn = UI:button(topBar, "-", UDim2.new(0,24,0,22), UDim2.new(1,-56,0.5,-11), T.BTN, T.TEXT, 16)
UI:stroke(minimizeBtn, T.STROKE, 1)
isKGRunning = false
closeBtn.MouseButton1Click:Connect(function() isKGRunning = false; ScreenGui:Destroy() end)

-- DRAG
do
 local dragging, dragStart, startPos, startFrame = false, nil, nil, nil
 topBar.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true; dragStart = input; startPos = input.Position; startFrame = mainFrame.Position
 input.Changed:Connect(function()
 if input.UserInputState == Enum.UserInputState.End then dragging = false end
 end)
 end
 end)
 topBar.InputChanged:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
 dragStart = input
 end
 end)
 UIS.InputChanged:Connect(function(input)
 if not dragging or input ~= dragStart then return end
 local delta = input.Position - startPos
 mainFrame.Position = UDim2.new(startFrame.X.Scale, startFrame.X.Offset + delta.X,
 startFrame.Y.Scale, startFrame.Y.Offset + delta.Y)
 end)
end

local tabBar = UI:frame(mainFrame, UDim2.new(1,0,0,28), UDim2.new(0,0,0,30), T.PANEL)
UI:stroke(tabBar, T.STROKE, 1)
local tabNames = {"HATCH", "LEVELING", "TEAMS", "ELEPHANT", "MISC"}
local tabBtns = {}
local tabPages = {}
local contentFrame = UI:frame(mainFrame, UDim2.new(1,0,1,-58), UDim2.new(0,0,0,58), T.BG, 1)
for i = 1, #tabNames do
 local page = UI:frame(contentFrame, UDim2.new(1,0,1,0), nil, T.BG, 1)
 tabPages[i] = page
end

local tabWidth = math.floor(guiW / #tabNames)
for idx, name in ipairs(tabNames) do
 local btn = UI:button(tabBar, name, UDim2.new(0, tabWidth - 2, 0, 22),
 UDim2.new(0, ((idx-1) * tabWidth) + 1, 0.5, -11),
 (idx == 1 and Color3.fromRGB(20,20,20)) or T.BTN,
 (idx == 1 and T.ACCENT) or T.DIM, 8)
 UI:stroke(btn, T.STROKE, 1)
 tabBtns[idx] = btn
 btn.MouseButton1Click:Connect(function()
 for i2, page in ipairs(tabPages) do
 page.Visible = (i2 == idx)
 tabBtns[i2].BackgroundColor3 = (i2 == idx and Color3.fromRGB(20,20,20)) or T.BTN
 tabBtns[i2].TextColor3 = (i2 == idx and T.ACCENT) or T.DIM
 end
 end)
end

-- PAGE REFERENCES (used by elephant/misc sections)
local PageHatch = tabPages[1]
local PageLeveling = tabPages[2]
local PageTeams = tabPages[3]
local PageElephant = tabPages[4]
local PageMisc = tabPages[5]

-- ============================================================
do
 local hScroll = UI:scroll(PageHatch, UDim2.new(1,0,1,0))
 hScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 hScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
 hScroll.ScrollBarThickness = 3
 hScroll.ScrollBarImageColor3 = T.ACCENT
 UI:list(hScroll, 5)
 UI:pad(hScroll, 4,4,4,4)

 local function makeTeamDD(parent, label, configKey, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,40), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,0,0,14), UDim2.new(0,0,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 local btn = UI:button(row, cfg.autoHatch[configKey] or "None selected",
 UDim2.new(1,-20,0,16), UDim2.new(0,0,1,-18), T.BTN, T.DIM, 8)
 btn.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(btn, 0,8,0,0); UI:stroke(btn, T.STROKE, 1)
 UI:label(row, "v", UDim2.new(0,20,0,16), UDim2.new(1,-20,1,-18), T.DIM, 8, Enum.TextXAlignment.Center)
 local listFrame = UI:frame(parent, UDim2.new(1,0,0,0), nil, T.BG, order + 1)
 listFrame.Visible = false; listFrame.AutomaticSize = Enum.AutomaticSize.Y
 UI:corner(listFrame, 5); UI:stroke(listFrame, T.STROKE, 1)
 local sf = UI:scroll(listFrame, UDim2.new(1,0,0,130))
 UI:list(sf, 2); UI:pad(sf, 2,2,2,2)
 local isOpen = false
 btn.MouseButton1Click:Connect(function()
 isOpen = not isOpen; listFrame.Visible = isOpen
 if isOpen then
 buildTeamDD(sf, function(name)
 cfg.autoHatch[configKey] = name; saveConfig(); btn.Text = name
 listFrame.Visible = false; isOpen = false
 end, cfg.autoHatch[configKey], UI, cfg, T)
 listFrame.Size = UDim2.new(1,0,0, math.min((buildTeamDD(sf, function() end, cfg.autoHatch[configKey], UI, cfg, T) * 24) + 6, 130))
 end
 end)
 return btn
 end

 local function makeNumInput(parent, label, configKey, defaultVal, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,26), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,-72,1,0), UDim2.new(0,6,0,0), T.DIM, 9).Font = Enum.Font.Gotham
 local inp = UI:input(row, tostring(cfg.autoHatch[configKey] or defaultVal), "",
 UDim2.new(0,64,0,20), UDim2.new(1,-68,0.5,-10))
 inp.FocusLost:Connect(function()
 local val = tonumber(inp.Text)
 if val and val >= 0 then cfg.autoHatch[configKey] = val; saveConfig()
 else inp.Text = tostring(cfg.autoHatch[configKey] or defaultVal) end
 end)
 return inp
 end

 -- ======================== AUTO HATCH ACCORDION ========================
 local hatchAcc = UI:accordion(hScroll, "AUTO HATCH", 1, true)
 local hatchInner = hatchAcc.Inner

 local eggList = {}
 local seen = {}
 for _, pet in ipairs(PetJSON) do
 if pet.egg and not seen[pet.egg] then
 seen[pet.egg] = true
 table.insert(eggList, {key = pet.egg, name = pet.egg})
 end
 end
 table.sort(eggList, function(a,b) return a.name < b.name end)

 local eggLbl = UI:label(hatchInner, "Egg", UDim2.new(1,0,0,14), nil, T.DIM, 9)
 eggLbl.Font = Enum.Font.Gotham; eggLbl.LayoutOrder = 1
 local eggRow = UI:frame(hatchInner, UDim2.new(1,0,0,26), nil, T.BTN, 2)
 UI:corner(eggRow, 5); UI:stroke(eggRow, T.STROKE, 1)
 local eggBtn = UI:button(eggRow, cfg.autoHatch.eggName or "Common Egg",
 UDim2.new(1,-20,1,0), UDim2.new(0,0,0,0), T.BTN, T.TEXT, 9)
 eggBtn.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(eggBtn, 0,8,0,0); UI:stroke(eggBtn, T.STROKE, 1)
 UI:label(eggRow, "v", UDim2.new(0,20,1,0), UDim2.new(1,-20,0,0), T.DIM, 9, Enum.TextXAlignment.Center)
 local eggListFrame = UI:frame(hatchInner, UDim2.new(1,0,0,0), nil, T.BG, 3)
 eggListFrame.Visible = false; eggListFrame.AutomaticSize = Enum.AutomaticSize.Y
 UI:corner(eggListFrame, 5); UI:stroke(eggListFrame, T.STROKE, 1)
 local eggSF = UI:scroll(eggListFrame, UDim2.new(1,0,0,130))
 UI:list(eggSF, 2); UI:pad(eggSF, 2,2,2,2)
 local eggOpen = false
 eggBtn.MouseButton1Click:Connect(function()
 eggOpen = not eggOpen; eggListFrame.Visible = eggOpen
 if eggOpen then
 for _, c in ipairs(eggSF:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 for i, egg in ipairs(eggList) do
 local isSel = cfg.autoHatch.eggName == egg.key
 local b = UI:button(eggSF, egg.name, UDim2.new(1,0,0,22), nil,
 (isSel and T.SEL_BG) or Color3.fromRGB(14,14,14),
 (isSel and T.SEL_TXT) or T.TEXT, 9)
 b.LayoutOrder = i; b.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(b, 0,8,0,0); UI:stroke(b, (isSel and T.ACCENT) or T.STROKE, 1)
 b.MouseButton1Click:Connect(function()
 cfg.autoHatch.eggName = egg.key; saveConfig(); eggBtn.Text = egg.name
 eggListFrame.Visible = false; eggOpen = false
 end)
 end
 eggListFrame.Size = UDim2.new(1,0,0, math.min((#eggList * 24) + 6, 130))
 end
 end)

 makeNumInput(hatchInner, "Egg Count", "eggCount", 13, 5)
 makeNumInput(hatchInner, "Egg Spacing", "eggSpacing", 7, 7)

 makeTeamDD(hatchInner, "CD Team (Reduce cooldown)", "teamCD", 10)
 makeTeamDD(hatchInner, "Koi Team", "teamKoi", 13)
 makeTeamDD(hatchInner, "Seal Team (Sell)", "teamSeal", 16)
 makeTeamDD(hatchInner, "Bronto Team (Heavy hatch)", "teamBronto", 19)

 makeNumInput(hatchInner, "Bronto threshold (kg)", "brontoThresh", 4, 22)

 local espRow = UI:frame(hatchInner, UDim2.new(1,0,0,26), nil, T.BTN, 25)
 UI:corner(espRow, 5); UI:stroke(espRow, T.STROKE, 1)
 UI:label(espRow, "Egg ESP", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 UI:toggle(espRow, UDim2.new(1,-48,0.5,-11), cfg.autoHatch.espEnabled,
 function(val) cfg.autoHatch.espEnabled = val; saveConfig() end)

 local asfRow = UI:frame(hatchInner, UDim2.new(1,0,0,26), nil, T.BTN, 28)
 UI:corner(asfRow, 5); UI:stroke(asfRow, T.STROKE, 1)
 UI:label(asfRow, "Auto Sell When Full", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 UI:toggle(asfRow, UDim2.new(1,-48,0.5,-11), cfg.autoHatch.autoSellWhenFull,
 function(val) cfg.autoHatch.autoSellWhenFull = val; saveConfig() end)

 makeNumInput(hatchInner, "Pet Inv Max", "petInvMax", 200, 31)

 local statusRow = UI:frame(hatchInner, UDim2.new(1,0,0,26), nil, T.DARK_CARD, 50)
 UI:corner(statusRow, 5); UI:stroke(statusRow, T.STROKE, 1)
 UI:label(statusRow, "AUTO HATCH", UDim2.new(0,120,1,0), UDim2.new(0,8,0,0), T.TEXT, 10).Font = Enum.Font.GothamBold
 local statusLbl = UI:label(statusRow, "IDLE", UDim2.new(1,-180,1,0), UDim2.new(0,124,0,0), T.DIM, 9)
 statusLbl.Font = Enum.Font.Gotham; statusLbl.TextTruncate = Enum.TextTruncate.AtEnd

 local startBtn = UI:button(statusRow, "START", UDim2.new(0,84,0,20), UDim2.new(1,-86,0.5,-10), T.BTN, T.ACCENT, 9)
 UI:stroke(startBtn, T.STROKE, 1)

 local logSF = UI:scroll(hatchInner, UDim2.new(1,0,0,80), nil, 51)
 UI:list(logSF, 2); UI:pad(logSF, 2,4,4,2)
 local function addLog(text, color)
 local l = UI:label(logSF, text, UDim2.new(1,0,0,16), nil, color or T.DIM, 8)
 l.TextXAlignment = Enum.TextXAlignment.Left
 l.AutomaticSize = Enum.AutomaticSize.Y
 end
 addLog("Auto Hatch ready!", T.SUCCESS)

 -- ======================== SELL SETTINGS ACCORDION ========================
 local sellAcc = UI:accordion(hScroll, "SELL SETTINGS", 2, true)
 local sellInner = sellAcc.Inner

 makeNumInput(sellInner, "Sell below (kg)", "sellThreshold", 0, 3)
 makeNumInput(sellInner, "Fav delay (sec)", "favDelay", 0.1, 5)

 local sellRow = UI:frame(sellInner, UDim2.new(1,0,0,26), nil, T.BTN, 7)
 UI:corner(sellRow, 5); UI:stroke(sellRow, T.STROKE, 1)
 local sellCount = 0
 for _ in pairs(cfg.autoHatch.sellPets or {}) do sellCount = sellCount + 1 end
 local sellLbl = UI:label(sellRow, "Sell pets: " .. (sellCount == 0 and "NONE" or sellCount .. " selected"),
 UDim2.new(1,-100,1,0), UDim2.new(0,6,0,0), T.DIM, 9)
 sellLbl.Font = Enum.Font.Gotham
 local sellSelBtn = UI:button(sellRow, "Select pets >", UDim2.new(0,90,0,20),
 UDim2.new(1,-94,0.5,-10), T.BTN, T.ACCENT, 9)
 UI:stroke(sellSelBtn, T.STROKE, 1)

 local function refreshSellCount()
 sellCount = 0; for _ in pairs(cfg.autoHatch.sellPets or {}) do sellCount = sellCount + 1 end
 sellLbl.Text = sellCount == 0 and "Sell pets: NONE" or ("Sell pets: " .. sellCount .. " selected")
 sellLbl.TextColor3 = sellCount == 0 and T.DIM or T.ACCENT
 end

 local sellOverlay = UI:frame(PageHatch, UDim2.new(1,0,1,0), nil, T.BG)
 sellOverlay.Visible = false; sellOverlay.ZIndex = 25
 local soBar = UI:frame(sellOverlay, UDim2.new(1,0,0,26), nil, T.PANEL)
 UI:stroke(soBar, T.STROKE, 1)
 UI:label(soBar, "Select pets to SELL", UDim2.new(1,-96,1,0), UDim2.new(0,8,0,0), T.ACCENT, 10)
 local soSelAll = UI:button(soBar, "Select All", UDim2.new(0,64,0,20), UDim2.new(1,-92,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(soSelAll, T.STROKE, 1)
 local soClose = UI:button(soBar, "X", UDim2.new(0,24,0,20), UDim2.new(1,-28,0.5,-10), T.ERROR, T.TEXT, 10)
 UI:stroke(soClose, T.ERROR, 1)
 soClose.MouseButton1Click:Connect(function() sellOverlay.Visible = false; refreshSellCount() end)
 local soSearch = UI:input(sellOverlay, "", "Search pet or egg...",
 UDim2.new(1,-8,0,22), UDim2.new(0,4,0,28))
 soSearch.TextColor3 = T.TEXT; soSearch.Font = Enum.Font.Gotham
 local soSF = UI:scroll(sellOverlay, UDim2.new(1,0,1,-56), UDim2.new(0,0,0,54))
 UI:list(soSF, 3); UI:pad(soSF, 3,4,4,3)

 local function getFilteredPets()
 local q = string.lower(soSearch.Text)
 local result = {}
 for _, pet in ipairs(PetJSON) do
 if q == "" or pet.name:lower():find(q,1,true) or (pet.egg or ""):lower():find(q,1,true) then
 table.insert(result, pet)
 end
 end
 return result
 end

 local function rebuildSellOverlay()
 for _, c in ipairs(soSF:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 local filtered = getFilteredPets()
 local allSelected = #filtered > 0
 for _, pet in ipairs(filtered) do
 if not (cfg.autoHatch.sellPets or {})[pet.name] then allSelected = false; break end
 end
 soSelAll.Text = #filtered == 0 and "Select All" or (allSelected and "Unselect All" or "Select All")
 for i, pet in ipairs(filtered) do
 local isSel = (cfg.autoHatch.sellPets or {})[pet.name] == true
 local b = UI:button(soSF, pet.name, UDim2.new(1,0,0,30), nil,
 (isSel and T.SEL_BG) or Color3.fromRGB(13,13,13),
 (isSel and T.SEL_TXT) or T.TEXT, 10)
 b.LayoutOrder = i; b.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(b, 0,8,4,0); UI:corner(b, 5)
 UI:stroke(b, (isSel and T.ACCENT) or T.STROKE, 1)
 local sub = UI:label(b, pet.egg or "", UDim2.new(1,-8,0,12), UDim2.new(0,8,1,-13),
 (isSel and Color3.fromRGB(60,40,0)) or T.DIM, 8)
 sub.Font = Enum.Font.Gotham
 b.MouseButton1Click:Connect(function()
 if not cfg.autoHatch.sellPets then cfg.autoHatch.sellPets = {} end
 if cfg.autoHatch.sellPets[pet.name] then cfg.autoHatch.sellPets[pet.name] = nil
 else cfg.autoHatch.sellPets[pet.name] = true end
 saveConfig(); refreshSellCount(); rebuildSellOverlay()
 end)
 end
 end

 soSelAll.MouseButton1Click:Connect(function()
 if not cfg.autoHatch.sellPets then cfg.autoHatch.sellPets = {} end
 local filtered = getFilteredPets()
 local allSel = true
 for _, pet in ipairs(filtered) do
 if not cfg.autoHatch.sellPets[pet.name] then allSel = false; break end
 end
 for _, pet in ipairs(filtered) do
 cfg.autoHatch.sellPets[pet.name] = allSel and nil or true
 end
 saveConfig(); refreshSellCount(); rebuildSellOverlay()
 end)
 soSearch:GetPropertyChangedSignal("Text"):Connect(rebuildSellOverlay)
 sellSelBtn.MouseButton1Click:Connect(function() sellOverlay.Visible = true; rebuildSellOverlay() end)

 local hatchRunning = false
 local hatchThread = nil

 local function placeEggs(eggName, count, spacing)
 local function getFarmCF2()
 local farm = workspace:FindFirstChild("Farm")
 if farm then
 local myPlot = farm:FindFirstChild(LocalPlayer.Name)
 if myPlot then
 local imp = myPlot:FindFirstChild("Important")
 if imp then
 local pl = imp:FindFirstChild("Plant_Locations")
 if pl then
 local ch = pl:GetChildren()
 if #ch > 0 then return ch[1]:GetPivot() end
 end
 end
 end
 end
 return Character and Character:GetPivot() or CFrame.new(0,5,0)
 end
 local cf = getFarmCF2()
 local placed = 0
 for _, tool in ipairs(Backpack:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetEggTool") then
 if tool:GetAttribute("h") == eggName or eggName == "*" then
 if placed >= count then break end
 tool.Parent = Character
 task.wait(0.05)
 pcall(function() PetsRemote:FireServer("PlaceEgg", tool, cf + CFrame.new(placed * spacing, 0, 0)) end)
 placed = placed + 1
 task.wait(0.1)
 end
 end
 end
 return placed
 end

 local function countEggs(eggName)
 local n = 0
 for _, tool in ipairs(Backpack:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetEggTool") then
 if tool:GetAttribute("h") == eggName then
 n = n + (tonumber(tool.Name:match("x(%d+)$")) or 1)
 end
 end
 end
 return n
 end

 local function hatchAllEggs()
 for _, obj in ipairs(CollectionService:GetTagged("PetEggServer")) do
 if obj:GetAttribute("OWNER") == LocalPlayer.Name then
 local tt = obj:GetAttribute("TimeToHatch") or 0
 if tt <= 0 then
 pcall(function() PetsRemote:FireServer("HatchPet", obj) end)
 end
 end
 end
 end

 local function sellAllPets()
 pcall(function() SellAllRemote:FireServer() end)
 end

 local function favAllPets(delay)
 for _, tool in ipairs(Character:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetEggTool") then
 elseif tool:IsA("Tool") then
 pcall(function() FavRemote:FireServer("Favorite", tool) end)
 task.wait(delay or 0.1)
 end
 end
 end

 local function wearTeam(teamName)
 if not teamName then return end
 local uuids = getTeamUUIDs(teamName)
 if #uuids == 0 then return end
 unequipAll()
 task.wait(0.1)
 local cf = getFarmCF()
 for _, uuid in ipairs(uuids) do
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 end

 local function runHatchCycle(statusFn, logFn)
 local a = cfg.autoHatch
 if a.teamCD then logFn("Wearing CD team...", T.DIM); wearTeam(a.teamCD) end
 logFn("Placing eggs...", T.ACCENT)
 local placed = placeEggs(a.eggName, a.eggCount, a.eggSpacing)
 if placed == 0 then logFn("No eggs to place!", T.ERROR); return end
 logFn(string.format("Placed %d eggs, waiting for hatch...", placed), T.ACCENT)

 local timeout = os.clock() + 120
 while os.clock() < timeout do
 local allReady = true
 for _, obj in ipairs(CollectionService:GetTagged("PetEggServer")) do
 if obj:GetAttribute("OWNER") == LocalPlayer.Name then
 if (obj:GetAttribute("TimeToHatch") or 0) > 0 then allReady = false; break end
 end
 end
 if allReady then break end
 task.wait(1)
 end

 if a.teamKoi then
 logFn(string.format("Koi mode  equipping koi team..."), T.ACCENT)
 wearTeam(a.teamKoi)
 task.wait(1)
 end

 hatchAllEggs()
 task.wait(0.5)

 if a.teamSeal then
 logFn("Seal mode  sell all pets...", T.ACCENT)
 wearTeam(a.teamSeal)
 task.wait(2)
 sellAllPets()
 task.wait(1)
 elseif a.sellPets and next(a.sellPets) then
 logFn("Selective sell...", T.DIM)
 sellAllPets()
 task.wait(1)
 end

 if a.favDelay and a.favDelay > 0 then
 favAllPets(a.favDelay)
 end

 if a.autoSellWhenFull then
 local inv = getInventory()
 local count = 0
 for _ in pairs(inv) do count = count + 1 end
 if count >= (a.petInvMax or 200) then
 logFn("Inventory full  selling all...", T.ERROR)
 sellAllPets()
 task.wait(2)
 end
 end
 end

 startBtn.MouseButton1Click:Connect(function()
 if hatchRunning then
 hatchRunning = false
 startBtn.Text = "START"
 startBtn.BackgroundColor3 = T.BTN
 statusLbl.Text = "STOPPED"
 statusLbl.TextColor3 = T.ERROR
 addLog("Stopped by user", T.ERROR)
 return
 end
 hatchRunning = true
 startBtn.Text = "STOP"
 startBtn.BackgroundColor3 = T.ERROR
 statusLbl.Text = "RUNNING"
 statusLbl.TextColor3 = T.SUCCESS
 addLog("=== AUTO HATCH START ===", T.ACCENT)

 hatchThread = task.spawn(function()
 local cycle = 0
 while hatchRunning do
 cycle = cycle + 1
 statusLbl.Text = "Cycle " .. cycle
 statusLbl.TextColor3 = T.SUCCESS
 addLog(string.format("--- Cycle %d ---", cycle), T.ACCENT)
 local ok, err = pcall(runHatchCycle, function(t,c) statusLbl.Text = t; statusLbl.TextColor3 = c end, addLog)
 if not ok then addLog("Error: " .. tostring(err), T.ERROR) end
 if not hatchRunning then break end
 task.wait(1)
 end
 addLog("--- Stopped ---", T.ERROR)
 statusLbl.Text = "IDLE"
 statusLbl.TextColor3 = T.DIM
 startBtn.Text = "START"
 startBtn.BackgroundColor3 = T.BTN
 hatchRunning = false
 end)
 end)
end

-- ============================================================
do
 local lvScroll = UI:scroll(PageLeveling, UDim2.new(1,0,1,0))
 lvScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 lvScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
 lvScroll.ScrollBarThickness = 3
 lvScroll.ScrollBarImageColor3 = T.ACCENT
 UI:list(lvScroll, 5)
 UI:pad(lvScroll, 4,4,4,4)

 _G.HH_Shared = {
 V = UI, T = T, D = cfg, CFG = TIMING,
 Player = LocalPlayer, Backpack = Backpack, Char = Character,
 MUTATION_MAP = MutJSON,
 saveD = saveConfig,
 getInv = getInventory, getKG = getKG, getAge = getAge, getBase = getBase,
 getPType = getPType, isFav = isFav, findPetTool = findPetTool,
 getMutName = getMutName,
 unequipAll = unequipAll, equipList = equipList,
 buildEquip = buildEquip, waitUntilEquipped = waitUntilEquipped,
 getActivePets = getActivePets, getFarmCF = getFarmCF,
 PetsRemote = PetsRemote, FavRemote = FavRemote,
 SellAllRemote = SellAllRemote, DataService = DataService,
 htTrack = htTrack,
 outerScroll = lvScroll, PageLeveling = PageLeveling,
 _buildTeamDD = buildTeamDD, getTeamUUIDs = getTeamUUIDs,
 }

 task.spawn(function()
 local ok, err = pcall(function()
 loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=leveling", true))()
 end)
 if not ok then warn("[HydraLite] Leveling module: " .. tostring(err))
 else
 task.wait(0.5)
 pcall(function()
 loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=nightmare", true))()
 end)
 end
 end)
end

-- ============================================================
do
 local tmScroll = UI:scroll(PageTeams, UDim2.new(1,0,1,0))
 tmScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 tmScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
 tmScroll.ScrollBarThickness = 3
 tmScroll.ScrollBarImageColor3 = T.ACCENT
 UI:list(tmScroll, 5)
 UI:pad(tmScroll, 4,4,4,4)

 local title = UI:label(tmScroll, "Pet Teams", UDim2.new(1,0,0,16), nil, T.ACCENT, 11)
 title.LayoutOrder = 0

 local saveRow = UI:frame(tmScroll, UDim2.new(1,0,0,26), nil, T.BG, 1)
 local teamNameInput = UI:input(saveRow, "", "Team name...",
 UDim2.new(1,-86,0,20), UDim2.new(0,0,0,2))
 teamNameInput.TextColor3 = T.TEXT
 local saveBtn = UI:button(saveRow, "Save Active Pets", UDim2.new(0,82,0,20),
 UDim2.new(1,-84,0,2), T.ACCENT, T.SEL_TXT, 8)
 UI:stroke(saveBtn, T.ACCENT, 1)

 local savedLbl = UI:label(tmScroll, "Saved Teams", UDim2.new(1,0,0,14), nil, T.DIM, 9)
 savedLbl.Font = Enum.Font.Gotham; savedLbl.LayoutOrder = 2

 local teamsContainer = UI:frame(tmScroll, UDim2.new(1,0,0,0), nil, T.BG, 3)
 teamsContainer.AutomaticSize = Enum.AutomaticSize.Y
 UI:list(teamsContainer, 4)

 local ddRefs = {}

 local function rebuildTeams()
 for _, c in ipairs(teamsContainer:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end

 if _G._NH_BUILTIN_TEAMS then
 for i, team in ipairs(_G._NH_BUILTIN_TEAMS) do
 local card = UI:frame(teamsContainer, UDim2.new(1,0,0,44), nil, Color3.fromRGB(30,20,60), -100+i)
 UI:corner(card, 6); UI:stroke(card, Color3.fromRGB(80,60,160), 1)
 UI:label(card, team.name, UDim2.new(1,-90,0,14), UDim2.new(0,8,0,2), Color3.fromRGB(180,160,255), 9).Font = Enum.Font.GothamBold
 UI:label(card, team.desc, UDim2.new(1,-90,0,12), UDim2.new(0,8,0,16), T.DIM, 7).Font = Enum.Font.Gotham
 local equipBtn = UI:button(card, "Equip", UDim2.new(0,70,0,20), UDim2.new(1,-78,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(equipBtn, T.STROKE, 1)
 local slots = team.slots
 equipBtn.MouseButton1Click:Connect(function()
 task.spawn(function()
 local uuids = getTeamUUIDs(team.name)
 if #uuids == 0 then return end
 unequipAll()
 task.wait(0.1)
 local cf = getFarmCF()
 for _, uuid in ipairs(uuids) do
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 end)
 end)
 end
 end

 local teamNames = {}
 for name in pairs(cfg.petTeams) do table.insert(teamNames, name) end
 table.sort(teamNames)

 if #teamNames == 0 then
 local lbl = UI:label(teamsContainer, "(no teams saved)", UDim2.new(1,0,0,20), nil, T.TEXT, 9)
 lbl.Font = Enum.Font.Gotham; lbl.LayoutOrder = 1
 return
 end

 for i, name in ipairs(teamNames) do
 local teamData = cfg.petTeams[name]
 local inv = getInventory()
 local petNames = {}
 for _, uuid in ipairs(teamData.uuids or {}) do
 local pet = inv[uuid]
 if pet and pet.PetType then
 local mut = (pet.PetData and pet.PetData.MutationType) or ""
 local mutName = (mut ~= "" and mut ~= "m" and MutJSON[mut] or "") or ""
 local display = mutName ~= "" and (pet.PetType .. " [" .. mutName .. "]") or pet.PetType
 table.insert(petNames, display)
 end
 end
 if #petNames == 0 then petNames = {"(empty)"} end

 local card = UI:frame(teamsContainer, UDim2.new(1,0,0,50), nil, T.BTN, i)
 UI:corner(card, 6); UI:stroke(card, T.STROKE, 1)
 UI:label(card, name, UDim2.new(1,-160,0,14), UDim2.new(0,8,0,2), T.TEXT, 9).Font = Enum.Font.GothamBold
 UI:label(card, table.concat(petNames, ", "), UDim2.new(1,-160,0,12), UDim2.new(0,8,0,16), T.DIM, 7)
 .Font = Enum.Font.Gotham
 UI:label(card, #petNames .. " pets", UDim2.new(0,40,0,12), UDim2.new(0,8,0,30), T.DIM, 7).Font = Enum.Font.Gotham

 local equipBtn = UI:button(card, "Equip", UDim2.new(0,60,0,20), UDim2.new(1,-148,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(equipBtn, T.STROKE, 1)
 local delBtn = UI:button(card, "X", UDim2.new(0,24,0,20), UDim2.new(1,-82,0.5,-10), T.ERROR, T.TEXT, 9)
 UI:stroke(delBtn, T.ERROR, 1)

 equipBtn.MouseButton1Click:Connect(function()
 task.spawn(function()
 local active = getActivePets()
 local uuids = teamData.uuids or {}
 local allActive = true
 for _, uuid in ipairs(uuids) do
 local found = false
 for _, a in ipairs(active) do if a == uuid then found = true; break end end
 if not found then allActive = false; break end
 end
 if allActive and #uuids > 0 then
 for _, uuid in ipairs(uuids) do
 pcall(function() PetsRemote:FireServer("UnequipPet", uuid) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 else
 unequipAll()
 task.wait(0.1)
 local cf = getFarmCF()
 for _, uuid in ipairs(uuids) do
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 end
 end)
 end)

 delBtn.MouseButton1Click:Connect(function()
 cfg.petTeams[name] = nil
 if cfg.leveling.mainTeam == name then cfg.leveling.mainTeam = nil end
 if cfg.leveling.optTeam == name then cfg.leveling.optTeam = nil end
 if cfg.elephant.levelingTeam == name then cfg.elephant.levelingTeam = nil end
 if cfg.elephant.elephantTeam == name then cfg.elephant.elephantTeam = nil end
 if cfg.elephant.phase2Team == name then cfg.elephant.phase2Team = nil end
 saveConfig(); rebuildTeams()
 for _, ref in ipairs(ddRefs) do pcall(function() ref.Refresh() end) end
 end)
 end
 end

 saveBtn.MouseButton1Click:Connect(function()
 local name = teamNameInput.Text
 if name == "" then name = "Team_" .. (os.time() % 10000) end
 local active = getActivePets()
 if #active == 0 then return end
 cfg.petTeams[name] = {uuids = active}
 saveConfig(); rebuildTeams()
 teamNameInput.Text = ""
 for _, ref in ipairs(ddRefs) do pcall(function() ref.Refresh() end) end
 end)

 _G._NH_BUILTIN_TEAMS = _G._NH_BUILTIN_TEAMS or builtInTeams
 _G._NH_rebuildTeams = rebuildTeams
 _G._NH_ddRefs = ddRefs
 rebuildTeams()
end

-- ============================================================

-- ============================================================
do
 local eleScroll = UI:scroll(PageElephant, UDim2.new(1,0,1,0))
 eleScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 eleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
 eleScroll.ScrollBarThickness = 3
 eleScroll.ScrollBarImageColor3 = T.ACCENT
 UI:list(eleScroll, 5)
 UI:pad(eleScroll, 4,4,4,4)

 local function makeTeamDD(parent, label, configKey, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,40), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,0,0,14), UDim2.new(0,0,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 local btn = UI:button(row, cfg.elephant[configKey] or "None selected",
 UDim2.new(1,-20,0,16), UDim2.new(0,0,1,-18), T.BTN, T.DIM, 8)
 btn.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(btn, 0,8,0,0)
 UI:stroke(btn, T.STROKE, 1)
 UI:label(row, "v", UDim2.new(0,20,0,16), UDim2.new(1,-20,1,-18), T.DIM, 8, Enum.TextXAlignment.Center)
 local listFrame = UI:frame(parent, UDim2.new(1,0,0,0), nil, T.BG, order + 1)
 listFrame.Visible = false; listFrame.AutomaticSize = Enum.AutomaticSize.Y
 UI:corner(listFrame, 5); UI:stroke(listFrame, T.STROKE, 1)
 local sf = UI:scroll(listFrame, UDim2.new(1,0,0,130))
 UI:list(sf, 2); UI:pad(sf, 2,2,2,2)
 local isOpen = false
 btn.MouseButton1Click:Connect(function()
 isOpen = not isOpen
 listFrame.Visible = isOpen
 if isOpen then
 buildTeamDD(sf, function(name)
 cfg.elephant[configKey] = name; saveConfig(); btn.Text = name
 listFrame.Visible = false; isOpen = false
 end, cfg.elephant[configKey], UI, cfg, T)
 end
 end)
 return btn
 end

 local function makeNumInput(parent, label, configKey, defaultVal, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,26), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,-72,1,0), UDim2.new(0,6,0,0), T.DIM, 9).Font = Enum.Font.Gotham
 local inp = UI:input(row, tostring(cfg.elephant[configKey] or defaultVal), "",
 UDim2.new(0,64,0,20), UDim2.new(1,-68,0.5,-10))
 inp.FocusLost:Connect(function()
 local val = tonumber(inp.Text)
 if val and val > 0 then cfg.elephant[configKey] = val; saveConfig()
 else inp.Text = tostring(cfg.elephant[configKey] or defaultVal) end
 end)
 return inp
 end

 local function makeToggle(parent, label, configKey, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,26), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.Gotham
 UI:toggle(row, UDim2.new(1,-48,0.5,-11), cfg.elephant[configKey] or false,
 function(val) cfg.elephant[configKey] = val; saveConfig() end)
 return row
 end

 local function makeModeRow(parent, label, configKey, optA, optB, order)
 local row = UI:frame(parent, UDim2.new(1,0,0,26), nil, T.BTN, order)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, label, UDim2.new(1,-120,1,0), UDim2.new(0,6,0,0), T.DIM, 9).Font = Enum.Font.Gotham
 local btnA = UI:button(row, optA.name, UDim2.new(0,56,0,20), UDim2.new(1,-118,0.5,-10), T.BTN, T.DIM, 8)
 UI:stroke(btnA, T.STROKE, 1)
 local btnB = UI:button(row, optB.name, UDim2.new(0,56,0,20), UDim2.new(1,-58,0.5,-10), T.BTN, T.DIM, 8)
 UI:stroke(btnB, T.STROKE, 1)
 local function refresh()
 local cur = cfg.elephant[configKey]
 if cur == optA.key then
 btnA.BackgroundColor3 = T.SEL_BG; btnA.TextColor3 = T.SEL_TXT; UI:stroke(btnA, T.ACCENT, 1)
 btnB.BackgroundColor3 = T.BTN; btnB.TextColor3 = T.DIM; UI:stroke(btnB, T.STROKE, 1)
 else
 btnB.BackgroundColor3 = T.SEL_BG; btnB.TextColor3 = T.SEL_TXT; UI:stroke(btnB, T.ACCENT, 1)
 btnA.BackgroundColor3 = T.BTN; btnA.TextColor3 = T.DIM; UI:stroke(btnA, T.STROKE, 1)
 end
 end
 btnA.MouseButton1Click:Connect(function() cfg.elephant[configKey] = optA.key; saveConfig(); refresh() end)
 btnB.MouseButton1Click:Connect(function() cfg.elephant[configKey] = optB.key; saveConfig(); refresh() end)
 refresh()
 return row
 end

 local eleAcc = UI:accordion(eleScroll, "AUTO ELEPHANT", 1, true)
 local eleInner = eleAcc.Inner

 makeTeamDD(eleInner, "Pet team for leveling 1-50", "levelingTeam", 10)
 makeTeamDD(eleInner, "Team for elephant", "elephantTeam", 20)
 makeTeamDD(eleInner, "Phase 2 team (after target weight)", "phase2Team", 30)
 makeToggle(eleInner, "Enable Phase 2 (after level threshold)", "phase2Enabled", 40)
 makeNumInput(eleInner, "Use Phase 2 from level", "phase2Threshold", 50, 50)
 makeNumInput(eleInner, "Target KG", "targetWeight", 3.5, 60)
 makeNumInput(eleInner, "Max Level (P1 switch)", "levelThreshold", 50, 70)
 makeToggle(eleInner, "Level to 100 after target weight", "levelTo100", 80)
 makeModeRow(eleInner, "Garden Slots", "gardenSlots", {key="1",name="1 Pet"}, {key="2",name="2 Pets"}, 90)
 makeModeRow(eleInner, "Garden Mode", "gardenMode", {key="A",name="All"}, {key="B",name="OneByOne"}, 100)

 -- Extra Filler Pets
 do
 local row = UI:frame(eleInner, UDim2.new(1,0,0,26), nil, T.BTN, 110)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, "Extra Filler Pets", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 UI:toggle(row, UDim2.new(1,-48,0.5,-11), cfg.elephant.useExtraPets or false,
 function(v) cfg.elephant.useExtraPets = v; saveConfig() end)
 local cnt = UI:label(row, "NONE", UDim2.new(0,50,1,0), UDim2.new(0,140,0,0), T.DIM, 9)
 cnt.Font = Enum.Font.Gotham
 local sb = UI:button(row, "Select >", UDim2.new(0,50,0,20), UDim2.new(1,-56,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(sb, T.STROKE, 1)
 local function upd() local n=0; for _ in pairs(cfg.elephant.extraPets) do n=n+1 end
 cnt.Text = n==0 and "NONE" or (n.." sel"); cnt.TextColor3 = n==0 and T.DIM or T.ACCENT end
 upd()
 local ov = UI:frame(PageElephant, UDim2.new(1,0,1,0), nil, T.BG)
 ov.Visible = false; ov.ZIndex = 20
 local oh = UI:frame(ov, UDim2.new(1,0,0,26), nil, T.PANEL)
 UI:stroke(oh, T.STROKE, 1)
 UI:label(oh, "Select Extra Filler Pets", UDim2.new(1,-36,1,0), UDim2.new(0,8,0,0), T.ACCENT, 10)
 local ox = UI:button(oh, "X", UDim2.new(0,24,0,20), UDim2.new(1,-28,0.5,-10), T.ERROR, T.TEXT, 10)
 UI:stroke(ox, T.ERROR, 1)
 ox.MouseButton1Click:Connect(function() ov.Visible = false; upd() end)
 local os = UI:input(ov, "", "Search pet...", UDim2.new(1,-8,0,22), UDim2.new(0,4,0,28))
 os.TextColor3 = T.TEXT; os.Font = Enum.Font.Gotham
 local ofr = UI:scroll(ov, UDim2.new(1,0,1,-56), UDim2.new(0,0,0,54))
 UI:list(ofr, 3); UI:pad(ofr, 3,4,4,3)
 local function rebuild()
 for _, c in ipairs(ofr:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 local inv = getInventory(); local q = string.lower(os.Text)
 local us = {}; for u in pairs(inv) do table.insert(us, u) end
 table.sort(us, function(a,b) return getKG(a)>getKG(b) end)
 local n = 0
 for _, uuid in ipairs(us) do
 local pet = inv[uuid]
 if not pet then continue end
 if q~="" and not string.lower(pet.PetType or ""):find(q,1,true) then continue end
 if table.find(cfg.targets, uuid) then continue end
 local sel = cfg.elephant.extraPets[uuid]==true
 local txt = string.format("%s | Age %d | %.2f KG", pet.PetType or "?", getAge(uuid), getKG(uuid))
 local b = UI:button(ofr, txt, UDim2.new(1,0,0,22), nil, sel and T.SEL_BG or Color3.fromRGB(13,13,13), sel and T.SEL_TXT or T.TEXT, 9)
 b.LayoutOrder = n; b.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(b,0,8,4,0); UI:stroke(b, sel and T.ACCENT or T.STROKE, 1)
 b.MouseButton1Click:Connect(function()
 if cfg.elephant.extraPets[uuid] then cfg.elephant.extraPets[uuid]=nil else cfg.elephant.extraPets[uuid]=true end
 saveConfig(); rebuild() end)
 n = n+1
 end
 end
 os:GetPropertyChangedSignal("Text"):Connect(rebuild)
 sb.MouseButton1Click:Connect(function() ov.Visible=true; rebuild() end)
 end

 -- Extra Elephant Filler
 do
 local row = UI:frame(eleInner, UDim2.new(1,0,0,26), nil, T.BTN, 120)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, "Extra Elephant Filler", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 UI:toggle(row, UDim2.new(1,-48,0.5,-11), cfg.elephant.useExtraElePets or false,
 function(v) cfg.elephant.useExtraElePets = v; saveConfig() end)
 local cnt = UI:label(row, "NONE", UDim2.new(0,50,1,0), UDim2.new(0,140,0,0), T.DIM, 9)
 cnt.Font = Enum.Font.Gotham
 local sb = UI:button(row, "Select >", UDim2.new(0,50,0,20), UDim2.new(1,-56,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(sb, T.STROKE, 1)
 local function upd() local n=0; for _ in pairs(cfg.elephant.extraElePets) do n=n+1 end
 cnt.Text = n==0 and "NONE" or (n.." sel"); cnt.TextColor3 = n==0 and T.DIM or T.ACCENT end
 upd()
 local ov = UI:frame(PageElephant, UDim2.new(1,0,1,0), nil, T.BG)
 ov.Visible = false; ov.ZIndex = 20
 local oh = UI:frame(ov, UDim2.new(1,0,0,26), nil, T.PANEL)
 UI:stroke(oh, T.STROKE, 1)
 UI:label(oh, "Select Extra Elephant Filler", UDim2.new(1,-36,1,0), UDim2.new(0,8,0,0), T.ACCENT, 10)
 local ox = UI:button(oh, "X", UDim2.new(0,24,0,20), UDim2.new(1,-28,0.5,-10), T.ERROR, T.TEXT, 10)
 UI:stroke(ox, T.ERROR, 1)
 ox.MouseButton1Click:Connect(function() ov.Visible = false; upd() end)
 local os2 = UI:input(ov, "", "Search pet...", UDim2.new(1,-8,0,22), UDim2.new(0,4,0,28))
 os2.TextColor3 = T.TEXT; os2.Font = Enum.Font.Gotham
 local ofr = UI:scroll(ov, UDim2.new(1,0,1,-56), UDim2.new(0,0,0,54))
 UI:list(ofr, 3); UI:pad(ofr, 3,4,4,3)
 local function rebuild()
 for _, c in ipairs(ofr:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 local inv = getInventory(); local q = string.lower(os2.Text)
 local us = {}; for u in pairs(inv) do table.insert(us, u) end
 table.sort(us, function(a,b) return getKG(a)>getKG(b) end)
 local n = 0
 for _, uuid in ipairs(us) do
 local pet = inv[uuid]
 if not pet then continue end
 if q~="" and not string.lower(pet.PetType or ""):find(q,1,true) then continue end
 if table.find(cfg.targets, uuid) then continue end
 local sel = cfg.elephant.extraElePets[uuid]==true
 local txt = string.format("%s | Age %d | %.2f KG", pet.PetType or "?", getAge(uuid), getKG(uuid))
 local b = UI:button(ofr, txt, UDim2.new(1,0,0,22), nil, sel and T.SEL_BG or Color3.fromRGB(13,13,13), sel and T.SEL_TXT or T.TEXT, 9)
 b.LayoutOrder = n; b.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(b,0,8,4,0); UI:stroke(b, sel and T.ACCENT or T.STROKE, 1)
 b.MouseButton1Click:Connect(function()
 if cfg.elephant.extraElePets[uuid] then cfg.elephant.extraElePets[uuid]=nil else cfg.elephant.extraElePets[uuid]=true end
 saveConfig(); rebuild() end)
 n = n+1
 end
 end
 os2:GetPropertyChangedSignal("Text"):Connect(rebuild)
 sb.MouseButton1Click:Connect(function() ov.Visible=true; rebuild() end)
 end

 -- Target pets selector
 local tgtCountLabel
 do
 local row = UI:frame(eleInner, UDim2.new(1,0,0,26), nil, T.BTN, 130)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 UI:label(row, "Target Pets", UDim2.new(0,100,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 tgtCountLabel = UI:label(row, "0", UDim2.new(0,50,1,0), UDim2.new(0,100,0,0), T.DIM, 9)
 tgtCountLabel.Font = Enum.Font.Gotham
 local sb = UI:button(row, "Select >", UDim2.new(0,50,0,20), UDim2.new(1,-56,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(sb, T.STROKE, 1)
 local function upd()
 tgtCountLabel.Text = tostring(#cfg.targets)
 tgtCountLabel.TextColor3 = #cfg.targets > 0 and T.ACCENT or T.DIM
 end
 upd()
 local ov = UI:frame(PageElephant, UDim2.new(1,0,1,0), nil, T.BG)
 ov.Visible = false; ov.ZIndex = 20
 local oh = UI:frame(ov, UDim2.new(1,0,0,26), nil, T.PANEL)
 UI:stroke(oh, T.STROKE, 1)
 UI:label(oh, "Select Target Pets", UDim2.new(1,-80,1,0), UDim2.new(0,8,0,0), T.ACCENT, 10)
 local sa = UI:button(oh, "All", UDim2.new(0,40,0,20), UDim2.new(1,-120,0.5,-10), T.BTN, T.ACCENT, 8)
 UI:stroke(sa, T.STROKE, 1)
 local ox = UI:button(oh, "X", UDim2.new(0,24,0,20), UDim2.new(1,-28,0.5,-10), T.ERROR, T.TEXT, 10)
 UI:stroke(ox, T.ERROR, 1)
 ox.MouseButton1Click:Connect(function() ov.Visible = false; upd() end)
 local os3 = UI:input(ov, "", "Search pet...", UDim2.new(1,-8,0,22), UDim2.new(0,4,0,28))
 os3.TextColor3 = T.TEXT; os3.Font = Enum.Font.Gotham
 local ofr = UI:scroll(ov, UDim2.new(1,0,1,-56), UDim2.new(0,0,0,54))
 UI:list(ofr, 3); UI:pad(ofr, 3,4,4,3)
 local function rebuild()
 for _, c in ipairs(ofr:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
 local inv = getInventory(); local q = string.lower(os3.Text)
 local us = {}; for u in pairs(inv) do table.insert(us, u) end
 table.sort(us, function(a,b) return getKG(a)>getKG(b) end)
 local allSel = true
 for _, uuid in ipairs(us) do
 if not table.find(cfg.targets, uuid) then allSel = false; break end
 end
 sa.Text = allSel and "None" or "All"
 local n = 0
 for _, uuid in ipairs(us) do
 local pet = inv[uuid]
 if not pet then continue end
 if q~="" and not string.lower(pet.PetType or ""):find(q,1,true) then continue end
 local sel = table.find(cfg.targets, uuid) ~= nil
 local mut = getMutName(uuid)
 local ms = (mut~="" and (" ["..mut.."]")) or ""
 local txt = string.format("%s%s | Age %d | %.2f KG", pet.PetType or "?", ms, getAge(uuid), getKG(uuid))
 local b = UI:button(ofr, txt, UDim2.new(1,0,0,22), nil, sel and T.SEL_BG or Color3.fromRGB(13,13,13), sel and T.SEL_TXT or T.TEXT, 9)
 b.LayoutOrder = n; b.TextXAlignment = Enum.TextXAlignment.Left
 UI:pad(b,0,8,4,0); UI:stroke(b, sel and T.ACCENT or T.STROKE, 1)
 b.MouseButton1Click:Connect(function()
 local i = table.find(cfg.targets, uuid)
 if i then table.remove(cfg.targets, uuid) else table.insert(cfg.targets, uuid) end
 saveConfig(); upd(); rebuild() end)
 n = n+1
 end
 end
 sa.MouseButton1Click:Connect(function()
 local inv = getInventory(); local q = string.lower(os3.Text)
 local us = {}; for u in pairs(inv) do table.insert(us, u) end
 local allSel = true
 for _, uuid in ipairs(us) do
 if not table.find(cfg.targets, uuid) then allSel = false; break end
 end
 if allSel then cfg.targets = {} else
 for _, uuid in ipairs(us) do
 local pet = inv[uuid]
 if pet and (q=="" or string.lower(pet.PetType or ""):find(q,1,true)) then
 if not table.find(cfg.targets, uuid) then table.insert(cfg.targets, uuid) end
 end
 end
 end
 saveConfig(); upd(); rebuild()
 end)
 os3:GetPropertyChangedSignal("Text"):Connect(rebuild)
 sb.MouseButton1Click:Connect(function() ov.Visible=true; rebuild() end)
 end

 -- Log panel
 local logScroll, logCount, doneCount, doneLabel
 do
 local lf = UI:frame(eleInner, UDim2.new(1,0,0,80), nil, T.PANEL, 140)
 UI:stroke(lf, T.STROKE, 1)
 local lh = UI:frame(lf, UDim2.new(1,0,0,16), nil, T.BG, 1)
 UI:label(lh, "LOGS", UDim2.new(0,60,1,0), UDim2.new(0,6,0,0), T.ACCENT, 8).Font = Enum.Font.GothamBold
 doneLabel = UI:label(lh, "Done: 0", UDim2.new(1,-60,1,0), nil, T.DIM, 8, Enum.TextXAlignment.Right)
 doneLabel.Font = Enum.Font.Gotham
 logScroll = UI:scroll(lf, UDim2.new(1,-4,1,-18), UDim2.new(0,2,0,17))
 UI:list(logScroll, 1); UI:pad(logScroll, 1,4,4,1)
 logCount = 0; doneCount = 0
 end

 local function logFn(msg, color)
 logCount = logCount + 1
 local lbl = Instance.new("TextLabel")
 lbl.Size = UDim2.new(1,0,0,12); lbl.BackgroundTransparency = 1
 lbl.Text = os.date("%H:%M:%S") .. " " .. msg
 lbl.TextColor3 = color or T.DIM; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 8
 lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.TextTruncate = Enum.TextTruncate.AtEnd
 lbl.LayoutOrder = logCount; lbl.Parent = logScroll
 local all = {}
 for _, c in ipairs(logScroll:GetChildren()) do if c:IsA("TextLabel") then table.insert(all, c) end end
 while #all > 35 do all[1]:Destroy(); table.remove(all, 1) end
 task.defer(function() logScroll.CanvasPosition = Vector2.new(0, math.huge) end)
 end

 -- AUTO KG bar
 local kgStatus
 do
 local bar = UI:frame(eleInner, UDim2.new(1,0,0,30), nil, T.PANEL, 999)
 UI:stroke(bar, T.STROKE, 1)
 UI:label(bar, "AUTO KG", UDim2.new(0,70,0,20), UDim2.new(0,6,0.5,-10), T.TEXT, 10).Font = Enum.Font.GothamBold
 kgStatus = UI:label(bar, "IDLE", UDim2.new(1,-100,1,0), UDim2.new(0,70,0,0), T.DIM, 9)
 kgStatus.Font = Enum.Font.Gotham; kgStatus.TextTruncate = Enum.TextTruncate.AtEnd
 end
 local function statusFn(msg, color)
 kgStatus.Text = msg; kgStatus.TextColor3 = color or T.DIM
 end

 --  AUTO KG LOGIC 
 local function startAutoKG(tog, status, log, doneLbl)
 local inv = getInventory()
 local cleaned = {}
 for _, uuid in ipairs(cfg.targets) do
 if inv[uuid] then table.insert(cleaned, uuid) end
 end
 cfg.targets = cleaned
 if #cfg.targets == 0 then status("No targets!", T.ERROR); tog.Set(false); return end
 isKGRunning = true; doneCount = 0
 status("Running...", T.SUCCESS)
 log("=== AUTO KG START ===", T.ACCENT)
 startTeamWatcher()

 task.spawn(function()
 local teamLev = getTeamUUIDs(cfg.elephant.levelingTeam)
 local teamEle = getTeamUUIDs(cfg.elephant.elephantTeam)
 local teamP2 = getTeamUUIDs(cfg.elephant.phase2Team)
 local targetKG = tonumber(cfg.elephant.targetWeight) or 2
 local maxLvl = cfg.elephant.levelThreshold
 local p2Enabled = cfg.elephant.phase2Enabled
 local p2Thresh = cfg.elephant.phase2Threshold
 local lvlTo100 = cfg.elephant.levelTo100
 local gardenSlots = math.max(1, math.min(3, tonumber(cfg.elephant.gardenSlots) or 1))
 local gardenMode = cfg.elephant.gardenMode or "A"
 local startTime = os.clock()
 local targetsCopy = {}
 for _, uuid in ipairs(cfg.targets) do table.insert(targetsCopy, uuid) end
 local totalPets = #targetsCopy

 local function buildEquipList(targetPets, teamPets)
 local list = {}
 for _, uuid in ipairs(targetPets) do
 if #list < 8 then table.insert(list, uuid) end
 end
 for _, uuid in ipairs(teamPets or {}) do
 if #list >= 8 then break end
 local found = false
 for _, e in ipairs(list) do if e == uuid then found = true; break end end
 if not found then table.insert(list, uuid) end
 end
 return list
 end

 local idx = 1
 while idx <= #targetsCopy and isKGRunning do
 local batch = {}
 for bi = idx, math.min(idx + gardenSlots - 1, #targetsCopy) do
 table.insert(batch, targetsCopy[bi])
 end
 if #batch == 0 then break end
 idx = idx + #batch

 -- Phase 1: Level to threshold
 local batchAtTarget = {}
 for _, uuid in ipairs(batch) do batchAtTarget[uuid] = getBase(uuid) end
 do
 local used = {}
 for _, uuid in ipairs(batch) do used[uuid] = true end
 for _, uuid in ipairs(teamLev) do used[uuid] = true end
 local finalEquip = {}
 for _, uuid in ipairs(batch) do if #finalEquip < 8 then table.insert(finalEquip, uuid) end end
 for _, uuid in ipairs(teamLev) do
 if #finalEquip >= 8 then break end; table.insert(finalEquip, uuid)
 end
 if cfg.elephant.useExtraPets and #finalEquip < 8 then
 local extras = getExtraPets(used, 8 - #finalEquip)
 for _, uuid in ipairs(extras) do
 if #finalEquip >= 8 then break end
 table.insert(finalEquip, uuid); used[uuid] = true
 end
 end
 setDesiredPets(finalEquip, teamLev)
 unequipAll(); task.wait(0.5)
 equipList(finalEquip)
 while isKGRunning do
 task.wait(TIMING.POLL_RATE)
 local allDone = true
 for uuid in pairs(batchAtTarget) do
 if getAge(uuid) < maxLvl then allDone = false; break end
 end
 if allDone then setDesiredPets({}, {}); unequipAll(); task.wait(0.3); break end
 local needRebuild = false
 for uuid in pairs(batchAtTarget) do
 if getAge(uuid) >= maxLvl then
 log(string.format("> %s lv%d swap out", getPType(uuid), getAge(uuid)), T.SUCCESS)
 batchAtTarget[uuid] = nil; needRebuild = true
 end
 end
 if not next(batchAtTarget) then setDesiredPets({}, {}); unequipAll(); task.wait(0.3); break end
 if needRebuild then
 local used2 = {}
 for uuid in pairs(batchAtTarget) do used2[uuid] = true end
 for _, uuid in ipairs(teamLev) do used2[uuid] = true end
 local final2 = {}
 for uuid in pairs(batchAtTarget) do if #final2 < 8 then table.insert(final2, uuid) end end
 for _, uuid in ipairs(teamLev) do
 if #final2 >= 8 then break end; table.insert(final2, uuid)
 end
 setDesiredPets(final2, teamLev)
 equipState.IsEquipping = true
 local targetSet = {}; for _, uuid in ipairs(final2) do targetSet[uuid] = true end
 for _, uuid in ipairs(getActivePets()) do
 if not targetSet[uuid] then
 pcall(function() PetsRemote:FireServer("UnequipPet", uuid) end)
 task.wait(TIMING.UNEQUIP_DELAY)
 end
 end
 task.wait(TIMING.UNEQUIP_BUFFER)
 local cf = getFarmCF()
 local nowSet = {}; for _, uuid in ipairs(getActivePets()) do nowSet[uuid] = true end
 for _, uuid in ipairs(final2) do
 if not nowSet[uuid] then
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 end
 equipState.IsEquipping = false
 end
 local sts = {}
 for uuid in pairs(batchAtTarget) do
 table.insert(sts, string.format("Lv%d %.2f/%.2fkg", getAge(uuid), getBase(uuid), targetKG))
 end
 status("P1: " .. table.concat(sts, " | "), T.DIM)
 end
 end
 if not isKGRunning then break end

 -- Phase 2: Elephant KG boost
 if #teamEle > 0 then
 if gardenMode == "A" then
 local preW = {}
 local actSet = {}
 for _, uuid in ipairs(batch) do preW[uuid] = getBase(uuid); actSet[uuid] = true end
 local function buildEleEquip()
 local used = {}
 for uuid in pairs(actSet) do used[uuid] = true end
 for _, uuid in ipairs(teamEle) do used[uuid] = true end
 local final = {}
 for uuid in pairs(actSet) do if #final < 8 then table.insert(final, uuid) end end
 for _, uuid in ipairs(teamEle) do
 if #final >= 8 then break end; table.insert(final, uuid)
 end
 if cfg.elephant.useExtraElePets and #final < 8 then
 local extras = getExtraElePets(used, 8 - #final)
 for _, uuid in ipairs(extras) do
 if #final >= 8 then break end; table.insert(final, uuid)
 end
 end
 return final
 end
 local eleEquip = buildEleEquip()
 setDesiredPets(eleEquip, teamEle)
 unequipAll(); task.wait(0.5); equipList(eleEquip)
 while isKGRunning do
 task.wait(TIMING.POLL_RATE)
 local anyUp = false
 for uuid in pairs(actSet) do
 local nw = getBase(uuid)
 if nw > preW[uuid] then
 log(string.format("> %s %.2f -> %.2fkg", getPType(uuid), preW[uuid], nw), Color3.fromRGB(255,180,80))
 preW[uuid] = nw; actSet[uuid] = nil; anyUp = true
 end
 end
 if not next(actSet) then setDesiredPets({}, {}); unequipAll(); task.wait(0.3); break end
 if anyUp then
 local newEq = buildEleEquip()
 setDesiredPets(newEq, teamEle)
 equipState.IsEquipping = true
 local tgtSet = {}; for _, uuid in ipairs(newEq) do tgtSet[uuid] = true end
 for _, uuid in ipairs(getActivePets()) do
 if not tgtSet[uuid] then
 pcall(function() PetsRemote:FireServer("UnequipPet", uuid) end)
 task.wait(TIMING.UNEQUIP_DELAY)
 end
 end
 task.wait(TIMING.UNEQUIP_BUFFER)
 local cf = getFarmCF()
 local ns = {}; for _, uuid in ipairs(getActivePets()) do ns[uuid] = true end
 for _, uuid in ipairs(newEq) do
 if not ns[uuid] then
 pcall(function() PetsRemote:FireServer("EquipPet", uuid, cf) end)
 task.wait(TIMING.EQUIP_DELAY)
 end
 end
 equipState.IsEquipping = false
 end
 local sts = {}
 for uuid in pairs(actSet) do table.insert(sts, string.format("%.2f/%.2fkg", getBase(uuid), targetKG)) end
 status("Ele A: " .. table.concat(sts, " | "), T.DIM)
 end
 else
 for _, uuid in ipairs(batch) do
 if not isKGRunning then break end
 local preW = getBase(uuid)
 local set = {[uuid] = true}
 for _, te in ipairs(teamEle) do set[te] = true end
 local final = {uuid}
 for _, te in ipairs(teamEle) do
 if #final >= 8 then break end; table.insert(final, te)
 end
 if cfg.elephant.useExtraElePets and #final < 8 then
 local extras = getExtraElePets(set, 8 - #final)
 for _, e in ipairs(extras) do
 if #final >= 8 then break end; table.insert(final, e)
 end
 end
 setDesiredPets({uuid}, teamEle)
 unequipAll(); task.wait(0.5); equipList(final)
 while isKGRunning do
 task.wait(TIMING.POLL_RATE)
 local nw = getBase(uuid)
 status(string.format("Ele B: %s %.2f/%.2fkg", getPType(uuid), nw, targetKG), T.DIM)
 if nw > preW then
 log(string.format("> %s %.2f -> %.2fkg", getPType(uuid), preW, nw), Color3.fromRGB(255,180,80))
 setDesiredPets({}, {}); unequipAll(); break
 end
 end
 end
 end
 end
 if not isKGRunning then break end
 for _, uuid in ipairs(batch) do batchAtTarget[uuid] = getBase(uuid) end

 -- Level each pet to 100
 for _, uuid in ipairs(batch) do
 if not isKGRunning then break end
 if not getInventory()[uuid] then
 local idx2 = table.find(cfg.targets, uuid)
 if idx2 then table.remove(cfg.targets, uuid) end
 else
 local petName = getPType(uuid)
 if not lvlTo100 then
 doneCount = doneCount + 1; doneLbl.Text = "Done: " .. doneCount
 log(string.format(" DONE %s %.2fkg", petName, getBase(uuid)), T.SUCCESS)
 status(string.format("%s done!", petName), T.SUCCESS)
 htTrack("kg_done", {pet_name = petName, final_kg = getBase(uuid)})
 local idx2 = table.find(cfg.targets, uuid)
 if idx2 then table.remove(cfg.targets, uuid) end
 if tgtCountLabel then tgtCountLabel.Text = tostring(#cfg.targets) end
 else
 log(string.format(" P2: %s  lvl 100", petName), T.ACCENT)
 status(string.format("P2 Lv%d/100 | %s", getAge(uuid), petName), T.ACCENT)
 local useP2 = p2Enabled and #teamP2 > 0 and (getAge(uuid) >= p2Thresh)
 local supportTeam = useP2 and teamP2 or teamLev
 currentTarget = uuid; currentTeam = supportTeam
 unequipAll(); task.wait(0.5)
 equipList(buildEquipTarget(uuid, supportTeam))
 while isKGRunning do
 task.wait(TIMING.POLL_RATE)
 local age = getAge(uuid)
 status(string.format("P2 Lv%d/100 | %s", age, petName), T.ACCENT)
 if p2Enabled and #teamP2 > 0 and not useP2 and (age >= p2Thresh) then
 useP2 = true; currentTeam = teamP2
 unequipAll(); task.wait(0.5)
 equipList(buildEquipTarget(uuid, teamP2))
 end
 if age >= 100 then
 unequipAll()
 doneCount = doneCount + 1; doneLbl.Text = "Done: " .. doneCount
 log(string.format(" DONE %s Lv100 %.2fkg", petName, getBase(uuid)), T.SUCCESS)
 status(string.format("%s done!", petName), T.SUCCESS)
 htTrack("kg_done", {pet_name = petName, final_kg = getBase(uuid)})
 local idx2 = table.find(cfg.targets, uuid)
 if idx2 then table.remove(cfg.targets, uuid) end
 if tgtCountLabel then tgtCountLabel.Text = tostring(#cfg.targets) end
 break
 end
 end
 end
 end
 end
 end

 isKGRunning = false
 tog.Set(false)
 stopTeamWatcher()
 statusFn("IDLE", T.DIM)
 cfg.toggles.autoKG = false; saveConfig()
 local elapsed = string.format("%.0fs", os.clock() - startTime)
 log("", T.ACCENT)
 log(string.format("ALL DONE %d/%d pets (%s)", doneCount, totalPets, elapsed), T.SUCCESS)
 end)
 end

 local kgToggle = UI:toggle(eleInner, UDim2.new(1,-52,0.5,-11), cfg.toggles.autoKG,
 function(val)
 cfg.toggles.autoKG = val; saveConfig()
 if val then startAutoKG(kgToggle, statusFn, logFn, doneLabel)
 else isKGRunning = false; stopTeamWatcher()
 logFn("--- Stopped ---", T.ERROR); statusFn("IDLE", T.DIM)
 end
 end)
 kgToggle.LayoutOrder = 998
 if cfg.toggles.autoKG then
 task.defer(function() startAutoKG(kgToggle, statusFn, logFn, doneLabel) end)
 end

 -- ======================== PLACE EGGS ========================
 local placeAcc = UI:accordion(eleInner, "PLACE EGGS", 990, false)
 local placeInner = placeAcc.Inner

 local placeRow = UI:frame(placeInner, UDim2.new(1,0,0,26), nil, T.BTN, 1)
 UI:corner(placeRow, 5); UI:stroke(placeRow, T.STROKE, 1)
 UI:label(placeRow, "Auto Place Eggs", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.Gotham
 local placeToggle = UI:toggle(placeRow, UDim2.new(1,-48,0.5,-11), cfg.placeEggs.enabled,
 function(val) cfg.placeEggs.enabled = val; saveConfig() end)

 local placeStatusRow = UI:frame(placeInner, UDim2.new(1,0,0,20), nil, T.BTN, 2)
 UI:corner(placeStatusRow, 5); UI:stroke(placeStatusRow, T.STROKE, 1)
 local placeStatusLabel = UI:label(placeStatusRow, "IDLE", UDim2.new(1,-8,1,0), UDim2.new(0,6,0,0), T.DIM, 8)
 placeStatusLabel.Font = Enum.Font.Gotham

 local function getEggNames()
 local names = {}
 local seen = {}
 for _, pet in ipairs(PetJSON) do
 if pet.egg and not seen[pet.egg] then
 seen[pet.egg] = true
 table.insert(names, pet.egg)
 end
 end
 table.sort(names)
 return names
 end

 local allEggNames = getEggNames()

 local function syncEggOrder()
 if not cfg.placeEggs.order then cfg.placeEggs.order = {} end
 local newOrder = {}
 local seen = {}
 for _, name in ipairs(cfg.placeEggs.order) do
 if not seen[name] then
 table.insert(newOrder, name)
 seen[name] = true
 end
 end
 for _, name in ipairs(allEggNames) do
 if not seen[name] then
 table.insert(newOrder, name)
 end
 end
 cfg.placeEggs.order = newOrder
 end
 syncEggOrder()

 local function getEggCount(eggName)
 local n = 0
 for _, tool in ipairs(Backpack:GetChildren()) do
 if tool:IsA("Tool") and CS:HasTag(tool, "PetEggTool") then
 if tool:GetAttribute("h") == eggName then
 n = n + (tonumber(tool.Name:match("x(%d+)$")) or 1)
 end
 end
 end
 return n
 end

 local eggSelState = {}
 for _, name in ipairs(allEggNames) do
 eggSelState[name] = true
 for _, ordered in ipairs(cfg.placeEggs.order) do
 if ordered == name then eggSelState[name] = true; break end
 end
 end

 local eggListFrame = UI:scroll(placeInner, UDim2.new(1,0,0,200), nil, 4)
 UI:list(eggListFrame, 2); UI:pad(eggListFrame, 2,2,2,2)

 local function rebuildEggList()
 for _, c in ipairs(eggListFrame:GetChildren()) do
 if c:IsA("GuiObject") then c:Destroy() end
 end
 local order = cfg.placeEggs.order or {}
 for i, name in ipairs(order) do
 local count = getEggCount(name)
 local row = UI:frame(eggListFrame, UDim2.new(1,0,0,22), nil, T.BTN, i)
 UI:corner(row, 3); UI:stroke(row, T.STROKE, 1)
 UI:label(row, name, UDim2.new(1,-70,1,0), UDim2.new(0,6,0,0), T.TEXT, 8).Font = Enum.Font.Gotham
 local cntLbl = UI:label(row, tostring(count), UDim2.new(0,30,1,0), UDim2.new(1,-68,0,0), count > 0 and T.ACCENT or T.DIM, 8)
 cntLbl.Font = Enum.Font.Gotham; cntLbl.TextXAlignment = Enum.TextXAlignment.Center

 local upBtn = UI:button(row, "^", UDim2.new(0,16,0,16), UDim2.new(1,-42,0.5,-8), T.BTN, T.DIM, 8)
 UI:stroke(upBtn, T.STROKE, 1)
 local downBtn = UI:button(row, "v", UDim2.new(0,16,0,16), UDim2.new(1,-24,0.5,-8), T.BTN, T.DIM, 8)
 UI:stroke(downBtn, T.STROKE, 1)

 local capturedIdx = i
 upBtn.MouseButton1Click:Connect(function()
 if capturedIdx > 1 then
 local tmp = cfg.placeEggs.order[capturedIdx]
 cfg.placeEggs.order[capturedIdx] = cfg.placeEggs.order[capturedIdx - 1]
 cfg.placeEggs.order[capturedIdx - 1] = tmp
 saveConfig(); rebuildEggList()
 end
 end)
 downBtn.MouseButton1Click:Connect(function()
 if capturedIdx < #cfg.placeEggs.order then
 local tmp = cfg.placeEggs.order[capturedIdx]
 cfg.placeEggs.order[capturedIdx] = cfg.placeEggs.order[capturedIdx + 1]
 cfg.placeEggs.order[capturedIdx + 1] = tmp
 saveConfig(); rebuildEggList()
 end
 end)
 end
 end
 rebuildEggList()
 end
end

-- AUTO PLACE EGGS LOOP
task.spawn(function()
 while task.wait(5) do
 if not cfg.placeEggs.enabled then continue end
 local success, err = pcall(function()
 local positions = getEggPositions()
 if #positions == 0 then return end

 local placed, placedPos = countPlacedEggs()
 local maxEggs = #positions
 if placed >= maxEggs then return end

 local usedPositions = {}
 for _, pos in ipairs(placedPos) do
 for i, slot in ipairs(positions) do
 if not usedPositions[i] and (pos - slot).Magnitude <= 2 then
 usedPositions[i] = true
 break
 end
 end
 end

 local order = cfg.placeEggs.order or {}
 for _, eggName in ipairs(order) do
 if placed >= maxEggs then break end
 local tool = getEggToolByName(eggName)
 if not tool then continue end

 local eggCount = tonumber(tool.Name:match("x(%d+)$")) or 1
 for _ = 1, eggCount do
 if placed >= maxEggs then break end

 local targetIdx = nil
 for i, _ in ipairs(positions) do
 if not usedPositions[i] then targetIdx = i; break end
 end
 if not targetIdx then break end

 Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
 local hum = Character:FindFirstChildOfClass("Humanoid")
 if hum then hum:EquipTool(tool) end
 task.wait(0.3)

 pcall(function()
 PetEggService:FireServer("CreateEgg", positions[targetIdx])
 end)
 usedPositions[targetIdx] = true
 placed = placed + 1
 task.wait(1)
 end
 end
 end)
 if not success then
 warn("[Auto Place Eggs]", err)
 end
 end
end)

-- ============================================================

-- ============================================================
do
 local miscScroll = UI:scroll(PageMisc, UDim2.new(1,0,1,0))
 miscScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 miscScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
 miscScroll.ScrollBarThickness = 3
 miscScroll.ScrollBarImageColor3 = T.ACCENT
 UI:list(miscScroll, 5)
 UI:pad(miscScroll, 4,4,4,4)

 -- ACCORDION 1: VISIBILITY
 local visAcc = UI:accordion(miscScroll, "VISIBILITY", 1, true)
 local inner = visAcc.Inner

 -- Hide Farm Plants
 local visConnections = {}
 local function hidePart(obj)
 if obj:IsA("BasePart") or obj:IsA("UnionOperation") or obj:IsA("MeshPart") then
 pcall(function() obj.Transparency = 1 end)
 end
 if obj:IsA("Decal") or obj:IsA("Texture") then
 pcall(function() obj.Transparency = 1 end)
 end
 if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
 pcall(function() obj.Enabled = false end)
 end
 if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
 pcall(function() obj.Enabled = false end)
 end
 end
 local function hideFarmPlants()
 local farm = workspace:FindFirstChild("Farm")
 if not farm then return end
 local function processPlot(plot)
 local important = plot:FindFirstChild("Important")
 if not important then return end
 local plants = important:FindFirstChild("Plants_Physical")
 if not plants then return end
 for _, desc in ipairs(plants:GetDescendants()) do hidePart(desc) end
 table.insert(visConnections, plants.DescendantAdded:Connect(function(d) task.wait(); hidePart(d) end))
 end
 for _, plot in ipairs(farm:GetChildren()) do processPlot(plot) end
 table.insert(visConnections, farm.ChildAdded:Connect(function(p) task.wait(0.5); processPlot(p) end))
 end
 local row = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 1)
 UI:corner(row, 5); UI:stroke(row, T.STROKE, 1)
 local hfpLbl = UI:label(row, "Hide Farm Plants", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9)
 hfpLbl.Font = Enum.Font.GothamBold; hfpLbl.TextYAlignment = Enum.TextYAlignment.Center
 UI:toggle(row, UDim2.new(1,-48,0.5,-11), cfg.toggles.hidePlants,
 function(val)
 cfg.toggles.hidePlants = val; saveConfig()
 if val then hideFarmPlants()
 else
 for _, c in ipairs(visConnections) do pcall(function() c:Disconnect() end) end
 table.clear(visConnections)
 end
 end)
 if cfg.toggles.hidePlants then hideFarmPlants() end

 -- ACCORDION 2: AUTO RENEW SERVER
 local rsAcc = UI:accordion(miscScroll, "AUTO RENEW SERVER", 2, true)
 local inner = rsAcc.Inner

 -- Job ID
 local jidRow = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 1)
 UI:corner(jidRow, 5); UI:stroke(jidRow, T.STROKE, 1)
 local jidLbl = UI:label(jidRow, "Job: " .. tostring(game.JobId),
 UDim2.new(1,0,1,0), UDim2.new(0,6,0,0), T.DIM, 8)
 jidLbl.Font = Enum.Font.Gotham; jidLbl.TextTruncate = Enum.TextTruncate.AtEnd
 jidLbl.TextXAlignment = Enum.TextXAlignment.Left

 -- Server Version
 local svRow = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 2)
 UI:corner(svRow, 5); UI:stroke(svRow, T.STROKE, 1)
 local svLbl = UI:label(svRow, "Version: " .. tostring(game.PlaceVersion),
 UDim2.new(1,0,1,0), UDim2.new(0,6,0,0), T.DIM, 8)
 svLbl.Font = Enum.Font.Gotham; svLbl.TextXAlignment = Enum.TextXAlignment.Left

 -- Interval
 local intRow = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 3)
 UI:corner(intRow, 5); UI:stroke(intRow, T.STROKE, 1)
 UI:label(intRow, "Interval (min)", UDim2.new(1,-72,1,0), UDim2.new(0,6,0,0), T.DIM, 9).Font = Enum.Font.Gotham
 local rsInterval = cfg.misc.rsInterval
 local intInput = UI:input(intRow, tostring(rsInterval), "",
 UDim2.new(0,64,0,20), UDim2.new(1,-68,0.5,-10))
 intInput.FocusLost:Connect(function()
 local val = tonumber(intInput.Text)
 if val and val >= 1 then rsInterval = val; cfg.misc.rsInterval = val; saveConfig()
 else intInput.Text = tostring(rsInterval) end
 end)

 -- Countdown
 local cdRow = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 4)
 UI:corner(cdRow, 5); UI:stroke(cdRow, T.STROKE, 1)
 local cdLbl = UI:label(cdRow, "Next rejoin: --:--",
 UDim2.new(1,0,1,0), UDim2.new(0,6,0,0), T.DIM, 9)
 cdLbl.Font = Enum.Font.Gotham; cdLbl.TextXAlignment = Enum.TextXAlignment.Left

 -- Toggle
 local togRow = UI:frame(inner, UDim2.new(1,0,0,26), nil, T.BTN, 5)
 UI:corner(togRow, 5); UI:stroke(togRow, T.STROKE, 1)
 UI:label(togRow, "AUTO RENEW", UDim2.new(1,-52,1,0), UDim2.new(0,6,0,0), T.TEXT, 9).Font = Enum.Font.GothamBold
 local running = false
 UI:toggle(togRow, UDim2.new(1,-48,0.5,-11), cfg.toggles.autoRefresh,
 function(val)
 cfg.toggles.autoRefresh = val; saveConfig()
 if val then
 running = true
 task.spawn(function()
 while running do
 local total = rsInterval * 60
 local elapsed = 0
 while elapsed < total and running do
 local rem = total - elapsed
 cdLbl.Text = string.format("Next rejoin: %02d:%02d", math.floor(rem/60), math.floor(rem%60))
 task.wait(1); elapsed = elapsed + 1
 end
 if running then
 cdLbl.Text = "Rejoining..."
 task.wait(0.5)
 pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
 end
 end
 end)
 else
 running = false; cdLbl.Text = "Next rejoin: --:--"
  end
  end)
end

for i = 2, #tabNames do tabPages[i].Visible = false end
print("[HydraLite] Loaded successfully. Features: Hatch, Leveling, Nightmare, Elephant (Auto KG), Misc.")
