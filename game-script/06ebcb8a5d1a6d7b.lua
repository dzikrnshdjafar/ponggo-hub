-- PonggoHub | Grow a Garden: Trade World Auto-List Booth Manager
-- Overwritten with updated, clean, keyless script dynamically scanning local inventory.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Check if UI already exists and destroy it
for _, uiName in ipairs({"PonggoHubMarket", "PonggoHubMarketUI"}) do
    local old = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(uiName) or CoreGui:FindFirstChild(uiName)
    if old then
        old:Destroy()
    end
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PonggoHubMarketUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui -- Use CoreGui to prevent resetting on death/spawn

-- Variables for State
local autoClaimEnabled = false
local autoListEnabled = false
local selectedPetType = "Any"
local minWeight = nil
local maxWeight = nil
local listingPrice = 1000
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

-- minimize floating button
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
addStroke(ToggleButton, Color3.fromRGB(120, 100, 255), 2, 0.4)
addGradient(ToggleButton, Color3.fromRGB(120, 100, 255), Color3.fromRGB(138, 35, 135))

-- Main GUI Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 600)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.Active = true
MainFrame.Draggable = true
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
TitleText.Text = "PonggoHub Booth Manager"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 15
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

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
PetFinderPanel.Size = UDim2.new(1, -30, 0, 160)
PetFinderPanel.Position = UDim2.new(0, 15, 0, 55)
PetFinderPanel.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
PetFinderPanel.Parent = MainFrame
addCorner(PetFinderPanel, 8)
addStroke(PetFinderPanel, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Auto Claim Booth Toggle
local ToggleAutoClaimBtn = Instance.new("TextButton")
ToggleAutoClaimBtn.Name = "ToggleAutoClaimBtn"
ToggleAutoClaimBtn.Size = UDim2.new(0, 180, 0, 30)
ToggleAutoClaimBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleAutoClaimBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87)
ToggleAutoClaimBtn.Text = "Auto Claim Booth: OFF"
ToggleAutoClaimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoClaimBtn.TextSize = 11
ToggleAutoClaimBtn.Font = Enum.Font.GothamBold
ToggleAutoClaimBtn.Parent = PetFinderPanel
addCorner(ToggleAutoClaimBtn, 6)

-- Toggle Button for Auto List
local ToggleAutoListBtn = Instance.new("TextButton")
ToggleAutoListBtn.Name = "ToggleAutoListBtn"
ToggleAutoListBtn.Size = UDim2.new(0, 180, 0, 30)
ToggleAutoListBtn.Position = UDim2.new(1, -190, 0, 10)
ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87)
ToggleAutoListBtn.Text = "Auto List Pets: OFF"
ToggleAutoListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoListBtn.TextSize = 11
ToggleAutoListBtn.Font = Enum.Font.GothamBold
ToggleAutoListBtn.Parent = PetFinderPanel
addCorner(ToggleAutoListBtn, 6)

-- Dropdown Button for Pet Type
local DropdownBtn = Instance.new("TextButton")
DropdownBtn.Name = "DropdownBtn"
DropdownBtn.Size = UDim2.new(0, 180, 0, 30)
DropdownBtn.Position = UDim2.new(0, 10, 0, 50)
DropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
DropdownBtn.Text = "Pet Type: Any"
DropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DropdownBtn.TextSize = 11
DropdownBtn.Font = Enum.Font.GothamBold
DropdownBtn.Parent = PetFinderPanel
addCorner(DropdownBtn, 6)
addStroke(DropdownBtn, Color3.fromRGB(255, 255, 255), 1, 0.9)

-- Dropdown Scrolling Frame Menu
local DropdownMenu = Instance.new("ScrollingFrame")
DropdownMenu.Name = "DropdownMenu"
DropdownMenu.Size = UDim2.new(0, 180, 0, 180)
DropdownMenu.Position = UDim2.new(0, 10, 0, 85)
DropdownMenu.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
DropdownMenu.BorderSizePixel = 0
DropdownMenu.ZIndex = 20
DropdownMenu.Visible = false
DropdownMenu.ScrollBarThickness = 4
DropdownMenu.ScrollBarImageColor3 = Color3.fromRGB(120, 100, 255)
DropdownMenu.Parent = PetFinderPanel
addCorner(DropdownMenu, 6)
addStroke(DropdownMenu, Color3.fromRGB(120, 100, 255), 1, 0.7)

