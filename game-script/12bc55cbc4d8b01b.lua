-- ════════════════════════════════════════════════════════
-- TAMPIL.lua — HydraHub (Deobfuscated Source)
-- Tool:  Auto-Hatch · Auto-KG · EV · AgeBreaker · MutMachine
--        Pick&Place · Pet-Boost · Webhook · Auto-Collect
-- Game:  Grow a Garden (Roblox)
-- Note:  Script contains external telemetry (§ 5)
-- ════════════════════════════════════════════════════════

-- ════════════════════════════════════════════════════════
-- § 1 · ROBLOX SERVICES & CORE REFERENCES
-- ════════════════════════════════════════════════════════
local Services={Players=game:GetService("Players"),RS=game:GetService("ReplicatedStorage"),Http=game:GetService("HttpService"),CoreGui=game:GetService("CoreGui"),CS=game:GetService("CollectionService"),UIS=game:GetService("UserInputService")}
local Players=Services.Players
local RS=Services.RS
local Http=Services.Http
local CoreGui=Services.CoreGui
local CS=Services.CS
local UIS=Services.UIS
local LocalPlayer=Players.LocalPlayer
local Backpack=LocalPlayer:WaitForChild("Backpack")
local Character=LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
LocalPlayer.CharacterAdded:Connect(function(v266) Character=v266
end)
local DataService=require(RS.Modules.DataService)
local GameEventRefs={Pets=RS:WaitForChild("GameEvents"):WaitForChild("PetsService"),Boost=RS:WaitForChild("GameEvents"):WaitForChild("PetBoostService")}
local PetsRemote=GameEventRefs.Pets
local BoostRemote=GameEventRefs.Boost
-- ════════════════════════════════════════════════════════
-- § 2 · LIBRARY LOAD & THEME
-- ════════════════════════════════════════════════════════
local HydraLib=loadstring(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/HydraMainLibrary.lua"))()
local T={BG=Color3.fromRGB(18,18,31),PANEL=Color3.fromRGB(12,12,20),BTN=Color3.fromRGB(26,26,46),SIDEBAR=Color3.fromRGB(14,14,24),STROKE=Color3.fromRGB(58,58,92),ACCENT=Color3.fromRGB(127,119,221),TEXT=Color3.fromRGB(220,220,235),DIM=Color3.fromRGB(100,100,130),SEL_BG=Color3.fromRGB(127,119,221),SEL_TXT=Color3.fromRGB(255,255,255),SUCCESS=Color3.fromRGB(80,210,100),ERROR=Color3.fromRGB(215,70,70),TOGGLE_ON=Color3.fromRGB(127,119,221),TOGGLE_OFF=Color3.fromRGB(35,35,55),ACTIVE_BG=Color3.fromRGB(20,20,50),ACTIVE_TXT=Color3.fromRGB(160,150,255),DARK_CARD=Color3.fromRGB(10,10,18),PHASE2=Color3.fromRGB(180,120,255)}
local UI=HydraLib.new(T)
if not HydraLib.buildPetList then HydraLib.buildPetList=function(v2321,v2322,v2323,v2324,v2325,v2326,v2327,v2328,v2329,v2330) local v2331=v2321.T
    for v2951,v2952 in ipairs(v2322:GetChildren()) do if v2952:IsA("GuiObject") then v2952:Destroy()
    end end local v2332=string.lower(v2326 or "" )
local v2333=v2328()
local v2334={}
for v2953 in pairs(v2333) do table.insert(v2334,v2953)
end table.sort(v2334,function(v2954,v2955) local v2956=(v2323[v2954] and 1) or 0
local v2957=(v2323[v2955] and 1) or 0
if (v2956~=v2957) then return v2956>v2957
end return v2327(v2954)>v2327(v2955)
end)
for v2958,v2959 in ipairs(v2334) do local v2960=v2333[v2959]
    if not v2960 then continue
    end local v2961=v2960.PetType or "?"
if ((v2332~="") and not v2961:lower():find(v2332,1,true)) then continue
end local v2962=v2323[v2959]
local v2963=v2324[v2959]==true
local v2964=(v2960.PetData and (v2960.PetData.Level or 0)) or 0
local v2965=v2327(v2959)
local v2966=(v2960.PetData and (v2960.PetData.BaseWeight or 0)) or 0
local v2967=(v2329(v2959) and " ❤") or ""
local v2968=(v2962 and " (active)") or ""
local v2969=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2961,v2968,v2967,v2964,v2965,v2966)
local v2970=v2321:button(v2322,v2969,UDim2.new(1,0,0,26),nil,(v2963 and v2331.SEL_BG) or (v2962 and v2331.ACTIVE_BG) or Color3.fromRGB(13,13,13) ,(v2963 and v2331.SEL_TXT) or (v2962 and v2331.ACTIVE_TXT) or v2331.TEXT ,9)
v2970.LayoutOrder=v2958
v2970:SetAttribute("uuid",v2959)
v2970.TextXAlignment=Enum.TextXAlignment.Left
v2321:pad(v2970,0,8,4,0)
v2321:stroke(v2970,(v2963 and v2331.ACCENT) or v2331.STROKE ,1)
v2970.MouseButton1Click:Connect(function() v2325(v2959,v2970,v2324)
end)
end end
end local PetsData=Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/pets.json"))
local PetAssetIds={}
task.spawn(function() local v267,v268=pcall(function() return Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/PetAssetId.json"))
end)
if (v267 and v268) then PetAssetIds=v268
end end)
local MutationMap=Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/mutation.json"))
-- ════════════════════════════════════════════════════════
-- § 4 · CONSTANTS & TIMING CONFIG
-- ════════════════════════════════════════════════════════
local ATTR_PET_UUID="PET_UUID"
local ATTR_FAVORITED="d"
local CONFIG_FILE="HydraX.json"
local DEFAULT_GARDEN_CF=CFrame.new( -22.884647369384766,0.13552331924438477,55.001434326171875)
local timingCfg={EQUIP_DELAY=0.08,UNEQUIP_DELAY=0.05,UNEQUIP_BUFFER=0.01,AH_EQUIP_DELAY=0.15,AH_UNEQUIP_DELAY=0.1,AH_POST_UNEQUIP_BUFFER=0.5,AH_KOI_SAFE_DELAY=1,AH_KOI_POST_HATCH=1.5,AH_SEAL_SAFE_DELAY=1,AH_SEAL_POST_SELL=2,POLL_RATE=3}
local isAutoKGRunning=false
-- ════════════════════════════════════════════════════════
-- § 5 · TELEMETRY / TRACKER  (hydra-checker.vercel.app)
-- ════════════════════════════════════════════════════════
local TRACKER_TOKEN="hx_punpsdun_tracker_2024"
local TRACKER_ENDPOINT="https://hydra-checker.vercel.app/api/t"
local TRACKER_LOAD_URL="https://hydra-checker.vercel.app/api/load-tracker?token=" .. TRACKER_TOKEN
task.spawn(function() local v269,v270=pcall(function() return loadstring(game:HttpGet(TRACKER_LOAD_URL))()
end)
if (v269 and v270) then _HT=v270
    _HT.init({username=LocalPlayer.Name,userId=tostring(LocalPlayer.UserId),secret=TRACKER_TOKEN,endpoint=TRACKER_ENDPOINT})
end end)

local function trackEvent(v271,v272) if not _HT then return
end pcall(function() _HT.track(v271,v272)
end)
end local boostTimingCfg={EQUIP_WAIT=0.1,FIRE_WAIT=0.1,UNEQUIP_WAIT=0.05,APPLY_DELAY=0.5,TEAM_CHECK=3}
-- ════════════════════════════════════════════════════════
-- § 6 · BOOST ITEMS & SIZE HELPER
-- ════════════════════════════════════════════════════════
local BOOST_ITEMS={{name="Small Toy",size="Small",btype="Toy"},{name="Medium Toy",size="Medium",btype="Toy"},{name="Large Toy",size="Large",btype="Toy"},{name="Small Treat",size="Small",btype="Treat"},{name="Medium Treat",size="Medium",btype="Treat"}}

local function getBoostSizeAndType(v273) for v1325,v1326 in ipairs(BOOST_ITEMS) do if (v1326.name==v273) then return v1326.size,v1326.btype
end end return "Small","Toy"
end local cfg={petTeams={},elephant={levelingTeam=nil,elephantTeam=nil,targetWeight=3.5,levelThreshold=50,phase2Team=nil,phase2Enabled=false,phase2Threshold=50,levelTo100=true,gardenSlots=1,gardenMode="A",useExtraPets=false,extraPets={},useExtraElePets=false,extraElePets={}},targets={},pickplace={petTimer=0,pickDelay=0.2,placeDelay=0.1,selPets={}},petboost={mode1={boostOptions={},selPets={}},mode2={pairs={},boostOptions={}}},toggles={autoKG=false,pickplace=false,mode1boost=false,mode2boost=false,autoCollect=false,hidePlants=false,autoRefresh=false,autoTradeWorld=false},misc={rsInterval=19},webhook={url="",continueSession=false},leveling={mainTeam=nil,optTeam=nil,optEnabled=false,optThreshold=50,targets={}},autoCollect={interval=0.1,sellAfter=false,selFruits={},selVariants={},stopWhenFull=false,maxInv=200},autoHatch={eggName="Paradise Egg",eggCount=13,eggSpacing=7,teamCD=nil,teamKoi=nil,teamSeal=nil,teamBronto=nil,brontoEnabled=true,brontoThresh=4,sellPets={},sellThresh=0,favDelay=0.1,espEnabled=true,running=false,autoSellWhenFull=false,petInvMax=200},autoTrade={targetPlayer=nil,selPets={},kgMode="Above",kgVal=0,ageMode="Above",ageVal=0,autoAccept=false,autoGift=false}}
local defaultBoostItem="Small Toy"
-- ════════════════════════════════════════════════════════
-- § 8 · CONFIG SAVE / LOAD  (orjson via writefile)
-- ════════════════════════════════════════════════════════
local configStore={}
configStore.save=function() if not writefile then return
end pcall(function() writefile(CONFIG_FILE,Http:JSONEncode(cfg))
end)
end
local saveConfig=configStore.save
-- ════════════════════════════════════════════════════════
-- § 9 · BUILT-IN TEAM PRESETS & TEAM HELPERS
-- ════════════════════════════════════════════════════════
local BUILTIN_TEAMS={{name="7 Mimic + 1 Bald Eagle",desc="Max passive Mimic, 1 Eagle filler",slots={{petType="Mimic Octopus",count=7},{petType="Bald Eagle",count=1}}},{name="Koi Max Passive",desc="Max hatch rate bonus, highest KG + mutation",slots={{petType="Koi",count=8}}},{name="Seal Max Passive",desc="Max sell return chance, always 8 Seal",slots={{petType="Seal",count=8}}},{name="Bronto Max Passive",desc="Max hatch size bonus (~30%), rest filled with Koi",slots={{petType="Brontosaurus",count=8},{petType="Koi",count=8}}},{name="Magpie Method",desc="1 Mimic, 3 Magpie, 1 Cockatrice, 3 filler priority",slots={{petType="Mimic Octopus",count=1},{petType="Magpie",count=3},{petType="Cockatrice",count=1}},priorityFiller={"Giant Ant","Red Giant Ant","Silver Monkey","Cape Buffalo"},fillerCount=3}}

local function getTeamUUIDs(v274) if not v274 then return {}
end for v1327,v1328 in ipairs(BUILTIN_TEAMS) do if (v1328.name==v274) then local v2974=(function() local v3463=DataService:GetData()
return (v3463 and v3463.PetsData and v3463.PetsData.PetInventory.Data) or {}
end)()
local v2975={}
for v3464,v3465 in pairs(v2974) do local v3466=v3465.PetType or ""
    if not v2975[v3466] then v2975[v3466]={}
    end table.insert(v2975[v3466],v3464)
end local v2976={a=0,b=0.1,c=0.2,d=0.3,g=0.5,s=0.05,z=0.08,A=0.22,J=0.01,K=0.03,L=0.045,M=0.06,N=0.07,O=0.07,P=0.3,V=0.2,X=0.3,Y=0.3,Z=0.3,["@"]=0.23,EV=0.3,RJ=0.25}

local function v2977(v3467) local v3468=v2974[v3467]
    if ( not v3468 or not v3468.PetData) then return 0
    end local v3469=v3468.PetData.BaseWeight or 0
