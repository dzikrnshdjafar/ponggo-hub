-- ══════════════════════════════════════════════════════════════════════════════
-- BOOTH MANAGER v5.2 - Grouped Items Edition
-- Changes from v5.1:
--   ✦ Grouped slide-cards for duplicate item names (expand / collapse)
--   ✦ Already-listed items show LISTED badge — cannot be re-listed
--   ✦ Favorited items show 🔒 badge — blocked from listing / queuing
--   ✦ Price inputs show formatted token placeholder  "e.g. 1,000 🪙"
--   ✦ Auto-list loop skips already-listed & favorited items
-- ══════════════════════════════════════════════════════════════════════════════
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Workspace           = game:GetService("Workspace")
local TweenService        = game:GetService("TweenService")
local Players             = game:GetService("Players")
local RunService          = game:GetService("RunService")
local CoreGui             = game:GetService("CoreGui")
local UserInputService    = game:GetService("UserInputService")
local HttpService         = game:GetService("HttpService")
local LocalPlayer         = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════════════════════
-- CONFIG
-- ══════════════════════════════════════════════════════════════════════════════
local CONFIG_PATH   = "booth_config_v52.json"
local defaultConfig = {
    autoClaim        = true,
    autoList         = true,
    maxListings      = 12,
    claimClosest     = true,
    backupItems      = {},
    settings = {
        showOwnerNames    = true,
        showItemCount     = true,
        highlightNearest  = true,
        autoRefresh       = true,
        soundOnClaim      = false,
    }
}
local config = table.clone(defaultConfig)

local function saveConfig()
    if writefile then pcall(function() writefile(CONFIG_PATH, HttpService:JSONEncode(config)) end) end
end
local function loadConfig()
    if readfile and isfile and isfile(CONFIG_PATH) then
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_PATH)) end)
        if ok and data and type(data) == "table" then
            config = data
            for k, v in pairs(defaultConfig) do
                if config[k] == nil then config[k] = v
                elseif type(v) == "table" and type(config[k]) == "table" then
                    for k2, v2 in pairs(v) do
                        if config[k][k2] == nil then config[k][k2] = v2 end
                    end
                end
            end
        end
    else saveConfig() end
end
loadConfig()

-- ══════════════════════════════════════════════════════════════════════════════
-- CONSTANTS
-- ══════════════════════════════════════════════════════════════════════════════
local PLACE_ID           = 129954712878723
local MAX_CLAIM_ATTEMPTS = 1
local CLAIM_RETRY_DELAY  = 2
local LIVE_UPDATE_RATE   = 3
local LISTING_COOLDOWN   = 2.5
local AUTO_SCAN_RATE     = 4

-- ══════════════════════════════════════════════════════════════════════════════
-- THEME
-- ══════════════════════════════════════════════════════════════════════════════
local T = {
    BG_BASE   = Color3.fromRGB(8,   9,  18),
    BG_PANEL  = Color3.fromRGB(13,  14,  26),
    BG_CARD   = Color3.fromRGB(18,  20,  36),
    BG_CARD2  = Color3.fromRGB(24,  26,  44),
    BG_INPUT  = Color3.fromRGB(11,  12,  22),
    BG_HOVER  = Color3.fromRGB(30,  32,  56),
    ACCENT    = Color3.fromRGB(120, 100, 255),
    ACCENT2   = Color3.fromRGB( 80,  64, 210),
    ACCENT_DIM= Color3.fromRGB( 50,  40, 150),
    GLOW      = Color3.fromRGB(160, 140, 255),
    PINK      = Color3.fromRGB(240,  90, 200),
    CYAN      = Color3.fromRGB( 48, 230, 220),
    SUCCESS   = Color3.fromRGB( 56, 230, 120),
    ERROR     = Color3.fromRGB(235,  65,  65),
    WARNING   = Color3.fromRGB(255, 195,  48),
    INFO      = Color3.fromRGB( 80, 170, 255),
    EMPTY     = Color3.fromRGB( 56, 230, 120),
    CLAIMED   = Color3.fromRGB(235,  65,  65),
    PARTIAL   = Color3.fromRGB(255, 195,  48),
    TEXT1     = Color3.fromRGB(245, 245, 255),
    TEXT2     = Color3.fromRGB(165, 160, 200),
    TEXT3     = Color3.fromRGB( 80,  76, 115),
    BORDER    = Color3.fromRGB( 32,  30,  58),
    BORDER_LIT= Color3.fromRGB( 55,  52,  95),
    TL_CLOSE  = Color3.fromRGB(235,  64,  64),
    TL_MIN    = Color3.fromRGB(255, 195,  48),
    TL_MAX    = Color3.fromRGB( 56, 230, 120),
    MISSING   = Color3.fromRGB(255, 120,  48),
    FAV_LOCK  = Color3.fromRGB(255, 195,  48),  -- gold for fav-locked
    LISTED    = Color3.fromRGB( 48, 230, 220),  -- cyan for already-listed
    GROUP_HDR = Color3.fromRGB( 22,  24,  44),  -- slightly lighter card bg for group header
}

-- ══════════════════════════════════════════════════════════════════════════════
-- TEARDOWN OLD UI
-- ══════════════════════════════════════════════════════════════════════════════
for _, n in ipairs({"BoothManagerUI","BoothNotifLayer","BM_OldUI",
                    "BoothManagerV5","BoothManagerV51","BoothManagerV52"}) do
    local old = CoreGui:FindFirstChild(n)
    if old then old:Destroy() end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════════════════════════════════════════
local function corner(p, r)
    local c = Instance.new("UICorner", p); c.CornerRadius = UDim.new(0, r or 8); return c
end
local function pad(p, t, r, b, l)
    local u = Instance.new("UIPadding", p)
    u.PaddingTop    = UDim.new(0, t or 0); u.PaddingRight  = UDim.new(0, r or 0)
    u.PaddingBottom = UDim.new(0, b or 0); u.PaddingLeft   = UDim.new(0, l or 0)
    return u
end
local function stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke", p)
    s.Color = col or T.BORDER; s.Thickness = thick or 1; s.Transparency = trans or 0
    return s
end
local function tw(obj, props, dur, style, dir)
    return TweenService:Create(obj,
        TweenInfo.new(dur or 0.25, style or Enum.EasingStyle.Quint,
                      dir or Enum.EasingDirection.Out), props)
end
local function safeFire(ev, ...)   local a={...}; pcall(function() ev:FireServer(table.unpack(a)) end) end
local function safeInvoke(fn, ...)
    local a={...}; local ok, r = pcall(function() return fn:InvokeServer(table.unpack(a)) end)
    return ok, r
end
local function anyBoxFocused()
    return UserInputService:GetFocusedTextBox() ~= nil
end

-- ── NEW: price formatter ───────────────────────────────────────────────────
-- formatPrice(1500000)  →  "1,500,000"
local function formatPrice(n)
    n = math.floor(tonumber(n) or 0)
    local s = tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    return s
end

-- ── NEW: suggested price from tool attributes (try common names) ───────────
local PRICE_ATTR_NAMES = {"SuggestedPrice","FloorPrice","BaseValue","Value","Price"}
local function getSuggestedPrice(tool)
    for _, attr in ipairs(PRICE_ATTR_NAMES) do
        local v = tool:GetAttribute(attr)
        if type(v) == "number" and v > 0 then return v end
    end
    return nil
end

-- ── NEW: price placeholder string ─────────────────────────────────────────
local function pricePlaceholder(tool)
    local sug = tool and getSuggestedPrice(tool)
    if sug then return "e.g. "..formatPrice(sug).." 🪙" end
    return "e.g. 1,000 🪙"
end

-- ══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION LAYER
-- ══════════════════════════════════════════════════════════════════════════════
local notifGui   = Instance.new("ScreenGui")
notifGui.Name    = "BoothNotifLayer"; notifGui.ResetOnSpawn = false
notifGui.DisplayOrder = 2000; notifGui.IgnoreGuiInset = true
notifGui.Parent  = CoreGui

local notifFrame = Instance.new("Frame", notifGui)
notifFrame.Size  = UDim2.new(0, 310, 1, 0)
notifFrame.Position = UDim2.new(1, -322, 0, 0)
notifFrame.BackgroundTransparency = 1
local nLayout = Instance.new("UIListLayout", notifFrame)
nLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
nLayout.Padding = UDim.new(0, 6)
pad(notifFrame, 0, 0, 16, 0)

local nCount = 0
local function notify(title, body, nType, dur)
    nType = nType or "info"; dur = dur or 4; nCount += 1
    local col = ({success=T.SUCCESS,error=T.ERROR,warning=T.WARNING,info=T.INFO})[nType] or T.INFO
    local card = Instance.new("Frame", notifFrame)
    card.Name = "N_"..nCount; card.Size = UDim2.new(1,0,0,0)
    card.BackgroundColor3 = T.BG_CARD; card.ClipsDescendants = true
    card.LayoutOrder = nCount; corner(card,10); stroke(card,T.BORDER_LIT)
    local bar = Instance.new("Frame",card); bar.Size=UDim2.new(0,3,1,0)
    bar.BackgroundColor3=col; bar.BorderSizePixel=0; corner(bar,2)
    local dot = Instance.new("Frame",card); dot.Size=UDim2.new(0,7,0,7)
    dot.Position=UDim2.new(0,14,0,12); dot.BackgroundColor3=col
    dot.BorderSizePixel=0; corner(dot,4)
    local tl = Instance.new("TextLabel",card); tl.Size=UDim2.new(1,-20,0,18)
    tl.Position=UDim2.new(0,26,0,7); tl.BackgroundTransparency=1; tl.Text=title
    tl.TextColor3=T.TEXT1; tl.Font=Enum.Font.GothamBold; tl.TextSize=12
    tl.TextXAlignment=Enum.TextXAlignment.Left
    local bl = Instance.new("TextLabel",card); bl.Size=UDim2.new(1,-20,0,26)
    bl.Position=UDim2.new(0,26,0,26); bl.BackgroundTransparency=1; bl.Text=body
    bl.TextColor3=T.TEXT2; bl.Font=Enum.Font.Gotham; bl.TextSize=10
    bl.TextWrapped=true; bl.TextXAlignment=Enum.TextXAlignment.Left
    local pg = Instance.new("Frame",card); pg.Size=UDim2.new(1,0,0,2)
    pg.Position=UDim2.new(0,0,1,-2); pg.BackgroundColor3=col; pg.BorderSizePixel=0
    tw(card,{Size=UDim2.new(1,0,0,66)},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
    task.delay(0.2, function() tw(pg,{Size=UDim2.new(0,0,0,2)},dur,Enum.EasingStyle.Linear):Play() end)
    task.delay(dur+0.2, function()
        tw(card,{Size=UDim2.new(1,0,0,0)},0.2):Play(); task.wait(0.22); card:Destroy()
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- PLACE CHECK
-- ══════════════════════════════════════════════════════════════════════════════
if game.PlaceId ~= PLACE_ID then
    notify("Wrong Place","Expected place "..PLACE_ID,"error"); return
end

-- ══════════════════════════════════════════════════════════════════════════════
-- MAIN GUI
-- ══════════════════════════════════════════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name  = "BoothManagerV52"; screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000; screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; screenGui.Parent = CoreGui

local WIN_W, WIN_H = 540, 640

local shadow = Instance.new("ImageLabel",screenGui)
shadow.Size = UDim2.new(0,WIN_W+80,0,WIN_H+80)
shadow.Position = UDim2.new(0.5,-(WIN_W+80)/2,0.5,-(WIN_H+80)/2+12)
shadow.BackgroundTransparency = 1; shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0,0,0); shadow.ImageTransparency = 0.45
shadow.ScaleType = Enum.ScaleType.Slice; shadow.SliceCenter = Rect.new(49,49,450,450); shadow.ZIndex = 1

local window = Instance.new("Frame",screenGui)
window.Name = "Window"; window.Size = UDim2.new(0,WIN_W,0,WIN_H)
window.Position = UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)
window.BackgroundColor3 = T.BG_BASE; window.BorderSizePixel = 0
window.ClipsDescendants = true; window.ZIndex = 2; corner(window,14); stroke(window,T.BORDER_LIT)