local DropdownLayout = Instance.new("UIListLayout")
DropdownLayout.Padding = UDim.new(0, 4)
DropdownLayout.Parent = DropdownMenu

DropdownLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    DropdownMenu.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 6)
end)

-- Listing Price Input
local PriceInput = Instance.new("TextBox")
PriceInput.Name = "PriceInput"
PriceInput.Size = UDim2.new(0, 180, 0, 30)
PriceInput.Position = UDim2.new(1, -190, 0, 50)
PriceInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
PriceInput.PlaceholderText = "Listing Price (Tokens)"
PriceInput.Text = "1000"
PriceInput.TextColor3 = Color3.fromRGB(255, 255, 0)
PriceInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
PriceInput.TextSize = 12
PriceInput.Font = Enum.Font.GothamBold
PriceInput.Parent = PetFinderPanel
addCorner(PriceInput, 6)
addStroke(PriceInput, Color3.fromRGB(255, 255, 255), 1, 0.95)

-- Min Weight Input
local MinWeightInput = Instance.new("TextBox")
MinWeightInput.Name = "MinWeightInput"
MinWeightInput.Size = UDim2.new(0, 180, 0, 30)
MinWeightInput.Position = UDim2.new(0, 10, 0, 90)
MinWeightInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MinWeightInput.PlaceholderText = "Min Weight (kg)"
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
MaxWeightInput.Size = UDim2.new(0, 180, 0, 30)
MaxWeightInput.Position = UDim2.new(1, -190, 0, 90)
MaxWeightInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MaxWeightInput.PlaceholderText = "Max Weight (kg)"
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
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Position = UDim2.new(0, 10, 0, 130)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.Parent = PetFinderPanel

-- Items ScrollFrame Container
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ItemsScroll"
ScrollFrame.Size = UDim2.new(1, -30, 1, -240)
ScrollFrame.Position = UDim2.new(0, 15, 0, 225)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(120, 100, 255)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

-- UIListLayout for listing items
local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = ScrollFrame

-- Automatic canvas resize
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- WORLD / REMOTE SETUP
-- ══════════════════════════════════════════════════════════════════════════════
local TradeWorld = Workspace:WaitForChild("TradeWorld", 20)
local Booths = TradeWorld and TradeWorld:WaitForChild("Booths", 10)

local GameEvents = ReplicatedStorage:WaitForChild("GameEvents", 12)
local TradeEvents = GameEvents and GameEvents:WaitForChild("TradeEvents", 8)
local BoothEvents = TradeEvents and TradeEvents:WaitForChild("Booths", 8)
local ClaimBoothEvent = BoothEvents and BoothEvents:WaitForChild("ClaimBooth", 8)
local RemoveBoothEvent = BoothEvents and BoothEvents:WaitForChild("RemoveBooth", 8)
local CreateListingInvoke = BoothEvents and BoothEvents:WaitForChild("CreateListing", 8)

-- Helper: Check if player has booth
local function getBoothOwner(booth)
    local a = booth:GetAttribute("Owner")
    return (a and a ~= "") and a or nil
end

local function playerHasBooth()
    if not Booths then return false, nil end
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") then
            local owner = getBoothOwner(booth)
            if owner and (owner == tostring(LocalPlayer.UserId) or owner == LocalPlayer.Name) then
                return true, booth
            end
        end
    end
    return false, nil
end

local function getListingCount()
    local count = 0
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local tb = pg and pg:FindFirstChild("TradeBooth")
    if tb then
        local fr = tb:FindFirstChildOfClass("Frame")
        local il = fr and fr:FindFirstChild("ItemsList")
        local sc = il and il:FindFirstChildOfClass("ScrollingFrame")
        if sc then
            for _, v in ipairs(sc:GetChildren()) do
                if v:IsA("Frame") and v.Name == "HoverableItemTemplate" then count = count + 1 end
            end
        end
    end
    return count
end

local function findClosestEmptyBooth()
    if not Booths then return nil end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local closest, closestDist = nil, math.huge
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") and not getBoothOwner(booth) then
            if hrp then
                local part = booth.PrimaryPart or booth:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < closestDist then
                        closestDist = d
                        closest = booth
                    end
                end
            else
                return booth
            end
        end
    end
    return closest