local v3470=v3468.PetData.MutationType or "m"
return v3469 * (1 + (v2976[v3470] or 0))
end local function v2978(v3471) local v3472=v2974[v3471]
if ( not v3472 or not v3472.PetData) then return 0
end local v3473=v3472.PetData.BaseWeight or 0
local v3474=v3472.PetData.MutationType or "m"
return (5.35 + (v3473 * 0.1)) * (1 + (v2976[v3474] or 0))
end for v3475,v3476 in pairs(v2975) do table.sort(v3476,function(v3791,v3792) return v2977(v3791)>v2977(v3792)
end)
end if (v1328.name=="Magpie Method") then local v3793={}
for v3994,v3995 in ipairs(v1328.slots) do local v3996=v2975[v3995.petType] or {}
    local v3997=0
    for v4107,v4108 in ipairs(v3996) do if ( #v3793>=8) then break
    end if (v3997>=v3995.count) then break
end table.insert(v3793,v4108)
v3997=v3997 + 1
end end local v3794=0
local v3795=v1328.fillerCount or 3
local v3796={}
for v3998,v3999 in ipairs(v1328.priorityFiller or {} ) do for v4109,v4110 in ipairs(v2975[v3999] or {} ) do local v4111=false
    for v4202,v4203 in ipairs(v3793) do if (v4203==v4110) then v4111=true
        break
    end end if not v4111 then table.insert(v3796,v4110)
end end end table.sort(v3796,function(v4000,v4001) return v2977(v4000)>v2977(v4001)
end)
for v4002,v4003 in ipairs(v3796) do if ( #v3793>=8) then break
end if (v3794>=v3795) then break
end table.insert(v3793,v4003)
v3794=v3794 + 1
end return v3793
end if (v1328.name=="Bronto Max Passive") then local v3797={}
local v3798=0
local v3799=v2975['Brontosaurus'] or {}
table.sort(v3799,function(v4004,v4005) return v2978(v4004)>v2978(v4005)
end)
for v4006,v4007 in ipairs(v3799) do if ( #v3797>=8) then break
end if (v3798>=30) then break
end table.insert(v3797,v4007)
v3798=v3798 + v2978(v4007)
end local v3800=v2975['Koi'] or {}
for v4008,v4009 in ipairs(v3800) do if ( #v3797>=8) then break
end table.insert(v3797,v4009)
end return v3797
end local v2979={}
for v3477,v3478 in ipairs(v1328.slots) do local v3479=v2975[v3478.petType] or {}
    local v3480=0
    for v3801,v3802 in ipairs(v3479) do if ( #v2979>=8) then break
    end if (v3480>=v3478.count) then break
end table.insert(v2979,v3802)
v3480=v3480 + 1
end end if ( #v2979<8) then for v4010,v4011 in ipairs(v1328.slots) do local v4012=v2975[v4011.petType] or {}
for v4112,v4113 in ipairs(v4012) do if ( #v2979>=8) then break
end local v4114=false
for v4204,v4205 in ipairs(v2979) do if (v4205==v4113) then v4114=true
    break
end end if not v4114 then table.insert(v2979,v4113)
end end end end return v2979
end end return (cfg.petTeams[v274] and cfg.petTeams[v274].uuids) or {}
end local function buildTeamDropdown(v275,v276,v277,v278,v279,v280) for v1329,v1330 in ipairs(v275:GetChildren()) do if v1330:IsA("GuiObject") then v1330:Destroy()
end end local v281={}
if _G._NH_BUILTIN_TEAMS then for v2980,v2981 in ipairs(_G._NH_BUILTIN_TEAMS) do table.insert(v281,v2981.name)
end end for v1331 in pairs(v279.petTeams) do table.insert(v281,v1331)
end table.sort(v281)
if ( #v281==0) then local v2335=v278:label(v275," (save a team first)",UDim2.new(1,0,0,22),nil,v280.DIM,9)
    v2335.LayoutOrder=1
    return 1
end for v1332,v1333 in ipairs(v281) do local v1334=v277==v1333
local v1335=false
if _G._NH_BUILTIN_TEAMS then for v3481,v3482 in ipairs(_G._NH_BUILTIN_TEAMS) do if (v3482.name==v1333) then v1335=true
    break
end end end local v1336=(v1335 and Color3.fromRGB(40,20,80)) or Color3.fromRGB(14,14,14)
local v1337=(v1335 and Color3.fromRGB(180,160,255)) or v280.TEXT
local v1338=(v1335 and Color3.fromRGB(80,60,160)) or v280.STROKE
if v1334 then v1336=(v1335 and Color3.fromRGB(80,50,160)) or v280.SEL_BG
    v1337=v280.SEL_TXT
    v1338=(v1335 and Color3.fromRGB(160,120,255)) or v280.ACCENT
end local v1339=v278:button(v275,v1333,UDim2.new(1,0,0,22),nil,v1336,v1337,9)
v1339.LayoutOrder=v1332
v1339.TextXAlignment=Enum.TextXAlignment.Left
v278:pad(v1339,0,8,0,0)
v278:stroke(v1339,v1338,1)
if v1335 then local v2983=Instance.new("ImageLabel",v1339)
    v2983.Size=UDim2.new(0,16,0,16)
    v2983.Position=UDim2.new(1, -20,0.5, -8)
    v2983.BackgroundTransparency=1
    v2983.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
    v2983.ScaleType=Enum.ScaleType.Fit
    v2983.ZIndex=v1339.ZIndex + 1
end v1339.MouseButton1Click:Connect(function() v276(v1333)
end)
end return #v281
end local function loadConfig() if ( not readfile or not isfile or not isfile(CONFIG_FILE)) then return
end local v282,v283=pcall(function() return Http:JSONDecode(readfile(CONFIG_FILE))
end)
if ( not v282 or not v283) then return
end if v283.petTeams then cfg.petTeams=v283.petTeams
end if v283.elephant then for v2991,v2992 in pairs(v283.elephant) do cfg.elephant[v2991]=v2992
end end if v283.targets then cfg.targets=v283.targets
end if v283.pickplace then for v2994,v2995 in pairs(v283.pickplace) do cfg.pickplace[v2994]=v2995
end end if v283.petboost then if v283.petboost.mode1 then if (type(v283.petboost.mode1.boostOptions)=="table") then cfg.petboost.mode1.boostOptions=v283.petboost.mode1.boostOptions
elseif v283.petboost.mode1.boostOption then cfg.petboost.mode1.boostOptions={[v283.petboost.mode1.boostOption]=true}
end if v283.petboost.mode1.selPets then cfg.petboost.mode1.selPets=v283.petboost.mode1.selPets
end end if v283.petboost.mode2 then for v3803,v3804 in pairs(v283.petboost.mode2) do cfg.petboost.mode2[v3803]=v3804
end end end if v283.toggles then for v2997,v2998 in pairs(v283.toggles) do cfg.toggles[v2997]=v2998
end end if v283.misc then for v3000,v3001 in pairs(v283.misc) do cfg.misc[v3000]=v3001
end end if v283.webhook then for v3003,v3004 in pairs(v283.webhook) do cfg.webhook[v3003]=v3004
end end if (cfg.webhook.continueSession==nil) then cfg.webhook.continueSession=false
end if v283.leveling then for v3006,v3007 in pairs(v283.leveling) do cfg.leveling[v3006]=v3007
end end if v283.autoHatch then for v3009,v3010 in pairs(v283.autoHatch) do cfg.autoHatch[v3009]=v3010
end end if v283.autoTrade then for v3012,v3013 in pairs(v283.autoTrade) do cfg.autoTrade[v3012]=v3013
end end if v283.autoNM then if not cfg.autoNM then cfg.autoNM={lvTeam=nil,hsTeam=nil,lvThresh=30,targets={}}
end for v3015,v3016 in pairs(v283.autoNM) do cfg.autoNM[v3015]=v3016
end end if v283.autoEV then if not cfg.autoEV then cfg.autoEV={pvTeam=nil,lvTeam=nil,levelTo100=false,autoCleanseFirst=false,targets={}}
end for v3018,v3019 in pairs(v283.autoEV) do cfg.autoEV[v3018]=v3019
end end if v283.autoAgeBreaker then if not cfg.autoAgeBreaker then cfg.autoAgeBreaker={targets={},tumbalKgMax=2,tumbalAgeMax=99,skipEnabled=false}
end local v2342=v283.autoAgeBreaker
if (type(v2342.targets)=="table") then cfg.autoAgeBreaker.targets=v2342.targets
end if (v2342.tumbalKgMax~=nil) then cfg.autoAgeBreaker.tumbalKgMax=v2342.tumbalKgMax
end if (v2342.tumbalAgeMax~=nil) then cfg.autoAgeBreaker.tumbalAgeMax=v2342.tumbalAgeMax
end if (v2342.skipEnabled~=nil) then cfg.autoAgeBreaker.skipEnabled=v2342.skipEnabled
end if (v2342.maxLevel~=nil) then cfg.autoAgeBreaker.maxLevel=v2342.maxLevel
end if (v2342.autoStart~=nil) then cfg.autoAgeBreaker.autoStart=v2342.autoStart
end end if (cfg.autoAgeBreaker and (cfg.autoAgeBreaker.skipEnabled==nil)) then cfg.autoAgeBreaker.skipEnabled=false
end if (cfg.autoAgeBreaker and (cfg.autoAgeBreaker.maxLevel==nil)) then cfg.autoAgeBreaker.maxLevel=125
end if (cfg.autoAgeBreaker and (cfg.autoAgeBreaker.autoStart==nil)) then cfg.autoAgeBreaker.autoStart=false
end if v283.autoMutMachine then if not cfg.autoMutMachine then cfg.autoMutMachine={targets={},targetMut="Golden",cdTeam=nil,claimTeam=nil,lvTeam=nil,lvThresh=50}
end for v3021,v3022 in pairs(v283.autoMutMachine) do cfg.autoMutMachine[v3021]=v3022
end end if v283.autoCollect then if (type(v283.autoCollect.selFruits)=="table") then cfg.autoCollect.selFruits=v283.autoCollect.selFruits
end if (type(v283.autoCollect.selVariants)=="table") then cfg.autoCollect.selVariants=v283.autoCollect.selVariants
end if (v283.autoCollect.interval~=nil) then cfg.autoCollect.interval=v283.autoCollect.interval
end if (v283.autoCollect.sellAfter~=nil) then cfg.autoCollect.sellAfter=v283.autoCollect.sellAfter
end if (v283.autoCollect.stopWhenFull~=nil) then cfg.autoCollect.stopWhenFull=v283.autoCollect.stopWhenFull
end if (v283.autoCollect.maxInv~=nil) then cfg.autoCollect.maxInv=v283.autoCollect.maxInv
end end cfg.autoHatch.brontoEnabled=true
if (cfg.elephant.levelTo100==nil) then cfg.elephant.levelTo100=true
end if (cfg.elephant.phase2Enabled==nil) then cfg.elephant.phase2Enabled=false
end if (cfg.elephant.phase2Threshold==nil) then cfg.elephant.phase2Threshold=50
end if (cfg.elephant.gardenSlots==nil) then cfg.elephant.gardenSlots=1
end if (cfg.elephant.gardenMode==nil) then cfg.elephant.gardenMode="A"
end if (cfg.elephant.useExtraPets==nil) then cfg.elephant.useExtraPets=false
end if (cfg.elephant.extraPets==nil) then cfg.elephant.extraPets={}
end if (cfg.elephant.useExtraElePets==nil) then cfg.elephant.useExtraElePets=false
end if (cfg.elephant.extraElePets==nil) then cfg.elephant.extraElePets={}
end if ( not cfg.petboost.mode1.boostOptions or not next(cfg.petboost.mode1.boostOptions)) then cfg.petboost.mode1.boostOptions={["Small Toy"]=true}
end if (cfg.leveling.optThreshold==nil) then cfg.leveling.optThreshold=50
end if (cfg.leveling.optEnabled==nil) then cfg.leveling.optEnabled=false
end if (type(cfg.leveling.targets)~="table") then cfg.leveling.targets={}
end if (v283.autoHatch and v283.autoHatch.specialBronto) then if not cfg.autoHatch.specialBronto then cfg.autoHatch.specialBronto={enabled=true,pets={}}
end if (v283.autoHatch.specialBronto.enabled~=nil) then cfg.autoHatch.specialBronto.enabled=v283.autoHatch.specialBronto.enabled
end if (type(v283.autoHatch.specialBronto.pets)=="table") then cfg.autoHatch.specialBronto.pets=v283.autoHatch.specialBronto.pets
end end local v285={eggName="Paradise Egg",eggCount=13,eggSpacing=7,teamCD=nil,teamKoi=nil,teamSeal=nil,teamBronto=nil,brontoEnabled=true,brontoThresh=4,sellPets={},sellThresh=0,favDelay=0.1,espEnabled=true,running=false,ahUnequipDelay=0.1,ahEquipDelay=0.15,autoSellWhenFull=false,petInvMax=200,postUnequipBuffer=0.5,koiSafeDelay=1,koiPostHatch=1.5,sealSafeDelay=1,sealPostSell=2}
for v1343,v1344 in pairs(v285) do if (cfg.autoHatch[v1343]==nil) then cfg.autoHatch[v1343]=v1344
end end end loadConfig()
if cfg.autoHatch.ahEquipDelay then timingCfg.AH_EQUIP_DELAY=cfg.autoHatch.ahEquipDelay
end if cfg.autoHatch.ahUnequipDelay then timingCfg.AH_UNEQUIP_DELAY=cfg.autoHatch.ahUnequipDelay
end if cfg.autoHatch.postUnequipBuffer then timingCfg.AH_POST_UNEQUIP_BUFFER=cfg.autoHatch.postUnequipBuffer
end if cfg.autoHatch.koiSafeDelay then timingCfg.AH_KOI_SAFE_DELAY=cfg.autoHatch.koiSafeDelay
end if cfg.autoHatch.koiPostHatch then timingCfg.AH_KOI_POST_HATCH=cfg.autoHatch.koiPostHatch
end if cfg.autoHatch.sealSafeDelay then timingCfg.AH_SEAL_SAFE_DELAY=cfg.autoHatch.sealSafeDelay
end if cfg.autoHatch.sealPostSell then timingCfg.AH_SEAL_POST_SELL=cfg.autoHatch.sealPostSell
end local SESSION_FILE="HydraX_Session.json"
local sessionStats={startTime=0,cycleCount=0,totalHatched=0,eggBefore=0,eggCurrent=0,koiProc=0,sealProc=0,koiLastCycle=0,sealLastCycle=0,petTypes={},specials={huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}}
local sessionStore={}
sessionStore.save=function() if not writefile then return
end pcall(function() writefile(SESSION_FILE,Http:JSONEncode({AH={startTime=sessionStats.startTime,cycleCount=sessionStats.cycleCount,totalHatched=sessionStats.totalHatched,eggBefore=sessionStats.eggBefore,eggCurrent=sessionStats.eggCurrent,koiProc=sessionStats.koiProc,sealProc=sessionStats.sealProc,koiLastCycle=sessionStats.koiLastCycle,sealLastCycle=sessionStats.sealLastCycle,petTypes=sessionStats.petTypes,specials=sessionStats.specials},KG={startTime=0,doneCount=0,totalPets=0}}))
end)
end
sessionStore.load=function() if ( not readfile or not isfile or not isfile(SESSION_FILE)) then return nil
end local v286,v287=pcall(function() return Http:JSONDecode(readfile(SESSION_FILE))
end)
if ( not v286 or not v287) then return nil
end return v287
end
sessionStore.delete=function() if ( not isfile or not isfile(SESSION_FILE)) then return
end pcall(function() if delfile then delfile(SESSION_FILE)
end end)
end
local saveSession=sessionStore.save
local loadSession=sessionStore.load
local deleteSession=sessionStore.delete
if (type(cfg.petboost.mode1.selPets)~="table") then cfg.petboost.mode1.selPets={}
end local petUtils={}
petUtils.getInv=function() local v288=DataService:GetData()
return (v288 and v288.PetsData and v288.PetsData.PetInventory.Data) or {}
end
petUtils.getKG=function(v289) for v1360,v1361 in ipairs({Backpack,Character}) do for v2359,v2360 in ipairs(v1361:GetChildren()) do if (v2360:IsA("Tool") and (v2360:GetAttribute(ATTR_PET_UUID)==v289)) then local v3516=v2360:GetAttribute("KG")
if v3516 then return v3516
end local v3517=v2360.Name:match("%[(%d+%.?%d*)%s*KG%]")
if v3517 then return tonumber(v3517)
end end end end local v290=petUtils.getInv()
return (v290[v289] and (v290[v289].PetData.BaseWeight or 0)) or 0
end
petUtils.getAge=function(v291) local v292=petUtils.getInv()
return (v292[v291] and (v292[v291].PetData.Level or 0)) or 0
end
petUtils.getBase=function(v293) local v294=petUtils.getInv()
return (v294[v293] and (v294[v293].PetData.BaseWeight or 0)) or 0
end
petUtils.getPType=function(v295) local v296=petUtils.getInv()
return (v296[v295] and (v296[v295].PetType or "Unknown")) or "Unknown"
end
petUtils.isFav=function(v297) for v1362,v1363 in ipairs({Backpack,Character}) do for v2361,v2362 in ipairs(v1363:GetChildren()) do if (v2362:IsA("Tool") and (v2362:GetAttribute(ATTR_PET_UUID)==v297)) then return v2362:GetAttribute(ATTR_FAVORITED)==true
end end end return false
end
petUtils.findPetTool=function(v298) for v1364,v1365 in ipairs({Backpack,Character}) do for v2363,v2364 in ipairs(v1365:GetChildren()) do if (v2364:IsA("Tool") and (v2364:GetAttribute(ATTR_PET_UUID)==v298)) then return v2364
end end end return nil
end
petUtils.getMutName=function(v299) local v300=petUtils.getInv()
local v301=v300[v299]
if ( not v301 or not v301.PetData) then return ""
end local v302=v301.PetData.MutationType or ""
if ((v302=="") or (v302=="m")) then return ""
end return MutationMap[v302] or v302
end
local getInventory=petUtils.getInv
local getKG=petUtils.getKG
local getAge=petUtils.getAge
local getBaseWeight=petUtils.getBase
local getPetType=petUtils.getPType
local isFavorited=petUtils.isFav
local findPetTool=petUtils.findPetTool
local getMutationName=petUtils.getMutName

local function fetchThumbnailURL(v303) if not v303 then return nil
end local v304=tostring(v303):match("%d+")
if not v304 then return nil
end local v305,v306=pcall(function() return Http:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/Players/assets?assetIds=" .. v304 .. "&size=150x150&format=Png&isCircular=false" ))
end)
if (v305 and v306 and v306.data and v306.data[1] and v306.data[1].imageUrl) then return v306.data[1].imageUrl
end return nil
end local function sendWebhook(v307) local v308=cfg.webhook.url
if ( not v308 or (v308=="")) then return
end if ( not string.match(v308,"^https://discord") and not string.match(v308,"^https://ptb.discord") and not string.match(v308,"^https://canary.discord")) then return
end task.spawn(function() local v1366,v1367=pcall(function() local v2365=v307 and v307[1] and v307[1].title and v307[1].title:find("Special Pet")
local v2366=Http:JSONEncode({username=LocalPlayer.Name,avatar_url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png",content=(v2365 and "@everyone") or nil ,embeds=v307})
local v2367=(syn and syn.request) or (http and http.request) or request
if v2367 then v2367({Url=v308,Method="POST",Headers={["Content-Type"]="application/json"},Body=v2366})
else Http:PostAsync(v308,v2366,Enum.HttpContentType.ApplicationJson,false)
end end)
if not v1366 then warn("[VoidHub Webhook]",v1367)
end end)
end local cyclePerfCache={}

local function sendCycleWebhook(v309,v310,v311,v312,v313,v314,v315,v316,v317) local v318=math.min((v311/v312) * 100 ,100)
    local v319=math.floor(v318/10 )
    local v320=string.rep("█",v319) .. string.rep("░",10 -v319 )
    if v317 then if not cyclePerfCache[v317] then cyclePerfCache[v317]={times={},gains={}}
    end local v2368=cyclePerfCache[v317]
table.insert(v2368.times,v313)
table.insert(v2368.gains,v311-v310 )
if ( #v2368.times>5) then table.remove(v2368.times,1)
end if ( #v2368.gains>5) then table.remove(v2368.gains,1)
end end local v321,v322=v313,v311-v310
if (v317 and cyclePerfCache[v317]) then local v2369=cyclePerfCache[v317]
    local v2370,v2371=0,0
    for v3025,v3026 in ipairs(v2369.times) do v2370=v2370 + v3026
    end for v3027,v3028 in ipairs(v2369.gains) do v2371=v2371 + v3028
end v321=v2370/ #v2369.times
v322=v2371/ #v2369.gains
end local v323=math.max(v312-v311 ,0)
local v324=((v322>0) and math.ceil(v323/v322 )) or 0
local v325=v324 * v321
local v326=((v324>0) and string.format("~%d cycle lagi (~%s)",v324,HydraLib.fmtTime(v325))) or "Almost done!"

local function v327(v1368) local v1369=string.format("%.3f",v1368)
    v1369=v1369:gsub("%.?0+$","")
    return v1369
end sendWebhook({{title="🔄 Cycle Complete",color=5793266,description=string.format("**%s** | Queue `%d / %d`\n\n`%s` **%.1f%%**",v309,v315 or 0 ,v316 or 0 ,v320,v318),fields={{name="⚖️ Weight",value=string.format("%s → **%s** kg",v327(v310),v327(v311)),inline=true},{name="🎯 Target",value=string.format("%s kg",v327(v312)),inline=true},{name="🔁 Phase",value=v314 or "?" ,inline=true},{name="⏱️ Cycle",value=HydraLib.fmtTime(v313),inline=true},{name="📈 Gain",value=string.format("+%s kg",v327(v311-v310 )),inline=true},{name="🔮 Est. Done",value=v326,inline=true}},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local function sendPetDoneWebhook(v328,v329,v330,v331,v332,v333) local v334=math.min(math.floor(v329/1 ),5)
local v335=string.rep("⭐",v334) .. string.rep("✩",5 -v334 )
sendWebhook({{title="✅ Pet Finished!",color=5763719,description=string.format("**%s** has reached **Level 100**!\n%s",v328,v335),fields={{name="⚖️ Final Base",value=string.format("**%.3f** kg",v329),inline=true},{name="🎯 Queue",value=string.format("%d / %d done",v332 or 0 ,v333 or 0 ),inline=true},{name="🏁 Total Time",value=HydraLib.fmtTime(v330),inline=false},{name="⚡ Phase 2 Time",value=HydraLib.fmtTime(v331),inline=true},{name="🐢 Phase 1 Time",value=HydraLib.fmtTime(v330-v331 ),inline=true}},footer={text="Hydra Hub 🐉 • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local function sendTestWebhook() sendWebhook({{title=" Hydra Hub — Connection Test",color=5793266,description="Webhook Connected!",fields={{name="✅ Status",value="Online",inline=true},{name="🕐 Time",value=os.date("%H:%M:%S"),inline=true},{name="👤 Player",value=LocalPlayer.Name,inline=true}},footer={text=" Hydra Hub • vX"}}})
end local function sendSpecialPetWebhook(v336,v337,v338,v339,v340) local v341=cfg.webhook.url
if ( not v341 or (v341=="")) then return
end local v342=""
if (v338>=9) then v342="Godly"
elseif (v338>=7) then v342="Titan"
elseif (v338>=5) then v342="Huge"
end local v343=PetAssetIds[v336]
if not v343 then local v2372,v2373=pcall(function() return Http:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/PetAssetId.json"))
end)
if (v2372 and v2373) then v343=v2373[v336]
end end local v344=fetchThumbnailURL(v343)
v344=v344 or "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"
local v345=v336
local v346=((v342~="") and v342) or "Normal"
local v347=5793266
if (v342=="Godly") then v347=16766720
elseif (v342=="Titan") then v347=12632256
elseif (v342=="Huge") then v347=5763719
end sendWebhook({{title="🐾 Special Pet Found — " .. v345 ,color=v347,fields={{name="🐾 Pet Info",value=">>> " .. v345 .. "\nWeight: " .. string.format("%.2f KG",v337) .. "\nBronto: " .. string.format("%.2f KG",v338) .. "\nAge: Age " .. tostring(v339 or 0 ) ,inline=false},{name="🥚 Egg Info",value=">>> Egg: " .. (v340 or "?") .. "\nTier: " .. v346 ,inline=false},{name="🔀 Info",value=">>> Player: ||" .. LocalPlayer.Name .. "||" .. "\nTime: " .. os.date("%d/%m/%Y %H:%M:%S") ,inline=false}},thumbnail={url=v344},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") }}})
end local function getSpecialTier(v348) if (v348>=9) then return "godly"
end if (v348>=7) then return "titan"
end if (v348>=5) then return "huge"
end return nil
end local function snapshotInventory() local v349=DataService:GetData()
if ( not v349 or not v349.PetsData) then return {}
end local v350={}
for v1370 in pairs(v349.PetsData.PetInventory.Data or {} ) do v350[v1370]=true
end return v350
end local function getNewPets(v351) local v352=DataService:GetData()
if ( not v352 or not v352.PetsData) then return {}
end local v353=v352.PetsData.PetInventory.Data or {}
local v354={}
for v1372,v1373 in pairs(v353) do if not v351[v1372] then table.insert(v354,{uuid=v1372,data=v1373})
end end return v354
end local function processHatchedPets(v355) for v1374,v1375 in ipairs(v355) do local v1376=v1375.data
if ( not v1376 or not v1376.PetData) then continue
end local v1377=v1376.PetType or "Unknown"
local v1378=v1376.PetData.BaseWeight or 0
sessionStats.totalHatched=sessionStats.totalHatched + 1
if not sessionStats.petTypes[v1377] then sessionStats.petTypes[v1377]={count=0,totalKG=0,minKG=math.huge,maxKG=0}
end local v1380=sessionStats.petTypes[v1377]
v1380.count=v1380.count + 1
v1380.totalKG=v1380.totalKG + v1378
v1380.minKG=math.min(v1380.minKG,v1378)
v1380.maxKG=math.max(v1380.maxKG,v1378)
local v1385=cfg.autoHatch.specialBronto
if (v1385 and v1385.enabled and v1385.pets[v1377]) then task.spawn(function() task.wait(1)
    local v3520=findPetTool(v1375.uuid)
    if (v3520 and (v3520:GetAttribute(ATTR_FAVORITED)~=true)) then pcall(function() FavRemote:FireServer(v3520)
    end)
task.wait(0.3)
end local v3521=(v1375.data.PetData and (v1375.data.PetData.Level or 0)) or 0
local v3522=cfg.autoHatch.eggName or "?"
task.wait(1)
local v3523=v1378
local v3524=findPetTool(v1375.uuid)
if v3524 then local v4017=v3524:GetAttribute("KG")
    if v4017 then v3523=v4017
    else local v4207=v3524.Name:match("%[(%d+%.?%d*)%s*KG%]")
    if v4207 then v3523=tonumber(v4207) or v1378
    end end end sendSpecialPetWebhook(v1377,v1378,v3523,v3521,v3522)
end)
end local v1386=getSpecialTier(v1378)
if v1386 then local v3030=sessionStats.specials[v1386]
    v3030.count=v3030.count + 1
    table.insert(v3030.pets,string.format("%s (%.2fkg)",v1377,v1378))
end local v1387=cfg.autoHatch.brontoThresh or 4
if (v1378>=v1387) then local v3032=(v1375.data.PetData and (v1375.data.PetData.Level or 0)) or 0
    local v3033=cfg.autoHatch.eggName or "?"
    task.spawn(function() task.wait(2)
    local v3525=v1378
    local v3526=findPetTool(v1375.uuid)
    if v3526 then local v4018=v3526:GetAttribute("KG")
        if v4018 then v3525=v4018
        else local v4208=v3526.Name:match("%[(%d+%.?%d*)%s*KG%]")
        if v4208 then v3525=tonumber(v4208) or v1378
        end end end sendSpecialPetWebhook(v1377,v1378,v3525,v3032,v3033)
end)
end end end local function getTeamSummaryStr(v356) if not v356 then return "None"
end local v357=getTeamUUIDs(v356)
if ( #v357==0) then return "None"
end local v358=getInventory()
local v359={}
for v1388,v1389 in ipairs(v357) do local v1390=v358[v1389]
    if not v1390 then continue
    end local v1391=v1390.PetType or "?"
local v1392=(v1390.PetData and (v1390.PetData.MutationType or "")) or ""
local v1393=((v1392~="") and (v1392~="m") and (MutationMap[v1392] or v1392)) or ""
local v1394=((v1393~="") and (v1393 .. " " .. v1391)) or v1391
v359[v1394]=(v359[v1394] or 0) + 1
end local v360={}
for v1396,v1397 in pairs(v359) do table.insert(v360,v1397 .. " " .. v1396 )
end table.sort(v360)
return table.concat(v360,", ")
end local function sendHatchCycleSummary() local v361=os.time() -sessionStats.startTime
local v362=v361/math.max(sessionStats.cycleCount,1)
local v363=sessionStats.eggCurrent-sessionStats.eggBefore
local v364=((v363>=0) and ("+" .. v363)) or tostring(v363)
local v365=((sessionStats.cycleCount>0) and (sessionStats.totalHatched/sessionStats.cycleCount)) or 0
local v366=((v365>0) and string.format("%.2f%%",(sessionStats.koiLastCycle/v365) * 100 )) or "0.00%"
local v367=((v365>0) and string.format("%.2f%%",(sessionStats.sealLastCycle/v365) * 100 )) or "0.00%"
local v368={}
local v369={}
for v1398,v1399 in pairs(sessionStats.petTypes) do table.insert(v369,{name=v1398,data=v1399})
end table.sort(v369,function(v1400,v1401) return v1400.data.count>v1401.data.count
end)
for v1402,v1403 in ipairs(v369) do local v1404=v1403.data
    table.insert(v368,string.format("• %s x%d (%.2f-%.2fkg)",v1403.name,v1404.count,v1404.minKG,v1404.maxKG))
end sendWebhook({{title="🥚 Hatch Cycle #" .. sessionStats.cycleCount ,color=15121980,fields={{name="👤 Profile",value="**Username:** ||" .. LocalPlayer.Name .. "||" ,inline=false},{name="🐾 Teams",value=table.concat({string.format("**Core:** %s",getTeamSummaryStr(cfg.autoHatch.teamCD)),string.format("**Hatch:** %s",getTeamSummaryStr(cfg.autoHatch.teamKoi)),string.format("**Special:** %s",getTeamSummaryStr(cfg.autoHatch.teamBronto)),string.format("**Sell:** %s",getTeamSummaryStr(cfg.autoHatch.teamSeal))},"\n"),inline=false},{name="⚜️ Special Statistics",value=table.concat({string.format("⭐ Special: %d",sessionStats.specials.huge.count + sessionStats.specials.titan.count + sessionStats.specials.godly.count ),((sessionStats.specials.godly.count>0) and string.format(" Godly x%d",sessionStats.specials.godly.count)) or "💛 Godly" ,((sessionStats.specials.titan.count>0) and string.format(" Titan x%d",sessionStats.specials.titan.count)) or "🥈 Titan" ,((sessionStats.specials.huge.count>0) and string.format(" Huge x%d",sessionStats.specials.huge.count)) or "🌟 Huge" },"\n"),inline=false},{name="💎 Overall Statistics",value=(( #v368>0) and table.concat(v368,"\n")) or "No pets hatched" ,inline=false},{name="🥚 Egg Statistics",value=table.concat({string.format("🥚 Egg Before: %d",sessionStats.eggBefore),string.format("📦 Current Egg: %d",sessionStats.eggCurrent),string.format("📊 Net Result: %s",v364),string.format(""),string.format("🍀 Koi Cashback: %d (%s)",sessionStats.koiLastCycle,v366),string.format("🤝 Seal Cashback: %d (%s)",sessionStats.sealLastCycle,v367),string.format("✨ Total Cashback: %d",sessionStats.koiLastCycle + sessionStats.sealLastCycle )},"\n"),inline=false},{name="📈 Hatch Statistics",value=table.concat({string.format("🔄 Hatch Cycles: %d",sessionStats.cycleCount),string.format("🐾 Total Hatched: %d",sessionStats.totalHatched),string.format("🪺 Overall Pet Sell: %d",sessionStats.totalHatched-(sessionStats.koiProc + sessionStats.sealProc) ),string.format(""),string.format("⏱️ Cycle Duration: %s",HydraLib.fmtTime(math.floor(v362))),string.format("🕐 All Time Duration: %s",HydraLib.fmtTime(math.floor(v361)))},"\n"),inline=false}},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local activePetsReplicator=nil

local function getActivePetsReplicator() if not activePetsReplicator then local v2374,v2375=pcall(function() local v3034=require(RS.Modules.ReplicationClass).new("ActivePetsService_Replicator")
    v3034:YieldUntilData()
    return v3034
end)
if v2374 then activePetsReplicator=v2375
end end return activePetsReplicator
end local function getActivePets() local v370=getActivePetsReplicator()
if not v370 then return {}
end local v371,v372=pcall(function() return v370:YieldUntilData().Table
end)
if ( not v371 or not v372) then return {}
end local v373=v372.ActivePetStates
local v374=v373[LocalPlayer.Name] or v373[tonumber(LocalPlayer.Name)] or {}
local v375={}
for v1405 in pairs(v374) do table.insert(v375,v1405)
end return v375
end local globalFlags={IsEquipping=false,PP_Processing={},GlobalBoostApplying=false}
-- ════════════════════════════════════════════════════════
-- § 14 · EQUIP / UNEQUIP UTILITIES
-- ════════════════════════════════════════════════════════
local equipUtils={}
equipUtils.unequipAll=function() globalFlags.IsEquipping=true
for v1406,v1407 in ipairs(getActivePets()) do pcall(function() PetsRemote:FireServer("UnequipPet",v1407)
end)
task.wait(timingCfg.UNEQUIP_DELAY)
end task.wait(timingCfg.UNEQUIP_BUFFER)
globalFlags.IsEquipping=false
end
equipUtils.getFarmCF=function() local v377=workspace:FindFirstChild("Farm")
if v377 then local v2376=v377:FindFirstChild(LocalPlayer.Name)
    if v2376 then local v3527=v2376:FindFirstChild("Important")
        if v3527 then local v4019=v3527:FindFirstChild("Plant_Locations")
            if v4019 then local v4209=v4019:GetChildren()
                if ( #v4209>0) then return v4209[1]:GetPivot()
                end end end end end end
            equipUtils.equipList=function(v378) globalFlags.IsEquipping=true
            local v380=equipUtils.getFarmCF()
            for v1408,v1409 in ipairs(v378) do pcall(function() PetsRemote:FireServer("EquipPet",v1409,v380)
            end)
        task.wait(timingCfg.EQUIP_DELAY)
    end globalFlags.IsEquipping=false
end
equipUtils.waitUntilEquipped=function(v381,v382) v382=v382 or 8
local v383=os.clock()
while (os.clock() -v383)=8) then break
end if (v1414~=v384) then table.insert(v386,v1414)
end end return v386
end
local unequipAll,getFarmCF,equipList,waitUntilEquipped,buildEquipList=equipUtils.unequipAll,equipUtils.getFarmCF,equipUtils.equipList,equipUtils.waitUntilEquipped,equipUtils.buildEquip
-- ════════════════════════════════════════════════════════
-- § 15 · AUTO-EQUIP MAINTAIN LOOP
-- ════════════════════════════════════════════════════════
local autoEquipLoopRunning=false
local autoEquipTargetUUID=nil
local autoEquipTeam={}
local autoEquipTargetSet={}

local function startAutoEquipLoop() autoEquipLoopRunning=true
    task.spawn(function() while autoEquipLoopRunning do task.wait(boostTimingCfg.TEAM_CHECK)
    if (globalFlags.IsEquipping or not isAutoKGRunning) then continue
    end if not next(autoEquipTargetSet) then continue
end local v2382=getActivePets()
local v2383,v2384={},{}
for v3035 in pairs(autoEquipTargetSet) do local v3036=false
    for v3528,v3529 in ipairs(v2382) do if (v3529==v3035) then v3036=true
        break
    end end if not v3036 then table.insert(v2383,v3035)
end end for v3037,v3038 in ipairs(v2382) do if not autoEquipTargetSet[v3038] then table.insert(v2384,v3038)
end end if (( #v2384>0) or ( #v2383>0)) then globalFlags.IsEquipping=true
for v3806,v3807 in ipairs(v2384) do pcall(function() PetsRemote:FireServer("UnequipPet",v3807)
end)
task.wait(timingCfg.UNEQUIP_DELAY)
end local v3531=getFarmCF()
for v3808,v3809 in ipairs(v2383) do pcall(function() PetsRemote:FireServer("EquipPet",v3809,v3531)
end)
task.wait(timingCfg.EQUIP_DELAY)
end globalFlags.IsEquipping=false
end end end)
end local function stopAutoEquipLoop() autoEquipLoopRunning=false
table.clear(autoEquipTargetSet)
autoEquipTeam={}
autoEquipTargetUUID=nil
end local function setAutoEquipTargets(v387,v388) table.clear(autoEquipTargetSet)
for v1415,v1416 in ipairs(v387) do autoEquipTargetSet[v1416]=true
end for v1418,v1419 in ipairs(v388) do autoEquipTargetSet[v1419]=true
end end local function getExtraFillers(v389,v390) local v391=getInventory()
local v392={}
local v393=0
for v1421 in pairs(cfg.elephant.extraPets) do v393=v393 + 1
end print("[FILLER DEBUG] extraPets count:",v393,"maxCount:",v390)
for v1422 in pairs(cfg.elephant.extraPets) do local v1423=v391[v1422]~=nil
    local v1424=v389[v1422]~=nil
    print("[FILLER DEBUG] uuid:",v1422,"inInv:",v1423,"excluded:",v1424)
    if ( not v1424 and v1423) then table.insert(v392,v1422)
    end end table.sort(v392,function(v1425,v1426) return getKG(v1425)>getKG(v1426)
end)
print("[FILLER DEBUG] candidates after filter:", #v392)
local v394={}
for v1427=1,math.min(v390, #v392) do table.insert(v394,v392[v1427])
end print("[FILLER DEBUG] returning:", #v394,"fillers")
return v394
end local function getExtraEleFillers(v395,v396) local v397=getInventory()
local v398={}
for v1428 in pairs(cfg.elephant.extraElePets) do if ( not v395[v1428] and v397[v1428]) then table.insert(v398,v1428)
end end table.sort(v398,function(v1429,v1430) return getKG(v1429)>getKG(v1430)
end)
local v399={}
for v1431=1,math.min(v396, #v398) do table.insert(v399,v398[v1431])
end return v399
end local PetBoostRegistry=require(RS.Data.PetRegistry.PetBoostRegistry)

local function isPetAlreadyBoosted(v400,v401,v402) local v403,v404=pcall(function() return DataService:GetData()
end)
if ( not v403 or not v404) then return false
end local v405=v404.PetsData and v404.PetsData.PetInventory and v404.PetsData.PetInventory.Data
if ( not v405 or not v405[v400]) then return false
end local v406=v405[v400].PetData and v405[v400].PetData.Boosts
if ( not v406 or not next(v406)) then return false
end local v407={}
for v1432,v1433 in pairs(v406) do local v1434=v1433.BoostType or v1433.Type
    local v1435=v1433.BoostAmount or v1433.Amount
    local v1436=PetBoostRegistry.BoostTypeStatData and PetBoostRegistry.BoostTypeStatData[v1434]
    if (v1436 and v1436.Amount) then local v3039=PetBoostRegistry.BoostTypeToPetModelName[v1434]
        for v3532,v3533 in pairs(v1436.Amount) do if (v3533==v1435) then v407[v3532 .. " " .. v3039 ]=true
        end end end end return v407[v401 .. " " .. v402 ]==true
end local function findBoostToolInBackpack(v408,v409) for v1437,v1438 in ipairs(Backpack:GetChildren()) do if (v1438:IsA("Tool") and CS:HasTag(v1438,"PetBoost") and string.find(v1438.Name,v408) and string.find(v1438.Name,v409)) then return v1438
end end return nil
end local function applyBoostToPet(v410,v411,v412) if globalFlags.GlobalBoostApplying then return false
end if isPetAlreadyBoosted(v410,v411,v412) then return false
end local v413=findBoostToolInBackpack(v411,v412)
if not v413 then return false
end globalFlags.GlobalBoostApplying=true
for v1439,v1440 in ipairs(Character:GetChildren()) do if v1440:IsA("Tool") then v1440.Parent=Backpack
end end task.wait(boostTimingCfg.UNEQUIP_WAIT)
pcall(function() v413.Parent=Character
end)
task.wait(boostTimingCfg.EQUIP_WAIT)
pcall(function() BoostRemote:FireServer("ApplyBoost",v410)
end)
task.wait(boostTimingCfg.FIRE_WAIT)
pcall(function() local v1442=Character:FindFirstChildWhichIsA("Tool")
if (v1442 and CS:HasTag(v1442,"PetBoost")) then v1442.Parent=Backpack
end end)
task.wait(0.5)
local v415=isPetAlreadyBoosted(v410,v411,v412)
globalFlags.GlobalBoostApplying=false
return v415
end pcall(function() CoreGui:FindFirstChild("HydraHubUI"):Destroy()
end)
-- ════════════════════════════════════════════════════════
-- § 17 · SCREEN GUI SHELL
-- ════════════════════════════════════════════════════════
local HydraGui=Instance.new("ScreenGui")
HydraGui.Name="HydraHubUI"
HydraGui.ResetOnSpawn=false
HydraGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
HydraGui.IgnoreGuiInset=true
HydraGui.Parent=CoreGui
local viewportSize=workspace.CurrentCamera.ViewportSize
local UISLocal=game:GetService("UserInputService")
local isMobile=UISLocal.TouchEnabled and not UISLocal.KeyboardEnabled
local UI_WIDTH,UI_HEIGHT=420,320
local uiScale=1
if isMobile then local v1443=viewportSize.X/420
    uiScale=math.clamp(v1443 * 0.72 ,0.65,1.4)
end local mainFrame=UI:frame(HydraGui,UDim2.new(0,UI_WIDTH,0,UI_HEIGHT),UDim2.new(0.5, -math.floor(UI_WIDTH/2 ),0.5, -math.floor(UI_HEIGHT/2 )),T.BG)
mainFrame.Active=true
UI:corner(mainFrame,8)
UI:stroke(mainFrame,T.ACCENT,1)
if (isMobile and (uiScale~=1)) then local v1444=Instance.new("UIScale",mainFrame)
    v1444.Scale=uiScale
end local titleBar=UI:frame(mainFrame,UDim2.new(1,0,0,30),nil,T.PANEL)
UI:corner(titleBar,8)
UI:stroke(titleBar,T.STROKE,1)
local logoIcon=Instance.new("ImageLabel",titleBar)
logoIcon.Size=UDim2.new(0,16,0,16)
logoIcon.Position=UDim2.new(0,6,0.5, -8)
logoIcon.BackgroundTransparency=1
logoIcon.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
logoIcon.ScaleType=Enum.ScaleType.Fit
UI:label(titleBar,"|",UDim2.new(0,8,1,0),UDim2.new(0,24,0,0),T.DIM,13,Enum.TextXAlignment.Center)
UI:label(titleBar,"HYDRA HUB",UDim2.new(1, -80,1,0),UDim2.new(0,34,0,0),T.TEXT,12)
local closeBtn=UI:button(titleBar,"X",UDim2.new(0,24,0,22),UDim2.new(1, -28,0.5, -11),T.ERROR,T.TEXT,10)
UI:stroke(closeBtn,T.ERROR,1)
local minimizeBtn=UI:button(titleBar,"-",UDim2.new(0,24,0,22),UDim2.new(1, -56,0.5, -11),T.BTN,T.TEXT,16)
UI:stroke(minimizeBtn,T.STROKE,1)
closeBtn.MouseButton1Click:Connect(function() isAutoKGRunning=false
HydraGui:Destroy()
end)
do local v416,v417,v418,v419=false,nil,nil,nil
titleBar.InputBegan:Connect(function(v1446) if ((v1446.UserInputType==Enum.UserInputType.MouseButton1) or (v1446.UserInputType==Enum.UserInputType.Touch)) then v416=true
v417=v1446
v418=v1446.Position
v419=mainFrame.Position
v1446.Changed:Connect(function() if (v1446.UserInputState==Enum.UserInputState.End) then v416=false
end end)
end end)
titleBar.InputChanged:Connect(function(v1447) if ((v1447.UserInputType==Enum.UserInputType.MouseMovement) or (v1447.UserInputType==Enum.UserInputType.Touch)) then v417=v1447
end end)
UIS.InputChanged:Connect(function(v1448) if ( not v416 or (v1448~=v417)) then return
end local v1449=v1448.Position-v418
mainFrame.Position=UDim2.new(v419.X.Scale,v419.X.Offset + v1449.X ,v419.Y.Scale,v419.Y.Offset + v1449.Y )
end)
end local navBar=UI:frame(mainFrame,UDim2.new(1,0,0,28),UDim2.new(0,0,0,30),T.PANEL)
UI:stroke(navBar,T.STROKE,1)
local NAV_TABS={"MAIN","AUTOMATION","COMING SOON","COMING SOON"}
local navBtns={}
local navPages={}
local contentArea=UI:frame(mainFrame,UDim2.new(1,0,1, -58),UDim2.new(0,0,0,58),T.BG,1)
for v420=1,4 do local v421=UI:frame(contentArea,UDim2.new(1,0,1,0),nil,T.BG,1)
    v421.Visible=v420==1
    navPages[v420]=v421
end local tabWidth=math.floor(420/4 )
for v424,v425 in ipairs(NAV_TABS) do local v426=UI:button(navBar,v425,UDim2.new(0,tabWidth-2 ,0,22),UDim2.new(0,((v424-1) * tabWidth) + 1 ,0.5, -11),((v424==1) and Color3.fromRGB(20,20,20)) or T.BTN ,((v424==1) and T.ACCENT) or T.DIM ,8)
    UI:stroke(v426,T.STROKE,1)
    navBtns[v424]=v426
    v426.MouseButton1Click:Connect(function() for v2385,v2386 in ipairs(navPages) do v2386.Visible=v2385==v424
    navBtns[v2385].BackgroundColor3=((v2385==v424) and Color3.fromRGB(20,20,20)) or T.BTN
    navBtns[v2385].TextColor3=((v2385==v424) and T.ACCENT) or T.DIM
end end)
end for v428,v429 in ipairs({3,4}) do UI:label(navPages[v429],"🔒 COMING SOON",UDim2.new(1,0,0,20),UDim2.new(0,0,0.5, -10),T.DIM,13,Enum.TextXAlignment.Center)
end local function buildAutomationTab() local v430=navPages[2]
local v431=UI:frame(v430,UDim2.new(0,52,1,0),nil,T.SIDEBAR)
UI:stroke(v431,Color3.fromRGB(18,18,18),1)
local v432=UI:sidebar(v431)
local v433=UI:iconBtn(v432,"🍎","FRUIT")
UI:sidebarDivider(v432)
local v434=UI:iconBtn(v432,"🛒","SHOP")
UI:sidebarDivider(v432)
local v435=UI:iconBtn(v432,"🎟️","TRADE")
local v436=UI:frame(v430,UDim2.new(1, -56,1, -2),UDim2.new(0,54,0,1),T.BG,1)
local v437=UI:frame(v436,UDim2.new(1,0,1,0),nil,T.BG,1)
v437.Visible=true
do local v1451=UI:scroll(v437,UDim2.new(1,0,1,0))
v1451.ScrollingDirection=Enum.ScrollingDirection.Y
v1451.AutomaticCanvasSize=Enum.AutomaticSize.Y
v1451.ScrollBarThickness=3
v1451.ScrollBarImageColor3=T.ACCENT
local v1459=Instance.new("Frame",v1451)
v1459.Size=UDim2.new(1,0,0,0)
v1459.BackgroundTransparency=1
v1459.AutomaticSize=Enum.AutomaticSize.Y
UI:list(v1459,6)
UI:pad(v1459,6,6,6,20)
local collectRunning=false
local collectSelFruits=cfg.autoCollect.selFruits
local collectSelVariants=cfg.autoCollect.selVariants
local collectSellAfter=cfg.autoCollect.sellAfter
local collectInterval=cfg.autoCollect.interval
local VARIANT_LIST={"Normal","Gold","Rainbow","Silver","Diamond","Jelly"}
local collectRemotes={SellInv=RS:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"),Teleport=RS:WaitForChild("GameEvents"):WaitForChild("PlayerTeleportTriggered"),_collect=nil}
local SellInvRemote=collectRemotes.SellInv
local TeleportRemote=collectRemotes.Teleport
local CSLocal=game:GetService("CollectionService")

local function getCollectRemote() if collectRemotes._collect then return collectRemotes._collect
end local v2390,v2391=pcall(function() return RS:WaitForChild("GameEvents"):WaitForChild("Crops"):WaitForChild("Collect",5)
end)
if (v2390 and v2391) then collectRemotes._collect=v2391
end return collectRemotes._collect
end local function getMyFarmCollect() local v2392=workspace:FindFirstChild("Farm")
if not v2392 then return nil
end for v3044,v3045 in ipairs(v2392:GetChildren()) do local v3046=v3045:FindFirstChild("Important")
if v3046 then local v3810=v3046:FindFirstChild("Data")
    if v3810 then local v4115=v3810:FindFirstChild("Owner")
        if (v4115 and (v4115.Value==LocalPlayer.Name)) then return v3045
        end end end end return nil
end local function isHarvestableReady(v2393) local v2394=v2393:GetAttribute("DoneGrowTime")
if not v2394 then return false
end if (workspace:GetServerTimeNow()0) and not collectSelFruits[v2395]) then return false
end local v2397=0
for v3048 in pairs(collectSelVariants) do v2397=v2397 + 1
end if (v2397>0) then local v3535=v2393:FindFirstChild("Variant")
local v3536=(v3535 and tostring(v3535.Value)) or "Normal"
if not collectSelVariants[v3536] then return false
end end return true
end local function doSellAll() local v2398=LocalPlayer.Character
if not v2398 then return
end local v2399,v2400=pcall(function() return workspace.Tutorial_Points.Tutorial_Point_2.CFrame
end)
if ( not v2399 or not v2400) then return
end v2398:PivotTo(v2400)
task.wait(0.1)
pcall(function() TeleportRemote:FireServer("Sell Shop")
end)
task.wait(1)
pcall(function() SellInvRemote:FireServer()
end)
task.wait(0.5)
end local function autoSellLoop() while collectSellAfter do task.wait(3)
local v3049=DataService:GetData()
local v3050=0
if (v3049 and v3049.InventoryData) then for v4021,v4022 in pairs(v3049.InventoryData) do if (v4022.ItemType=="Holdable") then v3050=v3050 + 1
end end end if (v3050>=200) then doSellAll()
end end end local stopWhenFull=cfg.autoCollect.stopWhenFull
local maxInvCount=cfg.autoCollect.maxInv

local function getInventoryCount() local v2401=DataService:GetData()
    if ( not v2401 or not v2401.InventoryData) then return 0
    end local v2402=0
for v3051,v3052 in pairs(v2401.InventoryData) do if (v3052.ItemType=="Holdable") then v2402=v2402 + 1
end end return v2402
end local function collectLoop() while collectRunning do if (stopWhenFull and (getInventoryCount()>=maxInvCount)) then task.wait(1)
continue
end local v3053=getMyFarmCollect()
if v3053 then local v3811={}
    local v3812={}
    for v4023,v4024 in ipairs(v3053:GetDescendants()) do if (CSLocal:HasTag(v4024,"Harvestable") and isHarvestableReady(v4024) and not v3812[v4024]) then v3812[v4024]=true
        table.insert(v3811,v4024)
    end end for v4025,v4026 in ipairs(v3811) do if not collectRunning then break
end if (stopWhenFull and (getInventoryCount()>=maxInvCount)) then break
end local v4027=getCollectRemote()
if v4027 then pcall(function() v4027:FireServer({v4026})
end)
end if (collectInterval>0) then task.wait(collectInterval)
end end end task.wait(((collectInterval>0) and collectInterval) or 0.1 )
end end local v1482=UI:accordion(v1459,"🍎 AUTO COLLECT",1,true)
local v1483=v1482.Inner
local v1484=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1484.LayoutOrder=0
UI:corner(v1484,5)
UI:stroke(v1484,T.STROKE,1)
UI:label(v1484,"Interval (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local v1488=UI:input(v1484,collectInterval,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v1488.FocusLost:Connect(function() local v2403=tonumber(v1488.Text)
if (v2403 and (v2403>=0)) then collectInterval=v2403
    cfg.autoCollect.interval=v2403
    saveConfig()
else v1488.Text=tostring(collectInterval)
end end)
local v1489=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1489.LayoutOrder=1
UI:corner(v1489,5)
UI:stroke(v1489,T.STROKE,1)
local v1491=UI:label(v1489,"Fruit: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),T.DIM,9)
v1491.Font=Enum.Font.Gotham
local v1493=UI:button(v1489,"Select >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9)
UI:stroke(v1493,T.STROKE,1)

local function v1494() local v2404=0
    for v3054 in pairs(collectSelFruits) do v2404=v2404 + 1
    end if (v2404==0) then v1491.Text="Fruit: ALL"
v1491.TextColor3=T.DIM
else v1491.Text="Fruit: " .. v2404 .. " selected"
v1491.TextColor3=T.ACCENT
end end v1494()
local v1495=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1495.LayoutOrder=2
UI:corner(v1495,5)
UI:stroke(v1495,T.STROKE,1)
local v1497=UI:label(v1495,"Variant: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),T.DIM,9)
v1497.Font=Enum.Font.Gotham
local v1499=UI:button(v1495,"Select >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9)
UI:stroke(v1499,T.STROKE,1)

local function v1500() local v2405=0
    for v3055 in pairs(collectSelVariants) do v2405=v2405 + 1
    end if (v2405==0) then v1497.Text="Variant: ALL"
v1497.TextColor3=T.DIM
else v1497.Text="Variant: " .. v2405 .. " selected"
v1497.TextColor3=T.ACCENT
end end v1500()
local v1501=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1501.LayoutOrder=25
UI:corner(v1501,5)
UI:stroke(v1501,T.STROKE,1)
UI:label(v1501,"Stop Collect When Full",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local v1505=UI:input(v1501,maxInvCount,"",UDim2.new(0,40,0,20),UDim2.new(1, -94,0.5, -10))
v1505.FocusLost:Connect(function() local v2406=tonumber(v1505.Text)
if (v2406 and (v2406>=1)) then maxInvCount=v2406
    cfg.autoCollect.maxInv=v2406
    saveConfig()
else v1505.Text=tostring(maxInvCount)
end end)
UI:toggle(v1501,UDim2.new(1, -52,0.5, -11),cfg.autoCollect.stopWhenFull,function(v2407) stopWhenFull=v2407
cfg.autoCollect.stopWhenFull=v2407
saveConfig()
end)
local v1506=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1506.LayoutOrder=3
UI:corner(v1506,5)
UI:stroke(v1506,T.STROKE,1)
UI:label(v1506,"Auto Sell All (Inventory Full)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
UI:toggle(v1506,UDim2.new(1, -52,0.5, -11),collectSellAfter,function(v2409) collectSellAfter=v2409
cfg.autoCollect.sellAfter=v2409
saveConfig()
if v2409 then task.spawn(autoSellLoop)
end end)
local v1509=UI:frame(v1483,UDim2.new(1,0,0,26),nil,T.BTN)
v1509.LayoutOrder=5
UI:corner(v1509,5)
UI:stroke(v1509,T.STROKE,1)
UI:label(v1509,"AUTO COLLECT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local v1512=UI:label(v1509,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),T.DIM,8)
v1512.Font=Enum.Font.Gotham
UI:toggle(v1509,UDim2.new(1, -52,0.5, -11),cfg.toggles.autoCollect,function(v2411) collectRunning=v2411
cfg.toggles.autoCollect=v2411
saveConfig()
v1512.Text=(v2411 and "● ON") or "● IDLE"
v1512.TextColor3=(v2411 and T.SUCCESS) or T.DIM
if v2411 then task.spawn(collectLoop)
end end)
if cfg.toggles.autoCollect then collectRunning=true
    task.defer(function() task.spawn(collectLoop)
end)
end local v1514=UI:frame(v437,UDim2.new(1,0,1,0),nil,T.BG)
v1514.Visible=false
v1514.ZIndex=25
local v1517=UI:frame(v1514,UDim2.new(1,0,0,26),nil,T.PANEL)
UI:stroke(v1517,T.STROKE,1)
UI:label(v1517,"Select Fruits to Collect",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10)
local v1518=UI:button(v1517,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8)
UI:stroke(v1518,T.STROKE,1)
local v1519=UI:button(v1517,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10)
UI:stroke(v1519,T.ERROR,1)
v1519.MouseButton1Click:Connect(function() v1514.Visible=false
v1494()
end)
local v1520=UI:input(v1514,"","Search fruit...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1520.TextColor3=T.TEXT
v1520.Font=Enum.Font.Gotham
local v1524=UI:scroll(v1514,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
UI:list(v1524,3)
UI:pad(v1524,3,4,4,3)
local v1525={}
do local v2416={}
local v2417,v2418=pcall(function() return game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/fruits.json")
end)
if (v2417 and v2418) then local v3553,v3554=pcall(function() return Http:JSONDecode(v2418)
end)
if (v3553 and v3554) then for v4116,v4117 in ipairs(v3554) do if not v2416[v4117] then v2416[v4117]=true
    table.insert(v1525,v4117)
end end end end end table.sort(v1525)

local function v1526() for v3056,v3057 in ipairs(v1524:GetChildren()) do if v3057:IsA("GuiObject") then v3057:Destroy()
end end local v2419=string.lower(v1520.Text)
local v2420={}
for v3058,v3059 in ipairs(v1525) do if ((v2419=="") or v3059:lower():find(v2419,1,true)) then table.insert(v2420,v3059)
end end local v2421= #v2420>0
for v3060,v3061 in ipairs(v2420) do if not collectSelFruits[v3061] then v2421=false
    break
end end v1518.Text=(( #v2420==0) and "Select All") or (v2421 and "Unselect All") or "Select All"
v1518.TextColor3=(v2421 and T.SEL_TXT) or T.ACCENT
v1518.BackgroundColor3=(v2421 and T.SEL_BG) or T.BTN
for v3062,v3063 in ipairs(v2420) do local v3064=collectSelFruits[v3063]==true
    local v3065=UI:button(v1524,v3063,UDim2.new(1,0,0,24),nil,(v3064 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3064 and T.SEL_TXT) or T.TEXT ,9)
    v3065.LayoutOrder=v3062
    v3065.TextXAlignment=Enum.TextXAlignment.Left
    UI:pad(v3065,0,8,4,0)
    UI:corner(v3065,4)
    UI:stroke(v3065,(v3064 and T.ACCENT) or T.STROKE ,1)
    v3065.MouseButton1Click:Connect(function() if collectSelFruits[v3063] then collectSelFruits[v3063]=nil
else collectSelFruits[v3063]=true
end cfg.autoCollect.selFruits=collectSelFruits
saveConfig()
v1494()
UI:updateRowVisual(v3065,collectSelFruits[v3063]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE)
end)
end end v1518.MouseButton1Click:Connect(function() local v2425=string.lower(v1520.Text)
local v2426={}
for v3069,v3070 in ipairs(v1525) do if ((v2425=="") or v3070:lower():find(v2425,1,true)) then table.insert(v2426,v3070)
end end local v2427= #v2426>0
for v3071,v3072 in ipairs(v2426) do if not collectSelFruits[v3072] then v2427=false
    break
end end if v2427 then for v3813,v3814 in ipairs(v2426) do collectSelFruits[v3814]=nil
end else for v3816,v3817 in ipairs(v2426) do collectSelFruits[v3817]=true
end end cfg.autoCollect.selFruits=collectSelFruits
saveConfig()
v1494()
v1526()
end)
v1520:GetPropertyChangedSignal("Text"):Connect(v1526)
v1493.MouseButton1Click:Connect(function() v1514.Visible=true
v1526()
end)
local v1527=UI:frame(v437,UDim2.new(1,0,1,0),nil,T.BG)
v1527.Visible=false
v1527.ZIndex=25
local v1530=UI:frame(v1527,UDim2.new(1,0,0,26),nil,T.PANEL)
UI:stroke(v1530,T.STROKE,1)
UI:label(v1530,"Select Variants to Collect",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),T.ACCENT,10)
local v1531=UI:button(v1530,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10)
UI:stroke(v1531,T.ERROR,1)
v1531.MouseButton1Click:Connect(function() v1527.Visible=false
v1500()
end)
local v1532=UI:scroll(v1527,UDim2.new(1,0,1, -32),UDim2.new(0,0,0,32))
UI:list(v1532,4)
UI:pad(v1532,4,4,4,4)

local function v1533() for v3073,v3074 in ipairs(v1532:GetChildren()) do if v3074:IsA("GuiObject") then v3074:Destroy()
end end for v3075,v3076 in ipairs(VARIANT_LIST) do local v3077=collectSelVariants[v3076]==true
local v3078=UI:button(v1532,v3076,UDim2.new(1,0,0,28),nil,(v3077 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3077 and T.SEL_TXT) or T.TEXT ,10)
v3078.LayoutOrder=v3075
v3078.TextXAlignment=Enum.TextXAlignment.Left
UI:pad(v3078,0,8,0,0)
UI:corner(v3078,5)
UI:stroke(v3078,(v3077 and T.ACCENT) or T.STROKE ,1)
v3078.MouseButton1Click:Connect(function() if collectSelVariants[v3076] then collectSelVariants[v3076]=nil
else collectSelVariants[v3076]=true
end cfg.autoCollect.selVariants=collectSelVariants
saveConfig()
v1500()
UI:updateRowVisual(v3078,collectSelVariants[v3076]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE)
end)
end end v1499.MouseButton1Click:Connect(function() v1527.Visible=true
v1533()
end)
local plantRunning=false
local plantInterval=1
local PlantRemote=RS:WaitForChild("GameEvents"):WaitForChild("Plant_RE")

local function getSeedFromChar() for v3082,v3083 in ipairs(Character:GetChildren()) do if (v3083:IsA("Tool") and (v3083:GetAttribute("Seed")~=nil)) then return v3083:GetAttribute("Seed"),v3083
end end return nil,nil
end local function getPlantLocsCollect(v2432) local v2433={}
local v2434=v2432 and v2432:FindFirstChild("Important")
if not v2434 then return v2433
end local v2435=v2434:FindFirstChild("Plant_Locations")
if not v2435 then return v2433
end for v3084,v3085 in ipairs(v2435:GetChildren()) do if v3085:IsA("BasePart") then table.insert(v2433,v3085)
end end return v2433
end local function generatePlantPositions(v2436,v2437,v2438) local v2439=getPlantLocsCollect(v2436)
if ( #v2439==0) then return {}
end local v2440={}
for v3086,v3087 in ipairs(v2439) do if ( #v2440>=v2437) then break
end local v3088=v3087.CFrame
local v3089=v3087.Size.X
local v3090=v3087.Size.Z
local v3091=3
local v3092=math.max(1,math.floor((v3089-(v3091 * 2))/v2438 ))
local v3093=math.max(1,math.floor((v3090-(v3091 * 2))/v2438 ))
local v3094=( -(v3092-1) * v2438)/2
local v3095=( -(v3093-1) * v2438)/2
for v3557=0,v3093-1 do for v3819=0,v3092-1 do if ( #v2440>=v2437) then break
end local v3820=(v3088 * CFrame.new(v3094 + (v3819 * v2438) ,0,v3095 + (v3557 * v2438) )).Position
table.insert(v2440,Vector3.new(v3820.X,0.135,v3820.Z))
end if ( #v2440>=v2437) then break
end end end return v2440
end local function plantLoop() while plantRunning do local v3096=getMyFarmCollect()
if v3096 then local v3821,v3822=getSeedFromChar()
    if (v3821 and v3822) then local v4118=generatePlantPositions(v3096,200,3)
        for v4211,v4212 in ipairs(v4118) do if not plantRunning then break
        end local v4213,v4211=getSeedFromChar()
    if not v4213 then break
    end pcall(function() PlantRemote:FireServer(Vector3.new(v4212.X,v4212.Y,v4212.Z),v4213)
end)
task.wait(0.1)
end end end task.wait(plantInterval)
end end local v1541=UI:accordion(v1459,"🌱 AUTO PLANT",3,false)
local v1542=v1541.Inner
local v1543=UI:frame(v1542,UDim2.new(1,0,0,26),nil,T.BTN)
v1543.LayoutOrder=0
UI:corner(v1543,5)
UI:stroke(v1543,T.STROKE,1)
UI:label(v1543,"Interval (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local v1546=UI:input(v1543,plantInterval,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v1546.FocusLost:Connect(function() local v2441=tonumber(v1546.Text)
if (v2441 and (v2441>0)) then plantInterval=v2441
    cfg.autoCollect.interval=v2441
    saveConfig()
else v1546.Text=tostring(plantInterval)
end end)
local v1547=UI:frame(v1542,UDim2.new(1,0,0,26),nil,T.BTN)
v1547.LayoutOrder=2
UI:corner(v1547,5)
UI:stroke(v1547,T.STROKE,1)
UI:label(v1547,"AUTO PLANT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local v1550=UI:label(v1547,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),T.DIM,8)
v1550.Font=Enum.Font.Gotham
UI:toggle(v1547,UDim2.new(1, -52,0.5, -11),false,function(v2442) plantRunning=v2442
v1550.Text=(v2442 and "● ON") or "● IDLE"
v1550.TextColor3=(v2442 and T.SUCCESS) or T.DIM
if v2442 then task.spawn(plantLoop)
end end)
end local v439=UI:frame(v436,UDim2.new(1,0,1,0),nil,T.BG,1)
v439.Visible=false
do local v1552=UI:scroll(v439,UDim2.new(1,0,1,0))
v1552.ScrollingDirection=Enum.ScrollingDirection.Y
v1552.AutomaticCanvasSize=Enum.AutomaticSize.Y
v1552.ScrollBarThickness=3
v1552.ScrollBarImageColor3=T.ACCENT
local v1560=Instance.new("Frame",v1552)
v1560.Size=UDim2.new(1,0,0,0)
v1560.BackgroundTransparency=1
v1560.AutomaticSize=Enum.AutomaticSize.Y
UI:list(v1560,6)
UI:pad(v1560,6,6,6,20)
UI:label(v1560,"🚧 Coming Soon",UDim2.new(1,0,0,20),nil,T.DIM,10,Enum.TextXAlignment.Center).LayoutOrder=1
end local v441=UI:frame(v436,UDim2.new(1,0,1,0),nil,T.BG,1)
v441.Visible=false
do local v1565=RS:WaitForChild("GameEvents"):WaitForChild("GiftPet")
local v1566=RS:WaitForChild("GameEvents"):WaitForChild("AcceptPetGift")
local v1567=RS:WaitForChild("GameEvents"):WaitForChild("PetGiftingService",10)
if not v1567 then warn("[AutoGift] PetGiftingService not found!")
end local giftRunning=cfg.autoTrade.autoGift
local acceptGiftEnabled=cfg.autoTrade.autoAccept
local giftTargetPlayer=cfg.autoTrade.targetPlayer
local giftSelPets=cfg.autoTrade.selPets
local giftAcceptConn=nil
local v1573=UI:scroll(v441,UDim2.new(1,0,1,0))
v1573.ScrollingDirection=Enum.ScrollingDirection.Y
v1573.AutomaticCanvasSize=Enum.AutomaticSize.Y
v1573.ScrollBarThickness=3
v1573.ScrollBarImageColor3=T.ACCENT
local v1581=Instance.new("Frame",v1573)
v1581.Size=UDim2.new(1,0,0,0)
v1581.BackgroundTransparency=1
v1581.AutomaticSize=Enum.AutomaticSize.Y
UI:list(v1581,6)
UI:pad(v1581,6,6,6,20)
local v1585=UI:accordion(v1581,"AUTO ACCEPT GIFT",1,true)
local v1586=v1585.Inner
local v1587=UI:frame(v1586,UDim2.new(1,0,0,26),nil,T.BTN)
v1587.LayoutOrder=1
UI:corner(v1587,5)
UI:stroke(v1587,T.STROKE,1)
UI:label(v1587,"AUTO ACCEPT ALL",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local v1591=UI:label(v1587,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),T.DIM,8)
v1591.Font=Enum.Font.Gotham
if acceptGiftEnabled then v1591.Text="● ON"
    v1591.TextColor3=T.SUCCESS
    giftAcceptConn=v1565.OnClientEvent:Connect(function(v3560,v3561,v3562) if not acceptGiftEnabled then return
end task.wait(0.1)
trackEvent("trade_gift_accept",{sender_username=tostring(v3562 or "?" ),pet_name=(v3561 and v3561.PetType and tostring(v3561.PetType)) or "?" ,pet_kg=(v3561 and v3561.PetData and v3561.PetData.BaseWeight and v3561.PetData.BaseWeight) or 0 ,pet_uuid=tostring(v3560 or "?" )})
pcall(function() v1566:FireServer(true,v3560)
end)
end)
end UI:toggle(v1587,UDim2.new(1, -52,0.5, -11),acceptGiftEnabled,function(v2445) acceptGiftEnabled=v2445
cfg.autoTrade.autoAccept=v2445
saveConfig()
v1591.Text=(v2445 and "● ON") or "● IDLE"
v1591.TextColor3=(v2445 and T.SUCCESS) or T.DIM
if v2445 then giftAcceptConn=v1565.OnClientEvent:Connect(function(v3823,v3824,v3825) if not acceptGiftEnabled then return
end task.wait(0.1)
trackEvent("trade_gift_accept",{sender_username=tostring(v3825 or "?" ),pet_name=(v3824 and v3824.PetType and tostring(v3824.PetType)) or "?" ,pet_kg=(v3824 and v3824.PetData and v3824.PetData.BaseWeight and v3824.PetData.BaseWeight) or 0 ,pet_uuid=tostring(v3823 or "?" )})
pcall(function() local v4032=LocalPlayer.PlayerGui:FindFirstChild("Gift_Notification")
if not v4032 then return
end local v4033=v4032:FindFirstChild("Frame")
if not v4033 then return
end for v4119,v4120 in ipairs(v4033:GetChildren()) do if v4120:IsA("GuiObject") then v4120:Destroy()
end end end)
pcall(function() v1566:FireServer(true,v3823)
end)
end)
elseif giftAcceptConn then giftAcceptConn:Disconnect()
giftAcceptConn=nil
end end)
local v1594=UI:accordion(v1581," AUTO GIFT PET",3,false)
local v1595=v1594.Inner
local v1596=UI:frame(v1595,UDim2.new(1,0,0,13),nil,T.BG,1)
v1596.LayoutOrder=0
UI:label(v1596,"TARGET PLAYER",UDim2.new(1,0,1,0),nil,T.DIM,8).Font=Enum.Font.Gotham
local v1599=UI:frame(v1595,UDim2.new(1,0,0,26),nil,T.BG,1)
v1599.LayoutOrder=1
local v1601=UI:button(v1599,giftTargetPlayer or "None selected" ,UDim2.new(1, -56,1,0),nil,T.BTN,T.TEXT,9)
v1601.TextXAlignment=Enum.TextXAlignment.Left
UI:pad(v1601,0,8,8,0)
UI:stroke(v1601,T.STROKE,1)
UI:label(v1599,"v",UDim2.new(0,16,1,0),UDim2.new(1, -76,0,0),T.DIM,9,Enum.TextXAlignment.Center)
local v1604=Instance.new("ImageButton",v1599)
v1604.Size=UDim2.new(0,24,0,24)
v1604.Position=UDim2.new(1, -28,0.5, -12)
v1604.BackgroundColor3=T.BTN
v1604.BorderSizePixel=0
v1604.Image="rbxthumb://type=Asset&id=98916802076487&w=150&h=150"
v1604.ScaleType=Enum.ScaleType.Fit
UI:corner(v1604,5)
UI:stroke(v1604,T.ACCENT,1)
local v1613=UI:frame(v1595,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10))
v1613.LayoutOrder=2
v1613.Visible=false
UI:corner(v1613,5)
UI:stroke(v1613,T.STROKE,1)
local v1616=UI:scroll(v1613)
UI:list(v1616,2)
UI:pad(v1616,2,2,2,2)
local v1617=false

local function v1618() for v3100,v3101 in ipairs(v1616:GetChildren()) do if v3101:IsA("GuiObject") then v3101:Destroy()
end end local v2449=game:GetService("Players"):GetPlayers()
local v2450=0
for v3102,v3103 in ipairs(v2449) do if (v3103.Name==LocalPlayer.Name) then continue
end v2450=v2450 + 1
local v3104=giftTargetPlayer==v3103.Name
local v3105=UI:button(v1616,v3103.Name,UDim2.new(1,0,0,22),nil,(v3104 and T.SEL_BG) or Color3.fromRGB(14,14,14) ,(v3104 and T.SEL_TXT) or T.TEXT ,9)
v3105.LayoutOrder=v2450
v3105.TextXAlignment=Enum.TextXAlignment.Left
UI:pad(v3105,0,8,0,0)
UI:stroke(v3105,(v3104 and T.ACCENT) or T.STROKE ,1)
v3105.MouseButton1Click:Connect(function() giftTargetPlayer=v3103.Name
cfg.autoTrade.targetPlayer=v3103.Name
saveConfig()
v1601.Text=v3103.Name
v1613.Visible=false
v1617=false
end)
end if (v2450==0) then local v3567=UI:label(v1616," (no other players)",UDim2.new(1,0,0,22),nil,T.DIM,9)
v3567.LayoutOrder=1
v2450=1
end v1613.Size=UDim2.new(1,0,0,math.min((v2450 * 24) + 6 ,100))
end v1601.MouseButton1Click:Connect(function() v1617= not v1617
v1613.Visible=v1617
if v1617 then v1618()
end end)
v1604.MouseButton1Click:Connect(function() if v1617 then v1618()
end end)
UI:divider(v1595,3)
local v1619=UI:frame(v1595,UDim2.new(1,0,0,26),nil,T.BG,1)
v1619.LayoutOrder=4
local v1621=UI:label(v1619,"Pets: NONE",UDim2.new(1, -96,1,0),UDim2.new(0,4,0,0),T.DIM,9)
v1621.Font=Enum.Font.Gotham
local v1623=UI:button(v1619,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9)
UI:stroke(v1623,T.STROKE,1)

local function v1624() local v2453=0
    for v3109 in pairs(giftSelPets) do v2453=v2453 + 1
    end if (v2453==0) then v1621.Text="Pets: NONE"
v1621.TextColor3=T.DIM
else v1621.Text="Pets: " .. v2453 .. " selected"
v1621.TextColor3=T.ACCENT
end end v1624()

local function v1625(v2454,v2455,v2456,v2457) local v2458=UI:frame(v1595,UDim2.new(1,0,0,26),nil,T.BTN)
    v2458.LayoutOrder=v2455
    UI:corner(v2458,5)
    UI:stroke(v2458,T.STROKE,1)
    UI:label(v2458,v2454,UDim2.new(0,30,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
    local v2462=cfg.autoTrade[v2456] or "Above"
    local v2463=UI:button(v2458,v2462,UDim2.new(0,46,0,20),UDim2.new(0,38,0.5, -10),T.PANEL,T.ACCENT,8)
    UI:stroke(v2463,T.STROKE,1)
    local v2464=cfg.autoTrade[v2457] or 0
    local v2465=UI:input(v2458,tostring(v2464),"",UDim2.new(0,50,0,20),UDim2.new(1, -54,0.5, -10))
    local v2466=v2462
    v2463.MouseButton1Click:Connect(function() v2466=((v2466=="Above") and "Below") or "Above"
    v2463.Text=v2466
    cfg.autoTrade[v2456]=v2466
    saveConfig()
end)
v2465.FocusLost:Connect(function() local v3112=tonumber(v2465.Text)
if (v3112 and (v3112>=0)) then cfg.autoTrade[v2457]=v3112
    saveConfig()
else v2465.Text=tostring(cfg.autoTrade[v2457] or 0 )
end end)
return v2465,function() return v2466
end,function() return tonumber(v2465.Text) or 0
end
end local v1626,v1627,v1628=v1625("KG",5,"kgMode","kgVal")
local v1629,v1630,v1631=v1625("Age",6,"ageMode","ageVal")
if (cfg.autoTrade.forceGiftFav==nil) then cfg.autoTrade.forceGiftFav=false
end local v1632=UI:frame(v1595,UDim2.new(1,0,0,26),nil,T.BTN)
v1632.LayoutOrder=7
UI:corner(v1632,5)
UI:stroke(v1632,T.STROKE,1)
UI:label(v1632,"Force Gift Favorited (UnFavorite Before Gift)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
UI:toggle(v1632,UDim2.new(1, -52,0.5, -11),cfg.autoTrade.forceGiftFav,function(v2467) cfg.autoTrade.forceGiftFav=v2467
saveConfig()
end)
local v1635=UI:frame(v1595,UDim2.new(1,0,0,28),nil,T.PANEL)
v1635.LayoutOrder=8
UI:stroke(v1635,T.STROKE,1)
UI:label(v1635,"AUTO GIFT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local v1638=UI:label(v1635,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),T.DIM,8)
v1638.Font=Enum.Font.Gotham

local function isGiftable(v2469) local v2470=getInventory()
    local v2471=v2470[v2469]
    if not v2471 then return false
    end local v2472=getBaseWeight(v2469)
local v2473=(v2471.PetData and (v2471.PetData.Level or 0)) or 0
local v2474=v1628()
local v2475=v1631()
local v2476=(v2474==0) or ((v1627()=="Above") and (v2472>=v2474)) or ((v1627()=="Below") and (v2472<=v2474))
local v2477=(v2475==0) or ((v1630()=="Above") and (v2473>=v2475)) or ((v1630()=="Below") and (v2473<=v2475))
return v2476 and v2477
end local function giftLoop() while giftRunning do if not giftTargetPlayer then v1638.Text="No target!"
v1638.TextColor3=T.ERROR
task.wait(1)
continue
end local v3114=game:GetService("Players"):FindFirstChild(giftTargetPlayer)
if not v3114 then v1638.Text="Player offline"
    v1638.TextColor3=T.DIM
    task.wait(2)
    continue
end local v3115=getInventory()
local v3116={}
local v3117=0
for v3575 in pairs(giftSelPets) do v3117=v3117 + 1
end if (v3117==0) then v1638.Text="No pets selected!"
v1638.TextColor3=T.ERROR
task.wait(2)
continue
end for v3576 in pairs(v3115) do local v3577=v3115[v3576]
if not v3577 then continue
end local v3578=v3577.PetType or ""
local v3579=giftSelPets[v3578]
if (v3579 and isGiftable(v3576)) then table.insert(v3116,v3576)
end end if ( #v3116==0) then v1638.Text="No matching pets"
v1638.TextColor3=T.DIM
task.wait(2)
continue
end for v3580,v3581 in ipairs(v3116) do if not giftRunning then break
end for v3840,v3841 in ipairs(Character:GetChildren()) do if v3841:IsA("Tool") then v3841.Parent=Backpack
end end task.wait(0.3)
local v3582=findPetTool(v3581)
if not v3582 then v1638.Text="Skip-no tool: " .. getPetType(v3581)
    v1638.TextColor3=T.ERROR
    continue
end local v3583=findPetTool(v3581)
if (v3583 and (v3583:GetAttribute(ATTR_FAVORITED)==true)) then if cfg.autoTrade.forceGiftFav then v1638.Text="Unfav: " .. getPetType(v3581)
    v1638.TextColor3=T.DIM
    local v4217=RS:WaitForChild("GameEvents"):WaitForChild("Favorite_Item")
    v4217:FireServer(v3583)
    local v4218=os.clock()
    repeat task.wait(0.1)
until (findPetTool(v3581)==nil) or (findPetTool(v3581) and (findPetTool(v3581):GetAttribute(ATTR_FAVORITED)~=true)) or ((os.clock() -v4218)>3) task.wait(0.5)
v3582=findPetTool(v3581)
if not v3582 then continue
end if (v3582:GetAttribute(ATTR_FAVORITED)==true) then v1638.Text="Still fav, skip: " .. getPetType(v3581)
v1638.TextColor3=T.ERROR
continue
end else v1638.Text="Skip-fav: " .. getPetType(v3581)
v1638.TextColor3=T.DIM
continue
end end _G.VoidHub_GiftingActive=true
v3582.Parent=Character
task.wait(1)
v1638.Text="Gifting " .. getPetType(v3581)
v1638.TextColor3=T.SUCCESS
local v3588=RS:FindFirstChild("GameEvents")
local v3589=v3588 and v3588:FindFirstChild("PetGiftingService")
if v3589 then pcall(function() v3589:FireServer("GivePet",v3114)
end)
trackEvent("trade_gift_send",{target_username=giftTargetPlayer or "?" ,pet_name=getPetType(v3581),pet_kg=getBaseWeight(v3581),pet_age=getAge(v3581),pet_mut=getMutationName(v3581)})
else v1638.Text="Remote not found!"
v1638.TextColor3=T.ERROR
end task.wait(1.5)
_G.VoidHub_GiftingActive=false
end task.wait(1)
end v1638.Text="● IDLE"
v1638.TextColor3=T.DIM
end UI:toggle(v1635,UDim2.new(1, -52,0.5, -11),giftRunning,function(v2481) giftRunning=v2481
cfg.autoTrade.autoGift=v2481
saveConfig()
v1638.Text=(v2481 and "● ON") or "● IDLE"
v1638.TextColor3=(v2481 and T.SUCCESS) or T.DIM
if not v2481 then _G.VoidHub_GiftingActive=false
end if v2481 then task.spawn(giftLoop)
end end)
if giftRunning then task.defer(function() task.spawn(giftLoop)
end)
end local v1642=UI:frame(v441,UDim2.new(1,0,1,0),nil,T.BG)
v1642.Visible=false
v1642.ZIndex=25
local v1645=UI:frame(v1642,UDim2.new(1,0,0,26),nil,T.PANEL)
UI:stroke(v1645,T.STROKE,1)
UI:label(v1645,"Select Pets to Gift",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10)
local v1646=UI:button(v1645,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8)
UI:stroke(v1646,T.STROKE,1)
local v1647=UI:button(v1645,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10)
UI:stroke(v1647,T.ERROR,1)
v1647.MouseButton1Click:Connect(function() v1642.Visible=false
v1624()
end)
local v1648=UI:input(v1642,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1648.TextColor3=T.TEXT
v1648.Font=Enum.Font.Gotham
local v1652=UI:scroll(v1642,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
UI:list(v1652,3)
UI:pad(v1652,3,4,4,3)

local function v1653() for v3118,v3119 in ipairs(v1652:GetChildren()) do if v3119:IsA("GuiObject") then v3119:Destroy()
end end local v2486=string.lower(v1648.Text)
local v2487={}
local v2488={}
for v3120,v3121 in ipairs(PetsData) do if not v2487[v3121.name] then v2487[v3121.name]=true
    if ((v2486=="") or v3121.name:lower():find(v2486,1,true)) then table.insert(v2488,v3121)
    end end end local v2489= #v2488>0
for v3122,v3123 in ipairs(v2488) do if not giftSelPets[v3123.name] then v2489=false
    break
end end v1646.Text=(( #v2488==0) and "Select All") or (v2489 and "Unselect All") or "Select All"
v1646.TextColor3=(v2489 and T.SEL_TXT) or T.ACCENT
v1646.BackgroundColor3=(v2489 and T.SEL_BG) or T.BTN
for v3124,v3125 in ipairs(v2488) do local v3126=giftSelPets[v3125.name]==true
    local v3127=UI:button(v1652,v3125.name,UDim2.new(1,0,0,30),nil,(v3126 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3126 and T.SEL_TXT) or T.TEXT ,9)
    v3127.LayoutOrder=v3124
    v3127.TextXAlignment=Enum.TextXAlignment.Left
    UI:pad(v3127,0,8,4,0)
    UI:corner(v3127,5)
    UI:stroke(v3127,(v3126 and T.ACCENT) or T.STROKE ,1)
    UI:label(v3127,v3125.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v3126 and Color3.fromRGB(60,40,0)) or T.DIM ,8).Font=Enum.Font.Gotham
    v3127.MouseButton1Click:Connect(function() if giftSelPets[v3125.name] then giftSelPets[v3125.name]=nil
else giftSelPets[v3125.name]=true
end cfg.autoTrade.selPets=giftSelPets
saveConfig()
v1624()
UI:updateRowVisual(v3127,giftSelPets[v3125.name]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE)
end)
end end v1646.MouseButton1Click:Connect(function() local v2493=string.lower(v1648.Text)
local v2494={}
local v2495={}
for v3133,v3134 in ipairs(PetsData) do if not v2495[v3134.name] then v2495[v3134.name]=true
    if ((v2493=="") or v3134.name:lower():find(v2493,1,true)) then table.insert(v2494,v3134)
    end end end local v2496= #v2494>0
for v3135,v3136 in ipairs(v2494) do if not giftSelPets[v3136.name] then v2496=false
    break
end end if v2496 then for v3844,v3845 in ipairs(v2494) do giftSelPets[v3845.name]=nil
end else for v3847,v3848 in ipairs(v2494) do giftSelPets[v3848.name]=true
end end cfg.autoTrade.selPets=giftSelPets
saveConfig()
v1624()
v1653()
end)
v1648:GetPropertyChangedSignal("Text"):Connect(v1653)
v1623.MouseButton1Click:Connect(function() v1642.Visible=true
v1653()
end)
end local v443={{v433,"fruit"},{v434,"shop"},{v435,"trade"}}

local function v444(v1654) v437.Visible=v1654=="fruit"
    v439.Visible=v1654=="shop"
    v441.Visible=v1654=="trade"
    for v2499,v2500 in ipairs(v443) do v2500[1].SetActive(v2500[2]==v1654 )
    end end v433.Button.MouseButton1Click:Connect(function() v444("fruit")
end)
v434.Button.MouseButton1Click:Connect(function() v444("shop")
end)
v435.Button.MouseButton1Click:Connect(function() v444("trade")
end)
v444("fruit")
end buildAutomationTab()
local mainPage=navPages[1]
local mainSidebar=UI:frame(mainPage,UDim2.new(0,52,1,0),nil,T.SIDEBAR)
UI:stroke(mainSidebar,Color3.fromRGB(18,18,18),1)
local sidebarScroll=Instance.new("ScrollingFrame",mainSidebar)
sidebarScroll.Size=UDim2.new(1,0,1,0)
sidebarScroll.BackgroundTransparency=1
sidebarScroll.BorderSizePixel=0
sidebarScroll.ScrollBarThickness=0
sidebarScroll.ScrollingDirection=Enum.ScrollingDirection.Y
sidebarScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
sidebarScroll.CanvasSize=UDim2.new(0,0,0,0)
local sidebarContent=Instance.new("Frame",sidebarScroll)
sidebarContent.Size=UDim2.new(1,0,0,0)
sidebarContent.BackgroundTransparency=1
sidebarContent.AutomaticSize=Enum.AutomaticSize.Y
local sidebarLayout=Instance.new("UIListLayout",sidebarContent)
sidebarLayout.Padding=UDim.new(0,2)
sidebarLayout.SortOrder=Enum.SortOrder.LayoutOrder
sidebarLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
local sidebarPadding=Instance.new("UIPadding",sidebarContent)
sidebarPadding.PaddingTop=UDim.new(0,6)
sidebarPadding.PaddingBottom=UDim.new(0,6)
local dividerOrder=0

local function addSidebarDivider() dividerOrder=dividerOrder + 1
    local v445=Instance.new("Frame",sidebarContent)
    v445.Size=UDim2.new(0,30,0,1)
    v445.BackgroundColor3=Color3.fromRGB(28,28,40)
    v445.BorderSizePixel=0
    v445.LayoutOrder=dividerOrder * 100
end local iconBtnOrder=0

local function createSidebarIconBtn(v450,v451) iconBtnOrder=iconBtnOrder + 1
    local v452=Instance.new("TextButton",sidebarContent)
    v452.Size=UDim2.new(1, -8,0,38)
    v452.LayoutOrder=(iconBtnOrder * 100) -50
    v452.BackgroundColor3=T.BTN
    v452.BackgroundTransparency=1
    v452.BorderSizePixel=0
    v452.Text=""
    v452.AutoButtonColor=false
    UI:corner(v452,7)
    local v461=Instance.new("Frame",v452)
    v461.Size=UDim2.new(0,2,0,20)
    v461.Position=UDim2.new(0,0,0.5, -10)
    v461.BackgroundColor3=T.ACCENT
    v461.BorderSizePixel=0
    v461.Visible=false
    UI:corner(v461,2)
    local v468=Instance.new("TextLabel",v452)
    v468.Size=UDim2.new(1,0,0,20)
    v468.Position=UDim2.new(0,0,0,5)
    v468.BackgroundTransparency=1
    v468.Text=v450
    v468.TextColor3=T.DIM
    v468.Font=Enum.Font.GothamBold
    v468.TextSize=14
    v468.TextXAlignment=Enum.TextXAlignment.Center
    local v480=Instance.new("TextLabel",v452)
    v480.Size=UDim2.new(1,0,0,10)
    v480.Position=UDim2.new(0,0,0,25)
    v480.BackgroundTransparency=1
    v480.Text=v451
    v480.TextColor3=T.DIM
    v480.Font=Enum.Font.Gotham
    v480.TextSize=7
    v480.TextXAlignment=Enum.TextXAlignment.Center
    v452.MouseEnter:Connect(function() if (v461.Visible==false) then v452.BackgroundTransparency=0.85
    v452.BackgroundColor3=T.ACCENT
    v468.TextColor3=Color3.fromRGB(160,150,220)
    v480.TextColor3=Color3.fromRGB(160,150,220)
end end)
v452.MouseLeave:Connect(function() if (v461.Visible==false) then v452.BackgroundTransparency=1
v452.BackgroundColor3=T.BTN
v468.TextColor3=T.DIM
v480.TextColor3=T.DIM
end end)

local function v490(v1658) v461.Visible=v1658
    if v1658 then v452.BackgroundColor3=Color3.fromRGB(20,20,50)
        v452.BackgroundTransparency=0
        v468.TextColor3=T.ACCENT
        v480.TextColor3=T.ACCENT
    else v452.BackgroundColor3=T.BTN
    v452.BackgroundTransparency=1
    v468.TextColor3=T.DIM
    v480.TextColor3=T.DIM
end end return {Button=v452,SetActive=v490}
end local hatchBtn=createSidebarIconBtn("🥚","HATCH")
local elephantBtn=createSidebarIconBtn("🐘","ELEPHANT")
local levelingBtn=createSidebarIconBtn("⬆","LEVELING")
addSidebarDivider()
local teamsBtn=createSidebarIconBtn("👥","TEAMS")
local pnpBtn=createSidebarIconBtn("👆","PnP")
local boostBtn=createSidebarIconBtn("⚡","BOOST")
addSidebarDivider()
local webhookBtn=createSidebarIconBtn("🔗","WEBHOOK")
addSidebarDivider()
local miscBtn=createSidebarIconBtn("⚙️","MISC")
local mainContent=UI:frame(mainPage,UDim2.new(1, -56,1, -2),UDim2.new(0,54,0,1),T.BG,1)
-- ════════════════════════════════════════════════════════
-- § 18 · AUTO-HATCH PAGE
-- ════════════════════════════════════════════════════════
local hatchPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
hatchPage.Visible=true
local miscPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
miscPage.Visible=false
local FavoriteItemRemote=RS:WaitForChild("GameEvents"):WaitForChild("Favorite_Item")
local SellAllPetsRemote=RS:WaitForChild("GameEvents"):WaitForChild("SellAllPets_RE")
local PetEggServiceRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetEggService")

local function getMyFarm() local v491,v492=pcall(require,RS.Modules.GetFarm)
    if (v491 and v492) then local v2501,v2502=pcall(function() return v492(LocalPlayer)
    end)
if (v2501 and v2502) then return v2502
end end local v493=workspace:FindFirstChild("Farm")
if not v493 then return nil
end for v1660,v1661 in ipairs(v493:GetChildren()) do local v1662=v1661:FindFirstChild("Important")
if v1662 then local v3159=v1662:FindFirstChild("Data")
    if v3159 then local v3850=v3159:FindFirstChild("Owner")
        if (v3850 and (v3850.Value==LocalPlayer.Name)) then return v1661
        end end end end return nil
end local function getPlantLocations(v494) local v495={}
local v496=v494 and v494:FindFirstChild("Important")
if not v496 then return v495
end local v497=v496:FindFirstChild("Plant_Locations")
if not v497 then return v495
end for v1663,v1664 in ipairs(v497:GetChildren()) do if v1664:IsA("BasePart") then table.insert(v495,v1664)
end end return v495
end local function generateEggPositions(v498,v499,v500) local v501=getPlantLocations(v498)
if ( #v501==0) then return {}
end local v502={}
for v1665,v1666 in ipairs(v501) do if ( #v502>=v499) then break
end local v1667=v1666.CFrame
local v1668=v1666.Size.X
local v1669=v1666.Size.Z
local v1670=3
local v1671=math.max(1,math.floor((v1668-(v1670 * 2))/v500 ))
local v1672=math.max(1,math.floor((v1669-(v1670 * 2))/v500 ))
local v1673=( -(v1671-1) * v500)/2
local v1674=( -(v1672-1) * v500)/2
for v2503=0,v1672-1 do for v3160=0,v1671-1 do if ( #v502>=v499) then break
end local v3161=(v1667 * CFrame.new(v1673 + (v3160 * v500) ,0,v1674 + (v2503 * v500) )).Position
table.insert(v502,Vector3.new(v3161.X,0.135,v3161.Z))
end if ( #v502>=v499) then break
end end end return v502
end local function getEggCountOnFarm() local v503=0
for v1675,v1676 in ipairs(CS:GetTagged("PetEggServer")) do if (v1676:GetAttribute("OWNER")==LocalPlayer.Name) then v503=v503 + 1
end end return v503
end local function findEggToolByName(v504) for v1677,v1678 in ipairs(Backpack:GetChildren()) do if (v1678:IsA("Tool") and CS:HasTag(v1678,"PetEggTool")) then if (v1678:GetAttribute("h")==v504) then return v1678
end end end return nil
end local function getPetInventoryCount() local v505=getInventory()
local v506=0
for v1679 in pairs(v505) do v506=v506 + 1
end return v506
end local eggESPRegistry={}
local eggDataCache={}

local function formatTime(v507) if (v507<=0) then return "READY!"
end local v508=math.floor(v507/3600 )
local v509=math.floor((v507%3600)/60 )
local v510=v507%60
if (v508>0) then return string.format("%dh %dm %ds",v508,v509,v510)
elseif (v509>0) then return string.format("%dm %ds",v509,v510)
else return string.format("%ds",v510)
end end local function getEggSaveData(v511) local v512=v511:GetAttribute("OBJECT_UUID")
if not v512 then return nil
end local v513,v514=pcall(function() return DataService:GetData()
end)
if ( not v513 or not v514 or not v514.SaveSlots) then return nil
end for v1680,v1681 in pairs(v514.SaveSlots.AllSlots) do local v1682=(v1681.SavedObjects or {})[v512]
if (v1682 and (type(v1682)=="table") and (v1682.ObjectType=="PetEgg") and v1682.Data) then return v1682.Data
end end return nil
end local function createEggESP(v515) local v516=v515:FindFirstChild("AH_EggESP")
if v516 then v516:Destroy()
end local v517=Instance.new("BillboardGui")
v517.Name="AH_EggESP"
v517.AlwaysOnTop=true
v517.Size=UDim2.new(0,220,0,90)
v517.StudsOffset=Vector3.new(0,5,0)
v517.Parent=v515
local v523=Instance.new("Frame",v517)
v523.Size=UDim2.fromScale(1,1)
v523.BackgroundTransparency=1

local function v526(v1683,v1684,v1685) local v1686=Instance.new("TextLabel",v523)
    v1686.Size=UDim2.new(1,0,0,22)
    v1686.Position=UDim2.new(0,0,0,v1683)
    v1686.BackgroundTransparency=1
    v1686.TextColor3=v1684
    v1686.TextStrokeTransparency=0
    v1686.TextSize=v1685 or 13
    v1686.Font=Enum.Font.GothamBold
    return v1686
end local v527=v526(0,Color3.fromRGB(255,220,50),14)
local v528=v526(23,Color3.fromRGB(100,255,100),13)
local v529=v526(46,Color3.fromRGB(100,200,255),13)
local v530=v526(69,Color3.fromRGB(255,255,255),13)
v527.Text=v515:GetAttribute("EggName") or "?"
v528.Text="🐾 ..."
v529.Text=""
v530.Text=formatTime(v515:GetAttribute("TimeToHatch") or 0 )
return v530,v528,v529
end local function registerEggESP(v535) if (v535:GetAttribute("OWNER")~=LocalPlayer.Name) then return
end if eggESPRegistry[v535] then return
end local v536,v537,v538
if cfg.autoHatch.espEnabled then v536,v537,v538=createEggESP(v535)
else v536={Text="",TextColor3=Color3.new()}
v537={Text=""}
v538={Text=""}
end local v539={timeLbl=v536,petLbl=v537,wgtLbl=v538,loaded=false}
eggESPRegistry[v535]=v539
eggDataCache[v535]={weight=0,petType="?",ready=(v535:GetAttribute("TimeToHatch") or 0)<=0 ,eggName=v535:GetAttribute("EggName") or "" }
v535:GetAttributeChangedSignal("TimeToHatch"):Connect(function() if not eggESPRegistry[v535] then return
end local v1695=v535:GetAttribute("TimeToHatch") or 0
if cfg.autoHatch.espEnabled then v536.Text=formatTime(v1695)
    v536.TextColor3=((v1695<=0) and Color3.fromRGB(100,255,100)) or Color3.fromRGB(255,255,255)
end if eggDataCache[v535] then eggDataCache[v535].ready=v1695<=0
end end)
end for v542,v543 in ipairs(CS:GetTagged("PetEggServer")) do registerEggESP(v543)
end CS:GetInstanceAddedSignal("PetEggServer"):Connect(function(v544) task.wait(0.2)
registerEggESP(v544)
end)
CS:GetInstanceRemovedSignal("PetEggServer"):Connect(function(v545) eggESPRegistry[v545]=nil
eggDataCache[v545]=nil
end)
task.spawn(function() while true do task.wait(0.3)
for v2504,v2505 in pairs(eggESPRegistry) do if ( not v2504 or not v2504.Parent) then eggESPRegistry[v2504]=nil
    eggDataCache[v2504]=nil
    continue
end if not v2505.loaded then local v3593=getEggSaveData(v2504)
if (v3593 and v3593.Type) then v2505.loaded=true
    if cfg.autoHatch.espEnabled then v2505.petLbl.Text="🐾 " .. v3593.Type
        v2505.wgtLbl.Text=string.format("%.2fkg",(v3593.BaseWeight or 0) * 1.1 )
    end if eggDataCache[v2504] then eggDataCache[v2504].weight=(v3593.BaseWeight or 0) * 1.1
eggDataCache[v2504].petType=v3593.Type
end end end end end end)

local function refreshAllESP() for v1696,v1697 in pairs(eggESPRegistry) do if (v1696 and v1696.Parent) then local v3165=v1696:FindFirstChild("AH_EggESP")
    if cfg.autoHatch.espEnabled then if not v3165 then local v4122,v4123,v4124=createEggESP(v1696)
        v1697.timeLbl=v4122
        v1697.petLbl=v4123
        v1697.wgtLbl=v4124
        local v4128=v1696:GetAttribute("TimeToHatch") or 0
        v4122.Text=formatTime(v4128)
        v4122.TextColor3=((v4128<=0) and Color3.fromRGB(100,255,100)) or Color3.fromRGB(255,255,255)
        if (v1697.loaded and eggDataCache[v1696]) then v4123.Text="🐾 " .. (eggDataCache[v1696].petType or "?")
            v4124.Text=string.format("%.2fkg",eggDataCache[v1696].weight or 0 )
        end end elseif v3165 then v3165:Destroy()
end end end end local isAutoHatchRunning=false
local autoHatchThread=nil
local autoFeedEnabled=false
if not cfg.autoHatch.specialBronto then cfg.autoHatch.specialBronto={enabled=true,pets={}}
end local function ahUnequipAll() globalFlags.IsEquipping=true
local v549=getActivePets()
for v1699,v1700 in ipairs(v549) do pcall(function() PetsRemote:FireServer("UnequipPet",v1700)
end)
task.wait(timingCfg.AH_UNEQUIP_DELAY)
end if ( #v549>0) then task.wait(timingCfg.AH_POST_UNEQUIP_BUFFER)
end globalFlags.IsEquipping=false
end local function ahEquipTeam(v550) globalFlags.IsEquipping=true
local v552=getFarmCF()
for v1701,v1702 in ipairs(v550) do pcall(function() PetsRemote:FireServer("EquipPet",v1702,v552)
end)
task.wait(timingCfg.AH_EQUIP_DELAY)
end globalFlags.IsEquipping=false
end local function switchToTeam(v553) if not v553 then return
end local v554=getTeamUUIDs(v553)
if ( #v554==0) then return
end ahUnequipAll()
task.wait(0.5)
ahEquipTeam(v554)
waitUntilEquipped(v554,8)
end local function placeEggs(v555,v556,v557,v558) for v1703,v1704 in ipairs(Character:GetChildren()) do if v1704:IsA("Tool") then v1704.Parent=Backpack
end end task.wait(0.3)
local v559=getMyFarm()
if not v559 then v558("Farm not found!",T.ERROR)
    return
end local v560=getEggCountOnFarm()
local v561=v556-v560
if (v561<=0) then v558("Farm already has " .. v560 .. " egg(s) — skip placing" ,T.DIM)
    return
end task.wait(0.3)
v560=getEggCountOnFarm()
v561=v556-v560
if (v561<=0) then v558("Re-check: farm full " .. v560 .. "/" .. v556 .. " — skip" ,T.DIM)
    return
end local v562=generateEggPositions(v559,200,v557)
if ( #v562==0) then v558("No positions generated!",T.ERROR)
    return
end v558(string.format("Placing %d egg(s) [%s]...",v561,v555),T.ACCENT)
local v563=0
local v564=1
local v565=0
while (v563=v556) then v558(string.format("Farm reached target %d/%d — done!",v1705,v556),T.SUCCESS)
    v563=v561
    break
end if (v564> #v562) then v564=1
v558("Wrap around positions, retry...",T.DIM)
task.wait(0.5)
end local v1706=v562[v564]
local v1707=findEggToolByName(v555)
if not v1707 then v558("No more eggs in backpack!",T.ERROR)
    break
end if cfg.autoHatch.autoSellWhenFull then for v3594,v3595 in ipairs(Character:GetChildren()) do if (v3595:IsA("Tool") and not CS:HasTag(v3595,"PetEggTool")) then v3595.Parent=Backpack
end end end local v1708=getEggCountOnFarm()
v1707.Parent=Character
task.wait(0.01)
PetEggServiceRemote:FireServer("CreateEgg",v1706)
task.wait(0.01)
local v1710=Character:FindFirstChildWhichIsA("Tool")
if (v1710 and CS:HasTag(v1710,"PetEggTool")) then v1710.Parent=Backpack
end local v1711=getEggCountOnFarm()
if (v1711>v1708) then v563=v563 + 1
    v565=0
    v558(string.format("Placed %d/%d",v563,v561),T.SUCCESS)
else v565=v565 + 1
local v3168=Character:FindFirstChildWhichIsA("Tool")
if (v3168 and CS:HasTag(v3168,"PetEggTool")) then v3168.Parent=Backpack
end if (v565>=50) then v558("50 fail streak — waiting 3s before retry...",T.ERROR)
task.wait(3)
v565=0
v564=1
end end v564=v564 + 1
end v558(string.format("Placed %d egg(s)",v563),T.SUCCESS)
end local function waitForHatch(v566,v567) v566("Waiting for eggs to hatch...",T.DIM)
while isAutoHatchRunning do local v1712=false
    for v2506,v2507 in ipairs(CS:GetTagged("PetEggServer")) do if (v2507:GetAttribute("OWNER")==LocalPlayer.Name) then local v3596=v2507:GetAttribute("TimeToHatch") or 0
        if (v3596>0) then v1712=true
            v567(string.format("⏳ Waiting — %s",formatTime(v3596)),T.DIM)
            break
        end end end if not v1712 then break
end task.wait(1)
end end local function hatchReadyEggs(v568,v569,v570) local v571={}
local v572={}
for v1713,v1714 in pairs(eggDataCache) do if (v1713 and v1713.Parent and (v1713:GetAttribute("OWNER")==LocalPlayer.Name)) then local v3169=v1713:GetAttribute("TimeToHatch") or 0
    if (v3169<=0) then if (v569 and (v1714.weight>=v568) and (v1714.weight>0)) then table.insert(v572,v1713)
    else table.insert(v571,v1713)
end end end end local function v573(v1715,v1716,v1717) local v1718=os.clock() + (v1717 or 30)
while isAutoHatchRunning and (os.clock()0) and cfg.autoHatch.teamKoi) then v570(string.format("Koi mode — hatching %d egg(s)", #v571),T.ACCENT)
    switchToTeam(cfg.autoHatch.teamKoi)
    local v2509=getTeamUUIDs(cfg.autoHatch.teamKoi)
    local v2510=waitUntilEquipped(v2509,10)
    if v2510 then v570("✓ Koi team confirmed active!",T.ACCENT)
        task.wait(timingCfg.AH_KOI_SAFE_DELAY)
        v570("Safety delay done, hatching...",T.ACCENT)
    else v570("Koi team timeout — hatching anyway...",T.ERROR)
end for v3172,v3173 in ipairs(v571) do if not isAutoHatchRunning then break
end if (v3173 and v3173.Parent) then task.spawn(function() pcall(function() PetEggServiceRemote:FireServer("HatchPet",v3173)
end)
end)
end end v573(v571,"Koi eggs",30)
task.wait(timingCfg.AH_KOI_POST_HATCH)
elseif ( #v571>0) then v570(string.format("Hatching %d egg(s) (no Koi team)", #v571),T.DIM)
for v3852,v3853 in ipairs(v571) do if not isAutoHatchRunning then break
end if (v3853 and v3853.Parent) then task.spawn(function() pcall(function() PetEggServiceRemote:FireServer("HatchPet",v3853)
end)
end)
end end v573(v571,"Eggs",30)
task.wait(1.5)
end if ( #v572>0) then v570(string.format("Bronto mode — %d egg(s) above %.2fkg", #v572,v568),Color3.fromRGB(200,150,255))
repeat if not cfg.autoHatch.teamBronto then v570("⛔ BRONTO SKIP — no bronto team set! Set team dulu lalu restart.",T.ERROR)
break
end local v3174=getTeamUUIDs(cfg.autoHatch.teamBronto)
if ( #v3174==0) then v570("⛔ BRONTO SKIP — bronto team '" .. cfg.autoHatch.teamBronto .. "' kosong atau tidak valid!" ,T.ERROR)
    break
end local v3175=cfg.petTeams[cfg.autoHatch.teamBronto] or {uuids=v3174}
local v3176={}
for v3597,v3598 in ipairs(PetsData) do local v3599=string.lower(v3598.name or "" )
    if v3599:find("brontosaurus",1,true) then v3176[v3598.name]=true
    end end local v3177={}
for v3600,v3601 in ipairs(PetsData) do local v3602=string.lower(v3601.name or "" )
    if v3602:find("koi",1,true) then v3177[v3601.name]=true
    end end local v3178=getInventory()
local v3179={}
local v3180={}
for v3603,v3604 in ipairs(v3175.uuids) do local v3605=(v3178[v3604] and (v3178[v3604].PetType or "?")) or "?(not in inv)"
    if v3177[v3605] then table.insert(v3180,v3605)
    elseif not v3176[v3605] then table.insert(v3179,v3605)
end end if ( #v3179>0) then v570("BRONTO SKIP - team '" .. cfg.autoHatch.teamBronto .. "' ada pet BUKAN Brontosaurus:" ,T.ERROR)
for v4046,v4047 in ipairs(v3179) do v570(" ! " .. v4047 ,T.ERROR)
end v570(" Fix team kamu lalu restart cycle!",T.ERROR)
break
end if ( #v3180>0) then v570("WARNING: ada Koi di bronto team - hatch anyway",Color3.fromRGB(255,200,50))
for v4048,v4049 in ipairs(v3180) do v570(" ! Koi: " .. v4049 ,Color3.fromRGB(255,200,50))
end end local v3181= #v3175.uuids-#v3180
v570("Team check OK (" .. v3181 .. " Bronto + " .. #v3180 .. " Koi)" ,Color3.fromRGB(200,150,255))
switchToTeam(cfg.autoHatch.teamBronto)
local v3182=getTeamUUIDs(cfg.autoHatch.teamBronto)
local v3183=waitUntilEquipped(v3182,15)
if not v3183 then v570("⛔ BRONTO SKIP — team timeout tidak equipped! Coba lagi next cycle.",T.ERROR)
    break
end v570("✓ Bronto team confirmed active!",Color3.fromRGB(200,150,255))
task.wait(timingCfg.AH_KOI_SAFE_DELAY)
v570("Safety delay done, hatching...",Color3.fromRGB(200,150,255))
for v3606,v3607 in ipairs(v572) do if not isAutoHatchRunning then break
end if (v3607 and v3607.Parent) then task.spawn(function() pcall(function() PetEggServiceRemote:FireServer("HatchPet",v3607)
end)
end)
end end v573(v572,"Bronto eggs",45)
v570("Post-bronto safety delay...",T.DIM)
task.wait(2)
v570("✓ Bronto sequence done!",Color3.fromRGB(200,150,255))
until true end task.wait(0.5)
end local function favoriteAndSell(v574,v575) local v576=cfg.autoHatch.sellPets or {}
local v577=cfg.autoHatch.sellThresh or 0
local v578=cfg.autoHatch.favDelay or 0.1
v574("Favoriting all (except sell targets)...",T.ACCENT)
v575("Favoriting...",T.DIM)
local v579=getInventory()
local v580=0
for v1719,v1720 in pairs(v579) do if not isAutoHatchRunning then break
end local v1721=v1720.PetType or ""
local v1722=(v1720.PetData and v1720.PetData.BaseWeight) or 0
local v1723=false
if v576[v1721] then if (v577<=0) then v1723=true
elseif (v17220) then v586(string.format("🍀 Koi proc: %d egg(s) returned",v588),T.SUCCESS)
end task.wait(0.5)
local v591=getNewPets(v585)
processHatchedPets(v591)
end local function checkSealCashback(v592,v593) local v594=countEggsInBackpack(cfg.autoHatch.eggName)
local v595=math.max(v594-v592 ,0)
sessionStats.sealProc=sessionStats.sealProc + v595
sessionStats.sealLastCycle=v595
if (v595>0) then v593(string.format("🤝 Seal proc: %d egg(s) recovered",v595),T.SUCCESS)
end sessionStats.eggCurrent=countEggsInBackpack(cfg.autoHatch.eggName)
saveSession()
trackEvent("hatch_cycle",{cycle_number=sessionStats.cycleCount,total_hatched=sessionStats.totalHatched,egg_name=cfg.autoHatch.eggName})
sendHatchCycleSummary()
end local function saveSessionMidCycle() if (sessionStats.startTime and (sessionStats.startTime>0)) then saveSession()
end end local function runSingleHatchCycle(v599,v600) local v601=cfg.autoHatch
v600("Placing eggs...",T.ACCENT)
placeEggs(v601.eggName,v601.eggCount,v601.eggSpacing,v599)
task.wait(1)
if not isAutoHatchRunning then return
end if v601.teamCD then v599("Wear CD team...",T.DIM)
v600("CD mode...",T.DIM)
switchToTeam(v601.teamCD)
end waitForHatch(v599,v600)
if not isAutoHatchRunning then return
end v600("Hatching...",T.ACCENT)
local v602=snapshotInventory()
hatchReadyEggs(v601.brontoThresh,v601.brontoEnabled,v599)
task.wait(0.5)
checkKoiCashback(v602,v599)
if not isAutoHatchRunning then return
end local v603=countEggsInBackpack(cfg.autoHatch.eggName)
favoriteAndSell(v599,v600)
task.wait(1)
checkSealCashback(v603,v599)
if not isAutoHatchRunning then return
end ahUnequipAll()
task.wait(0.5)
end local function buildAutoHatchUI() local v604=UI:scroll(hatchPage,UDim2.new(1,0,1,0))
v604.ScrollingDirection=Enum.ScrollingDirection.Y
v604.AutomaticCanvasSize=Enum.AutomaticSize.Y
v604.ScrollBarThickness=3
v604.ScrollBarImageColor3=T.ACCENT
local v612=Instance.new("Frame",v604)
v612.Size=UDim2.new(1,0,0,0)
v612.BackgroundTransparency=1
v612.AutomaticSize=Enum.AutomaticSize.Y
UI:list(v612,6)
UI:pad(v612,6,6,6,80)
local v616=UI:accordion(v612,"🥚 AUTO HATCH",1,true)
local v617=v616.Inner

local function v618(v1729,v1730,v1731,v1732) local v1733=UI:label(v1729,v1730,UDim2.new(1,0,0,13),nil,T.DIM,8)
    v1733.LayoutOrder=v1732
    v1733.Font=Enum.Font.Gotham
    local v1737=UI:frame(v1729,UDim2.new(1,0,0,26),nil,T.BG,1)
    v1737.LayoutOrder=v1732 + 1
    local v1739=UI:button(v1737,cfg.autoHatch[v1731] or "None selected" ,UDim2.new(1,0,1,0),nil,T.BTN,T.TEXT,9)
    v1739.TextXAlignment=Enum.TextXAlignment.Left
    UI:pad(v1739,0,8,8,0)
    UI:stroke(v1739,T.STROKE,1)
    UI:label(v1737,"v",UDim2.new(0,20,1,0),UDim2.new(1, -22,0,0),T.DIM,9,Enum.TextXAlignment.Center)
    local v1742=UI:frame(v1729,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10))
    v1742.LayoutOrder=v1732 + 2
    v1742.Visible=false
    UI:corner(v1742,5)
    UI:stroke(v1742,T.STROKE,1)
    local v1745=UI:scroll(v1742)
    UI:list(v1745,2)
    UI:pad(v1745,2,2,2,2)
    local v1746=false
    local function v1747() for v3185,v3186 in ipairs(v1745:GetChildren()) do if v3186:IsA("GuiObject") then v3186:Destroy()
    end end local v2519={}
if _G._NH_BUILTIN_TEAMS then for v3854,v3855 in ipairs(_G._NH_BUILTIN_TEAMS) do table.insert(v2519,v3855.name)
end end for v3187 in pairs(cfg.petTeams) do table.insert(v2519,v3187)
end table.sort(v2519)
if ( #v2519==0) then local v3611=UI:label(v1745," (save a team first)",UDim2.new(1,0,0,22),nil,T.DIM,9)
    v3611.LayoutOrder=1
    return 1
end local v2520=cfg.autoHatch[v1731]==nil
local v2521=UI:button(v1745,"None",UDim2.new(1,0,0,22),nil,(v2520 and T.SEL_BG) or Color3.fromRGB(14,14,14) ,(v2520 and T.SEL_TXT) or T.TEXT ,9)
v2521.LayoutOrder=0
v2521.TextXAlignment=Enum.TextXAlignment.Left
UI:pad(v2521,0,8,0,0)
UI:stroke(v2521,(v2520 and T.ACCENT) or T.STROKE ,1)
v2521.MouseButton1Click:Connect(function() cfg.autoHatch[v1731]=nil
saveConfig()
v1739.Text="None selected"
v1742.Visible=false
v1746=false
end)
for v3191,v3192 in ipairs(v2519) do local v3193=cfg.autoHatch[v1731]==v3192
    local v3194=false
    if _G._NH_BUILTIN_TEAMS then for v4050,v4051 in ipairs(_G._NH_BUILTIN_TEAMS) do if (v4051.name==v3192) then v3194=true
        break
    end end end local v3195=(v3194 and Color3.fromRGB(40,20,80)) or Color3.fromRGB(14,14,14)
local v3196=(v3194 and Color3.fromRGB(180,160,255)) or T.TEXT
local v3197=(v3194 and Color3.fromRGB(80,60,160)) or T.STROKE
if v3193 then v3195=(v3194 and Color3.fromRGB(80,50,160)) or T.SEL_BG
    v3196=T.SEL_TXT
    v3197=(v3194 and Color3.fromRGB(160,120,255)) or T.ACCENT
end local v3198=UI:button(v1745,v3192,UDim2.new(1,0,0,22),nil,v3195,v3196,9)
v3198.LayoutOrder=v3191
v3198.TextXAlignment=Enum.TextXAlignment.Left
UI:pad(v3198,0,8,0,0)
UI:stroke(v3198,v3197,1)
if v3194 then local v3857=Instance.new("ImageLabel",v3198)
    v3857.Size=UDim2.new(0,16,0,16)
    v3857.Position=UDim2.new(1, -20,0.5, -8)
    v3857.BackgroundTransparency=1
    v3857.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
    v3857.ScaleType=Enum.ScaleType.Fit
    v3857.ZIndex=v3198.ZIndex + 1
end v3198.MouseButton1Click:Connect(function() cfg.autoHatch[v1731]=v3192
saveConfig()
v1739.Text=v3192
v1742.Visible=false
v1746=false
end)
end return #v2519 + 1
end v1739.MouseButton1Click:Connect(function() v1746= not v1746
v1742.Visible=v1746
if v1746 then local v3616=v1747()
    v1742.Size=UDim2.new(1,0,0,math.min((v3616 * 24) + 6 ,130))
end end)
if _G._NH_ddRefs then table.insert(_G._NH_ddRefs,{Refresh=function() v1739.Text=cfg.autoHatch[v1731] or "None selected"
end})
end return v1739
end local eggDropdownItems={}
do local v1748={}
for v2526,v2527 in ipairs(PetsData) do local v2528=v2527.egg
    if (v2528 and not v1748[v2528]) then v1748[v2528]=true
        table.insert(eggDropdownItems,{key=v2528,name=v2528})
    end end table.sort(eggDropdownItems,function(v2529,v2530) return v2529.name=1)) then cfg.autoHatch.eggCount=math.floor(v1751)
saveConfig()
else eggCountInput.Text=tostring(cfg.autoHatch.eggCount)
end end)
eggSpacingInput.FocusLost:Connect(function() local v1752=tonumber(eggSpacingInput.Text)
if (v1752 and (v1752>=1)) then cfg.autoHatch.eggSpacing=v1752
    saveConfig()
else eggSpacingInput.Text=tostring(cfg.autoHatch.eggSpacing)
end end)
UI:divider(v617,4)
local cdTeamDropdown=v618(v617,"CD Team (Reduce cooldown)","teamCD",5)
local koiTeamDropdown=v618(v617,"Koi Team ","teamKoi",8)
local sealTeamDropdown=v618(v617,"Seal Team (Sell)","teamSeal",11)
local brontoTeamDropdown=v618(v617,"Bronto Team (Heavy hatch)","teamBronto",14)
UI:divider(v617,17)
local brontoThreshRow=UI:frame(v617,UDim2.new(1,0,0,26),nil,T.BTN)
brontoThreshRow.LayoutOrder=18
UI:corner(brontoThreshRow,5)
UI:stroke(brontoThreshRow,T.STROKE,1)
UI:label(brontoThreshRow,"Bronto threshold (kg)",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local brontoThreshInput=UI:input(brontoThreshRow,cfg.autoHatch.brontoThresh,"",UDim2.new(0,46,0,20),UDim2.new(1, -72,0.5, -10))
brontoThreshInput.FocusLost:Connect(function() local v1753=tonumber(brontoThreshInput.Text)
if (v1753 and (v1753>=0)) then cfg.autoHatch.brontoThresh=v1753
    saveConfig()
else brontoThreshInput.Text=tostring(cfg.autoHatch.brontoThresh)
end end)
UI:divider(v617,15)
local espToggleRow=UI:frame(v617,UDim2.new(1,0,0,26),nil,T.BTN)
espToggleRow.LayoutOrder=20
UI:corner(espToggleRow,5)
UI:stroke(espToggleRow,T.STROKE,1)
UI:label(espToggleRow,"Egg ESP",UDim2.new(1, -60,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
UI:toggle(espToggleRow,UDim2.new(1, -52,0.5, -11),cfg.autoHatch.espEnabled,function(v1754) cfg.autoHatch.espEnabled=v1754
saveConfig()
refreshAllESP()
end)
do local v1756=cfg.autoHatch.specialBronto
local v1757=UI:frame(v617,UDim2.new(1,0,0,1),nil,T.STROKE)
v1757.LayoutOrder=19
local v1759=UI:label(v617,"🌟 SPECIAL PET TO BRONTO",UDim2.new(1,0,0,16),nil,T.ACCENT,9)
v1759.LayoutOrder=190
v1759.Font=Enum.Font.GothamBold
local v1763=UI:frame(v617,UDim2.new(1,0,0,26),nil,T.BTN)
v1763.LayoutOrder=191
UI:corner(v1763,5)
UI:stroke(v1763,T.STROKE,1)
UI:label(v1763,"Enable Special Pet to Bronto",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
UI:toggle(v1763,UDim2.new(1, -48,0.5, -11),v1756.enabled,function(v2531) v1756.enabled=v2531
saveConfig()
end)
local v1766=UI:frame(v617,UDim2.new(1,0,0,26),nil,T.BTN)
v1766.LayoutOrder=192
UI:corner(v1766,5)
UI:stroke(v1766,T.STROKE,1)
local v1768=UI:label(v1766,"Pets: NONE",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),T.DIM,9)
v1768.Font=Enum.Font.Gotham
local v1771=UI:button(v1766,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9)
UI:stroke(v1771,T.STROKE,1)

local function v1772() local v2533=0
    for v3208 in pairs(v1756.pets) do v2533=v2533 + 1
    end if (v2533==0) then v1768.Text="Pets: NONE"
v1768.TextColor3=T.DIM
else v1768.Text="Pets: " .. v2533 .. " selected"
v1768.TextColor3=T.ACCENT
end end v1772()
local v1773=UI:frame(hatchPage,UDim2.new(1,0,1,0),nil,T.BG)
v1773.Visible=false
v1773.ZIndex=25
local v1776=UI:frame(v1773,UDim2.new(1,0,0,26),nil,T.PANEL)
UI:stroke(v1776,T.STROKE,1)
UI:label(v1776,"Select Special Pets to Bronto",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10)
local v1777=UI:button(v1776,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8)
UI:stroke(v1777,T.STROKE,1)
local v1778=UI:button(v1776,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10)
UI:stroke(v1778,T.ERROR,1)
v1778.MouseButton1Click:Connect(function() v1773.Visible=false
v1772()
end)
local v1779=UI:input(v1773,"","Search pet or egg...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1779.TextColor3=T.TEXT
v1779.Font=Enum.Font.Gotham
local v1783=UI:scroll(v1773,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
UI:list(v1783,3)
UI:pad(v1783,3,4,4,3)

local function v1784() local v2535=string.lower(v1779.Text)
    local v2536={}
    for v3209,v3210 in ipairs(PetsData) do if ((v2535=="") or v3210.name:lower():find(v2535,1,true) or v3210.egg:lower():find(v2535,1,true)) then table.insert(v2536,v3210)
    end end return v2536
end local function v1785() for v3211,v3212 in ipairs(v1783:GetChildren()) do if v3212:IsA("GuiObject") then v3212:Destroy()
end end local v2537=v1784()
local v2538= #v2537>0
for v3213,v3214 in ipairs(v2537) do if not v1756.pets[v3214.name] then v2538=false
    break
end end v1777.Text=(( #v2537==0) and "Select All") or (v2538 and "Unselect All") or "Select All"
v1777.TextColor3=(v2538 and T.SEL_TXT) or T.ACCENT
v1777.BackgroundColor3=(v2538 and T.SEL_BG) or T.BTN
for v3215,v3216 in ipairs(v2537) do local v3217=v1756.pets[v3216.name]==true
    local v3218=UI:button(v1783,v3216.name,UDim2.new(1,0,0,30),nil,(v3217 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3217 and T.SEL_TXT) or T.TEXT ,9)
    v3218.LayoutOrder=v3215
    v3218.TextXAlignment=Enum.TextXAlignment.Left
    UI:pad(v3218,0,8,4,0)
    UI:corner(v3218,5)
    UI:stroke(v3218,(v3217 and T.ACCENT) or T.STROKE ,1)
    UI:label(v3218,v3216.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v3217 and Color3.fromRGB(60,40,0)) or T.DIM ,8).Font=Enum.Font.Gotham
    v3218.MouseButton1Click:Connect(function() if v1756.pets[v3216.name] then v1756.pets[v3216.name]=nil
else v1756.pets[v3216.name]=true
end saveConfig()
v1772()
UI:updateRowVisualWithSub(v3218,v1756.pets[v3216.name]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE,Color3.fromRGB(60,40,0),T.DIM)
end)
end end v1777.MouseButton1Click:Connect(function() local v2542=v1784()
local v2543= #v2542>0
for v3224,v3225 in ipairs(v2542) do if not v1756.pets[v3225.name] then v2543=false
    break
end end if v2543 then for v3865,v3866 in ipairs(v2542) do v1756.pets[v3866.name]=nil
end else for v3868,v3869 in ipairs(v2542) do v1756.pets[v3869.name]=true
end end saveConfig()
v1772()
v1785()
end)
v1779:GetPropertyChangedSignal("Text"):Connect(v1785)
v1771.MouseButton1Click:Connect(function() v1773.Visible=true
v1785()
end)
end local timingEditorBtn,v645=UI:timingEditor(v617,hatchPage,timingCfg,cfg,saveConfig)
timingEditorBtn.LayoutOrder=21
timingEditorBtn.Text="⏱ Timing Editor "
timingEditorBtn.TextXAlignment=Enum.TextXAlignment.Center
if not cfg.autoHatch.afInterval then cfg.autoHatch.afInterval=30
end if (cfg.autoHatch.afEnabled==nil) then cfg.autoHatch.afEnabled=false
end local autoFeedRow=UI:frame(v617,UDim2.new(1,0,0,26),nil,T.BTN)
autoFeedRow.LayoutOrder=21
UI:corner(autoFeedRow,5)
UI:stroke(autoFeedRow,T.STROKE,1)
UI:label(autoFeedRow,"Auto Feed (sec)",UDim2.new(0,90,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local autoFeedIntervalInput=UI:input(autoFeedRow,cfg.autoHatch.afInterval,"",UDim2.new(0,40,0,20),UDim2.new(0,100,0.5, -10))
autoFeedIntervalInput.FocusLost:Connect(function() local v1786=tonumber(autoFeedIntervalInput.Text)
if (v1786 and (v1786>=1)) then cfg.autoHatch.afInterval=v1786
    saveConfig()
else autoFeedIntervalInput.Text=tostring(cfg.autoHatch.afInterval)
end end)
local autoFeedRunning=false
local autoFeedThread=nil
local ActivePetServiceRemote=RS:WaitForChild("GameEvents"):WaitForChild("ActivePetService")

local function getFruitToolFromChar() for v2547,v2548 in ipairs(Backpack:GetChildren()) do if (v2548:IsA("Tool") and CS:HasTag(v2548,"FruitTool") and (v2548:GetAttribute(ATTR_FAVORITED)~=true)) then return v2548
end end for v2549,v2550 in ipairs(Character:GetChildren()) do if (v2550:IsA("Tool") and CS:HasTag(v2550,"FruitTool") and (v2550:GetAttribute(ATTR_FAVORITED)~=true)) then return v2550
end end return nil
end local function getPetHungerPct(v1787) local v1788,v1789=pcall(function() return DataService:GetData()
end)
if ( not v1788 or not v1789 or not v1789.PetsData) then return 1
end local v1790=v1789.PetsData.PetInventory and v1789.PetsData.PetInventory.Data
if ( not v1790 or not v1790[v1787]) then return 1
end local v1791=v1790[v1787].PetData
if not v1791 then return 1
end local v1792=v1791.Hunger or 0
local v1793=100
local v1794,v1795=pcall(function() return require(game:GetService("ReplicatedStorage").Data.PetRegistry).PetList
end)
if (v1794 and v1795 and v1795[v1790[v1787].PetType]) then v1793=v1795[v1790[v1787].PetType].DefaultHunger or 100
end return v1792/v1793
end local function getPetsToFeed() local v1796=getActivePets()
local v1797={}
for v2551,v2552 in ipairs(v1796) do table.insert(v1797,{uuid=v2552,pct=getPetHungerPct(v2552)})
end table.sort(v1797,function(v2553,v2554) return v2553.pct0)) then sessionStats.startTime=v3872.AH.startTime or os.time()
sessionStats.cycleCount=v3872.AH.cycleCount or 0
sessionStats.totalHatched=v3872.AH.totalHatched or 0
sessionStats.eggBefore=v3872.AH.eggBefore or 0
sessionStats.eggCurrent=v3872.AH.eggCurrent or 0
sessionStats.koiProc=v3872.AH.koiProc or 0
sessionStats.sealProc=v3872.AH.sealProc or 0
sessionStats.koiLastCycle=v3872.AH.koiLastCycle or 0
sessionStats.sealLastCycle=v3872.AH.sealLastCycle or 0
sessionStats.petTypes=v3872.AH.petTypes or {}
for v4227,v4228 in pairs(sessionStats.petTypes) do if ( not v4228.minKG or (v4228.minKG==0)) then v4228.minKG=math.huge
end end sessionStats.specials=v3872.AH.specials or {huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}
v3232=true
hatchLog("══ CONTINUE SESSION (cycle " .. sessionStats.cycleCount .. ") ══" ,T.PHASE2)
end end if not v3232 then sessionStats.startTime=os.time()
sessionStats.cycleCount=0
sessionStats.totalHatched=0
sessionStats.koiProc=0
sessionStats.sealProc=0
sessionStats.koiLastCycle=0
sessionStats.sealLastCycle=0
sessionStats.petTypes={}
sessionStats.specials={huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}
sessionStats.eggCurrent=0
sessionStats.eggBefore=0
for v4055,v4056 in ipairs(Backpack:GetChildren()) do if (v4056:IsA("Tool") and CS:HasTag(v4056,"PetEggTool")) then if (v4056:GetAttribute("h")==cfg.autoHatch.eggName) then local v4334=tonumber(v4056.Name:match("x(%d+)$")) or 1
    sessionStats.eggBefore=sessionStats.eggBefore + v4334
end end end saveSession()
end hatchLog("════ AUTO HATCH START ════",T.ACCENT)
setHatchStatus("Starting...",T.SUCCESS)
autoHatchThread=task.spawn(function() local v3628=sessionStats.cycleCount
while isAutoHatchRunning do v3628=v3628 + 1
    sessionStats.cycleCount=v3628
    saveSessionMidCycle()
    hatchLog(string.format("── Cycle %d ──",v3628),T.ACCENT)
    setHatchStatus(string.format("Cycle %d",v3628),T.SUCCESS)
    local v3885,v3886=pcall(runSingleHatchCycle,hatchLog,setHatchStatus)
    if not v3885 then hatchLog("Error: " .. tostring(v3886) ,T.ERROR)
        setHatchStatus("Error!",T.ERROR)
        task.wait(3)
    end if not isAutoHatchRunning then break
end task.wait(1)
end hatchLog("─── Stopped ───",T.ERROR)
setHatchStatus("● IDLE",T.DIM)
end)
else isAutoHatchRunning=false
hatchLog("─── Stopped by user ───",T.ERROR)
setHatchStatus("● IDLE",T.DIM)
end end)
local sellSettingsAccordion=UI:accordion(v612,"💰 SELL SETTINGS",20,false)
local sellSettingsInner=sellSettingsAccordion.Inner
local sellThreshRow=UI:frame(sellSettingsInner,UDim2.new(1,0,0,26),nil,T.BTN)
sellThreshRow.LayoutOrder=1
UI:corner(sellThreshRow,5)
UI:stroke(sellThreshRow,T.STROKE,1)
UI:label(sellThreshRow,"Sell below (kg)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local sellThreshInput=UI:input(sellThreshRow,cfg.autoHatch.sellThresh,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
sellThreshInput.FocusLost:Connect(function() local v1809=tonumber(sellThreshInput.Text)
if (v1809 and (v1809>=0)) then cfg.autoHatch.sellThresh=v1809
    saveConfig()
else sellThreshInput.Text=tostring(cfg.autoHatch.sellThresh)
end end)
local favDelayRow=UI:frame(sellSettingsInner,UDim2.new(1,0,0,26),nil,T.BTN)
favDelayRow.LayoutOrder=1
UI:corner(favDelayRow,5)
UI:stroke(favDelayRow,T.STROKE,1)
UI:label(favDelayRow,"Fav delay (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham
local favDelayInput=UI:input(favDelayRow,cfg.autoHatch.favDelay,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
favDelayInput.FocusLost:Connect(function() local v1810=tonumber(favDelayInput.Text)
if (v1810 and (v1810>=0)) then cfg.autoHatch.favDelay=v1810
    saveConfig()
else favDelayInput.Text=tostring(cfg.autoHatch.favDelay)
end end)
local sellWhenFullRow=UI:frame(sellSettingsInner,UDim2.new(1,0,0,26),nil,T.BTN)
sellWhenFullRow.LayoutOrder=2
UI:corner(sellWhenFullRow,5)
UI:stroke(sellWhenFullRow,T.STROKE,1)
UI:label(sellWhenFullRow,"Auto Sell ONLY When Inventory Full",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold
local maxInvInput=UI:input(sellWhenFullRow,cfg.autoHatch.petInvMax,"",UDim2.new(0,40,0,20),UDim2.new(1, -94,0.5, -10))
maxInvInput.FocusLost:Connect(function() local v1811=tonumber(maxInvInput.Text)
if (v1811 and (v1811>=1)) then cfg.autoHatch.petInvMax=v1811
    saveConfig()
else maxInvInput.Text=tostring(cfg.autoHatch.petInvMax)
end end)
UI:toggle(sellWhenFullRow,UDim2.new(1, -52,0.5, -11),cfg.autoHatch.autoSellWhenFull,function(v1812) cfg.autoHatch.autoSellWhenFull=v1812
saveConfig()
end)
local sellPetsRow=UI:frame(sellSettingsInner,UDim2.new(1,0,0,26),nil,T.BTN)
sellPetsRow.LayoutOrder=3
UI:corner(sellPetsRow,5)
UI:stroke(sellPetsRow,T.STROKE,1)
local sellPetsLabel=UI:label(sellPetsRow,"Sell pets: NONE",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),T.DIM,9)
sellPetsLabel.Font=Enum.Font.Gotham
local selectSellPetsBtn=UI:button(sellPetsRow,"Select pets >",UDim2.new(0,90,0,20),UDim2.new(1, -94,0.5, -10),T.BTN,T.ACCENT,9)
UI:stroke(selectSellPetsBtn,T.STROKE,1)

local function refreshSellPetsLabel() local v1814=0
    for v2556 in pairs(cfg.autoHatch.sellPets) do v1814=v1814 + 1
    end if (v1814==0) then sellPetsLabel.Text="Sell pets: NONE"
sellPetsLabel.TextColor3=T.DIM
else sellPetsLabel.Text="Sell pets: " .. v1814 .. " selected"
sellPetsLabel.TextColor3=T.ACCENT
end end refreshSellPetsLabel()
local sellPetsOverlay=UI:frame(hatchPage,UDim2.new(1,0,1,0),nil,T.BG)
sellPetsOverlay.Visible=false
sellPetsOverlay.ZIndex=25
local v694=UI:frame(sellPetsOverlay,UDim2.new(1,0,0,26),nil,T.PANEL)
UI:stroke(v694,T.STROKE,1)
UI:label(v694,"Select pets to SELL",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10)
local v695=UI:button(v694,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8)
UI:stroke(v695,T.STROKE,1)
local v696=UI:button(v694,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10)
UI:stroke(v696,T.ERROR,1)
v696.MouseButton1Click:Connect(function() sellPetsOverlay.Visible=false
refreshSellPetsLabel()
end)
local v697=UI:input(sellPetsOverlay,"","Search pet or egg...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v697.TextColor3=T.TEXT
v697.Font=Enum.Font.Gotham
local v701=UI:scroll(sellPetsOverlay,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
UI:list(v701,3)
UI:pad(v701,3,4,4,3)

local function v702() local v1816=string.lower(v697.Text)
    local v1817={}
    for v2557,v2558 in ipairs(PetsData) do if ((v1816=="") or v2558.name:lower():find(v1816,1,true) or v2558.egg:lower():find(v1816,1,true)) then table.insert(v1817,v2558)
    end end return v1817
end local function v703() for v2559,v2560 in ipairs(v701:GetChildren()) do if v2560:IsA("GuiObject") then v2560:Destroy()
end end local v1818=v702()
local v1819= #v1818>0
for v2561,v2562 in ipairs(v1818) do if not cfg.autoHatch.sellPets[v2562.name] then v1819=false
    break
end end v695.Text=(( #v1818==0) and "Select All") or (v1819 and "Unselect All") or "Select All"
v695.TextColor3=(v1819 and T.SEL_TXT) or T.ACCENT
v695.BackgroundColor3=(v1819 and T.SEL_BG) or T.BTN
for v2563,v2564 in ipairs(v1818) do local v2565=cfg.autoHatch.sellPets[v2564.name]==true
    local v2566=UI:button(v701,v2564.name,UDim2.new(1,0,0,30),nil,(v2565 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2565 and T.SEL_TXT) or T.TEXT ,10)
    v2566.LayoutOrder=v2563
    v2566.TextXAlignment=Enum.TextXAlignment.Left
    UI:pad(v2566,0,8,4,0)
    UI:corner(v2566,5)
    UI:stroke(v2566,(v2565 and T.ACCENT) or T.STROKE ,1)
    UI:label(v2566,v2564.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v2565 and Color3.fromRGB(60,40,0)) or T.DIM ,8).Font=Enum.Font.Gotham
    v2566.MouseButton1Click:Connect(function() if cfg.autoHatch.sellPets[v2564.name] then cfg.autoHatch.sellPets[v2564.name]=nil
else cfg.autoHatch.sellPets[v2564.name]=true
end saveConfig()
refreshSellPetsLabel()
UI:updateRowVisualWithSub(v2566,cfg.autoHatch.sellPets[v2564.name]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE,Color3.fromRGB(60,40,0),T.DIM)
end)
end end v695.MouseButton1Click:Connect(function() local v1823=v702()
local v1824= #v1823>0
for v2572,v2573 in ipairs(v1823) do if not cfg.autoHatch.sellPets[v2573.name] then v1824=false
    break
end end if v1824 then for v3629,v3630 in ipairs(v1823) do cfg.autoHatch.sellPets[v3630.name]=nil
end else for v3632,v3633 in ipairs(v1823) do cfg.autoHatch.sellPets[v3633.name]=true
end end saveConfig()
refreshSellPetsLabel()
v703()
end)
v697:GetPropertyChangedSignal("Text"):Connect(v703)
selectSellPetsBtn.MouseButton1Click:Connect(function() sellPetsOverlay.Visible=true
v703()
end)
hatchLog("Auto Hatch ready!",T.SUCCESS)
end buildAutoHatchUI()
-- ════════════════════════════════════════════════════════
-- § 19 · ELEPHANT / AUTO-KG PAGE
-- ════════════════════════════════════════════════════════
local elephantPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
elephantPage.Visible=false
-- ════════════════════════════════════════════════════════
-- § 20 · LEVELING PAGE  (EV / AgeBreaker / MutMachine)
-- ════════════════════════════════════════════════════════
local levelingPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
levelingPage.Visible=false
-- ════════════════════════════════════════════════════════
-- § 21 · TEAMS PAGE
-- ════════════════════════════════════════════════════════
local teamsPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
teamsPage.Visible=false
-- ════════════════════════════════════════════════════════
-- § 22 · PICK & PLACE PAGE
-- ════════════════════════════════════════════════════════
local pickPlacePage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
pickPlacePage.Visible=false
-- ════════════════════════════════════════════════════════
-- § 23 · PET BOOST PAGE
-- ════════════════════════════════════════════════════════
local petBoostPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
petBoostPage.Visible=false
-- ════════════════════════════════════════════════════════
-- § 24 · WEBHOOK CONFIG PAGE
-- ════════════════════════════════════════════════════════
local webhookPage=UI:frame(mainContent,UDim2.new(1,0,1,0),nil,T.BG,1)
webhookPage.Visible=false
local pageMappings={{hatchBtn,"autohatch"},{elephantBtn,"elephant"},{levelingBtn,"leveling"},{teamsBtn,"teams"},{pnpBtn,"pickplace"},{boostBtn,"petboost"},{webhookBtn,"webhook"},{miscBtn,"misc"}}

local function switchToPage(v704) hatchPage.Visible=v704=="autohatch"
    elephantPage.Visible=v704=="elephant"
    levelingPage.Visible=v704=="leveling"
    teamsPage.Visible=v704=="teams"
    pickPlacePage.Visible=v704=="pickplace"
    petBoostPage.Visible=v704=="petboost"
    webhookPage.Visible=v704=="webhook"
    miscPage.Visible=v704=="misc"
    for v1826,v1827 in ipairs(pageMappings) do v1827[1].SetActive(v1827[2]==v704 )
    end end hatchBtn.Button.MouseButton1Click:Connect(function() switchToPage("autohatch")
end)
elephantBtn.Button.MouseButton1Click:Connect(function() switchToPage("elephant")
end)
levelingBtn.Button.MouseButton1Click:Connect(function() switchToPage("leveling")
end)
teamsBtn.Button.MouseButton1Click:Connect(function() switchToPage("teams")
end)
pnpBtn.Button.MouseButton1Click:Connect(function() switchToPage("pickplace")
end)
boostBtn.Button.MouseButton1Click:Connect(function() switchToPage("petboost")
end)
webhookBtn.Button.MouseButton1Click:Connect(function() switchToPage("webhook")
end)
miscBtn.Button.MouseButton1Click:Connect(function() switchToPage("misc")
end)
local levelingScroll=UI:scroll(levelingPage,UDim2.new(1,0,1,0))
levelingScroll.ScrollingDirection=Enum.ScrollingDirection.Y
levelingScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
levelingScroll.CanvasSize=UDim2.new(0,0,0,0)
UI:list(levelingScroll,6)
UI:pad(levelingScroll,4,4,4,8)
_G.HH_Shared={V=UI,T=T,D=cfg,CFG=timingCfg,Player=LocalPlayer,Backpack=Backpack,Char=Character,MUTATION_MAP=MutationMap,saveD=saveConfig,getInv=getInventory,getKG=getKG,getAge=getAge,getBase=getBaseWeight,getPType=getPetType,isFav=isFavorited,findPetTool=findPetTool,getMutName=getMutationName,unequipAll=unequipAll,equipList=equipList,buildEquip=buildEquipList,waitUntilEquipped=waitUntilEquipped,getActivePets=getActivePets,getFarmCF=getFarmCF,PetsRemote=PetsRemote,FavRemote=FavoriteItemRemote,SellAllRemote=SellAllPetsRemote,DataService=DataService,htTrack=trackEvent,UI=HydraLib,outerScroll=levelingScroll,PageLeveling=levelingPage,_buildTeamDD=buildTeamDropdown,getTeamUUIDs=getTeamUUIDs}
loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=leveling",true))()
loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=nightmare",true))()

local function buildAutoEVSection() local evRunning=false
    local evPollRate=1
    local PetShardRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetShardService_RE")
    local v716=game:GetService("CollectionService")
    local function v717(v1828) if not v1828 then return nil
    end return v1828:gsub("[{}]",""):lower()
end local function getEVMutType(v1829) local v1830,v1831=pcall(function() return DataService:GetData()
end)
if ( not v1830 or not v1831 or not v1831.PetsData) then return nil
end local v1832=v1831.PetsData.PetInventory.Data[v1829]
if ( not v1832 or not v1832.PetData) then return nil
end local v1833=v1832.PetData.MutationType
if ( not v1833 or (v1833=="") or (v1833=="m")) then return nil
end return v1833
end local function getPetAreaCF() local v1834=workspace:FindFirstChild("Farm")
if v1834 then local v3245=v1834:FindFirstChild(LocalPlayer.Name)
    if v3245 then local v3889=v3245:FindFirstChild("PetArea")
        if v3889 then return v3889.CFrame
        end end end return DEFAULT_GARDEN_CF
end local function findPetInPhysical(v1835) local v1836=workspace:FindFirstChild("PetsPhysical")
if not v1836 then return nil
end for v2574,v2575 in ipairs(v1836:GetChildren()) do if (v717(v2575:GetAttribute("UUID"))==v1835) then return v2575
end end return nil
end local function waitForSingleShardApply(v1837,v1838) local v1839=0
while v1839",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v762,T.STROKE,1);local v763,v764=UI:logPanel(v725,10,45);local v765=UI:frame(v725,UDim2.new(1,0,0,36),nil,T.PANEL);v765.LayoutOrder=11;UI:stroke(v765,T.STROKE,1);UI:label(v765,"AUTO EVERCHANTED",UDim2.new(0,120,0,20),UDim2.new(0,8,0.5, -10),T.TEXT,10).Font=Enum.Font.GothamBold;local v768=UI:label(v765,"● IDLE",UDim2.new(1, -180,1,0),UDim2.new(0,124,0,0),T.DIM,9);v768.Font=Enum.Font.Gotham;v768.TextTruncate=Enum.TextTruncate.AtEnd;local function v772(v1854,v1855) v768.Text=v1854;v768.TextColor3=v1855 or T.DIM ;end local v773=false;v733.MouseButton1Click:Connect(function() v773= not v773;v736.Visible=v773;if v773 then local v3248=v726(v739,function(v3638) cfg.autoEV.pvTeam=v3638;saveConfig();v733.Text=v3638;v736.Visible=false;v773=false;end,cfg.autoEV.pvTeam);v736.Size=UDim2.new(1,0,0,math.min((v3248 * 24) + 6 ,130));end end);local v774=false;v745.MouseButton1Click:Connect(function() v774= not v774;v736.Visible=false;v773=false;v747.Visible=v774;if v774 then local v3250=v726(v750,function(v3642) cfg.autoEV.lvTeam=v3642;saveConfig();v745.Text=v3642;v747.Visible=false;v774=false;end,cfg.autoEV.lvTeam);v747.Size=UDim2.new(1,0,0,math.min((v3250 * 24) + 6 ,130));end end);local v775=UI:frame(levelingPage,UDim2.new(1,0,1,0),nil,T.BG);v775.Visible=false;v775.ZIndex=20;local v778=UI:frame(v775,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v778,T.STROKE,1);UI:label(v778,"Select Target Pets (Everchanted)",UDim2.new(1, -118,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v779=UI:button(v778,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8);UI:stroke(v779,T.STROKE,1);local v780=UI:button(v778,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v780,T.ERROR,1);v780.MouseButton1Click:Connect(function() v775.Visible=false;v760.Text="Target pets: " .. #cfg.autoEV.targets ;end);local v781=UI:input(v775,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v781.TextColor3=T.TEXT;v781.Font=Enum.Font.Gotham;local v785=UI:scroll(v775,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v785,3);UI:pad(v785,3,4,4,3);local function v786() local v1863=string.lower(v781.Text);local v1864=getInventory();local v1865={};for v2584 in pairs(v1864) do table.insert(v1865,v2584);end table.sort(v1865,function(v2585,v2586) return getKG(v2585)>getKG(v2586) ;end);local v1866={};for v2587,v2588 in ipairs(v1865) do local v2589=v1864[v2588];if not v2589 then continue;end if ((v1863=="") or string.lower(v2589.PetType or "" ):find(v1863,1,true)) then table.insert(v1866,v2588);end end return v1866;end local function v787() for v2590,v2591 in ipairs(v785:GetChildren()) do if v2591:IsA("GuiObject") then v2591:Destroy();end end local v1867=getInventory();local v1868=v786();local v1869= #v1868>0 ;for v2592,v2593 in ipairs(v1868) do if not table.find(cfg.autoEV.targets,v2593) then v1869=false;break;end end v779.Text=(( #v1868==0) and "Select All") or (v1869 and "Unselect All") or "Select All" ;v779.TextColor3=(v1869 and T.SEL_TXT) or T.ACCENT ;v779.BackgroundColor3=(v1869 and T.SEL_BG) or T.BTN ;for v2594,v2595 in ipairs(v1868) do local v2596=v1867[v2595];if not v2596 then continue;end local v2597=table.find(cfg.autoEV.targets,v2595)~=nil ;local v2598=(v2596.PetData and (v2596.PetData.Level or 0)) or 0 ;local v2599=getKG(v2595);local v2600=(v2596.PetData and (v2596.PetData.BaseWeight or 0)) or 0 ;local v2601=(isFavorited(v2595) and " ❤") or "" ;local v2602=getEVMutType(v2595);local v2603=(v2602 and (" [" .. (MutationMap[v2602] or v2602) .. "]")) or "" ;local v2604=((v2603~="") and string.format('%s',v2603)) or "" ;local v2605=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2596.PetType or "?" ,v2604,v2601,v2598,v2599,v2600);local v2606=UI:button(v785,v2605,UDim2.new(1,0,0,22),nil,(v2597 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2597 and T.SEL_TXT) or T.TEXT ,9);v2606.LayoutOrder=v2594;v2606:SetAttribute("uuid",v2595);v2606.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2606,0,8,4,0);UI:stroke(v2606,(v2597 and T.ACCENT) or T.STROKE ,1);v2606.MouseButton1Click:Connect(function() local v3252=table.find(cfg.autoEV.targets,v2595);if v3252 then table.remove(cfg.autoEV.targets,v3252);else table.insert(cfg.autoEV.targets,v2595);end saveConfig();v760.Text="Target pets: " .. #cfg.autoEV.targets ;local v3254=table.find(cfg.autoEV.targets,v2595)~=nil ;UI:updateRowVisual(v2606,v3254,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);local v3255=v786();local v3256= #v3255>0 ;for v3646,v3647 in ipairs(v3255) do if not table.find(cfg.autoEV.targets,v3647) then v3256=false;break;end end v779.Text=(( #v3255==0) and "Select All") or (v3256 and "Unselect All") or "Select All" ;v779.TextColor3=(v3256 and T.SEL_TXT) or T.ACCENT ;v779.BackgroundColor3=(v3256 and T.SEL_BG) or T.BTN ;end);end end v779.MouseButton1Click:Connect(function() local v1873=v786();local v1874= #v1873>0 ;for v2610,v2611 in ipairs(v1873) do if not table.find(cfg.autoEV.targets,v2611) then v1874=false;break;end end if v1874 then for v3648,v3649 in ipairs(v1873) do local v3650=table.find(cfg.autoEV.targets,v3649);if v3650 then table.remove(cfg.autoEV.targets,v3650);end end else for v3651,v3652 in ipairs(v1873) do if not table.find(cfg.autoEV.targets,v3652) then table.insert(cfg.autoEV.targets,v3652);end end end saveConfig();v760.Text="Target pets: " .. #cfg.autoEV.targets ;v787();end);v781:GetPropertyChangedSignal("Text"):Connect(v787);v762.MouseButton1Click:Connect(function() v775.Visible=true;v787();end);local function v788(v1877,v1878) local v1879=getTeamUUIDs(cfg.autoEV.pvTeam);local v1880=getTeamUUIDs(cfg.autoEV.lvTeam);local v1881={};for v2612,v2613 in ipairs(cfg.autoEV.targets) do table.insert(v1881,v2613);end for v2614,v2615 in ipairs(v1881) do if not evRunning then break;end if not getInventory()[v2615] then v1877(string.format("[%d/%d] Skip — not in inventory",v2614, #v1881),T.DIM);continue;end local v2616=getPetType(v2615);v1877(string.format("[%d/%d] START %s",v2614, #v1881,v2616),T.ACCENT);if cfg.autoEV.autoCleanseFirst then local v3653=getEVMutType(v2615);if ((v3653~=nil) and (v3653~="EV")) then v1877(string.format("Auto cleanse: mut=%s, cleansing dulu...",MutationMap[v3653] or v3653 ),T.DIM);v1878("Pre-cleansing " .. v2616 ,T.DIM);cleanseEVPet(v2615,v1877);task.wait(1);unequipAll();elseif (v3653=="EV") then v1877("Pet sudah EV, skip cleanse.",T.DIM);else v1877("Tidak ada mutation, skip cleanse.",T.DIM);end end local v2617=false;local v2618=0;while evRunning and not v2617 do v2618+=1 v1877(string.format("Attempt %d — equip Peryton team",v2618),T.DIM);v1878(string.format("A%d | %s",v2618,v2616),T.DIM);unequipAll();task.wait(0.5);local v3260={v2615};for v3654,v3655 in ipairs(v1879) do if ( #v3260>=8) then break;end if (v3655~=v2615) then table.insert(v3260,v3655);end end equipList(v3260);local v3261=getEVMutType(v2615);v1877(string.format("Watching... prevMut=%s",tostring(v3261)),T.DIM);v1878(string.format("Waiting skill | %s",v2616),Color3.fromRGB(100,200,255));while evRunning do task.wait(evPollRate);local v3656=getEVMutType(v2615);if (v3656~=v3261) then v1877(string.format("Skill landed! mut=%s",tostring(v3656)),T.SUCCESS);if (v3656=="EV") then v1877("✓ EVERCHANTED DAPET! " .. v2616 ,T.SUCCESS);v1878("✓ Everchanted! " .. v2616 ,T.SUCCESS);v2617=true;unequipAll();else local v4229=(v3656 and (MutationMap[v3656] or v3656)) or "none" ;v1877(string.format("Dapat %s, bukan Everchanted — cleanse & retry",v4229),T.ERROR);v1878("Cleansing " .. v2616 ,T.DIM);cleanseEVPet(v2615,v1877);task.wait(1);unequipAll();end break;end end end if v2617 then if (cfg.autoEV.levelTo100 and ( #v1880>0)) then v1877("Level to 100: " .. v2616 ,T.ACCENT);v1878(string.format("Leveling %s to 100",v2616),T.ACCENT);unequipAll();task.wait(0.5);equipList(buildEquipList(v2615,v1880));while evRunning do task.wait(timingCfg.POLL_RATE);local v4142=getAge(v2615);v1878(string.format("Lv%d/100 | %s",v4142,v2616),T.DIM);if (v4142>=100) then v1877(string.format("✓ Lv100 done! %s",v2616),T.SUCCESS);unequipAll();break;end end elseif (cfg.autoEV.levelTo100 and ( #v1880==0)) then v1877("⚠ Level to 100 ON tapi Leveling Team belum di-set!",T.ERROR);end local v3657=table.find(cfg.autoEV.targets,v2615);if v3657 then table.remove(cfg.autoEV.targets,v3657);saveConfig();end v760.Text="Target pets: " .. #cfg.autoEV.targets ;v1877("Next pet...",T.DIM);task.wait(1);end end evRunning=false;v1877("════ ALL DONE ════",T.ACCENT);v1878("● IDLE",T.DIM);end UI:toggle(v765,UDim2.new(1, -52,0.5, -11),false,function(v1882) if v1882 then if not cfg.autoEV.pvTeam then v764("Set Peryton Team dulu!",T.ERROR);return;end if ( #cfg.autoEV.targets==0) then v764("Pilih target pets dulu!",T.ERROR);return;end evRunning=true;v764("════ AUTO EVERCHANTED START ════",T.ACCENT);v772("Starting...",T.SUCCESS);task.spawn(function() v788(v764,v772);end);else evRunning=false;v764("─── Stopped ───",T.ERROR);v772("● IDLE",T.DIM);end end);v764("Auto Everchanted ready!",T.SUCCESS);end buildAutoEVSection();local function buildAutoAgeBreakerSection() local ageBreakRunning=false;local ageBreakPollRate=2;local skipTimeRunning=false;local ageBreakClaiming=false;local ageBreakReturning=false;local TradeWorldData=nil;pcall(function() TradeWorldData=require(RS.Data.TradeWorldData);end);local function isInTradeWorld() if not TradeWorldData then return false;end if (game.PlaceId~=TradeWorldData.PlaceId) then if (TradeWorldData.ForceInWorld~=true) then return false;else return true;end else return true;end end local SubmitHeldRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_SubmitHeld");local SubmitPairRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Submit");local ClaimRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Claim");local CancelRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Cancel");local TravelToTradeWorldRemote=nil;pcall(function() TravelToTradeWorldRemote=RS:WaitForChild("GameEvents"):WaitForChild("TradeWorld"):WaitForChild("TravelToTradeWorld",5);end);if not cfg.autoAgeBreaker then cfg.autoAgeBreaker={targets={},tumbalKgMax=2,tumbalAgeMax=99,skipEnabled=false,maxLevel=125};end if (cfg.autoAgeBreaker.skipEnabled==nil) then cfg.autoAgeBreaker.skipEnabled=false;end if (cfg.autoAgeBreaker.maxLevel==nil) then cfg.autoAgeBreaker.maxLevel=125;end local function getMachineState() local v1883,v1884=pcall(function() return DataService:GetData();end);if ( not v1883 or not v1884) then return nil;end return v1884.PetAgeBreakMachine;end local function getPetMutName(v1885) local v1886=getInventory();local v1887=v1886[v1885];if ( not v1887 or not v1887.PetData) then return "";end local v1888=v1887.PetData.MutationType or "" ;if ((v1888=="") or (v1888=="m")) then return "";end return MutationMap[v1888] or v1888 ;end local function holdPetTool(v1889) for v2622,v2623 in ipairs(Character:GetChildren()) do if v2623:IsA("Tool") then v2623.Parent=Backpack;end end task.wait(0.3);local v1890=nil;local v1891=os.clock();while (os.clock() -v1891)<10 do v1890=findPetTool(v1889);if v1890 then break;end task.wait(1);end if not v1890 then return false;end v1890.Parent=Character;task.wait(0.3);local v1893=Character:FindFirstChildOfClass("Humanoid");if v1893 then v1893:EquipTool(v1890);task.wait(0.3);end return true;end local function findTumbalPet(v1894,v1895) local v1896=getInventory();local v1897=v1896[v1894];local v1898=v1895 or (v1897 and (v1897.PetType or "")) or getPetType(v1894) ;if ((v1898=="") or (v1898=="Unknown")) then return nil;end local v1899=cfg.autoAgeBreaker.tumbalKgMax or 2 ;local v1900=cfg.autoAgeBreaker.tumbalAgeMax or 99 ;local v1901={};for v2624,v2625 in pairs(v1896) do if (v2624==v1894) then continue;end if ( not v2625 or not v2625.PetData) then continue;end if (v2625.PetType~=v1898) then continue;end local v2626=v2625.PetData.Level or 0 ;local v2627=v2625.PetData.BaseWeight or 0 ;if (v2627>v1899) then continue;end if (v2626>v1900) then continue;end local v2628=false;do local v3262,v3263=pcall(function() return DataService:GetData();end);if (v3262 and v3263 and v3263.PetsData) then local v3890=v3263.PetsData.PetInventory.Data[v2624];if (v3890 and v3890.PetData) then v2628=(v3890.PetData.Favorited==true) or (v3890.PetData.IsFavorite==true) ;end end end if (v2628 or isFavorited(v2624)) then continue;end table.insert(v1901,{uuid=v2624,age=v2626,kg=v2627});end table.sort(v1901,function(v2629,v2630) if (v2629.kg~=v2630.kg) then return v2629.kg0) then return v1901[1].uuid;end abLog(string.format("Debug: targetType=%s kgMax=%.2f ageMax=%d",v1898,v1899,v1900),T.DIM);local v1902=0;for v2631,v2632 in pairs(v1896) do if (v2631==v1894) then continue;end if ( not v2632 or not v2632.PetData) then continue;end if (v2632.PetType~=v1898) then continue;end v1902=v1902 + 1 ;local v2633=v2632.PetData.Level or 0 ;local v2634=v2632.PetData.BaseWeight or 0 ;abLog(string.format(" Candidate: Age %d BaseKG %.2f fav=%s",v2633,v2634,tostring(isFavorited(v2631))),T.DIM);end if (v1902==0) then abLog(string.format("Tidak ada pet tipe '%s' selain target!",v1898),T.ERROR);end return nil;end local function ensureMainWorld(v1903) ageBreakReturning=true;v1903("Ensuring main world before claim...",T.DIM);if not isInTradeWorld() then v1903("Sudah di main world.",T.DIM);ageBreakReturning=false;return;end pcall(function() RS:WaitForChild("GameEvents"):WaitForChild("TradeWorld"):WaitForChild("TravelToMainWorld",5):FireServer();end);local v1904=os.clock();while isInTradeWorld() and ((os.clock() -v1904)<15) do task.wait(2);end v1903("Sudah di main world.",T.SUCCESS);task.wait(2);ageBreakReturning=false;end local v806=UI:accordion(levelingScroll,"🔨 AUTO AGE BREAKER",4,false);local v807=v806.Inner;local v808=UI:frame(v807,UDim2.new(1,0,0,26),nil,T.BTN);v808.LayoutOrder=1;UI:corner(v808,5);UI:stroke(v808,T.STROKE,1);UI:label(v808,"Tumbal: Max Base KG",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v812=UI:input(v808,cfg.autoAgeBreaker.tumbalKgMax,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v812.FocusLost:Connect(function() local v1905=tonumber(v812.Text);if (v1905 and (v1905>=0)) then cfg.autoAgeBreaker.tumbalKgMax=v1905;saveConfig();else v812.Text=tostring(cfg.autoAgeBreaker.tumbalKgMax);end end);local v813=UI:frame(v807,UDim2.new(1,0,0,26),nil,T.BTN);v813.LayoutOrder=2;UI:corner(v813,5);UI:stroke(v813,T.STROKE,1);UI:label(v813,"Tumbal: Max Age (level)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v816=UI:input(v813,cfg.autoAgeBreaker.tumbalAgeMax,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v816.FocusLost:Connect(function() local v1906=tonumber(v816.Text);if (v1906 and (v1906>=0)) then cfg.autoAgeBreaker.tumbalAgeMax=v1906;saveConfig();else v816.Text=tostring(cfg.autoAgeBreaker.tumbalAgeMax);end end);local v817=UI:frame(v807,UDim2.new(1,0,0,26),nil,T.BTN);v817.LayoutOrder=3;UI:corner(v817,5);UI:stroke(v817,T.STROKE,1);UI:label(v817,"Target: Max Level",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v820=UI:input(v817,cfg.autoAgeBreaker.maxLevel,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v820.FocusLost:Connect(function() local v1907=tonumber(v820.Text);if (v1907 and (v1907>=100) and (v1907<=125)) then cfg.autoAgeBreaker.maxLevel=v1907;saveConfig();else v820.Text=tostring(cfg.autoAgeBreaker.maxLevel);end end);local v821=UI:frame(v807,UDim2.new(1,0,0,22),nil,T.BG,1);v821.LayoutOrder=4;local v823=UI:label(v821,"Target pets: " .. #cfg.autoAgeBreaker.targets ,UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),T.DIM,9);v823.Font=Enum.Font.Gotham;local v825=UI:button(v821,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v825,T.STROKE,1);local v826=UI:frame(v807,UDim2.new(1,0,0,26),nil,T.BTN);v826.LayoutOrder=45;UI:corner(v826,5);UI:stroke(v826,T.STROKE,1);UI:label(v826,"Manual Actions",UDim2.new(0,80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v829=UI:button(v826,"Claim",UDim2.new(0,54,0,20),UDim2.new(1, -118,0.5, -10),T.BTN,T.SUCCESS,9);do local v1908=Instance.new("UIStroke",v829);v1908.Color=T.SUCCESS;v1908.Thickness=1;end local v830=UI:button(v826,"Cancel",UDim2.new(0,54,0,20),UDim2.new(1, -58,0.5, -10),T.BTN,T.ERROR,9);do local v1912=Instance.new("UIStroke",v830);v1912.Color=T.ERROR;v1912.Thickness=1;end v829.MouseButton1Click:Connect(function() pcall(function() ClaimRemote:FireServer();end);end);v830.MouseButton1Click:Connect(function() pcall(function() CancelRemote:FireServer();end);end);local v831=UI:frame(v807,UDim2.new(1,0,0,26),nil,T.BTN);v831.LayoutOrder=5;UI:corner(v831,5);UI:stroke(v831,T.STROKE,1);UI:label(v831,"Skip Time Age Breaker",UDim2.new(1, -110,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;local v835=UI:label(v831,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),T.DIM,8);v835.Font=Enum.Font.Gotham;local v837,v838=UI:logPanel(v807,6,45);local v839=UI:frame(v807,UDim2.new(1,0,0,36),nil,T.PANEL);v839.LayoutOrder=7;UI:stroke(v839,T.STROKE,1);UI:label(v839,"AUTO AGE BREAKER",UDim2.new(0,120,0,20),UDim2.new(0,8,0.5, -10),T.TEXT,10).Font=Enum.Font.GothamBold;local v842=UI:label(v839,"● IDLE",UDim2.new(1, -180,1,0),UDim2.new(0,124,0,0),T.DIM,9);v842.Font=Enum.Font.Gotham;v842.TextTruncate=Enum.TextTruncate.AtEnd;local function v846(v1916,v1917) v842.Text=v1916;v842.TextColor3=v1917 or T.DIM ;end local function v847() while ageBreakRunning do local v2635=getMachineState();if not v2635 then task.wait(1);continue;end if ( not v2635.IsRunning and (v2635.TimeLeft<=0)) then break;end local v2636=v2635.TimeLeft or 0 ;v846(string.format("⏳ Waiting %s",HydraLib.fmtTime(v2636)),T.DIM);task.wait(ageBreakPollRate);end end local function v848() if skipTimeRunning then return;end skipTimeRunning=true;v835.Text="● ON";v835.TextColor3=T.SUCCESS;task.spawn(function() while skipTimeRunning do if not ageBreakRunning then v835.Text="● ON";v835.TextColor3=T.SUCCESS;task.wait(5);continue;end if (ageBreakClaiming or ageBreakReturning) then v835.Text="● Claiming";v835.TextColor3=T.DIM;task.wait(2);continue;end local v3270=getMachineState();local v3271=v3270 and v3270.IsRunning and v3270.TimeLeft and (v3270.TimeLeft>0) ;if v3271 then v838(string.format("Timer %s — mulai skip ke TW...",HydraLib.fmtTime(v3270.TimeLeft or 0 )),T.ACCENT);v835.Text="→ TW";v835.TextColor3=T.ACCENT;if TravelToTradeWorldRemote then if (ageBreakReturning or ageBreakClaiming) then v838("Travel diblock (claiming aktif), skip ke TW dibatal",T.DIM);else pcall(function() TravelToTradeWorldRemote:FireServer();end);task.wait(8);end end local v3900=0;while skipTimeRunning and ageBreakRunning do if (ageBreakClaiming or ageBreakReturning) then v838("Claiming aktif, stop hopping",T.DIM);break;end v3900=v3900 + 1 ;v835.Text=string.format("Hop %d",v3900);v835.TextColor3=T.ACCENT;local v4060=getMachineState();if (v4060 and not v4060.IsRunning and ((v4060.TimeLeft or 0)<=0)) then v838(string.format("Timer habis sebelum hop %d, stop hopping",v3900),T.SUCCESS);break;end if (v3900>50) then v838("Max hop 50 tercapai, paksa balik",T.DIM);break;end pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,Players.LocalPlayer);end);task.wait(5);local v4061=getMachineState();if (v4061 and not v4061.IsRunning and ((v4061.TimeLeft or 0)<=0)) then v838(string.format("Timer habis setelah hop %d!",v3900),T.SUCCESS);break;end end v838("Hop selesai, nunggu claim dari main loop...",T.DIM);v835.Text="● ON";v835.TextColor3=T.SUCCESS;else if (v3270 and v3270.PetReady) then v835.Text="● Ready";v835.TextColor3=T.SUCCESS;elseif (v3270 and v3270.SubmittedPet and not v3270.IsRunning) then v835.Text="● Submitted";v835.TextColor3=T.DIM;else v835.Text="● ON";v835.TextColor3=T.SUCCESS;end task.wait(5);end end v835.Text="● IDLE";v835.TextColor3=T.DIM;end);end local v849=Instance.new("Frame",v831);v849.Size=UDim2.new(0,44,0,22);v849.Position=UDim2.new(1, -48,0.5, -11);v849.BackgroundColor3=((cfg.autoAgeBreaker.skipEnabled or false) and T.TOGGLE_ON) or T.TOGGLE_OFF ;v849.BorderSizePixel=0;Instance.new("UICorner",v849).CornerRadius=UDim.new(0,11);local v855=Instance.new("Frame",v849);v855.Size=UDim2.new(0,18,0,18);v855.Position=((cfg.autoAgeBreaker.skipEnabled or false) and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;v855.BackgroundColor3=Color3.fromRGB(255,255,255);v855.BorderSizePixel=0;Instance.new("UICorner",v855).CornerRadius=UDim.new(0,9);local v861=Instance.new("TextButton",v849);v861.Size=UDim2.new(1,0,1,0);v861.BackgroundTransparency=1;v861.Text="";local v865=cfg.autoAgeBreaker.skipEnabled or false ;local function v866(v1923) v865=v1923;v849.BackgroundColor3=(v1923 and T.TOGGLE_ON) or T.TOGGLE_OFF ;v855.Position=(v1923 and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;end v861.MouseButton1Click:Connect(function() v865= not v865;cfg.autoAgeBreaker.skipEnabled=v865;saveConfig();v866(v865);if v865 then v848();else skipTimeRunning=false;v835.Text="● IDLE";v835.TextColor3=T.DIM;end end);local v867=UI:frame(levelingPage,UDim2.new(1,0,1,0),nil,T.BG);v867.Visible=false;v867.ZIndex=20;local v870=UI:frame(v867,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v870,T.STROKE,1);UI:label(v870,"Select Target Pets (Age 100+)",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v871=UI:button(v870,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v871,T.ERROR,1);v871.MouseButton1Click:Connect(function() v867.Visible=false;v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;end);local v872=UI:input(v867,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v872.TextColor3=T.TEXT;v872.Font=Enum.Font.Gotham;local v876=UI:scroll(v867,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v876,3);UI:pad(v876,3,4,4,3);local function v877() for v2640,v2641 in ipairs(v876:GetChildren()) do if v2641:IsA("GuiObject") then v2641:Destroy();end end local v1929=getInventory();local v1930=string.lower(v872.Text);local v1931={};for v2642,v2643 in pairs(v1929) do if ( not v2643 or not v2643.PetData) then continue;end local v2644=v2643.PetData.Level or 0 ;if (v2644<100) then continue;end if ((v1930~="") and not string.lower(v2643.PetType or "" ):find(v1930,1,true)) then continue;end table.insert(v1931,v2642);end table.sort(v1931,function(v2645,v2646) return getKG(v2645)>getKG(v2646) ;end);for v2647,v2648 in ipairs(v1931) do local v2649=v1929[v2648];if not v2649 then continue;end local v2650=table.find(cfg.autoAgeBreaker.targets,v2648)~=nil ;local v2651=v2649.PetData.Level or 0 ;local v2652=getKG(v2648);local v2653=v2649.PetData.BaseWeight or 0 ;local v2654=(isFavorited(v2648) and " ❤") or "" ;local v2655=getPetMutName(v2648);local v2656=((v2655~="") and (" [" .. v2655 .. "]")) or "" ;local v2657=((v2656~="") and string.format('%s',v2656)) or "" ;local v2658=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2649.PetType or "?" ,v2657,v2654,v2651,v2652,v2653);local v2659=UI:button(v876,v2658,UDim2.new(1,0,0,22),nil,(v2650 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2650 and T.SEL_TXT) or T.TEXT ,9);v2659.LayoutOrder=v2647;v2659:SetAttribute("uuid",v2648);v2659.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2659,0,8,4,0);UI:stroke(v2659,(v2650 and T.ACCENT) or T.STROKE ,1);v2659.MouseButton1Click:Connect(function() local v3275=table.find(cfg.autoAgeBreaker.targets,v2648);if v3275 then table.remove(cfg.autoAgeBreaker.targets,v3275);else table.insert(cfg.autoAgeBreaker.targets,v2648);end saveConfig();v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;UI:updateRowVisual(v2659,table.find(cfg.autoAgeBreaker.targets,v2648)~=nil ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end);end end v872:GetPropertyChangedSignal("Text"):Connect(v877);v825.MouseButton1Click:Connect(function() v867.Visible=true;v877();end);local function v878() local v1933={};for v2663,v2664 in ipairs(cfg.autoAgeBreaker.targets) do table.insert(v1933,v2664);end for v2665,v2666 in ipairs(v1933) do if not ageBreakRunning then break;end do local v3277=getMachineState();if v3277 then if v3277.PetReady then v838(string.format("[%d/%d] Startup: machine ready, claiming...",v2665, #v1933),T.DIM);ageBreakClaiming=true;ensureMainWorld(v838);pcall(function() ClaimRemote:FireServer();end);task.wait(1.5);ageBreakClaiming=false;elseif (v3277.IsRunning or (v3277.TimeLeft and (v3277.TimeLeft>0))) then v838(string.format("[%d/%d] Startup: machine running (%s), waiting...",v2665, #v1933,HydraLib.fmtTime(v3277.TimeLeft or 0 )),T.DIM);v847();if not ageBreakRunning then break;end local v4276=getMachineState();if (v4276 and v4276.PetReady) then v838("Claiming after wait...",T.DIM);ageBreakClaiming=true;ensureMainWorld(v838);pcall(function() ClaimRemote:FireServer();end);task.wait(1.5);ageBreakClaiming=false;end elseif (v3277.SubmittedPet and not v3277.PetReady) then v838(string.format("[%d/%d] Startup: ada pet di mesin, cancel dulu...",v2665, #v1933),T.DIM);pcall(function() CancelRemote:FireServer();end);task.wait(1.5);end end end if not ageBreakRunning then break;end local v2667=getInventory();if not v2667[v2666] then local v3660=getMachineState();local v3661=false;if (v3660 and v3660.SubmittedPet) then local v4062=v3660.SubmittedPet;local v4063=((type(v4062)=="string") and v4062) or ((type(v4062)=="table") and (v4062.UUID or v4062.uuid or v4062.Id or v4062.id)) or nil ;if (v4063==v2666) then v3661=true;v838(string.format("[%d/%d] Pet target ada di machine, tunggu selesai...",v2665, #v1933),T.DIM);v847();if not ageBreakRunning then break;end local v4230=getMachineState();if (v4230 and v4230.PetReady) then ageBreakClaiming=true;ensureMainWorld(v838);pcall(function() ClaimRemote:FireServer();end);task.wait(1.5);ageBreakClaiming=false;end end end if not v3661 then v838(string.format("[%d/%d] Skip — not in inventory",v2665, #v1933),T.DIM);local v4064=table.find(cfg.autoAgeBreaker.targets,v2666);if v4064 then table.remove(cfg.autoAgeBreaker.targets,v4064);saveConfig();end v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;continue;end v2667=getInventory();if not v2667[v2666] then v838(string.format("[%d/%d] Skip — masih tidak ada di inventory",v2665, #v1933),T.DIM);local v4066=table.find(cfg.autoAgeBreaker.targets,v2666);if v4066 then table.remove(cfg.autoAgeBreaker.targets,v4066);saveConfig();end v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;continue;end end local v2668=getPetType(v2666);local v2669=v2668;local v2670=getAge(v2666);v838(string.format("[%d/%d] START %s (Age %d)",v2665, #v1933,v2668,v2670),T.ACCENT);if (v2670<100) then v838("Skip — target not age 100",T.DIM);continue;end local v2671=cfg.autoAgeBreaker.maxLevel or 125 ;while ageBreakRunning do local v3278=getAge(v2666);v846(string.format("Age %d/%d | %s",v3278,v2671,v2668),T.ACCENT);if (v3278>=v2671) then v838(string.format("✓ DONE %s reached Age %d!",v2668,v2671),T.SUCCESS);local v3902=table.find(cfg.autoAgeBreaker.targets,v2666);if v3902 then table.remove(cfg.autoAgeBreaker.targets,v3902);saveConfig();end v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;break;end local v3279=getMachineState();if not v3279 then task.wait(1);continue;end if (v3279.IsRunning or (v3279.TimeLeft>0)) then v838("Machine running, waiting...",T.DIM);v847();if not ageBreakRunning then break;end v3279=getMachineState();end if (v3279 and v3279.PetReady) then ageBreakClaiming=true;v838("Claiming...",T.SUCCESS);v846("Claiming " .. v2668 ,T.SUCCESS);ensureMainWorld(v838);pcall(function() ClaimRemote:FireServer();end);task.wait(1.5);ageBreakClaiming=false;local v3904=getAge(v2666);v838(string.format("Claimed! Age now: %d",v3904),T.SUCCESS);if (v3904>=v2671) then v838(string.format("✓ DONE %s reached Age %d!",v2668,v2671),T.SUCCESS);local v4146=table.find(cfg.autoAgeBreaker.targets,v2666);if v4146 then table.remove(cfg.autoAgeBreaker.targets,v4146);saveConfig();end v823.Text="Target pets: " .. #cfg.autoAgeBreaker.targets ;break;end v838("Re-leveling after claim...",T.DIM);local v3905=os.clock();while ageBreakRunning do task.wait(ageBreakPollRate);local v4068=getAge(v2666);v846(string.format("Re-leveling... Lv%d/100 | %s",v4068,v2668),T.DIM);if (v4068>=100) then v838(string.format("Target back to Age %d, next cycle",v4068),T.ACCENT);break;end if ((os.clock() -v3905)>3600) then v838("Timeout waiting for re-level",T.ERROR);break;end end continue;end local v3280=getPetType(v2666);local v3281=false;if (v3279 and v3279.SubmittedPet and not v3279.IsRunning and not v3279.PetReady) then local v3906=v3279.SubmittedPet;local v3907=((type(v3906)=="string") and v3906) or ((type(v3906)=="table") and (v3906.UUID or v3906.uuid or v3906.Id or v3906.id)) or nil ;if (v3907==v2666) then v838("Target sudah ada di mesin, langsung cari tumbal...",T.DIM);v3281=true;else v838(string.format("Pet lain di mesin (uuid=%s), cancel dulu...",tostring(v3907 or "nil" )),T.DIM);pcall(function() CancelRemote:FireServer();end);task.wait(1.5);end end if not v3281 then v838(string.format("Submitting target: %s to machine...",v2668),T.DIM);v846(string.format("Submitting target %s",v2668),T.DIM);local v3908=holdPetTool(v2666);if not v3908 then v838("Failed to equip target pet tool",T.ERROR);task.wait(1);continue;end pcall(function() SubmitHeldRemote:FireServer();end);task.wait(1.5);local v3909=Character:FindFirstChildWhichIsA("Tool");if (v3909 and v3909:GetAttribute("PET_UUID")) then v3909.Parent=Backpack;end task.wait(0.3);v838("Waiting for machine to receive target...",T.DIM);local v3910=os.clock();while ageBreakRunning do local v4069=getMachineState();if (v4069 and v4069.SubmittedPet) then break;end if ((os.clock() -v3910)>5) then v838("Timeout waiting for SubmittedPet!",T.ERROR);break;end task.wait(0.5);end if not ageBreakRunning then break;end end local v3282=findTumbalPet(v2666,v3280);if not v3282 then v838("No tumbal available! Stopping.",T.ERROR);ageBreakRunning=false;break;end local v3283=getPetType(v3282);local v3284=getAge(v3282);local v3285=getKG(v3282);v838(string.format("Submitting tumbal: %s Age %d %.2fkg",v3283,v3284,v3285),T.DIM);v846(string.format("Submitting tumbal %s",v3283),T.DIM);pcall(function() SubmitPairRemote:FireServer({v3282});end);task.wait(1.5);v838("Waiting for machine...",T.DIM);local v3286=os.clock();while ageBreakRunning do local v3662=getMachineState();if (v3662 and (v3662.IsRunning or (v3662.TimeLeft and (v3662.TimeLeft>0)))) then break;end if ((os.clock() -v3286)>5) then v838("Machine didn't start, retrying...",T.ERROR);break;end task.wait(0.5);end v847();if not ageBreakRunning then break;end end end ageBreakRunning=false;v838("════ ALL DONE ════",T.ACCENT);v846("● IDLE",T.DIM);end local function v879() local v1934,v1935=pcall(function() v878();end);if not v1934 then v838("Error: " .. tostring(v1935) ,T.ERROR);v846("● IDLE",T.DIM);end ageBreakRunning=false;v846("● IDLE",T.DIM);end local v880=Instance.new("Frame",v839);v880.Size=UDim2.new(0,44,0,22);v880.Position=UDim2.new(1, -48,0.5, -11);v880.BackgroundColor3=((cfg.autoAgeBreaker.autoStart or false) and T.TOGGLE_ON) or T.TOGGLE_OFF ;v880.BorderSizePixel=0;Instance.new("UICorner",v880).CornerRadius=UDim.new(0,11);local v886=Instance.new("Frame",v880);v886.Size=UDim2.new(0,18,0,18);v886.Position=((cfg.autoAgeBreaker.autoStart or false) and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;v886.BackgroundColor3=Color3.fromRGB(255,255,255);v886.BorderSizePixel=0;Instance.new("UICorner",v886).CornerRadius=UDim.new(0,9);local v892=Instance.new("TextButton",v880);v892.Size=UDim2.new(1,0,1,0);v892.BackgroundTransparency=1;v892.Text="";local v896=cfg.autoAgeBreaker.autoStart or false ;local function v897(v1936) v896=v1936;v880.BackgroundColor3=(v1936 and T.TOGGLE_ON) or T.TOGGLE_OFF ;v886.Position=(v1936 and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;end v892.MouseButton1Click:Connect(function() v896= not v896;v897(v896);if v896 then if ( #cfg.autoAgeBreaker.targets==0) then v838("Pilih target pets dulu!",T.ERROR);v896=false;v897(false);return;end cfg.autoAgeBreaker.autoStart=true;saveConfig();ageBreakRunning=true;v838("════ AUTO AGE BREAKER START ════",T.ACCENT);v846("Starting...",T.SUCCESS);task.spawn(function() local v3663,v3664=pcall(v879);if not v3663 then v838("Error: " .. tostring(v3664) ,T.ERROR);end ageBreakRunning=false;v896=false;v897(false);cfg.autoAgeBreaker.autoStart=false;saveConfig();v846("● IDLE",T.DIM);end);else ageBreakRunning=false;skipTimeRunning=false;cfg.autoAgeBreaker.autoStart=false;saveConfig();v838("─── Stopped ───",T.ERROR);v846("● IDLE",T.DIM);end end);if cfg.autoAgeBreaker.skipEnabled then task.defer(v848);end if (cfg.autoAgeBreaker.autoStart and ( #cfg.autoAgeBreaker.targets>0)) then task.delay(1.5,function() if not ageBreakRunning then v896=true;v897(true);ageBreakRunning=true;v838("════ AUTO RESUME ════",T.ACCENT);v846("Resuming...",T.SUCCESS);task.spawn(function() local v4070,v4071=pcall(v879);if not v4070 then v838("Error: " .. tostring(v4071) ,T.ERROR);end ageBreakRunning=false;v896=false;v897(false);cfg.autoAgeBreaker.autoStart=false;saveConfig();v846("● IDLE",T.DIM);end);end end);end v838("Auto Age Breaker ready!",T.SUCCESS);end buildAutoAgeBreakerSection();local function buildAutoMutMachineSection() local mutMachineRunning=false;local mutMachinePollRate=2;local MutMachineRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetMutationMachineService_RE");local mutationTypeList={};do local v1939,v1940=pcall(function() return require(RS.Data.PetRegistry.PetMutationRegistry);end);if (v1939 and v1940) then for v3666,v3667 in pairs(v1940.MachineMutationTypes or {} ) do table.insert(mutationTypeList,{key=v3666,name=v3666});end end table.insert(mutationTypeList,{key="GiantGolem",name="GiantGolem"});table.sort(mutationTypeList,function(v2672,v2673) return v2672.name=1) and (v1981<=99)) then cfg.autoMutMachine.lvThresh=v1981;saveConfig();else v944.Text=tostring(cfg.autoMutMachine.lvThresh);end end);local v945=UI:frame(v911,UDim2.new(1,0,0,22),nil,T.BG,1);v945.LayoutOrder=13;local v947=UI:label(v945,"Target pets: " .. #cfg.autoMutMachine.targets ,UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),T.DIM,9);v947.Font=Enum.Font.Gotham;local v949=UI:button(v945,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v949,T.STROKE,1);local v950,v951=UI:logPanel(v911,14,45);local v952=UI:frame(v911,UDim2.new(1,0,0,36),nil,T.PANEL);v952.LayoutOrder=15;UI:stroke(v952,T.STROKE,1);UI:label(v952,"AUTO MUTATION MACHINE",UDim2.new(0,140,0,20),UDim2.new(0,8,0.5, -10),T.TEXT,10).Font=Enum.Font.GothamBold;local v955=UI:label(v952,"● IDLE",UDim2.new(1, -200,1,0),UDim2.new(0,144,0,0),T.DIM,9);v955.Font=Enum.Font.Gotham;v955.TextTruncate=Enum.TextTruncate.AtEnd;local function v959(v1982,v1983) v955.Text=v1982;v955.TextColor3=v1983 or T.DIM ;end local function v960(v1986,v1987,v1988) return buildTeamDropdown(v1986,v1987,v1988,UI,cfg,T);end local v961,v962,v963,v964=false,false,false,false;v919.MouseButton1Click:Connect(function() v961= not v961;v923.Visible=false;v962=false;v926.Visible=false;v963=false;v920.Visible=v961;if v961 then local v3291=v960(v921,function(v3669) cfg.autoMutMachine.cdTeam=v3669;saveConfig();v919.Text=v3669;v920.Visible=false;v961=false;end,cfg.autoMutMachine.cdTeam);v920.Size=UDim2.new(1,0,0,math.min((v3291 * 24) + 6 ,130));end end);v922.MouseButton1Click:Connect(function() v962= not v962;v920.Visible=false;v961=false;v926.Visible=false;v963=false;v923.Visible=v962;if v962 then local v3293=v960(v924,function(v3673) cfg.autoMutMachine.claimTeam=v3673;saveConfig();v922.Text=v3673;v923.Visible=false;v962=false;end,cfg.autoMutMachine.claimTeam);v923.Size=UDim2.new(1,0,0,math.min((v3293 * 24) + 6 ,130));end end);v925.MouseButton1Click:Connect(function() v963= not v963;v920.Visible=false;v961=false;v923.Visible=false;v962=false;v929.Visible=false;v964=false;v926.Visible=v963;if v963 then local v3295=v960(v927,function(v3677) cfg.autoMutMachine.lvTeam=v3677;saveConfig();v925.Text=v3677;v926.Visible=false;v963=false;end,cfg.autoMutMachine.lvTeam);v926.Size=UDim2.new(1,0,0,math.min((v3295 * 24) + 6 ,130));end end);v928.MouseButton1Click:Connect(function() v964= not v964;v920.Visible=false;v961=false;v923.Visible=false;v962=false;v926.Visible=false;v963=false;v929.Visible=v964;if v964 then local v3297=v960(v930,function(v3681) cfg.autoMutMachine.lvTeam2=v3681;saveConfig();v928.Text=v3681;v929.Visible=false;v964=false;end,cfg.autoMutMachine.lvTeam2);v929.Size=UDim2.new(1,0,0,math.min((v3297 * 24) + 6 ,130));end end);local v965=UI:frame(levelingPage,UDim2.new(1,0,1,0),nil,T.BG);v965.Visible=false;v965.ZIndex=20;local v968=UI:frame(v965,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v968,T.STROKE,1);UI:label(v968,"Select Target Pets (Mutation Machine)",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v969=UI:button(v968,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v969,T.ERROR,1);v969.MouseButton1Click:Connect(function() v965.Visible=false;v947.Text="Target pets: " .. #cfg.autoMutMachine.targets ;end);local v970=UI:input(v965,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v970.TextColor3=T.TEXT;v970.Font=Enum.Font.Gotham;local v974=UI:scroll(v965,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v974,3);UI:pad(v974,3,4,4,3);local function v975() for v2682,v2683 in ipairs(v974:GetChildren()) do if v2683:IsA("GuiObject") then v2683:Destroy();end end local v2005=getInventory();local v2006=string.lower(v970.Text);local v2007={};for v2684 in pairs(v2005) do table.insert(v2007,v2684);end table.sort(v2007,function(v2685,v2686) return getKG(v2685)>getKG(v2686) ;end);for v2687,v2688 in ipairs(v2007) do local v2689=v2005[v2688];if not v2689 then continue;end if ((v2006~="") and not string.lower(v2689.PetType or "" ):find(v2006,1,true)) then continue;end local v2690=table.find(cfg.autoMutMachine.targets,v2688)~=nil ;local v2691=(v2689.PetData and (v2689.PetData.Level or 0)) or 0 ;local v2692=getKG(v2688);local v2693=(v2689.PetData and (v2689.PetData.BaseWeight or 0)) or 0 ;local v2694=(isFavorited(v2688) and " ❤") or "" ;local v2695=getMutType(v2688);local v2696=(v2695 and (" [" .. (MutationMap[v2695] or v2695) .. "]")) or "" ;local v2697=((v2696~="") and string.format('%s',v2696)) or "" ;local v2698=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2689.PetType or "?" ,v2697,v2694,v2691,v2692,v2693);local v2699=UI:button(v974,v2698,UDim2.new(1,0,0,22),nil,(v2690 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2690 and T.SEL_TXT) or T.TEXT ,9);v2699.LayoutOrder=v2687;v2699:SetAttribute("uuid",v2688);v2699.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2699,0,8,4,0);UI:stroke(v2699,(v2690 and T.ACCENT) or T.STROKE ,1);v2699.MouseButton1Click:Connect(function() local v3299=table.find(cfg.autoMutMachine.targets,v2688);if v3299 then table.remove(cfg.autoMutMachine.targets,v3299);else table.insert(cfg.autoMutMachine.targets,v2688);end saveConfig();v947.Text="Target pets: " .. #cfg.autoMutMachine.targets ;UI:updateRowVisual(v2699,table.find(cfg.autoMutMachine.targets,v2688)~=nil ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end);end end v970:GetPropertyChangedSignal("Text"):Connect(v975);v949.MouseButton1Click:Connect(function() v965.Visible=true;v975();end);local v976=false;local v977=nil;local v978={};local function v979() v976=true;task.spawn(function() while v976 do task.wait(boostTimingCfg.TEAM_CHECK);if (globalFlags.IsEquipping or not mutMachineRunning or not v977) then continue;end if mmCDActive then continue;end local v3301={};v3301[v977]=true;for v3685,v3686 in ipairs(v978) do v3301[v3686]=true;end local v3303=getActivePets();local v3304,v3305={},{};for v3688 in pairs(v3301) do local v3689=false;for v3911,v3912 in ipairs(v3303) do if (v3912==v3688) then v3689=true;break;end end if not v3689 then table.insert(v3304,v3688);end end for v3690,v3691 in ipairs(v3303) do if not v3301[v3691] then table.insert(v3305,v3691);end end if (( #v3305>0) or ( #v3304>0)) then globalFlags.IsEquipping=true;for v4073,v4074 in ipairs(v3305) do pcall(function() PetsRemote:FireServer("UnequipPet",v4074);end);task.wait(timingCfg.EQUIP_DELAY);end local v3914=getFarmCF();for v4075,v4076 in ipairs(v3304) do pcall(function() PetsRemote:FireServer("EquipPet",v4076,v3914);end);task.wait(timingCfg.EQUIP_DELAY);end globalFlags.IsEquipping=false;end end end);end local function v980() v976=false;v978={};v977=nil;end local function v981(v2009,v2010) if ( not v2009 or ( #v2009==0)) then unequipAll();task.wait(0.3);return true;end local v2011=getActivePets();local v2012={};for v2703,v2704 in ipairs(v2011) do v2012[v2704]=true;end local v2013= #v2011== #v2009 ;if v2013 then for v3692,v3693 in ipairs(v2009) do if not v2012[v3693] then v2013=false;break;end end end if v2013 then v2010("✓ Claim team already correct",T.DIM);return true;end v2010("Re-equipping claim team before claim...",T.DIM);unequipAll();task.wait(0.5);equipList(v2009);local v2014=waitUntilEquipped(v2009,8);task.wait(0.5);if not v2014 then v2010("⚠ Claim team verify timeout",T.ERROR);end return v2014;end local function v982(v2015,v2016) local v2017=getTeamUUIDs(cfg.autoMutMachine.lvTeam);local v2018=getTeamUUIDs(cfg.autoMutMachine.lvTeam2);local v2019=getTeamUUIDs(cfg.autoMutMachine.cdTeam);local v2020=getTeamUUIDs(cfg.autoMutMachine.claimTeam);local v2021=cfg.autoMutMachine.lvThresh or 50 ;local v2022=cfg.autoMutMachine.targetMut or "Golden" ;local v2023=nil;do local v2706,v2707=pcall(function() return require(RS.Data.PetRegistry.PetMutationRegistry);end);if (v2706 and v2707) then v2023=v2707.PetMutationToEnum[v2022];end end local v2024={};for v2708,v2709 in ipairs(cfg.autoMutMachine.targets) do table.insert(v2024,v2709);end for v2710,v2711 in ipairs(v2024) do if not mutMachineRunning then break;end do local v3306=getMachineData();if v3306 then if (v3306.IsRunning or (v3306.TimeLeft>0)) then v2015(string.format("[%d/%d] Startup: machine running, wear CD & waiting...",v2710, #v2024),T.DIM);if ( #v2019>0) then mmCDActive=true;mmSuppressPP=mmSuppressValue;_G.MM_SuppressPickPlace=mmSuppressValue;unequipAll();task.wait(0.3);equipList(v2019);waitUntilEquipped(v2019,8);end waitForMachineFinish(v2015,v2016);mmSuppressPP=false;_G.MM_SuppressPickPlace=false;mmCDActive=false;if not mutMachineRunning then break;end end v3306=getMachineData();if (v3306 and v3306.PetReady) then local v4149=v3306.SubmittedPet;local v4150=((type(v4149)=="string") and v4149) or ((type(v4149)=="table") and (v4149.UUID or v4149.uuid or v4149.Id or v4149.id)) or nil ;local v4151=(v4150==nil) or (v4150==v2711) ;v2015(string.format("Startup claim: pet=%s isOurs=%s",tostring(v4150 or "nil" ),tostring(v4151)),T.DIM);if ( #v2020>0) then unequipAll();task.wait(0.5);equipList(v2020);waitUntilEquipped(v2020,8);task.wait(0.5);end pcall(function() MutMachineRemote:FireServer("ClaimMutatedPet");end);task.wait(2);unequipAll();task.wait(0.5);if not mutMachineRunning then break;end end end end if not mutMachineRunning then break;end local v2712=getInventory();if not v2712[v2711] then v2015(string.format("[%d/%d] Skip — not in inventory",v2710, #v2024),T.DIM);continue;end local v2713=getPetType(v2711);v2015(string.format("[%d/%d] START %s | target: %s",v2710, #v2024,v2713,v2022),T.ACCENT);local v2714=false;local v2715=0;while mutMachineRunning and not v2714 do v2715+=1 local v3307=getMutPetAge(v2711);if (v33070) then v977=v2711;v978=v2017;equipList(buildEquipList(v2711,v2017));local v4152=v3307;while mutMachineRunning do task.wait(timingCfg.POLL_RATE);local v4231=getMutPetAge(v2711);v2016(string.format("Lv%d/%d | %s",v4231,v2021,v2713),T.DIM);if (v4231>=v2021) then v2015(string.format("Level %d reached!",v4231),T.ACCENT);break;end end unequipAll();task.wait(0.5);else v2015("No leveling team set, waiting for level " .. v2021 ,T.DIM);while mutMachineRunning do task.wait(mutMachinePollRate);local v4232=getMutPetAge(v2711);v2016(string.format("Waiting Lv%d/%d | %s",v4232,v2021,v2713),T.DIM);if (v4232>=v2021) then break;end end end if not mutMachineRunning then break;end end local v3308=getMachineData();if (v3308 and (v3308.IsRunning or (v3308.TimeLeft>0))) then local v3915=v3308.SubmittedPet;local v3916=((type(v3915)=="string") and v3915) or ((type(v3915)=="table") and (v3915.UUID or v3915.uuid or v3915.Id or v3915.id)) or nil ;local v3917=(v3916==nil) or (v3916==v2711) ;if v3917 then v2015("Pet target is in machine, waiting to finish...",T.DIM);else v2015(string.format("⚠ Machine has OTHER pet, wear CD & wait... pet=%s",tostring(v3916 or "nil" )),T.DIM);end if ( #v2019>0) then mmCDActive=true;mmSuppressPP=mmSuppressValue;_G.MM_SuppressPickPlace=mmSuppressValue;unequipAll();task.wait(0.3);equipList(v2019);waitUntilEquipped(v2019,8);end waitForMachineFinish(v2015,v2016);mmSuppressPP=false;_G.MM_SuppressPickPlace=false;mmCDActive=false;if not mutMachineRunning then break;end v3308=getMachineData();end if (v3308 and v3308.PetReady) then local v3918=v3308.SubmittedPet;local v3919=((type(v3918)=="string") and v3918) or ((type(v3918)=="table") and (v3918.UUID or v3918.uuid or v3918.Id or v3918.id)) or nil ;local v3920=(v3919==nil) or (v3919==v2711) ;if not v3920 then v2015("⚠ Machine result is not our target, claiming first...",T.DIM);else v2015("Claiming machine result (our target)...",T.DIM);end v2015("Ensuring claim team before claim...",T.DIM);v981(v2020,v2015);pcall(function() MutMachineRemote:FireServer("ClaimMutatedPet");end);task.wait(2);if not v3920 then v2015("Other pet claimed, checking & leveling target then submit...",T.ACCENT);unequipAll();task.wait(0.5);local v4153=getMutPetAge(v2711);if ((v41530)) then v2015(string.format("Leveling target to %d first (now Lv%d)...",v2021,v4153),T.DIM);equipList(buildEquipList(v2711,v2017));while mutMachineRunning do task.wait(timingCfg.POLL_RATE);local v4336=getMutPetAge(v2711);v2016(string.format("Re-level Lv%d/%d | %s",v4336,v2021,v2713),T.DIM);if (v4336>=v2021) then v2015(string.format("Level %d tercapai!",v4336),T.ACCENT);break;end end unequipAll();task.wait(0.5);end if not mutMachineRunning then break;end else local v4154=getMutType(v2711);if (v4154==v2023) then v2015(string.format("✓ GOT %s on %s!",v2022,v2713),T.SUCCESS);v2714=true;unequipAll();break;else local v4277=(v4154 and (MutationMap[v4154] or v4154)) or "none" ;v2015(string.format("Got %s, not %s — re-level & retry",v4277,v2022),T.ERROR);unequipAll();task.wait(0.5);end if v2714 then break;end if ( #v2017>0) then v2015("Re-leveling pet to threshold...",T.DIM);equipList(buildEquipList(v2711,v2017));while mutMachineRunning do task.wait(timingCfg.POLL_RATE);local v4337=getMutPetAge(v2711);v2016(string.format("Re-level Lv%d/%d | %s",v4337,v2021,v2713),T.DIM);if (v4337>=v2021) then v2015(string.format("Level %d tercapai!",v4337),T.ACCENT);break;end end unequipAll();task.wait(0.5);end if not mutMachineRunning then break;end end end v2015(string.format("Submitting %s to machine...",v2713),T.DIM);v2016(string.format("Submitting %s",v2713),T.DIM);local v3309=holdPetAsTool(v2711);if not v3309 then v2015("Failed to equip pet as held tool",T.ERROR);task.wait(1);continue;end pcall(function() MutMachineRemote:FireServer("SubmitHeldPet");end);task.wait(1);local v3310=Character:FindFirstChildWhichIsA("Tool");if (v3310 and v3310:GetAttribute("PET_UUID")) then v3310.Parent=Backpack;end task.wait(0.3);task.wait(0.5);pcall(function() MutMachineRemote:FireServer("StartMachine");end);task.wait(1);if ( #v2019>0) then v2015("Wearing CD team...",T.DIM);mmCDActive=true;mmSuppressPP=mmSuppressValue;_G.MM_SuppressPickPlace=mmSuppressValue;unequipAll();task.wait(0.5);equipList(v2019);waitUntilEquipped(v2019,8);end waitForMachineFinish(v2015,v2016);mmSuppressPP=false;_G.MM_SuppressPickPlace=false;mmCDActive=false;if not mutMachineRunning then break;end v2015("Ensuring claim team before claim...",T.DIM);v981(v2020,v2015);v2015("Claiming...",T.SUCCESS);v2016("Claiming " .. v2713 ,T.SUCCESS);pcall(function() MutMachineRemote:FireServer("ClaimMutatedPet");end);task.wait(1.5);unequipAll();local v3311=getMutType(v2711);if (v3311==v2023) then v2015(string.format("✓ GOT %s on %s!",v2022,v2713),T.SUCCESS);v2016(string.format("✓ %s! %s",v2022,v2713),T.SUCCESS);v2714=true;local v3922=table.find(cfg.autoMutMachine.targets,v2711);if v3922 then table.remove(cfg.autoMutMachine.targets,v3922);saveConfig();end v947.Text="Target pets: " .. #cfg.autoMutMachine.targets ;if cfg.autoMutMachine.lvTo100 then local v4155=(cfg.autoMutMachine.lv2Enabled and ( #v2018>0) and v2018) or v2017 ;if ( #v4155>0) then v2015("Leveling to 100 after mutation...",T.ACCENT);v2016(string.format("Leveling %s to 100",v2713),T.ACCENT);unequipAll();task.wait(0.5);local v4278=false;equipList(buildEquipList(v2711,v2017));while mutMachineRunning do task.wait(timingCfg.POLL_RATE);local v4338=getMutPetAge(v2711);v2016(string.format("Lv%d/100 | %s",v4338,v2713),T.DIM);if ( not v4278 and cfg.autoMutMachine.lv2Enabled and ( #v2018>0) and (v4338>=v2021)) then v4278=true;v2015(string.format("Switch to lv2 team at Lv%d",v4338),T.ACCENT);unequipAll();task.wait(0.5);v977=v2711;v978=v2018;equipList(buildEquipList(v2711,v2018));end if (v4338>=100) then v2015(string.format("✓ Lv100 done! %s",v2713),T.SUCCESS);unequipAll();break;end end else v2015("⚠ Level to 100 ON but no team set!",T.ERROR);end end else local v3924=(v3311 and (MutationMap[v3311] or v3311)) or "none" ;v2015(string.format("Got %s, not %s — retry (re-level to %d)",v3924,v2022,v2021),T.ERROR);if ( #v2017>0) then v2015("Re-leveling pet...",T.DIM);equipList(buildEquipList(v2711,v2017));while mutMachineRunning do task.wait(timingCfg.POLL_RATE);local v4233=getMutPetAge(v2711);v2016(string.format("Re-level Lv%d/%d | %s",v4233,v2021,v2713),T.DIM);if (v4233>=v2021) then v2015(string.format("Re-leveled to %d!",v4233),T.ACCENT);break;end end unequipAll();task.wait(0.5);end end end if not mutMachineRunning then break;end if v2714 then v2015("Next pet...",T.DIM);task.wait(1);end end mutMachineRunning=false;v2015("════ ALL DONE ════",T.ACCENT);v2016("● IDLE",T.DIM);end if not cfg.autoMutMachine then cfg.autoMutMachine.running=false;end if (cfg.autoMutMachine.running==nil) then cfg.autoMutMachine.running=false;end UI:toggle(v952,UDim2.new(1, -52,0.5, -11),cfg.autoMutMachine.running or false ,function(v2025) cfg.autoMutMachine.running=v2025;saveConfig();if v2025 then if ( #cfg.autoMutMachine.targets==0) then v951("Pilih target pets dulu!",T.ERROR);return;end mutMachineRunning=true;v951("════ AUTO MUTATION MACHINE START ════",T.ACCENT);v959("Starting...",T.SUCCESS);v979();task.spawn(function() v982(v951,v959);v980();end);else mutMachineRunning=false;v980();v951("─── Stopped ───",T.ERROR);v959("● IDLE",T.DIM);end end);if cfg.autoMutMachine.running then mutMachineRunning=true;task.defer(function() v979();task.spawn(function() v982(v951,v959);v980();end);end);end v951("Auto Mutation Machine ready!",T.SUCCESS);end buildAutoMutMachineSection();local function buildTeamsUI() local v983=UI:scroll(teamsPage,UDim2.new(1,0,1, -38));UI:list(v983,5);UI:pad(v983,6,6,6,6);local v984=UI:label(v983,"Pet Teams",UDim2.new(1,0,0,16),nil,T.ACCENT,11);v984.LayoutOrder=0;local v986=UI:frame(v983,UDim2.new(1,0,0,26),nil,T.BG,1);v986.LayoutOrder=1;local v988=UI:input(v986,"","Team name...",UDim2.new(1, -86,0,20),UDim2.new(0,0,0,2));v988.TextColor3=T.TEXT;local v991=UI:button(v986,"Save Active Pets",UDim2.new(0,82,0,20),UDim2.new(1, -84,0,2),T.ACCENT,T.SEL_TXT,8);UI:stroke(v991,T.ACCENT,1);local v992=UI:label(v983,"Saved Teams",UDim2.new(1,0,0,14),nil,T.DIM,9);v992.Font=Enum.Font.Gotham;v992.LayoutOrder=2;local v996=UI:frame(v983,UDim2.new(1,0,0,0),nil,T.BG,1);v996.LayoutOrder=3;v996.AutomaticSize=Enum.AutomaticSize.Y;UI:list(v996,4);local v1000={};local v1001={a=0,b=0.1,c=0.2,d=0.3,e=0,f=0,g=0.5,h=0,i=0,j=0,k=0,l=0,m=0,n=0,o=0,p=0,q=0,r=0,s=0.05,t=0,u=0,v=0,w=0,x=0,y=0,z=0.08,A=0.22,B=0,H=0,I=0,J=0.01,K=0.03,L=0.045,M=0.06,N=0.07,O=0.07,P=0.3,Q=0,R=0,S=0,T=0,U=0,V=0.2,W=0,X=0.3,Y=0.3,Z=0.3,["@"]=0.23,EV=0.3,RJ=0.25,SS=0};local function v1002(v2027) local v2028=getInventory();local v2029=v2028[v2027];if ( not v2029 or not v2029.PetData) then return 0;end local v2030=v2029.PetData.BaseWeight or 0 ;local v2031=v2029.PetData.MutationType or "m" ;return v2030 * (1 + (v1001[v2031] or 0)) ;end local function v1003(v2032,v2033) task.spawn(function() local v2718=getInventory();local v2719={};for v3312,v3313 in pairs(v2718) do local v3314=v3313.PetType or "" ;if not v2719[v3314] then v2719[v3314]={};end table.insert(v2719[v3314],v3312);end for v3315,v3316 in pairs(v2719) do table.sort(v3316,function(v3695,v3696) return v1002(v3695)>v1002(v3696) ;end);end local v2720={};if ((v2033=="Bronto Max Passive") or (v2033=="Magpie Method")) then v2720=getTeamUUIDs(v2033);else for v3926,v3927 in ipairs(v2032) do local v3928=v2719[v3927.petType] or {} ;local v3929=0;for v4077,v4078 in ipairs(v3928) do if ( #v2720>=8) then break;end if (v3929>=v3927.count) then break;end table.insert(v2720,v4078);v3929=v3929 + 1 ;end end if ( #v2720<8) then for v4156,v4157 in ipairs(v2032) do local v4158=v2719[v4157.petType] or {} ;for v4234,v4235 in ipairs(v4158) do if ( #v2720>=8) then break;end local v4236=false;for v4279,v4280 in ipairs(v2720) do if (v4280==v4235) then v4236=true;break;end end if not v4236 then table.insert(v2720,v4235);end end end end end if ( #v2720==0) then return;end for v3317,v3318 in ipairs(getActivePets()) do pcall(function() PetsRemote:FireServer("UnequipPet",v3318);end);task.wait(timingCfg.UNEQUIP_DELAY);end task.wait(timingCfg.UNEQUIP_BUFFER);local v2721=getFarmCF();for v3319,v3320 in ipairs(v2720) do pcall(function() PetsRemote:FireServer("EquipPet",v3320,v2721);end);task.wait(timingCfg.EQUIP_DELAY);end end);end local function v1004() for v2722,v2723 in ipairs(v996:GetChildren()) do if v2723:IsA("GuiObject") then v2723:Destroy();end end for v2724,v2725 in ipairs(BUILTIN_TEAMS) do local v2726=v2725.slots;UI:builtinTeamCard(v996,v2725.name,v2725.desc, -100 + v2724 ,function() v1003(v2726,v2725.name);end);end local v2034={};for v2727 in pairs(cfg.petTeams) do table.insert(v2034,v2727);end table.sort(v2034);if ( #v2034==0) then local v3321=UI:label(v996," (no teams saved)",UDim2.new(1,0,0,20),nil,T.TEXT,9);v3321.Font=Enum.Font.Gotham;v3321.LayoutOrder=1;return;end for v2728,v2729 in ipairs(v2034) do local v2730=cfg.petTeams[v2729];local v2731=getInventory();local v2732={};for v3325,v3326 in ipairs(v2730.uuids or {} ) do local v3327=v2731[v3326];if (v3327 and v3327.PetType) then local v3930=v3327.PetType;local v3931=(v3327.PetData and v3327.PetData.MutationType) or "" ;local v3932=((v3931~="") and (v3931~="m") and (MutationMap[v3931] or "")) or "" ;local v3933=((v3932~="") and (v3930 .. " [" .. v3932 .. "]")) or v3930 ;table.insert(v2732,v3933);end end if ( #v2732==0) then v2732={"(empty)"};end local v2733= #(v2730.uuids or {});UI:teamCard(v996,v2729,v2732,v2733,v2728,function() local v3328=getActivePets();local v3329=v2730.uuids or {} ;local v3330=true;for v3697,v3698 in ipairs(v3329) do local v3699=false;for v3934,v3935 in ipairs(v3328) do if (v3935==v3698) then v3699=true;break;end end if not v3699 then v3330=false;break;end end if (v3330 and ( #v3329>0)) then task.spawn(function() for v4159,v4160 in ipairs(v3329) do pcall(function() PetsRemote:FireServer("UnequipPet",v4160);end);task.wait(timingCfg.EQUIP_DELAY);end end);else task.spawn(function() local v4079=getActivePets();for v4161,v4162 in ipairs(v4079) do pcall(function() PetsRemote:FireServer("UnequipPet",v4162);end);task.wait(timingCfg.UNEQUIP_DELAY);end task.wait(timingCfg.UNEQUIP_BUFFER);local v4080=getFarmCF();for v4163,v4164 in ipairs(v3329) do pcall(function() PetsRemote:FireServer("EquipPet",v4164,v4080);end);task.wait(timingCfg.EQUIP_DELAY);end end);end end,function() cfg.petTeams[v2729]=nil;if (cfg.elephant.levelingTeam==v2729) then cfg.elephant.levelingTeam=nil;end if (cfg.elephant.elephantTeam==v2729) then cfg.elephant.elephantTeam=nil;end if (cfg.elephant.phase2Team==v2729) then cfg.elephant.phase2Team=nil;end saveConfig();v1004();for v3700,v3701 in ipairs(v1000) do pcall(function() v3701.Refresh();end);end end);end end v991.MouseButton1Click:Connect(function() local v2035=v988.Text;if (v2035=="") then v2035="Team_" .. (os.time()%10000) ;end local v2036=getActivePets();if ( #v2036==0) then print("[VoidHub] No active pets!");return;end cfg.petTeams[v2035]={uuids=v2036};saveConfig();v1004();v988.Text="";for v2734,v2735 in ipairs(v1000) do pcall(function() v2735.Refresh();end);end end);v1004();_G._NH_rebuildTeams=v1004;_G._NH_ddRefs=v1000;_G._NH_BUILTIN_TEAMS=BUILTIN_TEAMS;end buildTeamsUI();local autoKGToggle,pickPlaceToggle,autoBoostM1Toggle,autoBoostM2Toggle;local function buildElephantUI() local v1005=UI:scroll(elephantPage,UDim2.new(1,0,1,0));v1005.ScrollingDirection=Enum.ScrollingDirection.Y;v1005.AutomaticCanvasSize=Enum.AutomaticSize.None;v1005.CanvasSize=UDim2.new(0,0,0,1200);UI:list(v1005,6);UI:pad(v1005,4,4,4,4);local v1011=UI:accordionScroll(v1005,"AUTO ELEPHANT",1,true,{height=1800,pt=6,pl=6,pr=6,pb=6,gap=5});local v1012=v1011.Inner;local function v1013(v2039,v2040,v2041,v2042,v2043) local v2044=UI:label(v1012,v2039,UDim2.new(1,0,0,14),nil,T.DIM,9);v2044.Font=Enum.Font.Gotham;v2044.LayoutOrder=v2041;local v2048=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BG,1);v2048.LayoutOrder=v2042;local v2050=UI:button(v2048,cfg.elephant[v2040] or "None selected" ,UDim2.new(1,0,1,0),nil,T.BTN,T.TEXT,9);v2050.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2050,0,8,8,0);UI:stroke(v2050,T.STROKE,1);UI:label(v2048,"v",UDim2.new(0,20,1,0),UDim2.new(1, -22,0,0),T.DIM,9,Enum.TextXAlignment.Center);local v2053=UI:frame(v1012,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10));v2053.LayoutOrder=v2043;v2053.Visible=false;UI:corner(v2053,5);UI:stroke(v2053,T.STROKE,1);local v2056=UI:scroll(v2053);UI:list(v2056,2);UI:pad(v2056,2,2,2,2);return v2050,v2053,v2056;end local v1014,v1015,v1016=v1013("Select pet team for leveling 1-50","levelingTeam",1,2,3);local v1017,v1018,v1019=v1013("Select team for elephant","elephantTeam",4,5,6);UI:divider(v1012,75);local v1020=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BG,1);v1020.LayoutOrder=76;UI:label(v1020,"[ Optional ] Phase 2 team (X - 100)",UDim2.new(1, -52,1,0),UDim2.new(0,4,0,0),T.DIM,9).Font=Enum.Font.Gotham;UI:toggle(v1020,UDim2.new(1, -48,0.5, -11),cfg.elephant.phase2Enabled,function(v2057) cfg.elephant.phase2Enabled=v2057;saveConfig();end);local v1024,v1025,v1026=v1013("Select phase 2 team (after target weight)","phase2Team",77,78,79);local v1027=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BG,1);v1027.LayoutOrder=80;UI:label(v1027,"Use phase 2 team from level",UDim2.new(1, -72,1,0),UDim2.new(0,4,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v1030=UI:input(v1027,cfg.elephant.phase2Threshold,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v1030.FocusLost:Connect(function() local v2059=tonumber(v1030.Text);if (v2059 and (v2059>=1)) then cfg.elephant.phase2Threshold=v2059;saveConfig();else v1030.Text=tostring(cfg.elephant.phase2Threshold);end end);UI:divider(v1012,81);local function v1031(v2060,v2061,v2062) local v2063=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BG,1);v2063.LayoutOrder=v2062;UI:label(v2063,v2060,UDim2.new(1, -72,1,0),UDim2.new(0,4,0,0),T.DIM,9).Font=Enum.Font.Gotham;return UI:input(v2063,v2061,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));end local v1032=v1031("Target KG",cfg.elephant.targetWeight,82);local v1033=v1031("Max Level (P1 switch)",cfg.elephant.levelThreshold,83);v1032.FocusLost:Connect(function() local v2067=tonumber(v1032.Text);if (v2067 and (v2067>0)) then cfg.elephant.targetWeight=v2067;saveConfig();else v1032.Text=tostring(cfg.elephant.targetWeight);end end);v1033.FocusLost:Connect(function() local v2068=tonumber(v1033.Text);if (v2068 and (v2068>=1)) then cfg.elephant.levelThreshold=v2068;saveConfig();else v1033.Text=tostring(cfg.elephant.levelThreshold);end end);local v1034=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BG,1);v1034.LayoutOrder=10;UI:label(v1034,"Level to 100 after target weight",UDim2.new(1, -52,1,0),UDim2.new(0,4,0,0),T.DIM,9).Font=Enum.Font.Gotham;UI:toggle(v1034,UDim2.new(1, -48,0.5, -11),cfg.elephant.levelTo100,function(v2069) cfg.elephant.levelTo100=v2069;saveConfig();end);local v1037=UI:modePickerRow(v1012,{label="Target in Garden",overlayParent=elephantPage,modes={{key="1",name="1 Pet",desc="Proses 1 pet target di garden sekaligus"},{key="2",name="2 Pets",desc="Proses 2 pet target di garden sekaligus"},{key="3",name="3 Pets",desc="Proses 3 pet target di garden sekaligus"}},default=tostring(cfg.elephant.gardenSlots or 1 ),onSelect=function(v2071) cfg.elephant.gardenSlots=tonumber(v2071);saveConfig();end});v1037.row.LayoutOrder=11;local v1039=UI:modePickerRow(v1012,{label="Garden Mode",overlayParent=elephantPage,modes={{key="A",name="Mode A — All Target",desc="Semua Target pet di-equip bareng elephant team. Tunggu SEMUA naik baru balik ke leveling."},{key="B",name="Mode B — One By one",desc="Pet 1 + elephant team naik, lalu Pet 2 + elephant team naik, Baru balik ke leveling."}},default=cfg.elephant.gardenMode or "A" ,onSelect=function(v2073) cfg.elephant.gardenMode=v2073;saveConfig();end});v1039.row.LayoutOrder=12;local v1041=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BTN);v1041.LayoutOrder=13;UI:corner(v1041,5);UI:stroke(v1041,T.STROKE,1);UI:label(v1041,"Extra Filler Pets (swap saat capai threshold)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;UI:toggle(v1041,UDim2.new(1, -48,0.5, -11),cfg.elephant.useExtraPets or false ,function(v2075) cfg.elephant.useExtraPets=v2075;saveConfig();end);local v1045=UI:frame(v1012,UDim2.new(1,0,0,22),nil,T.BG,1);v1045.LayoutOrder=14;local v1047=UI:label(v1045,"Extra pets: NONE",UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),T.DIM,9);v1047.Font=Enum.Font.Gotham;local v1049=UI:button(v1045,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1049,T.STROKE,1);local function v1050() local v2077=0;for v2736 in pairs(cfg.elephant.extraPets) do v2077=v2077 + 1 ;end if (v2077==0) then v1047.Text="Extra pets: NONE";v1047.TextColor3=T.DIM;else v1047.Text="Extra pets: " .. v2077 .. " selected" ;v1047.TextColor3=T.ACCENT;end end v1050();local v1051=UI:frame(elephantPage,UDim2.new(1,0,1,0),nil,T.BG);v1051.Visible=false;v1051.ZIndex=20;local v1054=UI:frame(v1051,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v1054,T.STROKE,1);UI:label(v1054,"Select Extra Filler Pets",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v1055=UI:button(v1054,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v1055,T.ERROR,1);v1055.MouseButton1Click:Connect(function() v1051.Visible=false;v1050();end);local v1056=UI:input(v1051,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1056.TextColor3=T.TEXT;v1056.Font=Enum.Font.Gotham;local v1060=UI:scroll(v1051,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v1060,3);UI:pad(v1060,3,4,4,3);local function v1061() for v2737,v2738 in ipairs(v1060:GetChildren()) do if v2738:IsA("GuiObject") then v2738:Destroy();end end local v2079=getInventory();local v2080=string.lower(v1056.Text);local v2081={};for v2739 in pairs(v2079) do table.insert(v2081,v2739);end table.sort(v2081,function(v2740,v2741) return getKG(v2740)>getKG(v2741) ;end);for v2742,v2743 in ipairs(v2081) do local v2744=v2079[v2743];if not v2744 then continue;end if ((v2080~="") and not string.lower(v2744.PetType or "" ):find(v2080,1,true)) then continue;end if table.find(cfg.targets,v2743) then continue;end local v2745=cfg.elephant.extraPets[v2743]==true ;local v2746=(v2744.PetData and (v2744.PetData.Level or 0)) or 0 ;local v2747=getKG(v2743);local v2748=(isFavorited(v2743) and " ❤") or "" ;local v2749=string.format("%s%s | Age %d | %.2f KG",v2744.PetType or "?" ,v2748,v2746,v2747);local v2750=UI:button(v1060,v2749,UDim2.new(1,0,0,22),nil,(v2745 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2745 and T.SEL_TXT) or T.TEXT ,9);v2750.LayoutOrder=v2742;v2750:SetAttribute("uuid",v2743);v2750.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2750,0,8,4,0);UI:stroke(v2750,(v2745 and T.ACCENT) or T.STROKE ,1);v2750.MouseButton1Click:Connect(function() if cfg.elephant.extraPets[v2743] then cfg.elephant.extraPets[v2743]=nil;else cfg.elephant.extraPets[v2743]=true;end saveConfig();v1050();UI:updateRowVisual(v2750,cfg.elephant.extraPets[v2743]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end);end end v1056:GetPropertyChangedSignal("Text"):Connect(v1061);v1049.MouseButton1Click:Connect(function() v1051.Visible=true;v1061();end);local v1062=UI:frame(v1012,UDim2.new(1,0,0,26),nil,T.BTN);v1062.LayoutOrder=15;UI:corner(v1062,5);UI:stroke(v1062,T.STROKE,1);UI:label(v1062,"Extra Ele Filler Pets (swap saat capai target KG)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;UI:toggle(v1062,UDim2.new(1, -48,0.5, -11),cfg.elephant.useExtraElePets or false ,function(v2083) cfg.elephant.useExtraElePets=v2083;saveConfig();end);local v1065=UI:frame(v1012,UDim2.new(1,0,0,22),nil,T.BG,1);v1065.LayoutOrder=16;local v1067=UI:label(v1065,"Extra ele pets: NONE",UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),T.DIM,9);v1067.Font=Enum.Font.Gotham;local v1069=UI:button(v1065,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1069,T.STROKE,1);local function v1070() local v2085=0;for v2754 in pairs(cfg.elephant.extraElePets) do v2085=v2085 + 1 ;end if (v2085==0) then v1067.Text="Extra ele pets: NONE";v1067.TextColor3=T.DIM;else v1067.Text="Extra ele pets: " .. v2085 .. " selected" ;v1067.TextColor3=T.ACCENT;end end v1070();local v1071=UI:frame(elephantPage,UDim2.new(1,0,1,0),nil,T.BG);v1071.Visible=false;v1071.ZIndex=20;local v1074=UI:frame(v1071,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v1074,T.STROKE,1);UI:label(v1074,"Select Extra Ele Filler Pets",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v1075=UI:button(v1074,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v1075,T.ERROR,1);v1075.MouseButton1Click:Connect(function() v1071.Visible=false;v1070();end);local v1076=UI:input(v1071,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1076.TextColor3=T.TEXT;v1076.Font=Enum.Font.Gotham;local v1079=UI:scroll(v1071,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v1079,3);UI:pad(v1079,3,4,4,3);local function v1080() for v2755,v2756 in ipairs(v1079:GetChildren()) do if v2756:IsA("GuiObject") then v2756:Destroy();end end local v2087=getInventory();local v2088=string.lower(v1076.Text);local v2089={};for v2757 in pairs(v2087) do table.insert(v2089,v2757);end table.sort(v2089,function(v2758,v2759) return getKG(v2758)>getKG(v2759) ;end);for v2760,v2761 in ipairs(v2089) do local v2762=v2087[v2761];if not v2762 then continue;end if ((v2088~="") and not string.lower(v2762.PetType or "" ):find(v2088,1,true)) then continue;end if table.find(cfg.targets,v2761) then continue;end local v2763=cfg.elephant.extraElePets[v2761]==true ;local v2764=(v2762.PetData and (v2762.PetData.Level or 0)) or 0 ;local v2765=getKG(v2761);local v2766=(isFavorited(v2761) and " ❤") or "" ;local v2767=string.format("%s%s | Age %d | %.2f KG",v2762.PetType or "?" ,v2766,v2764,v2765);local v2768=UI:button(v1079,v2767,UDim2.new(1,0,0,22),nil,(v2763 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2763 and T.SEL_TXT) or T.TEXT ,9);v2768.LayoutOrder=v2760;v2768:SetAttribute("uuid",v2761);v2768.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2768,0,8,4,0);UI:stroke(v2768,(v2763 and T.ACCENT) or T.STROKE ,1);v2768.MouseButton1Click:Connect(function() if cfg.elephant.extraElePets[v2761] then cfg.elephant.extraElePets[v2761]=nil;else cfg.elephant.extraElePets[v2761]=true;end saveConfig();v1070();UI:updateRowVisual(v2768,cfg.elephant.extraElePets[v2761]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end);end end v1076:GetPropertyChangedSignal("Text"):Connect(v1080);v1069.MouseButton1Click:Connect(function() v1071.Visible=true;v1080();end);local v1081=UI:frame(v1012,UDim2.new(1,0,0,22),nil,T.BG,1);v1081.LayoutOrder=85;local v1083=UI:label(v1081,"Target pets: " .. #cfg.targets ,UDim2.new(1, -70,1,0),UDim2.new(0,4,0,0),T.DIM,9);v1083.Font=Enum.Font.Gotham;local v1085=UI:button(v1081,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1085,T.STROKE,1);local logsPanel=UI:frame(v1012,UDim2.new(1,0,0,52),nil,T.PANEL);logsPanel.LayoutOrder=86;UI:stroke(logsPanel,T.STROKE,1);local logsHeader=UI:frame(logsPanel,UDim2.new(1,0,0,14),nil,T.BG,1);UI:label(logsHeader,"LOGS",UDim2.new(1, -60,1,0),UDim2.new(0,6,0,0),T.ACCENT,8).Font=Enum.Font.GothamBold;local logsDoneLabel=UI:label(logsHeader,"Done: 0",UDim2.new(0,54,1,0),UDim2.new(1, -58,0,0),T.DIM,8,Enum.TextXAlignment.Right);logsDoneLabel.Font=Enum.Font.Gotham;local logsScroll=UI:scroll(logsPanel,UDim2.new(1, -4,1, -16),UDim2.new(0,2,0,15));UI:list(logsScroll,1);UI:pad(logsScroll,1,4,4,1);local logLineCount=0;local petsDoneCount=0;local function addLog(v2091,v2092) logLineCount=logLineCount + 1 ;local v2093=Instance.new("TextLabel");v2093.Size=UDim2.new(1,0,0,12);v2093.BackgroundTransparency=1;v2093.Text=os.date("%H:%M:%S") .. " " .. v2091 ;v2093.TextColor3=v2092 or T.DIM ;v2093.Font=Enum.Font.Gotham;v2093.TextSize=8;v2093.TextXAlignment=Enum.TextXAlignment.Left;v2093.TextTruncate=Enum.TextTruncate.AtEnd;v2093.LayoutOrder=logLineCount;v2093.Parent=logsScroll;local v2107={};for v2772,v2773 in ipairs(logsScroll:GetChildren()) do if v2773:IsA("TextLabel") then table.insert(v2107,v2773);end end while #v2107>35 do v2107[1]:Destroy();table.remove(v2107,1);end task.defer(function() logsScroll.CanvasPosition=Vector2.new(0,math.huge);end);end local autoKGPanel=UI:frame(v1012,UDim2.new(1,0,0,38),nil,T.PANEL);autoKGPanel.LayoutOrder=999;UI:stroke(autoKGPanel,T.STROKE,1);UI:label(autoKGPanel,"AUTO KG",UDim2.new(0,70,0,20),UDim2.new(0,8,0.5, -10),T.TEXT,10).Font=Enum.Font.GothamBold;local autoKGStatusLabel=UI:label(autoKGPanel,"● IDLE",UDim2.new(1, -120,1,0),UDim2.new(0,60,0,0),T.DIM,9);autoKGStatusLabel.Font=Enum.Font.Gotham;autoKGStatusLabel.TextTruncate=Enum.TextTruncate.AtEnd;local function setAutoKGStatus(v2108,v2109) autoKGStatusLabel.Text=v2108;autoKGStatusLabel.TextColor3=v2109 or T.DIM ;end local v1104=UI:frame(elephantPage,UDim2.new(1,0,1,0),nil,T.BG);v1104.Visible=false;v1104.ZIndex=20;local v1107=UI:frame(v1104,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v1107,T.STROKE,1);UI:label(v1107,"Select Target Pets",UDim2.new(1, -80,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v1108=UI:button(v1107,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -118,0.5, -10),T.BTN,T.ACCENT,8);UI:stroke(v1108,T.STROKE,1);local v1109=UI:button(v1107,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v1109,T.ERROR,1);v1109.MouseButton1Click:Connect(function() v1104.Visible=false;v1083.Text="Target pets: " .. #cfg.targets ;end);local v1110=UI:input(v1104,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1110.TextColor3=T.TEXT;v1110.Font=Enum.Font.Gotham;local v1113=UI:scroll(v1104,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v1113,3);UI:pad(v1113,3,4,4,3);local function v1114() local v2114=string.lower(v1110.Text);local v2115=getInventory();local v2116={};for v2775 in pairs(v2115) do table.insert(v2116,v2775);end table.sort(v2116,function(v2776,v2777) return getKG(v2776)>getKG(v2777) ;end);local v2117={};for v2778,v2779 in ipairs(v2116) do local v2780=v2115[v2779];if not v2780 then continue;end local v2781=string.lower(v2780.PetType or "" );if ((v2114=="") or v2781:find(v2114,1,true)) then table.insert(v2117,v2779);end end return v2117;end local function v1115() for v2782,v2783 in ipairs(v1113:GetChildren()) do if v2783:IsA("GuiObject") then v2783:Destroy();end end local v2118=getInventory();local v2119=v1114();local v2120=true;for v2784,v2785 in ipairs(v2119) do if not table.find(cfg.targets,v2785) then v2120=false;break;end end v1108.Text=(( #v2119==0) and "Select All") or (v2120 and "Unselect All") or "Select All" ;v1108.TextColor3=(v2120 and T.SEL_TXT) or T.ACCENT ;v1108.BackgroundColor3=(v2120 and T.SEL_BG) or T.BTN ;for v2786,v2787 in ipairs(v2119) do local v2788=v2118[v2787];if not v2788 then continue;end local v2789=table.find(cfg.targets,v2787)~=nil ;local v2790=(v2788.PetData and (v2788.PetData.Level or 0)) or 0 ;local v2791=getKG(v2787);local v2792=(v2788.PetData and (v2788.PetData.BaseWeight or 0)) or 0 ;local v2793=(isFavorited(v2787) and " ❤") or "" ;local v2794=getMutationName(v2787);local v2795=((v2794~="") and (" [" .. v2794 .. "]")) or "" ;local v2796=(v2788.PetData and (v2788.PetData.MutationType or "")) or "" ;local v2797=((v2796~="") and (v2796~="m") and string.format('%s',v2795)) or "" ;local v2798=string.format("%s%s | Age %d | %.2f KG | Base %.2f%s",v2788.PetType or "?" ,v2797,v2790,v2791,v2792,v2793);local v2799=UI:button(v1113,v2798,UDim2.new(1,0,0,22),nil,(v2789 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2789 and T.SEL_TXT) or T.TEXT ,9);v2799.LayoutOrder=v2786;v2799:SetAttribute("uuid",v2787);v2799.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2799,0,8,4,0);UI:stroke(v2799,(v2789 and T.ACCENT) or T.STROKE ,1);v2799.MouseButton1Click:Connect(function() local v3350=table.find(cfg.targets,v2787);if v3350 then table.remove(cfg.targets,v3350);else table.insert(cfg.targets,v2787);end saveConfig();v1083.Text="Target pets: " .. #cfg.targets ;local v3352=table.find(cfg.targets,v2787)~=nil ;UI:updateRowVisual(v2799,v3352,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end);end end v1108.MouseButton1Click:Connect(function() local v2124=v1114();local v2125=true;for v2803,v2804 in ipairs(v2124) do if not table.find(cfg.targets,v2804) then v2125=false;break;end end if v2125 then for v3702,v3703 in ipairs(v2124) do local v3704=table.find(cfg.targets,v3703);if v3704 then table.remove(cfg.targets,v3704);end end else for v3705,v3706 in ipairs(v2124) do if not table.find(cfg.targets,v3706) then table.insert(cfg.targets,v3706);end end end saveConfig();v1083.Text="Target pets: " .. #cfg.targets ;local v2127= not v2125;v1108.Text=(( #v2124==0) and "Select All") or (v2127 and "Unselect All") or "Select All" ;v1108.TextColor3=(v2127 and T.SEL_TXT) or T.ACCENT ;v1108.BackgroundColor3=(v2127 and T.SEL_BG) or T.BTN ;for v2805,v2806 in ipairs(v1113:GetChildren()) do if v2806:IsA("TextButton") then local v3707=v2806:GetAttribute("uuid");if v3707 then UI:updateRowVisual(v2806,v2127,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end end end end);v1110:GetPropertyChangedSignal("Text"):Connect(v1115);v1085.MouseButton1Click:Connect(function() v1104.Visible=true;v1115();end);local v1116,v1117,v1118=false,false,false;v1014.MouseButton1Click:Connect(function() v1116= not v1116;v1018.Visible=false;v1117=false;v1025.Visible=false;v1118=false;v1015.Visible=v1116;v1014.Text=cfg.elephant.levelingTeam or "None selected" ;if v1116 then local v3353=buildTeamDropdown(v1016,function(v3708) cfg.elephant.levelingTeam=v3708;saveConfig();v1014.Text=v3708;v1015.Visible=false;v1116=false;end,cfg.elephant.levelingTeam,UI,cfg,T);v1015.Size=UDim2.new(1,0,0,math.min((v3353 * 24) + 6 ,130));end end);v1017.MouseButton1Click:Connect(function() v1117= not v1117;v1015.Visible=false;v1116=false;v1025.Visible=false;v1118=false;v1018.Visible=v1117;v1017.Text=cfg.elephant.elephantTeam or "None selected" ;if v1117 then local v3355=buildTeamDropdown(v1019,function(v3712) cfg.elephant.elephantTeam=v3712;saveConfig();v1017.Text=v3712;v1018.Visible=false;v1117=false;end,cfg.elephant.elephantTeam,UI,cfg,T);v1018.Size=UDim2.new(1,0,0,math.min((v3355 * 24) + 6 ,130));end end);v1024.MouseButton1Click:Connect(function() v1118= not v1118;v1015.Visible=false;v1116=false;v1018.Visible=false;v1117=false;v1025.Visible=v1118;v1024.Text=cfg.elephant.phase2Team or "None selected" ;if v1118 then local v3357=buildTeamDropdown(v1026,function(v3716) cfg.elephant.phase2Team=v3716;saveConfig();v1024.Text=v3716;v1025.Visible=false;v1118=false;end,cfg.elephant.phase2Team,UI,cfg,T);v1025.Size=UDim2.new(1,0,0,math.min((v3357 * 24) + 6 ,130));end end);local function v1119(v2144) local v2145=getInventory();local v2146= #cfg.targets;local v2147={};for v2807,v2808 in ipairs(cfg.targets) do if v2145[v2808] then table.insert(v2147,v2808);end end cfg.targets=v2147;local v2149=v2146-#v2147 ;if (v2149>0) then if v2144 then v2144(string.format("Cleaned %d pet(s) not in inventory",v2149),T.DIM);end saveConfig();end return v2149;end local function v1120(v2150) local v2151=table.find(cfg.targets,v2150);if v2151 then table.remove(cfg.targets,v2151);saveConfig();end end local function v1121(v2152,v2153,v2154,v2155) v1119(v2154);if ( #cfg.targets==0) then v2153("No targets!",T.ERROR);v2152.Set(false);return;end isAutoKGRunning=true;petsDoneCount=0;v2153("Running…",T.SUCCESS);v2154("════ AUTO KG START ════",T.ACCENT);startAutoEquipLoop();task.spawn(function() local v2809=getTeamUUIDs(cfg.elephant.levelingTeam);local v2810=getTeamUUIDs(cfg.elephant.elephantTeam);local v2811=getTeamUUIDs(cfg.elephant.phase2Team);local v2812=tonumber(cfg.elephant.targetWeight) or 2 ;local v2813=cfg.elephant.levelThreshold;local v2814=cfg.elephant.phase2Enabled;local v2815=cfg.elephant.phase2Threshold;local v2816=cfg.elephant.levelTo100;local v2817=math.max(1,math.min(3,cfg.elephant.gardenSlots or 1 ));local v2818=cfg.elephant.gardenMode or "A" ;local v2819=os.clock();local v2820={};for v3359,v3360 in ipairs(cfg.targets) do table.insert(v2820,v3360);end local v2821= #v2820;local function v2822(v3361,v3362) local v3363={};for v3720,v3721 in ipairs(v3361) do if ( #v3363<8) then table.insert(v3363,v3721);end end for v3722,v3723 in ipairs(v3362 or {} ) do if ( #v3363>=8) then break;end local v3724=false;for v3943,v3944 in ipairs(v3363) do if (v3944==v3723) then v3724=true;break;end end if not v3724 then table.insert(v3363,v3723);end end return v3363;end local v2823=1;while (v2823<= #v2820) and isAutoKGRunning do local v3364={};local v3365=v2823;while ( #v3364=v2812) then v3366[v3948]=true;v2154(string.format("✓ %s reach %.2fkg",getPetType(v3948),getBaseWeight(v3948)),T.SUCCESS);else v3731=false;end end end if v3731 then unequipAll();break;end local v3732={};for v3949,v3950 in ipairs(v3364) do if not v3366[v3950] then table.insert(v3732,v3950);end end if ( #v3732==0) then unequipAll();break;end local v3733={};for v3951,v3952 in ipairs(v3732) do v3733[v3952]=getBaseWeight(v3952);end local function v3734() local v3954={};for v4081,v4082 in ipairs(v3732) do v3954[v4082]=true;end local function v3955() local v4084={};for v4166 in pairs(v3954) do table.insert(v4084,v4166);end local v4085={};for v4167,v4168 in ipairs(v4084) do v4085[v4168]=true;end for v4170,v4171 in ipairs(v2809) do v4085[v4171]=true;end local v4086=getActivePets();for v4173,v4174 in ipairs(v4086) do v4085[v4174]=true;end local v4087={};for v4176,v4177 in ipairs(v4084) do if ( #v4087<8) then table.insert(v4087,v4177);end end for v4178,v4179 in ipairs(v2809) do if ( #v4087>=8) then break;end table.insert(v4087,v4179);end if (cfg.elephant.useExtraPets and ( #v4087<8)) then local v4237=getExtraFillers(v4085,8 -#v4087 );for v4282,v4283 in ipairs(v4237) do if ( #v4087>=8) then break;end table.insert(v4087,v4283);v4085[v4283]=true;end end return v4087,v4084;end local v3956,v3957=v3955();setAutoEquipTargets(v3957,v2809);for v4088,v4089 in ipairs(v3956) do autoEquipTargetSet[v4089]=true;end unequipAll();task.wait(0.5);equipList(v3956);while isAutoKGRunning do task.wait(timingCfg.POLL_RATE);local v4091=false;for v4180 in pairs(v3954) do if (getAge(v4180)>=v2813) then addLog(string.format(" ✓ %s lv%d → swap keluar",getPetType(v4180),getAge(v4180)),T.SUCCESS);v3954[v4180]=nil;v4091=true;end end if not next(v3954) then setAutoEquipTargets({},{});unequipAll();task.wait(0.3);break;end if v4091 then local v4238,v4239=v3955();local v4240={};for v4286,v4287 in ipairs(v4238) do local v4288=false;for v4339 in pairs(v3954) do if (v4339==v4287) then v4288=true;break;end end local v4289=false;for v4340,v4341 in ipairs(v2809) do if (v4341==v4287) then v4289=true;break;end end if ( not v4288 and not v4289) then table.insert(v4240,v4287);end end setAutoEquipTargets(v4239,v2809);for v4290,v4291 in ipairs(v4240) do autoEquipTargetSet[v4291]=true;end globalFlags.IsEquipping=true;local v4242={};for v4293,v4294 in ipairs(v4238) do v4242[v4294]=true;end local v4243=getActivePets();for v4296,v4297 in ipairs(v4243) do if not v4242[v4297] then pcall(function() PetsRemote:FireServer("UnequipPet",v4297);end);task.wait(timingCfg.UNEQUIP_DELAY);end end task.wait(timingCfg.UNEQUIP_BUFFER);local v4244=getActivePets();local v4245={};for v4298,v4299 in ipairs(v4244) do v4245[v4299]=true;end local v4246=getFarmCF();for v4301,v4302 in ipairs(v4238) do if not v4245[v4302] then pcall(function() PetsRemote:FireServer("EquipPet",v4302,v4246);end);task.wait(timingCfg.EQUIP_DELAY);end end globalFlags.IsEquipping=false;end local v4092=true;for v4181,v4182 in ipairs(v3732) do if (getBaseWeight(v4182)<=v3733[v4182]) then v4092=false;break;end end if v4092 then setAutoEquipTargets({},{});unequipAll();break;end local v4093={};for v4183 in pairs(v3954) do table.insert(v4093,string.format("Lv%d %.2f/%.2fkg",getAge(v4183),getBaseWeight(v4183),v2812));end setAutoKGStatus("P1: " .. table.concat(v4093," | ") ,T.DIM);end end local function v3735() if ( #v2810==0) then return;end if (v2818=="A") then local v4184={};local v4185={};for v4247,v4248 in ipairs(v3732) do v4184[v4248]=getBaseWeight(v4248);v4185[v4248]=true;end local function v4186() local v4251={};for v4303 in pairs(v4185) do table.insert(v4251,v4303);end local v4252={};for v4304,v4305 in ipairs(v4251) do v4252[v4305]=true;end for v4307,v4308 in ipairs(v2810) do v4252[v4308]=true;end local v4253={};for v4310,v4311 in ipairs(v4251) do if ( #v4253<8) then table.insert(v4253,v4311);end end for v4312,v4313 in ipairs(v2810) do if ( #v4253>=8) then break;end table.insert(v4253,v4313);end if (cfg.elephant.useExtraElePets and ( #v4253<8)) then local v4342=getExtraEleFillers(v4252,8 -#v4253 );for v4363,v4364 in ipairs(v4342) do if ( #v4253>=8) then break;end table.insert(v4253,v4364);v4252[v4364]=true;end end return v4253,v4251;end local v4187,v4188=v4186();setAutoEquipTargets(v4188,v2810);for v4254,v4255 in ipairs(v4187) do autoEquipTargetSet[v4255]=true;end unequipAll();task.wait(0.5);equipList(v4187);while isAutoKGRunning do task.wait(timingCfg.POLL_RATE);local v4257=false;for v4314 in pairs(v4185) do local v4315=getBaseWeight(v4314);if (v4315>v4184[v4314]) then addLog(string.format("↑ %s %.2f→%.2fkg",getPetType(v4314),v4184[v4314],v4315),Color3.fromRGB(255,180,80));v4184[v4314]=v4315;v4185[v4314]=nil;v4257=true;end end if not next(v4185) then setAutoEquipTargets({},{});unequipAll();task.wait(0.3);break;end if v4257 then local v4343,v4344=v4186();local v4345={};for v4368,v4369 in ipairs(v4343) do local v4370=false;for v4386 in pairs(v4185) do if (v4386==v4369) then v4370=true;break;end end local v4371=false;for v4387,v4388 in ipairs(v2810) do if (v4388==v4369) then v4371=true;break;end end if ( not v4370 and not v4371) then table.insert(v4345,v4369);end end setAutoEquipTargets(v4344,v2810);for v4372,v4373 in ipairs(v4345) do autoEquipTargetSet[v4373]=true;end globalFlags.IsEquipping=true;local v4347={};for v4375,v4376 in ipairs(v4343) do v4347[v4376]=true;end local v4348=getActivePets();for v4378,v4379 in ipairs(v4348) do if not v4347[v4379] then pcall(function() PetsRemote:FireServer("UnequipPet",v4379);end);task.wait(timingCfg.UNEQUIP_DELAY);end end task.wait(timingCfg.UNEQUIP_BUFFER);local v4349=getActivePets();local v4350={};for v4380,v4381 in ipairs(v4349) do v4350[v4381]=true;end local v4351=getFarmCF();for v4383,v4384 in ipairs(v4343) do if not v4350[v4384] then pcall(function() PetsRemote:FireServer("EquipPet",v4384,v4351);end);task.wait(timingCfg.EQUIP_DELAY);end end globalFlags.IsEquipping=false;end local v4258={};for v4316 in pairs(v4185) do table.insert(v4258,string.format("%.2f/%.2fkg",getBaseWeight(v4316),v2812));end setAutoKGStatus("Elephant A: " .. table.concat(v4258," | ") ,T.DIM);end else for v4259,v4260 in ipairs(v3732) do if not isAutoKGRunning then break;end local v4261=getBaseWeight(v4260);local function v4262() local v4317={[v4260]=true};for v4352,v4353 in ipairs(v2810) do v4317[v4353]=true;end local v4318={v4260};for v4355,v4356 in ipairs(v2810) do if ( #v4318>=8) then break;end table.insert(v4318,v4356);end if (cfg.elephant.useExtraElePets and ( #v4318<8)) then local v4385=getExtraEleFillers(v4317,8 -#v4318 );for v4389,v4390 in ipairs(v4385) do if ( #v4318>=8) then break;end table.insert(v4318,v4390);end end return v4318;end local v4263=v4262();setAutoEquipTargets({v4260},v2810);for v4319,v4320 in ipairs(v4263) do autoEquipTargetSet[v4320]=true;end unequipAll();task.wait(0.5);equipList(v4263);while isAutoKGRunning do task.wait(timingCfg.POLL_RATE);local v4322=getBaseWeight(v4260);setAutoKGStatus(string.format("Elephant B: %s %.2f/%.2fkg",getPetType(v4260),v4322,v2812),T.DIM);if (v4322>v4261) then addLog(string.format("↑ %s %.2f→%.2fkg",getPetType(v4260),v4261,v4322),Color3.fromRGB(255,180,80));setAutoEquipTargets({},{});unequipAll();break;end end end end end v3734();if not isAutoKGRunning then break;end v3735();if not isAutoKGRunning then break;end for v3958,v3959 in ipairs(v3732) do v3733[v3959]=getBaseWeight(v3959);end end if not isAutoKGRunning then break;end for v3736,v3737 in ipairs(v3364) do if not isAutoKGRunning then break;end if not getInventory()[v3737] then v1120(v3737);continue;end local v3738=getPetType(v3737);local v3739=os.clock();if not v2816 then petsDoneCount=petsDoneCount + 1 ;v2155.Text="Done: " .. petsDoneCount ;local v4095=os.clock() -v3739 ;v2154(string.format("✓ DONE %s %.2fkg",v3738,getBaseWeight(v3737)),T.SUCCESS);v2153(string.format("%s done! %s",v3738,HydraLib.fmtTime(v4095)),T.SUCCESS);task.spawn(function() sendPetDoneWebhook(v3738,getBaseWeight(v3737),v4095,0,petsDoneCount,v2821);end);v1120(v3737);v1083.Text="Target pets: " .. #cfg.targets ;continue;end local v3740=os.clock();v2154(string.format("► P2: %s → lvl 100",v3738),T.PHASE2);v2153(string.format("P2 Lv%d/100 | %s",getAge(v3737),v3738),T.PHASE2);local v3741=v2814 and ( #v2811>0) and (getAge(v3737)>=v2815) ;local v3742=(v3741 and v2811) or v2809 ;autoEquipTargetUUID=v3737;autoEquipTeam=v3742;unequipAll();task.wait(0.5);equipList(buildEquipList(v3737,v3742));local v3743=getAge(v3737);while isAutoKGRunning do task.wait(timingCfg.POLL_RATE);local v3961=getAge(v3737);v2153(string.format("P2 Lv%d/100 | %s",v3961,v3738),T.PHASE2);if (v2814 and ( #v2811>0) and not v3741 and (v3961>=v2815)) then v3741=true;autoEquipTeam=v2811;unequipAll();task.wait(0.5);equipList(buildEquipList(v3737,v2811));end if (v3961>=(v3743 + 10)) then v2154(string.format(" Lv%d/100 %s",v3961,v3738),T.PHASE2);v3743=v3961-(v3961%10) ;end if (v3961>=100) then unequipAll();petsDoneCount=petsDoneCount + 1 ;v2155.Text="Done: " .. petsDoneCount ;local v4190=os.clock() -v3739 ;local v4191=os.clock() -v3740 ;v2154(string.format("✓ DONE %s Lv100 %.2fkg",v3738,getBaseWeight(v3737)),T.SUCCESS);v2154(string.format(" Time: %s (P2: %s)",HydraLib.fmtTime(v4190),HydraLib.fmtTime(v4191)),T.DIM);v2153(string.format("%s done! %s",v3738,HydraLib.fmtTime(v4190)),T.SUCCESS);v1120(v3737);v1083.Text="Target pets: " .. #cfg.targets ;trackEvent("kg_done",{pet_name=v3738,final_kg=getBaseWeight(v3737)});task.spawn(function() sendPetDoneWebhook(v3738,getBaseWeight(v3737),v4190,v4191,petsDoneCount,v2821);end);break;end end end end isAutoKGRunning=false;v2152.Set(false);stopAutoEquipLoop();cfg.toggles.autoKG=false;saveConfig();local v2825=HydraLib.fmtTime(os.clock() -v2819 );v2154("════════════════════════",T.ACCENT);v2154(string.format("ALL DONE %d/%d pets",petsDoneCount,v2821),T.SUCCESS);v2154(string.format("Total time: %s",v2825),T.ACCENT);v2153(string.format("Done! %d pets — %s",petsDoneCount,v2825),T.SUCCESS);v1083.Text="Target pets: " .. #cfg.targets ;end);end local v1122=UI:toggle(autoKGPanel,UDim2.new(1, -52,0.5, -11),cfg.toggles.autoKG,function(v2156) cfg.toggles.autoKG=v2156;saveConfig();if v2156 then v1121(tog,setAutoKGStatus,addLog,logsDoneLabel);else isAutoKGRunning=false;stopAutoEquipLoop();addLog("─── Stopped by user ───",T.ERROR);setAutoKGStatus("Stopped",T.DIM);end end);autoKGToggle=v1122;if cfg.toggles.autoKG then task.defer(function() v1121(v1122,setAutoKGStatus,addLog,logsDoneLabel);end);end end buildElephantUI();local function buildPickPlaceUI() local ppRunning=false;local ppPetTimer=cfg.pickplace.petTimer;local ppPickDelay=cfg.pickplace.pickDelay;local ppPlaceDelay=cfg.pickplace.placeDelay;local ppSelPets=cfg.pickplace.selPets;local ppCooldownConn=nil;local ppCooldownCache={};local PetCooldownsUpdatedRemote=RS:WaitForChild("GameEvents"):WaitForChild("PetCooldownsUpdated");local GetPetCooldownRemote=RS:WaitForChild("GameEvents"):WaitForChild("GetPetCooldown");local PetsServicePP=RS:WaitForChild("GameEvents"):WaitForChild("PetsService");local function v1133() local v2158=workspace:FindFirstChild("Farm");if v2158 then local v3367=v2158:FindFirstChild(LocalPlayer.Name);if v3367 then local v3962=v3367:FindFirstChild("PetArea");if v3962 then return v3962.CFrame;end end end return DEFAULT_GARDEN_CF;end local function v1134(v2159) local v2160=getInventory();local v2161=v2160[v2159];return (v2161 and (v2161.PetType or "?")) or "?" ;end local function v1135(v2162) if globalFlags.PP_Processing[v2162] then return;end globalFlags.PP_Processing[v2162]=true;task.spawn(function() task.wait(ppPickDelay);local v2827=pcall(function() PetsServicePP:FireServer("UnequipPet",v2162);end);if not v2827 then globalFlags.PP_Processing[v2162]=nil;return;end task.wait(ppPlaceDelay);local v2828=v1133();pcall(function() PetsServicePP:FireServer("EquipPet",v2162,v2828);end);globalFlags.PP_Processing[v2162]=nil;end);end local v1136=UI:scroll(pickPlacePage,UDim2.new(1,0,1, -42));UI:list(v1136,5);UI:pad(v1136,7,7,7,7);local function v1137(v2164,v2165,v2166) local v2167=UI:frame(v1136,UDim2.new(1,0,0,28),nil,T.BTN);v2167.LayoutOrder=v2166;UI:corner(v2167,6);UI:stroke(v2167,T.STROKE,1);UI:label(v2167,v2164,UDim2.new(1, -80,1,0),UDim2.new(0,8,0,0),T.DIM,9).Font=Enum.Font.Gotham;return UI:input(v2167,v2165,"",UDim2.new(0,64,0,20),UDim2.new(1, -72,0.5, -10));end local v1138=v1137("Pet Timer (sec)",ppPetTimer,1);local v1139=v1137("Pick delay (sec)",ppPickDelay,2);local v1140=v1137("Place delay (sec)",ppPlaceDelay,3);v1138.FocusLost:Connect(function() local v2171=tonumber(v1138.Text);if (v2171 and (v2171>=0)) then ppPetTimer=v2171;cfg.pickplace.petTimer=v2171;saveConfig();else v1138.Text=tostring(ppPetTimer);end end);v1139.FocusLost:Connect(function() local v2172=tonumber(v1139.Text);if (v2172 and (v2172>=0)) then ppPickDelay=v2172;cfg.pickplace.pickDelay=v2172;saveConfig();else v1139.Text=tostring(ppPickDelay);end end);v1140.FocusLost:Connect(function() local v2173=tonumber(v1140.Text);if (v2173 and (v2173>=0)) then ppPlaceDelay=v2173;cfg.pickplace.placeDelay=v2173;saveConfig();else v1140.Text=tostring(ppPlaceDelay);end end);local v1141=UI:frame(v1136,UDim2.new(1,0,0,28),nil,T.BTN);v1141.LayoutOrder=4;UI:corner(v1141,6);UI:stroke(v1141,T.STROKE,1);local v1143=UI:label(v1141,"Filter: ALL pets",UDim2.new(1, -180,1,0),UDim2.new(0,8,0,0),T.DIM,9);v1143.Font=Enum.Font.Gotham;local v1146=UI:button(v1141,"Clear",UDim2.new(0,40,0,20),UDim2.new(1, -172,0.5, -10),T.BTN,T.DIM,9);UI:stroke(v1146,T.STROKE,1);local v1147=UI:button(v1141,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1147,T.STROKE,1);local function v1148() local v2174=0;for v2830 in pairs(ppSelPets) do v2174=v2174 + 1 ;end if (v2174==0) then v1143.Text="Filter: ALL pets";v1143.TextColor3=T.DIM;else v1143.Text="Filter: " .. v2174 .. " selected" ;v1143.TextColor3=T.ACCENT;end end v1146.MouseButton1Click:Connect(function() for v2831 in pairs(ppSelPets) do ppSelPets[v2831]=nil;end saveConfig();v1148();end);v1148();local v1149=UI:frame(pickPlacePage,UDim2.new(1,0,1, -42),nil,T.BG);v1149.Visible=false;v1149.ZIndex=20;local v1152=UI:frame(v1149,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v1152,T.STROKE,1);UI:label(v1152,"Select pets to filter",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v1153=UI:button(v1152,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8);UI:stroke(v1153,T.STROKE,1);local v1154=UI:button(v1152,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v1154,T.ERROR,1);v1154.MouseButton1Click:Connect(function() v1149.Visible=false;v1148();end);local v1155=UI:input(v1149,"","Search pet or egg name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1155.TextColor3=T.TEXT;v1155.Font=Enum.Font.Gotham;local v1159=UI:scroll(v1149,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v1159,3);UI:pad(v1159,3,4,4,3);local function v1160() local v2176=string.lower(v1155.Text);local v2177={};for v2833,v2834 in ipairs(PetsData) do local v2835=v2834.name;local v2836=v2834.egg;if ((v2176=="") or v2835:lower():find(v2176,1,true) or v2836:lower():find(v2176,1,true)) then table.insert(v2177,v2834);end end return v2177;end local function v1161() for v2837,v2838 in ipairs(v1159:GetChildren()) do if v2838:IsA("GuiObject") then v2838:Destroy();end end local v2178=v1160();local v2179=true;for v2839,v2840 in ipairs(v2178) do if not ppSelPets[v2840.name] then v2179=false;break;end end v1153.Text=(( #v2178==0) and "Select All") or (v2179 and "Unselect All") or "Select All" ;v1153.TextColor3=(v2179 and T.SEL_TXT) or T.ACCENT ;v1153.BackgroundColor3=(v2179 and T.SEL_BG) or T.BTN ;for v2841,v2842 in ipairs(v2178) do local v2843=v2842.name;local v2844=v2842.egg;local v2845=ppSelPets[v2843]==true ;local v2846=UI:button(v1159,v2843,UDim2.new(1,0,0,30),nil,(v2845 and T.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2845 and T.SEL_TXT) or T.TEXT ,10);v2846.LayoutOrder=v2841;v2846.TextXAlignment=Enum.TextXAlignment.Left;UI:pad(v2846,0,8,4,0);UI:corner(v2846,5);UI:stroke(v2846,(v2845 and T.ACCENT) or T.STROKE ,1);UI:label(v2846,v2844,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v2845 and Color3.fromRGB(60,40,0)) or T.DIM ,8).Font=Enum.Font.Gotham;v2846.MouseButton1Click:Connect(function() if ppSelPets[v2843] then ppSelPets[v2843]=nil;else ppSelPets[v2843]=true;end saveConfig();v1148();local v3380=ppSelPets[v2843]==true ;UI:updateRowVisualWithSub(v2846,v3380,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE,Color3.fromRGB(60,40,0),T.DIM);end);end end v1153.MouseButton1Click:Connect(function() local v2183=v1160();local v2184=true;for v2852,v2853 in ipairs(v2183) do if not ppSelPets[v2853.name] then v2184=false;break;end end if v2184 then for v3745,v3746 in ipairs(v2183) do ppSelPets[v3746.name]=nil;end else for v3748,v3749 in ipairs(v2183) do ppSelPets[v3749.name]=true;end end saveConfig();v1148();v1161();end);v1155:GetPropertyChangedSignal("Text"):Connect(v1161);v1147.MouseButton1Click:Connect(function() v1149.Visible=true;v1161();end);local v1162=UI:frame(pickPlacePage,UDim2.new(1,0,0,38),UDim2.new(0,0,1, -38),T.PANEL);UI:stroke(v1162,T.STROKE,1);UI:label(v1162,"AUTO PICK PLACE",UDim2.new(1, -60,0,20),UDim2.new(0,8,0.5, -10),T.TEXT,10).Font=Enum.Font.GothamBold;local v1165=UI:label(v1162,"● IDLE",UDim2.new(0,56,1,0),UDim2.new(1, -110,0,0),T.DIM,8);v1165.Font=Enum.Font.Gotham;v1165.TextXAlignment=Enum.TextXAlignment.Right;local v1169=0;local v1170=0;local v1171=0;local v1172=UI:label(v1162,"PICK:0 SKIP:0 FIRE:0",UDim2.new(0,114,0,12),UDim2.new(0,60,1, -14),T.DIM,7,Enum.TextXAlignment.Left);v1172.Font=Enum.Font.Gotham;local function v1174() v1172.Text=string.format("PICK:%d SKIP:%d FIRE:%d",v1169,v1170,v1171);end local function v1175(v2187) ppRunning=true;v1165.Text="● ON";v1165.TextColor3=T.SUCCESS;table.clear(ppCooldownCache);table.clear(globalFlags.PP_Processing);v1169=0;v1170=0;v1171=0;v1174();ppCooldownConn=PetCooldownsUpdatedRemote.OnClientEvent:Connect(function(v2854,v2855) if ( not ppRunning or not v2854) then return;end if _G.MM_SuppressPickPlace then v1170=v1170 + 1 ;v1174();return;end local v2856=tostring(v2854);v1171=v1171 + 1 ;v1174();if ( not v2855 or (typeof(v2855)~="table") or ( #v2855==0)) then return;end local v2857=false;for v3381,v3382 in ipairs(v2855) do local v3383=v3382.Time or 999 ;if (v3383<=ppPetTimer) then v2857=true;break;end end if not v2857 then return;end local v2858=v1134(v2856);local v2859=0;for v3384 in pairs(ppSelPets) do v2859=v2859 + 1 ;end if ((v2859>0) and not ppSelPets[v2858]) then v1170=v1170 + 1 ;v1174();return;end v1169=v1169 + 1 ;v1174();v1135(v2856);end);end local v1176=UI:toggle(v1162,UDim2.new(1, -52,0.5, -11),cfg.toggles.pickplace,function(v2191) cfg.toggles.pickplace=v2191;saveConfig();ppRunning=v2191;trackEvent((v2191 and "feature_on") or "feature_off" ,{feature="pick_place"});if v2191 then v1175(ppTog);else v1165.Text="● IDLE";v1165.TextColor3=T.DIM;if ppCooldownConn then ppCooldownConn:Disconnect();ppCooldownConn=nil;end table.clear(ppCooldownCache);table.clear(globalFlags.PP_Processing);end end);pickPlaceToggle=v1176;if cfg.toggles.pickplace then task.defer(function() v1175(v1176);end);end end buildPickPlaceUI();local function buildPetBoostUI() local v1177=UI:scroll(petBoostPage,UDim2.new(1,0,1,0));v1177.ScrollingDirection=Enum.ScrollingDirection.Y;v1177.AutomaticCanvasSize=Enum.AutomaticSize.Y;v1177.ScrollBarThickness=3;v1177.ScrollBarImageColor3=T.ACCENT;local v1185=Instance.new("Frame");v1185.Size=UDim2.new(1,0,0,0);v1185.BackgroundTransparency=1;v1185.AutomaticSize=Enum.AutomaticSize.Y;v1185.Parent=v1177;UI:list(v1185,6);UI:pad(v1185,6,6,6,80);local function v1190(v2193) local v2194=string.lower(v2193 or "" );local v2195=getInventory();local v2196={};for v2860 in pairs(v2195) do local v2861=v2195[v2860];if not v2861 then continue;end local v2862=string.lower(v2861.PetType or "" );if ((v2194=="") or v2862:find(v2194,1,true)) then table.insert(v2196,v2860);end end return v2196;end local v1191=UI:accordion(v1185,"⚡ QUICK BOOST",1,true);local v1192=v1191.Inner;local v1193=UI:label(v1192,"SELECT BOOST",UDim2.new(1,0,0,13),nil,T.DIM,8);v1193.LayoutOrder=1;v1193.Font=Enum.Font.Gotham;local v1197={};for v2197 in pairs(cfg.petboost.mode1.boostOptions or {} ) do v1197[v2197]=true;end if not next(v1197) then v1197["Small Toy"]=true;end local v1198={};for v2199,v2200 in ipairs(BOOST_ITEMS) do table.insert(v1198,{key=v2200.name,name=v2200.name});end local v1199=UI:inlinePickerDropdown(v1192,HydraGui,{label="Boost",multiSelect=true,items=v1198,size=UDim2.new(1,0,0,28),zIndex=50,onSelect=function(v2201) for v2864 in pairs(v1197) do v1197[v2864]=nil;end for v2866,v2867 in ipairs(v2201) do v1197[v2867]=true;end for v2869 in pairs(cfg.petboost.mode1.boostOptions) do cfg.petboost.mode1.boostOptions[v2869]=nil;end for v2871,v2872 in ipairs(v2201) do cfg.petboost.mode1.boostOptions[v2872]=true;end saveConfig();end});v1199.row.LayoutOrder=2;do local v2202={};for v2874 in pairs(v1197) do table.insert(v2202,v2874);end if ( #v2202>0) then v1199.Set(v2202);end end local v1201=cfg.petboost.mode1.selPets;local v1202=UI:frame(v1192,UDim2.new(1,0,0,26),nil,T.DARK_CARD,0);v1202.LayoutOrder=3;local v1204=UI:label(v1202,"Pets: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,4,0,0),T.DIM,9);v1204.Font=Enum.Font.Gotham;local v1206=UI:button(v1202,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1206,T.STROKE,1);local function v1207() local v2203=0;for v2875 in pairs(v1201) do v2203=v2203 + 1 ;end if (v2203==0) then v1204.Text="Pets: ALL";v1204.TextColor3=T.DIM;else v1204.Text="Pets: " .. v2203 .. " selected" ;v1204.TextColor3=T.ACCENT;end end v1207();local v1208=UI:frame(v1192,UDim2.new(1,0,0,28),nil,T.DARK_CARD,0);v1208.LayoutOrder=4;UI:label(v1208,"AUTO BOOST",UDim2.new(1, -100,1,0),UDim2.new(0,4,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;local v1212=UI:label(v1208,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),T.DIM,8);v1212.Font=Enum.Font.Gotham;local v1214=false;local function v1215() v1214=true;v1212.Text="● ON";v1212.TextColor3=T.SUCCESS;task.spawn(function() while v1214 do task.wait(boostTimingCfg.APPLY_DELAY);if globalFlags.GlobalBoostApplying then continue;end local v3394=getActivePets();local v3395={};for v3751,v3752 in ipairs(v3394) do v3395[v3752]=true;end local v3396={};local v3397=0;for v3754 in pairs(v1201) do v3397=v3397 + 1 ;end if (v3397==0) then for v4097 in pairs(v3395) do table.insert(v3396,v4097);end else for v4098 in pairs(v1201) do if v3395[v4098] then table.insert(v3396,v4098);end end end for v3755 in pairs(v1197) do local v3756,v3757=getBoostSizeAndType(v3755);for v3965,v3966 in ipairs(v3396) do if ( not v1214 or GlobalBoostApplying) then break;end if isPetAlreadyBoosted(v3966,v3756,v3757) then continue;end if not findBoostToolInBackpack(v3756,v3757) then continue;end local v3967=applyBoostToPet(v3966,v3756,v3757);if v3967 then v1212.Text="✓ " .. getPetType(v3966) .. " (" .. v3756 .. ")" ;v1212.TextColor3=T.SUCCESS;end end end v1212.Text="● ON";v1212.TextColor3=T.SUCCESS;end v1212.Text="● IDLE";v1212.TextColor3=T.DIM;end);end local v1216=UI:toggle(v1208,UDim2.new(1, -48,0.5, -11),cfg.toggles.mode1boost,function(v2207) cfg.toggles.mode1boost=v2207;saveConfig();trackEvent((v2207 and "feature_on") or "feature_off" ,{feature="auto_boost_m1"});if v2207 then v1214=true;v1215();else v1214=false;v1212.Text="● IDLE";v1212.TextColor3=T.DIM;end end);autoBoostM1Toggle=v1216;if cfg.toggles.mode1boost then task.defer(function() v1215();end);end local v1217=UI:accordion(v1185,"⚡ BOOST MODE 2",3,false);local v1218=v1217.Inner;local v1219=UI:label(v1218,"ADD PAIR",UDim2.new(1,0,0,13),nil,T.DIM,8);v1219.LayoutOrder=1;v1219.Font=Enum.Font.Gotham;local v1222=UI:frame(v1218,UDim2.new(1,0,0,28),nil,T.BTN);v1222.LayoutOrder=2;UI:corner(v1222,5);UI:stroke(v1222,T.STROKE,1);local v1224=UI:label(v1222,"No pet selected",UDim2.new(1, -92,1,0),UDim2.new(0,8,0,0),T.DIM,9);v1224.Font=Enum.Font.Gotham;local v1226=UI:button(v1222,"Pick pet >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),T.BTN,T.ACCENT,9);UI:stroke(v1226,T.STROKE,1);local v1227=UI:label(v1218,"SELECT BOOST",UDim2.new(1,0,0,13),nil,T.DIM,8);v1227.LayoutOrder=3;v1227.Font=Enum.Font.Gotham;local v1230={};if ((type(cfg.petboost.mode2.boostOptions)=="table") and next(cfg.petboost.mode2.boostOptions)) then for v3404 in pairs(cfg.petboost.mode2.boostOptions) do v1230[v3404]=true;end else v1230["Small Toy"]=true;end local v1231=UI:inlinePickerDropdown(v1218,HydraGui,{label="Boost",multiSelect=true,items=v1198,size=UDim2.new(1,0,0,28),zIndex=51,onSelect=function(v2209) for v2880 in pairs(v1230) do v1230[v2880]=nil;end for v2882,v2883 in ipairs(v2209) do v1230[v2883]=true;end defaultBoostItem=v2209[1] or "Small Toy" ;if not cfg.petboost.mode2.boostOptions then cfg.petboost.mode2.boostOptions={};end for v2885 in pairs(cfg.petboost.mode2.boostOptions) do cfg.petboost.mode2.boostOptions[v2885]=nil;end for v2887,v2888 in ipairs(v2209) do cfg.petboost.mode2.boostOptions[v2888]=true;end saveConfig();end});v1231.row.LayoutOrder=4;do local v2210={};for v2890 in pairs(v1230) do table.insert(v2210,v2890);end if ( #v2210>0) then v1231.Set(v2210);end end local v1233=UI:button(v1218,"+ ADD TO LIST",UDim2.new(1,0,0,26),nil,T.ACCENT,T.SEL_TXT,10);v1233.LayoutOrder=5;UI:stroke(v1233,T.ACCENT,1);UI:divider(v1218,6);local v1235=UI:label(v1218,"BOOST LIST:",UDim2.new(1,0,0,13),nil,T.DIM,8);v1235.LayoutOrder=7;v1235.Font=Enum.Font.Gotham;local v1238=UI:frame(v1218,UDim2.new(1,0,0,0),nil,T.DARK_CARD,0);v1238.LayoutOrder=8;v1238.AutomaticSize=Enum.AutomaticSize.Y;UI:list(v1238,3);local function v1241() for v2891,v2892 in ipairs(v1238:GetChildren()) do if v2892:IsA("GuiObject") then v2892:Destroy();end end if ( #cfg.petboost.mode2.pairs==0) then local v3407=UI:label(v1238," (no pets added)",UDim2.new(1,0,0,18),nil,T.DIM,9);v3407.Font=Enum.Font.Gotham;v3407.LayoutOrder=1;return;end for v2893,v2894 in ipairs(cfg.petboost.mode2.pairs) do local v2895=getPetType(v2894.uuid);local v2896=getKG(v2894.uuid);local v2897=getAge(v2894.uuid);local v2898=(isFavorited(v2894.uuid) and " ❤") or "" ;local v2899=UI:frame(v1238,UDim2.new(1,0,0,40),nil,T.BTN);v2899.LayoutOrder=v2893;UI:corner(v2899,5);UI:stroke(v2899,T.STROKE,1);UI:label(v2899,v2895 .. v2898 ,UDim2.new(1, -34,0,16),UDim2.new(0,8,0,3),T.TEXT,9);local v2901=UI:label(v2899,string.format("Age %d | %.2fKG | %s · %s",v2897,v2896,v2894.boostType,v2894.boostSize),UDim2.new(1, -34,0,13),UDim2.new(0,8,0,22),T.DIM,8);v2901.Font=Enum.Font.Gotham;local v2904=UI:button(v2899,"-",UDim2.new(0,24,0,24),UDim2.new(1, -28,0.5, -12),T.ERROR,T.TEXT,14);UI:stroke(v2904,T.ERROR,1);local v2905=v2893;v2904.MouseButton1Click:Connect(function() table.remove(cfg.petboost.mode2.pairs,v2905);saveConfig();v1241();end);end end v1241();local v1242;local v1243={};local function v1244() local v2211=0;for v2906 in pairs(v1243) do v2211=v2211 + 1 ;end if (v2211==0) then v1224.Text="No pet selected";v1224.TextColor3=T.DIM;else v1224.Text=v2211 .. " pet(s) selected" ;v1224.TextColor3=T.ACCENT;end end v1233.MouseButton1Click:Connect(function() local v2212=0;for v2907 in pairs(v1230) do local v2908,v2909=getBoostSizeAndType(v2907);for v3417,v3418 in pairs(v1243) do if not v3418 then continue;end local v3419=false;for v3758,v3759 in ipairs(cfg.petboost.mode2.pairs) do if ((v3759.uuid==v3417) and (v3759.boostType==v2909) and (v3759.boostSize==v2908)) then v3419=true;break;end end if not v3419 then table.insert(cfg.petboost.mode2.pairs,{uuid=v3417,boostType=v2909,boostSize=v2908});v2212=v2212 + 1 ;end end end if (v2212>0) then saveConfig();v1241();for v3760 in pairs(v1243) do v1243[v3760]=nil;end v1224.Text="No pet selected";v1224.TextColor3=T.DIM;v1244();if v1242 then v1242.Visible=false;end end end);local v1245=UI:frame(v1218,UDim2.new(1,0,0,28),nil,T.DARK_CARD,0);v1245.LayoutOrder=9;UI:label(v1245,"AUTO BOOST (M2)",UDim2.new(1, -100,1,0),UDim2.new(0,4,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;local v1248=UI:label(v1245,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),T.DIM,8);v1248.Font=Enum.Font.Gotham;local v1250=false;local function v1251() v1250=true;v1248.Text="● ON";v1248.TextColor3=T.SUCCESS;task.spawn(function() while v1250 do task.wait(boostTimingCfg.APPLY_DELAY);if globalFlags.GlobalBoostApplying then continue;end local v3423=getActivePets();local v3424={};for v3762,v3763 in ipairs(v3423) do v3424[v3763]=true;end for v3765,v3766 in ipairs(cfg.petboost.mode2.pairs) do if ( not v1250 or GlobalBoostApplying) then break;end if not v3424[v3766.uuid] then continue;end if isPetAlreadyBoosted(v3766.uuid,v3766.boostSize,v3766.boostType) then continue;end if not findBoostToolInBackpack(v3766.boostSize,v3766.boostType) then continue;end local v3767=applyBoostToPet(v3766.uuid,v3766.boostSize,v3766.boostType);if v3767 then v1248.Text="✓ " .. getPetType(v3766.uuid) .. " (" .. v3766.boostSize .. ")" ;v1248.TextColor3=T.SUCCESS;end end v1248.Text="● ON";v1248.TextColor3=T.SUCCESS;end v1248.Text="● IDLE";v1248.TextColor3=T.DIM;end);end local v1252=UI:toggle(v1245,UDim2.new(1, -48,0.5, -11),cfg.toggles.mode2boost,function(v2216) cfg.toggles.mode2boost=v2216;saveConfig();trackEvent((v2216 and "feature_on") or "feature_off" ,{feature="auto_boost_m2"});if v2216 then v1250=true;v1251();else v1250=false;v1248.Text="● IDLE";v1248.TextColor3=T.DIM;end end);autoBoostM2Toggle=v1252;if cfg.toggles.mode2boost then task.defer(function() v1251();end);end do local v2218=UI:frame(petBoostPage,UDim2.new(1,0,1,0),nil,T.BG);v2218.Visible=false;v2218.ZIndex=30;local v2221=UI:frame(v2218,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v2221,T.STROKE,1);UI:label(v2221,"Select Pets — Quick Boost",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v2222=UI:button(v2221,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),T.BTN,T.ACCENT,8);UI:stroke(v2222,T.STROKE,1);local v2223=UI:button(v2221,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),T.ERROR,T.TEXT,10);UI:stroke(v2223,T.ERROR,1);v2223.MouseButton1Click:Connect(function() v2218.Visible=false;v1207();end);local v2224=UI:input(v2218,"","Search...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v2224.TextColor3=T.TEXT;v2224.Font=Enum.Font.Gotham;local v2229=UI:scroll(v2218,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v2229,3);UI:pad(v2229,3,4,4,3);local function v2230() local v2914={};pcall(function() for v3768,v3769 in ipairs(getActivePets()) do v2914[v3769]=true;end end);local v2915=v1190(v2224.Text);local v2916= #v2915>0 ;for v3431,v3432 in ipairs(v2915) do if not v1201[v3432] then v2916=false;break;end end v2222.Text=(( #v2915==0) and "Select All") or (v2916 and "Unselect All") or "Select All" ;v2222.TextColor3=(v2916 and T.SEL_TXT) or T.ACCENT ;v2222.BackgroundColor3=(v2916 and T.SEL_BG) or T.BTN ;UI:buildPetList(v2229,v2914,v1201,function(v3433,v3434,v3435) if v3435[v3433] then v3435[v3433]=nil;else v3435[v3433]=true;end saveConfig();v1207();UI:updateRowVisual(v3434,v3435[v3433]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end,v2224.Text,getKG,getInventory,isFavorited,getAge);end v2222.MouseButton1Click:Connect(function() local v2920=v1190(v2224.Text);local v2921= #v2920>0 ;for v3436,v3437 in ipairs(v2920) do if not v1201[v3437] then v2921=false;break;end end if v2921 then for v3971,v3972 in ipairs(v2920) do v1201[v3972]=nil;end else for v3974,v3975 in ipairs(v2920) do v1201[v3975]=true;end end saveConfig();v1207();for v3438,v3439 in ipairs(v2229:GetChildren()) do if v3439:IsA("TextButton") then local v3977=v3439:GetAttribute("uuid");if v3977 then UI:updateRowVisual(v3439,v1201[v3977]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end end end end);v2224:GetPropertyChangedSignal("Text"):Connect(v2230);v1206.MouseButton1Click:Connect(function() v2218.Visible=true;task.delay(0.1,v2230);end);end do v1242=UI:frame(petBoostPage,UDim2.new(1,0,1,0),nil,T.BG);v1242.Visible=false;v1242.ZIndex=30;local v2233=UI:frame(v1242,UDim2.new(1,0,0,26),nil,T.PANEL);UI:stroke(v2233,T.STROKE,1);UI:label(v2233,"Pick Pet — Mode 2",UDim2.new(1, -116,1,0),UDim2.new(0,8,0,0),T.ACCENT,10);local v2234=UI:button(v2233,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -112,0.5, -10),T.BTN,T.ACCENT,8);UI:stroke(v2234,T.STROKE,1);local v2235=UI:button(v2233,"Done",UDim2.new(0,40,0,20),UDim2.new(1, -44,0.5, -10),T.ACCENT,T.TEXT,10);UI:stroke(v2235,T.ACCENT,1);v2235.MouseButton1Click:Connect(function() v1242.Visible=false;end);local v2236=UI:input(v1242,"","Search...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v2236.TextColor3=T.TEXT;v2236.Font=Enum.Font.Gotham;local v2241=UI:scroll(v1242,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));UI:list(v2241,3);UI:pad(v2241,3,4,4,3);local function v2242() local v2924={};pcall(function() for v3771,v3772 in ipairs(getActivePets()) do v2924[v3772]=true;end end);local v2925=v1190(v2236.Text);local v2926= #v2925>0 ;for v3440,v3441 in ipairs(v2925) do if not v1243[v3441] then v2926=false;break;end end v2234.Text=(( #v2925==0) and "Select All") or (v2926 and "Unselect All") or "Select All" ;v2234.TextColor3=(v2926 and T.SEL_TXT) or T.ACCENT ;v2234.BackgroundColor3=(v2926 and T.SEL_BG) or T.BTN ;UI:buildPetList(v2241,v2924,v1243,function(v3442,v3443,v3444) if v3444[v3442] then v3444[v3442]=nil;else v3444[v3442]=true;end v1244();UI:updateRowVisual(v3443,v3444[v3442]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end,v2236.Text,getKG,getInventory,isFavorited,getAge);end v2234.MouseButton1Click:Connect(function() local v2930=v1190(v2236.Text);local v2931= #v2930>0 ;for v3445,v3446 in ipairs(v2930) do if not v1243[v3446] then v2931=false;break;end end if v2931 then for v3980,v3981 in ipairs(v2930) do v1243[v3981]=nil;end else for v3983,v3984 in ipairs(v2930) do v1243[v3984]=true;end end v1244();for v3447,v3448 in ipairs(v2241:GetChildren()) do if v3448:IsA("TextButton") then local v3986=v3448:GetAttribute("uuid");if v3986 then UI:updateRowVisual(v3448,v1243[v3986]==true ,T.SEL_BG,T.SEL_TXT,Color3.fromRGB(13,13,13),T.TEXT,T.ACCENT,T.STROKE);end end end end);v2236:GetPropertyChangedSignal("Text"):Connect(v2242);v1226.MouseButton1Click:Connect(function() v1242.Visible=true;task.delay(0.1,v2242);end);end end buildPetBoostUI();local function buildWebhookUI() local v1253=UI:scroll(webhookPage,UDim2.new(1,0,1,0));UI:list(v1253,6);UI:pad(v1253,8,8,8,8);local v1254=UI:label(v1253,"🦇 WEBHOOK",UDim2.new(1,0,0,16),nil,T.ACCENT,11);v1254.LayoutOrder=1;local v1256=UI:label(v1253,"Webhook URL",UDim2.new(1,0,0,13),nil,T.DIM,8);v1256.LayoutOrder=2;v1256.Font=Enum.Font.Gotham;local v1260=Instance.new("TextBox");v1260.Size=UDim2.new(1,0,0,28);v1260.BackgroundColor3=T.BTN;v1260.BorderSizePixel=0;v1260.Text=cfg.webhook.url or "" ;v1260.PlaceholderText="https://discord.com/api/webhooks/ID/TOKEN";v1260.TextColor3=T.ACCENT;v1260.PlaceholderColor3=T.DIM;v1260.Font=Enum.Font.Gotham;v1260.TextSize=9;v1260.ClearTextOnFocus=false;v1260.TextTruncate=Enum.TextTruncate.AtEnd;v1260.TextXAlignment=Enum.TextXAlignment.Left;v1260.LayoutOrder=3;v1260.Parent=v1253;UI:corner(v1260,5);UI:stroke(v1260,T.STROKE,1);UI:pad(v1260,0,8,8,0);v1260.FocusLost:Connect(function() cfg.webhook.url=v1260.Text;saveConfig();end);v1260:GetPropertyChangedSignal("Text"):Connect(function() cfg.webhook.url=v1260.Text;end);local v1280=UI:frame(v1253,UDim2.new(1,0,0,28),nil,T.BTN);v1280.LayoutOrder=4;UI:corner(v1280,5);UI:stroke(v1280,T.STROKE,1);UI:label(v1280,"Continue Session (after rejoin)",UDim2.new(1, -52,1,0),UDim2.new(0,8,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;UI:toggle(v1280,UDim2.new(1, -48,0.5, -11),cfg.webhook.continueSession,function(v2247) cfg.webhook.continueSession=v2247;saveConfig();if not v2247 then deleteSession();end end);local v1284=UI:button(v1253,"🔄 Reset Session Data",UDim2.new(1,0,0,28),nil,T.BTN,T.ERROR,10);v1284.LayoutOrder=5;UI:stroke(v1284,T.ERROR,1);v1284.MouseButton1Click:Connect(function() deleteSession();v1284.Text="✓ Session Reset!";v1284.TextColor3=T.SUCCESS;task.delay(2,function() v1284.Text="🔄 Reset Session Data";v1284.TextColor3=T.ERROR;end);end);local v1286=UI:button(v1253,"Send Test",UDim2.new(1,0,0,26),nil,T.BTN,T.ACCENT,10);v1286.LayoutOrder=6;UI:stroke(v1286,T.STROKE,1);v1286.MouseButton1Click:Connect(function() if (cfg.webhook.url=="") then v1286.Text="⚠ No URL!";v1286.TextColor3=T.ERROR;task.delay(1.5,function() v1286.Text="Send Test";v1286.TextColor3=T.ACCENT;end);return;end task.spawn(sendTestWebhook);v1286.Text="Sent!";v1286.TextColor3=T.SUCCESS;task.delay(1.5,function() v1286.Text="Send Test";v1286.TextColor3=T.ACCENT;end);end);end buildWebhookUI();local minimizedBtn=Instance.new("TextButton",HydraGui);minimizedBtn.Size=UDim2.new(0,42,0,42);minimizedBtn.Position=UDim2.new(0,20,0.5, -21);minimizedBtn.BackgroundColor3=Color3.fromRGB(18,18,18);minimizedBtn.BorderSizePixel=0;minimizedBtn.Text="";minimizedBtn.TextColor3=T.ACCENT;minimizedBtn.Font=Enum.Font.GothamBold;minimizedBtn.TextSize=18;minimizedBtn.Active=true;minimizedBtn.Draggable=true;minimizedBtn.Visible=false;UI:corner(minimizedBtn,10);UI:stroke(minimizedBtn,T.ACCENT,1);local minimizedBtnIcon=Instance.new("ImageLabel",minimizedBtn);minimizedBtnIcon.Size=UDim2.new(1, -6,1, -6);minimizedBtnIcon.Position=UDim2.new(0,3,0,3);minimizedBtnIcon.BackgroundTransparency=1;minimizedBtnIcon.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150";minimizedBtnIcon.ScaleType=Enum.ScaleType.Fit;minimizedBtn.MouseButton1Click:Connect(function() minimizedBtn.Visible=false;mainFrame.Visible=true;end);minimizeBtn.MouseButton1Click:Connect(function() mainFrame.Visible=false;minimizedBtn.Visible=true;end);do local v1292,v1293,v1294,v1295=420,900,320,700;local v1296=Instance.new("Frame",mainFrame);v1296.Size=UDim2.new(0,28,0,28);v1296.Position=UDim2.new(1, -28,1, -28);v1296.BackgroundTransparency=1;v1296.BorderSizePixel=0;v1296.Active=true;v1296.ZIndex=9999;local function v1303(v2255,v2256) local v2257=Instance.new("Frame",v1296);v2257.Size=UDim2.new(0,4,0,4);v2257.Position=UDim2.new(0,v2255,0,v2256);v2257.BackgroundColor3=T.ACCENT;v2257.BackgroundTransparency=0.3;v2257.BorderSizePixel=0;v2257.ZIndex=9999;UI:corner(v2257,2);end v1303(16,16);v1303(10,22);v1303(22,10);local v1304,v1305,v1306,v1307=false,nil,nil,nil;v1296.InputBegan:Connect(function(v2265) if ((v2265.UserInputType==Enum.UserInputType.MouseButton1) or (v2265.UserInputType==Enum.UserInputType.Touch)) then v1304=true;v1305=v2265;v1306=v2265.Position;v1307=mainFrame.Size;v2265.Changed:Connect(function() if (v2265.UserInputState==Enum.UserInputState.End) then v1304=false;end end);end end);v1296.InputChanged:Connect(function(v2266) if ((v2266.UserInputType==Enum.UserInputType.MouseMovement) or (v2266.UserInputType==Enum.UserInputType.Touch)) then v1305=v2266;end end);UIS.InputChanged:Connect(function(v2267) if ( not v1304 or (v2267~=v1305)) then return;end local v2268=v2267.Position-v1306 ;mainFrame.Size=UDim2.new(0,math.clamp(v1307.X.Offset + v2268.X ,v1292,v1293),0,math.clamp(v1307.Y.Offset + v2268.Y ,v1294,v1295));end);end task.spawn(function() local v1308=game:GetService("VirtualUser");task.wait(10);while true do task.wait(15 * 60 );pcall(function() v1308:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.15);v1308:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.3);v1308:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.15);v1308:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame);end);end end);local function buildMiscUI() local v1309=UI:scroll(miscPage,UDim2.new(1,0,1,0));v1309.ScrollingDirection=Enum.ScrollingDirection.Y;v1309.AutomaticCanvasSize=Enum.AutomaticSize.Y;v1309.ScrollBarThickness=3;v1309.ScrollBarImageColor3=T.ACCENT;local v1317=Instance.new("Frame",v1309);v1317.Size=UDim2.new(1,0,0,0);v1317.BackgroundTransparency=1;v1317.AutomaticSize=Enum.AutomaticSize.Y;UI:list(v1317,4);UI:pad(v1317,6,6,6,20);local v1321=UI:accordion(v1317,"👁 VISIBILITY",1,true);do local v2270={};local function v2271(v2939) if (v2939:IsA("BasePart") or v2939:IsA("UnionOperation") or v2939:IsA("MeshPart")) then pcall(function() v2939.Transparency=1;end);end if (v2939:IsA("Decal") or v2939:IsA("Texture")) then pcall(function() v2939.Transparency=1;end);end if (v2939:IsA("ParticleEmitter") or v2939:IsA("Trail") or v2939:IsA("Beam")) then pcall(function() v2939.Enabled=false;end);end if (v2939:IsA("PointLight") or v2939:IsA("SpotLight") or v2939:IsA("SurfaceLight")) then pcall(function() v2939.Enabled=false;end);end end local function v2272() local v2940=workspace:FindFirstChild("Farm");if not v2940 then return;end local function v2941(v3454) local v3455=v3454:FindFirstChild("Important");if not v3455 then return;end local v3456=v3455:FindFirstChild("Plants_Physical");if not v3456 then return;end for v3777,v3778 in ipairs(v3456:GetDescendants()) do v2271(v3778);end table.insert(v2270,v3456.DescendantAdded:Connect(function(v3779) task.wait();v2271(v3779);end));end for v3457,v3458 in ipairs(v2940:GetChildren()) do v2941(v3458);end table.insert(v2270,v2940.ChildAdded:Connect(function(v3459) task.wait(0.5);v2941(v3459);end));end local v2273=UI:frame(v1321.Inner,UDim2.new(1,0,0,26),nil,T.BTN);v2273.LayoutOrder=1;UI:corner(v2273,5);UI:stroke(v2273,T.STROKE,1);UI:label(v2273,"Hide Farm Plants",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;UI:toggle(v2273,UDim2.new(1, -48,0.5, -11),cfg.toggles.hidePlants,function(v2942) cfg.toggles.hidePlants=v2942;saveConfig();if v2942 then v2272();else for v3991,v3992 in ipairs(v2270) do pcall(function() v3992:Disconnect();end);end table.clear(v2270);end end);if cfg.toggles.hidePlants then v2272();end end local v1322=UI:accordion(v1317,"🔄 AUTO RENEW SERVER",2,true);do local v2277=v1322.Inner;local v2278=UI:frame(v2277,UDim2.new(1,0,0,26),nil,T.BTN);v2278.LayoutOrder=1;UI:corner(v2278,5);UI:stroke(v2278,T.STROKE,1);local v2280=UI:label(v2278,"Job ID: " .. tostring(game.JobId) ,UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),T.DIM,8);v2280.Font=Enum.Font.Gotham;v2280.TextTruncate=Enum.TextTruncate.AtEnd;v2280.TextXAlignment=Enum.TextXAlignment.Left;local v2287=UI:frame(v2277,UDim2.new(1,0,0,26),nil,T.BTN);v2287.LayoutOrder=2;UI:corner(v2287,5);UI:stroke(v2287,T.STROKE,1);local v2289=UI:label(v2287,"Server Version: " .. tostring(game.PlaceVersion) ,UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),T.DIM,8);v2289.Font=Enum.Font.Gotham;v2289.TextXAlignment=Enum.TextXAlignment.Left;local v2292=UI:frame(v2277,UDim2.new(1,0,0,26),nil,T.BTN);v2292.LayoutOrder=3;UI:corner(v2292,5);UI:stroke(v2292,T.STROKE,1);UI:label(v2292,"Interval (minutes)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),T.DIM,9).Font=Enum.Font.Gotham;local v2295=cfg.misc.rsInterval;local v2296=UI:input(v2292,v2295,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v2296.FocusLost:Connect(function() local v2944=tonumber(v2296.Text);if (v2944 and (v2944>=1)) then v2295=v2944;cfg.misc.rsInterval=v2944;saveConfig();else v2296.Text=tostring(v2295);end end);local v2297=UI:frame(v2277,UDim2.new(1,0,0,26),nil,T.BTN);v2297.LayoutOrder=4;UI:corner(v2297,5);UI:stroke(v2297,T.STROKE,1);local v2299=UI:label(v2297,"Next rejoin: --:--",UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),T.DIM,9);v2299.Font=Enum.Font.Gotham;v2299.TextXAlignment=Enum.TextXAlignment.Left;local v2302=UI:frame(v2277,UDim2.new(1,0,0,26),nil,T.BTN);v2302.LayoutOrder=5;UI:corner(v2302,5);UI:stroke(v2302,T.STROKE,1);UI:label(v2302,"AUTO RENEW SERVER",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),T.TEXT,9).Font=Enum.Font.GothamBold;local v2306=nil;UI:toggle(v2302,UDim2.new(1, -48,0.5, -11),cfg.toggles.autoRefresh,function(v2945) cfg.toggles.autoRefresh=v2945;saveConfig();local v2947=false;if v2945 then v2947=true;v2306=task.spawn(function() while v2947 do local v4102=v2295 * 60 ;local v4103=0;while (v4103
