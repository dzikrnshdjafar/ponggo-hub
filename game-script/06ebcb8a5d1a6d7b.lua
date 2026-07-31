-- PonggoHub | Grow a Garden: Trade World Booth Scanner
-- Overwritten with new, clean, keyless script as requested by user.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Check if UI already exists and destroy it
local existingUi = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("PonggoHubMarket")
if existingUi then
    existingUi:Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PonggoHubMarket"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Variables for UI State
local isOpen = true
local allItems = {}
local autoListEnabled = false
local selectedPetType = "Any"
local notifiedListings = {}
local autoListLoopActive = false

-- Helper to create rounded corners
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Helper to create UIStroke (Borders)
local function addStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Helper to create Gradients
local function addGradient(parent, color1, color2)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Parent = parent
    return gradient
end

-- Create Minimize/Open Button (Floating Button)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0.5, -25)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleButton.Text = "🛒"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 24
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = ScreenGui
ToggleButton.Visible = false
addCorner(ToggleButton, 25)
addStroke(ToggleButton, Color3.fromRGB(138, 35, 135), 2, 0.4)
addGradient(ToggleButton, Color3.fromRGB(138, 35, 135), Color3.fromRGB(233, 64, 87))

-- Main GUI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 600)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true -- Enable drag & drop for the window
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 12)
addStroke(MainFrame, Color3.fromRGB(255, 255, 255), 1, 0.9)

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
TitleBar.Parent = MainFrame
addCorner(TitleBar, 12)

-- Cover the bottom rounded corners of the TitleBar to merge with the MainFrame
local TitleBarCover = Instance.new("Frame")
TitleBarCover.Name = "TitleBarCover"
TitleBarCover.Size = UDim2.new(1, 0, 0.5, 0)
TitleBarCover.Position = UDim2.new(0, 0, 0.5, 0)
TitleBarCover.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
TitleBarCover.BorderSizePixel = 0
TitleBarCover.ZIndex = 0
TitleBarCover.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "PonggoHub Market Scanner"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Refresh Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Name = "RefreshBtn"
RefreshBtn.Size = UDim2.new(0, 30, 0, 30)
RefreshBtn.Position = UDim2.new(1, -75, 0.5, -15)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
RefreshBtn.Text = "🔄"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 14
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = TitleBar
addCorner(RefreshBtn, 6)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
addCorner(CloseBtn, 6)

-- Pet Finder Container (Settings Panel)
local PetFinderPanel = Instance.new("Frame")
PetFinderPanel.Name = "PetFinderPanel"
PetFinderPanel.Size = UDim2.new(1, -30, 0, 130)
PetFinderPanel.Position = UDim2.new(0, 15, 0, 55)
PetFinderPanel.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
PetFinderPanel.Parent = MainFrame
addCorner(PetFinderPanel, 8)
addStroke(PetFinderPanel, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Toggle Button for Auto List
local ToggleAutoListBtn = Instance.new("TextButton")
ToggleAutoListBtn.Name = "ToggleAutoListBtn"
ToggleAutoListBtn.Size = UDim2.new(0, 180, 0, 30)
ToggleAutoListBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87) -- Starts Off (Red)
ToggleAutoListBtn.Text = "Auto List Pets: OFF"
ToggleAutoListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoListBtn.TextSize = 12
ToggleAutoListBtn.Font = Enum.Font.GothamBold
ToggleAutoListBtn.Parent = PetFinderPanel
addCorner(ToggleAutoListBtn, 6)