end

local function findAnyEmptyBooth()
    if not Booths then return nil end
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") and not getBoothOwner(booth) then
            return booth
        end
    end
    return nil
end

-- Parse Pet Name and Weight (Heuristic regex)
local function parsePetName(itemName)
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

-- Get Pet Weight (Heuristic checking attributes + name)
local function getPetWeight(tool)
    local weightAttr = tool:GetAttribute("Weight") or tool:GetAttribute("weight") or tool:GetAttribute("HatchWeight")
    if type(weightAttr) == "number" then
        return weightAttr
    end
    local _, weight = parsePetName(tool.Name)
    return weight
end

-- Get Pet Species (Heuristic checking attributes + name)
local function getPetSpecies(tool)
    local speciesAttr = tool:GetAttribute("Species") or tool:GetAttribute("PetType")
    if type(speciesAttr) == "string" and speciesAttr ~= "" then
        return speciesAttr
    end
    local species = parsePetName(tool.Name)
    return species or tool.Name
end

-- Discover Game Pet Types dynamically
local function discoverPetTypes()
    local types = {["Any"] = true}
    
    -- 1. Scan Backpack
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("PET_UUID") then
                local species = getPetSpecies(tool)
                if species and species ~= "" then
                    types[species] = true
                end
            end
        end
    end
    
    -- 2. Scan Character (Equipped tools)
    local char = LocalPlayer.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("PET_UUID") then
                local species = getPetSpecies(tool)
                if species and species ~= "" then
                    types[species] = true
                end
            end
        end
    end
    
    -- 3. Scan ReplicatedStorage database folders
    local function scanStorage(parent, depth)
        if depth > 4 then return end
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Folder") then
                local lowerName = string.lower(child.Name)
                if lowerName == "pets" or lowerName == "pettemplates" or lowerName == "petdata" then
                    for _, pet in ipairs(child:GetChildren()) do
                        types[pet.Name] = true
                    end
                else
                    scanStorage(child, depth + 1)
                end
            end
        end
    end
    pcall(scanStorage, ReplicatedStorage, 1)
    
    -- Convert set to sorted list
    local list = {}
    for t in pairs(types) do
        table.insert(list, t)
    end
    table.sort(list, function(a, b)
        if a == "Any" then return true end
        if b == "Any" then return false end
        return a < b
    end)
    return list
end

