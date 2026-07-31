local v0={Players=game:GetService("Players"),RS=game:GetService("ReplicatedStorage"),Http=game:GetService("HttpService"),CoreGui=game:GetService("CoreGui"),CS=game:GetService("CollectionService"),UIS=game:GetService("UserInputService")}
local v1=v0.Players
local v2=v0.RS
local v3=v0.Http
local v4=v0.CoreGui
local v5=v0.CS
local v6=v0.UIS
local v7=v1.LocalPlayer
local v8=v7:WaitForChild("Backpack")
local v9=v7.Character or v7.CharacterAdded:Wait()
v7.CharacterAdded:Connect(function(v268) v9=v268
end)
local v10=require(v2.Modules.DataService)
local v11={Pets=v2:WaitForChild("GameEvents"):WaitForChild("PetsService"),Boost=v2:WaitForChild("GameEvents"):WaitForChild("PetBoostService")}
local v12=v11.Pets
local v13=v11.Boost
local v14=loadstring(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/HydraMainLibrary.lua"))()
local v15={BG=Color3.fromRGB(18,18,31),PANEL=Color3.fromRGB(12,12,20),BTN=Color3.fromRGB(26,26,46),SIDEBAR=Color3.fromRGB(14,14,24),STROKE=Color3.fromRGB(58,58,92),ACCENT=Color3.fromRGB(127,119,221),TEXT=Color3.fromRGB(220,220,235),DIM=Color3.fromRGB(100,100,130),SEL_BG=Color3.fromRGB(127,119,221),SEL_TXT=Color3.fromRGB(255,255,255),SUCCESS=Color3.fromRGB(80,210,100),ERROR=Color3.fromRGB(215,70,70),TOGGLE_ON=Color3.fromRGB(127,119,221),TOGGLE_OFF=Color3.fromRGB(35,35,55),ACTIVE_BG=Color3.fromRGB(20,20,50),ACTIVE_TXT=Color3.fromRGB(160,150,255),DARK_CARD=Color3.fromRGB(10,10,18),PHASE2=Color3.fromRGB(180,120,255)}
local v16=v14.new(v15)
if not v14.buildPetList then v14.buildPetList=function(v2360,v2361,v2362,v2363,v2364,v2365,v2366,v2367,v2368,v2369) local v2370=v2360.T
        for v3013,v3014 in ipairs(v2361:GetChildren()) do if v3014:IsA("GuiObject") then v3014:Destroy()
            end end local v2371=string.lower(v2365 or "" )
    local v2372=v2367()
    local v2373={}
    for v3015 in pairs(v2372) do table.insert(v2373,v3015)
    end table.sort(v2373,function(v3016,v3017) local v3018=(v2362[v3016] and 1) or 0
    local v3019=(v2362[v3017] and 1) or 0
    if (v3018~=v3019) then return v3018>v3019
    end return v2366(v3016)>v2366(v3017)
end)
for v3020,v3021 in ipairs(v2373) do local v3022=v2372[v3021]
if not v3022 then continue
end local v3023=v3022.PetType or "?"
if ((v2371~="") and not v3023:lower():find(v2371,1,true)) then continue
end local v3024=v2362[v3021]
local v3025=v2363[v3021]==true
local v3026=(v3022.PetData and (v3022.PetData.Level or 0)) or 0
local v3027=v2366(v3021)
local v3028=(v3022.PetData and (v3022.PetData.BaseWeight or 0)) or 0
local v3029=(v2368(v3021) and " ❤") or ""
local v3030=(v3024 and " (active)") or ""
local v3031=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v3023,v3030,v3029,v3026,v3027,v3028)
local v3032=v2360:button(v2361,v3031,UDim2.new(1,0,0,26),nil,(v3025 and v2370.SEL_BG) or (v3024 and v2370.ACTIVE_BG) or Color3.fromRGB(13,13,13) ,(v3025 and v2370.SEL_TXT) or (v3024 and v2370.ACTIVE_TXT) or v2370.TEXT ,9)
v3032.LayoutOrder=v3020
v3032:SetAttribute("uuid",v3021)
v3032.TextXAlignment=Enum.TextXAlignment.Left
v2360:pad(v3032,0,8,4,0)
v2360:stroke(v3032,(v3025 and v2370.ACCENT) or v2370.STROKE ,1)
v3032.MouseButton1Click:Connect(function() v2364(v3021,v3032,v2363)
end)
end end
end local v17=v3:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/wardz25/updater/refs/heads/main/pets.json"))
local v18={}
task.spawn(function() local v269,v270=pcall(function() return v3:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/wardz25/updater/refs/heads/main/PetAssetId.json"))
    end)
if (v269 and v270) then v18=v270
end end)
local v19=v3:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/wardz25/updater/refs/heads/main/mutation.json"))
local v20="PET_UUID"
local v21="d"
local v22="HydraX.json"
local v23=CFrame.new( -22.884647369384766,0.13552331924438477,55.001434326171875)
local v24={EQUIP_DELAY=0.08,UNEQUIP_DELAY=0.05,UNEQUIP_BUFFER=0.01,AH_EQUIP_DELAY=0.15,AH_UNEQUIP_DELAY=0.1,AH_POST_UNEQUIP_BUFFER=0.5,AH_KOI_SAFE_DELAY=1,AH_KOI_POST_HATCH=1.5,AH_SEAL_SAFE_DELAY=1,AH_SEAL_POST_SELL=2,POLL_RATE=3}
local v25=false
local v26="hx_punpsdun_tracker_2024"
local v27="https://hydra-checker.vercel.app/api/t"
local v28="https://hydra-checker.vercel.app/api/load-tracker?token=" .. v26
task.spawn(function() local v271,v272=pcall(function() return loadstring(game:HttpGet(v28))()
    end)
if (v271 and v272) then _HT=v272
    _HT.init({username=v7.Name,userId=tostring(v7.UserId),secret=v26,endpoint=v27})
end end)
local function v29(v273,v274) if not _HT then return
end pcall(function() _HT.track(v273,v274)
end)
end local v30={EQUIP_WAIT=0.1,FIRE_WAIT=0.1,UNEQUIP_WAIT=0.05,APPLY_DELAY=0.5,TEAM_CHECK=3}
local v31={{name="Small Toy",size="Small",btype="Toy"},{name="Medium Toy",size="Medium",btype="Toy"},{name="Large Toy",size="Large",btype="Toy"},{name="Small Treat",size="Small",btype="Treat"},{name="Medium Treat",size="Medium",btype="Treat"}}
local function v32(v275) for v1332,v1333 in ipairs(v31) do if (v1333.name==v275) then return v1333.size,v1333.btype
        end end return "Small","Toy"
end local v33={petTeams={},elephant={levelingTeam=nil,elephantTeam=nil,targetWeight=3.5,levelThreshold=50,phase2Team=nil,phase2Enabled=false,phase2Threshold=50,levelTo100=true,gardenSlots=1,gardenMode="A",useExtraPets=false,extraPets={},useExtraElePets=false,extraElePets={}},targets={},pickplace={petTimer=0,pickDelay=0.2,placeDelay=0.1,selPets={},selUUIDs={},modeB=false},petboost={mode1={boostOptions={},selPets={}},mode2={pairs={},boostOptions={}}},toggles={autoKG=false,pickplace=false,mode1boost=false,mode2boost=false,autoCollect=false,hidePlants=false,autoRefresh=false,autoTradeWorld=false},misc={rsInterval=19},webhook={url="",continueSession=false},leveling={mainTeam=nil,optTeam=nil,optEnabled=false,optThreshold=50,targets={}},autoCollect={interval=0.1,sellAfter=false,selFruits={},selVariants={},stopWhenFull=false,maxInv=200},autoHatch={eggName="Paradise Egg",eggCount=13,eggSpacing=7,teamCD=nil,teamKoi=nil,teamSeal=nil,teamBronto=nil,brontoEnabled=true,brontoThresh=4,sellPets={},sellThresh=0,favDelay=0.1,espEnabled=true,running=false,autoSellWhenFull=false,petInvMax=200},autoTrade={targetPlayer=nil,selPets={},kgMode="Above",kgVal=0,ageMode="Above",ageVal=0,autoAccept=false,autoGift=false}}
local v34="Small Toy"
local v35={}
v35.save=function() if not writefile then return
    end pcall(function() writefile(v22,v3:JSONEncode(v33))
end)
end
local v37=v35.save
local v38={{name="7 Mimic + 1 Bald Eagle",desc="Max passive Mimic, 1 Eagle filler",slots={{petType="Mimic Octopus",count=7},{petType="Bald Eagle",count=1}}},{name="Koi Max Passive",desc="Max hatch rate bonus, highest KG + mutation",slots={{petType="Koi",count=8}}},{name="Seal Max Passive",desc="Max sell return chance, always 8 Seal",slots={{petType="Seal",count=8}}},{name="Bronto Max Passive",desc="Max hatch size bonus (~30%), rest filled with Koi",slots={{petType="Brontosaurus",count=8},{petType="Koi",count=8}}},{name="Magpie Method",desc="1 Mimic, 3 Magpie, 1 Cockatrice, 3 filler priority",slots={{petType="Mimic Octopus",count=1},{petType="Magpie",count=3},{petType="Cockatrice",count=1}},priorityFiller={"Giant Ant","Red Giant Ant","Silver Monkey","Cape Buffalo"},fillerCount=3}}
local function v39(v276) if not v276 then return {}
    end for v1334,v1335 in ipairs(v38) do if (v1335.name==v276) then local v3036=(function() local v3562=v10:GetData()
            return (v3562 and v3562.PetsData and v3562.PetsData.PetInventory.Data) or {}
        end)()
    local v3037={}
    for v3563,v3564 in pairs(v3036) do local v3565=v3564.PetType or ""
        if not v3037[v3565] then v3037[v3565]={}
        end table.insert(v3037[v3565],v3563)