-- Max Price Input
local MaxPriceInput = Instance.new("TextBox")
MaxPriceInput.Name = "MaxPriceInput"
MaxPriceInput.Size = UDim2.new(0, 180, 0, 30)
MaxPriceInput.Position = UDim2.new(1, -190, 0, 10)
MaxPriceInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MaxPriceInput.PlaceholderText = "Max Price (Tokens)"
MaxPriceInput.Text = ""
MaxPriceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxPriceInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
MaxPriceInput.TextSize = 12
MaxPriceInput.Font = Enum.Font.Gotham
MaxPriceInput.Parent = PetFinderPanel
addCorner(MaxPriceInput, 6)
addStroke(MaxPriceInput, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Dropdown Button for Pet Type
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Name = "DropdownBtn"
DropdownBtn.Size = UDim2.new(0, 180, 0, 30)
DropdownBtn.Position = UDim2.new(0, 10, 0, 50)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
DropdownBtn.Text = "Pet Type: Any"
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.TextSize = 12
DropdownBtn.Font = Enum.Font.GothamBold
DropdownBtn.Parent = PetFinderPanel
addCorner(DropdownBtn, 6)
addStroke(DropdownBtn, Color3.fromRGB(255, 255, 255), 1, 0.9)

-- Dropdown Scrolling Frame Menu (ZIndex layered above main elements)
local DropdownMenu = Instance.new("ScrollingFrame")
DropdownMenu.Name = "DropdownMenu"
DropdownMenu.Size = UDim2.new(0, 180, 0, 150)
DropdownMenu.Position = UDim2.new(0, 10, 0, 85)
DropdownMenu.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.ZIndex = 30
DropdownMenu.Visible = false
DropdownMenu.ScrollBarThickness = 4
DropdownMenu.ScrollBarImageColor3 = Color3.fromRGB(138, 35, 135)
DropdownMenu.Parent = PetFinderPanel
addCorner(DropdownMenu, 6)
addStroke(DropdownMenu, Color3.fromRGB(138, 35, 135), 1, 0.7)

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Padding = UDim.new(0, 4)
DropdownLayout.Parent = DropdownMenu

DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    DropdownMenu.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 6)
end)