-- Display Local Backpack Items matching filters
local function renderBackpackList(petsList)
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local count = 0
    for _, pet in ipairs(petsList) do
        count = count + 1
        local matches = pet.passesFilters
        
        -- Create Card Frame
        local Card = Instance.new("Frame")
        Card.Name = "ItemCard_" .. count
        Card.Size = UDim2.new(1, -6, 0, 52)
        Card.BackgroundColor3 = matches and Color3.fromRGB(24, 30, 24) or Color3.fromRGB(24, 24, 34)
        Card.Parent = ScrollFrame
        addCorner(Card, 8)
        addStroke(Card, matches and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(255, 255, 255), 1, 0.9)
        
        -- Item Name Label
        local NameLabel = Instance.new("TextLabel")
        NameLabel.Name = "ItemName"
        NameLabel.Size = UDim2.new(0.65, 0, 0.5, 0)
        NameLabel.Position = UDim2.new(0, 10, 0.1, 0)
        NameLabel.BackgroundTransparency = 1
        local weightStr = pet.weight and (" [" .. pet.weight .. "kg]") or ""
        NameLabel.Text = "🐾 " .. pet.species .. weightStr
        NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        NameLabel.TextSize = 13
        NameLabel.Font = Enum.Font.GothamBold
        NameLabel.TextXAlignment = Enum.TextXAlignment.Left
        NameLabel.Parent = Card
        
        -- Status / Info Label
        local InfoLabel = Instance.new("TextLabel")
        InfoLabel.Name = "InfoLabel"
        InfoLabel.Size = UDim2.new(0.65, 0, 0.4, 0)
        InfoLabel.Position = UDim2.new(0, 10, 0.5, 0)
        InfoLabel.BackgroundTransparency = 1
        InfoLabel.Text = matches and "✓ Matches Filters" or "✕ Doesn't Match"
        InfoLabel.TextColor3 = matches and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(150, 150, 150)
        InfoLabel.TextSize = 10
        InfoLabel.Font = Enum.Font.Gotham
        InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
        InfoLabel.Parent = Card
        
        -- Manual List Button
        local ListBtn = Instance.new("TextButton")
        ListBtn.Name = "ListBtn"
        ListBtn.Size = UDim2.new(0, 80, 0, 26)
        ListBtn.Position = UDim2.new(1, -90, 0.5, -13)
        ListBtn.BackgroundColor3 = matches and Color3.fromRGB(120, 100, 255) or Color3.fromRGB(40, 40, 55)
        ListBtn.Text = "List"
        ListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ListBtn.TextSize = 12
        ListBtn.Font = Enum.Font.GothamBold
        ListBtn.Active = matches
        ListBtn.AutoButtonColor = matches
        ListBtn.Parent = Card
        addCorner(ListBtn, 6)
        
        ListBtn.MouseButton1Click:Connect(function()
            if not matches then return end
            
            local price = tonumber(PriceInput.Text) or 0
            if price <= 0 then
                StatusLabel.Text = "Status: Enter a valid positive listing price first!"
                return
            end
            
            local hasBooth, _ = playerHasBooth()
            if not hasBooth then
                StatusLabel.Text = "Status: Claim a booth first!"
                return
            end
            
            local ok, err = pcall(function() return CreateListingInvoke:InvokeServer("Pet", pet.uuid, price) end)
            if ok then
                StatusLabel.Text = "Status: Manually listed " .. pet.species
            else
                StatusLabel.Text = "Status: Listing failed! Check slots or try again."
            end
        end)
    end
    
    if count == 0 then
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -6, 0, 50)
        Card.BackgroundColor3 = Color3.fromRGB(24, 24, 34)
        Card.Parent = ScrollFrame
        addCorner(Card, 8)
        
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.BackgroundTransparency = 1
        Label.Text = "No pets found in inventory."
        Label.TextColor3 = Color3.fromRGB(150, 150, 150)
        Label.TextSize = 12
        Label.Font = Enum.Font.GothamBold
        Label.Parent = Card
    end
end

-- Main Scan and List System
local function scanAndListPets()
    local hasBooth, playerBooth = playerHasBooth()
    
    -- Auto claim handler
    if not hasBooth and autoClaimEnabled then
        local targetBooth = findClosestEmptyBooth() or findAnyEmptyBooth()
        if targetBooth then
            pcall(function() RemoveBoothEvent:FireServer() end)
            task.wait(0.4)
            pcall(function() ClaimBoothEvent:FireServer(targetBooth) end)
            task.wait(0.5)
            hasBooth, playerBooth = playerHasBooth()
        end
    end
    
    if not hasBooth then
        StatusLabel.Text = "Status: No booth claimed. Click 'Claim' or enable Auto Claim."
    else
        StatusLabel.Text = "Status: Booth claimed successfully."
    end
    
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    local rawPets = {}
    
    -- Gather pets in backpack
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("PET_UUID") then
                table.insert(rawPets, tool)
            end
        end
    end
    
    -- Gather equipped pets
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") and tool:GetAttribute("PET_UUID") then
                table.insert(rawPets, tool)
            end
        end
    end
    
    local processedPets = {}
    
    for _, tool in ipairs(rawPets) do
        local uuid = tool:GetAttribute("PET_UUID")
        local species = getPetSpecies(tool)
        local weight = getPetWeight(tool)
        
        -- Filter checks
        local passes = true
        if selectedPetType ~= "Any" and string.lower(species) ~= string.lower(selectedPetType) then
            passes = false
        end
        if passes and minWeight and weight and weight < minWeight then
            passes = false
        end
        if passes and maxWeight and weight and weight > maxWeight then
            passes = false
        end
        
        table.insert(processedPets, {
            tool = tool,
            uuid = uuid,
            species = species,
            weight = weight,
            passesFilters = passes
        })
    end
    
    -- Run Auto List routine if active
    if autoListEnabled and hasBooth then
        local targetListings = {}
        for _, pet in ipairs(processedPets) do
            if pet.passesFilters then
                table.insert(targetListings, pet)
            end
        end
        
        if #targetListings > 0 then
            StatusLabel.Text = "Status: Auto-listing matching pets..."
            for _, pet in ipairs(targetListings) do
                local slots = getListingCount()
                if slots >= 12 then
                    StatusLabel.Text = "Status: Booth is full (12/12)!"
                    break
                end
                
                local price = tonumber(PriceInput.Text) or 1000
                if price <= 0 then
                    StatusLabel.Text = "Status: Enter a valid listing price."
                    break
                end
                
                -- Check backpack again before listing to avoid race condition
                if toolInInventory(pet.tool) then
                    local ok, success = pcall(function() return CreateListingInvoke:InvokeServer("Pet", pet.uuid, price) end)
                    if ok and success then
                        notify("[PonggoHub]", "Auto-listed " .. pet.species .. " for " .. price .. " T")
                        task.wait(1.5) -- listing cooldown
                    end
                end
            end
        end
    end
    
    renderBackpackList(processedPets)
