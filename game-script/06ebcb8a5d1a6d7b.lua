-- PonggoHub | Grow a Garden: Trade World Booth Scanner
-- Overwritten with new, clean, keyless script as requested by user.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
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
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
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

-- Search Bar Container
local SearchContainer = Instance.new("Frame")
SearchContainer.Name = "SearchContainer"
SearchContainer.Size = UDim2.new(1, -30, 0, 36)
SearchContainer.Position = UDim2.new(0, 15, 0, 60)
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
ScrollFrame.Size = UDim2.new(1, -30, 1, -120)
ScrollFrame.Position = UDim2.new(0, 15, 0, 105)
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
    -- Look for common names in Workspace
    local names = {"Booths", "PlayerBooths", "TradingBooths", "Stands", "PlayerStands", "ActiveBooths", "Marketplace", "FarmersMarket", "FarmerMarket"}
    for _, name in ipairs(names) do
        local obj = Workspace:FindFirstChild(name)
        if obj then
            return obj
        end
    end
    
    -- Fallback search of workspace children
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
    -- Check common attributes
    local ownerAttr = booth:GetAttribute("Owner") or booth:GetAttribute("OwnerName") or booth:GetAttribute("Player") or booth:GetAttribute("ClaimedBy")
    if ownerAttr then
        return tostring(ownerAttr)
    end
    
    -- Check child values
    local ownerVal = booth:FindFirstChild("Owner") or booth:FindFirstChild("OwnerName") or booth:FindFirstChild("Player") or booth:FindFirstChild("ClaimedBy")
    if ownerVal then
        if ownerVal:IsA("StringValue") then
            return ownerVal.Value
        elseif ownerVal:IsA("ObjectValue") and ownerVal.Value then
            return ownerVal.Value.Name
        end
    end
    
    -- If booth name matches a current player, use that
    local name = booth.Name
    if Players:FindFirstChild(name) then
        return name
    end
    
    -- Fallback: Check inside SurfaceGui/BillboardGui for text labels containing Owner or Usernames
    for _, gui in ipairs(booth:GetDescendants()) do
        if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then
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

-- Find Booth Items
local function getBoothItems(booth)
    local items = {}
    
    -- Check common folder names
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
            
            table.insert(items, {
                Name = name,
                Price = tonumber(price) or 0,
                Quantity = tonumber(quantity) or 1
            })
        end
    end
    
    -- Fallback: If no structured items folder was found, parse the SurfaceGui/BillboardGui labels
    if #items == 0 then
        for _, gui in ipairs(booth:GetDescendants()) do
            if gui:IsA("SurfaceGui") or gui:IsA("BillboardGui") then
                for _, frame in ipairs(gui:GetDescendants()) do
                    if frame:IsA("Frame") or frame:IsA("ImageLabel") then
                        local nameLabel, priceLabel, qtyLabel = nil, nil, nil
                        for _, child in ipairs(frame:GetChildren()) do
                            if child:IsA("TextLabel") then
                                local text = child.Text
                                if string.find(text, "^x%d+$") or string.find(text, "^%d+x$") then
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
                            
                            table.insert(items, {
                                Name = itemName,
                                Price = priceNum,
                                Quantity = qtyNum
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
            -- Offset teleportation slightly so the player lands on their feet
            root.CFrame = position + Vector3.new(0, 4.5, 0)
        end
    end
end

-- Render the Items in UI
local function renderItems(filter)
    -- Clear current rendered items
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Filter and display
    local count = 0
    for _, item in ipairs(allItems) do
        if not filter or filter == "" or string.find(string.lower(item.Name), string.lower(filter)) or string.find(string.lower(item.Seller), string.lower(filter)) then
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
            
            -- Seller/Booth Owner Label
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
            
            -- Teleport button click event
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
        warn("Booths folder not found!")
        return
    end
    
    for _, booth in ipairs(boothsFolder:GetChildren()) do
        -- Booths must be Models or Parts
        if booth:IsA("Model") or booth:IsA("BasePart") then
            local owner = getBoothOwner(booth)
            -- Only scan claimed booths
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
                            Position = position
                        })
                    end
                end
            end
        end
    end
    
    -- Re-render list with current search filter
    renderItems(SearchInput.Text)
end

-- Connect Events
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

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    renderItems(SearchInput.Text)
end)

-- Initial Scan
scanBooths()

-- Notify User
local function notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

notify("[PonggoHub]", "Market Scanner loaded successfully!")