local grad = Instance.new("UIGradient",window)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(22,18,46)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(8,8,18)),
}); grad.Rotation = 135

local function syncShadow()
    shadow.Position = UDim2.new(
        window.Position.X.Scale, window.Position.X.Offset-40,
        window.Position.Y.Scale, window.Position.Y.Offset-28)
end
window:GetPropertyChangedSignal("Position"):Connect(syncShadow); syncShadow()

-- ──────────────────────────────────────────────────────────────────────────────
-- TITLE BAR
-- ──────────────────────────────────────────────────────────────────────────────
local titleBar = Instance.new("Frame",window); titleBar.Name="TitleBar"
titleBar.Size=UDim2.new(1,0,0,52); titleBar.BackgroundColor3=T.BG_PANEL
titleBar.BorderSizePixel=0; titleBar.ZIndex=5; corner(titleBar,14)

local tbFill = Instance.new("Frame",window); tbFill.Size=UDim2.new(1,0,0,14)
tbFill.Position=UDim2.new(0,0,0,38); tbFill.BackgroundColor3=T.BG_PANEL
tbFill.BorderSizePixel=0; tbFill.ZIndex=4

local accentBar = Instance.new("Frame",titleBar); accentBar.Size=UDim2.new(0,3,0,26)
accentBar.Position=UDim2.new(0,14,0.5,-13); accentBar.BackgroundColor3=T.GLOW
accentBar.BorderSizePixel=0; accentBar.ZIndex=6; corner(accentBar,2)

local titleLabel = Instance.new("TextLabel",titleBar)
titleLabel.Size=UDim2.new(0,200,0,22); titleLabel.Position=UDim2.new(0,25,0,8)
titleLabel.BackgroundTransparency=1; titleLabel.Text="Booth Manager"
titleLabel.TextColor3=T.TEXT1; titleLabel.Font=Enum.Font.GothamBold
titleLabel.TextSize=16; titleLabel.TextXAlignment=Enum.TextXAlignment.Left; titleLabel.ZIndex=6

local versionLabel = Instance.new("TextLabel",titleBar)
versionLabel.Size=UDim2.new(0,200,0,14); versionLabel.Position=UDim2.new(0,25,0,32)
versionLabel.BackgroundTransparency=1; versionLabel.Text="v5.2 · Grouped Items Edition"
versionLabel.TextColor3=T.TEXT3; versionLabel.Font=Enum.Font.Gotham
versionLabel.TextSize=10; versionLabel.TextXAlignment=Enum.TextXAlignment.Left; versionLabel.ZIndex=6

local liveDot = Instance.new("Frame",titleBar); liveDot.Size=UDim2.new(0,8,0,8)
liveDot.Position=UDim2.new(1,-168,0.5,-4); liveDot.BackgroundColor3=T.SUCCESS
liveDot.BorderSizePixel=0; liveDot.ZIndex=6; corner(liveDot,4)

local liveLabel = Instance.new("TextLabel",titleBar); liveLabel.Size=UDim2.new(0,70,0,14)
liveLabel.Position=UDim2.new(1,-158,0.5,-7); liveLabel.BackgroundTransparency=1; liveLabel.Text="Live"
liveLabel.TextColor3=T.TEXT3; liveLabel.Font=Enum.Font.Gotham; liveLabel.TextSize=10
liveLabel.TextXAlignment=Enum.TextXAlignment.Left; liveLabel.ZIndex=6

task.spawn(function()
    while window and window.Parent do
        tw(liveDot,{BackgroundTransparency=0.6},0.8):Play(); task.wait(0.85)
        tw(liveDot,{BackgroundTransparency=0},0.8):Play();   task.wait(0.85)
    end
end)

local btnRow = Instance.new("Frame",titleBar); btnRow.Size=UDim2.new(0,64,0,16)
btnRow.Position=UDim2.new(1,-76,0.5,-8); btnRow.BackgroundTransparency=1; btnRow.ZIndex=6

local function mkTrafficBtn(col, xOff, icon)
    local btn = Instance.new("TextButton",btnRow)
    btn.Size=UDim2.new(0,14,0,14); btn.Position=UDim2.new(0,xOff,0.5,-7)
    btn.BackgroundColor3=col; btn.Text=""; btn.BorderSizePixel=0; btn.ZIndex=7; corner(btn,7)
    btn.MouseEnter:Connect(function()
        btn.Text=icon; btn.TextSize=7; btn.TextColor3=Color3.new(0,0,0)
        tw(btn,{BackgroundColor3=col:Lerp(Color3.new(1,1,1),0.25)},0.1):Play()
    end)
    btn.MouseLeave:Connect(function()
        btn.Text=""
        tw(btn,{BackgroundColor3=col},0.1):Play()
    end)
    return btn
end

local btnClose    = mkTrafficBtn(T.TL_CLOSE, 0,  "✕")
local btnMinimize = mkTrafficBtn(T.TL_MIN,  22,  "—")
local btnMaximize = mkTrafficBtn(T.TL_MAX,  44,  "+")

-- Drag
local dragging, dragStart, winStart = false, nil, nil
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=i.Position; winStart=window.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        window.Position = UDim2.new(winStart.X.Scale, winStart.X.Offset+d.X,
                                    winStart.Y.Scale, winStart.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
end)

btnClose.MouseButton1Click:Connect(function()
    tw(window,{Size=UDim2.new(0,WIN_W,0,0),
        Position=UDim2.new(window.Position.X.Scale,window.Position.X.Offset,
                           window.Position.Y.Scale,window.Position.Y.Offset+WIN_H/2)},
        0.2,Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()
    tw(shadow,{ImageTransparency=1},0.2):Play()
    task.wait(0.22); screenGui:Destroy(); shadow:Destroy(); notifGui:Destroy()
end)

local minimized = false
btnMinimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(window,{Size=UDim2.new(0,WIN_W,0,minimized and 52 or WIN_H)},
        minimized and 0.2 or 0.35,
        minimized and Enum.EasingStyle.Quint or Enum.EasingStyle.Back):Play()
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- TAB BAR
-- ══════════════════════════════════════════════════════════════════════════════
local TABS = {"Booths","My Booth","Queue","Settings"}

local tabBar = Instance.new("Frame",window); tabBar.Name="TabBar"
tabBar.Size=UDim2.new(1,0,0,40); tabBar.Position=UDim2.new(0,0,0,52)
tabBar.BackgroundColor3=T.BG_PANEL; tabBar.BorderSizePixel=0; tabBar.ZIndex=4
local tabLayout = Instance.new("UIListLayout",tabBar)
tabLayout.FillDirection=Enum.FillDirection.Horizontal
tabLayout.VerticalAlignment=Enum.VerticalAlignment.Center
tabLayout.SortOrder=Enum.SortOrder.LayoutOrder

local tbGap = Instance.new("Frame",window); tbGap.Size=UDim2.new(1,0,0,6)
tbGap.Position=UDim2.new(0,0,0,92); tbGap.BackgroundColor3=T.BG_BASE
tbGap.BorderSizePixel=0; tbGap.ZIndex=3

local contentArea = Instance.new("Frame",window); contentArea.Name="Content"
contentArea.Size=UDim2.new(1,0,1,-98); contentArea.Position=UDim2.new(0,0,0,98)
contentArea.BackgroundTransparency=1; contentArea.ClipsDescendants=true; contentArea.ZIndex=2

local pages, tabBtns, tabInds = {}, {}, {}
local activeTab = ""

local function switchTab(name)
    for n, pg in pairs(pages) do pg.Visible = (n==name) end
    for n, btn in pairs(tabBtns) do
        local on = (n==name)
        tw(tabInds[n],{Size=UDim2.new(on and 0.55 or 0,0,0,2)},0.22):Play()
        tw(btn,{TextColor3=on and T.TEXT1 or T.TEXT3},0.18):Play()
        tw(btn,{BackgroundColor3=on and T.BG_HOVER or T.BG_PANEL},0.18):Play()
    end
    activeTab = name
end

local function mkTabBtn(name, idx)
    local btn = Instance.new("TextButton",tabBar)
    btn.Size=UDim2.new(1/#TABS,0,1,0); btn.BackgroundColor3=T.BG_PANEL
    btn.TextColor3=T.TEXT3; btn.Text=name; btn.Font=Enum.Font.GothamBold
    btn.TextSize=11; btn.BorderSizePixel=0; btn.LayoutOrder=idx; btn.ZIndex=5
    local ind = Instance.new("Frame",btn); ind.Size=UDim2.new(0,0,0,2)
    ind.Position=UDim2.new(0.5,0,1,-1); ind.AnchorPoint=Vector2.new(0.5,0)
    ind.BackgroundColor3=T.ACCENT; ind.BorderSizePixel=0; ind.ZIndex=6; corner(ind,1)
    tabBtns[name]=btn; tabInds[name]=ind
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
    return btn
end
for i, n in ipairs(TABS) do mkTabBtn(n,i) end

-- ══════════════════════════════════════════════════════════════════════════════
-- PAGE FACTORY & SHARED WIDGETS
-- ══════════════════════════════════════════════════════════════════════════════
local function newPage(name)
    local sf = Instance.new("ScrollingFrame",contentArea)
    sf.Name=name.."Page"; sf.Size=UDim2.new(1,0,1,0); sf.BackgroundTransparency=1
    sf.BorderSizePixel=0; sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=T.ACCENT_DIM
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    sf.Visible=false; sf.ZIndex=2; pad(sf,12,10,16,10)
    local layout = Instance.new("UIListLayout",sf)
    layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,8)
    pages[name]=sf; return sf, layout
end

local function mkCard(parent, h, order, col)
    local c = Instance.new("Frame",parent)
    c.Size=UDim2.new(1,0,0,h or 50); c.BackgroundColor3=col or T.BG_CARD
    c.BorderSizePixel=0; c.LayoutOrder=order or 0; corner(c,10); stroke(c,T.BORDER)
    return c
end
local function sectionHdr(parent, text, order)
    local row = Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,26); row.BackgroundTransparency=1; row.LayoutOrder=order or 0
    local line = Instance.new("Frame",row); line.Size=UDim2.new(0,2,0.55,0)
    line.Position=UDim2.new(0,0,0.225,0); line.BackgroundColor3=T.ACCENT; line.BorderSizePixel=0; corner(line,1)
    local lbl = Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-12,1,0); lbl.Position=UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=text:upper()
    lbl.TextColor3=T.TEXT3; lbl.Font=Enum.Font.GothamBold
    lbl.TextSize=10; lbl.TextXAlignment=Enum.TextXAlignment.Left
    return row