end

-- Check if tool is still in backpack
local function toolInInventory(tool)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local char = LocalPlayer.Character
    return tool.Parent == bp or (char and tool.Parent == char)
end

-- Auto-List Background Loop Handler
local function startAutoListLoop()
    if autoListLoopActive then return end
    autoListLoopActive = true
    task.spawn(function()
        while autoListEnabled or autoClaimEnabled do
            pcall(scanAndListPets)
            task.wait(3.5)
        end
        autoListLoopActive = false
        StatusLabel.Text = "Status: Idle"
    end)
end

-- Rebuild Dropdown Menu
local function rebuildDropdown()
    for _, child in ipairs(DropdownMenu:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local petTypesList = discoverPetTypes()
    for _, petType in ipairs(petTypesList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 28)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        btn.Text = petType
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 12
        btn.ZIndex = 25
        btn.Parent = DropdownMenu
        addCorner(btn, 4)
        
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(120, 100, 255)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        end)
        
        btn.MouseButton1Click:Connect(function()
            selectedPetType = petType
            DropdownBtn.Text = "Pet Type: " .. petType
            DropdownMenu.Visible = false
            pcall(scanAndListPets)
        end)
    end
end

-- Wire UI Actions
DropdownBtn.MouseButton1Click:Connect(function()
    DropdownMenu.Visible = not DropdownMenu.Visible
    if DropdownMenu.Visible then
        rebuildDropdown()
    end
end)

ToggleAutoClaimBtn.MouseButton1Click:Connect(function()
    autoClaimEnabled = not autoClaimEnabled
    if autoClaimEnabled then
        ToggleAutoClaimBtn.Text = "Auto Claim Booth: ON"
        ToggleAutoClaimBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        startAutoListLoop()
    else
        ToggleAutoClaimBtn.Text = "Auto Claim Booth: OFF"
        ToggleAutoClaimBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87)
    end
    pcall(scanAndListPets)
end)

ToggleAutoListBtn.MouseButton1Click:Connect(function()
    autoListEnabled = not autoListEnabled
    if autoListEnabled then
        ToggleAutoListBtn.Text = "Auto List Pets: ON"
        ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        startAutoListLoop()
    else
        ToggleAutoListBtn.Text = "Auto List Pets: OFF"
        ToggleAutoListBtn.BackgroundColor3 = Color3.fromRGB(233, 64, 87)
    end
    pcall(scanAndListPets)
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
    pcall(scanAndListPets)
end)

-- Live filter updates when inputs change
MinWeightInput:GetPropertyChangedSignal("Text"):Connect(function()
    minWeight = tonumber(MinWeightInput.Text)
    pcall(scanAndListPets)
end)

MaxWeightInput:GetPropertyChangedSignal("Text"):Connect(function()
    maxWeight = tonumber(MaxWeightInput.Text)
    pcall(scanAndListPets)
end)

PriceInput:GetPropertyChangedSignal("Text"):Connect(function()
    listingPrice = tonumber(PriceInput.Text) or 1000
    pcall(scanAndListPets)
end)

RefreshBtn.MouseButton1Click:Connect(function()
    pcall(scanAndListPets)
end)

-- Initial Setup & Loop
task.spawn(function()
    pcall(scanAndListPets)
    -- Continuous refresh loop
    while MainFrame and MainFrame.Parent do
        pcall(scanAndListPets)
        task.wait(4)
    end
end)

notify("[PonggoHub]", "Booth Manager loaded successfully!")