-- Min Weight Input
local MinWeightInput = Instance.new("TextBox")
MinWeightInput.Name = "MinWeightInput"
MinWeightInput.Size = UDim2.new(0, 85, 0, 30)
MinWeightInput.Position = UDim2.new(1, -190, 0, 50)
MinWeightInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MinWeightInput.PlaceholderText = "Min Wt"
MinWeightInput.Text = ""
MinWeightInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MinWeightInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
MinWeightInput.TextSize = 12
MinWeightInput.Font = Enum.Font.Gotham
MinWeightInput.Parent = PetFinderPanel
addCorner(MinWeightInput, 6)
addStroke(MinWeightInput, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Max Weight Input
local MaxWeightInput = Instance.new("TextBox")
MaxWeightInput.Name = "MaxWeightInput"
MaxWeightInput.Size = UDim2.new(0, 85, 0, 30)
MaxWeightInput.Position = UDim2.new(1, -95, 0, 50)
MaxWeightInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MaxWeightInput.PlaceholderText = "Max Wt"
MaxWeightInput.Text = ""
MaxWeightInput.TextColor3 = Color3.fromRGB(255, 255, 255)
MaxWeightInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
MaxWeightInput.TextSize = 12
MaxWeightInput.Font = Enum.Font.Gotham
MaxWeightInput.Parent = PetFinderPanel
addCorner(MaxWeightInput, 6)
addStroke(MaxWeightInput, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Auto List Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 95)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = PetFinderPanel

-- Search Bar Container
local SearchContainer = Instance.new("Frame")
SearchContainer.Name = "SearchContainer"
SearchContainer.Size = UDim2.new(1, -30, 0, 36)
SearchContainer.Position = UDim2.new(0, 15, 0, 195)
SearchContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
SearchContainer.Parent = MainFrame
addCorner(SearchContainer, 8)
addStroke(SearchContainer, Color3.fromRGB(255, 255, 255), 1, 0.9)

-- Search Input
local SearchInput = Instance.new("TextBox")
SearchInput.Name = "SearchInput"
SearchInput.Size = UDim2.new(1, -20, 1, 0)
SearchInput.Position = UDim2.new(0, 10, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderText = "Search item name (e.g. Seed, Pet)..."
SearchInput.Text = ""
SearchInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
SearchInput.TextSize = 14
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.Parent = SearchContainer

-- Items ScrollingFrame Container
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ItemsScroll"
ScrollFrame.Size = UDim2.new(1, -30, 1, -255)
ScrollFrame.Position = UDim2.new(0, 15, 0, 240)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 35, 135)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

-- UIListLayout for listing items
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

-- Automatic canvas resize
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

-- Find Booths Folder in Workspace
local function getBoothsFolder()
    local names = {"Booths", "PlayerBooths", "TradingBooths", "Stands", "PlayerStands", "ActiveBooths", "Marketplace", "FarmersMarket", "FarmerMarket"}
    for _, name in ipairs(names) do
        local obj = Workspace:FindFirstChild(name)
        if obj then
            return obj
        end
    end
    
    for _, child in ipairs(Workspace:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            local lowerName = string.lower(child.Name)
            if string.find(lowerName, "booth") or string.find(lowerName, "stand") or string.find(lowerName, "market") then
                return child
            end
        end
    end
    return nil
end

-- Find Booth Owner Name
local function getBoothOwner(booth)
    local ownerAttr = booth:GetAttribute("Owner") or booth:GetAttribute("OwnerName") or booth:GetAttribute("Player") or booth:GetAttribute("ClaimedBy")
    if ownerAttr then
        return tostring(ownerAttr)
    end
    
    local ownerVal = booth:FindFirstChild("Owner") or booth:FindFirstChild("OwnerName") or booth:FindFirstChild("Player") or booth:FindFirstChild("ClaimedBy")
    if ownerVal then
        if ownerVal:IsA("StringValue") then
            return ownerVal.Value
        elseif ownerVal:IsA("ObjectValue") and ownerVal.Value then
            return ownerVal.Value.Name
        end
    end
    
    local name = booth.Name
    if Players:FindFirstChild(name) then
        return name
    end
    
    for _, gui in ipairs(booth:GetDescendants()) do
        if gui:IsA("BillboardGui") or gui:IsA("SurfaceGui") then
            for _, label in ipairs(gui:GetDescendants()) do
                if label:IsA("TextLabel") or label:IsA("TextBox") then
                    local text = label.Text
                    local ownerMatch = string.match(text, "([^%s]+)'s Booth") or string.match(text, "Owner: ([^%s]+)")
                    if ownerMatch then
                        return ownerMatch
                    end
                end
            end
        end
    end
    
    return "Unknown"
end

-- Extract Weight (e.g. 5.2kg or Weight: 5.2)
local function extractWeightFromText(text)
    local wt = string.match(text, "([%d%.]+)%s*kg") or string.match(text, "Weight:%s*([%d%.]+)") or string.match(text, "Wt:%s*([%d%.]+)")
    return tonumber(wt)
end

-- Parse Pet Name and Weight
local function parsePetName(itemName)
    -- Try to match weight from name string first
    local species, weightStr = string.match(itemName, "^(.-)%s*[%[%(]%s*([%d%.]+)%s*kg%s*[%]%)]")
    if not species then
        species, weightStr = string.match(itemName, "^(.-)%s*([%d%.]+)%s*kg")
    end
    
    if species and weightStr then
        species = string.gsub(species, "^%s*(.-)%s*$", "%1") -- trim spaces
        return species, tonumber(weightStr)
    end
    
    return itemName, nil
end

-- Find Booth Items
local function getBoothItems(booth)
    local items = {}
    local folders = {"Items", "Selling", "ListedItems", "Products", "Goods", "List"}
    local itemFolder = nil
    for _, name in ipairs(folders) do
        local f = booth:FindFirstChild(name)
        if f then
            itemFolder = f
            break
        end
    end
    
    if itemFolder then
        for _, item in ipairs(itemFolder:GetChildren()) do
            local name = item.Name
            local price = item:GetAttribute("Price") or item:GetAttribute("Cost")
            local quantity = item:GetAttribute("Quantity") or item:GetAttribute("Amount") or 1
            local weight = item:GetAttribute("Weight") or item:GetAttribute("PetWeight") or item:GetAttribute("HatchWeight")
            
            if not price then
                local priceVal = item:FindFirstChild("Price") or item:FindFirstChild("Cost")
                if priceVal and priceVal:IsA("ValueBase") then
                    price = priceVal.Value
                end
            end
            if not quantity then
                local qtyVal = item:FindFirstChild("Quantity") or item:FindFirstChild("Amount") or item:FindFirstChild("Count")
                if qtyVal and qtyVal:IsA("ValueBase") then
                    quantity = qtyVal.Value
                end
            end
            if not weight then
                local wVal = item:FindFirstChild("Weight") or item:FindFirstChild("PetWeight") or item:FindFirstChild("HatchWeight")
                if wVal and wVal:IsA("ValueBase") then
                    weight = wVal.Value
                end
            end
            
            -- If we have a parsed weight or attribute, let's reconstruct the name cleanly
            local cleanName = name
            local species, parsedWeight = parsePetName(name)
            local finalWeight = weight or parsedWeight
            
            if finalWeight then
                cleanName = species .. " [" .. finalWeight .. "kg]"
            end
            
            table.insert(items, {
                Name = cleanName,
                Price = tonumber(price) or 0,
                Quantity = tonumber(quantity) or 1,
                Weight = finalWeight
            })
        end
    end
    
    -- Fallback: Scan GUI text elements inside the booth
    if #items == 0 then
        for _, gui in ipairs(booth:GetDescendants()) do
            if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then
                for _, frame in ipairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") or frame:IsA("ImageLabel") then
                        local nameLabel, priceLabel, qtyLabel, weightLabel = nil, nil, nil, nil
                        local foundWeightVal = nil
                        
                        for _, child in ipairs(frame:GetChildren()) do
                            if child:IsA("TextLabel") then
                                local text = child.Text
                                local extractedWt = extractWeightFromText(text)
                                
                                if extractedWt then
                                    foundWeightVal = extractedWt
                                    weightLabel = child
                                elseif string.find(text, "^x%d+$") or string.find(text, "^%d+x$") then
                                    qtyLabel = child
                                elseif string.match(text, "^%d+$") or string.find(text, "Token") or string.find(text, "%$") then
                                    priceLabel = child
                                else
                                    if text ~= "Buy" and text ~= "Purchase" and text ~= "" and #text > 2 then
                                        nameLabel = child
                                    end
                                end
                            end
                        end
                        
                        if nameLabel and priceLabel then
                            local itemName = nameLabel.Text
                            local priceText = priceLabel.Text
                            local priceNum = tonumber(string.match(priceText, "%d+")) or 0
                            local qtyText = qtyLabel and qtyLabel.Text or "1"
                            local qtyNum = tonumber(string.match(qtyText, "%d+")) or 1
                            
                            local species, parsedWeight = parsePetName(itemName)
                            local finalWeight = foundWeightVal or parsedWeight
                            local cleanName = itemName
                            
                            if finalWeight then
                                cleanName = species .. " [" .. finalWeight .. "kg]"
                            end
                            
                            table.insert(items, {
                                Name = cleanName,
                                Price = priceNum,
                                Quantity = qtyNum,
                                Weight = finalWeight
                            })
                        end
                    end
                end
            end
        end
    end
    
    return items
end

-- Teleport to Booth Location
local function teleportTo(position)
    local char = LocalPlayer.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = position + Vector3.new(0, 4.5, 0)
        end
    end
end

-- Dynamic Pet Types Gatherer
local function getDynamicPetTypes()
    local types = {"Any"}
    local found = {}
    
    local function addType(name)
        if name and name ~= "" and not found[name] then
            -- Exclude common noise names
            if name ~= "List" and name ~= "Selling" and name ~= "Config" and name ~= "Remotes" and name ~= "Events" and name ~= "Items" then
                found[name] = true
                table.insert(types, name)
            end
        end
    end
    
    -- 1. Scan ReplicatedStorage folders
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("Folder") then
                local folderName = string.lower(obj.Name)
                if folderName == "pets" or folderName == "petmodels" or folderName == "petassets" or folderName == "petconfigs" then
                    for _, child in ipairs(obj:GetChildren()) do
                        addType(child.Name)
                    end
                end
            end
        end
    end)
    
    -- 2. Scan ReplicatedStorage ModuleScripts / Configs
    pcall(function()
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("ModuleScript") then
                local lowerName = string.lower(obj.Name)
                if string.find(lowerName, "pet") and not string.find(lowerName, "controller") and not string.find(lowerName, "client") and not string.find(lowerName, "server") then
                    local data = require(obj)
                    if type(data) == "table" then
                        for k, v in pairs(data) do
                            if type(k) == "string" then
                                addType(k)
                            elseif type(v) == "table" and type(v.Name) == "string" then
                                addType(v.Name)
                            end
                        end
                    end
                end
            end
        end
    end)
    
    -- 3. Scan active booths currently on server
    local boothsFolder = getBoothsFolder()
    if boothsFolder then
        for _, booth in ipairs(boothsFolder:GetChildren()) do
            local items = getBoothItems(booth)
            for _, item in ipairs(items) do
                local species, _ = parsePetName(item.Name)
                local nameLower = string.lower(item.Name)
                -- If it's not seed/fertilizer/cosmetics, treat as pet type candidate
                if not string.find(nameLower, "seed") and not string.find(nameLower, "fertilizer") and not string.find(nameLower, "water") and not string.find(nameLower, "token") and not string.find(nameLower, "booth") and not string.find(nameLower, "skin") then
                    addType(species)
                end
            end
        end
    end
    
    -- 4. Fallback defaults if none detected
    if #types <= 1 then
        local defaults = {"Orange Tabby", "Rooster", "Pig", "Cow", "Sheep", "Chicken", "Bunny", "Goat", "Cat", "Dog", "Axolotl", "Duck", "Frog", "Bee", "Turtle"}
        for _, d in ipairs(defaults) do
            addType(d)
        end
    end
    
    -- Sort alphabetically
    table.sort(types, function(a, b)
        if a == "Any" then return true end
        if b == "Any" then return false end
        return a < b
    end)
    
    return types
end

-- Check if species matches any of the dynamic pet types
local function isPet(itemName)
    local species = parsePetName(itemName)
    local petTypes = getDynamicPetTypes()
    for _, t in ipairs(petTypes) do
        if t ~= "Any" and string.lower(species) == string.lower(t) then
            return true
        end
    end
    -- Fallback: If itemName contains "kg", we automatically classify it as a pet
    if string.find(string.lower(itemName), "kg") then
        return true
    end
    return false
end

-- Check if item passes the filters (Auto List vs Standard Search)
local function passesFilters(item, name, price, weight)
    local species, parsedWeight = parsePetName(name)
    local finalWeight = weight or parsedWeight
    
    if autoListEnabled then
        -- Must be a pet
        if not isPet(name) then
            return false
        end
        
        -- Filter species
        if selectedPetType ~= "Any" and string.lower(species) ~= string.lower(selectedPetType) then
            return false
        end
        
        -- Filter min weight (only if input is specified)
        local minW = tonumber(MinWeightInput.Text)
        if minW then
            if not finalWeight or finalWeight < minW then
                return false
            end
        end
        
        -- Filter max weight (only if input is specified)
        local maxW = tonumber(MaxWeightInput.Text)
        if maxW then
            if not finalWeight or finalWeight > maxW then
                return false
            end
        end
        
        -- Filter max price (only if input is specified)
        local maxP = tonumber(MaxPriceInput.Text)
        if maxP and price > maxP then
            return false
        end
        
        return true
    else
        -- Standard Search Bar filter
        local filter = SearchInput.Text
        if not filter or filter == "" then
            return true
        end
        return string.find(string.lower(name), string.lower(filter)) or string.find(string.lower(item.Seller), string.lower(filter))
    end
end

-- Render the Items in UI
local function renderItems()
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local count = 0
    for _, item in ipairs(allItems) do
        if passesFilters(item, item.Name, item.Price, item.Weight) then
            count = count + 1
            
            -- Create Card Frame
            local Card = Instance.new("Frame")
            Card.Name = "ItemCard_" .. count
            Card.Size = UDim2.new(1, -6, 0, 60)
            Card.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
            Card.Parent = ScrollFrame
            addCorner(Card, 8)
            addStroke(Card, Color3.fromRGB(255, 255, 255), 1, 0.95)
            
            -- Item Name Label
            local NameLabel = Instance.new("TextLabel")
            NameLabel.Name = "ItemName"
            NameLabel.Size = UDim2.new(0.65, 0, 0.5, 0)
            NameLabel.Position = UDim2.new(0, 10, 0.1, 0)
            NameLabel.BackgroundTransparency = 1
            local qtyStr = (item.Quantity > 1) and (" (x" .. item.Quantity .. ")") or ""
            NameLabel.Text = "📦 " .. item.Name .. qtyStr
            NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            NameLabel.TextSize = 14
            NameLabel.Font = Enum.Font.GothamBold
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.Parent = Card
            
            -- Seller Label
            local SellerLabel = Instance.new("TextLabel")
            SellerLabel.Name = "Seller"
            SellerLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
            SellerLabel.Position = UDim2.new(0, 10, 0.5, 0)
            SellerLabel.BackgroundTransparency = 1
            SellerLabel.Text = "👤 Seller: " .. item.Seller
            SellerLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
            SellerLabel.TextSize = 11
            SellerLabel.Font = Enum.Font.Gotham
            SellerLabel.TextXAlignment = Enum.TextXAlignment.Left
            SellerLabel.Parent = Card
            
            -- Price Label
            local PriceLabel = Instance.new("TextLabel")
            PriceLabel.Name = "Price"
            PriceLabel.Size = UDim2.new(0.25, 0, 0.4, 0)
            PriceLabel.Position = UDim2.new(0.5, 0, 0.1, 0)
            PriceLabel.BackgroundTransparency = 1
            PriceLabel.Text = "🪙 " .. item.Price .. " T"
            PriceLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
            PriceLabel.TextSize = 13
            PriceLabel.Font = Enum.Font.GothamBold
            PriceLabel.TextXAlignment = Enum.TextXAlignment.Left
            PriceLabel.Parent = Card
            
            -- Teleport Button
            local TeleportBtn = Instance.new("TextButton")
            TeleportBtn.Name = "TeleportBtn"
            TeleportBtn.Size = UDim2.new(0, 80, 0, 32)
            TeleportBtn.Position = UDim2.new(1, -90, 0.5, -16)
            TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            TeleportBtn.Text = "Teleport"
            TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TeleportBtn.TextSize = 12
            TeleportBtn.Font = Enum.Font.GothamBold
            TeleportBtn.Parent = Card
            addCorner(TeleportBtn, 6)
            addStroke(TeleportBtn, Color3.fromRGB(138, 35, 135), 1, 0.6)
            
            TeleportBtn.MouseButton1Click:Connect(function()
                teleportTo(item.Position)
            end)
        end
    end
end

-- Scan Server Booths
local function scanBooths()
    allItems = {}
    local boothsFolder = getBoothsFolder()
    
    if not boothsFolder then
        StatusLabel.Text = "Status: Booths folder not found!"
        return
    end
    
    if autoListEnabled then
        StatusLabel.Text = "Status: Scanning server for filtered pets..."
    else
        StatusLabel.Text = "Status: Idle"
    end
    
    local currentActiveListings = {}
    
    for _, booth in ipairs(boothsFolder:GetChildren()) do
        if booth:IsA("Model") or booth:IsA("BasePart") then
            local owner = getBoothOwner(booth)
            if owner and owner ~= "Unknown" and owner ~= "" then
                local position = booth:IsA("Model") and (booth.PrimaryPart and booth.PrimaryPart.Position or booth:FindFirstChildWhichIsA("BasePart") and booth:FindFirstChildWhichIsA("BasePart").Position) or booth.Position
                if position then
                    local boothItems = getBoothItems(booth)
                    for _, item in ipairs(boothItems) do
                        table.insert(allItems, {
                            Name = item.Name,
                            Price = item.Price,
                            Quantity = item.Quantity,
                            Seller = owner,
                            Position = position,
                            Weight = item.Weight
                        })
                        
                        -- Tracking active matching items for notifications
                        if autoListEnabled and passesFilters({Seller = owner}, item.Name, item.Price, item.Weight) then
                            local listingKey = owner .. "_" .. item.Name .. "_" .. item.Price
                            currentActiveListings[listingKey] = true
                            
                            if not notifiedListings[listingKey] then
                                notifiedListings[listingKey] = true
                                notify("Matching Pet Found!", owner .. " is selling: " .. item.Name .. " for " .. item.Price .. " Tokens!")
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Cleanup notified listings that are no longer active in the marketplace
    for key in pairs(notifiedListings) do
        if not currentActiveListings[key] then
            notifiedListings[key] = nil
        end
    end
    
    renderItems()
end

-- Populate Dropdown List dynamically
local function updateDropdownOptions()
    for _, child in ipairs(DropdownMenu:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local petTypes = getDynamicPetTypes()
    for _, petType in ipairs(petTypes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        btn.Text = petType
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.ZIndex = 35
        btn.Parent = DropdownMenu
        addCorner(btn, 4)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(138, 35, 135)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        end)
        
        btn.MouseButton1Click:Connect(function()
            selectedPetType = petType
            DropdownBtn.Text = "Pet Type: " .. petType
            DropdownMenu.Visible = false
            scanBooths()
        end)
    end
end

-- Auto-List Background Loop Handler
local function startAutoListLoop()
    if autoListLoopActive then return end
    autoListLoopActive = true
    task.spawn(function()
        while autoListEnabled do
            scanBooths()
            task.wait(4)
        end
        autoListLoopActive = false
        StatusLabel.Text = "Status: Idle"
    end)
end

-- Connect UI Events
RefreshBtn.MouseButton1Click:Connect(function()
    scanBooths()
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ToggleButton.Visible = true
    isOpen = false
end)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ToggleButton.Visible = false
    isOpen = true
    scanBooths()
end)

DropdownBtn.MouseButton1Click:Connect(function()
    DropdownMenu.Visible = not DropdownMenu.Visible
    if DropdownMenu.Visible then
        updateDropdownOptions()
    end
end)

-- Toggle Auto-List Handler
ToggleAutoListBtn.MouseButton1Click:Connect(function()
    autoListEnabled = not autoListEnabled
    if autoListEnabled then
        ToggleAutoListBtn.Text = "Auto List Pets: ON"
        ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Green
        SearchContainer.Visible = false -- Hide standard search when auto list is active
        ScrollFrame.Position = UDim2.new(0, 15, 0, 195)
        ScrollFrame.Size = UDim2.new(1, -30, 1, -210)
        startAutoListLoop()
    else
        ToggleAutoListBtn.Text = "Auto List Pets: OFF"
        ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87) -- Red
        SearchContainer.Visible = true
        ScrollFrame.Position = UDim2.new(0, 15, 0, 240)
        ScrollFrame.Size = UDim2.new(1, -30, 1, -255)
        scanBooths()
    end
end)

-- Re-filter when text inputs change
SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    if not autoListEnabled then
        renderItems()
    end
end)

MinWeightInput:GetPropertyChangedSignal("Text"):Connect(function()
    if autoListEnabled then
        renderItems()
    end
end)

MaxWeightInput:GetPropertyChangedSignal("Text"):Connect(function()
    if autoListEnabled then
        renderItems()
    end
end)

MaxPriceInput:GetPropertyChangedSignal("Text"):Connect(function()
    if autoListEnabled then
        renderItems()
    end
end)

-- Initial Scan
scanBooths()
notify("[PonggoHub]", "Market Scanner loaded successfully!")