end
local function mkBtn(parent, text, col, w, h)
    local btn = Instance.new("TextButton",parent)
    btn.Size=UDim2.new(0,w or 80,0,h or 28); btn.BackgroundColor3=col or T.ACCENT_DIM
    btn.TextColor3=T.TEXT1; btn.Text=text; btn.Font=Enum.Font.GothamBold
    btn.TextSize=12; btn.BorderSizePixel=0; btn.AutoButtonColor=false; corner(btn,7)
    local base = col or T.ACCENT_DIM; local hover = base:Lerp(Color3.new(1,1,1),0.12)
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=hover},0.12):Play() end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=base},0.12):Play() end)
    return btn
end
local function mkTextBox(parent, placeholder)
    local box = Instance.new("TextBox",parent)
    box.BackgroundColor3=T.BG_INPUT; box.TextColor3=T.TEXT1
    box.PlaceholderText=placeholder or ""; box.PlaceholderColor3=T.TEXT3
    box.Font=Enum.Font.GothamBold; box.TextSize=11; box.BorderSizePixel=0
    box.ClearTextOnFocus=false
    corner(box,7); stroke(box,T.BORDER_LIT); pad(box,0,8,0,8)
    return box
end
local function mkToggle(parent, label, defOn, order, onChange)
    local row = mkCard(parent,40,order)
    local lbl = Instance.new("TextLabel",row)
    lbl.Size=UDim2.new(1,-72,1,0); lbl.Position=UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency=1; lbl.Text=label; lbl.TextColor3=T.TEXT1
    lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
    local state = defOn
    local track = Instance.new("TextButton",row)
    track.Size=UDim2.new(0,40,0,22); track.Position=UDim2.new(1,-52,0.5,-11)
    track.BackgroundColor3=state and T.ACCENT or T.BG_INPUT; track.Text=""; track.BorderSizePixel=0
    corner(track,11); stroke(track,T.BORDER)
    local knob = Instance.new("Frame",track); knob.Size=UDim2.new(0,16,0,16)
    knob.Position=state and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3=T.TEXT1; knob.BorderSizePixel=0; corner(knob,8)
    local function set(v)
        state=v; tw(track,{BackgroundColor3=v and T.ACCENT or T.BG_INPUT},0.18):Play()
        tw(knob,{Position=v and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)},0.18):Play()
        if onChange then onChange(v) end
    end
    track.MouseButton1Click:Connect(function() set(not state) end)
    return row, function() return state end, set
end
local function mkStatCard(parent, labelTxt, val, col, order)
    local c = mkCard(parent,72,order)
    local vLbl = Instance.new("TextLabel",c)
    vLbl.Size=UDim2.new(1,-12,0,28); vLbl.Position=UDim2.new(0,12,0,10)
    vLbl.BackgroundTransparency=1; vLbl.Text=tostring(val)
    vLbl.TextColor3=col or T.TEXT1; vLbl.Font=Enum.Font.GothamBold
    vLbl.TextSize=22; vLbl.TextXAlignment=Enum.TextXAlignment.Left
    local lLbl = Instance.new("TextLabel",c)
    lLbl.Size=UDim2.new(1,-12,0,14); lLbl.Position=UDim2.new(0,12,0,44)
    lLbl.BackgroundTransparency=1; lLbl.Text=labelTxt
    lLbl.TextColor3=T.TEXT2; lLbl.Font=Enum.Font.Gotham
    lLbl.TextSize=11; lLbl.TextXAlignment=Enum.TextXAlignment.Left
    return c, vLbl
end

-- ══════════════════════════════════════════════════════════════════════════════
-- WORLD / REMOTE SETUP
-- ══════════════════════════════════════════════════════════════════════════════
local TradeWorld = Workspace:WaitForChild("TradeWorld",30)
local Booths     = TradeWorld and TradeWorld:WaitForChild("Booths",15)
if not (TradeWorld and Booths) then notify("Load Error","World failed to load.","error"); return end

local function safeWait(parent, name, t)
    local ok, r = pcall(function() return parent:WaitForChild(name, t or 10) end)
    return ok and r or nil
end

local GameEvents     = safeWait(ReplicatedStorage,"GameEvents",12)
local TradeEvents    = GameEvents and safeWait(GameEvents,"TradeEvents",8)
local BoothEvents    = TradeEvents and safeWait(TradeEvents,"Booths",8)
local SkinService    = GameEvents and safeWait(GameEvents,"TradeBoothSkinService",8)
if not (GameEvents and TradeEvents and BoothEvents and SkinService) then
    notify("Remote Error","Could not find game remotes.","error"); return
end

local ClaimBoothEvent     = safeWait(BoothEvents,"ClaimBooth",    8)
local RemoveBoothEvent    = safeWait(BoothEvents,"RemoveBooth",   8)
local CreateListingInvoke = safeWait(BoothEvents,"CreateListing", 8)
local SkinEquipEvent      = safeWait(SkinService, "Equip",         8)
local RemoveListingEvent  = safeWait(BoothEvents,"RemoveListing", 3)
local UpdateListingEvent  = safeWait(BoothEvents,"UpdateListing", 3)

if not (ClaimBoothEvent and RemoveBoothEvent and CreateListingInvoke) then
    notify("Remote Error","Core remotes missing.","error"); return
end

-- ══════════════════════════════════════════════════════════════════════════════
-- BOOTH HELPERS
-- ══════════════════════════════════════════════════════════════════════════════
local function getBoothOwner(booth)
    local a = booth:GetAttribute("Owner")
    return (a and a ~= "") and a or nil
end
local function getBoothItemCount(booth)
    local d = booth:FindFirstChild("DynamicInstances")
    return d and #d:GetChildren() or 0
end
local function getBoothStatus(booth)
    local owner = getBoothOwner(booth)
    local items  = getBoothItemCount(booth)
    if owner then return (items > 0) and "claimed" or "partial", owner, items end
    if items > 0 then return "partial", nil, items end
    return "empty", nil, 0
end
local function statusColor(status)
    if status == "empty"   then return T.EMPTY,   "EMPTY"
    elseif status == "claimed" then return T.CLAIMED, "CLAIMED"
    elseif status == "partial" then return T.WARNING, "PARTIAL"
    end
    return T.TEXT3, "UNKNOWN"
end

local function playerHasBooth()
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

local function findClosestEmptyBooth()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local closest, closestDist = nil, math.huge
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") and getBoothStatus(booth) == "empty" then
            if hrp then
                local part = booth.PrimaryPart or booth:FindFirstChildWhichIsA("BasePart")
                if part then
                    local d = (part.Position - hrp.Position).Magnitude
                    if d < closestDist then closestDist=d; closest=booth end
                end
            else return booth end
        end
    end
    return closest
end

local function findAnyEmptyBooth()
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") and getBoothStatus(booth) == "empty" then return booth end
    end
    return nil
end

-- ══════════════════════════════════════════════════════════════════════════════
-- QUEUE / LISTING SYSTEM
-- ══════════════════════════════════════════════════════════════════════════════
local listingQueue = {}

if config.backupItems and type(config.backupItems) == "table" then
    for _, item in ipairs(config.backupItems) do
        table.insert(listingQueue, item)
    end
end

local function isInQueue(name)
    for _, item in ipairs(listingQueue) do if item.name == name then return true end end
    return false
end
local function getQueuedItem(name)
    for _, item in ipairs(listingQueue) do if item.name == name then return item end end
    return nil
end
local function addToQueue(itemName, price, itemType, itemId, priority)
    if isInQueue(itemName) then notify("Already Queued",itemName.." is already queued.","warning"); return false end
    table.insert(listingQueue, {name=itemName,price=price,type=itemType,id=itemId,priority=priority or "normal"})
    table.sort(listingQueue, function(a,b)
        local p1 = a.priority=="high" and 1 or 0; local p2 = b.priority=="high" and 1 or 0
        if p1~=p2 then return p1>p2 end; return false
    end)
    config.backupItems=listingQueue; saveConfig(); return true
end
local function removeFromQueue(name)
    for i = #listingQueue, 1, -1 do
        if listingQueue[i].name == name then table.remove(listingQueue,i) end
    end
    config.backupItems=listingQueue; saveConfig()
end

local function itemInBackpack(name)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return false end
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") and tool.Name == name then return true end
    end
    return false
end

local function getListingCount()
    local count = 0
    local pg  = LocalPlayer:FindFirstChild("PlayerGui")
    local tb  = pg and pg:FindFirstChild("TradeBooth")
    if tb then
        local fr = tb:FindFirstChildOfClass("Frame")
        local il = fr and fr:FindFirstChild("ItemsList")
        local sc = il and il:FindFirstChildOfClass("ScrollingFrame")
        if sc then
            for _, v in ipairs(sc:GetChildren()) do
                if v:IsA("Frame") and v.Name == "HoverableItemTemplate" then count += 1 end
            end
        end
    end
    return count
end