end local v3038={a=0,b=0.1,c=0.2,d=0.3,g=0.5,s=0.05,z=0.08,A=0.22,J=0.01,K=0.03,L=0.045,M=0.06,N=0.07,O=0.07,P=0.3,V=0.2,X=0.3,Y=0.3,Z=0.3,["@"]=0.23,EV=0.3,RJ=0.25}
local function v3039(v3566) local v3567=v3036[v3566]
if ( not v3567 or not v3567.PetData) then return 0
end local v3568=v3567.PetData.BaseWeight or 0
local v3569=v3567.PetData.MutationType or "m"
return v3568 * (1 + (v3038[v3569] or 0))
end local function v3040(v3570) local v3571=v3036[v3570]
if ( not v3571 or not v3571.PetData) then return 0
end local v3572=v3571.PetData.BaseWeight or 0
local v3573=v3571.PetData.MutationType or "m"
return (5.35 + (v3572 * 0.1)) * (1 + (v3038[v3573] or 0))
end for v3574,v3575 in pairs(v3037) do table.sort(v3575,function(v3914,v3915) return v3039(v3914)>v3039(v3915)
end)
end if (v1335.name=="Magpie Method") then local v3916={}
for v4138,v4139 in ipairs(v1335.slots) do local v4140=v3037[v4139.petType] or {}
    local v4141=0
    for v4258,v4259 in ipairs(v4140) do if ( #v3916>=8) then break
        end if (v4141>=v4139.count) then break
    end table.insert(v3916,v4259)
v4141=v4141 + 1
end end local v3917=0
local v3918=v1335.fillerCount or 3
local v3919={}
for v4142,v4143 in ipairs(v1335.priorityFiller or {} ) do for v4260,v4261 in ipairs(v3037[v4143] or {} ) do local v4262=false
        for v4361,v4362 in ipairs(v3916) do if (v4362==v4261) then v4262=true
                break
            end end if not v4262 then table.insert(v3919,v4261)
    end end end table.sort(v3919,function(v4144,v4145) return v3039(v4144)>v3039(v4145)
end)
for v4146,v4147 in ipairs(v3919) do if ( #v3916>=8) then break
end if (v3917>=v3918) then break
end table.insert(v3916,v4147)
v3917=v3917 + 1
end return v3916
end if (v1335.name=="Bronto Max Passive") then local v3920={}
local v3921=0
local v3922=v3037['Brontosaurus'] or {}
table.sort(v3922,function(v4148,v4149) return v3040(v4148)>v3040(v4149)
end)
for v4150,v4151 in ipairs(v3922) do if ( #v3920>=8) then break
end if (v3921>=30) then break
end table.insert(v3920,v4151)
v3921=v3921 + v3040(v4151)
end local v3923=v3037['Koi'] or {}
for v4152,v4153 in ipairs(v3923) do if ( #v3920>=8) then break
end table.insert(v3920,v4153)
end return v3920
end local v3041={}
for v3576,v3577 in ipairs(v1335.slots) do local v3578=v3037[v3577.petType] or {}
local v3579=0
for v3924,v3925 in ipairs(v3578) do if ( #v3041>=8) then break
    end if (v3579>=v3577.count) then break
end table.insert(v3041,v3925)
v3579=v3579 + 1
end end if ( #v3041<8) then for v4154,v4155 in ipairs(v1335.slots) do local v4156=v3037[v4155.petType] or {}
for v4263,v4264 in ipairs(v4156) do if ( #v3041>=8) then break
    end local v4265=false
for v4363,v4364 in ipairs(v3041) do if (v4364==v4264) then v4265=true
        break
    end end if not v4265 then table.insert(v3041,v4264)
end end end end return v3041
end end return (v33.petTeams[v276] and v33.petTeams[v276].uuids) or {}
end local function v40(v277,v278,v279,v280,v281,v282) for v1336,v1337 in ipairs(v277:GetChildren()) do if v1337:IsA("GuiObject") then v1337:Destroy()
    end end local v283={}
if _G._NH_BUILTIN_TEAMS then for v3042,v3043 in ipairs(_G._NH_BUILTIN_TEAMS) do table.insert(v283,v3043.name)
end end for v1338 in pairs(v281.petTeams) do table.insert(v283,v1338)
end table.sort(v283)
if ( #v283==0) then local v2374=v280:label(v277," (save a team first)",UDim2.new(1,0,0,22),nil,v282.DIM,9)
v2374.LayoutOrder=1
return 1
end for v1339,v1340 in ipairs(v283) do local v1341=v279==v1340
local v1342=false
if _G._NH_BUILTIN_TEAMS then for v3580,v3581 in ipairs(_G._NH_BUILTIN_TEAMS) do if (v3581.name==v1340) then v1342=true
            break
        end end end local v1343=(v1342 and Color3.fromRGB(40,20,80)) or Color3.fromRGB(14,14,14)
local v1344=(v1342 and Color3.fromRGB(180,160,255)) or v282.TEXT
local v1345=(v1342 and Color3.fromRGB(80,60,160)) or v282.STROKE
if v1341 then v1343=(v1342 and Color3.fromRGB(80,50,160)) or v282.SEL_BG
    v1344=v282.SEL_TXT
    v1345=(v1342 and Color3.fromRGB(160,120,255)) or v282.ACCENT
end local v1346=v280:button(v277,v1340,UDim2.new(1,0,0,22),nil,v1343,v1344,9)
v1346.LayoutOrder=v1339
v1346.TextXAlignment=Enum.TextXAlignment.Left
v280:pad(v1346,0,8,0,0)
v280:stroke(v1346,v1345,1)
if v1342 then local v3045=Instance.new("ImageLabel",v1346)
    v3045.Size=UDim2.new(0,16,0,16)
    v3045.Position=UDim2.new(1, -20,0.5, -8)
    v3045.BackgroundTransparency=1
    v3045.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
    v3045.ScaleType=Enum.ScaleType.Fit
    v3045.ZIndex=v1346.ZIndex + 1
end v1346.MouseButton1Click:Connect(function() v278(v1340)
end)
end return #v283
end local function v41() if ( not readfile or not isfile or not isfile(v22)) then return
end local v284,v285=pcall(function() return v3:JSONDecode(readfile(v22))
end)
if ( not v284 or not v285) then return
end if v285.petTeams then v33.petTeams=v285.petTeams
end if v285.elephant then for v3053,v3054 in pairs(v285.elephant) do v33.elephant[v3053]=v3054
end end if v285.targets then v33.targets=v285.targets
end if v285.pickplace then for v3056,v3057 in pairs(v285.pickplace) do v33.pickplace[v3056]=v3057
end end if (v33.pickplace.selUUIDs==nil) then v33.pickplace.selUUIDs={}
end if (v33.pickplace.modeB==nil) then v33.pickplace.modeB=false
end if v285.petboost then if v285.petboost.mode1 then if (type(v285.petboost.mode1.boostOptions)=="table") then v33.petboost.mode1.boostOptions=v285.petboost.mode1.boostOptions
    elseif v285.petboost.mode1.boostOption then v33.petboost.mode1.boostOptions={[v285.petboost.mode1.boostOption]=true}
    end if v285.petboost.mode1.selPets then v33.petboost.mode1.selPets=v285.petboost.mode1.selPets
end end if v285.petboost.mode2 then for v3926,v3927 in pairs(v285.petboost.mode2) do v33.petboost.mode2[v3926]=v3927
end end end if v285.toggles then for v3059,v3060 in pairs(v285.toggles) do v33.toggles[v3059]=v3060
end end if v285.misc then for v3062,v3063 in pairs(v285.misc) do v33.misc[v3062]=v3063
end end if v285.webhook then for v3065,v3066 in pairs(v285.webhook) do v33.webhook[v3065]=v3066
end end if (v33.webhook.continueSession==nil) then v33.webhook.continueSession=false
end if v285.leveling then for v3068,v3069 in pairs(v285.leveling) do v33.leveling[v3068]=v3069
end end if v285.autoHatch then for v3071,v3072 in pairs(v285.autoHatch) do v33.autoHatch[v3071]=v3072
end end if v285.autoTrade then for v3074,v3075 in pairs(v285.autoTrade) do v33.autoTrade[v3074]=v3075
end end if v285.autoNM then if not v33.autoNM then v33.autoNM={lvTeam=nil,hsTeam=nil,lvThresh=30,targets={}}
end for v3077,v3078 in pairs(v285.autoNM) do v33.autoNM[v3077]=v3078
end end if v285.autoEV then if not v33.autoEV then v33.autoEV={pvTeam=nil,lvTeam=nil,levelTo100=false,autoCleanseFirst=false,targets={}}
end for v3080,v3081 in pairs(v285.autoEV) do v33.autoEV[v3080]=v3081
end end if v285.autoAgeBreaker then if not v33.autoAgeBreaker then v33.autoAgeBreaker={targets={},tumbalKgMax=2,tumbalAgeMax=99,skipEnabled=false}
end local v2383=v285.autoAgeBreaker
if (type(v2383.targets)=="table") then v33.autoAgeBreaker.targets=v2383.targets
end if (v2383.tumbalKgMax~=nil) then v33.autoAgeBreaker.tumbalKgMax=v2383.tumbalKgMax
end if (v2383.tumbalAgeMax~=nil) then v33.autoAgeBreaker.tumbalAgeMax=v2383.tumbalAgeMax
end if (v2383.skipEnabled~=nil) then v33.autoAgeBreaker.skipEnabled=v2383.skipEnabled
end if (v2383.maxLevel~=nil) then v33.autoAgeBreaker.maxLevel=v2383.maxLevel
end if (v2383.autoStart~=nil) then v33.autoAgeBreaker.autoStart=v2383.autoStart
end end if (v33.autoAgeBreaker and (v33.autoAgeBreaker.skipEnabled==nil)) then v33.autoAgeBreaker.skipEnabled=false
end if (v33.autoAgeBreaker and (v33.autoAgeBreaker.maxLevel==nil)) then v33.autoAgeBreaker.maxLevel=125
end if (v33.autoAgeBreaker and (v33.autoAgeBreaker.autoStart==nil)) then v33.autoAgeBreaker.autoStart=false
end if v285.autoMutMachine then if not v33.autoMutMachine then v33.autoMutMachine={targets={},targetMut="Golden",cdTeam=nil,claimTeam=nil,lvTeam=nil,lvThresh=50}
end for v3083,v3084 in pairs(v285.autoMutMachine) do v33.autoMutMachine[v3083]=v3084
end end if v285.autoCollect then if (type(v285.autoCollect.selFruits)=="table") then v33.autoCollect.selFruits=v285.autoCollect.selFruits
end if (type(v285.autoCollect.selVariants)=="table") then v33.autoCollect.selVariants=v285.autoCollect.selVariants
end if (v285.autoCollect.interval~=nil) then v33.autoCollect.interval=v285.autoCollect.interval
end if (v285.autoCollect.sellAfter~=nil) then v33.autoCollect.sellAfter=v285.autoCollect.sellAfter
end if (v285.autoCollect.stopWhenFull~=nil) then v33.autoCollect.stopWhenFull=v285.autoCollect.stopWhenFull
end if (v285.autoCollect.maxInv~=nil) then v33.autoCollect.maxInv=v285.autoCollect.maxInv
end end v33.autoHatch.brontoEnabled=true
if (v33.elephant.levelTo100==nil) then v33.elephant.levelTo100=true
end if (v33.elephant.phase2Enabled==nil) then v33.elephant.phase2Enabled=false
end if (v33.elephant.phase2Threshold==nil) then v33.elephant.phase2Threshold=50
end if (v33.elephant.gardenSlots==nil) then v33.elephant.gardenSlots=1
end if (v33.elephant.gardenMode==nil) then v33.elephant.gardenMode="A"
end if (v33.elephant.useExtraPets==nil) then v33.elephant.useExtraPets=false
end if (v33.elephant.extraPets==nil) then v33.elephant.extraPets={}
end if (v33.elephant.useExtraElePets==nil) then v33.elephant.useExtraElePets=false
end if (v33.elephant.extraElePets==nil) then v33.elephant.extraElePets={}
end if ( not v33.petboost.mode1.boostOptions or not next(v33.petboost.mode1.boostOptions)) then v33.petboost.mode1.boostOptions={["Small Toy"]=true}
end if (v33.leveling.optThreshold==nil) then v33.leveling.optThreshold=50
end if (v33.leveling.optEnabled==nil) then v33.leveling.optEnabled=false
end if (type(v33.leveling.targets)~="table") then v33.leveling.targets={}
end if (v285.autoHatch and v285.autoHatch.specialBronto) then if not v33.autoHatch.specialBronto then v33.autoHatch.specialBronto={enabled=true,pets={}}
end if (v285.autoHatch.specialBronto.enabled~=nil) then v33.autoHatch.specialBronto.enabled=v285.autoHatch.specialBronto.enabled
end if (type(v285.autoHatch.specialBronto.pets)=="table") then v33.autoHatch.specialBronto.pets=v285.autoHatch.specialBronto.pets
end end local v287={eggName="Paradise Egg",eggCount=13,eggSpacing=7,teamCD=nil,teamKoi=nil,teamSeal=nil,teamBronto=nil,brontoEnabled=true,brontoThresh=4,sellPets={},sellThresh=0,favDelay=0.1,espEnabled=true,running=false,ahUnequipDelay=0.1,ahEquipDelay=0.15,autoSellWhenFull=false,petInvMax=200,postUnequipBuffer=0.5,koiSafeDelay=1,koiPostHatch=1.5,sealSafeDelay=1,sealPostSell=2}
for v1350,v1351 in pairs(v287) do if (v33.autoHatch[v1350]==nil) then v33.autoHatch[v1350]=v1351
end end end v41()
if v33.autoHatch.ahEquipDelay then v24.AH_EQUIP_DELAY=v33.autoHatch.ahEquipDelay
end if v33.autoHatch.ahUnequipDelay then v24.AH_UNEQUIP_DELAY=v33.autoHatch.ahUnequipDelay
end if v33.autoHatch.postUnequipBuffer then v24.AH_POST_UNEQUIP_BUFFER=v33.autoHatch.postUnequipBuffer
end if v33.autoHatch.koiSafeDelay then v24.AH_KOI_SAFE_DELAY=v33.autoHatch.koiSafeDelay
end if v33.autoHatch.koiPostHatch then v24.AH_KOI_POST_HATCH=v33.autoHatch.koiPostHatch
end if v33.autoHatch.sealSafeDelay then v24.AH_SEAL_SAFE_DELAY=v33.autoHatch.sealSafeDelay
end if v33.autoHatch.sealPostSell then v24.AH_SEAL_POST_SELL=v33.autoHatch.sealPostSell
end local v42="HydraX_Session.json"
local v43={startTime=0,cycleCount=0,totalHatched=0,eggBefore=0,eggCurrent=0,koiProc=0,sealProc=0,koiLastCycle=0,sealLastCycle=0,petTypes={},specials={huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}}
local v44={}
v44.save=function() if not writefile then return
    end pcall(function() writefile(v42,v3:JSONEncode({AH={startTime=v43.startTime,cycleCount=v43.cycleCount,totalHatched=v43.totalHatched,eggBefore=v43.eggBefore,eggCurrent=v43.eggCurrent,koiProc=v43.koiProc,sealProc=v43.sealProc,koiLastCycle=v43.koiLastCycle,sealLastCycle=v43.sealLastCycle,petTypes=v43.petTypes,specials=v43.specials},KG={startTime=0,doneCount=0,totalPets=0}}))
end)
end
v44.load=function() if ( not readfile or not isfile or not isfile(v42)) then return nil
end local v288,v289=pcall(function() return v3:JSONDecode(readfile(v42))
end)
if ( not v288 or not v289) then return nil
end return v289
end
v44.delete=function() if ( not isfile or not isfile(v42)) then return
end pcall(function() if delfile then delfile(v42)
end end)
end
local v48=v44.save
local v49=v44.load
local v50=v44.delete
if (type(v33.petboost.mode1.selPets)~="table") then v33.petboost.mode1.selPets={}
end local v51={}
v51.getInv=function() local v290=v10:GetData()
return (v290 and v290.PetsData and v290.PetsData.PetInventory.Data) or {}
end
v51.getKG=function(v291) for v1367,v1368 in ipairs({v8,v9}) do for v2400,v2401 in ipairs(v1368:GetChildren()) do if (v2401:IsA("Tool") and (v2401:GetAttribute(v20)==v291)) then local v3615=v2401:GetAttribute("KG")
            if v3615 then return v3615
            end local v3616=v2401.Name:match("%[(%d+%.?%d*)%s*KG%]")
        if v3616 then return tonumber(v3616)
        end end end end local v292=v51.getInv()
return (v292[v291] and (v292[v291].PetData.BaseWeight or 0)) or 0
end
v51.getAge=function(v293) local v294=v51.getInv()
return (v294[v293] and (v294[v293].PetData.Level or 0)) or 0
end
v51.getBase=function(v295) local v296=v51.getInv()
return (v296[v295] and (v296[v295].PetData.BaseWeight or 0)) or 0
end
v51.getPType=function(v297) local v298=v51.getInv()
return (v298[v297] and (v298[v297].PetType or "Unknown")) or "Unknown"
end
v51.isFav=function(v299) for v1369,v1370 in ipairs({v8,v9}) do for v2402,v2403 in ipairs(v1370:GetChildren()) do if (v2403:IsA("Tool") and (v2403:GetAttribute(v20)==v299)) then return v2403:GetAttribute(v21)==true
        end end end return false
end
v51.findPetTool=function(v300) for v1371,v1372 in ipairs({v8,v9}) do for v2404,v2405 in ipairs(v1372:GetChildren()) do if (v2405:IsA("Tool") and (v2405:GetAttribute(v20)==v300)) then return v2405
        end end end return nil
end
v51.getMutName=function(v301) local v302=v51.getInv()
local v303=v302[v301]
if ( not v303 or not v303.PetData) then return ""
end local v304=v303.PetData.MutationType or ""
if ((v304=="") or (v304=="m")) then return ""
end return v19[v304] or v304
end
local v60=v51.getInv
local v61=v51.getKG
local v62=v51.getAge
local v63=v51.getBase
local v64=v51.getPType
local v65=v51.isFav
local v66=v51.findPetTool
local v67=v51.getMutName
local function v68(v305) if not v305 then return nil
    end local v306=tostring(v305):match("%d+")
if not v306 then return nil
end local v307,v308=pcall(function() return v3:JSONDecode(game:HttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. v306 .. "&size=150x150&format=Png&isCircular=false" ))
end)
if (v307 and v308 and v308.data and v308.data[1] and v308.data[1].imageUrl) then return v308.data[1].imageUrl
end return nil
end local function v69(v309) local v310=v33.webhook.url
if ( not v310 or (v310=="")) then return
end if ( not string.match(v310,"^https://discord") and not string.match(v310,"^https://ptb.discord") and not string.match(v310,"^https://canary.discord")) then return
end task.spawn(function() local v1373,v1374=pcall(function() local v2406=v309 and v309[1] and v309[1].title and v309[1].title:find("Special Pet")
    local v2407=v3:JSONEncode({username=v7.Name,avatar_url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png",content=(v2406 and "@everyone") or nil ,embeds=v309})
    local v2408=(syn and syn.request) or (http and http.request) or request
    if v2408 then v2408({Url=v310,Method="POST",Headers={["Content-Type"]="application/json"},Body=v2407})
    else v3:PostAsync(v310,v2407,Enum.HttpContentType.ApplicationJson,false)
end end)
if not v1373 then warn("[VoidHub Webhook]",v1374)
end end)
end local v70={}
local function v71(v311,v312,v313,v314,v315,v316,v317,v318,v319) local v320=math.min((v313/v314) * 100 ,100)
local v321=math.floor(v320/10 )
local v322=string.rep("█",v321) .. string.rep("░",10 -v321 )
if v319 then if not v70[v319] then v70[v319]={times={},gains={}}
    end local v2409=v70[v319]
table.insert(v2409.times,v315)
table.insert(v2409.gains,v313-v312 )
if ( #v2409.times>5) then table.remove(v2409.times,1)
end if ( #v2409.gains>5) then table.remove(v2409.gains,1)
end end local v323,v324=v315,v313-v312
if (v319 and v70[v319]) then local v2410=v70[v319]
local v2411,v2412=0,0
for v3087,v3088 in ipairs(v2410.times) do v2411=v2411 + v3088
end for v3089,v3090 in ipairs(v2410.gains) do v2412=v2412 + v3090
end v323=v2411/ #v2410.times
v324=v2412/ #v2410.gains
end local v325=math.max(v314-v313 ,0)
local v326=((v324>0) and math.ceil(v325/v324 )) or 0
local v327=v326 * v323
local v328=((v326>0) and string.format("~%d cycle lagi (~%s)",v326,v14.fmtTime(v327))) or "Almost done!"
local function v329(v1375) local v1376=string.format("%.3f",v1375)
    v1376=v1376:gsub("%.?0+$","")
    return v1376
end v69({{title="🔄 Cycle Complete",color=5793266,description=string.format("**%s** | Queue `%d / %d`\n\n`%s` **%.1f%%**",v311,v317 or 0 ,v318 or 0 ,v322,v320),fields={{name="⚖️ Weight",value=string.format("%s → **%s** kg",v329(v312),v329(v313)),inline=true},{name="🎯 Target",value=string.format("%s kg",v329(v314)),inline=true},{name="🔁 Phase",value=v316 or "?" ,inline=true},{name="⏱️ Cycle",value=v14.fmtTime(v315),inline=true},{name="📈 Gain",value=string.format("+%s kg",v329(v313-v312 )),inline=true},{name="🔮 Est. Done",value=v328,inline=true}},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local function v72(v330,v331,v332,v333,v334,v335) local v336=math.min(math.floor(v331/1 ),5)
local v337=string.rep("⭐",v336) .. string.rep("✩",5 -v336 )
v69({{title="✅ Pet Finished!",color=5763719,description=string.format("**%s** has reached **Level 100**!\n%s",v330,v337),fields={{name="⚖️ Final Base",value=string.format("**%.3f** kg",v331),inline=true},{name="🎯 Queue",value=string.format("%d / %d done",v334 or 0 ,v335 or 0 ),inline=true},{name="🏁 Total Time",value=v14.fmtTime(v332),inline=false},{name="⚡ Phase 2 Time",value=v14.fmtTime(v333),inline=true},{name="🐢 Phase 1 Time",value=v14.fmtTime(v332-v333 ),inline=true}},footer={text="Hydra Hub 🐉 • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local function v73() v69({{title=" Hydra Hub — Connection Test",color=5793266,description="Webhook Connected!",fields={{name="✅ Status",value="Online",inline=true},{name="🕐 Time",value=os.date("%H:%M:%S"),inline=true},{name="👤 Player",value=v7.Name,inline=true}},footer={text=" Hydra Hub • vX"}}})
end local function v74(v338,v339,v340,v341,v342) local v343=v33.webhook.url
if ( not v343 or (v343=="")) then return
end local v344=""
if (v340>=9) then v344="Godly"
elseif (v340>=7) then v344="Titan"
elseif (v340>=5) then v344="Huge"
end local v345=v18[v338]
if not v345 then local v2413,v2414=pcall(function() return v3:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/PetAssetId.json"))
end)
if (v2413 and v2414) then v345=v2414[v338]
end end local v346=v68(v345)
v346=v346 or "https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"
local v347=v338
local v348=((v344~="") and v344) or "Normal"
local v349=5793266
if (v344=="Godly") then v349=16766720
elseif (v344=="Titan") then v349=12632256
elseif (v344=="Huge") then v349=5763719
end v69({{title="🐾 Special Pet Found — " .. v347 ,color=v349,fields={{name="🐾 Pet Info",value=">>> " .. v347 .. "\nWeight: " .. string.format("%.2f KG",v339) .. "\nBronto: " .. string.format("%.2f KG",v340) .. "\nAge: Age " .. tostring(v341 or 0 ) ,inline=false},{name="🥚 Egg Info",value=">>> Egg: " .. (v342 or "?") .. "\nTier: " .. v348 ,inline=false},{name="🔀 Info",value=">>> Player: ||" .. v7.Name .. "||" .. "\nTime: " .. os.date("%d/%m/%Y %H:%M:%S") ,inline=false}},thumbnail={url=v346},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") }}})
end local function v75(v350) if (v350>=9) then return "godly"
end if (v350>=7) then return "titan"
end if (v350>=5) then return "huge"
end return nil
end local function v76() local v351=v10:GetData()
if ( not v351 or not v351.PetsData) then return {}
end local v352={}
for v1377 in pairs(v351.PetsData.PetInventory.Data or {} ) do v352[v1377]=true
end return v352
end local function v77(v353) local v354=v10:GetData()
if ( not v354 or not v354.PetsData) then return {}
end local v355=v354.PetsData.PetInventory.Data or {}
local v356={}
for v1379,v1380 in pairs(v355) do if not v353[v1379] then table.insert(v356,{uuid=v1379,data=v1380})
    end end return v356
end local function v78(v357) for v1381,v1382 in ipairs(v357) do local v1383=v1382.data
    if ( not v1383 or not v1383.PetData) then continue
    end local v1384=v1383.PetType or "Unknown"
local v1385=v1383.PetData.BaseWeight or 0
v43.totalHatched=v43.totalHatched + 1
if not v43.petTypes[v1384] then v43.petTypes[v1384]={count=0,totalKG=0,minKG=math.huge,maxKG=0}
end local v1387=v43.petTypes[v1384]
v1387.count=v1387.count + 1
v1387.totalKG=v1387.totalKG + v1385
v1387.minKG=math.min(v1387.minKG,v1385)
v1387.maxKG=math.max(v1387.maxKG,v1385)
local v1392=v33.autoHatch.specialBronto
if (v1392 and v1392.enabled and v1392.pets[v1384]) then task.spawn(function() task.wait(1)
        local v3619=v66(v1382.uuid)
        if (v3619 and (v3619:GetAttribute(v21)~=true)) then pcall(function() FavRemote:FireServer(v3619)
            end)
        task.wait(0.3)
    end local v3620=(v1382.data.PetData and (v1382.data.PetData.Level or 0)) or 0
local v3621=v33.autoHatch.eggName or "?"
task.wait(1)
local v3622=v1385
local v3623=v66(v1382.uuid)
if v3623 then local v4161=v3623:GetAttribute("KG")
    if v4161 then v3622=v4161
    else local v4366=v3623.Name:match("%[(%d+%.?%d*)%s*KG%]")
    if v4366 then v3622=tonumber(v4366) or v1385
    end end end v74(v1384,v1385,v3622,v3620,v3621)
end)
end local v1393=v75(v1385)
if v1393 then local v3092=v43.specials[v1393]
v3092.count=v3092.count + 1
table.insert(v3092.pets,string.format("%s (%.2fkg)",v1384,v1385))
end local v1394=v33.autoHatch.brontoThresh or 4
if (v1385>=v1394) then local v3094=(v1382.data.PetData and (v1382.data.PetData.Level or 0)) or 0
local v3095=v33.autoHatch.eggName or "?"
task.spawn(function() task.wait(2)
    local v3624=v1385
    local v3625=v66(v1382.uuid)
    if v3625 then local v4162=v3625:GetAttribute("KG")
        if v4162 then v3624=v4162
        else local v4367=v3625.Name:match("%[(%d+%.?%d*)%s*KG%]")
        if v4367 then v3624=tonumber(v4367) or v1385
        end end end v74(v1384,v1385,v3624,v3094,v3095)
end)
end end end local function v79(v358) if not v358 then return "None"
end local v359=v39(v358)
if ( #v359==0) then return "None"
end local v360=v60()
local v361={}
for v1395,v1396 in ipairs(v359) do local v1397=v360[v1396]
    if not v1397 then continue
    end local v1398=v1397.PetType or "?"
local v1399=(v1397.PetData and (v1397.PetData.MutationType or "")) or ""
local v1400=((v1399~="") and (v1399~="m") and (v19[v1399] or v1399)) or ""
local v1401=((v1400~="") and (v1400 .. " " .. v1398)) or v1398
v361[v1401]=(v361[v1401] or 0) + 1
end local v362={}
for v1403,v1404 in pairs(v361) do table.insert(v362,v1404 .. " " .. v1403 )
end table.sort(v362)
return table.concat(v362,", ")
end local function v80() local v363=os.time() -v43.startTime
local v364=v363/math.max(v43.cycleCount,1)
local v365=v43.eggCurrent-v43.eggBefore
local v366=((v365>=0) and ("+" .. v365)) or tostring(v365)
local v367=((v43.cycleCount>0) and (v43.totalHatched/v43.cycleCount)) or 0
local v368=((v367>0) and string.format("%.2f%%",(v43.koiLastCycle/v367) * 100 )) or "0.00%"
local v369=((v367>0) and string.format("%.2f%%",(v43.sealLastCycle/v367) * 100 )) or "0.00%"
local v370={}
local v371={}
for v1405,v1406 in pairs(v43.petTypes) do table.insert(v371,{name=v1405,data=v1406})
end table.sort(v371,function(v1407,v1408) return v1407.data.count>v1408.data.count
end)
for v1409,v1410 in ipairs(v371) do local v1411=v1410.data
table.insert(v370,string.format("• %s x%d (%.2f-%.2fkg)",v1410.name,v1411.count,v1411.minKG,v1411.maxKG))
end v69({{title="🥚 Hatch Cycle #" .. v43.cycleCount ,color=15121980,fields={{name="👤 Profile",value="**Username:** ||" .. v7.Name .. "||" ,inline=false},{name="🐾 Teams",value=table.concat({string.format("**Core:** %s",v79(v33.autoHatch.teamCD)),string.format("**Hatch:** %s",v79(v33.autoHatch.teamKoi)),string.format("**Special:** %s",v79(v33.autoHatch.teamBronto)),string.format("**Sell:** %s",v79(v33.autoHatch.teamSeal))},"\n"),inline=false},{name="⚜️ Special Statistics",value=table.concat({string.format("⭐ Special: %d",v43.specials.huge.count + v43.specials.titan.count + v43.specials.godly.count ),((v43.specials.godly.count>0) and string.format(" Godly x%d",v43.specials.godly.count)) or "💛 Godly" ,((v43.specials.titan.count>0) and string.format(" Titan x%d",v43.specials.titan.count)) or "🥈 Titan" ,((v43.specials.huge.count>0) and string.format(" Huge x%d",v43.specials.huge.count)) or "🌟 Huge" },"\n"),inline=false},{name="💎 Overall Statistics",value=(( #v370>0) and table.concat(v370,"\n")) or "No pets hatched" ,inline=false},{name="🥚 Egg Statistics",value=table.concat({string.format("🥚 Egg Before: %d",v43.eggBefore),string.format("📦 Current Egg: %d",v43.eggCurrent),string.format("📊 Net Result: %s",v366),string.format(""),string.format("🍀 Koi Cashback: %d (%s)",v43.koiLastCycle,v368),string.format("🤝 Seal Cashback: %d (%s)",v43.sealLastCycle,v369),string.format("✨ Total Cashback: %d",v43.koiLastCycle + v43.sealLastCycle )},"\n"),inline=false},{name="📈 Hatch Statistics",value=table.concat({string.format("🔄 Hatch Cycles: %d",v43.cycleCount),string.format("🐾 Total Hatched: %d",v43.totalHatched),string.format("🪺 Overall Pet Sell: %d",v43.totalHatched-(v43.koiProc + v43.sealProc) ),string.format(""),string.format("⏱️ Cycle Duration: %s",v14.fmtTime(math.floor(v364))),string.format("🕐 All Time Duration: %s",v14.fmtTime(math.floor(v363)))},"\n"),inline=false}},footer={text="Hydra Hub • " .. os.date("%d/%m/%Y %H:%M:%S") },thumbnail={url="https://raw.githubusercontent.com/Punpunzero02/updater/main/HydraX.png"}}})
end local v81=nil
local function v82() if not v81 then local v2415,v2416=pcall(function() local v3096=require(v2.Modules.ReplicationClass).new("ActivePetsService_Replicator")
        v3096:YieldUntilData()
        return v3096
    end)
if v2415 then v81=v2416
end end return v81
end local function v83() local v372=v82()
if not v372 then return {}
end local v373,v374=pcall(function() return v372:YieldUntilData().Table
end)
if ( not v373 or not v374) then return {}
end local v375=v374.ActivePetStates
local v376=v375[v7.Name] or v375[tonumber(v7.Name)] or {}
local v377={}
for v1412 in pairs(v376) do table.insert(v377,v1412)
end return v377
end local v84={IsEquipping=false,PP_Processing={},GlobalBoostApplying=false}
local v85={}
v85.unequipAll=function() v84.IsEquipping=true
    for v1413,v1414 in ipairs(v83()) do pcall(function() v12:FireServer("UnequipPet",v1414)
        end)
    task.wait(v24.UNEQUIP_DELAY)
end task.wait(v24.UNEQUIP_BUFFER)
v84.IsEquipping=false
end
v85.getFarmCF=function() local v379=workspace:FindFirstChild("Farm")
if v379 then local v2417=v379:FindFirstChild(v7.Name)
    if v2417 then local v3626=v2417:FindFirstChild("Important")
        if v3626 then local v4163=v3626:FindFirstChild("Plant_Locations")
            if v4163 then local v4368=v4163:GetChildren()
                if ( #v4368>0) then return v4368[1]:GetPivot()
                end end end end end end
v85.equipList=function(v380) v84.IsEquipping=true
local v382=v85.getFarmCF()
for v1415,v1416 in ipairs(v380) do pcall(function() v12:FireServer("EquipPet",v1416,v382)
    end)
task.wait(v24.EQUIP_DELAY)
end v84.IsEquipping=false
end
v85.waitUntilEquipped=function(v383,v384) v384=v384 or 8
local v385=os.clock()
while (os.clock() -v385)=8) then break
end if (v1421~=v386) then table.insert(v388,v1421)
end end return v388
end
local v91,v92,v93,v94,v95=v85.unequipAll,v85.getFarmCF,v85.equipList,v85.waitUntilEquipped,v85.buildEquip
local v96=false
local v97=nil
local v98={}
local v99={}
local function v100() v96=true
    task.spawn(function() while v96 do task.wait(v30.TEAM_CHECK)
            if (v84.IsEquipping or not v25) then continue
            end if not next(v99) then continue
        end local v2423=v83()
    local v2424,v2425={},{}
    for v3097 in pairs(v99) do local v3098=false
        for v3627,v3628 in ipairs(v2423) do if (v3628==v3097) then v3098=true
                break
            end end if not v3098 then table.insert(v2424,v3097)
    end end for v3099,v3100 in ipairs(v2423) do if not v99[v3100] then table.insert(v2425,v3100)
end end if (( #v2425>0) or ( #v2424>0)) then v84.IsEquipping=true
for v3929,v3930 in ipairs(v2425) do pcall(function() v12:FireServer("UnequipPet",v3930)
end)
task.wait(v24.UNEQUIP_DELAY)
end local v3630=v92()
for v3931,v3932 in ipairs(v2424) do pcall(function() v12:FireServer("EquipPet",v3932,v3630)
end)
task.wait(v24.EQUIP_DELAY)
end v84.IsEquipping=false
end end end)
end local function v101() v96=false
table.clear(v99)
v98={}
v97=nil
end local function v102(v389,v390) table.clear(v99)
for v1422,v1423 in ipairs(v389) do v99[v1423]=true
end for v1425,v1426 in ipairs(v390) do v99[v1426]=true
end end local function v103(v391,v392) local v393=v60()
local v394={}
local v395=0
for v1428 in pairs(v33.elephant.extraPets) do v395=v395 + 1
end print("[FILLER DEBUG] extraPets count:",v395,"maxCount:",v392)
for v1429 in pairs(v33.elephant.extraPets) do local v1430=v393[v1429]~=nil
local v1431=v391[v1429]~=nil
print("[FILLER DEBUG] uuid:",v1429,"inInv:",v1430,"excluded:",v1431)
if ( not v1431 and v1430) then table.insert(v394,v1429)
end end table.sort(v394,function(v1432,v1433) return v61(v1432)>v61(v1433)
end)
print("[FILLER DEBUG] candidates after filter:", #v394)
local v396={}
for v1434=1,math.min(v392, #v394) do table.insert(v396,v394[v1434])
end print("[FILLER DEBUG] returning:", #v396,"fillers")
return v396
end local function v104(v397,v398) local v399=v60()
local v400={}
for v1435 in pairs(v33.elephant.extraElePets) do if ( not v397[v1435] and v399[v1435]) then table.insert(v400,v1435)
    end end table.sort(v400,function(v1436,v1437) return v61(v1436)>v61(v1437)
end)
local v401={}
for v1438=1,math.min(v398, #v400) do table.insert(v401,v400[v1438])
end return v401
end local v105=require(v2.Data.PetRegistry.PetBoostRegistry)
local function v106(v402,v403,v404) local v405,v406=pcall(function() return v10:GetData()
end)
if ( not v405 or not v406) then return false
end local v407=v406.PetsData and v406.PetsData.PetInventory and v406.PetsData.PetInventory.Data
if ( not v407 or not v407[v402]) then return false
end local v408=v407[v402].PetData and v407[v402].PetData.Boosts
if ( not v408 or not next(v408)) then return false
end local v409={}
for v1439,v1440 in pairs(v408) do local v1441=v1440.BoostType or v1440.Type
local v1442=v1440.BoostAmount or v1440.Amount
local v1443=v105.BoostTypeStatData and v105.BoostTypeStatData[v1441]
if (v1443 and v1443.Amount) then local v3101=v105.BoostTypeToPetModelName[v1441]
    for v3631,v3632 in pairs(v1443.Amount) do if (v3632==v1442) then v409[v3631 .. " " .. v3101 ]=true
        end end end end return v409[v403 .. " " .. v404 ]==true
end local function v107(v410,v411) for v1444,v1445 in ipairs(v8:GetChildren()) do if (v1445:IsA("Tool") and v5:HasTag(v1445,"PetBoost") and string.find(v1445.Name,v410) and string.find(v1445.Name,v411)) then return v1445
    end end return nil
end local function v108(v412,v413,v414) if v84.GlobalBoostApplying then return false
end if v106(v412,v413,v414) then return false
end local v415=v107(v413,v414)
if not v415 then return false
end v84.GlobalBoostApplying=true
for v1446,v1447 in ipairs(v9:GetChildren()) do if v1447:IsA("Tool") then v1447.Parent=v8
end end task.wait(v30.UNEQUIP_WAIT)
pcall(function() v415.Parent=v9
end)
task.wait(v30.EQUIP_WAIT)
pcall(function() v13:FireServer("ApplyBoost",v412)
end)
task.wait(v30.FIRE_WAIT)
pcall(function() local v1449=v9:FindFirstChildWhichIsA("Tool")
    if (v1449 and v5:HasTag(v1449,"PetBoost")) then v1449.Parent=v8
    end end)
task.wait(0.5)
local v417=v106(v412,v413,v414)
v84.GlobalBoostApplying=false
return v417
end pcall(function() v4:FindFirstChild("HydraHubUI"):Destroy()
end)
local v109=Instance.new("ScreenGui")
v109.Name="HydraHubUI"
v109.ResetOnSpawn=false
v109.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
v109.IgnoreGuiInset=true
v109.Parent=v4
local v116=workspace.CurrentCamera.ViewportSize
local v117=game:GetService("UserInputService")
local v118=v117.TouchEnabled and not v117.KeyboardEnabled
local v119,v120=420,320
local v121=1
if v118 then local v1450=v116.X/420
    v121=math.clamp(v1450 * 0.72 ,0.65,1.4)
end local v122=v16:frame(v109,UDim2.new(0,v119,0,v120),UDim2.new(0.5, -math.floor(v119/2 ),0.5, -math.floor(v120/2 )),v15.BG)
v122.Active=true
v16:corner(v122,8)
v16:stroke(v122,v15.ACCENT,1)
if (v118 and (v121~=1)) then local v1451=Instance.new("UIScale",v122)
    v1451.Scale=v121
end local v124=v16:frame(v122,UDim2.new(1,0,0,30),nil,v15.PANEL)
v16:corner(v124,8)
v16:stroke(v124,v15.STROKE,1)
local v125=Instance.new("ImageLabel",v124)
v125.Size=UDim2.new(0,16,0,16)
v125.Position=UDim2.new(0,6,0.5, -8)
v125.BackgroundTransparency=1
v125.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
v125.ScaleType=Enum.ScaleType.Fit
v16:label(v124,"|",UDim2.new(0,8,1,0),UDim2.new(0,24,0,0),v15.DIM,13,Enum.TextXAlignment.Center)
v16:label(v124,"HYDRA HUB",UDim2.new(1, -80,1,0),UDim2.new(0,34,0,0),v15.TEXT,12)
local v132=v16:button(v124,"X",UDim2.new(0,24,0,22),UDim2.new(1, -28,0.5, -11),v15.ERROR,v15.TEXT,10)
v16:stroke(v132,v15.ERROR,1)
local v133=v16:button(v124,"-",UDim2.new(0,24,0,22),UDim2.new(1, -56,0.5, -11),v15.BTN,v15.TEXT,16)
v16:stroke(v133,v15.STROKE,1)
v132.MouseButton1Click:Connect(function() v25=false
    v109:Destroy()
end)
do local v418,v419,v420,v421=false,nil,nil,nil
v124.InputBegan:Connect(function(v1453) if ((v1453.UserInputType==Enum.UserInputType.MouseButton1) or (v1453.UserInputType==Enum.UserInputType.Touch)) then v418=true
        v419=v1453
        v420=v1453.Position
        v421=v122.Position
        v1453.Changed:Connect(function() if (v1453.UserInputState==Enum.UserInputState.End) then v418=false
            end end)
end end)
v124.InputChanged:Connect(function(v1454) if ((v1454.UserInputType==Enum.UserInputType.MouseMovement) or (v1454.UserInputType==Enum.UserInputType.Touch)) then v419=v1454
end end)
v6.InputChanged:Connect(function(v1455) if ( not v418 or (v1455~=v419)) then return
end local v1456=v1455.Position-v420
v122.Position=UDim2.new(v421.X.Scale,v421.X.Offset + v1456.X ,v421.Y.Scale,v421.Y.Offset + v1456.Y )
end)
end local v134=v16:frame(v122,UDim2.new(1,0,0,28),UDim2.new(0,0,0,30),v15.PANEL)
v16:stroke(v134,v15.STROKE,1)
local v135={"MAIN","AUTOMATION","COMING SOON","COMING SOON"}
local v136={}
local v137={}
local v138=v16:frame(v122,UDim2.new(1,0,1, -58),UDim2.new(0,0,0,58),v15.BG,1)
for v422=1,4 do local v423=v16:frame(v138,UDim2.new(1,0,1,0),nil,v15.BG,1)
    v423.Visible=v422==1
    v137[v422]=v423
end local v139=math.floor(420/4 )
for v426,v427 in ipairs(v135) do local v428=v16:button(v134,v427,UDim2.new(0,v139-2 ,0,22),UDim2.new(0,((v426-1) * v139) + 1 ,0.5, -11),((v426==1) and Color3.fromRGB(20,20,20)) or v15.BTN ,((v426==1) and v15.ACCENT) or v15.DIM ,8)
v16:stroke(v428,v15.STROKE,1)
v136[v426]=v428
v428.MouseButton1Click:Connect(function() for v2426,v2427 in ipairs(v137) do v2427.Visible=v2426==v426
        v136[v2426].BackgroundColor3=((v2426==v426) and Color3.fromRGB(20,20,20)) or v15.BTN
        v136[v2426].TextColor3=((v2426==v426) and v15.ACCENT) or v15.DIM
    end end)
end for v430,v431 in ipairs({3,4}) do v16:label(v137[v431],"🔒 COMING SOON",UDim2.new(1,0,0,20),UDim2.new(0,0,0.5, -10),v15.DIM,13,Enum.TextXAlignment.Center)
end local function v140() local v432=v137[2]
local v433=v16:frame(v432,UDim2.new(0,52,1,0),nil,v15.SIDEBAR)
v16:stroke(v433,Color3.fromRGB(18,18,18),1)
local v434=v16:sidebar(v433)
local v435=v16:iconBtn(v434,"🍎","FRUIT")
v16:sidebarDivider(v434)
local v436=v16:iconBtn(v434,"🛒","SHOP")
v16:sidebarDivider(v434)
local v437=v16:iconBtn(v434,"🎟️","TRADE")
local v438=v16:frame(v432,UDim2.new(1, -56,1, -2),UDim2.new(0,54,0,1),v15.BG,1)
local v439=v16:frame(v438,UDim2.new(1,0,1,0),nil,v15.BG,1)
v439.Visible=true
do local v1458=v16:scroll(v439,UDim2.new(1,0,1,0))
    v1458.ScrollingDirection=Enum.ScrollingDirection.Y
    v1458.AutomaticCanvasSize=Enum.AutomaticSize.Y
    v1458.ScrollBarThickness=3
    v1458.ScrollBarImageColor3=v15.ACCENT
    local v1466=Instance.new("Frame",v1458)
    v1466.Size=UDim2.new(1,0,0,0)
    v1466.BackgroundTransparency=1
    v1466.AutomaticSize=Enum.AutomaticSize.Y
    v16:list(v1466,6)
    v16:pad(v1466,6,6,6,20)
    local v1470=false
    local v1471=v33.autoCollect.selFruits
    local v1472=v33.autoCollect.selVariants
    local v1473=v33.autoCollect.sellAfter
    local v1474=v33.autoCollect.interval
    local v1475={"Normal","Gold","Rainbow","Silver","Diamond","Jelly"}
    local v1476={SellInv=v2:WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"),Teleport=v2:WaitForChild("GameEvents"):WaitForChild("PlayerTeleportTriggered"),_collect=nil}
    local v1477=v1476.SellInv
    local v1478=v1476.Teleport
    local v1479=game:GetService("CollectionService")
    local function v1480() if v1476._collect then return v1476._collect
        end local v2431,v2432=pcall(function() return v2:WaitForChild("GameEvents"):WaitForChild("Crops"):WaitForChild("Collect",5)
    end)
if (v2431 and v2432) then v1476._collect=v2432
end return v1476._collect
end local function v1481() local v2433=workspace:FindFirstChild("Farm")
if not v2433 then return nil
end for v3106,v3107 in ipairs(v2433:GetChildren()) do local v3108=v3107:FindFirstChild("Important")
if v3108 then local v3933=v3108:FindFirstChild("Data")
    if v3933 then local v4266=v3933:FindFirstChild("Owner")
        if (v4266 and (v4266.Value==v7.Name)) then return v3107
        end end end end return nil
end local function v1482(v2434) local v2435=v2434:GetAttribute("DoneGrowTime")
if not v2435 then return false
end if (workspace:GetServerTimeNow()0) and not v1471[v2436]) then return false
end local v2438=0
for v3110 in pairs(v1472) do v2438=v2438 + 1
end if (v2438>0) then local v3634=v2434:FindFirstChild("Variant")
local v3635=(v3634 and tostring(v3634.Value)) or "Normal"
if not v1472[v3635] then return false
end end return true
end local function v1483() local v2439=v7.Character
if not v2439 then return
end local v2440,v2441=pcall(function() return workspace.Tutorial_Points.Tutorial_Point_2.CFrame
end)
if ( not v2440 or not v2441) then return
end v2439:PivotTo(v2441)
task.wait(0.1)
pcall(function() v1478:FireServer("Sell Shop")
end)
task.wait(1)
pcall(function() v1477:FireServer()
end)
task.wait(0.5)
end local function v1484() while v1473 do task.wait(3)
    local v3111=v10:GetData()
    local v3112=0
    if (v3111 and v3111.InventoryData) then for v4165,v4166 in pairs(v3111.InventoryData) do if (v4166.ItemType=="Holdable") then v3112=v3112 + 1
            end end end if (v3112>=200) then v1483()
end end end local v1485=v33.autoCollect.stopWhenFull
local v1486=v33.autoCollect.maxInv
local function v1487() local v2442=v10:GetData()
    if ( not v2442 or not v2442.InventoryData) then return 0
    end local v2443=0
for v3113,v3114 in pairs(v2442.InventoryData) do if (v3114.ItemType=="Holdable") then v2443=v2443 + 1
    end end return v2443
end local function v1488() while v1470 do if (v1485 and (v1487()>=v1486)) then task.wait(1)
        continue
    end local v3115=v1481()
if v3115 then local v3934={}
    local v3935={}
    for v4167,v4168 in ipairs(v3115:GetDescendants()) do if (v1479:HasTag(v4168,"Harvestable") and v1482(v4168) and not v3935[v4168]) then v3935[v4168]=true
            table.insert(v3934,v4168)
        end end for v4169,v4170 in ipairs(v3934) do if not v1470 then break
    end if (v1485 and (v1487()>=v1486)) then break
end local v4171=v1480()
if v4171 then pcall(function() v4171:FireServer({v4170})
end)
end if (v1474>0) then task.wait(v1474)
end end end task.wait(((v1474>0) and v1474) or 0.1 )
end end local v1489=v16:accordion(v1466,"🍎 AUTO COLLECT",1,true)
local v1490=v1489.Inner
local v1491=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1491.LayoutOrder=0
v16:corner(v1491,5)
v16:stroke(v1491,v15.STROKE,1)
v16:label(v1491,"Interval (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v1495=v16:input(v1491,v1474,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v1495.FocusLost:Connect(function() local v2444=tonumber(v1495.Text)
    if (v2444 and (v2444>=0)) then v1474=v2444
        v33.autoCollect.interval=v2444
        v37()
    else v1495.Text=tostring(v1474)
end end)
local v1496=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1496.LayoutOrder=1
v16:corner(v1496,5)
v16:stroke(v1496,v15.STROKE,1)
local v1498=v16:label(v1496,"Fruit: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),v15.DIM,9)
v1498.Font=Enum.Font.Gotham
local v1500=v16:button(v1496,"Select >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9)
v16:stroke(v1500,v15.STROKE,1)
local function v1501() local v2445=0
    for v3116 in pairs(v1471) do v2445=v2445 + 1
    end if (v2445==0) then v1498.Text="Fruit: ALL"
    v1498.TextColor3=v15.DIM
else v1498.Text="Fruit: " .. v2445 .. " selected"
v1498.TextColor3=v15.ACCENT
end end v1501()
local v1502=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1502.LayoutOrder=2
v16:corner(v1502,5)
v16:stroke(v1502,v15.STROKE,1)
local v1504=v16:label(v1502,"Variant: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),v15.DIM,9)
v1504.Font=Enum.Font.Gotham
local v1506=v16:button(v1502,"Select >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9)
v16:stroke(v1506,v15.STROKE,1)
local function v1507() local v2446=0
    for v3117 in pairs(v1472) do v2446=v2446 + 1
    end if (v2446==0) then v1504.Text="Variant: ALL"
    v1504.TextColor3=v15.DIM
else v1504.Text="Variant: " .. v2446 .. " selected"
v1504.TextColor3=v15.ACCENT
end end v1507()
local v1508=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1508.LayoutOrder=25
v16:corner(v1508,5)
v16:stroke(v1508,v15.STROKE,1)
v16:label(v1508,"Stop Collect When Full",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v1512=v16:input(v1508,v1486,"",UDim2.new(0,40,0,20),UDim2.new(1, -94,0.5, -10))
v1512.FocusLost:Connect(function() local v2447=tonumber(v1512.Text)
    if (v2447 and (v2447>=1)) then v1486=v2447
        v33.autoCollect.maxInv=v2447
        v37()
    else v1512.Text=tostring(v1486)
end end)
v16:toggle(v1508,UDim2.new(1, -52,0.5, -11),v33.autoCollect.stopWhenFull,function(v2448) v1485=v2448
v33.autoCollect.stopWhenFull=v2448
v37()
end)
local v1513=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1513.LayoutOrder=3
v16:corner(v1513,5)
v16:stroke(v1513,v15.STROKE,1)
v16:label(v1513,"Auto Sell All (Inventory Full)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
v16:toggle(v1513,UDim2.new(1, -52,0.5, -11),v1473,function(v2450) v1473=v2450
    v33.autoCollect.sellAfter=v2450
    v37()
    if v2450 then task.spawn(v1484)
    end end)
local v1516=v16:frame(v1490,UDim2.new(1,0,0,26),nil,v15.BTN)
v1516.LayoutOrder=5
v16:corner(v1516,5)
v16:stroke(v1516,v15.STROKE,1)
v16:label(v1516,"AUTO COLLECT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v1519=v16:label(v1516,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),v15.DIM,8)
v1519.Font=Enum.Font.Gotham
v16:toggle(v1516,UDim2.new(1, -52,0.5, -11),v33.toggles.autoCollect,function(v2452) v1470=v2452
    v33.toggles.autoCollect=v2452
    v37()
    v1519.Text=(v2452 and "● ON") or "● IDLE"
    v1519.TextColor3=(v2452 and v15.SUCCESS) or v15.DIM
    if v2452 then task.spawn(v1488)
    end end)
if v33.toggles.autoCollect then v1470=true
task.defer(function() task.spawn(v1488)
end)
end local v1521=v16:frame(v439,UDim2.new(1,0,1,0),nil,v15.BG)
v1521.Visible=false
v1521.ZIndex=25
local v1524=v16:frame(v1521,UDim2.new(1,0,0,26),nil,v15.PANEL)
v16:stroke(v1524,v15.STROKE,1)
v16:label(v1524,"Select Fruits to Collect",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10)
local v1525=v16:button(v1524,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8)
v16:stroke(v1525,v15.STROKE,1)
local v1526=v16:button(v1524,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10)
v16:stroke(v1526,v15.ERROR,1)
v1526.MouseButton1Click:Connect(function() v1521.Visible=false
    v1501()
end)
local v1527=v16:input(v1521,"","Search fruit...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1527.TextColor3=v15.TEXT
v1527.Font=Enum.Font.Gotham
local v1531=v16:scroll(v1521,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
v16:list(v1531,3)
v16:pad(v1531,3,4,4,3)
local v1532={}
do local v2457={}
    local v2458,v2459=pcall(function() return game:HttpGet("https://raw.githubusercontent.com/Punpunzero02/updater/refs/heads/main/fruits.json")
    end)
if (v2458 and v2459) then local v3652,v3653=pcall(function() return v3:JSONDecode(v2459)
    end)
if (v3652 and v3653) then for v4267,v4268 in ipairs(v3653) do if not v2457[v4268] then v2457[v4268]=true
            table.insert(v1532,v4268)
        end end end end end table.sort(v1532)
local function v1533() for v3118,v3119 in ipairs(v1531:GetChildren()) do if v3119:IsA("GuiObject") then v3119:Destroy()
end end local v2460=string.lower(v1527.Text)
local v2461={}
for v3120,v3121 in ipairs(v1532) do if ((v2460=="") or v3121:lower():find(v2460,1,true)) then table.insert(v2461,v3121)
    end end local v2462= #v2461>0
for v3122,v3123 in ipairs(v2461) do if not v1471[v3123] then v2462=false
    break
end end v1525.Text=(( #v2461==0) and "Select All") or (v2462 and "Unselect All") or "Select All"
v1525.TextColor3=(v2462 and v15.SEL_TXT) or v15.ACCENT
v1525.BackgroundColor3=(v2462 and v15.SEL_BG) or v15.BTN
for v3124,v3125 in ipairs(v2461) do local v3126=v1471[v3125]==true
    local v3127=v16:button(v1531,v3125,UDim2.new(1,0,0,24),nil,(v3126 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3126 and v15.SEL_TXT) or v15.TEXT ,9)
    v3127.LayoutOrder=v3124
    v3127.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v3127,0,8,4,0)
    v16:corner(v3127,4)
    v16:stroke(v3127,(v3126 and v15.ACCENT) or v15.STROKE ,1)
    v3127.MouseButton1Click:Connect(function() if v1471[v3125] then v1471[v3125]=nil
        else v1471[v3125]=true
    end v33.autoCollect.selFruits=v1471
v37()
v1501()
v16:updateRowVisual(v3127,v1471[v3125]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE)
end)
end end v1525.MouseButton1Click:Connect(function() local v2466=string.lower(v1527.Text)
local v2467={}
for v3131,v3132 in ipairs(v1532) do if ((v2466=="") or v3132:lower():find(v2466,1,true)) then table.insert(v2467,v3132)
    end end local v2468= #v2467>0
for v3133,v3134 in ipairs(v2467) do if not v1471[v3134] then v2468=false
    break
end end if v2468 then for v3936,v3937 in ipairs(v2467) do v1471[v3937]=nil
end else for v3939,v3940 in ipairs(v2467) do v1471[v3940]=true
end end v33.autoCollect.selFruits=v1471
v37()
v1501()
v1533()
end)
v1527:GetPropertyChangedSignal("Text"):Connect(v1533)
v1500.MouseButton1Click:Connect(function() v1521.Visible=true
    v1533()
end)
local v1534=v16:frame(v439,UDim2.new(1,0,1,0),nil,v15.BG)
v1534.Visible=false
v1534.ZIndex=25
local v1537=v16:frame(v1534,UDim2.new(1,0,0,26),nil,v15.PANEL)
v16:stroke(v1537,v15.STROKE,1)
v16:label(v1537,"Select Variants to Collect",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10)
local v1538=v16:button(v1537,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10)
v16:stroke(v1538,v15.ERROR,1)
v1538.MouseButton1Click:Connect(function() v1534.Visible=false
    v1507()
end)
local v1539=v16:scroll(v1534,UDim2.new(1,0,1, -32),UDim2.new(0,0,0,32))
v16:list(v1539,4)
v16:pad(v1539,4,4,4,4)
local function v1540() for v3135,v3136 in ipairs(v1539:GetChildren()) do if v3136:IsA("GuiObject") then v3136:Destroy()
        end end for v3137,v3138 in ipairs(v1475) do local v3139=v1472[v3138]==true
    local v3140=v16:button(v1539,v3138,UDim2.new(1,0,0,28),nil,(v3139 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3139 and v15.SEL_TXT) or v15.TEXT ,10)
    v3140.LayoutOrder=v3137
    v3140.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v3140,0,8,0,0)
    v16:corner(v3140,5)
    v16:stroke(v3140,(v3139 and v15.ACCENT) or v15.STROKE ,1)
    v3140.MouseButton1Click:Connect(function() if v1472[v3138] then v1472[v3138]=nil
        else v1472[v3138]=true
    end v33.autoCollect.selVariants=v1472
v37()
v1507()
v16:updateRowVisual(v3140,v1472[v3138]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE)
end)
end end v1506.MouseButton1Click:Connect(function() v1534.Visible=true
v1540()
end)
local v1541=false
local v1542=1
local v1543=v2:WaitForChild("GameEvents"):WaitForChild("Plant_RE")
local function v1544() for v3144,v3145 in ipairs(v9:GetChildren()) do if (v3145:IsA("Tool") and (v3145:GetAttribute("Seed")~=nil)) then return v3145:GetAttribute("Seed"),v3145
        end end return nil,nil
end local function v1545(v2473) local v2474={}
local v2475=v2473 and v2473:FindFirstChild("Important")
if not v2475 then return v2474
end local v2476=v2475:FindFirstChild("Plant_Locations")
if not v2476 then return v2474
end for v3146,v3147 in ipairs(v2476:GetChildren()) do if v3147:IsA("BasePart") then table.insert(v2474,v3147)
end end return v2474
end local function v1546(v2477,v2478,v2479) local v2480=v1545(v2477)
if ( #v2480==0) then return {}
end local v2481={}
for v3148,v3149 in ipairs(v2480) do if ( #v2481>=v2478) then break
end local v3150=v3149.CFrame
local v3151=v3149.Size.X
local v3152=v3149.Size.Z
local v3153=3
local v3154=math.max(1,math.floor((v3151-(v3153 * 2))/v2479 ))
local v3155=math.max(1,math.floor((v3152-(v3153 * 2))/v2479 ))
local v3156=( -(v3154-1) * v2479)/2
local v3157=( -(v3155-1) * v2479)/2
for v3656=0,v3155-1 do for v3942=0,v3154-1 do if ( #v2481>=v2478) then break
        end local v3943=(v3150 * CFrame.new(v3156 + (v3942 * v2479) ,0,v3157 + (v3656 * v2479) )).Position
    table.insert(v2481,Vector3.new(v3943.X,0.135,v3943.Z))
end if ( #v2481>=v2478) then break
end end end return v2481
end local function v1547() while v1541 do local v3158=v1481()
    if v3158 then local v3944,v3945=v1544()
        if (v3944 and v3945) then local v4269=v1546(v3158,200,3)
            for v4370,v4371 in ipairs(v4269) do if not v1541 then break
                end local v4372,v4370=v1544()
            if not v4372 then break
            end pcall(function() v1543:FireServer(Vector3.new(v4371.X,v4371.Y,v4371.Z),v4372)
        end)
    task.wait(0.1)
end end end task.wait(v1542)
end end local v1548=v16:accordion(v1466,"🌱 AUTO PLANT",3,false)
local v1549=v1548.Inner
local v1550=v16:frame(v1549,UDim2.new(1,0,0,26),nil,v15.BTN)
v1550.LayoutOrder=0
v16:corner(v1550,5)
v16:stroke(v1550,v15.STROKE,1)
v16:label(v1550,"Interval (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v1553=v16:input(v1550,v1542,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v1553.FocusLost:Connect(function() local v2482=tonumber(v1553.Text)
    if (v2482 and (v2482>0)) then v1542=v2482
        v33.autoCollect.interval=v2482
        v37()
    else v1553.Text=tostring(v1542)
end end)
local v1554=v16:frame(v1549,UDim2.new(1,0,0,26),nil,v15.BTN)
v1554.LayoutOrder=2
v16:corner(v1554,5)
v16:stroke(v1554,v15.STROKE,1)
v16:label(v1554,"AUTO PLANT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v1557=v16:label(v1554,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),v15.DIM,8)
v1557.Font=Enum.Font.Gotham
v16:toggle(v1554,UDim2.new(1, -52,0.5, -11),false,function(v2483) v1541=v2483
    v1557.Text=(v2483 and "● ON") or "● IDLE"
    v1557.TextColor3=(v2483 and v15.SUCCESS) or v15.DIM
    if v2483 then task.spawn(v1547)
    end end)
end local v441=v16:frame(v438,UDim2.new(1,0,1,0),nil,v15.BG,1)
v441.Visible=false
do local v1559=v16:scroll(v441,UDim2.new(1,0,1,0))
    v1559.ScrollingDirection=Enum.ScrollingDirection.Y
    v1559.AutomaticCanvasSize=Enum.AutomaticSize.Y
    v1559.ScrollBarThickness=3
    v1559.ScrollBarImageColor3=v15.ACCENT
    local v1567=Instance.new("Frame",v1559)
    v1567.Size=UDim2.new(1,0,0,0)
    v1567.BackgroundTransparency=1
    v1567.AutomaticSize=Enum.AutomaticSize.Y
    v16:list(v1567,6)
    v16:pad(v1567,6,6,6,20)
    v16:label(v1567,"🚧 Coming Soon",UDim2.new(1,0,0,20),nil,v15.DIM,10,Enum.TextXAlignment.Center).LayoutOrder=1
end local v443=v16:frame(v438,UDim2.new(1,0,1,0),nil,v15.BG,1)
v443.Visible=false
do local v1572=v2:WaitForChild("GameEvents"):WaitForChild("GiftPet")
    local v1573=v2:WaitForChild("GameEvents"):WaitForChild("AcceptPetGift")
    local v1574=v2:WaitForChild("GameEvents"):WaitForChild("PetGiftingService",10)
    if not v1574 then warn("[AutoGift] PetGiftingService not found!")
    end local v1575=v33.autoTrade.autoGift
local v1576=v33.autoTrade.autoAccept
local v1577=v33.autoTrade.targetPlayer
local v1578=v33.autoTrade.selPets
local v1579=nil
local v1580=v16:scroll(v443,UDim2.new(1,0,1,0))
v1580.ScrollingDirection=Enum.ScrollingDirection.Y
v1580.AutomaticCanvasSize=Enum.AutomaticSize.Y
v1580.ScrollBarThickness=3
v1580.ScrollBarImageColor3=v15.ACCENT
local v1588=Instance.new("Frame",v1580)
v1588.Size=UDim2.new(1,0,0,0)
v1588.BackgroundTransparency=1
v1588.AutomaticSize=Enum.AutomaticSize.Y
v16:list(v1588,6)
v16:pad(v1588,6,6,6,20)
local v1592=v16:accordion(v1588,"AUTO ACCEPT GIFT",1,true)
local v1593=v1592.Inner
local v1594=v16:frame(v1593,UDim2.new(1,0,0,26),nil,v15.BTN)
v1594.LayoutOrder=1
v16:corner(v1594,5)
v16:stroke(v1594,v15.STROKE,1)
v16:label(v1594,"AUTO ACCEPT ALL",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v1598=v16:label(v1594,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),v15.DIM,8)
v1598.Font=Enum.Font.Gotham
if v1576 then v1598.Text="● ON"
    v1598.TextColor3=v15.SUCCESS
    v1579=v1572.OnClientEvent:Connect(function(v3659,v3660,v3661) if not v1576 then return
        end task.wait(0.1)
    v29("trade_gift_accept",{sender_username=tostring(v3661 or "?" ),pet_name=(v3660 and v3660.PetType and tostring(v3660.PetType)) or "?" ,pet_kg=(v3660 and v3660.PetData and v3660.PetData.BaseWeight and v3660.PetData.BaseWeight) or 0 ,pet_uuid=tostring(v3659 or "?" )})
    pcall(function() v1573:FireServer(true,v3659)
    end)
end)
end v16:toggle(v1594,UDim2.new(1, -52,0.5, -11),v1576,function(v2486) v1576=v2486
v33.autoTrade.autoAccept=v2486
v37()
v1598.Text=(v2486 and "● ON") or "● IDLE"
v1598.TextColor3=(v2486 and v15.SUCCESS) or v15.DIM
if v2486 then v1579=v1572.OnClientEvent:Connect(function(v3946,v3947,v3948) if not v1576 then return
        end task.wait(0.1)
    v29("trade_gift_accept",{sender_username=tostring(v3948 or "?" ),pet_name=(v3947 and v3947.PetType and tostring(v3947.PetType)) or "?" ,pet_kg=(v3947 and v3947.PetData and v3947.PetData.BaseWeight and v3947.PetData.BaseWeight) or 0 ,pet_uuid=tostring(v3946 or "?" )})
    pcall(function() local v4176=v7.PlayerGui:FindFirstChild("Gift_Notification")
        if not v4176 then return
        end local v4177=v4176:FindFirstChild("Frame")
    if not v4177 then return
    end for v4270,v4271 in ipairs(v4177:GetChildren()) do if v4271:IsA("GuiObject") then v4271:Destroy()
    end end end)
pcall(function() v1573:FireServer(true,v3946)
end)
end)
elseif v1579 then v1579:Disconnect()
    v1579=nil
end end)
local v1601=v16:accordion(v1588," AUTO GIFT PET",3,false)
local v1602=v1601.Inner
local v1603=v16:frame(v1602,UDim2.new(1,0,0,13),nil,v15.BG,1)
v1603.LayoutOrder=0
v16:label(v1603,"TARGET PLAYER",UDim2.new(1,0,1,0),nil,v15.DIM,8).Font=Enum.Font.Gotham
local v1606=v16:frame(v1602,UDim2.new(1,0,0,26),nil,v15.BG,1)
v1606.LayoutOrder=1
local v1608=v16:button(v1606,v1577 or "None selected" ,UDim2.new(1, -56,1,0),nil,v15.BTN,v15.TEXT,9)
v1608.TextXAlignment=Enum.TextXAlignment.Left
v16:pad(v1608,0,8,8,0)
v16:stroke(v1608,v15.STROKE,1)
v16:label(v1606,"v",UDim2.new(0,16,1,0),UDim2.new(1, -76,0,0),v15.DIM,9,Enum.TextXAlignment.Center)
local v1611=Instance.new("ImageButton",v1606)
v1611.Size=UDim2.new(0,24,0,24)
v1611.Position=UDim2.new(1, -28,0.5, -12)
v1611.BackgroundColor3=v15.BTN
v1611.BorderSizePixel=0
v1611.Image="rbxthumb://type=Asset&id=98916802076487&w=150&h=150"
v1611.ScaleType=Enum.ScaleType.Fit
v16:corner(v1611,5)
v16:stroke(v1611,v15.ACCENT,1)
local v1620=v16:frame(v1602,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10))
v1620.LayoutOrder=2
v1620.Visible=false
v16:corner(v1620,5)
v16:stroke(v1620,v15.STROKE,1)
local v1623=v16:scroll(v1620)
v16:list(v1623,2)
v16:pad(v1623,2,2,2,2)
local v1624=false
local function v1625() for v3162,v3163 in ipairs(v1623:GetChildren()) do if v3163:IsA("GuiObject") then v3163:Destroy()
        end end local v2490=game:GetService("Players"):GetPlayers()
local v2491=0
for v3164,v3165 in ipairs(v2490) do if (v3165.Name==v7.Name) then continue
    end v2491=v2491 + 1
local v3166=v1577==v3165.Name
local v3167=v16:button(v1623,v3165.Name,UDim2.new(1,0,0,22),nil,(v3166 and v15.SEL_BG) or Color3.fromRGB(14,14,14) ,(v3166 and v15.SEL_TXT) or v15.TEXT ,9)
v3167.LayoutOrder=v2491
v3167.TextXAlignment=Enum.TextXAlignment.Left
v16:pad(v3167,0,8,0,0)
v16:stroke(v3167,(v3166 and v15.ACCENT) or v15.STROKE ,1)
v3167.MouseButton1Click:Connect(function() v1577=v3165.Name
    v33.autoTrade.targetPlayer=v3165.Name
    v37()
    v1608.Text=v3165.Name
    v1620.Visible=false
    v1624=false
end)
end if (v2491==0) then local v3666=v16:label(v1623," (no other players)",UDim2.new(1,0,0,22),nil,v15.DIM,9)
v3666.LayoutOrder=1
v2491=1
end v1620.Size=UDim2.new(1,0,0,math.min((v2491 * 24) + 6 ,100))
end v1608.MouseButton1Click:Connect(function() v1624= not v1624
v1620.Visible=v1624
if v1624 then v1625()
end end)
v1611.MouseButton1Click:Connect(function() if v1624 then v1625()
end end)
v16:divider(v1602,3)
local v1626=v16:frame(v1602,UDim2.new(1,0,0,26),nil,v15.BG,1)
v1626.LayoutOrder=4
local v1628=v16:label(v1626,"Pets: NONE",UDim2.new(1, -96,1,0),UDim2.new(0,4,0,0),v15.DIM,9)
v1628.Font=Enum.Font.Gotham
local v1630=v16:button(v1626,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9)
v16:stroke(v1630,v15.STROKE,1)
local function v1631() local v2494=0
    for v3171 in pairs(v1578) do v2494=v2494 + 1
    end if (v2494==0) then v1628.Text="Pets: NONE"
    v1628.TextColor3=v15.DIM
else v1628.Text="Pets: " .. v2494 .. " selected"
v1628.TextColor3=v15.ACCENT
end end v1631()
local function v1632(v2495,v2496,v2497,v2498) local v2499=v16:frame(v1602,UDim2.new(1,0,0,26),nil,v15.BTN)
v2499.LayoutOrder=v2496
v16:corner(v2499,5)
v16:stroke(v2499,v15.STROKE,1)
v16:label(v2499,v2495,UDim2.new(0,30,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v2503=v33.autoTrade[v2497] or "Above"
local v2504=v16:button(v2499,v2503,UDim2.new(0,46,0,20),UDim2.new(0,38,0.5, -10),v15.PANEL,v15.ACCENT,8)
v16:stroke(v2504,v15.STROKE,1)
local v2505=v33.autoTrade[v2498] or 0
local v2506=v16:input(v2499,tostring(v2505),"",UDim2.new(0,50,0,20),UDim2.new(1, -54,0.5, -10))
local v2507=v2503
v2504.MouseButton1Click:Connect(function() v2507=((v2507=="Above") and "Below") or "Above"
    v2504.Text=v2507
    v33.autoTrade[v2497]=v2507
    v37()
end)
v2506.FocusLost:Connect(function() local v3174=tonumber(v2506.Text)
if (v3174 and (v3174>=0)) then v33.autoTrade[v2498]=v3174
    v37()
else v2506.Text=tostring(v33.autoTrade[v2498] or 0 )
end end)
return v2506,function() return v2507
end,function() return tonumber(v2506.Text) or 0
end
end local v1633,v1634,v1635=v1632("KG",5,"kgMode","kgVal")
local v1636,v1637,v1638=v1632("Age",6,"ageMode","ageVal")
if (v33.autoTrade.forceGiftFav==nil) then v33.autoTrade.forceGiftFav=false
end local v1639=v16:frame(v1602,UDim2.new(1,0,0,26),nil,v15.BTN)
v1639.LayoutOrder=7
v16:corner(v1639,5)
v16:stroke(v1639,v15.STROKE,1)
v16:label(v1639,"Force Gift Favorited (UnFavorite Before Gift)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
v16:toggle(v1639,UDim2.new(1, -52,0.5, -11),v33.autoTrade.forceGiftFav,function(v2508) v33.autoTrade.forceGiftFav=v2508
    v37()
end)
local v1642=v16:frame(v1602,UDim2.new(1,0,0,28),nil,v15.PANEL)
v1642.LayoutOrder=8
v16:stroke(v1642,v15.STROKE,1)
v16:label(v1642,"AUTO GIFT",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v1645=v16:label(v1642,"● IDLE",UDim2.new(0,60,1,0),UDim2.new(1, -108,0,0),v15.DIM,8)
v1645.Font=Enum.Font.Gotham
local function v1647(v2510) local v2511=v60()
    local v2512=v2511[v2510]
    if not v2512 then return false
    end local v2513=v63(v2510)
local v2514=(v2512.PetData and (v2512.PetData.Level or 0)) or 0
local v2515=v1635()
local v2516=v1638()
local v2517=(v2515==0) or ((v1634()=="Above") and (v2513>=v2515)) or ((v1634()=="Below") and (v2513<=v2515))
local v2518=(v2516==0) or ((v1637()=="Above") and (v2514>=v2516)) or ((v1637()=="Below") and (v2514<=v2516))
return v2517 and v2518
end local function v1648() while v1575 do if not v1577 then v1645.Text="No target!"
        v1645.TextColor3=v15.ERROR
        task.wait(1)
        continue
    end local v3176=game:GetService("Players"):FindFirstChild(v1577)
if not v3176 then v1645.Text="Player offline"
    v1645.TextColor3=v15.DIM
    task.wait(2)
    continue
end local v3177=v60()
local v3178={}
local v3179=0
for v3674 in pairs(v1578) do v3179=v3179 + 1
end if (v3179==0) then v1645.Text="No pets selected!"
v1645.TextColor3=v15.ERROR
task.wait(2)
continue
end for v3675 in pairs(v3177) do local v3676=v3177[v3675]
if not v3676 then continue
end local v3677=v3676.PetType or ""
local v3678=v1578[v3677]
if (v3678 and v1647(v3675)) then table.insert(v3178,v3675)
end end if ( #v3178==0) then v1645.Text="No matching pets"
v1645.TextColor3=v15.DIM
task.wait(2)
continue
end for v3679,v3680 in ipairs(v3178) do if not v1575 then break
end for v3963,v3964 in ipairs(v9:GetChildren()) do if v3964:IsA("Tool") then v3964.Parent=v8
end end task.wait(0.3)
local v3681=v66(v3680)
if not v3681 then v1645.Text="Skip-no tool: " .. v64(v3680)
    v1645.TextColor3=v15.ERROR
    continue
end local v3682=v66(v3680)
if (v3682 and (v3682:GetAttribute(v21)==true)) then if v33.autoTrade.forceGiftFav then v1645.Text="Unfav: " .. v64(v3680)
    v1645.TextColor3=v15.DIM
    local v4376=v2:WaitForChild("GameEvents"):WaitForChild("Favorite_Item")
    v4376:FireServer(v3682)
    local v4377=os.clock()
    repeat task.wait(0.1)
    until (v66(v3680)==nil) or (v66(v3680) and (v66(v3680):GetAttribute(v21)~=true)) or ((os.clock() -v4377)>3) task.wait(0.5)
v3681=v66(v3680)
if not v3681 then continue
end if (v3681:GetAttribute(v21)==true) then v1645.Text="Still fav, skip: " .. v64(v3680)
v1645.TextColor3=v15.ERROR
continue
end else v1645.Text="Skip-fav: " .. v64(v3680)
v1645.TextColor3=v15.DIM
continue
end end _G.VoidHub_GiftingActive=true
v3681.Parent=v9
task.wait(1)
v1645.Text="Gifting " .. v64(v3680)
v1645.TextColor3=v15.SUCCESS
local v3687=v2:FindFirstChild("GameEvents")
local v3688=v3687 and v3687:FindFirstChild("PetGiftingService")
if v3688 then pcall(function() v3688:FireServer("GivePet",v3176)
    end)
v29("trade_gift_send",{target_username=v1577 or "?" ,pet_name=v64(v3680),pet_kg=v63(v3680),pet_age=v62(v3680),pet_mut=v67(v3680)})
else v1645.Text="Remote not found!"
v1645.TextColor3=v15.ERROR
end task.wait(1.5)
_G.VoidHub_GiftingActive=false
end task.wait(1)
end v1645.Text="● IDLE"
v1645.TextColor3=v15.DIM
end v16:toggle(v1642,UDim2.new(1, -52,0.5, -11),v1575,function(v2522) v1575=v2522
v33.autoTrade.autoGift=v2522
v37()
v1645.Text=(v2522 and "● ON") or "● IDLE"
v1645.TextColor3=(v2522 and v15.SUCCESS) or v15.DIM
if not v2522 then _G.VoidHub_GiftingActive=false
end if v2522 then task.spawn(v1648)
end end)
if v1575 then task.defer(function() task.spawn(v1648)
end)
end local v1649=v16:frame(v443,UDim2.new(1,0,1,0),nil,v15.BG)
v1649.Visible=false
v1649.ZIndex=25
local v1652=v16:frame(v1649,UDim2.new(1,0,0,26),nil,v15.PANEL)
v16:stroke(v1652,v15.STROKE,1)
v16:label(v1652,"Select Pets to Gift",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10)
local v1653=v16:button(v1652,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8)
v16:stroke(v1653,v15.STROKE,1)
local v1654=v16:button(v1652,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10)
v16:stroke(v1654,v15.ERROR,1)
v1654.MouseButton1Click:Connect(function() v1649.Visible=false
    v1631()
end)
local v1655=v16:input(v1649,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1655.TextColor3=v15.TEXT
v1655.Font=Enum.Font.Gotham
local v1659=v16:scroll(v1649,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
v16:list(v1659,3)
v16:pad(v1659,3,4,4,3)
local function v1660() for v3180,v3181 in ipairs(v1659:GetChildren()) do if v3181:IsA("GuiObject") then v3181:Destroy()
        end end local v2527=string.lower(v1655.Text)
local v2528={}
local v2529={}
for v3182,v3183 in ipairs(v17) do if not v2528[v3183.name] then v2528[v3183.name]=true
        if ((v2527=="") or v3183.name:lower():find(v2527,1,true)) then table.insert(v2529,v3183)
        end end end local v2530= #v2529>0
for v3184,v3185 in ipairs(v2529) do if not v1578[v3185.name] then v2530=false
    break
end end v1653.Text=(( #v2529==0) and "Select All") or (v2530 and "Unselect All") or "Select All"
v1653.TextColor3=(v2530 and v15.SEL_TXT) or v15.ACCENT
v1653.BackgroundColor3=(v2530 and v15.SEL_BG) or v15.BTN
for v3186,v3187 in ipairs(v2529) do local v3188=v1578[v3187.name]==true
    local v3189=v16:button(v1659,v3187.name,UDim2.new(1,0,0,30),nil,(v3188 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3188 and v15.SEL_TXT) or v15.TEXT ,9)
    v3189.LayoutOrder=v3186
    v3189.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v3189,0,8,4,0)
    v16:corner(v3189,5)
    v16:stroke(v3189,(v3188 and v15.ACCENT) or v15.STROKE ,1)
    v16:label(v3189,v3187.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v3188 and Color3.fromRGB(60,40,0)) or v15.DIM ,8).Font=Enum.Font.Gotham
    v3189.MouseButton1Click:Connect(function() if v1578[v3187.name] then v1578[v3187.name]=nil
        else v1578[v3187.name]=true
    end v33.autoTrade.selPets=v1578
v37()
v1631()
v16:updateRowVisual(v3189,v1578[v3187.name]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE)
end)
end end v1653.MouseButton1Click:Connect(function() local v2534=string.lower(v1655.Text)
local v2535={}
local v2536={}
for v3195,v3196 in ipairs(v17) do if not v2536[v3196.name] then v2536[v3196.name]=true
        if ((v2534=="") or v3196.name:lower():find(v2534,1,true)) then table.insert(v2535,v3196)
        end end end local v2537= #v2535>0
for v3197,v3198 in ipairs(v2535) do if not v1578[v3198.name] then v2537=false
    break
end end if v2537 then for v3967,v3968 in ipairs(v2535) do v1578[v3968.name]=nil
end else for v3970,v3971 in ipairs(v2535) do v1578[v3971.name]=true
end end v33.autoTrade.selPets=v1578
v37()
v1631()
v1660()
end)
v1655:GetPropertyChangedSignal("Text"):Connect(v1660)
v1630.MouseButton1Click:Connect(function() v1649.Visible=true
    v1660()
end)
end local v445={{v435,"fruit"},{v436,"shop"},{v437,"trade"}}
local function v446(v1661) v439.Visible=v1661=="fruit"
v441.Visible=v1661=="shop"
v443.Visible=v1661=="trade"
for v2540,v2541 in ipairs(v445) do v2541[1].SetActive(v2541[2]==v1661 )
end end v435.Button.MouseButton1Click:Connect(function() v446("fruit")
end)
v436.Button.MouseButton1Click:Connect(function() v446("shop")
end)
v437.Button.MouseButton1Click:Connect(function() v446("trade")
end)
v446("fruit")
end v140()
local v141=v137[1]
local v142=v16:frame(v141,UDim2.new(0,52,1,0),nil,v15.SIDEBAR)
v16:stroke(v142,Color3.fromRGB(18,18,18),1)
local v143=Instance.new("ScrollingFrame",v142)
v143.Size=UDim2.new(1,0,1,0)
v143.BackgroundTransparency=1
v143.BorderSizePixel=0
v143.ScrollBarThickness=0
v143.ScrollingDirection=Enum.ScrollingDirection.Y
v143.AutomaticCanvasSize=Enum.AutomaticSize.Y
v143.CanvasSize=UDim2.new(0,0,0,0)
local v153=Instance.new("Frame",v143)
v153.Size=UDim2.new(1,0,0,0)
v153.BackgroundTransparency=1
v153.AutomaticSize=Enum.AutomaticSize.Y
local v157=Instance.new("UIListLayout",v153)
v157.Padding=UDim.new(0,2)
v157.SortOrder=Enum.SortOrder.LayoutOrder
v157.HorizontalAlignment=Enum.HorizontalAlignment.Center
local v163=Instance.new("UIPadding",v153)
v163.PaddingTop=UDim.new(0,6)
v163.PaddingBottom=UDim.new(0,6)
local v166=0
local function v167() v166=v166 + 1
    local v447=Instance.new("Frame",v153)
    v447.Size=UDim2.new(0,30,0,1)
    v447.BackgroundColor3=Color3.fromRGB(28,28,40)
    v447.BorderSizePixel=0
    v447.LayoutOrder=v166 * 100
end local v168=0
local function v169(v452,v453) v168=v168 + 1
local v454=Instance.new("TextButton",v153)
v454.Size=UDim2.new(1, -8,0,38)
v454.LayoutOrder=(v168 * 100) -50
v454.BackgroundColor3=v15.BTN
v454.BackgroundTransparency=1
v454.BorderSizePixel=0
v454.Text=""
v454.AutoButtonColor=false
v16:corner(v454,7)
local v463=Instance.new("Frame",v454)
v463.Size=UDim2.new(0,2,0,20)
v463.Position=UDim2.new(0,0,0.5, -10)
v463.BackgroundColor3=v15.ACCENT
v463.BorderSizePixel=0
v463.Visible=false
v16:corner(v463,2)
local v470=Instance.new("TextLabel",v454)
v470.Size=UDim2.new(1,0,0,20)
v470.Position=UDim2.new(0,0,0,5)
v470.BackgroundTransparency=1
v470.Text=v452
v470.TextColor3=v15.DIM
v470.Font=Enum.Font.GothamBold
v470.TextSize=14
v470.TextXAlignment=Enum.TextXAlignment.Center
local v482=Instance.new("TextLabel",v454)
v482.Size=UDim2.new(1,0,0,10)
v482.Position=UDim2.new(0,0,0,25)
v482.BackgroundTransparency=1
v482.Text=v453
v482.TextColor3=v15.DIM
v482.Font=Enum.Font.Gotham
v482.TextSize=7
v482.TextXAlignment=Enum.TextXAlignment.Center
v454.MouseEnter:Connect(function() if (v463.Visible==false) then v454.BackgroundTransparency=0.85
        v454.BackgroundColor3=v15.ACCENT
        v470.TextColor3=Color3.fromRGB(160,150,220)
        v482.TextColor3=Color3.fromRGB(160,150,220)
    end end)
v454.MouseLeave:Connect(function() if (v463.Visible==false) then v454.BackgroundTransparency=1
    v454.BackgroundColor3=v15.BTN
    v470.TextColor3=v15.DIM
    v482.TextColor3=v15.DIM
end end)
local function v492(v1665) v463.Visible=v1665
if v1665 then v454.BackgroundColor3=Color3.fromRGB(20,20,50)
    v454.BackgroundTransparency=0
    v470.TextColor3=v15.ACCENT
    v482.TextColor3=v15.ACCENT
else v454.BackgroundColor3=v15.BTN
v454.BackgroundTransparency=1
v470.TextColor3=v15.DIM
v482.TextColor3=v15.DIM
end end return {Button=v454,SetActive=v492}
end local v170=v169("🥚","HATCH")
local v171=v169("🐘","ELEPHANT")
local v172=v169("⬆","LEVELING")
v167()
local v173=v169("👥","TEAMS")
local v174=v169("👆","PnP")
local v175=v169("⚡","BOOST")
v167()
local v176=v169("🔗","WEBHOOK")
v167()
local v177=v169("⚙️","MISC")
local v178=v16:frame(v141,UDim2.new(1, -56,1, -2),UDim2.new(0,54,0,1),v15.BG,1)
local v179=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v179.Visible=true
local v181=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v181.Visible=false
local v183=v2:WaitForChild("GameEvents"):WaitForChild("Favorite_Item")
local v184=v2:WaitForChild("GameEvents"):WaitForChild("SellAllPets_RE")
local v185=v2:WaitForChild("GameEvents"):WaitForChild("PetEggService")
local function v186() local v493,v494=pcall(require,v2.Modules.GetFarm)
    if (v493 and v494) then local v2542,v2543=pcall(function() return v494(v7)
        end)
    if (v2542 and v2543) then return v2543
    end end local v495=workspace:FindFirstChild("Farm")
if not v495 then return nil
end for v1667,v1668 in ipairs(v495:GetChildren()) do local v1669=v1668:FindFirstChild("Important")
if v1669 then local v3221=v1669:FindFirstChild("Data")
    if v3221 then local v3973=v3221:FindFirstChild("Owner")
        if (v3973 and (v3973.Value==v7.Name)) then return v1668
        end end end end return nil
end local function v187(v496) local v497={}
local v498=v496 and v496:FindFirstChild("Important")
if not v498 then return v497
end local v499=v498:FindFirstChild("Plant_Locations")
if not v499 then return v497
end for v1670,v1671 in ipairs(v499:GetChildren()) do if v1671:IsA("BasePart") then table.insert(v497,v1671)
end end return v497
end local function v188(v500,v501,v502) local v503=v187(v500)
if ( #v503==0) then return {}
end local v504={}
for v1672,v1673 in ipairs(v503) do if ( #v504>=v501) then break
end local v1674=v1673.CFrame
local v1675=v1673.Size.X
local v1676=v1673.Size.Z
local v1677=3
local v1678=math.max(1,math.floor((v1675-(v1677 * 2))/v502 ))
local v1679=math.max(1,math.floor((v1676-(v1677 * 2))/v502 ))
local v1680=( -(v1678-1) * v502)/2
local v1681=( -(v1679-1) * v502)/2
for v2544=0,v1679-1 do for v3222=0,v1678-1 do if ( #v504>=v501) then break
        end local v3223=(v1674 * CFrame.new(v1680 + (v3222 * v502) ,0,v1681 + (v2544 * v502) )).Position
    table.insert(v504,Vector3.new(v3223.X,0.135,v3223.Z))
end if ( #v504>=v501) then break
end end end return v504
end local function v189() local v505=0
for v1682,v1683 in ipairs(v5:GetTagged("PetEggServer")) do if (v1683:GetAttribute("OWNER")==v7.Name) then v505=v505 + 1
    end end return v505
end local function v190(v506) for v1684,v1685 in ipairs(v8:GetChildren()) do if (v1685:IsA("Tool") and v5:HasTag(v1685,"PetEggTool")) then if (v1685:GetAttribute("h")==v506) then return v1685
        end end end return nil
end local function v191() local v507=v60()
local v508=0
for v1686 in pairs(v507) do v508=v508 + 1
end return v508
end local v192={}
local v193={}
local function v194(v509) if (v509<=0) then return "READY!"
    end local v510=math.floor(v509/3600 )
local v511=math.floor((v509%3600)/60 )
local v512=v509%60
if (v510>0) then return string.format("%dh %dm %ds",v510,v511,v512)
elseif (v511>0) then return string.format("%dm %ds",v511,v512)
else return string.format("%ds",v512)
end end local function v195(v513) local v514=v513:GetAttribute("OBJECT_UUID")
if not v514 then return nil
end local v515,v516=pcall(function() return v10:GetData()
end)
if ( not v515 or not v516 or not v516.SaveSlots) then return nil
end for v1687,v1688 in pairs(v516.SaveSlots.AllSlots) do local v1689=(v1688.SavedObjects or {})[v514]
if (v1689 and (type(v1689)=="table") and (v1689.ObjectType=="PetEgg") and v1689.Data) then return v1689.Data
end end return nil
end local function v196(v517) local v518=v517:FindFirstChild("AH_EggESP")
if v518 then v518:Destroy()
end local v519=Instance.new("BillboardGui")
v519.Name="AH_EggESP"
v519.AlwaysOnTop=true
v519.Size=UDim2.new(0,220,0,90)
v519.StudsOffset=Vector3.new(0,5,0)
v519.Parent=v517
local v525=Instance.new("Frame",v519)
v525.Size=UDim2.fromScale(1,1)
v525.BackgroundTransparency=1
local function v528(v1690,v1691,v1692) local v1693=Instance.new("TextLabel",v525)
    v1693.Size=UDim2.new(1,0,0,22)
    v1693.Position=UDim2.new(0,0,0,v1690)
    v1693.BackgroundTransparency=1
    v1693.TextColor3=v1691
    v1693.TextStrokeTransparency=0
    v1693.TextSize=v1692 or 13
    v1693.Font=Enum.Font.GothamBold
    return v1693
end local v529=v528(0,Color3.fromRGB(255,220,50),14)
local v530=v528(23,Color3.fromRGB(100,255,100),13)
local v531=v528(46,Color3.fromRGB(100,200,255),13)
local v532=v528(69,Color3.fromRGB(255,255,255),13)
v529.Text=v517:GetAttribute("EggName") or "?"
v530.Text="🐾 ..."
v531.Text=""
v532.Text=v194(v517:GetAttribute("TimeToHatch") or 0 )
return v532,v530,v531
end local function v197(v537) if (v537:GetAttribute("OWNER")~=v7.Name) then return
end if v192[v537] then return
end local v538,v539,v540
if v33.autoHatch.espEnabled then v538,v539,v540=v196(v537)
else v538={Text="",TextColor3=Color3.new()}
v539={Text=""}
v540={Text=""}
end local v541={timeLbl=v538,petLbl=v539,wgtLbl=v540,loaded=false}
v192[v537]=v541
v193[v537]={weight=0,petType="?",ready=(v537:GetAttribute("TimeToHatch") or 0)<=0 ,eggName=v537:GetAttribute("EggName") or "" }
v537:GetAttributeChangedSignal("TimeToHatch"):Connect(function() if not v192[v537] then return
    end local v1702=v537:GetAttribute("TimeToHatch") or 0
if v33.autoHatch.espEnabled then v538.Text=v194(v1702)
    v538.TextColor3=((v1702<=0) and Color3.fromRGB(100,255,100)) or Color3.fromRGB(255,255,255)
end if v193[v537] then v193[v537].ready=v1702<=0
end end)
end for v544,v545 in ipairs(v5:GetTagged("PetEggServer")) do v197(v545)
end v5:GetInstanceAddedSignal("PetEggServer"):Connect(function(v546) task.wait(0.2)
v197(v546)
end)
v5:GetInstanceRemovedSignal("PetEggServer"):Connect(function(v547) v192[v547]=nil
v193[v547]=nil
end)
task.spawn(function() while true do task.wait(0.3)
    for v2545,v2546 in pairs(v192) do if ( not v2545 or not v2545.Parent) then v192[v2545]=nil
            v193[v2545]=nil
            continue
        end if not v2546.loaded then local v3692=v195(v2545)
        if (v3692 and v3692.Type) then v2546.loaded=true
            if v33.autoHatch.espEnabled then v2546.petLbl.Text="🐾 " .. v3692.Type
                v2546.wgtLbl.Text=string.format("%.2fkg",(v3692.BaseWeight or 0) * 1.1 )
            end if v193[v2545] then v193[v2545].weight=(v3692.BaseWeight or 0) * 1.1
            v193[v2545].petType=v3692.Type
        end end end end end end)
local function v198() for v1703,v1704 in pairs(v192) do if (v1703 and v1703.Parent) then local v3227=v1703:FindFirstChild("AH_EggESP")
if v33.autoHatch.espEnabled then if not v3227 then local v4273,v4274,v4275=v196(v1703)
        v1704.timeLbl=v4273
        v1704.petLbl=v4274
        v1704.wgtLbl=v4275
        local v4279=v1703:GetAttribute("TimeToHatch") or 0
        v4273.Text=v194(v4279)
        v4273.TextColor3=((v4279<=0) and Color3.fromRGB(100,255,100)) or Color3.fromRGB(255,255,255)
        if (v1704.loaded and v193[v1703]) then v4274.Text="🐾 " .. (v193[v1703].petType or "?")
            v4275.Text=string.format("%.2fkg",v193[v1703].weight or 0 )
        end end elseif v3227 then v3227:Destroy()
end end end end local v199=false
local v200=nil
local v201=false
local v202=false
if not v33.autoHatch.specialBronto then v33.autoHatch.specialBronto={enabled=true,pets={}}
end local function v203() v84.IsEquipping=true
local v551=v83()
for v1706,v1707 in ipairs(v551) do pcall(function() v12:FireServer("UnequipPet",v1707)
    end)
task.wait(v24.AH_UNEQUIP_DELAY)
end if ( #v551>0) then task.wait(v24.AH_POST_UNEQUIP_BUFFER)
end v84.IsEquipping=false
end local function v204(v552) v84.IsEquipping=true
local v554=v92()
for v1708,v1709 in ipairs(v552) do pcall(function() v12:FireServer("EquipPet",v1709,v554)
    end)
task.wait(v24.AH_EQUIP_DELAY)
end v84.IsEquipping=false
end local function v205(v555,v556) if not v555 then return
end local v557=v39(v555)
if ( #v557==0) then return
end if v556 then v202=true
_G.AH_SuppressPickPlace=true
end v203()
task.wait(0.3)
v204(v557)
local v558=v94(v557,10)
if not v558 then v203()
    task.wait(0.3)
    v204(v557)
    v94(v557,8)
end end local function v206() if not v33.autoHatch.suppressPPOnTeam then return
end v202=false
_G.AH_SuppressPickPlace=false
end local function v207(v559,v560,v561,v562) for v1710,v1711 in ipairs(v9:GetChildren()) do if v1711:IsA("Tool") then v1711.Parent=v8
    end end task.wait(0.3)
local v563=v186()
if not v563 then v562("Farm not found!",v15.ERROR)
    return
end local v564=v189()
local v565=v560-v564
if (v565<=0) then v562("Farm already has " .. v564 .. " egg(s) — skip placing" ,v15.DIM)
    return
end task.wait(0.3)
v564=v189()
v565=v560-v564
if (v565<=0) then v562("Re-check: farm full " .. v564 .. "/" .. v560 .. " — skip" ,v15.DIM)
    return
end local v566=v188(v563,200,v561)
if ( #v566==0) then v562("No positions generated!",v15.ERROR)
return
end v562(string.format("Placing %d egg(s) [%s]...",v565,v559),v15.ACCENT)
local v567=0
local v568=1
local v569=0
while (v567=v560) then v562(string.format("Farm reached target %d/%d — done!",v1712,v560),v15.SUCCESS)
    v567=v565
    break
end if (v568> #v566) then v568=1
v562("Wrap around positions, retry...",v15.DIM)
task.wait(0.5)
end local v1713=v566[v568]
local v1714=v190(v559)
if not v1714 then v562("No more eggs in backpack!",v15.ERROR)
    break
end if v33.autoHatch.autoSellWhenFull then for v3693,v3694 in ipairs(v9:GetChildren()) do if (v3694:IsA("Tool") and not v5:HasTag(v3694,"PetEggTool")) then v3694.Parent=v8
    end end end local v1715=v189()
v1714.Parent=v9
task.wait(0.01)
v185:FireServer("CreateEgg",v1713)
task.wait(0.01)
local v1717=v9:FindFirstChildWhichIsA("Tool")
if (v1717 and v5:HasTag(v1717,"PetEggTool")) then v1717.Parent=v8
end local v1718=v189()
if (v1718>v1715) then v567=v567 + 1
v569=0
v562(string.format("Placed %d/%d",v567,v565),v15.SUCCESS)
else v569=v569 + 1
local v3230=v9:FindFirstChildWhichIsA("Tool")
if (v3230 and v5:HasTag(v3230,"PetEggTool")) then v3230.Parent=v8
end if (v569>=50) then v562("50 fail streak — waiting 3s before retry...",v15.ERROR)
task.wait(3)
v569=0
v568=1
end end v568=v568 + 1
end v562(string.format("Placed %d egg(s)",v567),v15.SUCCESS)
end local function v208(v570,v571) v570("Waiting for eggs to hatch...",v15.DIM)
while v199 do local v1719=false
    for v2547,v2548 in ipairs(v5:GetTagged("PetEggServer")) do if (v2548:GetAttribute("OWNER")==v7.Name) then local v3695=v2548:GetAttribute("TimeToHatch") or 0
            if (v3695>0) then v1719=true
                v571(string.format("⏳ Waiting — %s",v194(v3695)),v15.DIM)
                break
            end end end if not v1719 then break
end task.wait(1)
end end local function v209(v572,v573,v574) local v575={}
local v576={}
for v1720,v1721 in pairs(v193) do if (v1720 and v1720.Parent and (v1720:GetAttribute("OWNER")==v7.Name)) then local v3231=v1720:GetAttribute("TimeToHatch") or 0
        if (v3231<=0) then if (v573 and (v1721.weight>=v572) and (v1721.weight>0)) then table.insert(v576,v1720)
            else table.insert(v575,v1720)
        end end end end local function v577(v1722,v1723,v1724) local v1725=os.clock() + (v1724 or 30)
while v199 and (os.clock()0) and v33.autoHatch.teamKoi) then v574(string.format("Koi mode — hatching %d egg(s)", #v575),v15.ACCENT)
v205(v33.autoHatch.teamKoi,true)
local v2550=v39(v33.autoHatch.teamKoi)
local v2551=v94(v2550,10)
if v2551 then v574("✓ Koi team confirmed active!",v15.ACCENT)
    task.wait(v24.AH_KOI_SAFE_DELAY)
    v574("Safety delay done, hatching...",v15.ACCENT)
else v574("Koi team timeout — hatching anyway...",v15.ERROR)
end local v2552=v83()
local v2553={}
for v3234,v3235 in ipairs(v2552) do v2553[v3235]=true
end local v2554=true
for v3237,v3238 in ipairs(v2550) do if not v2553[v3238] then v2554=false
    break
end end if not v2554 then v574("⚠ Koi team not fully active, re-equip...",v15.ERROR)
v203()
task.wait(0.3)
v204(v2550)
v94(v2550,8)
task.wait(0.5)
end for v3239,v3240 in ipairs(v575) do if not v199 then break
end if (v3240 and v3240.Parent) then task.spawn(function() pcall(function() v185:FireServer("HatchPet",v3240)
    end)
end)
end end v577(v575,"Koi eggs",30)
task.wait(v24.AH_KOI_POST_HATCH)
v206()
elseif ( #v575>0) then v574(string.format("Hatching %d egg(s) (no Koi team)", #v575),v15.DIM)
    for v3975,v3976 in ipairs(v575) do if not v199 then break
        end if (v3976 and v3976.Parent) then task.spawn(function() pcall(function() v185:FireServer("HatchPet",v3976)
            end)
    end)
end end v577(v575,"Eggs",30)
task.wait(1.5)
end if ( #v576>0) then v574(string.format("Bronto mode — %d egg(s) above %.2fkg", #v576,v572),Color3.fromRGB(200,150,255))
repeat if not v33.autoHatch.teamBronto then v574("⛔ BRONTO SKIP — no bronto team set! Set team dulu lalu restart.",v15.ERROR)
        break
    end local v3241=v39(v33.autoHatch.teamBronto)
if ( #v3241==0) then v574("⛔ BRONTO SKIP — bronto team '" .. v33.autoHatch.teamBronto .. "' kosong atau tidak valid!" ,v15.ERROR)
    break
end local v3242=v33.petTeams[v33.autoHatch.teamBronto] or {uuids=v3241}
local v3243={}
for v3696,v3697 in ipairs(v17) do local v3698=string.lower(v3697.name or "" )
    if v3698:find("brontosaurus",1,true) then v3243[v3697.name]=true
    end end local v3244={}
for v3699,v3700 in ipairs(v17) do local v3701=string.lower(v3700.name or "" )
if v3701:find("koi",1,true) then v3244[v3700.name]=true
end end local v3245=v60()
local v3246={}
local v3247={}
for v3702,v3703 in ipairs(v3242.uuids) do local v3704=(v3245[v3703] and (v3245[v3703].PetType or "?")) or "?(not in inv)"
    if v3244[v3704] then table.insert(v3247,v3704)
    elseif not v3243[v3704] then table.insert(v3246,v3704)
    end end if ( #v3246>0) then v574("BRONTO SKIP - team '" .. v33.autoHatch.teamBronto .. "' ada pet BUKAN Brontosaurus:" ,v15.ERROR)
for v4190,v4191 in ipairs(v3246) do v574(" ! " .. v4191 ,v15.ERROR)
end v574(" Fix team kamu lalu restart cycle!",v15.ERROR)
break
end if ( #v3247>0) then v574("WARNING: ada Koi di bronto team - hatch anyway",Color3.fromRGB(255,200,50))
for v4192,v4193 in ipairs(v3247) do v574(" ! Koi: " .. v4193 ,Color3.fromRGB(255,200,50))
end end local v3248= #v3242.uuids-#v3247
v574("Team check OK (" .. v3248 .. " Bronto + " .. #v3247 .. " Koi)" ,Color3.fromRGB(200,150,255))
v205(v33.autoHatch.teamBronto,true)
local v3249=v39(v33.autoHatch.teamBronto)
local v3250=v94(v3249,15)
if not v3250 then v574("⛔ BRONTO SKIP — team timeout tidak equipped! Coba lagi next cycle.",v15.ERROR)
    v206()
    break
end local v3251=v83()
local v3252={}
for v3705,v3706 in ipairs(v3251) do v3252[v3706]=true
end local v3253=true
for v3708,v3709 in ipairs(v3249) do if not v3252[v3709] then v3253=false
    break
end end if not v3253 then v574("⚠ Bronto team not fully active, re-equip...",v15.ERROR)
v203()
task.wait(0.3)
v204(v3249)
v94(v3249,8)
task.wait(0.5)
end v574("✓ Bronto team confirmed active!",Color3.fromRGB(200,150,255))
task.wait(v24.AH_KOI_SAFE_DELAY)
v574("Safety delay done, hatching...",Color3.fromRGB(200,150,255))
for v3710,v3711 in ipairs(v576) do if not v199 then break
    end if (v3711 and v3711.Parent) then task.spawn(function() pcall(function() v185:FireServer("HatchPet",v3711)
        end)
end)
end end v577(v576,"Bronto eggs",45)
v574("Post-bronto safety delay...",v15.DIM)
task.wait(2)
v206()
v574("✓ Bronto sequence done!",Color3.fromRGB(200,150,255))
until true end task.wait(0.5)
end local function v210(v578,v579) local v580=v33.autoHatch.sellPets or {}
local v581=v33.autoHatch.sellThresh or 0
local v582=v33.autoHatch.favDelay or 0.1
v578("Favoriting all (except sell targets)...",v15.ACCENT)
v579("Favoriting...",v15.DIM)
local v583=v60()
local v584=0
for v1726,v1727 in pairs(v583) do if not v199 then break
    end local v1728=v1727.PetType or ""
local v1729=(v1727.PetData and v1727.PetData.BaseWeight) or 0
local v1730=false
if v580[v1728] then if (v581<=0) then v1730=true
    elseif (v17290) then v590(string.format("🍀 Koi proc: %d egg(s) returned",v592),v15.SUCCESS)
    end task.wait(0.5)
local v595=v77(v589)
v78(v595)
end local function v213(v596,v597) local v598=v211(v33.autoHatch.eggName)
local v599=math.max(v598-v596 ,0)
v43.sealProc=v43.sealProc + v599
v43.sealLastCycle=v599
if (v599>0) then v597(string.format("🤝 Seal proc: %d egg(s) recovered",v599),v15.SUCCESS)
end v43.eggCurrent=v211(v33.autoHatch.eggName)
v48()
v29("hatch_cycle",{cycle_number=v43.cycleCount,total_hatched=v43.totalHatched,egg_name=v33.autoHatch.eggName})
v80()
end local function v214() if (v43.startTime and (v43.startTime>0)) then v48()
end end local function v215(v603,v604) local v605=v33.autoHatch
v604("Placing eggs...",v15.ACCENT)
v207(v605.eggName,v605.eggCount,v605.eggSpacing,v603)
task.wait(1)
if not v199 then return
end if v605.teamCD then v603("Wear CD team...",v15.DIM)
v604("CD mode...",v15.DIM)
v205(v605.teamCD)
end v208(v603,v604)
if not v199 then return
end v604("Hatching...",v15.ACCENT)
local v606=v76()
v209(v605.brontoThresh,v605.brontoEnabled,v603)
task.wait(0.5)
v212(v606,v603)
if not v199 then return
end local v607=v211(v33.autoHatch.eggName)
v210(v603,v604)
task.wait(1)
v213(v607,v603)
if not v199 then return
end v203()
task.wait(0.5)
end local function v216() local v608=v16:scroll(v179,UDim2.new(1,0,1,0))
v608.ScrollingDirection=Enum.ScrollingDirection.Y
v608.AutomaticCanvasSize=Enum.AutomaticSize.Y
v608.ScrollBarThickness=3
v608.ScrollBarImageColor3=v15.ACCENT
local v616=Instance.new("Frame",v608)
v616.Size=UDim2.new(1,0,0,0)
v616.BackgroundTransparency=1
v616.AutomaticSize=Enum.AutomaticSize.Y
v16:list(v616,6)
v16:pad(v616,6,6,6,80)
local v620=v16:accordion(v616,"🥚 AUTO HATCH",1,true)
local v621=v620.Inner
local function v622(v1736,v1737,v1738,v1739) local v1740=v16:label(v1736,v1737,UDim2.new(1,0,0,13),nil,v15.DIM,8)
    v1740.LayoutOrder=v1739
    v1740.Font=Enum.Font.Gotham
    local v1744=v16:frame(v1736,UDim2.new(1,0,0,26),nil,v15.BG,1)
    v1744.LayoutOrder=v1739 + 1
    local v1746=v16:button(v1744,v33.autoHatch[v1738] or "None selected" ,UDim2.new(1,0,1,0),nil,v15.BTN,v15.TEXT,9)
    v1746.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v1746,0,8,8,0)
    v16:stroke(v1746,v15.STROKE,1)
    v16:label(v1744,"v",UDim2.new(0,20,1,0),UDim2.new(1, -22,0,0),v15.DIM,9,Enum.TextXAlignment.Center)
    local v1749=v16:frame(v1736,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10))
    v1749.LayoutOrder=v1739 + 2
    v1749.Visible=false
    v16:corner(v1749,5)
    v16:stroke(v1749,v15.STROKE,1)
    local v1752=v16:scroll(v1749)
    v16:list(v1752,2)
    v16:pad(v1752,2,2,2,2)
    local v1753=false
    local function v1754() for v3255,v3256 in ipairs(v1752:GetChildren()) do if v3256:IsA("GuiObject") then v3256:Destroy()
            end end local v2563={}
    if _G._NH_BUILTIN_TEAMS then for v3977,v3978 in ipairs(_G._NH_BUILTIN_TEAMS) do table.insert(v2563,v3978.name)
        end end for v3257 in pairs(v33.petTeams) do table.insert(v2563,v3257)
end table.sort(v2563)
if ( #v2563==0) then local v3715=v16:label(v1752," (save a team first)",UDim2.new(1,0,0,22),nil,v15.DIM,9)
v3715.LayoutOrder=1
return 1
end local v2564=v33.autoHatch[v1738]==nil
local v2565=v16:button(v1752,"None",UDim2.new(1,0,0,22),nil,(v2564 and v15.SEL_BG) or Color3.fromRGB(14,14,14) ,(v2564 and v15.SEL_TXT) or v15.TEXT ,9)
v2565.LayoutOrder=0
v2565.TextXAlignment=Enum.TextXAlignment.Left
v16:pad(v2565,0,8,0,0)
v16:stroke(v2565,(v2564 and v15.ACCENT) or v15.STROKE ,1)
v2565.MouseButton1Click:Connect(function() v33.autoHatch[v1738]=nil
    v37()
    v1746.Text="None selected"
    v1749.Visible=false
    v1753=false
end)
for v3261,v3262 in ipairs(v2563) do local v3263=v33.autoHatch[v1738]==v3262
local v3264=false
if _G._NH_BUILTIN_TEAMS then for v4197,v4198 in ipairs(_G._NH_BUILTIN_TEAMS) do if (v4198.name==v3262) then v3264=true
            break
        end end end local v3265=(v3264 and Color3.fromRGB(40,20,80)) or Color3.fromRGB(14,14,14)
local v3266=(v3264 and Color3.fromRGB(180,160,255)) or v15.TEXT
local v3267=(v3264 and Color3.fromRGB(80,60,160)) or v15.STROKE
if v3263 then v3265=(v3264 and Color3.fromRGB(80,50,160)) or v15.SEL_BG
    v3266=v15.SEL_TXT
    v3267=(v3264 and Color3.fromRGB(160,120,255)) or v15.ACCENT
end local v3268=v16:button(v1752,v3262,UDim2.new(1,0,0,22),nil,v3265,v3266,9)
v3268.LayoutOrder=v3261
v3268.TextXAlignment=Enum.TextXAlignment.Left
v16:pad(v3268,0,8,0,0)
v16:stroke(v3268,v3267,1)
if v3264 then local v3980=Instance.new("ImageLabel",v3268)
    v3980.Size=UDim2.new(0,16,0,16)
    v3980.Position=UDim2.new(1, -20,0.5, -8)
    v3980.BackgroundTransparency=1
    v3980.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150"
    v3980.ScaleType=Enum.ScaleType.Fit
    v3980.ZIndex=v3268.ZIndex + 1
end v3268.MouseButton1Click:Connect(function() v33.autoHatch[v1738]=v3262
v37()
v1746.Text=v3262
v1749.Visible=false
v1753=false
end)
end return #v2563 + 1
end v1746.MouseButton1Click:Connect(function() v1753= not v1753
v1749.Visible=v1753
if v1753 then local v3720=v1754()
    v1749.Size=UDim2.new(1,0,0,math.min((v3720 * 24) + 6 ,130))
end end)
if _G._NH_ddRefs then table.insert(_G._NH_ddRefs,{Refresh=function() v1746.Text=v33.autoHatch[v1738] or "None selected"
end})
end return v1746
end local v623={}
do local v1755={}
for v2570,v2571 in ipairs(v17) do local v2572=v2571.egg
    if (v2572 and not v1755[v2572]) then v1755[v2572]=true
        table.insert(v623,{key=v2572,name=v2572})
    end end table.sort(v623,function(v2573,v2574) return v2573.name=1)) then v33.autoHatch.eggCount=math.floor(v1758)
    v37()
else v633.Text=tostring(v33.autoHatch.eggCount)
end end)
v635.FocusLost:Connect(function() local v1759=tonumber(v635.Text)
if (v1759 and (v1759>=1)) then v33.autoHatch.eggSpacing=v1759
    v37()
else v635.Text=tostring(v33.autoHatch.eggSpacing)
end end)
v16:divider(v621,4)
local v636=v622(v621,"CD Team (Reduce cooldown)","teamCD",5)
local v637=v622(v621,"Koi Team ","teamKoi",8)
local v638=v622(v621,"Seal Team (Sell)","teamSeal",11)
local v639=v622(v621,"Bronto Team (Heavy hatch)","teamBronto",14)
v16:divider(v621,17)
local v640=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v640.LayoutOrder=18
v16:corner(v640,5)
v16:stroke(v640,v15.STROKE,1)
v16:label(v640,"Bronto threshold (kg)",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v643=v16:input(v640,v33.autoHatch.brontoThresh,"",UDim2.new(0,46,0,20),UDim2.new(1, -72,0.5, -10))
v643.FocusLost:Connect(function() local v1760=tonumber(v643.Text)
    if (v1760 and (v1760>=0)) then v33.autoHatch.brontoThresh=v1760
        v37()
    else v643.Text=tostring(v33.autoHatch.brontoThresh)
end end)
v16:divider(v621,15)
local v644=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v644.LayoutOrder=20
v16:corner(v644,5)
v16:stroke(v644,v15.STROKE,1)
v16:label(v644,"Egg ESP",UDim2.new(1, -60,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
v16:toggle(v644,UDim2.new(1, -52,0.5, -11),v33.autoHatch.espEnabled,function(v1761) v33.autoHatch.espEnabled=v1761
    v37()
    v198()
end)
if (v33.autoHatch.suppressPPOnTeam==nil) then v33.autoHatch.suppressPPOnTeam=true
end local v648=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v648.LayoutOrder=20
v16:corner(v648,5)
v16:stroke(v648,v15.STROKE,1)
v16:label(v648,"Don't Pick-Place saat Koi/Bronto/Seal active",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
v16:toggle(v648,UDim2.new(1, -48,0.5, -11),v33.autoHatch.suppressPPOnTeam,function(v1763) v33.autoHatch.suppressPPOnTeam=v1763
    v37()
    if not v1763 then v202=false
        _G.AH_SuppressPickPlace=false
    end end)
do local v1765=v33.autoHatch.specialBronto
local v1766=v16:frame(v621,UDim2.new(1,0,0,1),nil,v15.STROKE)
v1766.LayoutOrder=19
local v1768=v16:label(v621,"🌟 SPECIAL PET TO BRONTO",UDim2.new(1,0,0,16),nil,v15.ACCENT,9)
v1768.LayoutOrder=190
v1768.Font=Enum.Font.GothamBold
local v1772=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v1772.LayoutOrder=191
v16:corner(v1772,5)
v16:stroke(v1772,v15.STROKE,1)
v16:label(v1772,"Enable Special Pet to Bronto",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
v16:toggle(v1772,UDim2.new(1, -48,0.5, -11),v1765.enabled,function(v2576) v1765.enabled=v2576
    v37()
end)
local v1775=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v1775.LayoutOrder=192
v16:corner(v1775,5)
v16:stroke(v1775,v15.STROKE,1)
local v1777=v16:label(v1775,"Pets: NONE",UDim2.new(1, -96,1,0),UDim2.new(0,6,0,0),v15.DIM,9)
v1777.Font=Enum.Font.Gotham
local v1780=v16:button(v1775,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9)
v16:stroke(v1780,v15.STROKE,1)
local function v1781() local v2578=0
    for v3278 in pairs(v1765.pets) do v2578=v2578 + 1
    end if (v2578==0) then v1777.Text="Pets: NONE"
    v1777.TextColor3=v15.DIM
else v1777.Text="Pets: " .. v2578 .. " selected"
v1777.TextColor3=v15.ACCENT
end end v1781()
local v1782=v16:frame(v179,UDim2.new(1,0,1,0),nil,v15.BG)
v1782.Visible=false
v1782.ZIndex=25
local v1785=v16:frame(v1782,UDim2.new(1,0,0,26),nil,v15.PANEL)
v16:stroke(v1785,v15.STROKE,1)
v16:label(v1785,"Select Special Pets to Bronto",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10)
local v1786=v16:button(v1785,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8)
v16:stroke(v1786,v15.STROKE,1)
local v1787=v16:button(v1785,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10)
v16:stroke(v1787,v15.ERROR,1)
v1787.MouseButton1Click:Connect(function() v1782.Visible=false
    v1781()
end)
local v1788=v16:input(v1782,"","Search pet or egg...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v1788.TextColor3=v15.TEXT
v1788.Font=Enum.Font.Gotham
local v1792=v16:scroll(v1782,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
v16:list(v1792,3)
v16:pad(v1792,3,4,4,3)
local function v1793() local v2580=string.lower(v1788.Text)
    local v2581={}
    for v3279,v3280 in ipairs(v17) do if ((v2580=="") or v3280.name:lower():find(v2580,1,true) or v3280.egg:lower():find(v2580,1,true)) then table.insert(v2581,v3280)
        end end return v2581
end local function v1794() for v3281,v3282 in ipairs(v1792:GetChildren()) do if v3282:IsA("GuiObject") then v3282:Destroy()
    end end local v2582=v1793()
local v2583= #v2582>0
for v3283,v3284 in ipairs(v2582) do if not v1765.pets[v3284.name] then v2583=false
        break
    end end v1786.Text=(( #v2582==0) and "Select All") or (v2583 and "Unselect All") or "Select All"
v1786.TextColor3=(v2583 and v15.SEL_TXT) or v15.ACCENT
v1786.BackgroundColor3=(v2583 and v15.SEL_BG) or v15.BTN
for v3285,v3286 in ipairs(v2582) do local v3287=v1765.pets[v3286.name]==true
    local v3288=v16:button(v1792,v3286.name,UDim2.new(1,0,0,30),nil,(v3287 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v3287 and v15.SEL_TXT) or v15.TEXT ,9)
    v3288.LayoutOrder=v3285
    v3288.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v3288,0,8,4,0)
    v16:corner(v3288,5)
    v16:stroke(v3288,(v3287 and v15.ACCENT) or v15.STROKE ,1)
    v16:label(v3288,v3286.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v3287 and Color3.fromRGB(60,40,0)) or v15.DIM ,8).Font=Enum.Font.Gotham
    v3288.MouseButton1Click:Connect(function() if v1765.pets[v3286.name] then v1765.pets[v3286.name]=nil
        else v1765.pets[v3286.name]=true
    end v37()
v1781()
v16:updateRowVisualWithSub(v3288,v1765.pets[v3286.name]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE,Color3.fromRGB(60,40,0),v15.DIM)
end)
end end v1786.MouseButton1Click:Connect(function() local v2587=v1793()
local v2588= #v2587>0
for v3294,v3295 in ipairs(v2587) do if not v1765.pets[v3295.name] then v2588=false
        break
    end end if v2588 then for v3988,v3989 in ipairs(v2587) do v1765.pets[v3989.name]=nil
end else for v3991,v3992 in ipairs(v2587) do v1765.pets[v3992.name]=true
end end v37()
v1781()
v1794()
end)
v1788:GetPropertyChangedSignal("Text"):Connect(v1794)
v1780.MouseButton1Click:Connect(function() v1782.Visible=true
    v1794()
end)
end local v651,v652=v16:timingEditor(v621,v179,v24,v33,v37)
v651.LayoutOrder=21
v651.Text="⏱ Timing Editor "
v651.TextXAlignment=Enum.TextXAlignment.Center
if not v33.autoHatch.afInterval then v33.autoHatch.afInterval=30
end if (v33.autoHatch.afEnabled==nil) then v33.autoHatch.afEnabled=false
end local v657=v16:frame(v621,UDim2.new(1,0,0,26),nil,v15.BTN)
v657.LayoutOrder=21
v16:corner(v657,5)
v16:stroke(v657,v15.STROKE,1)
v16:label(v657,"Auto Feed (sec)",UDim2.new(0,90,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v660=v16:input(v657,v33.autoHatch.afInterval,"",UDim2.new(0,40,0,20),UDim2.new(0,100,0.5, -10))
v660.FocusLost:Connect(function() local v1795=tonumber(v660.Text)
    if (v1795 and (v1795>=1)) then v33.autoHatch.afInterval=v1795
        v37()
    else v660.Text=tostring(v33.autoHatch.afInterval)
end end)
local v661=false
local v662=nil
local v663=v2:WaitForChild("GameEvents"):WaitForChild("ActivePetService")
local function v664() for v2592,v2593 in ipairs(v8:GetChildren()) do if (v2593:IsA("Tool") and v5:HasTag(v2593,"FruitTool") and (v2593:GetAttribute(v21)~=true)) then return v2593
        end end for v2594,v2595 in ipairs(v9:GetChildren()) do if (v2595:IsA("Tool") and v5:HasTag(v2595,"FruitTool") and (v2595:GetAttribute(v21)~=true)) then return v2595
    end end return nil
end local function v665(v1796) local v1797,v1798=pcall(function() return v10:GetData()
end)
if ( not v1797 or not v1798 or not v1798.PetsData) then return 1
end local v1799=v1798.PetsData.PetInventory and v1798.PetsData.PetInventory.Data
if ( not v1799 or not v1799[v1796]) then return 1
end local v1800=v1799[v1796].PetData
if not v1800 then return 1
end local v1801=v1800.Hunger or 0
local v1802=100
local v1803,v1804=pcall(function() return require(game:GetService("ReplicatedStorage").Data.PetRegistry).PetList
end)
if (v1803 and v1804 and v1804[v1799[v1796].PetType]) then v1802=v1804[v1799[v1796].PetType].DefaultHunger or 100
end return v1801/v1802
end local function v666() local v1805=v83()
local v1806={}
for v2596,v2597 in ipairs(v1805) do table.insert(v1806,{uuid=v2597,pct=v665(v2597)})
end table.sort(v1806,function(v2598,v2599) return v2598.pct0)) then v43.startTime=v4003.AH.startTime or os.time()
    v43.cycleCount=v4003.AH.cycleCount or 0
    v43.totalHatched=v4003.AH.totalHatched or 0
    v43.eggBefore=v4003.AH.eggBefore or 0
    v43.eggCurrent=v4003.AH.eggCurrent or 0
    v43.koiProc=v4003.AH.koiProc or 0
    v43.sealProc=v4003.AH.sealProc or 0
    v43.koiLastCycle=v4003.AH.koiLastCycle or 0
    v43.sealLastCycle=v4003.AH.sealLastCycle or 0
    v43.petTypes=v4003.AH.petTypes or {}
    for v4386,v4387 in pairs(v43.petTypes) do if ( not v4387.minKG or (v4387.minKG==0)) then v4387.minKG=math.huge
        end end v43.specials=v4003.AH.specials or {huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}
v3302=true
v669("══ CONTINUE SESSION (cycle " .. v43.cycleCount .. ") ══" ,v15.PHASE2)
end end if not v3302 then v43.startTime=os.time()
v43.cycleCount=0
v43.totalHatched=0
v43.koiProc=0
v43.sealProc=0
v43.koiLastCycle=0
v43.sealLastCycle=0
v43.petTypes={}
v43.specials={huge={count=0,pets={}},titan={count=0,pets={}},godly={count=0,pets={}}}
v43.eggCurrent=0
v43.eggBefore=0
for v4202,v4203 in ipairs(v8:GetChildren()) do if (v4203:IsA("Tool") and v5:HasTag(v4203,"PetEggTool")) then if (v4203:GetAttribute("h")==v33.autoHatch.eggName) then local v4493=tonumber(v4203.Name:match("x(%d+)$")) or 1
            v43.eggBefore=v43.eggBefore + v4493
        end end end v48()
end v669("════ AUTO HATCH START ════",v15.ACCENT)
v677("Starting...",v15.SUCCESS)
v200=task.spawn(function() local v3733=v43.cycleCount
    while v199 do v3733=v3733 + 1
        v43.cycleCount=v3733
        v214()
        v669(string.format("── Cycle %d ──",v3733),v15.ACCENT)
        v677(string.format("Cycle %d",v3733),v15.SUCCESS)
        local v4016,v4017=pcall(v215,v669,v677)
        if not v4016 then v669("Error: " .. tostring(v4017) ,v15.ERROR)
            v677("Error!",v15.ERROR)
            task.wait(3)
        end if not v199 then break
    end task.wait(1)
end v669("─── Stopped ───",v15.ERROR)
v677("● IDLE",v15.DIM)
end)
else v199=false
v669("─── Stopped by user ───",v15.ERROR)
v677("● IDLE",v15.DIM)
end end)
local v678=v16:accordion(v616,"💰 SELL SETTINGS",20,false)
local v679=v678.Inner
local v680=v16:frame(v679,UDim2.new(1,0,0,26),nil,v15.BTN)
v680.LayoutOrder=1
v16:corner(v680,5)
v16:stroke(v680,v15.STROKE,1)
v16:label(v680,"Sell below (kg)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v683=v16:input(v680,v33.autoHatch.sellThresh,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v683.FocusLost:Connect(function() local v1818=tonumber(v683.Text)
    if (v1818 and (v1818>=0)) then v33.autoHatch.sellThresh=v1818
        v37()
    else v683.Text=tostring(v33.autoHatch.sellThresh)
end end)
local v684=v16:frame(v679,UDim2.new(1,0,0,26),nil,v15.BTN)
v684.LayoutOrder=1
v16:corner(v684,5)
v16:stroke(v684,v15.STROKE,1)
v16:label(v684,"Fav delay (sec)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham
local v687=v16:input(v684,v33.autoHatch.favDelay,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10))
v687.FocusLost:Connect(function() local v1819=tonumber(v687.Text)
    if (v1819 and (v1819>=0)) then v33.autoHatch.favDelay=v1819
        v37()
    else v687.Text=tostring(v33.autoHatch.favDelay)
end end)
local v688=v16:frame(v679,UDim2.new(1,0,0,26),nil,v15.BTN)
v688.LayoutOrder=2
v16:corner(v688,5)
v16:stroke(v688,v15.STROKE,1)
v16:label(v688,"Auto Sell ONLY When Inventory Full",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold
local v691=v16:input(v688,v33.autoHatch.petInvMax,"",UDim2.new(0,40,0,20),UDim2.new(1, -94,0.5, -10))
v691.FocusLost:Connect(function() local v1820=tonumber(v691.Text)
    if (v1820 and (v1820>=1)) then v33.autoHatch.petInvMax=v1820
        v37()
    else v691.Text=tostring(v33.autoHatch.petInvMax)
end end)
v16:toggle(v688,UDim2.new(1, -52,0.5, -11),v33.autoHatch.autoSellWhenFull,function(v1821) v33.autoHatch.autoSellWhenFull=v1821
v37()
end)
local v692=v16:frame(v679,UDim2.new(1,0,0,26),nil,v15.BTN)
v692.LayoutOrder=3
v16:corner(v692,5)
v16:stroke(v692,v15.STROKE,1)
local v694=v16:label(v692,"Sell pets: NONE",UDim2.new(1, -100,1,0),UDim2.new(0,6,0,0),v15.DIM,9)
v694.Font=Enum.Font.Gotham
local v696=v16:button(v692,"Select pets >",UDim2.new(0,90,0,20),UDim2.new(1, -94,0.5, -10),v15.BTN,v15.ACCENT,9)
v16:stroke(v696,v15.STROKE,1)
local function v697() local v1823=0
    for v2601 in pairs(v33.autoHatch.sellPets) do v1823=v1823 + 1
    end if (v1823==0) then v694.Text="Sell pets: NONE"
    v694.TextColor3=v15.DIM
else v694.Text="Sell pets: " .. v1823 .. " selected"
v694.TextColor3=v15.ACCENT
end end v697()
local v698=v16:frame(v179,UDim2.new(1,0,1,0),nil,v15.BG)
v698.Visible=false
v698.ZIndex=25
local v701=v16:frame(v698,UDim2.new(1,0,0,26),nil,v15.PANEL)
v16:stroke(v701,v15.STROKE,1)
v16:label(v701,"Select pets to SELL",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10)
local v702=v16:button(v701,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8)
v16:stroke(v702,v15.STROKE,1)
local v703=v16:button(v701,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10)
v16:stroke(v703,v15.ERROR,1)
v703.MouseButton1Click:Connect(function() v698.Visible=false
    v697()
end)
local v704=v16:input(v698,"","Search pet or egg...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28))
v704.TextColor3=v15.TEXT
v704.Font=Enum.Font.Gotham
local v708=v16:scroll(v698,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54))
v16:list(v708,3)
v16:pad(v708,3,4,4,3)
local function v709() local v1825=string.lower(v704.Text)
    local v1826={}
    for v2602,v2603 in ipairs(v17) do if ((v1825=="") or v2603.name:lower():find(v1825,1,true) or v2603.egg:lower():find(v1825,1,true)) then table.insert(v1826,v2603)
        end end return v1826
end local function v710() for v2604,v2605 in ipairs(v708:GetChildren()) do if v2605:IsA("GuiObject") then v2605:Destroy()
    end end local v1827=v709()
local v1828= #v1827>0
for v2606,v2607 in ipairs(v1827) do if not v33.autoHatch.sellPets[v2607.name] then v1828=false
        break
    end end v702.Text=(( #v1827==0) and "Select All") or (v1828 and "Unselect All") or "Select All"
v702.TextColor3=(v1828 and v15.SEL_TXT) or v15.ACCENT
v702.BackgroundColor3=(v1828 and v15.SEL_BG) or v15.BTN
for v2608,v2609 in ipairs(v1827) do local v2610=v33.autoHatch.sellPets[v2609.name]==true
    local v2611=v16:button(v708,v2609.name,UDim2.new(1,0,0,30),nil,(v2610 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2610 and v15.SEL_TXT) or v15.TEXT ,10)
    v2611.LayoutOrder=v2608
    v2611.TextXAlignment=Enum.TextXAlignment.Left
    v16:pad(v2611,0,8,4,0)
    v16:corner(v2611,5)
    v16:stroke(v2611,(v2610 and v15.ACCENT) or v15.STROKE ,1)
    v16:label(v2611,v2609.egg,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v2610 and Color3.fromRGB(60,40,0)) or v15.DIM ,8).Font=Enum.Font.Gotham
    v2611.MouseButton1Click:Connect(function() if v33.autoHatch.sellPets[v2609.name] then v33.autoHatch.sellPets[v2609.name]=nil
        else v33.autoHatch.sellPets[v2609.name]=true
    end v37()
v697()
v16:updateRowVisualWithSub(v2611,v33.autoHatch.sellPets[v2609.name]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE,Color3.fromRGB(60,40,0),v15.DIM)
end)
end end v702.MouseButton1Click:Connect(function() local v1832=v709()
local v1833= #v1832>0
for v2617,v2618 in ipairs(v1832) do if not v33.autoHatch.sellPets[v2618.name] then v1833=false
        break
    end end if v1833 then for v3734,v3735 in ipairs(v1832) do v33.autoHatch.sellPets[v3735.name]=nil
end else for v3737,v3738 in ipairs(v1832) do v33.autoHatch.sellPets[v3738.name]=true
end end v37()
v697()
v710()
end)
v704:GetPropertyChangedSignal("Text"):Connect(v710)
v696.MouseButton1Click:Connect(function() v698.Visible=true
    v710()
end)
v669("Auto Hatch ready!",v15.SUCCESS)
end v216()
local v217=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v217.Visible=false
local v219=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v219.Visible=false
local v221=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v221.Visible=false
local v223=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v223.Visible=false
local v225=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v225.Visible=false
local v227=v16:frame(v178,UDim2.new(1,0,1,0),nil,v15.BG,1)
v227.Visible=false
local v229={{v170,"autohatch"},{v171,"elephant"},{v172,"leveling"},{v173,"teams"},{v174,"pickplace"},{v175,"petboost"},{v176,"webhook"},{v177,"misc"}}
local function v230(v711) v179.Visible=v711=="autohatch"
    v217.Visible=v711=="elephant"
    v219.Visible=v711=="leveling"
    v221.Visible=v711=="teams"
    v223.Visible=v711=="pickplace"
    v225.Visible=v711=="petboost"
    v227.Visible=v711=="webhook"
    v181.Visible=v711=="misc"
    for v1835,v1836 in ipairs(v229) do v1836[1].SetActive(v1836[2]==v711 )
    end end v170.Button.MouseButton1Click:Connect(function() v230("autohatch")
end)
v171.Button.MouseButton1Click:Connect(function() v230("elephant")
end)
v172.Button.MouseButton1Click:Connect(function() v230("leveling")
end)
v173.Button.MouseButton1Click:Connect(function() v230("teams")
end)
v174.Button.MouseButton1Click:Connect(function() v230("pickplace")
end)
v175.Button.MouseButton1Click:Connect(function() v230("petboost")
end)
v176.Button.MouseButton1Click:Connect(function() v230("webhook")
end)
v177.Button.MouseButton1Click:Connect(function() v230("misc")
end)
local v231=v16:scroll(v219,UDim2.new(1,0,1,0))
v231.ScrollingDirection=Enum.ScrollingDirection.Y
v231.AutomaticCanvasSize=Enum.AutomaticSize.Y
v231.CanvasSize=UDim2.new(0,0,0,0)
v16:list(v231,6)
v16:pad(v231,4,4,4,8)
_G.HH_Shared={V=v16,T=v15,D=v33,CFG=v24,Player=v7,Backpack=v8,Char=v9,MUTATION_MAP=v19,saveD=v37,getInv=v60,getKG=v61,getAge=v62,getBase=v63,getPType=v64,isFav=v65,findPetTool=v66,getMutName=v67,unequipAll=v91,equipList=v93,buildEquip=v95,waitUntilEquipped=v94,getActivePets=v83,getFarmCF=v92,PetsRemote=v12,FavRemote=v183,SellAllRemote=v184,DataService=v10,htTrack=v29,UI=v14,outerScroll=v231,PageLeveling=v219,_buildTeamDD=v40,getTeamUUIDs=v39}
loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=leveling",true))()
loadstring(game:HttpGet("https://hydra-checker.vercel.app/api/module?name=nightmare",true))()
local function v235() local v720=false
    local v721=1
    local v722=v2:WaitForChild("GameEvents"):WaitForChild("PetShardService_RE")
    local v723=game:GetService("CollectionService")
    local function v724(v1837) if not v1837 then return nil
        end return v1837:gsub("[{}]",""):lower()
end local function v725(v1838) local v1839,v1840=pcall(function() return v10:GetData()
end)
if ( not v1839 or not v1840 or not v1840.PetsData) then return nil
end local v1841=v1840.PetsData.PetInventory.Data[v1838]
if ( not v1841 or not v1841.PetData) then return nil
end local v1842=v1841.PetData.MutationType
if ( not v1842 or (v1842=="") or (v1842=="m")) then return nil
end return v1842
end local function v726() local v1843=workspace:FindFirstChild("Farm")
if v1843 then local v3315=v1843:FindFirstChild(v7.Name)
    if v3315 then local v4020=v3315:FindFirstChild("PetArea")
        if v4020 then return v4020.CFrame
        end end end return v23
end local function v727(v1844) local v1845=workspace:FindFirstChild("PetsPhysical")
if not v1845 then return nil
end for v2619,v2620 in ipairs(v1845:GetChildren()) do if (v724(v2620:GetAttribute("UUID"))==v1844) then return v2620
end end return nil
end local function v728(v1846,v1847) local v1848=0
while v1848",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v769,v15.STROKE,1);local v770,v771=v16:logPanel(v732,10,45);local v772=v16:frame(v732,UDim2.new(1,0,0,36),nil,v15.PANEL);v772.LayoutOrder=11;v16:stroke(v772,v15.STROKE,1);v16:label(v772,"AUTO EVERCHANTED",UDim2.new(0,120,0,20),UDim2.new(0,8,0.5, -10),v15.TEXT,10).Font=Enum.Font.GothamBold;local v775=v16:label(v772,"● IDLE",UDim2.new(1, -180,1,0),UDim2.new(0,124,0,0),v15.DIM,9);v775.Font=Enum.Font.Gotham;v775.TextTruncate=Enum.TextTruncate.AtEnd;local function v779(v1863,v1864) v775.Text=v1863;v775.TextColor3=v1864 or v15.DIM ;end local v780=false;v740.MouseButton1Click:Connect(function() v780= not v780;v743.Visible=v780;if v780 then local v3318=v733(v746,function(v3743) v33.autoEV.pvTeam=v3743;v37();v740.Text=v3743;v743.Visible=false;v780=false;end,v33.autoEV.pvTeam);v743.Size=UDim2.new(1,0,0,math.min((v3318 * 24) + 6 ,130));end end);local v781=false;v752.MouseButton1Click:Connect(function() v781= not v781;v743.Visible=false;v780=false;v754.Visible=v781;if v781 then local v3320=v733(v757,function(v3747) v33.autoEV.lvTeam=v3747;v37();v752.Text=v3747;v754.Visible=false;v781=false;end,v33.autoEV.lvTeam);v754.Size=UDim2.new(1,0,0,math.min((v3320 * 24) + 6 ,130));end end);local v782=v16:frame(v219,UDim2.new(1,0,1,0),nil,v15.BG);v782.Visible=false;v782.ZIndex=20;local v785=v16:frame(v782,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v785,v15.STROKE,1);v16:label(v785,"Select Target Pets (Everchanted)",UDim2.new(1, -118,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v786=v16:button(v785,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v786,v15.STROKE,1);local v787=v16:button(v785,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v787,v15.ERROR,1);v787.MouseButton1Click:Connect(function() v782.Visible=false;v767.Text="Target pets: " .. #v33.autoEV.targets ;end);local v788=v16:input(v782,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v788.TextColor3=v15.TEXT;v788.Font=Enum.Font.Gotham;local v792=v16:scroll(v782,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v792,3);v16:pad(v792,3,4,4,3);local function v793() local v1872=string.lower(v788.Text);local v1873=v60();local v1874={};for v2629 in pairs(v1873) do table.insert(v1874,v2629);end table.sort(v1874,function(v2630,v2631) return v61(v2630)>v61(v2631) ;end);local v1875={};for v2632,v2633 in ipairs(v1874) do local v2634=v1873[v2633];if not v2634 then continue;end if ((v1872=="") or string.lower(v2634.PetType or "" ):find(v1872,1,true)) then table.insert(v1875,v2633);end end return v1875;end local function v794() for v2635,v2636 in ipairs(v792:GetChildren()) do if v2636:IsA("GuiObject") then v2636:Destroy();end end local v1876=v60();local v1877=v793();local v1878= #v1877>0 ;for v2637,v2638 in ipairs(v1877) do if not table.find(v33.autoEV.targets,v2638) then v1878=false;break;end end v786.Text=(( #v1877==0) and "Select All") or (v1878 and "Unselect All") or "Select All" ;v786.TextColor3=(v1878 and v15.SEL_TXT) or v15.ACCENT ;v786.BackgroundColor3=(v1878 and v15.SEL_BG) or v15.BTN ;for v2639,v2640 in ipairs(v1877) do local v2641=v1876[v2640];if not v2641 then continue;end local v2642=table.find(v33.autoEV.targets,v2640)~=nil ;local v2643=(v2641.PetData and (v2641.PetData.Level or 0)) or 0 ;local v2644=v61(v2640);local v2645=(v2641.PetData and (v2641.PetData.BaseWeight or 0)) or 0 ;local v2646=(v65(v2640) and " ❤") or "" ;local v2647=v725(v2640);local v2648=(v2647 and (" [" .. (v19[v2647] or v2647) .. "]")) or "" ;local v2649=((v2648~="") and string.format('%s',v2648)) or "" ;local v2650=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2641.PetType or "?" ,v2649,v2646,v2643,v2644,v2645);local v2651=v16:button(v792,v2650,UDim2.new(1,0,0,22),nil,(v2642 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2642 and v15.SEL_TXT) or v15.TEXT ,9);v2651.LayoutOrder=v2639;v2651:SetAttribute("uuid",v2640);v2651.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2651,0,8,4,0);v16:stroke(v2651,(v2642 and v15.ACCENT) or v15.STROKE ,1);v2651.MouseButton1Click:Connect(function() local v3322=table.find(v33.autoEV.targets,v2640);if v3322 then table.remove(v33.autoEV.targets,v3322);else table.insert(v33.autoEV.targets,v2640);end v37();v767.Text="Target pets: " .. #v33.autoEV.targets ;local v3324=table.find(v33.autoEV.targets,v2640)~=nil ;v16:updateRowVisual(v2651,v3324,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);local v3325=v793();local v3326= #v3325>0 ;for v3751,v3752 in ipairs(v3325) do if not table.find(v33.autoEV.targets,v3752) then v3326=false;break;end end v786.Text=(( #v3325==0) and "Select All") or (v3326 and "Unselect All") or "Select All" ;v786.TextColor3=(v3326 and v15.SEL_TXT) or v15.ACCENT ;v786.BackgroundColor3=(v3326 and v15.SEL_BG) or v15.BTN ;end);end end v786.MouseButton1Click:Connect(function() local v1882=v793();local v1883= #v1882>0 ;for v2655,v2656 in ipairs(v1882) do if not table.find(v33.autoEV.targets,v2656) then v1883=false;break;end end if v1883 then for v3753,v3754 in ipairs(v1882) do local v3755=table.find(v33.autoEV.targets,v3754);if v3755 then table.remove(v33.autoEV.targets,v3755);end end else for v3756,v3757 in ipairs(v1882) do if not table.find(v33.autoEV.targets,v3757) then table.insert(v33.autoEV.targets,v3757);end end end v37();v767.Text="Target pets: " .. #v33.autoEV.targets ;v794();end);v788:GetPropertyChangedSignal("Text"):Connect(v794);v769.MouseButton1Click:Connect(function() v782.Visible=true;v794();end);local function v795(v1886,v1887) local v1888=v39(v33.autoEV.pvTeam);local v1889=v39(v33.autoEV.lvTeam);local v1890={};for v2657,v2658 in ipairs(v33.autoEV.targets) do table.insert(v1890,v2658);end for v2659,v2660 in ipairs(v1890) do if not v720 then break;end if not v60()[v2660] then v1886(string.format("[%d/%d] Skip — not in inventory",v2659, #v1890),v15.DIM);continue;end local v2661=v64(v2660);v1886(string.format("[%d/%d] START %s",v2659, #v1890,v2661),v15.ACCENT);if v33.autoEV.autoCleanseFirst then local v3758=v725(v2660);if ((v3758~=nil) and (v3758~="EV")) then v1886(string.format("Auto cleanse: mut=%s, cleansing dulu...",v19[v3758] or v3758 ),v15.DIM);v1887("Pre-cleansing " .. v2661 ,v15.DIM);v730(v2660,v1886);task.wait(1);v91();elseif (v3758=="EV") then v1886("Pet sudah EV, skip cleanse.",v15.DIM);else v1886("Tidak ada mutation, skip cleanse.",v15.DIM);end end local v2662=false;local v2663=0;while v720 and not v2662 do v2663+=1 v1886(string.format("Attempt %d — equip Peryton team",v2663),v15.DIM);v1887(string.format("A%d | %s",v2663,v2661),v15.DIM);v91();task.wait(0.5);local v3330={v2660};for v3759,v3760 in ipairs(v1888) do if ( #v3330>=8) then break;end if (v3760~=v2660) then table.insert(v3330,v3760);end end v93(v3330);local v3331=v725(v2660);v1886(string.format("Watching... prevMut=%s",tostring(v3331)),v15.DIM);v1887(string.format("Waiting skill | %s",v2661),Color3.fromRGB(100,200,255));while v720 do task.wait(v721);local v3761=v725(v2660);if (v3761~=v3331) then v1886(string.format("Skill landed! mut=%s",tostring(v3761)),v15.SUCCESS);if (v3761=="EV") then v1886("✓ EVERCHANTED DAPET! " .. v2661 ,v15.SUCCESS);v1887("✓ Everchanted! " .. v2661 ,v15.SUCCESS);v2662=true;v91();else local v4388=(v3761 and (v19[v3761] or v3761)) or "none" ;v1886(string.format("Dapat %s, bukan Everchanted — cleanse & retry",v4388),v15.ERROR);v1887("Cleansing " .. v2661 ,v15.DIM);v730(v2660,v1886);task.wait(1);v91();end break;end end end if v2662 then if (v33.autoEV.levelTo100 and ( #v1889>0)) then v1886("Level to 100: " .. v2661 ,v15.ACCENT);v1887(string.format("Leveling %s to 100",v2661),v15.ACCENT);v91();task.wait(0.5);v93(v95(v2660,v1889));while v720 do task.wait(v24.POLL_RATE);local v4299=v62(v2660);v1887(string.format("Lv%d/100 | %s",v4299,v2661),v15.DIM);if (v4299>=100) then v1886(string.format("✓ Lv100 done! %s",v2661),v15.SUCCESS);v91();break;end end elseif (v33.autoEV.levelTo100 and ( #v1889==0)) then v1886("⚠ Level to 100 ON tapi Leveling Team belum di-set!",v15.ERROR);end local v3762=table.find(v33.autoEV.targets,v2660);if v3762 then table.remove(v33.autoEV.targets,v3762);v37();end v767.Text="Target pets: " .. #v33.autoEV.targets ;v1886("Next pet...",v15.DIM);task.wait(1);end end v720=false;v1886("════ ALL DONE ════",v15.ACCENT);v1887("● IDLE",v15.DIM);end v16:toggle(v772,UDim2.new(1, -52,0.5, -11),false,function(v1891) if v1891 then if not v33.autoEV.pvTeam then v771("Set Peryton Team dulu!",v15.ERROR);return;end if ( #v33.autoEV.targets==0) then v771("Pilih target pets dulu!",v15.ERROR);return;end v720=true;v771("════ AUTO EVERCHANTED START ════",v15.ACCENT);v779("Starting...",v15.SUCCESS);task.spawn(function() v795(v771,v779);end);else v720=false;v771("─── Stopped ───",v15.ERROR);v779("● IDLE",v15.DIM);end end);v771("Auto Everchanted ready!",v15.SUCCESS);end v235();local function v236() local v796=false;local v797=2;local v798=false;local v799=false;local v800=false;local v801=nil;pcall(function() v801=require(v2.Data.TradeWorldData);end);local function v802() if not v801 then return false;end if (game.PlaceId~=v801.PlaceId) then if (v801.ForceInWorld~=true) then return false;else return true;end else return true;end end local v803=v2:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_SubmitHeld");local v804=v2:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Submit");local v805=v2:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Claim");local v806=v2:WaitForChild("GameEvents"):WaitForChild("PetAgeLimitBreak_Cancel");local v807=nil;pcall(function() v807=v2:WaitForChild("GameEvents"):WaitForChild("TradeWorld"):WaitForChild("TravelToTradeWorld",5);end);if not v33.autoAgeBreaker then v33.autoAgeBreaker={targets={},tumbalKgMax=2,tumbalAgeMax=99,skipEnabled=false,maxLevel=125};end if (v33.autoAgeBreaker.skipEnabled==nil) then v33.autoAgeBreaker.skipEnabled=false;end if (v33.autoAgeBreaker.maxLevel==nil) then v33.autoAgeBreaker.maxLevel=125;end local function v808() local v1892,v1893=pcall(function() return v10:GetData();end);if ( not v1892 or not v1893) then return nil;end return v1893.PetAgeBreakMachine;end local function v809(v1894) local v1895=v60();local v1896=v1895[v1894];if ( not v1896 or not v1896.PetData) then return "";end local v1897=v1896.PetData.MutationType or "" ;if ((v1897=="") or (v1897=="m")) then return "";end return v19[v1897] or v1897 ;end local function v810(v1898) for v2667,v2668 in ipairs(v9:GetChildren()) do if v2668:IsA("Tool") then v2668.Parent=v8;end end task.wait(0.3);local v1899=nil;local v1900=os.clock();while (os.clock() -v1900)<10 do v1899=v66(v1898);if v1899 then break;end task.wait(1);end if not v1899 then return false;end v1899.Parent=v9;task.wait(0.3);local v1902=v9:FindFirstChildOfClass("Humanoid");if v1902 then v1902:EquipTool(v1899);task.wait(0.3);end return true;end local function v811(v1903,v1904) local v1905=v60();local v1906=v1905[v1903];local v1907=v1904 or (v1906 and (v1906.PetType or "")) or v64(v1903) ;if ((v1907=="") or (v1907=="Unknown")) then return nil;end local v1908=v33.autoAgeBreaker.tumbalKgMax or 2 ;local v1909=v33.autoAgeBreaker.tumbalAgeMax or 99 ;local v1910={};for v2669,v2670 in pairs(v1905) do if (v2669==v1903) then continue;end if ( not v2670 or not v2670.PetData) then continue;end if (v2670.PetType~=v1907) then continue;end local v2671=v2670.PetData.Level or 0 ;local v2672=v2670.PetData.BaseWeight or 0 ;if (v2672>v1908) then continue;end if (v2671>v1909) then continue;end local v2673=false;do local v3332,v3333=pcall(function() return v10:GetData();end);if (v3332 and v3333 and v3333.PetsData) then local v4021=v3333.PetsData.PetInventory.Data[v2669];if (v4021 and v4021.PetData) then v2673=(v4021.PetData.Favorited==true) or (v4021.PetData.IsFavorite==true) ;end end end if (v2673 or v65(v2669)) then continue;end table.insert(v1910,{uuid=v2669,age=v2671,kg=v2672});end table.sort(v1910,function(v2674,v2675) if (v2674.kg~=v2675.kg) then return v2674.kg0) then return v1910[1].uuid;end abLog(string.format("Debug: targetType=%s kgMax=%.2f ageMax=%d",v1907,v1908,v1909),v15.DIM);local v1911=0;for v2676,v2677 in pairs(v1905) do if (v2676==v1903) then continue;end if ( not v2677 or not v2677.PetData) then continue;end if (v2677.PetType~=v1907) then continue;end v1911=v1911 + 1 ;local v2678=v2677.PetData.Level or 0 ;local v2679=v2677.PetData.BaseWeight or 0 ;abLog(string.format(" Candidate: Age %d BaseKG %.2f fav=%s",v2678,v2679,tostring(v65(v2676))),v15.DIM);end if (v1911==0) then abLog(string.format("Tidak ada pet tipe '%s' selain target!",v1907),v15.ERROR);end return nil;end local function v812(v1912) v800=true;v1912("Ensuring main world before claim...",v15.DIM);if not v802() then v1912("Sudah di main world.",v15.DIM);v800=false;return;end pcall(function() v2:WaitForChild("GameEvents"):WaitForChild("TradeWorld"):WaitForChild("TravelToMainWorld",5):FireServer();end);local v1913=os.clock();while v802() and ((os.clock() -v1913)<15) do task.wait(2);end v1912("Sudah di main world.",v15.SUCCESS);task.wait(2);v800=false;end local v813=v16:accordion(v231,"🔨 AUTO AGE BREAKER",4,false);local v814=v813.Inner;local v815=v16:frame(v814,UDim2.new(1,0,0,26),nil,v15.BTN);v815.LayoutOrder=1;v16:corner(v815,5);v16:stroke(v815,v15.STROKE,1);v16:label(v815,"Tumbal: Max Base KG",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v819=v16:input(v815,v33.autoAgeBreaker.tumbalKgMax,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v819.FocusLost:Connect(function() local v1914=tonumber(v819.Text);if (v1914 and (v1914>=0)) then v33.autoAgeBreaker.tumbalKgMax=v1914;v37();else v819.Text=tostring(v33.autoAgeBreaker.tumbalKgMax);end end);local v820=v16:frame(v814,UDim2.new(1,0,0,26),nil,v15.BTN);v820.LayoutOrder=2;v16:corner(v820,5);v16:stroke(v820,v15.STROKE,1);v16:label(v820,"Tumbal: Max Age (level)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v823=v16:input(v820,v33.autoAgeBreaker.tumbalAgeMax,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v823.FocusLost:Connect(function() local v1915=tonumber(v823.Text);if (v1915 and (v1915>=0)) then v33.autoAgeBreaker.tumbalAgeMax=v1915;v37();else v823.Text=tostring(v33.autoAgeBreaker.tumbalAgeMax);end end);local v824=v16:frame(v814,UDim2.new(1,0,0,26),nil,v15.BTN);v824.LayoutOrder=3;v16:corner(v824,5);v16:stroke(v824,v15.STROKE,1);v16:label(v824,"Target: Max Level",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v827=v16:input(v824,v33.autoAgeBreaker.maxLevel,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v827.FocusLost:Connect(function() local v1916=tonumber(v827.Text);if (v1916 and (v1916>=100) and (v1916<=125)) then v33.autoAgeBreaker.maxLevel=v1916;v37();else v827.Text=tostring(v33.autoAgeBreaker.maxLevel);end end);local v828=v16:frame(v814,UDim2.new(1,0,0,22),nil,v15.BG,1);v828.LayoutOrder=4;local v830=v16:label(v828,"Target pets: " .. #v33.autoAgeBreaker.targets ,UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v830.Font=Enum.Font.Gotham;local v832=v16:button(v828,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v832,v15.STROKE,1);local v833=v16:frame(v814,UDim2.new(1,0,0,26),nil,v15.BTN);v833.LayoutOrder=45;v16:corner(v833,5);v16:stroke(v833,v15.STROKE,1);v16:label(v833,"Manual Actions",UDim2.new(0,80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v836=v16:button(v833,"Claim",UDim2.new(0,54,0,20),UDim2.new(1, -118,0.5, -10),v15.BTN,v15.SUCCESS,9);do local v1917=Instance.new("UIStroke",v836);v1917.Color=v15.SUCCESS;v1917.Thickness=1;end local v837=v16:button(v833,"Cancel",UDim2.new(0,54,0,20),UDim2.new(1, -58,0.5, -10),v15.BTN,v15.ERROR,9);do local v1921=Instance.new("UIStroke",v837);v1921.Color=v15.ERROR;v1921.Thickness=1;end v836.MouseButton1Click:Connect(function() pcall(function() v805:FireServer();end);end);v837.MouseButton1Click:Connect(function() pcall(function() v806:FireServer();end);end);local v838=v16:frame(v814,UDim2.new(1,0,0,26),nil,v15.BTN);v838.LayoutOrder=5;v16:corner(v838,5);v16:stroke(v838,v15.STROKE,1);v16:label(v838,"Skip Time Age Breaker",UDim2.new(1, -110,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;local v842=v16:label(v838,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),v15.DIM,8);v842.Font=Enum.Font.Gotham;local v844,v845=v16:logPanel(v814,6,45);local v846=v16:frame(v814,UDim2.new(1,0,0,36),nil,v15.PANEL);v846.LayoutOrder=7;v16:stroke(v846,v15.STROKE,1);v16:label(v846,"AUTO AGE BREAKER",UDim2.new(0,120,0,20),UDim2.new(0,8,0.5, -10),v15.TEXT,10).Font=Enum.Font.GothamBold;local v849=v16:label(v846,"● IDLE",UDim2.new(1, -180,1,0),UDim2.new(0,124,0,0),v15.DIM,9);v849.Font=Enum.Font.Gotham;v849.TextTruncate=Enum.TextTruncate.AtEnd;local function v853(v1925,v1926) v849.Text=v1925;v849.TextColor3=v1926 or v15.DIM ;end local function v854() while v796 do local v2680=v808();if not v2680 then task.wait(1);continue;end if ( not v2680.IsRunning and (v2680.TimeLeft<=0)) then break;end local v2681=v2680.TimeLeft or 0 ;v853(string.format("⏳ Waiting %s",v14.fmtTime(v2681)),v15.DIM);task.wait(v797);end end local function v855() if v798 then return;end v798=true;v842.Text="● ON";v842.TextColor3=v15.SUCCESS;task.spawn(function() while v798 do if not v796 then v842.Text="● ON";v842.TextColor3=v15.SUCCESS;task.wait(5);continue;end if (v799 or v800) then v842.Text="● Claiming";v842.TextColor3=v15.DIM;task.wait(2);continue;end local v3340=v808();local v3341=v3340 and v3340.IsRunning and v3340.TimeLeft and (v3340.TimeLeft>0) ;if v3341 then v845(string.format("Timer %s — mulai skip ke TW...",v14.fmtTime(v3340.TimeLeft or 0 )),v15.ACCENT);v842.Text="→ TW";v842.TextColor3=v15.ACCENT;if v807 then if (v800 or v799) then v845("Travel diblock (claiming aktif), skip ke TW dibatal",v15.DIM);else pcall(function() v807:FireServer();end);task.wait(8);end end local v4031=0;while v798 and v796 do if (v799 or v800) then v845("Claiming aktif, stop hopping",v15.DIM);break;end v4031=v4031 + 1 ;v842.Text=string.format("Hop %d",v4031);v842.TextColor3=v15.ACCENT;local v4207=v808();if (v4207 and not v4207.IsRunning and ((v4207.TimeLeft or 0)<=0)) then v845(string.format("Timer habis sebelum hop %d, stop hopping",v4031),v15.SUCCESS);break;end if (v4031>50) then v845("Max hop 50 tercapai, paksa balik",v15.DIM);break;end pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,game.JobId,v1.LocalPlayer);end);task.wait(5);local v4208=v808();if (v4208 and not v4208.IsRunning and ((v4208.TimeLeft or 0)<=0)) then v845(string.format("Timer habis setelah hop %d!",v4031),v15.SUCCESS);break;end end v845("Hop selesai, nunggu claim dari main loop...",v15.DIM);v842.Text="● ON";v842.TextColor3=v15.SUCCESS;else if (v3340 and v3340.PetReady) then v842.Text="● Ready";v842.TextColor3=v15.SUCCESS;elseif (v3340 and v3340.SubmittedPet and not v3340.IsRunning) then v842.Text="● Submitted";v842.TextColor3=v15.DIM;else v842.Text="● ON";v842.TextColor3=v15.SUCCESS;end task.wait(5);end end v842.Text="● IDLE";v842.TextColor3=v15.DIM;end);end local v856=Instance.new("Frame",v838);v856.Size=UDim2.new(0,44,0,22);v856.Position=UDim2.new(1, -48,0.5, -11);v856.BackgroundColor3=((v33.autoAgeBreaker.skipEnabled or false) and v15.TOGGLE_ON) or v15.TOGGLE_OFF ;v856.BorderSizePixel=0;Instance.new("UICorner",v856).CornerRadius=UDim.new(0,11);local v862=Instance.new("Frame",v856);v862.Size=UDim2.new(0,18,0,18);v862.Position=((v33.autoAgeBreaker.skipEnabled or false) and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;v862.BackgroundColor3=Color3.fromRGB(255,255,255);v862.BorderSizePixel=0;Instance.new("UICorner",v862).CornerRadius=UDim.new(0,9);local v868=Instance.new("TextButton",v856);v868.Size=UDim2.new(1,0,1,0);v868.BackgroundTransparency=1;v868.Text="";local v872=v33.autoAgeBreaker.skipEnabled or false ;local function v873(v1932) v872=v1932;v856.BackgroundColor3=(v1932 and v15.TOGGLE_ON) or v15.TOGGLE_OFF ;v862.Position=(v1932 and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;end v868.MouseButton1Click:Connect(function() v872= not v872;v33.autoAgeBreaker.skipEnabled=v872;v37();v873(v872);if v872 then v855();else v798=false;v842.Text="● IDLE";v842.TextColor3=v15.DIM;end end);local v874=v16:frame(v219,UDim2.new(1,0,1,0),nil,v15.BG);v874.Visible=false;v874.ZIndex=20;local v877=v16:frame(v874,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v877,v15.STROKE,1);v16:label(v877,"Select Target Pets (Age 100+)",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v878=v16:button(v877,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v878,v15.ERROR,1);v878.MouseButton1Click:Connect(function() v874.Visible=false;v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;end);local v879=v16:input(v874,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v879.TextColor3=v15.TEXT;v879.Font=Enum.Font.Gotham;local v883=v16:scroll(v874,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v883,3);v16:pad(v883,3,4,4,3);local function v884() for v2685,v2686 in ipairs(v883:GetChildren()) do if v2686:IsA("GuiObject") then v2686:Destroy();end end local v1938=v60();local v1939=string.lower(v879.Text);local v1940={};for v2687,v2688 in pairs(v1938) do if ( not v2688 or not v2688.PetData) then continue;end local v2689=v2688.PetData.Level or 0 ;if (v2689<100) then continue;end if ((v1939~="") and not string.lower(v2688.PetType or "" ):find(v1939,1,true)) then continue;end table.insert(v1940,v2687);end table.sort(v1940,function(v2690,v2691) return v61(v2690)>v61(v2691) ;end);for v2692,v2693 in ipairs(v1940) do local v2694=v1938[v2693];if not v2694 then continue;end local v2695=table.find(v33.autoAgeBreaker.targets,v2693)~=nil ;local v2696=v2694.PetData.Level or 0 ;local v2697=v61(v2693);local v2698=v2694.PetData.BaseWeight or 0 ;local v2699=(v65(v2693) and " ❤") or "" ;local v2700=v809(v2693);local v2701=((v2700~="") and (" [" .. v2700 .. "]")) or "" ;local v2702=((v2701~="") and string.format('%s',v2701)) or "" ;local v2703=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2694.PetType or "?" ,v2702,v2699,v2696,v2697,v2698);local v2704=v16:button(v883,v2703,UDim2.new(1,0,0,22),nil,(v2695 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2695 and v15.SEL_TXT) or v15.TEXT ,9);v2704.LayoutOrder=v2692;v2704:SetAttribute("uuid",v2693);v2704.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2704,0,8,4,0);v16:stroke(v2704,(v2695 and v15.ACCENT) or v15.STROKE ,1);v2704.MouseButton1Click:Connect(function() local v3345=table.find(v33.autoAgeBreaker.targets,v2693);if v3345 then table.remove(v33.autoAgeBreaker.targets,v3345);else table.insert(v33.autoAgeBreaker.targets,v2693);end v37();v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;v16:updateRowVisual(v2704,table.find(v33.autoAgeBreaker.targets,v2693)~=nil ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v879:GetPropertyChangedSignal("Text"):Connect(v884);v832.MouseButton1Click:Connect(function() v874.Visible=true;v884();end);local function v885() local v1942={};for v2708,v2709 in ipairs(v33.autoAgeBreaker.targets) do table.insert(v1942,v2709);end for v2710,v2711 in ipairs(v1942) do if not v796 then break;end do local v3347=v808();if v3347 then if v3347.PetReady then v845(string.format("[%d/%d] Startup: machine ready, claiming...",v2710, #v1942),v15.DIM);v799=true;v812(v845);pcall(function() v805:FireServer();end);task.wait(1.5);v799=false;elseif (v3347.IsRunning or (v3347.TimeLeft and (v3347.TimeLeft>0))) then v845(string.format("[%d/%d] Startup: machine running (%s), waiting...",v2710, #v1942,v14.fmtTime(v3347.TimeLeft or 0 )),v15.DIM);v854();if not v796 then break;end local v4435=v808();if (v4435 and v4435.PetReady) then v845("Claiming after wait...",v15.DIM);v799=true;v812(v845);pcall(function() v805:FireServer();end);task.wait(1.5);v799=false;end elseif (v3347.SubmittedPet and not v3347.PetReady) then v845(string.format("[%d/%d] Startup: ada pet di mesin, cancel dulu...",v2710, #v1942),v15.DIM);pcall(function() v806:FireServer();end);task.wait(1.5);end end end if not v796 then break;end local v2712=v60();if not v2712[v2711] then local v3765=v808();local v3766=false;if (v3765 and v3765.SubmittedPet) then local v4209=v3765.SubmittedPet;local v4210=((type(v4209)=="string") and v4209) or ((type(v4209)=="table") and (v4209.UUID or v4209.uuid or v4209.Id or v4209.id)) or nil ;if (v4210==v2711) then v3766=true;v845(string.format("[%d/%d] Pet target ada di machine, tunggu selesai...",v2710, #v1942),v15.DIM);v854();if not v796 then break;end local v4389=v808();if (v4389 and v4389.PetReady) then v799=true;v812(v845);pcall(function() v805:FireServer();end);task.wait(1.5);v799=false;end end end if not v3766 then v845(string.format("[%d/%d] Skip — not in inventory",v2710, #v1942),v15.DIM);local v4211=table.find(v33.autoAgeBreaker.targets,v2711);if v4211 then table.remove(v33.autoAgeBreaker.targets,v4211);v37();end v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;continue;end v2712=v60();if not v2712[v2711] then v845(string.format("[%d/%d] Skip — masih tidak ada di inventory",v2710, #v1942),v15.DIM);local v4213=table.find(v33.autoAgeBreaker.targets,v2711);if v4213 then table.remove(v33.autoAgeBreaker.targets,v4213);v37();end v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;continue;end end local v2713=v64(v2711);local v2714=v2713;local v2715=v62(v2711);v845(string.format("[%d/%d] START %s (Age %d)",v2710, #v1942,v2713,v2715),v15.ACCENT);if (v2715<100) then v845("Skip — target not age 100",v15.DIM);continue;end local v2716=v33.autoAgeBreaker.maxLevel or 125 ;while v796 do local v3348=v62(v2711);v853(string.format("Age %d/%d | %s",v3348,v2716,v2713),v15.ACCENT);if (v3348>=v2716) then v845(string.format("✓ DONE %s reached Age %d!",v2713,v2716),v15.SUCCESS);local v4033=table.find(v33.autoAgeBreaker.targets,v2711);if v4033 then table.remove(v33.autoAgeBreaker.targets,v4033);v37();end v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;break;end local v3349=v808();if not v3349 then task.wait(1);continue;end if (v3349.IsRunning or (v3349.TimeLeft>0)) then v845("Machine running, waiting...",v15.DIM);v854();if not v796 then break;end v3349=v808();end if (v3349 and v3349.PetReady) then v799=true;v845("Claiming...",v15.SUCCESS);v853("Claiming " .. v2713 ,v15.SUCCESS);v812(v845);pcall(function() v805:FireServer();end);task.wait(1.5);v799=false;local v4035=v62(v2711);v845(string.format("Claimed! Age now: %d",v4035),v15.SUCCESS);if (v4035>=v2716) then v845(string.format("✓ DONE %s reached Age %d!",v2713,v2716),v15.SUCCESS);local v4303=table.find(v33.autoAgeBreaker.targets,v2711);if v4303 then table.remove(v33.autoAgeBreaker.targets,v4303);v37();end v830.Text="Target pets: " .. #v33.autoAgeBreaker.targets ;break;end v845("Re-leveling after claim...",v15.DIM);local v4036=os.clock();while v796 do task.wait(v797);local v4215=v62(v2711);v853(string.format("Re-leveling... Lv%d/100 | %s",v4215,v2713),v15.DIM);if (v4215>=100) then v845(string.format("Target back to Age %d, next cycle",v4215),v15.ACCENT);break;end if ((os.clock() -v4036)>3600) then v845("Timeout waiting for re-level",v15.ERROR);break;end end continue;end local v3350=v64(v2711);local v3351=false;if (v3349 and v3349.SubmittedPet and not v3349.IsRunning and not v3349.PetReady) then local v4037=v3349.SubmittedPet;local v4038=((type(v4037)=="string") and v4037) or ((type(v4037)=="table") and (v4037.UUID or v4037.uuid or v4037.Id or v4037.id)) or nil ;if (v4038==v2711) then v845("Target sudah ada di mesin, langsung cari tumbal...",v15.DIM);v3351=true;else v845(string.format("Pet lain di mesin (uuid=%s), cancel dulu...",tostring(v4038 or "nil" )),v15.DIM);pcall(function() v806:FireServer();end);task.wait(1.5);end end if not v3351 then v845(string.format("Submitting target: %s to machine...",v2713),v15.DIM);v853(string.format("Submitting target %s",v2713),v15.DIM);local v4039=v810(v2711);if not v4039 then v845("Failed to equip target pet tool",v15.ERROR);task.wait(1);continue;end pcall(function() v803:FireServer();end);task.wait(1.5);local v4040=v9:FindFirstChildWhichIsA("Tool");if (v4040 and v4040:GetAttribute("PET_UUID")) then v4040.Parent=v8;end task.wait(0.3);v845("Waiting for machine to receive target...",v15.DIM);local v4041=os.clock();while v796 do local v4216=v808();if (v4216 and v4216.SubmittedPet) then break;end if ((os.clock() -v4041)>5) then v845("Timeout waiting for SubmittedPet!",v15.ERROR);break;end task.wait(0.5);end if not v796 then break;end end local v3352=v811(v2711,v3350);if not v3352 then v845("No tumbal available! Stopping.",v15.ERROR);v796=false;break;end local v3353=v64(v3352);local v3354=v62(v3352);local v3355=v61(v3352);v845(string.format("Submitting tumbal: %s Age %d %.2fkg",v3353,v3354,v3355),v15.DIM);v853(string.format("Submitting tumbal %s",v3353),v15.DIM);pcall(function() v804:FireServer({v3352});end);task.wait(1.5);v845("Waiting for machine...",v15.DIM);local v3356=os.clock();while v796 do local v3767=v808();if (v3767 and (v3767.IsRunning or (v3767.TimeLeft and (v3767.TimeLeft>0)))) then break;end if ((os.clock() -v3356)>5) then v845("Machine didn't start, retrying...",v15.ERROR);break;end task.wait(0.5);end v854();if not v796 then break;end end end v796=false;v845("════ ALL DONE ════",v15.ACCENT);v853("● IDLE",v15.DIM);end local function v886() local v1943,v1944=pcall(function() v885();end);if not v1943 then v845("Error: " .. tostring(v1944) ,v15.ERROR);v853("● IDLE",v15.DIM);end v796=false;v853("● IDLE",v15.DIM);end local v887=Instance.new("Frame",v846);v887.Size=UDim2.new(0,44,0,22);v887.Position=UDim2.new(1, -48,0.5, -11);v887.BackgroundColor3=((v33.autoAgeBreaker.autoStart or false) and v15.TOGGLE_ON) or v15.TOGGLE_OFF ;v887.BorderSizePixel=0;Instance.new("UICorner",v887).CornerRadius=UDim.new(0,11);local v893=Instance.new("Frame",v887);v893.Size=UDim2.new(0,18,0,18);v893.Position=((v33.autoAgeBreaker.autoStart or false) and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;v893.BackgroundColor3=Color3.fromRGB(255,255,255);v893.BorderSizePixel=0;Instance.new("UICorner",v893).CornerRadius=UDim.new(0,9);local v899=Instance.new("TextButton",v887);v899.Size=UDim2.new(1,0,1,0);v899.BackgroundTransparency=1;v899.Text="";local v903=v33.autoAgeBreaker.autoStart or false ;local function v904(v1945) v903=v1945;v887.BackgroundColor3=(v1945 and v15.TOGGLE_ON) or v15.TOGGLE_OFF ;v893.Position=(v1945 and UDim2.new(1, -20,0.5, -9)) or UDim2.new(0,2,0.5, -9) ;end v899.MouseButton1Click:Connect(function() v903= not v903;v904(v903);if v903 then if ( #v33.autoAgeBreaker.targets==0) then v845("Pilih target pets dulu!",v15.ERROR);v903=false;v904(false);return;end v33.autoAgeBreaker.autoStart=true;v37();v796=true;v845("════ AUTO AGE BREAKER START ════",v15.ACCENT);v853("Starting...",v15.SUCCESS);task.spawn(function() local v3768,v3769=pcall(v886);if not v3768 then v845("Error: " .. tostring(v3769) ,v15.ERROR);end v796=false;v903=false;v904(false);v33.autoAgeBreaker.autoStart=false;v37();v853("● IDLE",v15.DIM);end);else v796=false;v798=false;v33.autoAgeBreaker.autoStart=false;v37();v845("─── Stopped ───",v15.ERROR);v853("● IDLE",v15.DIM);end end);if v33.autoAgeBreaker.skipEnabled then task.defer(v855);end if (v33.autoAgeBreaker.autoStart and ( #v33.autoAgeBreaker.targets>0)) then task.delay(1.5,function() if not v796 then v903=true;v904(true);v796=true;v845("════ AUTO RESUME ════",v15.ACCENT);v853("Resuming...",v15.SUCCESS);task.spawn(function() local v4217,v4218=pcall(v886);if not v4217 then v845("Error: " .. tostring(v4218) ,v15.ERROR);end v796=false;v903=false;v904(false);v33.autoAgeBreaker.autoStart=false;v37();v853("● IDLE",v15.DIM);end);end end);end v845("Auto Age Breaker ready!",v15.SUCCESS);end v236();local function v237() local v905=false;local v906=2;local v907=v2:WaitForChild("GameEvents"):WaitForChild("PetMutationMachineService_RE");local v908={};do local v1948,v1949=pcall(function() return require(v2.Data.PetRegistry.PetMutationRegistry);end);if (v1948 and v1949) then for v3771,v3772 in pairs(v1949.MachineMutationTypes or {} ) do table.insert(v908,{key=v3771,name=v3771});end end table.insert(v908,{key="GiantGolem",name="GiantGolem"});table.sort(v908,function(v2717,v2718) return v2717.name=1) and (v1991<=99)) then v33.autoMutMachine.lvThresh=v1991;v37();else v951.Text=tostring(v33.autoMutMachine.lvThresh);end end);local v952=v16:frame(v918,UDim2.new(1,0,0,22),nil,v15.BG,1);v952.LayoutOrder=13;local v954=v16:label(v952,"Target pets: " .. #v33.autoMutMachine.targets ,UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v954.Font=Enum.Font.Gotham;local v956=v16:button(v952,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v956,v15.STROKE,1);local v957,v958=v16:logPanel(v918,14,45);local v959=v16:frame(v918,UDim2.new(1,0,0,36),nil,v15.PANEL);v959.LayoutOrder=15;v16:stroke(v959,v15.STROKE,1);v16:label(v959,"AUTO MUTATION MACHINE",UDim2.new(0,140,0,20),UDim2.new(0,8,0.5, -10),v15.TEXT,10).Font=Enum.Font.GothamBold;local v962=v16:label(v959,"● IDLE",UDim2.new(1, -200,1,0),UDim2.new(0,144,0,0),v15.DIM,9);v962.Font=Enum.Font.Gotham;v962.TextTruncate=Enum.TextTruncate.AtEnd;local function v966(v1992,v1993) v962.Text=v1992;v962.TextColor3=v1993 or v15.DIM ;end local function v967(v1996,v1997,v1998) return v40(v1996,v1997,v1998,v16,v33,v15);end local v968,v969,v970,v971=false,false,false,false;v926.MouseButton1Click:Connect(function() v968= not v968;v930.Visible=false;v969=false;v933.Visible=false;v970=false;v927.Visible=v968;if v968 then local v3361=v967(v928,function(v3774) v33.autoMutMachine.cdTeam=v3774;v37();v926.Text=v3774;v927.Visible=false;v968=false;end,v33.autoMutMachine.cdTeam);v927.Size=UDim2.new(1,0,0,math.min((v3361 * 24) + 6 ,130));end end);v929.MouseButton1Click:Connect(function() v969= not v969;v927.Visible=false;v968=false;v933.Visible=false;v970=false;v930.Visible=v969;if v969 then local v3363=v967(v931,function(v3778) v33.autoMutMachine.claimTeam=v3778;v37();v929.Text=v3778;v930.Visible=false;v969=false;end,v33.autoMutMachine.claimTeam);v930.Size=UDim2.new(1,0,0,math.min((v3363 * 24) + 6 ,130));end end);v932.MouseButton1Click:Connect(function() v970= not v970;v927.Visible=false;v968=false;v930.Visible=false;v969=false;v936.Visible=false;v971=false;v933.Visible=v970;if v970 then local v3365=v967(v934,function(v3782) v33.autoMutMachine.lvTeam=v3782;v37();v932.Text=v3782;v933.Visible=false;v970=false;end,v33.autoMutMachine.lvTeam);v933.Size=UDim2.new(1,0,0,math.min((v3365 * 24) + 6 ,130));end end);v935.MouseButton1Click:Connect(function() v971= not v971;v927.Visible=false;v968=false;v930.Visible=false;v969=false;v933.Visible=false;v970=false;v936.Visible=v971;if v971 then local v3367=v967(v937,function(v3786) v33.autoMutMachine.lvTeam2=v3786;v37();v935.Text=v3786;v936.Visible=false;v971=false;end,v33.autoMutMachine.lvTeam2);v936.Size=UDim2.new(1,0,0,math.min((v3367 * 24) + 6 ,130));end end);local v972=v16:frame(v219,UDim2.new(1,0,1,0),nil,v15.BG);v972.Visible=false;v972.ZIndex=20;local v975=v16:frame(v972,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v975,v15.STROKE,1);v16:label(v975,"Select Target Pets (Mutation Machine)",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v976=v16:button(v975,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v976,v15.ERROR,1);v976.MouseButton1Click:Connect(function() v972.Visible=false;v954.Text="Target pets: " .. #v33.autoMutMachine.targets ;end);local v977=v16:input(v972,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v977.TextColor3=v15.TEXT;v977.Font=Enum.Font.Gotham;local v981=v16:scroll(v972,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v981,3);v16:pad(v981,3,4,4,3);local function v982() for v2727,v2728 in ipairs(v981:GetChildren()) do if v2728:IsA("GuiObject") then v2728:Destroy();end end local v2015=v60();local v2016=string.lower(v977.Text);local v2017={};for v2729 in pairs(v2015) do table.insert(v2017,v2729);end table.sort(v2017,function(v2730,v2731) return v61(v2730)>v61(v2731) ;end);for v2732,v2733 in ipairs(v2017) do local v2734=v2015[v2733];if not v2734 then continue;end if ((v2016~="") and not string.lower(v2734.PetType or "" ):find(v2016,1,true)) then continue;end local v2735=table.find(v33.autoMutMachine.targets,v2733)~=nil ;local v2736=(v2734.PetData and (v2734.PetData.Level or 0)) or 0 ;local v2737=v61(v2733);local v2738=(v2734.PetData and (v2734.PetData.BaseWeight or 0)) or 0 ;local v2739=(v65(v2733) and " ❤") or "" ;local v2740=v910(v2733);local v2741=(v2740 and (" [" .. (v19[v2740] or v2740) .. "]")) or "" ;local v2742=((v2741~="") and string.format('%s',v2741)) or "" ;local v2743=string.format("%s%s%s | Age %d | %.2f KG | Base %.2f",v2734.PetType or "?" ,v2742,v2739,v2736,v2737,v2738);local v2744=v16:button(v981,v2743,UDim2.new(1,0,0,22),nil,(v2735 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2735 and v15.SEL_TXT) or v15.TEXT ,9);v2744.LayoutOrder=v2732;v2744:SetAttribute("uuid",v2733);v2744.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2744,0,8,4,0);v16:stroke(v2744,(v2735 and v15.ACCENT) or v15.STROKE ,1);v2744.MouseButton1Click:Connect(function() local v3369=table.find(v33.autoMutMachine.targets,v2733);if v3369 then table.remove(v33.autoMutMachine.targets,v3369);else table.insert(v33.autoMutMachine.targets,v2733);end v37();v954.Text="Target pets: " .. #v33.autoMutMachine.targets ;v16:updateRowVisual(v2744,table.find(v33.autoMutMachine.targets,v2733)~=nil ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v977:GetPropertyChangedSignal("Text"):Connect(v982);v956.MouseButton1Click:Connect(function() v972.Visible=true;v982();end);local v983=false;local v984=nil;local v985={};local function v986() v983=true;task.spawn(function() while v983 do task.wait(v30.TEAM_CHECK);if (v84.IsEquipping or not v905 or not v984) then continue;end if v915 then continue;end local v3371={};v3371[v984]=true;for v3790,v3791 in ipairs(v985) do v3371[v3791]=true;end local v3373=v83();local v3374,v3375={},{};for v3793 in pairs(v3371) do local v3794=false;for v4042,v4043 in ipairs(v3373) do if (v4043==v3793) then v3794=true;break;end end if not v3794 then table.insert(v3374,v3793);end end for v3795,v3796 in ipairs(v3373) do if not v3371[v3796] then table.insert(v3375,v3796);end end if (( #v3375>0) or ( #v3374>0)) then v84.IsEquipping=true;for v4220,v4221 in ipairs(v3375) do pcall(function() v12:FireServer("UnequipPet",v4221);end);task.wait(v24.EQUIP_DELAY);end local v4045=v92();for v4222,v4223 in ipairs(v3374) do pcall(function() v12:FireServer("EquipPet",v4223,v4045);end);task.wait(v24.EQUIP_DELAY);end v84.IsEquipping=false;end end end);end local function v987() v983=false;v985={};v984=nil;end local function v988(v2019,v2020) if ( not v2019 or ( #v2019==0)) then v91();task.wait(0.3);return true;end local v2021=v83();local v2022={};for v2748,v2749 in ipairs(v2021) do v2022[v2749]=true;end local v2023= #v2021== #v2019 ;if v2023 then for v3797,v3798 in ipairs(v2019) do if not v2022[v3798] then v2023=false;break;end end end if v2023 then v2020("✓ Claim team already correct",v15.DIM);return true;end v2020("Re-equipping claim team before claim...",v15.DIM);v91();task.wait(0.5);v93(v2019);local v2024=v94(v2019,8);task.wait(0.5);if not v2024 then v2020("⚠ Claim team verify timeout",v15.ERROR);end return v2024;end local function v989(v2025,v2026) local v2027=v39(v33.autoMutMachine.lvTeam);local v2028=v39(v33.autoMutMachine.lvTeam2);local v2029=v39(v33.autoMutMachine.cdTeam);local v2030=v39(v33.autoMutMachine.claimTeam);local v2031=v33.autoMutMachine.lvThresh or 50 ;local v2032=v33.autoMutMachine.targetMut or "Golden" ;local v2033=nil;do local v2751,v2752=pcall(function() return require(v2.Data.PetRegistry.PetMutationRegistry);end);if (v2751 and v2752) then v2033=v2752.PetMutationToEnum[v2032];end end local v2034={};for v2753,v2754 in ipairs(v33.autoMutMachine.targets) do table.insert(v2034,v2754);end for v2755,v2756 in ipairs(v2034) do if not v905 then break;end do local v3376=v909();if v3376 then if (v3376.IsRunning or (v3376.TimeLeft>0)) then v2025(string.format("[%d/%d] Startup: machine running, wear CD & waiting...",v2755, #v2034),v15.DIM);if ( #v2029>0) then v915=true;v913=v914;_G.MM_SuppressPickPlace=v914;v91();task.wait(0.3);v93(v2029);v94(v2029,8);end v916(v2025,v2026);v913=false;_G.MM_SuppressPickPlace=false;v915=false;if not v905 then break;end end v3376=v909();if (v3376 and v3376.PetReady) then local v4306=v3376.SubmittedPet;local v4307=((type(v4306)=="string") and v4306) or ((type(v4306)=="table") and (v4306.UUID or v4306.uuid or v4306.Id or v4306.id)) or nil ;local v4308=(v4307==nil) or (v4307==v2756) ;v2025(string.format("Startup claim: pet=%s isOurs=%s",tostring(v4307 or "nil" ),tostring(v4308)),v15.DIM);if ( #v2030>0) then v91();task.wait(0.5);v93(v2030);v94(v2030,8);task.wait(0.5);end pcall(function() v907:FireServer("ClaimMutatedPet");end);task.wait(2);v91();task.wait(0.5);if not v905 then break;end end end end if not v905 then break;end local v2757=v60();if not v2757[v2756] then v2025(string.format("[%d/%d] Skip — not in inventory",v2755, #v2034),v15.DIM);continue;end local v2758=v64(v2756);v2025(string.format("[%d/%d] START %s | target: %s",v2755, #v2034,v2758,v2032),v15.ACCENT);local v2759=false;local v2760=0;while v905 and not v2759 do v2760+=1 local v3377=v911(v2756);if (v33770) then v984=v2756;v985=v2027;v93(v95(v2756,v2027));local v4309=v3377;while v905 do task.wait(v24.POLL_RATE);local v4390=v911(v2756);v2026(string.format("Lv%d/%d | %s",v4390,v2031,v2758),v15.DIM);if (v4390>=v2031) then v2025(string.format("Level %d reached!",v4390),v15.ACCENT);break;end end v91();task.wait(0.5);else v2025("No leveling team set, waiting for level " .. v2031 ,v15.DIM);while v905 do task.wait(v906);local v4391=v911(v2756);v2026(string.format("Waiting Lv%d/%d | %s",v4391,v2031,v2758),v15.DIM);if (v4391>=v2031) then break;end end end if not v905 then break;end end local v3378=v909();if (v3378 and (v3378.IsRunning or (v3378.TimeLeft>0))) then local v4046=v3378.SubmittedPet;local v4047=((type(v4046)=="string") and v4046) or ((type(v4046)=="table") and (v4046.UUID or v4046.uuid or v4046.Id or v4046.id)) or nil ;local v4048=(v4047==nil) or (v4047==v2756) ;if v4048 then v2025("Pet target is in machine, waiting to finish...",v15.DIM);else v2025(string.format("⚠ Machine has OTHER pet, wear CD & wait... pet=%s",tostring(v4047 or "nil" )),v15.DIM);end if ( #v2029>0) then v915=true;v913=v914;_G.MM_SuppressPickPlace=v914;v91();task.wait(0.3);v93(v2029);v94(v2029,8);end v916(v2025,v2026);v913=false;_G.MM_SuppressPickPlace=false;v915=false;if not v905 then break;end v3378=v909();end if (v3378 and v3378.PetReady) then local v4049=v3378.SubmittedPet;local v4050=((type(v4049)=="string") and v4049) or ((type(v4049)=="table") and (v4049.UUID or v4049.uuid or v4049.Id or v4049.id)) or nil ;local v4051=(v4050==nil) or (v4050==v2756) ;if not v4051 then v2025("⚠ Machine result is not our target, claiming first...",v15.DIM);else v2025("Claiming machine result (our target)...",v15.DIM);end v2025("Ensuring claim team before claim...",v15.DIM);v988(v2030,v2025);pcall(function() v907:FireServer("ClaimMutatedPet");end);task.wait(2);if not v4051 then v2025("Other pet claimed, checking & leveling target then submit...",v15.ACCENT);v91();task.wait(0.5);local v4310=v911(v2756);if ((v43100)) then v2025(string.format("Leveling target to %d first (now Lv%d)...",v2031,v4310),v15.DIM);v93(v95(v2756,v2027));while v905 do task.wait(v24.POLL_RATE);local v4495=v911(v2756);v2026(string.format("Re-level Lv%d/%d | %s",v4495,v2031,v2758),v15.DIM);if (v4495>=v2031) then v2025(string.format("Level %d tercapai!",v4495),v15.ACCENT);break;end end v91();task.wait(0.5);end if not v905 then break;end else local v4311=v910(v2756);if (v4311==v2033) then v2025(string.format("✓ GOT %s on %s!",v2032,v2758),v15.SUCCESS);v2759=true;v91();break;else local v4436=(v4311 and (v19[v4311] or v4311)) or "none" ;v2025(string.format("Got %s, not %s — re-level & retry",v4436,v2032),v15.ERROR);v91();task.wait(0.5);end if v2759 then break;end if ( #v2027>0) then v2025("Re-leveling pet to threshold...",v15.DIM);v93(v95(v2756,v2027));while v905 do task.wait(v24.POLL_RATE);local v4496=v911(v2756);v2026(string.format("Re-level Lv%d/%d | %s",v4496,v2031,v2758),v15.DIM);if (v4496>=v2031) then v2025(string.format("Level %d tercapai!",v4496),v15.ACCENT);break;end end v91();task.wait(0.5);end if not v905 then break;end end end v2025(string.format("Submitting %s to machine...",v2758),v15.DIM);v2026(string.format("Submitting %s",v2758),v15.DIM);local v3379=v912(v2756);if not v3379 then v2025("Failed to equip pet as held tool",v15.ERROR);task.wait(1);continue;end pcall(function() v907:FireServer("SubmitHeldPet");end);task.wait(1);local v3380=v9:FindFirstChildWhichIsA("Tool");if (v3380 and v3380:GetAttribute("PET_UUID")) then v3380.Parent=v8;end task.wait(0.3);task.wait(0.5);pcall(function() v907:FireServer("StartMachine");end);task.wait(1);if ( #v2029>0) then v2025("Wearing CD team...",v15.DIM);v915=true;v913=v914;_G.MM_SuppressPickPlace=v914;v91();task.wait(0.5);v93(v2029);v94(v2029,8);end v916(v2025,v2026);v913=false;_G.MM_SuppressPickPlace=false;v915=false;if not v905 then break;end v2025("Ensuring claim team before claim...",v15.DIM);v988(v2030,v2025);v2025("Claiming...",v15.SUCCESS);v2026("Claiming " .. v2758 ,v15.SUCCESS);pcall(function() v907:FireServer("ClaimMutatedPet");end);task.wait(1.5);v91();local v3381=v910(v2756);if (v3381==v2033) then v2025(string.format("✓ GOT %s on %s!",v2032,v2758),v15.SUCCESS);v2026(string.format("✓ %s! %s",v2032,v2758),v15.SUCCESS);v2759=true;local v4053=table.find(v33.autoMutMachine.targets,v2756);if v4053 then table.remove(v33.autoMutMachine.targets,v4053);v37();end v954.Text="Target pets: " .. #v33.autoMutMachine.targets ;if v33.autoMutMachine.lvTo100 then local v4312=(v33.autoMutMachine.lv2Enabled and ( #v2028>0) and v2028) or v2027 ;if ( #v4312>0) then v2025("Leveling to 100 after mutation...",v15.ACCENT);v2026(string.format("Leveling %s to 100",v2758),v15.ACCENT);v91();task.wait(0.5);local v4437=false;v93(v95(v2756,v2027));while v905 do task.wait(v24.POLL_RATE);local v4497=v911(v2756);v2026(string.format("Lv%d/100 | %s",v4497,v2758),v15.DIM);if ( not v4437 and v33.autoMutMachine.lv2Enabled and ( #v2028>0) and (v4497>=v2031)) then v4437=true;v2025(string.format("Switch to lv2 team at Lv%d",v4497),v15.ACCENT);v91();task.wait(0.5);v984=v2756;v985=v2028;v93(v95(v2756,v2028));end if (v4497>=100) then v2025(string.format("✓ Lv100 done! %s",v2758),v15.SUCCESS);v91();break;end end else v2025("⚠ Level to 100 ON but no team set!",v15.ERROR);end end else local v4055=(v3381 and (v19[v3381] or v3381)) or "none" ;v2025(string.format("Got %s, not %s — retry (re-level to %d)",v4055,v2032,v2031),v15.ERROR);if ( #v2027>0) then v2025("Re-leveling pet...",v15.DIM);v93(v95(v2756,v2027));while v905 do task.wait(v24.POLL_RATE);local v4392=v911(v2756);v2026(string.format("Re-level Lv%d/%d | %s",v4392,v2031,v2758),v15.DIM);if (v4392>=v2031) then v2025(string.format("Re-leveled to %d!",v4392),v15.ACCENT);break;end end v91();task.wait(0.5);end end end if not v905 then break;end if v2759 then v2025("Next pet...",v15.DIM);task.wait(1);end end v905=false;v2025("════ ALL DONE ════",v15.ACCENT);v2026("● IDLE",v15.DIM);end if not v33.autoMutMachine then v33.autoMutMachine.running=false;end if (v33.autoMutMachine.running==nil) then v33.autoMutMachine.running=false;end v16:toggle(v959,UDim2.new(1, -52,0.5, -11),v33.autoMutMachine.running or false ,function(v2035) v33.autoMutMachine.running=v2035;v37();if v2035 then if ( #v33.autoMutMachine.targets==0) then v958("Pilih target pets dulu!",v15.ERROR);return;end v905=true;v958("════ AUTO MUTATION MACHINE START ════",v15.ACCENT);v966("Starting...",v15.SUCCESS);v986();task.spawn(function() v989(v958,v966);v987();end);else v905=false;v987();v958("─── Stopped ───",v15.ERROR);v966("● IDLE",v15.DIM);end end);if v33.autoMutMachine.running then v905=true;task.defer(function() v986();task.spawn(function() v989(v958,v966);v987();end);end);end v958("Auto Mutation Machine ready!",v15.SUCCESS);end v237();local function v238() local v990=v16:scroll(v221,UDim2.new(1,0,1, -38));v16:list(v990,5);v16:pad(v990,6,6,6,6);local v991=v16:label(v990,"Pet Teams",UDim2.new(1,0,0,16),nil,v15.ACCENT,11);v991.LayoutOrder=0;local v993=v16:frame(v990,UDim2.new(1,0,0,26),nil,v15.BG,1);v993.LayoutOrder=1;local v995=v16:input(v993,"","Team name...",UDim2.new(1, -86,0,20),UDim2.new(0,0,0,2));v995.TextColor3=v15.TEXT;local v998=v16:button(v993,"Save Active Pets",UDim2.new(0,82,0,20),UDim2.new(1, -84,0,2),v15.ACCENT,v15.SEL_TXT,8);v16:stroke(v998,v15.ACCENT,1);local v999=v16:label(v990,"Saved Teams",UDim2.new(1,0,0,14),nil,v15.DIM,9);v999.Font=Enum.Font.Gotham;v999.LayoutOrder=2;local v1003=v16:frame(v990,UDim2.new(1,0,0,0),nil,v15.BG,1);v1003.LayoutOrder=3;v1003.AutomaticSize=Enum.AutomaticSize.Y;v16:list(v1003,4);local v1007={};local v1008={a=0,b=0.1,c=0.2,d=0.3,e=0,f=0,g=0.5,h=0,i=0,j=0,k=0,l=0,m=0,n=0,o=0,p=0,q=0,r=0,s=0.05,t=0,u=0,v=0,w=0,x=0,y=0,z=0.08,A=0.22,B=0,H=0,I=0,J=0.01,K=0.03,L=0.045,M=0.06,N=0.07,O=0.07,P=0.3,Q=0,R=0,S=0,T=0,U=0,V=0.2,W=0,X=0.3,Y=0.3,Z=0.3,["@"]=0.23,EV=0.3,RJ=0.25,SS=0};local function v1009(v2037) local v2038=v60();local v2039=v2038[v2037];if ( not v2039 or not v2039.PetData) then return 0;end local v2040=v2039.PetData.BaseWeight or 0 ;local v2041=v2039.PetData.MutationType or "m" ;return v2040 * (1 + (v1008[v2041] or 0)) ;end local function v1010(v2042,v2043) task.spawn(function() local v2763=v60();local v2764={};for v3382,v3383 in pairs(v2763) do local v3384=v3383.PetType or "" ;if not v2764[v3384] then v2764[v3384]={};end table.insert(v2764[v3384],v3382);end for v3385,v3386 in pairs(v2764) do table.sort(v3386,function(v3800,v3801) return v1009(v3800)>v1009(v3801) ;end);end local v2765={};if ((v2043=="Bronto Max Passive") or (v2043=="Magpie Method")) then v2765=v39(v2043);else for v4057,v4058 in ipairs(v2042) do local v4059=v2764[v4058.petType] or {} ;local v4060=0;for v4224,v4225 in ipairs(v4059) do if ( #v2765>=8) then break;end if (v4060>=v4058.count) then break;end table.insert(v2765,v4225);v4060=v4060 + 1 ;end end if ( #v2765<8) then for v4313,v4314 in ipairs(v2042) do local v4315=v2764[v4314.petType] or {} ;for v4393,v4394 in ipairs(v4315) do if ( #v2765>=8) then break;end local v4395=false;for v4438,v4439 in ipairs(v2765) do if (v4439==v4394) then v4395=true;break;end end if not v4395 then table.insert(v2765,v4394);end end end end end if ( #v2765==0) then return;end for v3387,v3388 in ipairs(v83()) do pcall(function() v12:FireServer("UnequipPet",v3388);end);task.wait(v24.UNEQUIP_DELAY);end task.wait(v24.UNEQUIP_BUFFER);local v2766=v92();for v3389,v3390 in ipairs(v2765) do pcall(function() v12:FireServer("EquipPet",v3390,v2766);end);task.wait(v24.EQUIP_DELAY);end end);end local function v1011() for v2767,v2768 in ipairs(v1003:GetChildren()) do if v2768:IsA("GuiObject") then v2768:Destroy();end end for v2769,v2770 in ipairs(v38) do local v2771=v2770.slots;v16:builtinTeamCard(v1003,v2770.name,v2770.desc, -100 + v2769 ,function() v1010(v2771,v2770.name);end);end local v2044={};for v2772 in pairs(v33.petTeams) do table.insert(v2044,v2772);end table.sort(v2044);if ( #v2044==0) then local v3391=v16:label(v1003," (no teams saved)",UDim2.new(1,0,0,20),nil,v15.TEXT,9);v3391.Font=Enum.Font.Gotham;v3391.LayoutOrder=1;return;end for v2773,v2774 in ipairs(v2044) do local v2775=v33.petTeams[v2774];local v2776=v60();local v2777={};for v3395,v3396 in ipairs(v2775.uuids or {} ) do local v3397=v2776[v3396];if (v3397 and v3397.PetType) then local v4061=v3397.PetType;local v4062=(v3397.PetData and v3397.PetData.MutationType) or "" ;local v4063=((v4062~="") and (v4062~="m") and (v19[v4062] or "")) or "" ;local v4064=((v4063~="") and (v4061 .. " [" .. v4063 .. "]")) or v4061 ;table.insert(v2777,v4064);end end if ( #v2777==0) then v2777={"(empty)"};end local v2778= #(v2775.uuids or {});v16:teamCard(v1003,v2774,v2777,v2778,v2773,function() local v3398=v83();local v3399=v2775.uuids or {} ;local v3400=true;for v3802,v3803 in ipairs(v3399) do local v3804=false;for v4065,v4066 in ipairs(v3398) do if (v4066==v3803) then v3804=true;break;end end if not v3804 then v3400=false;break;end end if (v3400 and ( #v3399>0)) then task.spawn(function() for v4316,v4317 in ipairs(v3399) do pcall(function() v12:FireServer("UnequipPet",v4317);end);task.wait(v24.EQUIP_DELAY);end end);else task.spawn(function() local v4226=v83();for v4318,v4319 in ipairs(v4226) do pcall(function() v12:FireServer("UnequipPet",v4319);end);task.wait(v24.UNEQUIP_DELAY);end task.wait(v24.UNEQUIP_BUFFER);local v4227=v92();for v4320,v4321 in ipairs(v3399) do pcall(function() v12:FireServer("EquipPet",v4321,v4227);end);task.wait(v24.EQUIP_DELAY);end end);end end,function() v33.petTeams[v2774]=nil;if (v33.elephant.levelingTeam==v2774) then v33.elephant.levelingTeam=nil;end if (v33.elephant.elephantTeam==v2774) then v33.elephant.elephantTeam=nil;end if (v33.elephant.phase2Team==v2774) then v33.elephant.phase2Team=nil;end v37();v1011();for v3805,v3806 in ipairs(v1007) do pcall(function() v3806.Refresh();end);end end);end end v998.MouseButton1Click:Connect(function() local v2045=v995.Text;if (v2045=="") then v2045="Team_" .. (os.time()%10000) ;end local v2046=v83();if ( #v2046==0) then print("[VoidHub] No active pets!");return;end v33.petTeams[v2045]={uuids=v2046};v37();v1011();v995.Text="";for v2779,v2780 in ipairs(v1007) do pcall(function() v2780.Refresh();end);end end);v1011();_G._NH_rebuildTeams=v1011;_G._NH_ddRefs=v1007;_G._NH_BUILTIN_TEAMS=v38;end v238();local v239,v240,v241,v242;local function v243() local v1012=v16:scroll(v217,UDim2.new(1,0,1,0));v1012.ScrollingDirection=Enum.ScrollingDirection.Y;v1012.AutomaticCanvasSize=Enum.AutomaticSize.None;v1012.CanvasSize=UDim2.new(0,0,0,1200);v16:list(v1012,6);v16:pad(v1012,4,4,4,4);local v1018=v16:accordionScroll(v1012,"AUTO ELEPHANT",1,true,{height=1800,pt=6,pl=6,pr=6,pb=6,gap=5});local v1019=v1018.Inner;local function v1020(v2049,v2050,v2051,v2052,v2053) local v2054=v16:label(v1019,v2049,UDim2.new(1,0,0,14),nil,v15.DIM,9);v2054.Font=Enum.Font.Gotham;v2054.LayoutOrder=v2051;local v2058=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BG,1);v2058.LayoutOrder=v2052;local v2060=v16:button(v2058,v33.elephant[v2050] or "None selected" ,UDim2.new(1,0,1,0),nil,v15.BTN,v15.TEXT,9);v2060.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2060,0,8,8,0);v16:stroke(v2060,v15.STROKE,1);v16:label(v2058,"v",UDim2.new(0,20,1,0),UDim2.new(1, -22,0,0),v15.DIM,9,Enum.TextXAlignment.Center);local v2063=v16:frame(v1019,UDim2.new(1,0,0,0),nil,Color3.fromRGB(10,10,10));v2063.LayoutOrder=v2053;v2063.Visible=false;v16:corner(v2063,5);v16:stroke(v2063,v15.STROKE,1);local v2066=v16:scroll(v2063);v16:list(v2066,2);v16:pad(v2066,2,2,2,2);return v2060,v2063,v2066;end local v1021,v1022,v1023=v1020("Select pet team for leveling 1-50","levelingTeam",1,2,3);local v1024,v1025,v1026=v1020("Select team for elephant","elephantTeam",4,5,6);v16:divider(v1019,75);local v1027=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BG,1);v1027.LayoutOrder=76;v16:label(v1027,"[ Optional ] Phase 2 team (X - 100)",UDim2.new(1, -52,1,0),UDim2.new(0,4,0,0),v15.DIM,9).Font=Enum.Font.Gotham;v16:toggle(v1027,UDim2.new(1, -48,0.5, -11),v33.elephant.phase2Enabled,function(v2067) v33.elephant.phase2Enabled=v2067;v37();end);local v1031,v1032,v1033=v1020("Select phase 2 team (after target weight)","phase2Team",77,78,79);local v1034=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BG,1);v1034.LayoutOrder=80;v16:label(v1034,"Use phase 2 team from level",UDim2.new(1, -72,1,0),UDim2.new(0,4,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v1037=v16:input(v1034,v33.elephant.phase2Threshold,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v1037.FocusLost:Connect(function() local v2069=tonumber(v1037.Text);if (v2069 and (v2069>=1)) then v33.elephant.phase2Threshold=v2069;v37();else v1037.Text=tostring(v33.elephant.phase2Threshold);end end);v16:divider(v1019,81);local function v1038(v2070,v2071,v2072) local v2073=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BG,1);v2073.LayoutOrder=v2072;v16:label(v2073,v2070,UDim2.new(1, -72,1,0),UDim2.new(0,4,0,0),v15.DIM,9).Font=Enum.Font.Gotham;return v16:input(v2073,v2071,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));end local v1039=v1038("Target KG",v33.elephant.targetWeight,82);local v1040=v1038("Max Level (P1 switch)",v33.elephant.levelThreshold,83);v1039.FocusLost:Connect(function() local v2077=tonumber(v1039.Text);if (v2077 and (v2077>0)) then v33.elephant.targetWeight=v2077;v37();else v1039.Text=tostring(v33.elephant.targetWeight);end end);v1040.FocusLost:Connect(function() local v2078=tonumber(v1040.Text);if (v2078 and (v2078>=1)) then v33.elephant.levelThreshold=v2078;v37();else v1040.Text=tostring(v33.elephant.levelThreshold);end end);local v1041=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BG,1);v1041.LayoutOrder=10;v16:label(v1041,"Level to 100 after target weight",UDim2.new(1, -52,1,0),UDim2.new(0,4,0,0),v15.DIM,9).Font=Enum.Font.Gotham;v16:toggle(v1041,UDim2.new(1, -48,0.5, -11),v33.elephant.levelTo100,function(v2079) v33.elephant.levelTo100=v2079;v37();end);local v1044=v16:modePickerRow(v1019,{label="Target in Garden",overlayParent=v217,modes={{key="1",name="1 Pet",desc="Proses 1 pet target di garden sekaligus"},{key="2",name="2 Pets",desc="Proses 2 pet target di garden sekaligus"},{key="3",name="3 Pets",desc="Proses 3 pet target di garden sekaligus"}},default=tostring(v33.elephant.gardenSlots or 1 ),onSelect=function(v2081) v33.elephant.gardenSlots=tonumber(v2081);v37();end});v1044.row.LayoutOrder=11;local v1046=v16:modePickerRow(v1019,{label="Garden Mode",overlayParent=v217,modes={{key="A",name="Mode A — All Target",desc="Semua Target pet di-equip bareng elephant team. Tunggu SEMUA naik baru balik ke leveling."},{key="B",name="Mode B — One By one",desc="Pet 1 + elephant team naik, lalu Pet 2 + elephant team naik, Baru balik ke leveling."}},default=v33.elephant.gardenMode or "A" ,onSelect=function(v2083) v33.elephant.gardenMode=v2083;v37();end});v1046.row.LayoutOrder=12;local v1048=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BTN);v1048.LayoutOrder=13;v16:corner(v1048,5);v16:stroke(v1048,v15.STROKE,1);v16:label(v1048,"Extra Filler Pets (swap saat capai threshold)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;v16:toggle(v1048,UDim2.new(1, -48,0.5, -11),v33.elephant.useExtraPets or false ,function(v2085) v33.elephant.useExtraPets=v2085;v37();end);local v1052=v16:frame(v1019,UDim2.new(1,0,0,22),nil,v15.BG,1);v1052.LayoutOrder=14;local v1054=v16:label(v1052,"Extra pets: NONE",UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v1054.Font=Enum.Font.Gotham;local v1056=v16:button(v1052,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1056,v15.STROKE,1);local function v1057() local v2087=0;for v2781 in pairs(v33.elephant.extraPets) do v2087=v2087 + 1 ;end if (v2087==0) then v1054.Text="Extra pets: NONE";v1054.TextColor3=v15.DIM;else v1054.Text="Extra pets: " .. v2087 .. " selected" ;v1054.TextColor3=v15.ACCENT;end end v1057();local v1058=v16:frame(v217,UDim2.new(1,0,1,0),nil,v15.BG);v1058.Visible=false;v1058.ZIndex=20;local v1061=v16:frame(v1058,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v1061,v15.STROKE,1);v16:label(v1061,"Select Extra Filler Pets",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v1062=v16:button(v1061,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v1062,v15.ERROR,1);v1062.MouseButton1Click:Connect(function() v1058.Visible=false;v1057();end);local v1063=v16:input(v1058,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1063.TextColor3=v15.TEXT;v1063.Font=Enum.Font.Gotham;local v1067=v16:scroll(v1058,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v1067,3);v16:pad(v1067,3,4,4,3);local function v1068() for v2782,v2783 in ipairs(v1067:GetChildren()) do if v2783:IsA("GuiObject") then v2783:Destroy();end end local v2089=v60();local v2090=string.lower(v1063.Text);local v2091={};for v2784 in pairs(v2089) do table.insert(v2091,v2784);end table.sort(v2091,function(v2785,v2786) return v61(v2785)>v61(v2786) ;end);for v2787,v2788 in ipairs(v2091) do local v2789=v2089[v2788];if not v2789 then continue;end if ((v2090~="") and not string.lower(v2789.PetType or "" ):find(v2090,1,true)) then continue;end if table.find(v33.targets,v2788) then continue;end local v2790=v33.elephant.extraPets[v2788]==true ;local v2791=(v2789.PetData and (v2789.PetData.Level or 0)) or 0 ;local v2792=v61(v2788);local v2793=(v65(v2788) and " ❤") or "" ;local v2794=string.format("%s%s | Age %d | %.2f KG",v2789.PetType or "?" ,v2793,v2791,v2792);local v2795=v16:button(v1067,v2794,UDim2.new(1,0,0,22),nil,(v2790 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2790 and v15.SEL_TXT) or v15.TEXT ,9);v2795.LayoutOrder=v2787;v2795:SetAttribute("uuid",v2788);v2795.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2795,0,8,4,0);v16:stroke(v2795,(v2790 and v15.ACCENT) or v15.STROKE ,1);v2795.MouseButton1Click:Connect(function() if v33.elephant.extraPets[v2788] then v33.elephant.extraPets[v2788]=nil;else v33.elephant.extraPets[v2788]=true;end v37();v1057();v16:updateRowVisual(v2795,v33.elephant.extraPets[v2788]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v1063:GetPropertyChangedSignal("Text"):Connect(v1068);v1056.MouseButton1Click:Connect(function() v1058.Visible=true;v1068();end);local v1069=v16:frame(v1019,UDim2.new(1,0,0,26),nil,v15.BTN);v1069.LayoutOrder=15;v16:corner(v1069,5);v16:stroke(v1069,v15.STROKE,1);v16:label(v1069,"Extra Ele Filler Pets (swap saat capai target KG)",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;v16:toggle(v1069,UDim2.new(1, -48,0.5, -11),v33.elephant.useExtraElePets or false ,function(v2093) v33.elephant.useExtraElePets=v2093;v37();end);local v1072=v16:frame(v1019,UDim2.new(1,0,0,22),nil,v15.BG,1);v1072.LayoutOrder=16;local v1074=v16:label(v1072,"Extra ele pets: NONE",UDim2.new(1, -90,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v1074.Font=Enum.Font.Gotham;local v1076=v16:button(v1072,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1076,v15.STROKE,1);local function v1077() local v2095=0;for v2799 in pairs(v33.elephant.extraElePets) do v2095=v2095 + 1 ;end if (v2095==0) then v1074.Text="Extra ele pets: NONE";v1074.TextColor3=v15.DIM;else v1074.Text="Extra ele pets: " .. v2095 .. " selected" ;v1074.TextColor3=v15.ACCENT;end end v1077();local v1078=v16:frame(v217,UDim2.new(1,0,1,0),nil,v15.BG);v1078.Visible=false;v1078.ZIndex=20;local v1081=v16:frame(v1078,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v1081,v15.STROKE,1);v16:label(v1081,"Select Extra Ele Filler Pets",UDim2.new(1, -36,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v1082=v16:button(v1081,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v1082,v15.ERROR,1);v1082.MouseButton1Click:Connect(function() v1078.Visible=false;v1077();end);local v1083=v16:input(v1078,"","Search pet...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1083.TextColor3=v15.TEXT;v1083.Font=Enum.Font.Gotham;local v1086=v16:scroll(v1078,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v1086,3);v16:pad(v1086,3,4,4,3);local function v1087() for v2800,v2801 in ipairs(v1086:GetChildren()) do if v2801:IsA("GuiObject") then v2801:Destroy();end end local v2097=v60();local v2098=string.lower(v1083.Text);local v2099={};for v2802 in pairs(v2097) do table.insert(v2099,v2802);end table.sort(v2099,function(v2803,v2804) return v61(v2803)>v61(v2804) ;end);for v2805,v2806 in ipairs(v2099) do local v2807=v2097[v2806];if not v2807 then continue;end if ((v2098~="") and not string.lower(v2807.PetType or "" ):find(v2098,1,true)) then continue;end if table.find(v33.targets,v2806) then continue;end local v2808=v33.elephant.extraElePets[v2806]==true ;local v2809=(v2807.PetData and (v2807.PetData.Level or 0)) or 0 ;local v2810=v61(v2806);local v2811=(v65(v2806) and " ❤") or "" ;local v2812=string.format("%s%s | Age %d | %.2f KG",v2807.PetType or "?" ,v2811,v2809,v2810);local v2813=v16:button(v1086,v2812,UDim2.new(1,0,0,22),nil,(v2808 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2808 and v15.SEL_TXT) or v15.TEXT ,9);v2813.LayoutOrder=v2805;v2813:SetAttribute("uuid",v2806);v2813.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2813,0,8,4,0);v16:stroke(v2813,(v2808 and v15.ACCENT) or v15.STROKE ,1);v2813.MouseButton1Click:Connect(function() if v33.elephant.extraElePets[v2806] then v33.elephant.extraElePets[v2806]=nil;else v33.elephant.extraElePets[v2806]=true;end v37();v1077();v16:updateRowVisual(v2813,v33.elephant.extraElePets[v2806]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v1083:GetPropertyChangedSignal("Text"):Connect(v1087);v1076.MouseButton1Click:Connect(function() v1078.Visible=true;v1087();end);local v1088=v16:frame(v1019,UDim2.new(1,0,0,22),nil,v15.BG,1);v1088.LayoutOrder=85;local v1090=v16:label(v1088,"Target pets: " .. #v33.targets ,UDim2.new(1, -70,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v1090.Font=Enum.Font.Gotham;local v1092=v16:button(v1088,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -86,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1092,v15.STROKE,1);local v1093=v16:frame(v1019,UDim2.new(1,0,0,52),nil,v15.PANEL);v1093.LayoutOrder=86;v16:stroke(v1093,v15.STROKE,1);local v1095=v16:frame(v1093,UDim2.new(1,0,0,14),nil,v15.BG,1);v16:label(v1095,"LOGS",UDim2.new(1, -60,1,0),UDim2.new(0,6,0,0),v15.ACCENT,8).Font=Enum.Font.GothamBold;local v1097=v16:label(v1095,"Done: 0",UDim2.new(0,54,1,0),UDim2.new(1, -58,0,0),v15.DIM,8,Enum.TextXAlignment.Right);v1097.Font=Enum.Font.Gotham;local v1099=v16:scroll(v1093,UDim2.new(1, -4,1, -16),UDim2.new(0,2,0,15));v16:list(v1099,1);v16:pad(v1099,1,4,4,1);local v1100=0;local v1101=0;local function v1102(v2101,v2102) v1100=v1100 + 1 ;local v2103=Instance.new("TextLabel");v2103.Size=UDim2.new(1,0,0,12);v2103.BackgroundTransparency=1;v2103.Text=os.date("%H:%M:%S") .. " " .. v2101 ;v2103.TextColor3=v2102 or v15.DIM ;v2103.Font=Enum.Font.Gotham;v2103.TextSize=8;v2103.TextXAlignment=Enum.TextXAlignment.Left;v2103.TextTruncate=Enum.TextTruncate.AtEnd;v2103.LayoutOrder=v1100;v2103.Parent=v1099;local v2117={};for v2817,v2818 in ipairs(v1099:GetChildren()) do if v2818:IsA("TextLabel") then table.insert(v2117,v2818);end end while #v2117>35 do v2117[1]:Destroy();table.remove(v2117,1);end task.defer(function() v1099.CanvasPosition=Vector2.new(0,math.huge);end);end local v1103=v16:frame(v1019,UDim2.new(1,0,0,38),nil,v15.PANEL);v1103.LayoutOrder=999;v16:stroke(v1103,v15.STROKE,1);v16:label(v1103,"AUTO KG",UDim2.new(0,70,0,20),UDim2.new(0,8,0.5, -10),v15.TEXT,10).Font=Enum.Font.GothamBold;local v1106=v16:label(v1103,"● IDLE",UDim2.new(1, -120,1,0),UDim2.new(0,60,0,0),v15.DIM,9);v1106.Font=Enum.Font.Gotham;v1106.TextTruncate=Enum.TextTruncate.AtEnd;local function v1110(v2118,v2119) v1106.Text=v2118;v1106.TextColor3=v2119 or v15.DIM ;end local v1111=v16:frame(v217,UDim2.new(1,0,1,0),nil,v15.BG);v1111.Visible=false;v1111.ZIndex=20;local v1114=v16:frame(v1111,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v1114,v15.STROKE,1);v16:label(v1114,"Select Target Pets",UDim2.new(1, -80,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v1115=v16:button(v1114,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -118,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v1115,v15.STROKE,1);local v1116=v16:button(v1114,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v1116,v15.ERROR,1);v1116.MouseButton1Click:Connect(function() v1111.Visible=false;v1090.Text="Target pets: " .. #v33.targets ;end);local v1117=v16:input(v1111,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1117.TextColor3=v15.TEXT;v1117.Font=Enum.Font.Gotham;local v1120=v16:scroll(v1111,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v1120,3);v16:pad(v1120,3,4,4,3);local function v1121() local v2124=string.lower(v1117.Text);local v2125=v60();local v2126={};for v2820 in pairs(v2125) do table.insert(v2126,v2820);end table.sort(v2126,function(v2821,v2822) return v61(v2821)>v61(v2822) ;end);local v2127={};for v2823,v2824 in ipairs(v2126) do local v2825=v2125[v2824];if not v2825 then continue;end local v2826=string.lower(v2825.PetType or "" );if ((v2124=="") or v2826:find(v2124,1,true)) then table.insert(v2127,v2824);end end return v2127;end local function v1122() for v2827,v2828 in ipairs(v1120:GetChildren()) do if v2828:IsA("GuiObject") then v2828:Destroy();end end local v2128=v60();local v2129=v1121();local v2130=true;for v2829,v2830 in ipairs(v2129) do if not table.find(v33.targets,v2830) then v2130=false;break;end end v1115.Text=(( #v2129==0) and "Select All") or (v2130 and "Unselect All") or "Select All" ;v1115.TextColor3=(v2130 and v15.SEL_TXT) or v15.ACCENT ;v1115.BackgroundColor3=(v2130 and v15.SEL_BG) or v15.BTN ;for v2831,v2832 in ipairs(v2129) do local v2833=v2128[v2832];if not v2833 then continue;end local v2834=table.find(v33.targets,v2832)~=nil ;local v2835=(v2833.PetData and (v2833.PetData.Level or 0)) or 0 ;local v2836=v61(v2832);local v2837=(v2833.PetData and (v2833.PetData.BaseWeight or 0)) or 0 ;local v2838=(v65(v2832) and " ❤") or "" ;local v2839=v67(v2832);local v2840=((v2839~="") and (" [" .. v2839 .. "]")) or "" ;local v2841=(v2833.PetData and (v2833.PetData.MutationType or "")) or "" ;local v2842=((v2841~="") and (v2841~="m") and string.format('%s',v2840)) or "" ;local v2843=string.format("%s%s | Age %d | %.2f KG | Base %.2f%s",v2833.PetType or "?" ,v2842,v2835,v2836,v2837,v2838);local v2844=v16:button(v1120,v2843,UDim2.new(1,0,0,22),nil,(v2834 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2834 and v15.SEL_TXT) or v15.TEXT ,9);v2844.LayoutOrder=v2831;v2844:SetAttribute("uuid",v2832);v2844.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2844,0,8,4,0);v16:stroke(v2844,(v2834 and v15.ACCENT) or v15.STROKE ,1);v2844.MouseButton1Click:Connect(function() local v3420=table.find(v33.targets,v2832);if v3420 then table.remove(v33.targets,v3420);else table.insert(v33.targets,v2832);end v37();v1090.Text="Target pets: " .. #v33.targets ;local v3422=table.find(v33.targets,v2832)~=nil ;v16:updateRowVisual(v2844,v3422,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v1115.MouseButton1Click:Connect(function() local v2134=v1121();local v2135=true;for v2848,v2849 in ipairs(v2134) do if not table.find(v33.targets,v2849) then v2135=false;break;end end if v2135 then for v3807,v3808 in ipairs(v2134) do local v3809=table.find(v33.targets,v3808);if v3809 then table.remove(v33.targets,v3809);end end else for v3810,v3811 in ipairs(v2134) do if not table.find(v33.targets,v3811) then table.insert(v33.targets,v3811);end end end v37();v1090.Text="Target pets: " .. #v33.targets ;local v2137= not v2135;v1115.Text=(( #v2134==0) and "Select All") or (v2137 and "Unselect All") or "Select All" ;v1115.TextColor3=(v2137 and v15.SEL_TXT) or v15.ACCENT ;v1115.BackgroundColor3=(v2137 and v15.SEL_BG) or v15.BTN ;for v2850,v2851 in ipairs(v1120:GetChildren()) do if v2851:IsA("TextButton") then local v3812=v2851:GetAttribute("uuid");if v3812 then v16:updateRowVisual(v2851,v2137,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end end end end);v1117:GetPropertyChangedSignal("Text"):Connect(v1122);v1092.MouseButton1Click:Connect(function() v1111.Visible=true;v1122();end);local v1123,v1124,v1125=false,false,false;v1021.MouseButton1Click:Connect(function() v1123= not v1123;v1025.Visible=false;v1124=false;v1032.Visible=false;v1125=false;v1022.Visible=v1123;v1021.Text=v33.elephant.levelingTeam or "None selected" ;if v1123 then local v3423=v40(v1023,function(v3813) v33.elephant.levelingTeam=v3813;v37();v1021.Text=v3813;v1022.Visible=false;v1123=false;end,v33.elephant.levelingTeam,v16,v33,v15);v1022.Size=UDim2.new(1,0,0,math.min((v3423 * 24) + 6 ,130));end end);v1024.MouseButton1Click:Connect(function() v1124= not v1124;v1022.Visible=false;v1123=false;v1032.Visible=false;v1125=false;v1025.Visible=v1124;v1024.Text=v33.elephant.elephantTeam or "None selected" ;if v1124 then local v3425=v40(v1026,function(v3817) v33.elephant.elephantTeam=v3817;v37();v1024.Text=v3817;v1025.Visible=false;v1124=false;end,v33.elephant.elephantTeam,v16,v33,v15);v1025.Size=UDim2.new(1,0,0,math.min((v3425 * 24) + 6 ,130));end end);v1031.MouseButton1Click:Connect(function() v1125= not v1125;v1022.Visible=false;v1123=false;v1025.Visible=false;v1124=false;v1032.Visible=v1125;v1031.Text=v33.elephant.phase2Team or "None selected" ;if v1125 then local v3427=v40(v1033,function(v3821) v33.elephant.phase2Team=v3821;v37();v1031.Text=v3821;v1032.Visible=false;v1125=false;end,v33.elephant.phase2Team,v16,v33,v15);v1032.Size=UDim2.new(1,0,0,math.min((v3427 * 24) + 6 ,130));end end);local function v1126(v2154) local v2155=v60();local v2156= #v33.targets;local v2157={};for v2852,v2853 in ipairs(v33.targets) do if v2155[v2853] then table.insert(v2157,v2853);end end v33.targets=v2157;local v2159=v2156-#v2157 ;if (v2159>0) then if v2154 then v2154(string.format("Cleaned %d pet(s) not in inventory",v2159),v15.DIM);end v37();end return v2159;end local function v1127(v2160) local v2161=table.find(v33.targets,v2160);if v2161 then table.remove(v33.targets,v2161);v37();end end local function v1128(v2162,v2163,v2164,v2165) v1126(v2164);if ( #v33.targets==0) then v2163("No targets!",v15.ERROR);v2162.Set(false);return;end v25=true;v1101=0;v2163("Running…",v15.SUCCESS);v2164("════ AUTO KG START ════",v15.ACCENT);v100();task.spawn(function() local v2854=v39(v33.elephant.levelingTeam);local v2855=v39(v33.elephant.elephantTeam);local v2856=v39(v33.elephant.phase2Team);local v2857=tonumber(v33.elephant.targetWeight) or 2 ;local v2858=v33.elephant.levelThreshold;local v2859=v33.elephant.phase2Enabled;local v2860=v33.elephant.phase2Threshold;local v2861=v33.elephant.levelTo100;local v2862=math.max(1,math.min(3,v33.elephant.gardenSlots or 1 ));local v2863=v33.elephant.gardenMode or "A" ;local v2864=os.clock();local v2865={};for v3429,v3430 in ipairs(v33.targets) do table.insert(v2865,v3430);end local v2866= #v2865;local function v2867(v3431,v3432) local v3433={};for v3825,v3826 in ipairs(v3431) do if ( #v3433<8) then table.insert(v3433,v3826);end end for v3827,v3828 in ipairs(v3432 or {} ) do if ( #v3433>=8) then break;end local v3829=false;for v4074,v4075 in ipairs(v3433) do if (v4075==v3828) then v3829=true;break;end end if not v3829 then table.insert(v3433,v3828);end end return v3433;end local v2868=1;while (v2868<= #v2865) and v25 do local v3434={};local v3435=v2868;while ( #v3434=v2857) then v3436[v4079]=true;v2164(string.format("✓ %s reach %.2fkg",v64(v4079),v63(v4079)),v15.SUCCESS);else v3836=false;end end end if v3836 then v91();break;end local v3837={};for v4080,v4081 in ipairs(v3434) do if not v3436[v4081] then table.insert(v3837,v4081);end end if ( #v3837==0) then v91();break;end local v3838={};for v4082,v4083 in ipairs(v3837) do v3838[v4083]=v63(v4083);end local function v3839() local v4085={};for v4228,v4229 in ipairs(v3837) do v4085[v4229]=true;end local function v4086() local v4231={};for v4323 in pairs(v4085) do table.insert(v4231,v4323);end local v4232={};for v4324,v4325 in ipairs(v4231) do v4232[v4325]=true;end for v4327,v4328 in ipairs(v2854) do v4232[v4328]=true;end local v4233=v83();for v4330,v4331 in ipairs(v4233) do v4232[v4331]=true;end local v4234={};for v4333,v4334 in ipairs(v4231) do if ( #v4234<8) then table.insert(v4234,v4334);end end for v4335,v4336 in ipairs(v2854) do if ( #v4234>=8) then break;end table.insert(v4234,v4336);end if (v33.elephant.useExtraPets and ( #v4234<8)) then local v4396=v103(v4232,8 -#v4234 );for v4441,v4442 in ipairs(v4396) do if ( #v4234>=8) then break;end table.insert(v4234,v4442);v4232[v4442]=true;end end return v4234,v4231;end local v4087,v4088=v4086();v102(v4088,v2854);for v4235,v4236 in ipairs(v4087) do v99[v4236]=true;end v91();task.wait(0.5);v93(v4087);while v25 do task.wait(v24.POLL_RATE);local v4238=false;for v4337 in pairs(v4085) do if (v62(v4337)>=v2858) then v1102(string.format(" ✓ %s lv%d → swap keluar",v64(v4337),v62(v4337)),v15.SUCCESS);v4085[v4337]=nil;v4238=true;end end if not next(v4085) then v102({},{});v91();task.wait(0.3);break;end if v4238 then local v4397,v4398=v4086();local v4399={};for v4445,v4446 in ipairs(v4397) do local v4447=false;for v4498 in pairs(v4085) do if (v4498==v4446) then v4447=true;break;end end local v4448=false;for v4499,v4500 in ipairs(v2854) do if (v4500==v4446) then v4448=true;break;end end if ( not v4447 and not v4448) then table.insert(v4399,v4446);end end v102(v4398,v2854);for v4449,v4450 in ipairs(v4399) do v99[v4450]=true;end v84.IsEquipping=true;local v4401={};for v4452,v4453 in ipairs(v4397) do v4401[v4453]=true;end local v4402=v83();for v4455,v4456 in ipairs(v4402) do if not v4401[v4456] then pcall(function() v12:FireServer("UnequipPet",v4456);end);task.wait(v24.UNEQUIP_DELAY);end end task.wait(v24.UNEQUIP_BUFFER);local v4403=v83();local v4404={};for v4457,v4458 in ipairs(v4403) do v4404[v4458]=true;end local v4405=v92();for v4460,v4461 in ipairs(v4397) do if not v4404[v4461] then pcall(function() v12:FireServer("EquipPet",v4461,v4405);end);task.wait(v24.EQUIP_DELAY);end end v84.IsEquipping=false;end local v4239=true;for v4338,v4339 in ipairs(v3837) do if (v63(v4339)<=v3838[v4339]) then v4239=false;break;end end if v4239 then v102({},{});v91();break;end local v4240={};for v4340 in pairs(v4085) do table.insert(v4240,string.format("Lv%d %.2f/%.2fkg",v62(v4340),v63(v4340),v2857));end v1110("P1: " .. table.concat(v4240," | ") ,v15.DIM);end end local function v3840() if ( #v2855==0) then return;end if (v2863=="A") then local v4341={};local v4342={};for v4406,v4407 in ipairs(v3837) do v4341[v4407]=v63(v4407);v4342[v4407]=true;end local function v4343() local v4410={};for v4462 in pairs(v4342) do table.insert(v4410,v4462);end local v4411={};for v4463,v4464 in ipairs(v4410) do v4411[v4464]=true;end for v4466,v4467 in ipairs(v2855) do v4411[v4467]=true;end local v4412={};for v4469,v4470 in ipairs(v4410) do if ( #v4412<8) then table.insert(v4412,v4470);end end for v4471,v4472 in ipairs(v2855) do if ( #v4412>=8) then break;end table.insert(v4412,v4472);end if (v33.elephant.useExtraElePets and ( #v4412<8)) then local v4501=v104(v4411,8 -#v4412 );for v4522,v4523 in ipairs(v4501) do if ( #v4412>=8) then break;end table.insert(v4412,v4523);v4411[v4523]=true;end end return v4412,v4410;end local v4344,v4345=v4343();v102(v4345,v2855);for v4413,v4414 in ipairs(v4344) do v99[v4414]=true;end v91();task.wait(0.5);v93(v4344);while v25 do task.wait(v24.POLL_RATE);local v4416=false;for v4473 in pairs(v4342) do local v4474=v63(v4473);if (v4474>v4341[v4473]) then v1102(string.format("↑ %s %.2f→%.2fkg",v64(v4473),v4341[v4473],v4474),Color3.fromRGB(255,180,80));v4341[v4473]=v4474;v4342[v4473]=nil;v4416=true;end end if not next(v4342) then v102({},{});v91();task.wait(0.3);break;end if v4416 then local v4502,v4503=v4343();local v4504={};for v4527,v4528 in ipairs(v4502) do local v4529=false;for v4545 in pairs(v4342) do if (v4545==v4528) then v4529=true;break;end end local v4530=false;for v4546,v4547 in ipairs(v2855) do if (v4547==v4528) then v4530=true;break;end end if ( not v4529 and not v4530) then table.insert(v4504,v4528);end end v102(v4503,v2855);for v4531,v4532 in ipairs(v4504) do v99[v4532]=true;end v84.IsEquipping=true;local v4506={};for v4534,v4535 in ipairs(v4502) do v4506[v4535]=true;end local v4507=v83();for v4537,v4538 in ipairs(v4507) do if not v4506[v4538] then pcall(function() v12:FireServer("UnequipPet",v4538);end);task.wait(v24.UNEQUIP_DELAY);end end task.wait(v24.UNEQUIP_BUFFER);local v4508=v83();local v4509={};for v4539,v4540 in ipairs(v4508) do v4509[v4540]=true;end local v4510=v92();for v4542,v4543 in ipairs(v4502) do if not v4509[v4543] then pcall(function() v12:FireServer("EquipPet",v4543,v4510);end);task.wait(v24.EQUIP_DELAY);end end v84.IsEquipping=false;end local v4417={};for v4475 in pairs(v4342) do table.insert(v4417,string.format("%.2f/%.2fkg",v63(v4475),v2857));end v1110("Elephant A: " .. table.concat(v4417," | ") ,v15.DIM);end else for v4418,v4419 in ipairs(v3837) do if not v25 then break;end local v4420=v63(v4419);local function v4421() local v4476={[v4419]=true};for v4511,v4512 in ipairs(v2855) do v4476[v4512]=true;end local v4477={v4419};for v4514,v4515 in ipairs(v2855) do if ( #v4477>=8) then break;end table.insert(v4477,v4515);end if (v33.elephant.useExtraElePets and ( #v4477<8)) then local v4544=v104(v4476,8 -#v4477 );for v4548,v4549 in ipairs(v4544) do if ( #v4477>=8) then break;end table.insert(v4477,v4549);end end return v4477;end local v4422=v4421();v102({v4419},v2855);for v4478,v4479 in ipairs(v4422) do v99[v4479]=true;end v91();task.wait(0.5);v93(v4422);while v25 do task.wait(v24.POLL_RATE);local v4481=v63(v4419);v1110(string.format("Elephant B: %s %.2f/%.2fkg",v64(v4419),v4481,v2857),v15.DIM);if (v4481>v4420) then v1102(string.format("↑ %s %.2f→%.2fkg",v64(v4419),v4420,v4481),Color3.fromRGB(255,180,80));v102({},{});v91();break;end end end end end v3839();if not v25 then break;end v3840();if not v25 then break;end for v4089,v4090 in ipairs(v3837) do v3838[v4090]=v63(v4090);end end if not v25 then break;end for v3841,v3842 in ipairs(v3434) do if not v25 then break;end if not v60()[v3842] then v1127(v3842);continue;end local v3843=v64(v3842);local v3844=os.clock();if not v2861 then v1101=v1101 + 1 ;v2165.Text="Done: " .. v1101 ;local v4242=os.clock() -v3844 ;v2164(string.format("✓ DONE %s %.2fkg",v3843,v63(v3842)),v15.SUCCESS);v2163(string.format("%s done! %s",v3843,v14.fmtTime(v4242)),v15.SUCCESS);task.spawn(function() v72(v3843,v63(v3842),v4242,0,v1101,v2866);end);v1127(v3842);v1090.Text="Target pets: " .. #v33.targets ;continue;end local v3845=os.clock();v2164(string.format("► P2: %s → lvl 100",v3843),v15.PHASE2);v2163(string.format("P2 Lv%d/100 | %s",v62(v3842),v3843),v15.PHASE2);local v3846=v2859 and ( #v2856>0) and (v62(v3842)>=v2860) ;local v3847=(v3846 and v2856) or v2854 ;v97=v3842;v98=v3847;v91();task.wait(0.5);v93(v95(v3842,v3847));local v3848=v62(v3842);while v25 do task.wait(v24.POLL_RATE);local v4092=v62(v3842);v2163(string.format("P2 Lv%d/100 | %s",v4092,v3843),v15.PHASE2);if (v2859 and ( #v2856>0) and not v3846 and (v4092>=v2860)) then v3846=true;v98=v2856;v91();task.wait(0.5);v93(v95(v3842,v2856));end if (v4092>=(v3848 + 10)) then v2164(string.format(" Lv%d/100 %s",v4092,v3843),v15.PHASE2);v3848=v4092-(v4092%10) ;end if (v4092>=100) then v91();v1101=v1101 + 1 ;v2165.Text="Done: " .. v1101 ;local v4347=os.clock() -v3844 ;local v4348=os.clock() -v3845 ;v2164(string.format("✓ DONE %s Lv100 %.2fkg",v3843,v63(v3842)),v15.SUCCESS);v2164(string.format(" Time: %s (P2: %s)",v14.fmtTime(v4347),v14.fmtTime(v4348)),v15.DIM);v2163(string.format("%s done! %s",v3843,v14.fmtTime(v4347)),v15.SUCCESS);v1127(v3842);v1090.Text="Target pets: " .. #v33.targets ;v29("kg_done",{pet_name=v3843,final_kg=v63(v3842)});task.spawn(function() v72(v3843,v63(v3842),v4347,v4348,v1101,v2866);end);break;end end end end v25=false;v2162.Set(false);v101();v33.toggles.autoKG=false;v37();local v2870=v14.fmtTime(os.clock() -v2864 );v2164("════════════════════════",v15.ACCENT);v2164(string.format("ALL DONE %d/%d pets",v1101,v2866),v15.SUCCESS);v2164(string.format("Total time: %s",v2870),v15.ACCENT);v2163(string.format("Done! %d pets — %s",v1101,v2870),v15.SUCCESS);v1090.Text="Target pets: " .. #v33.targets ;end);end local v1129=v16:toggle(v1103,UDim2.new(1, -52,0.5, -11),v33.toggles.autoKG,function(v2166) v33.toggles.autoKG=v2166;v37();if v2166 then v1128(tog,v1110,v1102,v1097);else v25=false;v101();v1102("─── Stopped by user ───",v15.ERROR);v1110("Stopped",v15.DIM);end end);v239=v1129;if v33.toggles.autoKG then task.defer(function() v1128(v1129,v1110,v1102,v1097);end);end end v243();local function v244() local v1130=false;local v1131=v33.pickplace.petTimer;local v1132=v33.pickplace.pickDelay;local v1133=v33.pickplace.placeDelay;local v1134=v33.pickplace.selPets;local v1135=nil;local v1136={};local v1137=v2:WaitForChild("GameEvents"):WaitForChild("PetCooldownsUpdated");local v1138=v2:WaitForChild("GameEvents"):WaitForChild("GetPetCooldown");local v1139=v2:WaitForChild("GameEvents"):WaitForChild("PetsService");local function v1140() local v2168=workspace:FindFirstChild("Farm");if v2168 then local v3437=v2168:FindFirstChild(v7.Name);if v3437 then local v4093=v3437:FindFirstChild("PetArea");if v4093 then return v4093.CFrame;end end end return v23;end local function v1141(v2169) local v2170=v60();local v2171=v2170[v2169];return (v2171 and (v2171.PetType or "?")) or "?" ;end local function v1142(v2172) if v84.PP_Processing[v2172] then return;end v84.PP_Processing[v2172]=true;task.spawn(function() task.wait(v1132);local v2872=pcall(function() v1139:FireServer("UnequipPet",v2172);end);if not v2872 then v84.PP_Processing[v2172]=nil;return;end task.wait(v1133);local v2873=v1140();pcall(function() v1139:FireServer("EquipPet",v2172,v2873);end);v84.PP_Processing[v2172]=nil;end);end local v1143=v16:scroll(v223,UDim2.new(1,0,1, -42));v16:list(v1143,5);v16:pad(v1143,7,7,7,7);local function v1144(v2174,v2175,v2176) local v2177=v16:frame(v1143,UDim2.new(1,0,0,28),nil,v15.BTN);v2177.LayoutOrder=v2176;v16:corner(v2177,6);v16:stroke(v2177,v15.STROKE,1);v16:label(v2177,v2174,UDim2.new(1, -80,1,0),UDim2.new(0,8,0,0),v15.DIM,9).Font=Enum.Font.Gotham;return v16:input(v2177,v2175,"",UDim2.new(0,64,0,20),UDim2.new(1, -72,0.5, -10));end local v1145=v1144("Pet Timer (sec)",v1131,1);local v1146=v1144("Pick delay (sec)",v1132,2);local v1147=v1144("Place delay (sec)",v1133,3);v1145.FocusLost:Connect(function() local v2181=tonumber(v1145.Text);if (v2181 and (v2181>=0)) then v1131=v2181;v33.pickplace.petTimer=v2181;v37();else v1145.Text=tostring(v1131);end end);v1146.FocusLost:Connect(function() local v2182=tonumber(v1146.Text);if (v2182 and (v2182>=0)) then v1132=v2182;v33.pickplace.pickDelay=v2182;v37();else v1146.Text=tostring(v1132);end end);v1147.FocusLost:Connect(function() local v2183=tonumber(v1147.Text);if (v2183 and (v2183>=0)) then v1133=v2183;v33.pickplace.placeDelay=v2183;v37();else v1147.Text=tostring(v1133);end end);local v1148=v16:frame(v1143,UDim2.new(1,0,0,28),nil,v15.BTN);v1148.LayoutOrder=4;v16:corner(v1148,6);v16:stroke(v1148,v15.STROKE,1);local v1150=v16:label(v1148,"Filter: ALL pets",UDim2.new(1, -180,1,0),UDim2.new(0,8,0,0),v15.DIM,9);v1150.Font=Enum.Font.Gotham;local v1153=v16:button(v1148,"Clear",UDim2.new(0,40,0,20),UDim2.new(1, -172,0.5, -10),v15.BTN,v15.DIM,9);v16:stroke(v1153,v15.STROKE,1);local v1154=v16:button(v1148,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1154,v15.STROKE,1);local function v1155() local v2184=0;for v2875 in pairs(v1134) do v2184=v2184 + 1 ;end if (v2184==0) then v1150.Text="Filter: ALL pets";v1150.TextColor3=v15.DIM;else v1150.Text="Filter: " .. v2184 .. " selected" ;v1150.TextColor3=v15.ACCENT;end end v1153.MouseButton1Click:Connect(function() for v2876 in pairs(v1134) do v1134[v2876]=nil;end v37();v1155();end);v1155();local v1156=v16:frame(v223,UDim2.new(1,0,1, -42),nil,v15.BG);v1156.Visible=false;v1156.ZIndex=20;local v1159=v16:frame(v1156,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v1159,v15.STROKE,1);v16:label(v1159,"Select pets to filter",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v1160=v16:button(v1159,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v1160,v15.STROKE,1);local v1161=v16:button(v1159,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v1161,v15.ERROR,1);v1161.MouseButton1Click:Connect(function() v1156.Visible=false;v1155();end);local v1162=v16:input(v1156,"","Search pet or egg name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v1162.TextColor3=v15.TEXT;v1162.Font=Enum.Font.Gotham;local v1166=v16:scroll(v1156,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v1166,3);v16:pad(v1166,3,4,4,3);local function v1167() local v2186=string.lower(v1162.Text);local v2187={};for v2878,v2879 in ipairs(v17) do local v2880=v2879.name;local v2881=v2879.egg;if ((v2186=="") or v2880:lower():find(v2186,1,true) or v2881:lower():find(v2186,1,true)) then table.insert(v2187,v2879);end end return v2187;end local function v1168() for v2882,v2883 in ipairs(v1166:GetChildren()) do if v2883:IsA("GuiObject") then v2883:Destroy();end end local v2188=v1167();local v2189=true;for v2884,v2885 in ipairs(v2188) do if not v1134[v2885.name] then v2189=false;break;end end v1160.Text=(( #v2188==0) and "Select All") or (v2189 and "Unselect All") or "Select All" ;v1160.TextColor3=(v2189 and v15.SEL_TXT) or v15.ACCENT ;v1160.BackgroundColor3=(v2189 and v15.SEL_BG) or v15.BTN ;for v2886,v2887 in ipairs(v2188) do local v2888=v2887.name;local v2889=v2887.egg;local v2890=v1134[v2888]==true ;local v2891=v16:button(v1166,v2888,UDim2.new(1,0,0,30),nil,(v2890 and v15.SEL_BG) or Color3.fromRGB(13,13,13) ,(v2890 and v15.SEL_TXT) or v15.TEXT ,10);v2891.LayoutOrder=v2886;v2891.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v2891,0,8,4,0);v16:corner(v2891,5);v16:stroke(v2891,(v2890 and v15.ACCENT) or v15.STROKE ,1);v16:label(v2891,v2889,UDim2.new(1, -8,0,12),UDim2.new(0,8,1, -13),(v2890 and Color3.fromRGB(60,40,0)) or v15.DIM ,8).Font=Enum.Font.Gotham;v2891.MouseButton1Click:Connect(function() if v1134[v2888] then v1134[v2888]=nil;else v1134[v2888]=true;end v37();v1155();local v3450=v1134[v2888]==true ;v16:updateRowVisualWithSub(v2891,v3450,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE,Color3.fromRGB(60,40,0),v15.DIM);end);end end v1160.MouseButton1Click:Connect(function() local v2193=v1167();local v2194=true;for v2897,v2898 in ipairs(v2193) do if not v1134[v2898.name] then v2194=false;break;end end if v2194 then for v3850,v3851 in ipairs(v2193) do v1134[v3851.name]=nil;end else for v3853,v3854 in ipairs(v2193) do v1134[v3854.name]=true;end end v37();v1155();v1168();end);v1162:GetPropertyChangedSignal("Text"):Connect(v1168);v1154.MouseButton1Click:Connect(function() v1156.Visible=true;v1168();end);do local v2196=v33.pickplace.selUUIDs;local v2197=v33.pickplace.modeB;local v2198=nil;local v2199=v16:frame(v1143,UDim2.new(1,0,0,28),nil,v15.BTN);v2199.LayoutOrder=5;v16:corner(v2199,6);v16:stroke(v2199,v15.STROKE,1);v16:label(v2199,"Mode B — Select UUID (Auto-Restore)",UDim2.new(1, -52,1,0),UDim2.new(0,8,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;v16:toggle(v2199,UDim2.new(1, -48,0.5, -11),v33.pickplace.modeB,function(v2899) v2197=v2899;v33.pickplace.modeB=v2899;v37();if (v2899 and v1130) then if _G._PP_StartAutoRestore then _G._PP_StartAutoRestore();end elseif not v2899 then if _G._PP_StopAutoRestore then _G._PP_StopAutoRestore();end end end);local v2203=v16:frame(v1143,UDim2.new(1,0,0,28),nil,v15.BTN);v2203.LayoutOrder=6;v16:corner(v2203,6);v16:stroke(v2203,v15.STROKE,1);local v2205=v16:label(v2203,"UUID Pets: NONE",UDim2.new(1, -180,1,0),UDim2.new(0,8,0,0),v15.DIM,9);v2205.Font=Enum.Font.Gotham;local v2208=v16:button(v2203,"Clear",UDim2.new(0,40,0,20),UDim2.new(1, -172,0.5, -10),v15.BTN,v15.DIM,9);v16:stroke(v2208,v15.STROKE,1);local v2209=v16:button(v2203,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v2209,v15.STROKE,1);local function v2210() local v2901=0;for v3451 in pairs(v2196) do v2901=v2901 + 1 ;end if (v2901==0) then v2205.Text="UUID Pets: NONE";v2205.TextColor3=v15.DIM;else v2205.Text="UUID Pets: " .. v2901 .. " selected" ;v2205.TextColor3=v15.ACCENT;end end v2210();v2208.MouseButton1Click:Connect(function() for v3452 in pairs(v2196) do v2196[v3452]=nil;end v37();v2210();end);local v2211=v16:frame(v223,UDim2.new(1,0,1, -42),nil,v15.BG);v2211.Visible=false;v2211.ZIndex=20;local v2214=v16:frame(v2211,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v2214,v15.STROKE,1);v16:label(v2214,"Select Pets (by UUID)",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v2215=v16:button(v2214,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v2215,v15.STROKE,1);local v2216=v16:button(v2214,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v2216,v15.ERROR,1);v2216.MouseButton1Click:Connect(function() v2211.Visible=false;v2210();end);local v2217=v16:input(v2211,"","Search pet name...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v2217.TextColor3=v15.TEXT;v2217.Font=Enum.Font.Gotham;local v2221=v16:scroll(v2211,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v2221,3);v16:pad(v2221,3,4,4,3);local function v2222() local v2903=string.lower(v2217.Text);local v2904=v60();local v2905={};for v3454 in pairs(v2904) do table.insert(v2905,v3454);end table.sort(v2905,function(v3455,v3456) return v61(v3455)>v61(v3456) ;end);local v2906={};for v3457,v3458 in ipairs(v2905) do local v3459=v2904[v3458];if not v3459 then continue;end if ((v2903=="") or string.lower(v3459.PetType or "" ):find(v2903,1,true)) then table.insert(v2906,v3458);end end return v2906;end local function v2223() for v3460,v3461 in ipairs(v2221:GetChildren()) do if v3461:IsA("GuiObject") then v3461:Destroy();end end local v2907=v2222();local v2908= #v2907>0 ;for v3462,v3463 in ipairs(v2907) do if not v2196[v3463] then v2908=false;break;end end v2215.Text=(( #v2907==0) and "Select All") or (v2908 and "Unselect All") or "Select All" ;v2215.TextColor3=(v2908 and v15.SEL_TXT) or v15.ACCENT ;v2215.BackgroundColor3=(v2908 and v15.SEL_BG) or v15.BTN ;local v2912={};pcall(function() for v3862,v3863 in ipairs(v83()) do v2912[v3863]=true;end end);for v3464,v3465 in ipairs(v2907) do local v3466=v60();local v3467=v3466[v3465];if not v3467 then continue;end local v3468=v2196[v3465]==true ;local v3469=v2912[v3465]==true ;local v3470=(v3467.PetData and (v3467.PetData.Level or 0)) or 0 ;local v3471=v61(v3465);local v3472=(v65(v3465) and " ❤") or "" ;local v3473=(v3469 and " (active)") or "" ;local v3474=string.format("%s%s%s | Age %d | %.2f KG",v3467.PetType or "?" ,v3473,v3472,v3470,v3471);local v3475=v16:button(v2221,v3474,UDim2.new(1,0,0,26),nil,(v3468 and v15.SEL_BG) or (v3469 and v15.ACTIVE_BG) or Color3.fromRGB(13,13,13) ,(v3468 and v15.SEL_TXT) or (v3469 and v15.ACTIVE_TXT) or v15.TEXT ,9);v3475.LayoutOrder=v3464;v3475:SetAttribute("uuid",v3465);v3475.TextXAlignment=Enum.TextXAlignment.Left;v16:pad(v3475,0,8,4,0);v16:corner(v3475,4);v16:stroke(v3475,(v3468 and v15.ACCENT) or v15.STROKE ,1);v3475.MouseButton1Click:Connect(function() if v2196[v3465] then v2196[v3465]=nil;else v2196[v3465]=true;end v33.pickplace.selUUIDs=v2196;v37();v2210();v16:updateRowVisual(v3475,v2196[v3465]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end);end end v2215.MouseButton1Click:Connect(function() local v2913=v2222();local v2914= #v2913>0 ;for v3479,v3480 in ipairs(v2913) do if not v2196[v3480] then v2914=false;break;end end if v2914 then for v4096,v4097 in ipairs(v2913) do v2196[v4097]=nil;end else for v4099,v4100 in ipairs(v2913) do v2196[v4100]=true;end end v33.pickplace.selUUIDs=v2196;v37();v2210();v2223();end);v2217:GetPropertyChangedSignal("Text"):Connect(v2223);v2209.MouseButton1Click:Connect(function() v2211.Visible=true;v2223();end);local function v2224() if v2198 then task.cancel(v2198);v2198=nil;end v2198=task.spawn(function() while v33.pickplace.modeB and v1130 do task.wait(5);if v84.IsEquipping then continue;end local v3866=0;for v4102 in pairs(v2196) do v3866=v3866 + 1 ;end if (v3866==0) then continue;end local v3867=v83();local v3868={};for v4103,v4104 in ipairs(v3867) do v3868[v4104]=true;end local v3869=v60();local v3870={};for v4106 in pairs(v2196) do if (v3869[v4106] and not v3868[v4106]) then table.insert(v3870,v4106);end end if ( #v3870>0) then local v4246=v1140();v84.IsEquipping=true;for v4350,v4351 in ipairs(v3870) do pcall(function() v1139:FireServer("EquipPet",v4351,v4246);end);task.wait(v24.EQUIP_DELAY);end v84.IsEquipping=false;end end end);end _G._PP_StartAutoRestore=v2224;_G._PP_StopAutoRestore=function() if v2198 then task.cancel(v2198);v2198=nil;end end;_G._PP_GetModeB=function() return v33.pickplace.modeB;end;_G._PP_GetSelUUIDs=function() return v2196;end;end local v1169=v16:frame(v223,UDim2.new(1,0,0,38),UDim2.new(0,0,1, -38),v15.PANEL);v16:stroke(v1169,v15.STROKE,1);v16:label(v1169,"AUTO PICK PLACE",UDim2.new(1, -60,0,20),UDim2.new(0,8,0.5, -10),v15.TEXT,10).Font=Enum.Font.GothamBold;local v1172=v16:label(v1169,"● IDLE",UDim2.new(0,56,1,0),UDim2.new(1, -110,0,0),v15.DIM,8);v1172.Font=Enum.Font.Gotham;v1172.TextXAlignment=Enum.TextXAlignment.Right;local v1176=0;local v1177=0;local v1178=0;local v1179=v16:label(v1169,"PICK:0 SKIP:0 FIRE:0",UDim2.new(0,114,0,12),UDim2.new(0,60,1, -14),v15.DIM,7,Enum.TextXAlignment.Left);v1179.Font=Enum.Font.Gotham;local function v1181() v1179.Text=string.format("PICK:%d SKIP:%d FIRE:%d",v1176,v1177,v1178);end local function v1182(v2226) v1130=true;v1172.Text="● ON";v1172.TextColor3=v15.SUCCESS;table.clear(v1136);table.clear(v84.PP_Processing);v1176=0;v1177=0;v1178=0;v1181();if (_G._PP_GetModeB and _G._PP_GetModeB()) then if _G._PP_StartAutoRestore then _G._PP_StartAutoRestore();end end v1135=v1137.OnClientEvent:Connect(function(v2917,v2918) if ( not v1130 or not v2917) then return;end if (_G.MM_SuppressPickPlace or _G.AH_SuppressPickPlace) then v1177=v1177 + 1 ;v1181();return;end local v2919=tostring(v2917);v1178=v1178 + 1 ;v1181();if ( not v2918 or (typeof(v2918)~="table") or ( #v2918==0)) then return;end local v2920=false;for v3481,v3482 in ipairs(v2918) do local v3483=v3482.Time or 999 ;if (v3483<=v1131) then v2920=true;break;end end if not v2920 then return;end local v2921=v1141(v2919);if (_G._PP_GetModeB and _G._PP_GetModeB()) then local v3871=(_G._PP_GetSelUUIDs and _G._PP_GetSelUUIDs()) or {} ;local v3872=0;for v4107 in pairs(v3871) do v3872=v3872 + 1 ;end if ((v3872>0) and not v3871[v2919]) then v1177=v1177 + 1 ;v1181();return;end else local v3873=0;for v4108 in pairs(v1134) do v3873=v3873 + 1 ;end if ((v3873>0) and not v1134[v2921]) then v1177=v1177 + 1 ;v1181();return;end end v1176=v1176 + 1 ;v1181();v1142(v2919);end);end local v1183=v16:toggle(v1169,UDim2.new(1, -52,0.5, -11),v33.toggles.pickplace,function(v2230) v33.toggles.pickplace=v2230;v37();v1130=v2230;v29((v2230 and "feature_on") or "feature_off" ,{feature="pick_place"});if v2230 then v1182(ppTog);else v1172.Text="● IDLE";v1172.TextColor3=v15.DIM;if v1135 then v1135:Disconnect();v1135=nil;end if _G._PP_StopAutoRestore then _G._PP_StopAutoRestore();end table.clear(v1136);table.clear(v84.PP_Processing);end end);v240=v1183;if v33.toggles.pickplace then task.defer(function() v1182(v1183);end);end end v244();local function v245() local v1184=v16:scroll(v225,UDim2.new(1,0,1,0));v1184.ScrollingDirection=Enum.ScrollingDirection.Y;v1184.AutomaticCanvasSize=Enum.AutomaticSize.Y;v1184.ScrollBarThickness=3;v1184.ScrollBarImageColor3=v15.ACCENT;local v1192=Instance.new("Frame");v1192.Size=UDim2.new(1,0,0,0);v1192.BackgroundTransparency=1;v1192.AutomaticSize=Enum.AutomaticSize.Y;v1192.Parent=v1184;v16:list(v1192,6);v16:pad(v1192,6,6,6,80);local function v1197(v2232) local v2233=string.lower(v2232 or "" );local v2234=v60();local v2235={};for v2922 in pairs(v2234) do local v2923=v2234[v2922];if not v2923 then continue;end local v2924=string.lower(v2923.PetType or "" );if ((v2233=="") or v2924:find(v2233,1,true)) then table.insert(v2235,v2922);end end return v2235;end local v1198=v16:accordion(v1192,"⚡ QUICK BOOST",1,true);local v1199=v1198.Inner;local v1200=v16:label(v1199,"SELECT BOOST",UDim2.new(1,0,0,13),nil,v15.DIM,8);v1200.LayoutOrder=1;v1200.Font=Enum.Font.Gotham;local v1204={};for v2236 in pairs(v33.petboost.mode1.boostOptions or {} ) do v1204[v2236]=true;end if not next(v1204) then v1204["Small Toy"]=true;end local v1205={};for v2238,v2239 in ipairs(v31) do table.insert(v1205,{key=v2239.name,name=v2239.name});end local v1206=v16:inlinePickerDropdown(v1199,v109,{label="Boost",multiSelect=true,items=v1205,size=UDim2.new(1,0,0,28),zIndex=50,onSelect=function(v2240) for v2926 in pairs(v1204) do v1204[v2926]=nil;end for v2928,v2929 in ipairs(v2240) do v1204[v2929]=true;end for v2931 in pairs(v33.petboost.mode1.boostOptions) do v33.petboost.mode1.boostOptions[v2931]=nil;end for v2933,v2934 in ipairs(v2240) do v33.petboost.mode1.boostOptions[v2934]=true;end v37();end});v1206.row.LayoutOrder=2;do local v2241={};for v2936 in pairs(v1204) do table.insert(v2241,v2936);end if ( #v2241>0) then v1206.Set(v2241);end end local v1208=v33.petboost.mode1.selPets;local v1209=v16:frame(v1199,UDim2.new(1,0,0,26),nil,v15.DARK_CARD,0);v1209.LayoutOrder=3;local v1211=v16:label(v1209,"Pets: ALL",UDim2.new(1, -96,1,0),UDim2.new(0,4,0,0),v15.DIM,9);v1211.Font=Enum.Font.Gotham;local v1213=v16:button(v1209,"Select pets >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1213,v15.STROKE,1);local function v1214() local v2242=0;for v2937 in pairs(v1208) do v2242=v2242 + 1 ;end if (v2242==0) then v1211.Text="Pets: ALL";v1211.TextColor3=v15.DIM;else v1211.Text="Pets: " .. v2242 .. " selected" ;v1211.TextColor3=v15.ACCENT;end end v1214();local v1215=v16:frame(v1199,UDim2.new(1,0,0,28),nil,v15.DARK_CARD,0);v1215.LayoutOrder=4;v16:label(v1215,"AUTO BOOST",UDim2.new(1, -100,1,0),UDim2.new(0,4,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;local v1219=v16:label(v1215,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),v15.DIM,8);v1219.Font=Enum.Font.Gotham;local v1221=false;local function v1222() v1221=true;v1219.Text="● ON";v1219.TextColor3=v15.SUCCESS;task.spawn(function() while v1221 do task.wait(v30.APPLY_DELAY);if v84.GlobalBoostApplying then continue;end local v3493=v83();local v3494={};for v3874,v3875 in ipairs(v3493) do v3494[v3875]=true;end local v3495={};local v3496=0;for v3877 in pairs(v1208) do v3496=v3496 + 1 ;end if (v3496==0) then for v4248 in pairs(v3494) do table.insert(v3495,v4248);end else for v4249 in pairs(v1208) do if v3494[v4249] then table.insert(v3495,v4249);end end end for v3878 in pairs(v1204) do local v3879,v3880=v32(v3878);for v4109,v4110 in ipairs(v3495) do if ( not v1221 or GlobalBoostApplying) then break;end if v106(v4110,v3879,v3880) then continue;end if not v107(v3879,v3880) then continue;end local v4111=v108(v4110,v3879,v3880);if v4111 then v1219.Text="✓ " .. v64(v4110) .. " (" .. v3879 .. ")" ;v1219.TextColor3=v15.SUCCESS;end end end v1219.Text="● ON";v1219.TextColor3=v15.SUCCESS;end v1219.Text="● IDLE";v1219.TextColor3=v15.DIM;end);end local v1223=v16:toggle(v1215,UDim2.new(1, -48,0.5, -11),v33.toggles.mode1boost,function(v2246) v33.toggles.mode1boost=v2246;v37();v29((v2246 and "feature_on") or "feature_off" ,{feature="auto_boost_m1"});if v2246 then v1221=true;v1222();else v1221=false;v1219.Text="● IDLE";v1219.TextColor3=v15.DIM;end end);v241=v1223;if v33.toggles.mode1boost then task.defer(function() v1222();end);end local v1224=v16:accordion(v1192,"⚡ BOOST MODE 2",3,false);local v1225=v1224.Inner;local v1226=v16:label(v1225,"ADD PAIR",UDim2.new(1,0,0,13),nil,v15.DIM,8);v1226.LayoutOrder=1;v1226.Font=Enum.Font.Gotham;local v1229=v16:frame(v1225,UDim2.new(1,0,0,28),nil,v15.BTN);v1229.LayoutOrder=2;v16:corner(v1229,5);v16:stroke(v1229,v15.STROKE,1);local v1231=v16:label(v1229,"No pet selected",UDim2.new(1, -92,1,0),UDim2.new(0,8,0,0),v15.DIM,9);v1231.Font=Enum.Font.Gotham;local v1233=v16:button(v1229,"Pick pet >",UDim2.new(0,84,0,20),UDim2.new(1, -88,0.5, -10),v15.BTN,v15.ACCENT,9);v16:stroke(v1233,v15.STROKE,1);local v1234=v16:label(v1225,"SELECT BOOST",UDim2.new(1,0,0,13),nil,v15.DIM,8);v1234.LayoutOrder=3;v1234.Font=Enum.Font.Gotham;local v1237={};if ((type(v33.petboost.mode2.boostOptions)=="table") and next(v33.petboost.mode2.boostOptions)) then for v3503 in pairs(v33.petboost.mode2.boostOptions) do v1237[v3503]=true;end else v1237["Small Toy"]=true;end local v1238=v16:inlinePickerDropdown(v1225,v109,{label="Boost",multiSelect=true,items=v1205,size=UDim2.new(1,0,0,28),zIndex=51,onSelect=function(v2248) for v2942 in pairs(v1237) do v1237[v2942]=nil;end for v2944,v2945 in ipairs(v2248) do v1237[v2945]=true;end v34=v2248[1] or "Small Toy" ;if not v33.petboost.mode2.boostOptions then v33.petboost.mode2.boostOptions={};end for v2947 in pairs(v33.petboost.mode2.boostOptions) do v33.petboost.mode2.boostOptions[v2947]=nil;end for v2949,v2950 in ipairs(v2248) do v33.petboost.mode2.boostOptions[v2950]=true;end v37();end});v1238.row.LayoutOrder=4;do local v2249={};for v2952 in pairs(v1237) do table.insert(v2249,v2952);end if ( #v2249>0) then v1238.Set(v2249);end end local v1240=v16:button(v1225,"+ ADD TO LIST",UDim2.new(1,0,0,26),nil,v15.ACCENT,v15.SEL_TXT,10);v1240.LayoutOrder=5;v16:stroke(v1240,v15.ACCENT,1);v16:divider(v1225,6);local v1242=v16:label(v1225,"BOOST LIST:",UDim2.new(1,0,0,13),nil,v15.DIM,8);v1242.LayoutOrder=7;v1242.Font=Enum.Font.Gotham;local v1245=v16:frame(v1225,UDim2.new(1,0,0,0),nil,v15.DARK_CARD,0);v1245.LayoutOrder=8;v1245.AutomaticSize=Enum.AutomaticSize.Y;v16:list(v1245,3);local function v1248() for v2953,v2954 in ipairs(v1245:GetChildren()) do if v2954:IsA("GuiObject") then v2954:Destroy();end end if ( #v33.petboost.mode2.pairs==0) then local v3506=v16:label(v1245," (no pets added)",UDim2.new(1,0,0,18),nil,v15.DIM,9);v3506.Font=Enum.Font.Gotham;v3506.LayoutOrder=1;return;end for v2955,v2956 in ipairs(v33.petboost.mode2.pairs) do local v2957=v64(v2956.uuid);local v2958=v61(v2956.uuid);local v2959=v62(v2956.uuid);local v2960=(v65(v2956.uuid) and " ❤") or "" ;local v2961=v16:frame(v1245,UDim2.new(1,0,0,40),nil,v15.BTN);v2961.LayoutOrder=v2955;v16:corner(v2961,5);v16:stroke(v2961,v15.STROKE,1);v16:label(v2961,v2957 .. v2960 ,UDim2.new(1, -34,0,16),UDim2.new(0,8,0,3),v15.TEXT,9);local v2963=v16:label(v2961,string.format("Age %d | %.2fKG | %s · %s",v2959,v2958,v2956.boostType,v2956.boostSize),UDim2.new(1, -34,0,13),UDim2.new(0,8,0,22),v15.DIM,8);v2963.Font=Enum.Font.Gotham;local v2966=v16:button(v2961,"-",UDim2.new(0,24,0,24),UDim2.new(1, -28,0.5, -12),v15.ERROR,v15.TEXT,14);v16:stroke(v2966,v15.ERROR,1);local v2967=v2955;v2966.MouseButton1Click:Connect(function() table.remove(v33.petboost.mode2.pairs,v2967);v37();v1248();end);end end v1248();local v1249;local v1250={};local function v1251() local v2250=0;for v2968 in pairs(v1250) do v2250=v2250 + 1 ;end if (v2250==0) then v1231.Text="No pet selected";v1231.TextColor3=v15.DIM;else v1231.Text=v2250 .. " pet(s) selected" ;v1231.TextColor3=v15.ACCENT;end end v1240.MouseButton1Click:Connect(function() local v2251=0;for v2969 in pairs(v1237) do local v2970,v2971=v32(v2969);for v3516,v3517 in pairs(v1250) do if not v3517 then continue;end local v3518=false;for v3881,v3882 in ipairs(v33.petboost.mode2.pairs) do if ((v3882.uuid==v3516) and (v3882.boostType==v2971) and (v3882.boostSize==v2970)) then v3518=true;break;end end if not v3518 then table.insert(v33.petboost.mode2.pairs,{uuid=v3516,boostType=v2971,boostSize=v2970});v2251=v2251 + 1 ;end end end if (v2251>0) then v37();v1248();for v3883 in pairs(v1250) do v1250[v3883]=nil;end v1231.Text="No pet selected";v1231.TextColor3=v15.DIM;v1251();if v1249 then v1249.Visible=false;end end end);local v1252=v16:frame(v1225,UDim2.new(1,0,0,28),nil,v15.DARK_CARD,0);v1252.LayoutOrder=9;v16:label(v1252,"AUTO BOOST (M2)",UDim2.new(1, -100,1,0),UDim2.new(0,4,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;local v1255=v16:label(v1252,"● IDLE",UDim2.new(0,50,1,0),UDim2.new(1, -104,0,0),v15.DIM,8);v1255.Font=Enum.Font.Gotham;local v1257=false;local function v1258() v1257=true;v1255.Text="● ON";v1255.TextColor3=v15.SUCCESS;task.spawn(function() while v1257 do task.wait(v30.APPLY_DELAY);if v84.GlobalBoostApplying then continue;end local v3522=v83();local v3523={};for v3885,v3886 in ipairs(v3522) do v3523[v3886]=true;end for v3888,v3889 in ipairs(v33.petboost.mode2.pairs) do if ( not v1257 or GlobalBoostApplying) then break;end if not v3523[v3889.uuid] then continue;end if v106(v3889.uuid,v3889.boostSize,v3889.boostType) then continue;end if not v107(v3889.boostSize,v3889.boostType) then continue;end local v3890=v108(v3889.uuid,v3889.boostSize,v3889.boostType);if v3890 then v1255.Text="✓ " .. v64(v3889.uuid) .. " (" .. v3889.boostSize .. ")" ;v1255.TextColor3=v15.SUCCESS;end end v1255.Text="● ON";v1255.TextColor3=v15.SUCCESS;end v1255.Text="● IDLE";v1255.TextColor3=v15.DIM;end);end local v1259=v16:toggle(v1252,UDim2.new(1, -48,0.5, -11),v33.toggles.mode2boost,function(v2255) v33.toggles.mode2boost=v2255;v37();v29((v2255 and "feature_on") or "feature_off" ,{feature="auto_boost_m2"});if v2255 then v1257=true;v1258();else v1257=false;v1255.Text="● IDLE";v1255.TextColor3=v15.DIM;end end);v242=v1259;if v33.toggles.mode2boost then task.defer(function() v1258();end);end do local v2257=v16:frame(v225,UDim2.new(1,0,1,0),nil,v15.BG);v2257.Visible=false;v2257.ZIndex=30;local v2260=v16:frame(v2257,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v2260,v15.STROKE,1);v16:label(v2260,"Select Pets — Quick Boost",UDim2.new(1, -96,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v2261=v16:button(v2260,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -92,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v2261,v15.STROKE,1);local v2262=v16:button(v2260,"X",UDim2.new(0,24,0,20),UDim2.new(1, -28,0.5, -10),v15.ERROR,v15.TEXT,10);v16:stroke(v2262,v15.ERROR,1);v2262.MouseButton1Click:Connect(function() v2257.Visible=false;v1214();end);local v2263=v16:input(v2257,"","Search...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v2263.TextColor3=v15.TEXT;v2263.Font=Enum.Font.Gotham;local v2268=v16:scroll(v2257,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v2268,3);v16:pad(v2268,3,4,4,3);local function v2269() local v2976={};pcall(function() for v3891,v3892 in ipairs(v83()) do v2976[v3892]=true;end end);local v2977=v1197(v2263.Text);local v2978= #v2977>0 ;for v3530,v3531 in ipairs(v2977) do if not v1208[v3531] then v2978=false;break;end end v2261.Text=(( #v2977==0) and "Select All") or (v2978 and "Unselect All") or "Select All" ;v2261.TextColor3=(v2978 and v15.SEL_TXT) or v15.ACCENT ;v2261.BackgroundColor3=(v2978 and v15.SEL_BG) or v15.BTN ;v16:buildPetList(v2268,v2976,v1208,function(v3532,v3533,v3534) if v3534[v3532] then v3534[v3532]=nil;else v3534[v3532]=true;end v37();v1214();v16:updateRowVisual(v3533,v3534[v3532]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end,v2263.Text,v61,v60,v65,v62);end v2261.MouseButton1Click:Connect(function() local v2982=v1197(v2263.Text);local v2983= #v2982>0 ;for v3535,v3536 in ipairs(v2982) do if not v1208[v3536] then v2983=false;break;end end if v2983 then for v4115,v4116 in ipairs(v2982) do v1208[v4116]=nil;end else for v4118,v4119 in ipairs(v2982) do v1208[v4119]=true;end end v37();v1214();for v3537,v3538 in ipairs(v2268:GetChildren()) do if v3538:IsA("TextButton") then local v4121=v3538:GetAttribute("uuid");if v4121 then v16:updateRowVisual(v3538,v1208[v4121]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end end end end);v2263:GetPropertyChangedSignal("Text"):Connect(v2269);v1213.MouseButton1Click:Connect(function() v2257.Visible=true;task.delay(0.1,v2269);end);end do v1249=v16:frame(v225,UDim2.new(1,0,1,0),nil,v15.BG);v1249.Visible=false;v1249.ZIndex=30;local v2272=v16:frame(v1249,UDim2.new(1,0,0,26),nil,v15.PANEL);v16:stroke(v2272,v15.STROKE,1);v16:label(v2272,"Pick Pet — Mode 2",UDim2.new(1, -116,1,0),UDim2.new(0,8,0,0),v15.ACCENT,10);local v2273=v16:button(v2272,"Select All",UDim2.new(0,64,0,20),UDim2.new(1, -112,0.5, -10),v15.BTN,v15.ACCENT,8);v16:stroke(v2273,v15.STROKE,1);local v2274=v16:button(v2272,"Done",UDim2.new(0,40,0,20),UDim2.new(1, -44,0.5, -10),v15.ACCENT,v15.TEXT,10);v16:stroke(v2274,v15.ACCENT,1);v2274.MouseButton1Click:Connect(function() v1249.Visible=false;end);local v2275=v16:input(v1249,"","Search...",UDim2.new(1, -8,0,22),UDim2.new(0,4,0,28));v2275.TextColor3=v15.TEXT;v2275.Font=Enum.Font.Gotham;local v2280=v16:scroll(v1249,UDim2.new(1,0,1, -56),UDim2.new(0,0,0,54));v16:list(v2280,3);v16:pad(v2280,3,4,4,3);local function v2281() local v2986={};pcall(function() for v3894,v3895 in ipairs(v83()) do v2986[v3895]=true;end end);local v2987=v1197(v2275.Text);local v2988= #v2987>0 ;for v3539,v3540 in ipairs(v2987) do if not v1250[v3540] then v2988=false;break;end end v2273.Text=(( #v2987==0) and "Select All") or (v2988 and "Unselect All") or "Select All" ;v2273.TextColor3=(v2988 and v15.SEL_TXT) or v15.ACCENT ;v2273.BackgroundColor3=(v2988 and v15.SEL_BG) or v15.BTN ;v16:buildPetList(v2280,v2986,v1250,function(v3541,v3542,v3543) if v3543[v3541] then v3543[v3541]=nil;else v3543[v3541]=true;end v1251();v16:updateRowVisual(v3542,v3543[v3541]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end,v2275.Text,v61,v60,v65,v62);end v2273.MouseButton1Click:Connect(function() local v2992=v1197(v2275.Text);local v2993= #v2992>0 ;for v3544,v3545 in ipairs(v2992) do if not v1250[v3545] then v2993=false;break;end end if v2993 then for v4124,v4125 in ipairs(v2992) do v1250[v4125]=nil;end else for v4127,v4128 in ipairs(v2992) do v1250[v4128]=true;end end v1251();for v3546,v3547 in ipairs(v2280:GetChildren()) do if v3547:IsA("TextButton") then local v4130=v3547:GetAttribute("uuid");if v4130 then v16:updateRowVisual(v3547,v1250[v4130]==true ,v15.SEL_BG,v15.SEL_TXT,Color3.fromRGB(13,13,13),v15.TEXT,v15.ACCENT,v15.STROKE);end end end end);v2275:GetPropertyChangedSignal("Text"):Connect(v2281);v1233.MouseButton1Click:Connect(function() v1249.Visible=true;task.delay(0.1,v2281);end);end end v245();local function v246() local v1260=v16:scroll(v227,UDim2.new(1,0,1,0));v16:list(v1260,6);v16:pad(v1260,8,8,8,8);local v1261=v16:label(v1260,"🦇 WEBHOOK",UDim2.new(1,0,0,16),nil,v15.ACCENT,11);v1261.LayoutOrder=1;local v1263=v16:label(v1260,"Webhook URL",UDim2.new(1,0,0,13),nil,v15.DIM,8);v1263.LayoutOrder=2;v1263.Font=Enum.Font.Gotham;local v1267=Instance.new("TextBox");v1267.Size=UDim2.new(1,0,0,28);v1267.BackgroundColor3=v15.BTN;v1267.BorderSizePixel=0;v1267.Text=v33.webhook.url or "" ;v1267.PlaceholderText="https://discord.com/api/webhooks/ID/TOKEN";v1267.TextColor3=v15.ACCENT;v1267.PlaceholderColor3=v15.DIM;v1267.Font=Enum.Font.Gotham;v1267.TextSize=9;v1267.ClearTextOnFocus=false;v1267.TextTruncate=Enum.TextTruncate.AtEnd;v1267.TextXAlignment=Enum.TextXAlignment.Left;v1267.LayoutOrder=3;v1267.Parent=v1260;v16:corner(v1267,5);v16:stroke(v1267,v15.STROKE,1);v16:pad(v1267,0,8,8,0);v1267.FocusLost:Connect(function() v33.webhook.url=v1267.Text;v37();end);v1267:GetPropertyChangedSignal("Text"):Connect(function() v33.webhook.url=v1267.Text;end);local v1287=v16:frame(v1260,UDim2.new(1,0,0,28),nil,v15.BTN);v1287.LayoutOrder=4;v16:corner(v1287,5);v16:stroke(v1287,v15.STROKE,1);v16:label(v1287,"Continue Session (after rejoin)",UDim2.new(1, -52,1,0),UDim2.new(0,8,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;v16:toggle(v1287,UDim2.new(1, -48,0.5, -11),v33.webhook.continueSession,function(v2286) v33.webhook.continueSession=v2286;v37();if not v2286 then v50();end end);local v1291=v16:button(v1260,"🔄 Reset Session Data",UDim2.new(1,0,0,28),nil,v15.BTN,v15.ERROR,10);v1291.LayoutOrder=5;v16:stroke(v1291,v15.ERROR,1);v1291.MouseButton1Click:Connect(function() v50();v1291.Text="✓ Session Reset!";v1291.TextColor3=v15.SUCCESS;task.delay(2,function() v1291.Text="🔄 Reset Session Data";v1291.TextColor3=v15.ERROR;end);end);local v1293=v16:button(v1260,"Send Test",UDim2.new(1,0,0,26),nil,v15.BTN,v15.ACCENT,10);v1293.LayoutOrder=6;v16:stroke(v1293,v15.STROKE,1);v1293.MouseButton1Click:Connect(function() if (v33.webhook.url=="") then v1293.Text="⚠ No URL!";v1293.TextColor3=v15.ERROR;task.delay(1.5,function() v1293.Text="Send Test";v1293.TextColor3=v15.ACCENT;end);return;end task.spawn(v73);v1293.Text="Sent!";v1293.TextColor3=v15.SUCCESS;task.delay(1.5,function() v1293.Text="Send Test";v1293.TextColor3=v15.ACCENT;end);end);end v246();local v247=Instance.new("TextButton",v109);v247.Size=UDim2.new(0,42,0,42);v247.Position=UDim2.new(0,20,0.5, -21);v247.BackgroundColor3=Color3.fromRGB(18,18,18);v247.BorderSizePixel=0;v247.Text="";v247.TextColor3=v15.ACCENT;v247.Font=Enum.Font.GothamBold;v247.TextSize=18;v247.Active=true;v247.Draggable=true;v247.Visible=false;v16:corner(v247,10);v16:stroke(v247,v15.ACCENT,1);local v261=Instance.new("ImageLabel",v247);v261.Size=UDim2.new(1, -6,1, -6);v261.Position=UDim2.new(0,3,0,3);v261.BackgroundTransparency=1;v261.Image="rbxthumb://type=Asset&id=5669312251&w=150&h=150";v261.ScaleType=Enum.ScaleType.Fit;v247.MouseButton1Click:Connect(function() v247.Visible=false;v122.Visible=true;end);v133.MouseButton1Click:Connect(function() v122.Visible=false;v247.Visible=true;end);do local v1299,v1300,v1301,v1302=420,900,320,700;local v1303=Instance.new("Frame",v122);v1303.Size=UDim2.new(0,28,0,28);v1303.Position=UDim2.new(1, -28,1, -28);v1303.BackgroundTransparency=1;v1303.BorderSizePixel=0;v1303.Active=true;v1303.ZIndex=9999;local function v1310(v2294,v2295) local v2296=Instance.new("Frame",v1303);v2296.Size=UDim2.new(0,4,0,4);v2296.Position=UDim2.new(0,v2294,0,v2295);v2296.BackgroundColor3=v15.ACCENT;v2296.BackgroundTransparency=0.3;v2296.BorderSizePixel=0;v2296.ZIndex=9999;v16:corner(v2296,2);end v1310(16,16);v1310(10,22);v1310(22,10);local v1311,v1312,v1313,v1314=false,nil,nil,nil;v1303.InputBegan:Connect(function(v2304) if ((v2304.UserInputType==Enum.UserInputType.MouseButton1) or (v2304.UserInputType==Enum.UserInputType.Touch)) then v1311=true;v1312=v2304;v1313=v2304.Position;v1314=v122.Size;v2304.Changed:Connect(function() if (v2304.UserInputState==Enum.UserInputState.End) then v1311=false;end end);end end);v1303.InputChanged:Connect(function(v2305) if ((v2305.UserInputType==Enum.UserInputType.MouseMovement) or (v2305.UserInputType==Enum.UserInputType.Touch)) then v1312=v2305;end end);v6.InputChanged:Connect(function(v2306) if ( not v1311 or (v2306~=v1312)) then return;end local v2307=v2306.Position-v1313 ;v122.Size=UDim2.new(0,math.clamp(v1314.X.Offset + v2307.X ,v1299,v1300),0,math.clamp(v1314.Y.Offset + v2307.Y ,v1301,v1302));end);end task.spawn(function() local v1315=game:GetService("VirtualUser");task.wait(10);while true do task.wait(15 * 60 );pcall(function() v1315:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.15);v1315:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.3);v1315:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame);task.wait(0.15);v1315:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame);end);end end);local function v267() local v1316=v16:scroll(v181,UDim2.new(1,0,1,0));v1316.ScrollingDirection=Enum.ScrollingDirection.Y;v1316.AutomaticCanvasSize=Enum.AutomaticSize.Y;v1316.ScrollBarThickness=3;v1316.ScrollBarImageColor3=v15.ACCENT;local v1324=Instance.new("Frame",v1316);v1324.Size=UDim2.new(1,0,0,0);v1324.BackgroundTransparency=1;v1324.AutomaticSize=Enum.AutomaticSize.Y;v16:list(v1324,4);v16:pad(v1324,6,6,6,20);local v1328=v16:accordion(v1324,"👁 VISIBILITY",1,true);do local v2309={};local function v2310(v3001) if (v3001:IsA("BasePart") or v3001:IsA("UnionOperation") or v3001:IsA("MeshPart")) then pcall(function() v3001.Transparency=1;end);end if (v3001:IsA("Decal") or v3001:IsA("Texture")) then pcall(function() v3001.Transparency=1;end);end if (v3001:IsA("ParticleEmitter") or v3001:IsA("Trail") or v3001:IsA("Beam")) then pcall(function() v3001.Enabled=false;end);end if (v3001:IsA("PointLight") or v3001:IsA("SpotLight") or v3001:IsA("SurfaceLight")) then pcall(function() v3001.Enabled=false;end);end end local function v2311() local v3002=workspace:FindFirstChild("Farm");if not v3002 then return;end local function v3003(v3553) local v3554=v3553:FindFirstChild("Important");if not v3554 then return;end local v3555=v3554:FindFirstChild("Plants_Physical");if not v3555 then return;end for v3900,v3901 in ipairs(v3555:GetDescendants()) do v2310(v3901);end table.insert(v2309,v3555.DescendantAdded:Connect(function(v3902) task.wait();v2310(v3902);end));end for v3556,v3557 in ipairs(v3002:GetChildren()) do v3003(v3557);end table.insert(v2309,v3002.ChildAdded:Connect(function(v3558) task.wait(0.5);v3003(v3558);end));end local v2312=v16:frame(v1328.Inner,UDim2.new(1,0,0,26),nil,v15.BTN);v2312.LayoutOrder=1;v16:corner(v2312,5);v16:stroke(v2312,v15.STROKE,1);v16:label(v2312,"Hide Farm Plants",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;v16:toggle(v2312,UDim2.new(1, -48,0.5, -11),v33.toggles.hidePlants,function(v3004) v33.toggles.hidePlants=v3004;v37();if v3004 then v2311();else for v4135,v4136 in ipairs(v2309) do pcall(function() v4136:Disconnect();end);end table.clear(v2309);end end);if v33.toggles.hidePlants then v2311();end end local v1329=v16:accordion(v1324,"🔄 AUTO RENEW SERVER",2,true);do local v2316=v1329.Inner;local v2317=v16:frame(v2316,UDim2.new(1,0,0,26),nil,v15.BTN);v2317.LayoutOrder=1;v16:corner(v2317,5);v16:stroke(v2317,v15.STROKE,1);local v2319=v16:label(v2317,"Job ID: " .. tostring(game.JobId) ,UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),v15.DIM,8);v2319.Font=Enum.Font.Gotham;v2319.TextTruncate=Enum.TextTruncate.AtEnd;v2319.TextXAlignment=Enum.TextXAlignment.Left;local v2326=v16:frame(v2316,UDim2.new(1,0,0,26),nil,v15.BTN);v2326.LayoutOrder=2;v16:corner(v2326,5);v16:stroke(v2326,v15.STROKE,1);local v2328=v16:label(v2326,"Server Version: " .. tostring(game.PlaceVersion) ,UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),v15.DIM,8);v2328.Font=Enum.Font.Gotham;v2328.TextXAlignment=Enum.TextXAlignment.Left;local v2331=v16:frame(v2316,UDim2.new(1,0,0,26),nil,v15.BTN);v2331.LayoutOrder=3;v16:corner(v2331,5);v16:stroke(v2331,v15.STROKE,1);v16:label(v2331,"Interval (minutes)",UDim2.new(1, -80,1,0),UDim2.new(0,6,0,0),v15.DIM,9).Font=Enum.Font.Gotham;local v2334=v33.misc.rsInterval;local v2335=v16:input(v2331,v2334,"",UDim2.new(0,64,0,20),UDim2.new(1, -68,0.5, -10));v2335.FocusLost:Connect(function() local v3006=tonumber(v2335.Text);if (v3006 and (v3006>=1)) then v2334=v3006;v33.misc.rsInterval=v3006;v37();else v2335.Text=tostring(v2334);end end);local v2336=v16:frame(v2316,UDim2.new(1,0,0,26),nil,v15.BTN);v2336.LayoutOrder=4;v16:corner(v2336,5);v16:stroke(v2336,v15.STROKE,1);local v2338=v16:label(v2336,"Next rejoin: --:--",UDim2.new(1,0,1,0),UDim2.new(0,6,0,0),v15.DIM,9);v2338.Font=Enum.Font.Gotham;v2338.TextXAlignment=Enum.TextXAlignment.Left;local v2341=v16:frame(v2316,UDim2.new(1,0,0,26),nil,v15.BTN);v2341.LayoutOrder=5;v16:corner(v2341,5);v16:stroke(v2341,v15.STROKE,1);v16:label(v2341,"AUTO RENEW SERVER",UDim2.new(1, -52,1,0),UDim2.new(0,6,0,0),v15.TEXT,9).Font=Enum.Font.GothamBold;local v2345=nil;v16:toggle(v2341,UDim2.new(1, -48,0.5, -11),v33.toggles.autoRefresh,function(v3007) v33.toggles.autoRefresh=v3007;v37();local v3009=false;if v3007 then v3009=true;v2345=task.spawn(function() while v3009 do local v4253=v2334 * 60 ;local v4254=0;while (v4254