local function getListedItems()
    local items = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    local tb = pg and pg:FindFirstChild("TradeBooth")
    if not tb then return items end
    local fr = tb:FindFirstChildOfClass("Frame")
    local il = fr and fr:FindFirstChild("ItemsList")
    local sc = il and il:FindFirstChildOfClass("ScrollingFrame")
    if not sc then return items end
    for _, v in ipairs(sc:GetChildren()) do
        if v:IsA("Frame") and v.Name == "HoverableItemTemplate" then
            local nameText, priceText, listingId = "Unknown", "?", nil
            local function searchLabels(inst, depth)
                if depth > 4 then return end
                for _, child in ipairs(inst:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        local txt = child.Text or ""
                        if txt ~= "" and not txt:match("^%s*$") then
                            if txt:match("^%d+$") or txt:match("^%d+,") then
                                priceText = txt
                            elseif #txt > 2 and not txt:match("^[%p]+$") then
                                if nameText == "Unknown" then nameText = txt end
                            end
                        end
                    end
                    searchLabels(child, depth+1)
                end
            end
            searchLabels(v, 0)
            listingId = v:GetAttribute("ListingId") or v:GetAttribute("ID") or v:GetAttribute("Id")
            table.insert(items, {frame=v, name=nameText, price=priceText, id=listingId})
        end
    end
    return items
end

-- ══════════════════════════════════════════════════════════════════════════════
-- NEW: LISTED ITEM TRACKING
-- ══════════════════════════════════════════════════════════════════════════════
-- listedItemNames[name] = true  →  that item is already listed in the booth
local listedItemNames = {}

local function refreshListedNames()
    listedItemNames = {}
    local items = getListedItems()
    for _, item in ipairs(items) do
        if item.name and item.name ~= "Unknown" then
            listedItemNames[item.name] = true
        end
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- NEW: GROUP EXPAND STATE
-- ══════════════════════════════════════════════════════════════════════════════
-- expandedGroups[itemName] = true  →  that group card is expanded
local expandedGroups = {}

-- ══════════════════════════════════════════════════════════════════════════════
-- FORWARD DECLARATIONS
-- ══════════════════════════════════════════════════════════════════════════════
local refreshQueueList, scanBackpackForBooth, scanBackpackForQueue, refreshListedItems
local vQueueCount, vAlreadyListed

-- ══════════════════════════════════════════════════════════════════════════════
-- PAGE 1 · BOOTHS
-- ══════════════════════════════════════════════════════════════════════════════
local boothsPage = newPage("Booths")
sectionHdr(boothsPage,"Overview",1)

local statsRow = Instance.new("Frame",boothsPage)
statsRow.Size=UDim2.new(1,0,0,72); statsRow.BackgroundTransparency=1; statsRow.LayoutOrder=2
local sg = Instance.new("UIGridLayout",statsRow)
sg.CellSize=UDim2.new(0.333,-4,0,72); sg.CellPadding=UDim2.new(0,6,0,0)
local _, vTotal   = mkStatCard(statsRow,"Total",    "0",T.TEXT1,  1)
local _, vEmpty   = mkStatCard(statsRow,"Empty",    "0",T.EMPTY,  2)
local _, vClaimed = mkStatCard(statsRow,"Occupied", "0",T.CLAIMED,3)

sectionHdr(boothsPage,"Live Status",3)
local syncCard = mkCard(boothsPage,30,4)
local syncDot = Instance.new("Frame",syncCard); syncDot.Size=UDim2.new(0,7,0,7)
syncDot.Position=UDim2.new(0,10,0.5,-3.5); syncDot.BackgroundColor3=T.SUCCESS
syncDot.BorderSizePixel=0; corner(syncDot,4)
local syncText = Instance.new("TextLabel",syncCard)
syncText.Size=UDim2.new(1,-30,1,0); syncText.Position=UDim2.new(0,24,0,0)
syncText.BackgroundTransparency=1; syncText.Text="Syncing booths..."
syncText.TextColor3=T.TEXT2; syncText.Font=Enum.Font.GothamBold
syncText.TextSize=10; syncText.TextXAlignment=Enum.TextXAlignment.Left

sectionHdr(boothsPage,"Booths",5)
local boothList = Instance.new("Frame",boothsPage)
boothList.Size=UDim2.new(1,0,0,0); boothList.BackgroundTransparency=1
boothList.LayoutOrder=6; boothList.AutomaticSize=Enum.AutomaticSize.Y
local boothListLayout = Instance.new("UIListLayout",boothList)
boothListLayout.SortOrder=Enum.SortOrder.LayoutOrder; boothListLayout.Padding=UDim.new(0,6)

local boothRegistry = {}
local boothCardRefs = {}

local function createBoothCard(data)
    local sColor, sText = statusColor(data.status)
    local card = mkCard(boothList,80,data.index)
    local stripe = Instance.new("Frame",card)
    stripe.Size=UDim2.new(0,3,0.6,0); stripe.Position=UDim2.new(0,0,0.2,0)
    stripe.BackgroundColor3=sColor; stripe.BorderSizePixel=0; corner(stripe,2)
    local badge = Instance.new("Frame",card)
    badge.Size=UDim2.new(0,38,0,38); badge.Position=UDim2.new(0,12,0.5,-19)
    badge.BackgroundColor3=Color3.new(sColor.R*.12,sColor.G*.12,sColor.B*.12); corner(badge,10)
    local badgeNum = Instance.new("TextLabel",badge)
    badgeNum.Size=UDim2.new(1,0,1,0); badgeNum.BackgroundTransparency=1
    badgeNum.Text=tostring(data.index); badgeNum.TextColor3=sColor
    badgeNum.Font=Enum.Font.GothamBold; badgeNum.TextSize=15
    local nameLabel = Instance.new("TextLabel",card)
    nameLabel.Size=UDim2.new(0,180,0,20); nameLabel.Position=UDim2.new(0,60,0,10)
    nameLabel.BackgroundTransparency=1; nameLabel.Text=data.name
    nameLabel.TextColor3=T.TEXT1; nameLabel.Font=Enum.Font.GothamBold
    nameLabel.TextSize=13; nameLabel.TextXAlignment=Enum.TextXAlignment.Left
    local pill = Instance.new("Frame",card)
    pill.Size=UDim2.new(0,0,0,17); pill.Position=UDim2.new(0,60,0,33)
    pill.BackgroundColor3=Color3.new(sColor.R*.1,sColor.G*.1,sColor.B*.1)
    pill.BorderSizePixel=0; pill.AutomaticSize=Enum.AutomaticSize.X; corner(pill,4)
    local pillTxt = Instance.new("TextLabel",pill)
    pillTxt.Size=UDim2.new(0,0,1,0); pillTxt.BackgroundTransparency=1
    pillTxt.Text=sText; pillTxt.TextColor3=sColor
    pillTxt.Font=Enum.Font.GothamBold; pillTxt.TextSize=9
    pillTxt.AutomaticSize=Enum.AutomaticSize.X; pad(pillTxt,0,7,0,7)
    local parts = {data.owner~="" and ("@"..data.owner) or "Unclaimed"}
    if data.itemCount and data.itemCount>0 then table.insert(parts,data.itemCount.." items") end
    local subLabel = Instance.new("TextLabel",card)
    subLabel.Size=UDim2.new(0,220,0,14); subLabel.Position=UDim2.new(0,60,0,56)
    subLabel.BackgroundTransparency=1; subLabel.Text=table.concat(parts," · ")
    subLabel.TextColor3=T.TEXT3; subLabel.Font=Enum.Font.Gotham
    subLabel.TextSize=10; subLabel.TextXAlignment=Enum.TextXAlignment.Left
    local claimBtn = nil
    if data.status == "empty" then
        claimBtn = mkBtn(card,"Claim",T.ACCENT_DIM,62,26)
        claimBtn.Position=UDim2.new(1,-72,0.5,-13)
        claimBtn.MouseButton1Click:Connect(function()
            safeFire(RemoveBoothEvent); task.wait(0.4)
            safeFire(ClaimBoothEvent,data.boothRef)
            notify("Claiming",data.name,"info")
        end)
    end
    return card, {stripe,badge,badgeNum,nameLabel,pill,pillTxt,subLabel,claimBtn}
end

-- ══════════════════════════════════════════════════════════════════════════════
-- PAGE 2 · MY BOOTH
-- ══════════════════════════════════════════════════════════════════════════════
local myBoothPage = newPage("My Booth")
sectionHdr(myBoothPage,"Controls",1)

local manageCard = mkCard(myBoothPage,56,2)
local manageTxt = Instance.new("TextLabel",manageCard)
manageTxt.Size=UDim2.new(1,-110,1,0); manageTxt.Position=UDim2.new(0,12,0,0)
manageTxt.BackgroundTransparency=1; manageTxt.Text="Remove your active booth"
manageTxt.TextColor3=T.TEXT2; manageTxt.Font=Enum.Font.GothamBold
manageTxt.TextSize=12; manageTxt.TextXAlignment=Enum.TextXAlignment.Left
manageTxt.TextYAlignment=Enum.TextYAlignment.Center
local removeBoothBtn = mkBtn(manageCard,"Remove",T.ERROR,80,28)
removeBoothBtn.Position=UDim2.new(1,-92,0.5,-14)
removeBoothBtn.MouseButton1Click:Connect(function()
    safeFire(RemoveBoothEvent); notify("Removed","Booth freed","warning")
end)

-- ── Listed Items Panel ────────────────────────────────────────────────────────
sectionHdr(myBoothPage,"Listed Items",3)

local refreshListedBtn = mkBtn(myBoothPage,"↻ Refresh",T.ACCENT_DIM,90,26)
refreshListedBtn.LayoutOrder=4

local listedContainer = Instance.new("Frame",myBoothPage)
listedContainer.Size=UDim2.new(1,0,0,0); listedContainer.BackgroundTransparency=1
listedContainer.LayoutOrder=5; listedContainer.AutomaticSize=Enum.AutomaticSize.Y
local listedLayout = Instance.new("UIListLayout",listedContainer)
listedLayout.SortOrder=Enum.SortOrder.LayoutOrder; listedLayout.Padding=UDim.new(0,5)

refreshListedItems = function()
    for _, v in ipairs(listedContainer:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    refreshListedNames()   -- sync the set too
    local items = getListedItems()
    if #items == 0 then
        local ec = mkCard(listedContainer,34,1)
        local et = Instance.new("TextLabel",ec)
        et.Size=UDim2.new(1,0,1,0); et.BackgroundTransparency=1
        et.Text="No items currently listed"; et.TextColor3=T.TEXT3
        et.Font=Enum.Font.GothamBold; et.TextSize=12
        return
    end
    for i, item in ipairs(items) do
        local row = mkCard(listedContainer,86,i)

        local nameLbl = Instance.new("TextLabel",row)
        nameLbl.Size=UDim2.new(1,-16,0,20); nameLbl.Position=UDim2.new(0,12,0,8)
        nameLbl.BackgroundTransparency=1; nameLbl.Text=item.name
        nameLbl.TextColor3=T.TEXT1; nameLbl.Font=Enum.Font.GothamBold
        nameLbl.TextSize=13; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
        nameLbl.TextTruncate=Enum.TextTruncate.AtEnd

        local curPriceLbl = Instance.new("TextLabel",row)
        curPriceLbl.Size=UDim2.new(0,130,0,16); curPriceLbl.Position=UDim2.new(0,12,0,30)
        curPriceLbl.BackgroundTransparency=1
        curPriceLbl.Text="🪙 Current: "..formatPrice(tonumber(item.price) or 0)
        curPriceLbl.TextColor3=T.WARNING; curPriceLbl.Font=Enum.Font.GothamBold
        curPriceLbl.TextSize=11; curPriceLbl.TextXAlignment=Enum.TextXAlignment.Left

        local newPriceBox = mkTextBox(row,"New price  e.g. 1,000 🪙")
        newPriceBox.Size=UDim2.new(0,120,0,24); newPriceBox.Position=UDim2.new(0,12,0,56)

        local chgBtn = mkBtn(row,"Change",T.ACCENT_DIM,64,24)
        chgBtn.Position=UDim2.new(0,138,0,56); chgBtn.TextSize=11
        chgBtn.MouseButton1Click:Connect(function()
            local newPrice = tonumber(newPriceBox.Text)
            if not newPrice or newPrice <= 0 then
                notify("Bad Price","Enter a valid positive number","warning"); return
            end
            if UpdateListingEvent then
                safeFire(UpdateListingEvent, item.id, newPrice)
                notify("Price Changed",item.name.." → 🪙 "..formatPrice(newPrice),"success")
                newPriceBox.Text = ""
                task.wait(0.5); refreshListedItems()
            else
                notify("Remote Missing","UpdateListing remote not found.","error")
            end
        end)

        local rmBtn = mkBtn(row,"✕ Remove",T.ERROR,80,24)
        rmBtn.Position=UDim2.new(1,-92,0,56); rmBtn.TextSize=11
        rmBtn.MouseButton1Click:Connect(function()
            if RemoveListingEvent then
                safeFire(RemoveListingEvent, item.id)
                notify("Removed",item.name.." removed","warning")
                task.wait(0.5); refreshListedItems()
            else
                notify("Remote Missing","RemoveListing remote not found.","error")
            end
        end)
    end
end

refreshListedBtn.MouseButton1Click:Connect(function() refreshListedItems() end)

-- ── Backpack Items ────────────────────────────────────────────────────────────
sectionHdr(myBoothPage,"Backpack Items",6)

local mySearchCard = mkCard(myBoothPage,36,7)
local mySearchBox = mkTextBox(mySearchCard,"🔍  Search items...")
mySearchBox.Size=UDim2.new(1,-16,0,24); mySearchBox.Position=UDim2.new(0,8,0.5,-12)

local bpContainer = Instance.new("Frame",myBoothPage)
bpContainer.Size=UDim2.new(1,0,0,0); bpContainer.BackgroundTransparency=1
bpContainer.LayoutOrder=8; bpContainer.AutomaticSize=Enum.AutomaticSize.Y
local bpLayout = Instance.new("UIListLayout",bpContainer)
bpLayout.SortOrder=Enum.SortOrder.LayoutOrder; bpLayout.Padding=UDim.new(0,5)

-- ══════════════════════════════════════════════════════════════════════════════
-- PAGE 3 · QUEUE
-- ══════════════════════════════════════════════════════════════════════════════
local queuePage = newPage("Queue")
sectionHdr(queuePage,"Overview",1)

local qStatsRow = Instance.new("Frame",queuePage)
qStatsRow.Size=UDim2.new(1,0,0,52); qStatsRow.BackgroundTransparency=1; qStatsRow.LayoutOrder=2
local qsg = Instance.new("UIGridLayout",qStatsRow)
qsg.CellSize=UDim2.new(0.5,-4,0,52); qsg.CellPadding=UDim2.new(0,6,0,0)
local _, vQueueCountStat = mkStatCard(qStatsRow,"In Queue","0",T.ACCENT,  1)
local _, vListedStat     = mkStatCard(qStatsRow,"Listed",  "0",T.SUCCESS, 2)
vQueueCount = vQueueCountStat; vAlreadyListed = vListedStat

sectionHdr(queuePage,"Add Items",3)
local addCard = mkCard(queuePage,0,4)
addCard.AutomaticSize=Enum.AutomaticSize.Y; pad(addCard,8,10,10,10)
local addLayout = Instance.new("UIListLayout",addCard)
addLayout.SortOrder=Enum.SortOrder.LayoutOrder; addLayout.Padding=UDim.new(0,6)

local toolbarFrame = Instance.new("Frame",addCard)
toolbarFrame.Size=UDim2.new(1,0,0,30); toolbarFrame.BackgroundTransparency=1; toolbarFrame.LayoutOrder=1

local qSearchBox = mkTextBox(toolbarFrame,"🔍  Search items...")
qSearchBox.Size=UDim2.new(1,-130,0,28); qSearchBox.Position=UDim2.new(0,0,0,1)

local SORT_STATES = {"name","name_desc","type","type_desc"}
local SORT_LABELS = {name="Name ↑",name_desc="Name ↓",type="Type ↑",type_desc="Type ↓"}
local currentSort = "name"

local sortBtn = mkBtn(toolbarFrame,"Name ↑",T.ACCENT_DIM,60,28)
sortBtn.Position=UDim2.new(1,-124,0,1)

local FILTER_STATES = {"all","Pet","Holdable"}
local FILTER_LABELS = {all="All",Pet="Pets",Holdable="Items"}
local FILTER_COLORS = {all=T.ACCENT_DIM,Pet=T.PINK,Holdable=T.CYAN}
local currentFilter = "all"

local filterBtn = mkBtn(toolbarFrame,"All",T.ACCENT_DIM,58,28)
filterBtn.Position=UDim2.new(1,-60,0,1)

sortBtn.MouseButton1Click:Connect(function()
    local idx=1; for i,v in ipairs(SORT_STATES) do if v==currentSort then idx=i; break end end
    idx=(idx%#SORT_STATES)+1; currentSort=SORT_STATES[idx]; sortBtn.Text=SORT_LABELS[currentSort]
    if not anyBoxFocused() then scanBackpackForQueue() end
end)
filterBtn.MouseButton1Click:Connect(function()
    local idx=1; for i,v in ipairs(FILTER_STATES) do if v==currentFilter then idx=i; break end end
    idx=(idx%#FILTER_STATES)+1; currentFilter=FILTER_STATES[idx]
    filterBtn.Text=FILTER_LABELS[currentFilter]
    filterBtn.BackgroundColor3=FILTER_COLORS[currentFilter]
    if not anyBoxFocused() then scanBackpackForQueue() end
end)

local qBpContainer = Instance.new("Frame",addCard)
qBpContainer.Size=UDim2.new(1,0,0,0); qBpContainer.BackgroundTransparency=1
qBpContainer.AutomaticSize=Enum.AutomaticSize.Y; qBpContainer.LayoutOrder=2
local qBpLayout = Instance.new("UIListLayout",qBpContainer)
qBpLayout.SortOrder=Enum.SortOrder.LayoutOrder; qBpLayout.Padding=UDim.new(0,5)

local autoScanCard = mkCard(addCard,26,3)
local asDot = Instance.new("Frame",autoScanCard); asDot.Size=UDim2.new(0,7,0,7)
asDot.Position=UDim2.new(0,10,0.5,-3.5); asDot.BackgroundColor3=T.CYAN
asDot.BorderSizePixel=0; corner(asDot,4)
local asLabel = Instance.new("TextLabel",autoScanCard)
asLabel.Size=UDim2.new(1,-30,1,0); asLabel.Position=UDim2.new(0,24,0,0)
asLabel.BackgroundTransparency=1
asLabel.Text="Auto-scan every "..AUTO_SCAN_RATE.."s  ·  skips while typing"
asLabel.TextColor3=T.TEXT3; asLabel.Font=Enum.Font.Gotham
asLabel.TextSize=10; asLabel.TextXAlignment=Enum.TextXAlignment.Left

-- ── Current Queue List ────────────────────────────────────────────────────────
sectionHdr(queuePage,"Current Queue",5)
local queueListFrame = Instance.new("Frame",queuePage)
queueListFrame.Size=UDim2.new(1,0,0,0); queueListFrame.BackgroundTransparency=1
queueListFrame.LayoutOrder=6; queueListFrame.AutomaticSize=Enum.AutomaticSize.Y
local queueListLayout2 = Instance.new("UIListLayout",queueListFrame)
queueListLayout2.SortOrder=Enum.SortOrder.LayoutOrder; queueListLayout2.Padding=UDim.new(0,5)

local clearAllBtn = mkBtn(queuePage,"Clear All",T.ERROR,0,30)
clearAllBtn.Size=UDim2.new(1,0,0,30); clearAllBtn.LayoutOrder=7
clearAllBtn.MouseButton1Click:Connect(function()
    listingQueue={}; config.backupItems={}; saveConfig()
    refreshQueueList(); vQueueCount.Text="0"
    notify("Cleared","Queue emptied","warning")
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- PAGE 4 · SETTINGS
-- ══════════════════════════════════════════════════════════════════════════════
local settingsPage = newPage("Settings")
sectionHdr(settingsPage,"Automation",1)
mkToggle(settingsPage,"Auto-list from queue",   config.autoList,    2,function(v) config.autoList=v;     saveConfig() end)
mkToggle(settingsPage,"Auto-claim booth on join",config.autoClaim,  3,function(v) config.autoClaim=v;   saveConfig() end)
mkToggle(settingsPage,"Claim closest booth",    config.claimClosest,4,function(v) config.claimClosest=v; saveConfig() end)
sectionHdr(settingsPage,"Display",5)
mkToggle(settingsPage,"Show owner names",     config.settings.showOwnerNames,  6,function(v) config.settings.showOwnerNames=v;  saveConfig() end)
mkToggle(settingsPage,"Show item count",      config.settings.showItemCount,   7,function(v) config.settings.showItemCount=v;   saveConfig() end)
mkToggle(settingsPage,"Highlight nearest",    config.settings.highlightNearest,8,function(v) config.settings.highlightNearest=v;saveConfig() end)

-- ══════════════════════════════════════════════════════════════════════════════
-- NEW: GROUPED ITEM CARD BUILDER
-- ══════════════════════════════════════════════════════════════════════════════
-- group = { name=string, itemType=string, list=[{tool, itemId, isFav},...] }
-- mode  = "booth" | "queue"
-- ──────────────────────────────────────────────────────────────────────────────
local function createGroupedItemCard(container, group, mode, idx)
    local isSingle   = #group.list == 1
    local itemName   = group.name
    local itemType   = group.itemType
    local typeCol    = itemType == "Pet" and T.PINK or T.CYAN
    local isExpanded = expandedGroups[itemName] or isSingle   -- singles always open

    -- ── outer wrapper card  (AutomaticSize=Y so it grows/shrinks) ──────────
    local wrapper = Instance.new("Frame", container)
    wrapper.Name            = "GroupCard_"..itemName
    wrapper.Size            = UDim2.new(1, 0, 0, 0)
    wrapper.BackgroundColor3= T.BG_CARD
    wrapper.BorderSizePixel = 0
    wrapper.LayoutOrder     = idx
    wrapper.AutomaticSize   = Enum.AutomaticSize.Y
    corner(wrapper, 10); stroke(wrapper, T.BORDER)

    local wLayout = Instance.new("UIListLayout", wrapper)
    wLayout.SortOrder  = Enum.SortOrder.LayoutOrder
    wLayout.Padding    = UDim.new(0, 0)

    -- ── HEADER ROW ───────────────────────────────────────────────────────────
    local header = Instance.new("Frame", wrapper)
    header.Name             = "Header"
    header.Size             = UDim2.new(1, 0, 0, 54)
    header.BackgroundColor3 = T.GROUP_HDR
    header.BorderSizePixel  = 0
    header.LayoutOrder      = 1
    corner(header, 10)

    -- left type stripe
    local typeStripe = Instance.new("Frame", header)
    typeStripe.Size             = UDim2.new(0, 3, 0.55, 0)
    typeStripe.Position         = UDim2.new(0, 0, 0.225, 0)
    typeStripe.BackgroundColor3 = typeCol
    typeStripe.BorderSizePixel  = 0
    corner(typeStripe, 2)

    -- icon badge
    local iconBadge = Instance.new("Frame", header)
    iconBadge.Size             = UDim2.new(0, 34, 0, 34)
    iconBadge.Position         = UDim2.new(0, 10, 0.5, -17)
    iconBadge.BackgroundColor3 = Color3.new(typeCol.R*.1, typeCol.G*.1, typeCol.B*.1)
    corner(iconBadge, 9)
    local iconLabel = Instance.new("TextLabel", iconBadge)
    iconLabel.Size = UDim2.new(1,0,1,0); iconLabel.BackgroundTransparency = 1
    iconLabel.Text = itemType == "Pet" and "🐾" or "🎒"; iconLabel.TextSize = 16

    -- item name
    local nameLabel = Instance.new("TextLabel", header)
    nameLabel.Size              = UDim2.new(1, -160, 0, 18)
    nameLabel.Position          = UDim2.new(0, 54, 0, 9)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text              = itemName
    nameLabel.TextColor3        = T.TEXT1
    nameLabel.Font              = Enum.Font.GothamBold
    nameLabel.TextSize          = 13
    nameLabel.TextXAlignment    = Enum.TextXAlignment.Left
    nameLabel.TextTruncate      = Enum.TextTruncate.AtEnd

    -- type sub-label
    local subLabel = Instance.new("TextLabel", header)
    subLabel.Size           = UDim2.new(1, -160, 0, 14)
    subLabel.Position       = UDim2.new(0, 54, 0, 29)
    subLabel.BackgroundTransparency = 1
    subLabel.Text           = itemType
    subLabel.TextColor3     = T.TEXT3
    subLabel.Font           = Enum.Font.Gotham
    subLabel.TextSize       = 10
    subLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- count badge (only for multiples)
    if not isSingle then
        local countBadge = Instance.new("Frame", header)
        countBadge.Size             = UDim2.new(0, 0, 0, 20)
        countBadge.Position         = UDim2.new(1, isSingle and -10 or -88, 0.5, -10)
        countBadge.AnchorPoint      = Vector2.new(1, 0)
        countBadge.BackgroundColor3 = T.ACCENT_DIM
        countBadge.BorderSizePixel  = 0
        countBadge.AutomaticSize    = Enum.AutomaticSize.X
        corner(countBadge, 6)
        local countLbl = Instance.new("TextLabel", countBadge)
        countLbl.Size = UDim2.new(0,0,1,0); countLbl.BackgroundTransparency = 1
        countLbl.Text = "×"..#group.list
        countLbl.TextColor3 = T.GLOW; countLbl.Font = Enum.Font.GothamBold; countLbl.TextSize = 11
        countLbl.AutomaticSize = Enum.AutomaticSize.X; pad(countLbl,0,7,0,7)
    end

    -- expand / collapse button (only for multiples)
    local expandBtn
    if not isSingle then
        expandBtn = Instance.new("TextButton", header)
        expandBtn.Size             = UDim2.new(0, 28, 0, 28)
        expandBtn.Position         = UDim2.new(1, -38, 0.5, -14)
        expandBtn.BackgroundColor3 = T.BG_CARD2
        expandBtn.Text             = isExpanded and "▲" or "▼"
        expandBtn.TextColor3       = T.TEXT2
        expandBtn.Font             = Enum.Font.GothamBold
        expandBtn.TextSize         = 12
        expandBtn.BorderSizePixel  = 0
        expandBtn.AutoButtonColor  = false
        corner(expandBtn, 7)
        expandBtn.MouseButton1Click:Connect(function()
            expandedGroups[itemName] = not expandedGroups[itemName]
            -- rebuild current tab
            if activeTab == "My Booth" then
                if not anyBoxFocused() then scanBackpackForBooth() end
            elseif activeTab == "Queue" then
                if not anyBoxFocused() then scanBackpackForQueue() end
            end
        end)
    end

    -- ── DIVIDER (shown when expanded) ────────────────────────────────────────
    if isExpanded then
        local divider = Instance.new("Frame", wrapper)
        divider.Name             = "Divider"
        divider.Size             = UDim2.new(1, -20, 0, 1)
        divider.BackgroundColor3 = T.BORDER_LIT
        divider.BorderSizePixel  = 0
        divider.LayoutOrder      = 2
    end

    -- ══════════════════════════════════════════════════════════════════════════
    -- SUB-ITEM ROWS  (built only when expanded)
    -- ══════════════════════════════════════════════════════════════════════════
    if isExpanded then
        for j, entry in ipairs(group.list) do
            local tool   = entry.tool
            local itemId = entry.itemId
            local isFav  = entry.isFav
            local isListed = listedItemNames[itemName] == true

            local subRow = Instance.new("Frame", wrapper)
            subRow.Name             = "SubItem_"..j
            subRow.Size             = UDim2.new(1, 0, 0, 46)
            subRow.BackgroundTransparency = 1
            subRow.LayoutOrder      = 2 + j

            -- index pill
            local idxPill = Instance.new("Frame", subRow)
            idxPill.Size             = UDim2.new(0, 22, 0, 22)
            idxPill.Position         = UDim2.new(0, 12, 0.5, -11)
            idxPill.BackgroundColor3 = T.BG_CARD2
            idxPill.BorderSizePixel  = 0
            corner(idxPill, 6)
            local idxLbl = Instance.new("TextLabel", idxPill)
            idxLbl.Size = UDim2.new(1,0,1,0); idxLbl.BackgroundTransparency = 1
            idxLbl.Text = tostring(j); idxLbl.TextColor3 = T.TEXT3
            idxLbl.Font = Enum.Font.GothamBold; idxLbl.TextSize = 10

            -- UUID (truncated)
            local uuidLbl = Instance.new("TextLabel", subRow)
            uuidLbl.Size             = UDim2.new(0, 100, 0, 14)
            uuidLbl.Position         = UDim2.new(0, 42, 0.5, -7)
            uuidLbl.BackgroundTransparency = 1
            uuidLbl.Text             = "ID: "..string.sub(tostring(itemId), 1, 10)
            uuidLbl.TextColor3       = T.TEXT3
            uuidLbl.Font             = Enum.Font.Gotham
            uuidLbl.TextSize         = 10
            uuidLbl.TextXAlignment   = Enum.TextXAlignment.Left

            -- ── RIGHT AREA: fav-locked / listed / actionable ────────────────
            if isFav then
                -- 🔒 FAVORITED — cannot list
                local favBadge = Instance.new("Frame", subRow)
                favBadge.Size             = UDim2.new(0, 0, 0, 22)
                favBadge.Position         = UDim2.new(1, -10, 0.5, -11)
                favBadge.AnchorPoint      = Vector2.new(1, 0)
                favBadge.BackgroundColor3 = Color3.new(T.FAV_LOCK.R*.12, T.FAV_LOCK.G*.12, 0)
                favBadge.BorderSizePixel  = 0
                favBadge.AutomaticSize    = Enum.AutomaticSize.X
                corner(favBadge, 6)
                stroke(favBadge, T.FAV_LOCK, 1, 0.4)
                local favLbl = Instance.new("TextLabel", favBadge)
                favLbl.Size = UDim2.new(0,0,1,0); favLbl.BackgroundTransparency = 1
                favLbl.Text = "⭐ Favorited"; favLbl.TextColor3 = T.FAV_LOCK
                favLbl.Font = Enum.Font.GothamBold; favLbl.TextSize = 10
                favLbl.AutomaticSize = Enum.AutomaticSize.X; pad(favLbl,0,7,0,7)

            elseif isListed then
                -- ✓ LISTED — already in booth, can't re-list
                local listedBadge = Instance.new("Frame", subRow)
                listedBadge.Size             = UDim2.new(0, 0, 0, 22)
                listedBadge.Position         = UDim2.new(1, -10, 0.5, -11)
                listedBadge.AnchorPoint      = Vector2.new(1, 0)
                listedBadge.BackgroundColor3 = Color3.new(0, T.LISTED.G*.1, T.LISTED.B*.1)
                listedBadge.BorderSizePixel  = 0
                listedBadge.AutomaticSize    = Enum.AutomaticSize.X
                corner(listedBadge, 6)
                stroke(listedBadge, T.LISTED, 1, 0.4)
                local listedLbl = Instance.new("TextLabel", listedBadge)
                listedLbl.Size = UDim2.new(0,0,1,0); listedLbl.BackgroundTransparency = 1
                listedLbl.Text = "✓ Listed"; listedLbl.TextColor3 = T.LISTED
                listedLbl.Font = Enum.Font.GothamBold; listedLbl.TextSize = 10
                listedLbl.AutomaticSize = Enum.AutomaticSize.X; pad(listedLbl,0,7,0,7)

            elseif mode == "booth" then
                -- price box + List button
                local priceBox = mkTextBox(subRow, pricePlaceholder(tool))
                priceBox.Size     = UDim2.new(0, 84, 0, 24)
                priceBox.Position = UDim2.new(1, -174, 0.5, -12)

                local listBtn = mkBtn(subRow, "List", T.ACCENT_DIM, 80, 24)
                listBtn.Position  = UDim2.new(1, -88, 0.5, -12)
                listBtn.TextSize  = 11
                listBtn.MouseButton1Click:Connect(function()
                    local price = tonumber(priceBox.Text)
                    if not price or price <= 0 then
                        notify("Bad Price","Enter a valid price  e.g. 1,000","warning"); return
                    end
                    if isFav then notify("Favorited",tool.Name.." is favorited — unstar it first","warning"); return end
                    if listedItemNames[itemName] then notify("Already Listed",itemName.." is already in your booth","warning"); return end
                    local ok,_ = safeInvoke(CreateListingInvoke, itemType, itemId, price)
                    if ok then
                        notify("Listed!",tool.Name.." @ 🪙 "..formatPrice(price),"success")
                        priceBox.Text = ""
                        listedItemNames[itemName] = true
                        task.wait(0.3); scanBackpackForBooth()
                    else notify("Error","Listing failed","error") end
                end)

            else
                -- queue mode: price + priority + Add button
                local inQ = isInQueue(tool.Name)

                if inQ then
                    local qItem = getQueuedItem(tool.Name)
                    local qBadge = Instance.new("Frame", subRow)
                    qBadge.Size             = UDim2.new(0, 0, 0, 22)
                    qBadge.Position         = UDim2.new(1, -10, 0.5, -11)
                    qBadge.AnchorPoint      = Vector2.new(1, 0)
                    qBadge.BackgroundColor3 = Color3.new(0, T.SUCCESS.G*.1, 0)
                    qBadge.BorderSizePixel  = 0
                    qBadge.AutomaticSize    = Enum.AutomaticSize.X
                    corner(qBadge, 6)
                    stroke(qBadge, T.SUCCESS, 1, 0.4)
                    local qLbl = Instance.new("TextLabel", qBadge)
                    qLbl.Size = UDim2.new(0,0,1,0); qLbl.BackgroundTransparency = 1
                    qLbl.Text = "✓ Queued"..(qItem and " · 🪙 "..formatPrice(qItem.price) or "")
                    qLbl.TextColor3 = T.SUCCESS; qLbl.Font = Enum.Font.GothamBold; qLbl.TextSize = 10
                    qLbl.AutomaticSize = Enum.AutomaticSize.X; pad(qLbl,0,7,0,7)

                    local rmvBtn = mkBtn(subRow, "✕", T.ERROR, 26, 24)
                    rmvBtn.Position  = UDim2.new(0, 42, 0.5, -12)
                    rmvBtn.TextSize  = 12
                    rmvBtn.MouseButton1Click:Connect(function()
                        removeFromQueue(tool.Name)
                        refreshQueueList(); vQueueCount.Text = tostring(#listingQueue)
                        if not anyBoxFocused() then scanBackpackForQueue() end
                    end)
                else
                    local priceBox = mkTextBox(subRow, pricePlaceholder(tool))
                    priceBox.Size     = UDim2.new(0, 72, 0, 24)
                    priceBox.Position = UDim2.new(1, -174, 0.5, -12)

                    local addBtn = mkBtn(subRow, "+ Add", T.SUCCESS, 78, 24)
                    addBtn.Position   = UDim2.new(1, -90, 0.5, -12)
                    addBtn.TextSize   = 11
                    addBtn.MouseButton1Click:Connect(function()
                        if isFav then notify("Favorited",tool.Name.." is favorited — unstar to queue","warning"); return end
                        if listedItemNames[itemName] then notify("Already Listed",itemName.." is already listed","warning"); return end
                        local price = tonumber(priceBox.Text)
                        if not price or price <= 0 then
                            notify("Invalid Price","Enter a positive number  e.g. 1,000","error"); return
                        end
                        if addToQueue(tool.Name, price, itemType, itemId, "normal") then
                            notify("Queued", tool.Name.." @ 🪙 "..formatPrice(price), "success")
                            priceBox.Text = ""
                            refreshQueueList(); vQueueCount.Text = tostring(#listingQueue)
                            if not anyBoxFocused() then scanBackpackForQueue() end
                        end
                    end)
                end
            end

            -- thin separator between sub-items (not last)
            if j < #group.list then
                local sep = Instance.new("Frame", wrapper)
                sep.Name             = "Sep_"..j
                sep.Size             = UDim2.new(1, -20, 0, 1)
                sep.BackgroundColor3 = T.BORDER
                sep.BorderSizePixel  = 0
                sep.LayoutOrder      = 2 + j + 0.5   -- between sub items
            end
        end
    end

    return wrapper
end

-- ══════════════════════════════════════════════════════════════════════════════
-- BACKPACK COLLECTION  (flat list, sorted)
-- ══════════════════════════════════════════════════════════════════════════════
local function collectBackpackItems(searchQuery, filter, sortMode)
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if not bp then return {} end
    local items = {}
    for _, tool in ipairs(bp:GetChildren()) do
        if tool:IsA("Tool") then
            local petUUID = tool:GetAttribute("PET_UUID")
            local fruitC  = tool:GetAttribute("c")
            local isFav   = tool:GetAttribute("d") == true
            local itemType, itemId
            if petUUID      then itemType="Pet";      itemId=petUUID
            elseif fruitC   then itemType="Holdable"; itemId=fruitC
            else continue end
            if searchQuery and searchQuery ~= "" then
                if not tool.Name:lower():find(searchQuery:lower(), 1, true) then continue end
            end
            if filter and filter ~= "all" and itemType ~= filter then continue end
            table.insert(items, {tool=tool, itemType=itemType, itemId=itemId, isFav=isFav})
        end
    end
    local mode = sortMode or "name"
    if mode == "name"      then table.sort(items,function(a,b) return a.tool.Name < b.tool.Name end)
    elseif mode=="name_desc" then table.sort(items,function(a,b) return a.tool.Name > b.tool.Name end)
    elseif mode=="type"      then table.sort(items,function(a,b) return a.itemType < b.itemType end)
    elseif mode=="type_desc" then table.sort(items,function(a,b) return a.itemType > b.itemType end)
    end
    return items
end

-- ── NEW: group flat list by item name ─────────────────────────────────────────
-- Returns: [ {name, itemType, list=[...]}, ... ]  in insertion order (= sorted order)
local function groupItems(flatList)
    local groups    = {}
    local groupMap  = {}
    for _, entry in ipairs(flatList) do
        local n = entry.tool.Name
        if not groupMap[n] then
            groupMap[n] = {name=n, itemType=entry.itemType, list={}}
            table.insert(groups, groupMap[n])
        end
        table.insert(groupMap[n].list, entry)
    end
    return groups
end

-- ══════════════════════════════════════════════════════════════════════════════
-- BACKPACK SCAN FUNCTIONS  (now use grouped cards)
-- ══════════════════════════════════════════════════════════════════════════════
local myBoothSearch = ""
mySearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    myBoothSearch = mySearchBox.Text
    local snap = myBoothSearch
    task.delay(0.35, function()
        if myBoothSearch == snap then scanBackpackForBooth() end
    end)
end)

scanBackpackForBooth = function()
    refreshListedNames()
    for _, v in ipairs(bpContainer:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local flat   = collectBackpackItems(myBoothSearch, "all", "name")
    local groups = groupItems(flat)
    if #groups == 0 then
        local ec = mkCard(bpContainer,34,1)
        local et = Instance.new("TextLabel",ec); et.Size=UDim2.new(1,0,1,0); et.BackgroundTransparency=1
        et.Text = myBoothSearch ~= "" and '🔍 No results for "'..myBoothSearch..'"' or "No items in backpack"
        et.TextColor3=T.TEXT3; et.Font=Enum.Font.GothamBold; et.TextSize=12
        return
    end
    for i, group in ipairs(groups) do
        createGroupedItemCard(bpContainer, group, "booth", i)
    end
end

local queueSearch = ""
qSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    queueSearch = qSearchBox.Text
    local snap = queueSearch
    task.delay(0.35, function()
        if queueSearch == snap then scanBackpackForQueue() end
    end)
end)

scanBackpackForQueue = function()
    refreshListedNames()
    for _, v in ipairs(qBpContainer:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local flat   = collectBackpackItems(queueSearch, currentFilter ~= "all" and currentFilter or nil, currentSort)
    local groups = groupItems(flat)
    if #groups == 0 then
        local ec = mkCard(qBpContainer,34,1)
        local et = Instance.new("TextLabel",ec); et.Size=UDim2.new(1,0,1,0); et.BackgroundTransparency=1
        if queueSearch ~= "" then et.Text = '🔍 No results for "'..queueSearch..'"'
        elseif currentFilter ~= "all" then et.Text = "No "..currentFilter.."s found"
        else et.Text = "No items in backpack" end
        et.TextColor3=T.TEXT3; et.Font=Enum.Font.GothamBold; et.TextSize=12
        return
    end
    for i, group in ipairs(groups) do
        createGroupedItemCard(qBpContainer, group, "queue", i)
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- QUEUE LIST  (with backpack & fav validation)
-- ══════════════════════════════════════════════════════════════════════════════
refreshQueueList = function()
    for _, v in ipairs(queueListFrame:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    if #listingQueue == 0 then
        local ec = mkCard(queueListFrame,34,1)
        local et = Instance.new("TextLabel",ec); et.Size=UDim2.new(1,0,1,0); et.BackgroundTransparency=1
        et.Text="Queue is empty"; et.TextColor3=T.TEXT3; et.Font=Enum.Font.GothamBold; et.TextSize=12
        return
    end
    for i, item in ipairs(listingQueue) do
        local exists = itemInBackpack(item.name)
        local isAlreadyListed = listedItemNames[item.name] == true
        local rowCol = exists and T.BG_CARD or Color3.fromRGB(30,16,16)
        local row = mkCard(queueListFrame,62,i,rowCol)

        -- priority badge
        local priBadge = Instance.new("Frame",row)
        priBadge.Size             = UDim2.new(0,0,0,17); priBadge.Position=UDim2.new(0,10,0,6)
        priBadge.BackgroundColor3 = item.priority=="high" and T.WARNING or T.ACCENT_DIM
        priBadge.BorderSizePixel  = 0; priBadge.AutomaticSize=Enum.AutomaticSize.X; corner(priBadge,5)
        local priLbl = Instance.new("TextLabel",priBadge)
        priLbl.Size=UDim2.new(0,0,1,0); priLbl.BackgroundTransparency=1
        priLbl.Text=(item.priority=="high" and "⭐ " or "").."#"..i
        priLbl.TextColor3=T.BG_BASE; priLbl.Font=Enum.Font.GothamBold; priLbl.TextSize=10
        priLbl.AutomaticSize=Enum.AutomaticSize.X; pad(priLbl,0,5,0,5)

        -- name
        local nLbl = Instance.new("TextLabel",row)
        nLbl.Size=UDim2.new(1,-120,0,18); nLbl.Position=UDim2.new(0,10,0,6)
        nLbl.BackgroundTransparency=1; nLbl.Text=item.name
        nLbl.TextColor3=exists and T.TEXT1 or T.MISSING
        nLbl.Font=Enum.Font.GothamBold; nLbl.TextSize=12; nLbl.TextXAlignment=Enum.TextXAlignment.Left

        -- price
        local pLbl = Instance.new("TextLabel",row)
        pLbl.Size=UDim2.new(0,110,0,14); pLbl.Position=UDim2.new(0,10,0,26)
        pLbl.BackgroundTransparency=1; pLbl.Text="🪙 "..formatPrice(tonumber(item.price) or 0)
        pLbl.TextColor3=T.WARNING; pLbl.Font=Enum.Font.GothamBold
        pLbl.TextSize=11; pLbl.TextXAlignment=Enum.TextXAlignment.Left

        -- warning badges row
        local badgeX = 10
        if not exists then
            local mb = Instance.new("Frame",row); mb.Size=UDim2.new(0,0,0,16)
            mb.Position=UDim2.new(0,badgeX,0,43); mb.BackgroundColor3=T.MISSING
            mb.BorderSizePixel=0; mb.AutomaticSize=Enum.AutomaticSize.X; corner(mb,4)
            local ml = Instance.new("TextLabel",mb); ml.Size=UDim2.new(0,0,1,0); ml.BackgroundTransparency=1
            ml.Text="⚠ Not in backpack"; ml.TextColor3=T.BG_BASE
            ml.Font=Enum.Font.GothamBold; ml.TextSize=9
            ml.AutomaticSize=Enum.AutomaticSize.X; pad(ml,0,5,0,5)
            badgeX = badgeX + 120
        end
        if isAlreadyListed then
            local lb = Instance.new("Frame",row); lb.Size=UDim2.new(0,0,0,16)
            lb.Position=UDim2.new(0,badgeX,0,43); lb.BackgroundColor3=T.LISTED
            lb.BorderSizePixel=0; lb.AutomaticSize=Enum.AutomaticSize.X; corner(lb,4)
            local ll = Instance.new("TextLabel",lb); ll.Size=UDim2.new(0,0,1,0); ll.BackgroundTransparency=1
            ll.Text="✓ Already listed"; ll.TextColor3=T.BG_BASE
            ll.Font=Enum.Font.GothamBold; ll.TextSize=9
            ll.AutomaticSize=Enum.AutomaticSize.X; pad(ll,0,5,0,5)
        end

        -- remove button
        local rmBtn = mkBtn(row,"✕",T.ERROR,32,28)
        rmBtn.Position=UDim2.new(1,-42,0.5,-14); rmBtn.TextSize=13
        rmBtn.MouseButton1Click:Connect(function()
            table.remove(listingQueue,i); config.backupItems=listingQueue; saveConfig()
            refreshQueueList(); vQueueCount.Text=tostring(#listingQueue)
        end)
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO-SCAN LOOP
-- ══════════════════════════════════════════════════════════════════════════════
task.spawn(function()
    while window and window.Parent do
        task.wait(AUTO_SCAN_RATE)
        if not screenGui.Parent then break end
        if anyBoxFocused() then continue end
        pcall(function()
            if activeTab == "My Booth" then
                scanBackpackForBooth()
            elseif activeTab == "Queue" then
                scanBackpackForQueue()
            end
        end)
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO-LIST LOOP
-- NEW: skips items that are favorited or already listed
-- ══════════════════════════════════════════════════════════════════════════════
task.spawn(function()
    while task.wait(2) do
        if not screenGui.Parent then break end
        if config.autoList then
            refreshListedNames()  -- sync listed set before processing queue
            local current = getListingCount()
            local slots   = config.maxListings - current
            local attempts = 0
            while attempts < slots and #listingQueue > 0 and config.autoList do
                local next = listingQueue[1]

                -- Skip if already listed in booth
                if listedItemNames[next.name] then
                    notify("Already Listed", next.name.." is already in booth — skipping", "info")
                    table.remove(listingQueue, 1); config.backupItems=listingQueue; saveConfig()
                    vQueueCount.Text = tostring(#listingQueue)
                    continue
                end

                -- Find matching tool in backpack (skip favorited)
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local found = nil
                if bp then
                    for _, tool in ipairs(bp:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name == next.name then
                            if tool:GetAttribute("d") == true then
                                -- favorited — skip and pop from queue
                                notify("Fav Protected", next.name.." is favorited — removed from queue", "warning")
                                table.remove(listingQueue, 1); config.backupItems=listingQueue; saveConfig()
                                vQueueCount.Text = tostring(#listingQueue)
                                found = nil; break
                            end
                            found = tool; break
                        end
                    end
                end

                if not found then
                    notify("Not Found", next.name.." not in backpack.", "warning")
                    table.remove(listingQueue, 1); config.backupItems=listingQueue; saveConfig()
                else
                    local ok,_ = safeInvoke(CreateListingInvoke, next.type, next.id, next.price)
                    if ok then
                        notify("Auto Listed!", next.name.." @ 🪙 "..formatPrice(next.price), "success")
                        listedItemNames[next.name] = true
                        table.remove(listingQueue, 1); config.backupItems=listingQueue; saveConfig()
                        vQueueCount.Text = tostring(#listingQueue)
                        task.wait(LISTING_COOLDOWN); attempts += 1
                    else break end
                end
            end
        end
        vListedStat.Text = tostring(getListingCount())
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- BOOTH LIVE UPDATE
-- ══════════════════════════════════════════════════════════════════════════════
local function fullRebuild()
    for _, v in ipairs(boothList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    boothRegistry={}; boothCardRefs={}
    local total,empty,claimed = 0,0,0; local idx=0
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") then
            idx+=1; total+=1
            local status,owner,itemCount = getBoothStatus(booth)
            if status=="empty" then empty+=1 else claimed+=1 end
            local data={name=booth.Name,status=status,owner=owner or "",itemCount=itemCount,index=idx,boothRef=booth}
            boothRegistry[booth.Name]=data
            local card,els = createBoothCard(data)
            boothCardRefs[booth.Name]={frame=card,els=els,data=data}
        end
    end
    vTotal.Text=tostring(total); vEmpty.Text=tostring(empty); vClaimed.Text=tostring(claimed)
    syncText.Text="Last sync: "..os.date("%H:%M")
end

local function liveUpdate()
    refreshListedNames()   -- keep listed set fresh
    local total,empty,claimed = 0,0,0
    for _, booth in ipairs(Booths:GetChildren()) do
        if booth:IsA("Model") then
            total+=1
            local status,owner,itemCount = getBoothStatus(booth)
            if status=="empty" then empty+=1 else claimed+=1 end
            local prev = boothRegistry[booth.Name]
            if not prev or prev.status~=status or prev.owner~=(owner or "") then
                local nd={name=booth.Name,status=status,owner=owner or "",itemCount=itemCount,
                          index=prev and prev.index or 0,boothRef=booth}
                boothRegistry[booth.Name]=nd
                local ref = boothCardRefs[booth.Name]
                if ref and ref.frame and ref.frame.Parent then
                    local sColor,sText = statusColor(status)
                    local els = ref.els
                    tw(els[1],{BackgroundColor3=sColor},0.3):Play()
                    els[3].TextColor3=sColor; els[6].Text=sText
                    local parts={owner and "@"..owner or "Unclaimed"}
                    if itemCount and itemCount>0 then table.insert(parts,itemCount.." items") end
                    els[7].Text=table.concat(parts," · ")
                    if status=="empty" and not els[8] then
                        local cb = mkBtn(ref.frame,"Claim",T.ACCENT_DIM,62,26)
                        cb.Position=UDim2.new(1,-72,0.5,-13)
                        cb.MouseButton1Click:Connect(function()
                            -- safeFire(RemoveBoothEvent); task.wait(0.4)
                            safeFire(ClaimBoothEvent,nd.boothRef)
                            notify("Claiming",nd.name,"info")
                        end)
                        els[8]=cb
                    elseif status~="empty" and els[8] then
                        els[8]:Destroy(); els[8]=nil
                    end
                    ref.data=nd
                end
            end
        end
    end
    vTotal.Text=tostring(total); vEmpty.Text=tostring(empty); vClaimed.Text=tostring(claimed)
    syncText.Text="Last sync: "..os.date("%H:%M")
end

task.spawn(function()
    while task.wait(LIVE_UPDATE_RATE) do
        if screenGui.Parent then pcall(liveUpdate) end
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- AUTO-CLAIM ON JOIN
-- ══════════════════════════════════════════════════════════════════════════════
task.spawn(function()
    if not config.autoClaim then return end
    task.wait(3)
    if playerHasBooth() then return end

    notify("Auto Claim","Searching for a booth...","info")
    local claimed = false

    for attempt = 1, MAX_CLAIM_ATTEMPTS do
        if claimed then break end
        if not screenGui.Parent then break end
        if playerHasBooth() then claimed=true; break end

        local targetBooth = config.claimClosest and findClosestEmptyBooth() or findAnyEmptyBooth()
        if targetBooth then
            safeFire(RemoveBoothEvent); task.wait(0.5)
            safeFire(ClaimBoothEvent, targetBooth)
            notify("Auto Claim","Attempting "..targetBooth.Name.." (try "..attempt..")","info")
            task.wait(CLAIM_RETRY_DELAY)
            if playerHasBooth() then
                claimed=true; notify("Claimed!",targetBooth.Name.." secured ✓","success"); break
            end
        else
            task.wait(CLAIM_RETRY_DELAY)
        end
    end

    if not claimed then
        notify("Auto Claim","Could not claim a booth after "..MAX_CLAIM_ATTEMPTS.." attempts.","warning")
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- INIT
-- ══════════════════════════════════════════════════════════════════════════════
window.Size     = UDim2.new(0,WIN_W,0,0)
window.Position = UDim2.new(0.5,-WIN_W/2,0.5,0)
shadow.ImageTransparency = 1
tw(window,{Size=UDim2.new(0,WIN_W,0,WIN_H),Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2)},
    0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out):Play()
tw(shadow,{ImageTransparency=0.5},0.5):Play()

task.wait(0.6)
notify("Booth Manager v5.2","Grouped items · Listed lock · Fav lock · Token prices","success")

task.spawn(function()
    refreshListedNames()
    fullRebuild()
    refreshQueueList()
    vQueueCount.Text = tostring(#listingQueue)
    refreshListedItems()
    scanBackpackForBooth()
    scanBackpackForQueue()
end)

switchTab("Booths")

-- Anti-AFK
task.spawn(function()
    while true do
        VirtualInputManager:SendKeyEvent(true,Enum.KeyCode.F15,false,game)
        task.wait(0.05)
        VirtualInputManager:SendKeyEvent(false,Enum.KeyCode.F15,false,game)
        task.wait(math.random(2,5))
    end
end)
