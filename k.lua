local cloneref = cloneref or clonereference or function(instance)
    return instance
end

local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local Toggles = {}
local Options = {}
local Labels = {}
local Buttons = {}

local Library = {
    LocalPlayer = LocalPlayer,
    ScreenGui = nil,
    Window = nil,
    ActiveTab = nil,
    Tabs = {},
    TabButtons = {},

    Scheme = {},
    Registry = {},
    Gradients = {},
    Scales = {},

    IsMobile = false,
    DevicePlatform = nil,
    DPIScale = 1,
    OriginalMinSize = Vector2.new(400, 300),
    MinSize = Vector2.new(400, 300),

    Toggles = Toggles,
    Options = Options,
    Labels = Labels,
    Buttons = Buttons,

    TweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Unloaded = false,
    ToggleKey = Enum.KeyCode.RightShift,
    Folder = "DannyUI",
}

do
    local mobile = false
    local ok, platform = pcall(function()
        return UserInputService:GetPlatform()
    end)
    if ok then
        Library.DevicePlatform = platform
        mobile = platform == Enum.Platform.Android or platform == Enum.Platform.IOS
    end
    if not mobile then
        mobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
    end
    Library.IsMobile = mobile
    Library.OriginalMinSize = mobile and Vector2.new(320, 220) or Vector2.new(400, 300)
    Library.MinSize = Library.OriginalMinSize
end

local SchemeOrder = {
    "FontColor",
    "SubTextColor",
    "MainColor",
    "AccentColor",
    "BackgroundColor",
    "OutlineColor",
    "CardColor",
    "CardHoverColor",
    "TabIdleColor",
    "TabActiveColor",
    "MuteColor",
    "TrackColor",
    "FillColor",
    "DangerColor",
    "ToggleOnCard",
    "ToggleOnPill",
    "ToggleOnText",
    "KnobOffColor",
    "SliderKnobColor",
    "ButtonHoverColor",
    "TopButtonColor",
    "PanelGradMid",
    "PanelGradEnd",
    "GlowColor",
    "TitleStrokeColor",
    "OnInkColor",
}

local BaseScheme = {
    FontColor = Color3.fromRGB(232, 241, 255),
    SubTextColor = Color3.fromRGB(142, 165, 198),
    MainColor = Color3.fromRGB(14, 18, 26),
    AccentColor = Color3.fromRGB(68, 224, 255),
    BackgroundColor = Color3.fromRGB(9, 11, 16),
    OutlineColor = Color3.fromRGB(46, 76, 122),
    CardColor = Color3.fromRGB(15, 20, 30),
    CardHoverColor = Color3.fromRGB(19, 25, 38),
    TabIdleColor = Color3.fromRGB(20, 28, 40),
    TabActiveColor = Color3.fromRGB(28, 57, 96),
    MuteColor = Color3.fromRGB(28, 36, 50),
    TrackColor = Color3.fromRGB(24, 33, 47),
    FillColor = Color3.fromRGB(68, 224, 255),
    DangerColor = Color3.fromRGB(255, 70, 90),
    OnInkColor = Color3.fromRGB(0, 0, 0),
    ToggleOnCard = Color3.fromRGB(17, 33, 59),
    ToggleOnPill = Color3.fromRGB(24, 77, 133),
    ToggleOnText = Color3.fromRGB(240, 250, 255),
    KnobOffColor = Color3.fromRGB(170, 186, 212),
    TopButtonColor = Color3.fromRGB(18, 24, 34),
    ButtonHoverColor = Color3.fromRGB(28, 42, 66),
    PanelGradMid = Color3.fromRGB(18, 24, 36),
    PanelGradEnd = Color3.fromRGB(12, 15, 24),
    GlowColor = Color3.fromRGB(0, 160, 255),
    TitleStrokeColor = Color3.fromRGB(7, 36, 66),
    SliderKnobColor = Color3.fromRGB(224, 247, 255),
    Font = Enum.Font.GothamSemibold,
    CornerRadius = 16,
    CardCornerRadius = 12,
    TabBarWidth = 130,
    HeaderHeight = 58,
    GradientColors = {
        Color3.fromRGB(95, 190, 255),
        Color3.fromRGB(215, 248, 255),
        Color3.fromRGB(78, 162, 255),
        Color3.fromRGB(220, 250, 255),
        Color3.fromRGB(88, 176, 255),
        Color3.fromRGB(95, 190, 255),
    },
    FooterGradientColors = {
        Color3.fromRGB(165, 220, 235),
        Color3.fromRGB(85, 190, 220),
        Color3.fromRGB(165, 220, 235),
    },
    GradientSpeed = 0.45,
}

for k, v in pairs(BaseScheme) do
    Library.Scheme[k] = v
end

local Themes = {
    Default = {
        1,
        {
            FontColor = "e8f1ff",
            SubTextColor = "8ea5c6",
            MainColor = "0e121a",
            AccentColor = "44e0ff",
            BackgroundColor = "090b10",
            OutlineColor = "2e4c7a",
            CardColor = "0f141e",
            CardHoverColor = "131926",
            TabIdleColor = "141c28",
            TabActiveColor = "1c3960",
            MuteColor = "1c2432",
            TrackColor = "18212f",
            FillColor = "44e0ff",
            DangerColor = "ff465a",
            OnInkColor = "000000",
            ToggleOnCard = "11213b",
            ToggleOnPill = "184d85",
            ToggleOnText = "f0faff",
            KnobOffColor = "aabader",
            SliderKnobColor = "e0f7ff",
            ButtonHoverColor = "1c2a42",
            TopButtonColor = "121822",
            PanelGradMid = "121824",
            PanelGradEnd = "0c0f18",
            GlowColor = "00a0ff",
            TitleStrokeColor = "072442",
            GradientColors = { "5fbeff", "d7f8ff", "4ea2ff", "dcfaff", "58b0ff", "5fbeff" },
        },
    },
    Mono = {
        2,
        {
            FontColor = "e8e8e8",
            SubTextColor = "8c8c8c",
            MainColor = "0c0c0c",
            AccentColor = "ffffff",
            BackgroundColor = "050505",
            OutlineColor = "3a3a3a",
            CardColor = "121212",
            CardHoverColor = "1c1c1c",
            TabIdleColor = "141414",
            TabActiveColor = "2e2e2e",
            MuteColor = "2a2a2a",
            TrackColor = "222222",
            FillColor = "ffffff",
            DangerColor = "c8c8c8",
            OnInkColor = "000000",
            ToggleOnCard = "1a1a1a",
            ToggleOnPill = "3a3a3a",
            ToggleOnText = "ffffff",
            KnobOffColor = "b4b4b4",
            SliderKnobColor = "ffffff",
            ButtonHoverColor = "242424",
            TopButtonColor = "1a1a1a",
            PanelGradMid = "161616",
            PanelGradEnd = "0a0a0a",
            GlowColor = "a0a0a0",
            TitleStrokeColor = "2a2a2a",
            GradientColors = { "c8c8c8", "ffffff", "a0a0a0", "ffffff", "c8c8c8" },
        },
    },
    Midnight = {
        3,
        {
            FontColor = "dbeafe",
            SubTextColor = "93c5fd",
            MainColor = "0c1e42",
            AccentColor = "5591f4",
            BackgroundColor = "0a0f1e",
            OutlineColor = "1e3a8a",
            CardColor = "101828",
            CardHoverColor = "182038",
            TabIdleColor = "121a30",
            TabActiveColor = "1e3a8a",
            MuteColor = "1c2740",
            TrackColor = "243048",
            FillColor = "2563eb",
            DangerColor = "f87171",
            OnInkColor = "000000",
            ToggleOnCard = "132447",
            ToggleOnPill = "1e3a8a",
            ToggleOnText = "eff6ff",
            KnobOffColor = "93c5fd",
            SliderKnobColor = "dbeafe",
            ButtonHoverColor = "182038",
            TopButtonColor = "101828",
            PanelGradMid = "122040",
            PanelGradEnd = "0a1428",
            GlowColor = "3b82f6",
            TitleStrokeColor = "1e3a8a",
            GradientColors = { "60a5fa", "dbeafe", "93c5fd", "eff6ff", "60a5fa" },
        },
    },
}

local function Tween(Object, Info, Properties)
    local TweenObject = TweenService:Create(Object, Info or Library.TweenInfo, Properties)
    TweenObject:Play()
    return TweenObject
end

local function GetContrastColor(Background)
    local _, _, Value = Background:ToHSV()
    if Value > 0.65 then
        return Library.Scheme.OnInkColor or Color3.new(0, 0, 0)
    end
    return Library.Scheme.FontColor
end

local function New(ClassName, Properties, Children)
    local InstanceObject = Instance.new(ClassName)
    for Property, Value in pairs(Properties or {}) do
        if Property ~= "ThemeTag" then
            InstanceObject[Property] = Value
        end
    end
    if Properties and Properties.ThemeTag then
        Library:AddToRegistry(InstanceObject, Properties.ThemeTag)
        for Property, SchemeKey in pairs(Properties.ThemeTag) do
            local Value = Library.Scheme[SchemeKey]
            if Value ~= nil and typeof(Value) ~= "table" then
                InstanceObject[Property] = Value
            end
        end
    end
    for _, Child in ipairs(Children or {}) do
        Child.Parent = InstanceObject
    end
    return InstanceObject
end

local function ColorToHex(Color)
    return string.format("%02x%02x%02x", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
end

local function HexToColor(Hex)
    if typeof(Hex) == "Color3" then
        return Hex
    end
    if typeof(Hex) ~= "string" then
        return nil
    end
    Hex = string.gsub(Hex, "#", "")
    if #Hex ~= 6 then
        return nil
    end
    local Success, Color = pcall(Color3.fromHex, Hex)
    if Success then
        return Color
    end
    return nil
end

local function GetGradientColors(colors)
    local out = {}
    if typeof(colors) ~= "table" then
        return Library.Scheme.GradientColors
    end
    for _, c in ipairs(colors) do
        local col = HexToColor(c) or (typeof(c) == "Color3" and c) or nil
        if col then
            out[#out + 1] = col
        end
    end
    if #out < 2 then
        return Library.Scheme.GradientColors
    end
    return out
end

local function MakeColorSequence(colors)
    colors = GetGradientColors(colors)
    local keypoints = {}
    local n = #colors
    for i, c in ipairs(colors) do
        local t = (i - 1) / math.max(n - 1, 1)
        keypoints[#keypoints + 1] = ColorSequenceKeypoint.new(t, c)
    end
    return ColorSequence.new(keypoints)
end

local function OffsetColorSequence(colors, shift)
    colors = GetGradientColors(colors)
    local n = #colors
    if n < 2 then
        return MakeColorSequence(colors)
    end
    shift = (shift or 0) % 1
    if shift < 0 then
        shift = shift + 1
    end

    local keyed = {}
    for i = 1, n do
        local t = ((i - 1) / n + shift) % 1
        keyed[#keyed + 1] = { t = t, c = colors[i] }
    end
    table.sort(keyed, function(a, b)
        return a.t < b.t
    end)

    local first, last = keyed[1], keyed[#keyed]
    local gap = first.t + (1 - last.t)
    local seam = first.c
    if gap > 1e-6 then
        seam = last.c:Lerp(first.c, first.t / gap)
    end

    local kp = { ColorSequenceKeypoint.new(0, seam) }
    for _, k in ipairs(keyed) do
        if k.t > 1e-4 and k.t < 1 - 1e-4 then
            kp[#kp + 1] = ColorSequenceKeypoint.new(k.t, k.c)
        end
    end
    kp[#kp + 1] = ColorSequenceKeypoint.new(1, seam)
    return ColorSequence.new(kp)
end

function Library:GetBetterColor(Color, Add)
    local h, s, v = Color:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(v + (Add / 255), 0, 1))
end

function Library:SafeCallback(Func, ...)
    if typeof(Func) ~= "function" then
        return
    end
    pcall(Func, ...)
end

function Library:Validate(Table, Template)
    Table = Table or {}
    for k, v in pairs(Template) do
        if Table[k] == nil then
            Table[k] = v
        end
    end
    return Table
end

function Library:GiveSignal(Connection)
    if not Library.Signals then
        Library.Signals = {}
    end
    Library.Signals[#Library.Signals + 1] = Connection
    return Connection
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for instance, properties in pairs(Library.Registry) do
        if typeof(instance) == "Instance" and instance.Parent then
            for property, index in pairs(properties) do
                local value
                if typeof(index) == "function" then
                    value = index()
                else
                    value = Library.Scheme[index]
                end
                if value ~= nil and typeof(value) ~= "table" then
                    pcall(function()
                        instance[property] = value
                    end)
                end
            end
        else
            Library.Registry[Instance] = nil
        end
    end
    for _, Grad in ipairs(Library.Gradients) do
        if Grad.Gradient and Grad.Gradient.Parent then
            local Cols = Grad.Colors or Library.Scheme.GradientColors
            if Grad.Mode == "Pendulum" then
                Grad.Gradient.Color = MakeColorSequence(Cols)
            else
                Grad.Gradient.Color = OffsetColorSequence(Cols, 0)
            end
        end
    end
    local Chrome = Library.Chrome
    if Chrome then
        if Chrome.PanelGrad and Chrome.PanelGrad.Parent then
            Chrome.PanelGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Scheme.PanelGradMid),
                ColorSequenceKeypoint.new(0.45, Library.Scheme.MainColor),
                ColorSequenceKeypoint.new(1, Library.Scheme.PanelGradEnd),
            })
        end
        if Chrome.TabBarGrad and Chrome.TabBarGrad.Parent then
            Chrome.TabBarGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Scheme.TabIdleColor),
                ColorSequenceKeypoint.new(0.45, Library.Scheme.TabActiveColor),
                ColorSequenceKeypoint.new(1, Library.Scheme.AccentColor),
            })
        end
        if Chrome.ContentGlowGrad and Chrome.ContentGlowGrad.Parent then
            Chrome.ContentGlowGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Library.Scheme.TabActiveColor),
                ColorSequenceKeypoint.new(1, Library.Scheme.MainColor),
            })
        end
    end
    for _, toggle in pairs(Toggles) do
        if toggle.Refresh then
            toggle:Refresh()
        end
    end
    if Library.ActiveTab and Library.ActiveTab.Select then
        Library.ActiveTab:Select()
    end
end

function Library:AddGradient(gradient, opts)
    opts = opts or {}
    if not gradient then
        return nil
    end
    local mode = opts.Mode or "Scroll"
    local entry = {
        Gradient = gradient,
        Enabled = opts.Enabled ~= false,
        Mode = mode,
        Speed = opts.Speed or Library.Scheme.GradientSpeed or 0.45,
        Colors = opts.Colors and GetGradientColors(opts.Colors) or nil,
        Phase = opts.Phase or 0,
        TileRepeat = false,
    }
    local cols = entry.Colors or Library.Scheme.GradientColors
    if mode == "Pendulum" then
        gradient.Color = MakeColorSequence(cols)
    else
        gradient.Color = OffsetColorSequence(cols, 0)
    end
    gradient.Transparency = NumberSequence.new(0)
    gradient.Offset = Vector2.zero
    if opts.Rotation ~= nil then
        gradient.Rotation = opts.Rotation
    end
    entry.TileRepeat = pcall(function()
        gradient.TileMode = Enum.GradientTileMode.Repeat
    end)
    Library.Gradients[#Library.Gradients + 1] = entry
    return entry
end

function Library:SetLabelGradient(label, info)
    info = info or {}
    if info.Gradient == false then
        local existing = label:FindFirstChildOfClass("UIGradient")
        if existing then
            existing:Destroy()
        end
        return nil
    end
    if info.Gradient ~= true and not info.GradientColors then
        return nil
    end

    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = New("UIGradient", { Name = "LabelGradient", Parent = label })
    end
    return Library:AddGradient(grad, {
        Enabled = true,
        Mode = info.Mode or "Scroll",
        Colors = info.GradientColors,
        Speed = info.GradientSpeed,
        Phase = info.GradientPhase,
        Rotation = info.Rotation,
    })
end

function Library:CreateLabel(parent, info)
    info = Library:Validate(info, {
        Text = "Header",
        Size = UDim2.new(1, 0, 0, 22),
        Position = nil,
        TextSize = 14,
        Font = nil,
        Gradient = false,
        GradientColors = nil,
        Sub = false,
    })

    local label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = info.Size,
        Position = info.Position,
        Font = info.Font or (info.Sub and Enum.Font.Gotham or Library.Scheme.Font),
        Text = info.Text,
        TextSize = info.TextSize,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ThemeTag = {
            TextColor3 = info.Sub and "SubTextColor" or "FontColor",
        },
        Parent = parent,
    })

    if info.Gradient then
        Library:SetLabelGradient(label, info)
    end
    return label
end

function Library:CreateOuter(parent, height)
    local card = New("Frame", {
        Size = UDim2.new(1, -2, 0, height or 48),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "CardColor" },
        Parent = parent,
    })
    New("UICorner", { CornerRadius = UDim.new(0, Library.Scheme.CardCornerRadius or 2), Parent = card })
    local stroke = New("UIStroke", {
        Thickness = 1,
        Transparency = 0.45,
        ThemeTag = { Color = "OutlineColor" },
        Parent = card,
    })
    return card, stroke
end

local function ApplyHover(Card, IsLocked)
    Library:GiveSignal(Card.MouseEnter:Connect(function()
        if IsLocked and IsLocked() then
            return
        end
        Tween(Card, nil, { BackgroundColor3 = Library.Scheme.CardHoverColor })
    end))
    Library:GiveSignal(Card.MouseLeave:Connect(function()
        if IsLocked and IsLocked() then
            return
        end
        Tween(Card, nil, { BackgroundColor3 = Library.Scheme.CardColor })
    end))
end

local Funcs = {}

function Funcs:AddLabel(Idx, Info)
    if typeof(Idx) == "table" then
        Info = Idx
        Idx = Info.Idx or ("Label_" .. tostring(#Labels + 1))
    end
    Info = Library:Validate(Info, {
        Text = "Label",
        Gradient = false,
        GradientColors = nil,
        DoesWrap = false,
        Tall = false,
    })

    local height = Info.Tall and 36 or 28
    local card = Library:CreateOuter(self.Container, height)
    local label = Library:CreateLabel(card, {
        Text = Info.Text,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(12, 0),
        TextSize = 13,
        Gradient = Info.Gradient,
        GradientColors = Info.GradientColors,
        GradientSpeed = Info.GradientSpeed,
    })
    if Info.DoesWrap then
        label.TextWrapped = true
    end

    local obj = {
        Type = "Label",
        Text = Info.Text,
        SetText = function(_, text)
            label.Text = tostring(text)
        end,
        SetGradient = function(_, enabled, colors)
            Library:SetLabelGradient(label, {
                Gradient = enabled and true or false,
                GradientColors = colors,
            })
        end,
    }
    Labels[Idx] = obj
    return obj
end

function Funcs:AddButton(Idx, Info)
    if typeof(Idx) == "table" then
        Info = Idx
        Idx = Info.Idx or ("Button_" .. tostring(#Buttons + 1))
    end
    Info = Library:Validate(Info, {
        Text = "Button",
        Callback = function() end,
        Gradient = false,
    })

    local card = Library:CreateOuter(self.Container, 48)
    local btn = New("TextButton", {
        Size = UDim2.new(1, -12, 1, -10),
        Position = UDim2.fromOffset(6, 5),
        AutoButtonColor = false,
        Text = Info.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        ThemeTag = {
            BackgroundColor3 = "TabIdleColor",
            TextColor3 = "FontColor",
        },
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 9), Parent = btn })
    local st = New("UIStroke", {
        Thickness = 1,
        Transparency = 0.3,
        ThemeTag = { Color = "OutlineColor" },
        Parent = btn,
    })

    if Info.Gradient then
        Library:SetLabelGradient(btn, Info)
    end

    Library:GiveSignal(btn.MouseEnter:Connect(function()
        Tween(btn, nil, { BackgroundColor3 = Library.Scheme.ButtonHoverColor or Library.Scheme.CardHoverColor })
    end))
    Library:GiveSignal(btn.MouseLeave:Connect(function()
        Tween(btn, nil, { BackgroundColor3 = Library.Scheme.TabIdleColor })
    end))
    Library:GiveSignal(btn.MouseButton1Click:Connect(function()
        Tween(st, nil, { Color = Library.Scheme.AccentColor, Transparency = 0.05 })
        task.delay(0.16, function()
            if st and st.Parent then
                Tween(st, nil, { Color = Library.Scheme.OutlineColor, Transparency = 0.3 })
            end
        end)
        Library:SafeCallback(Info.Callback)
    end))

    local obj = {
        Type = "Button",
        SetText = function(_, text)
            btn.Text = tostring(text)
        end,
    }
    Buttons[Idx] = obj
    return obj
end

function Funcs:AddToggle(Idx, Info)
    Info = Library:Validate(Info, {
        Text = "Toggle",
        Default = false,
        Callback = function() end,
        Risky = false,
    })

    local card = Library:CreateOuter(self.Container, 52)
    local label = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -98, 1, 0),
        Font = Library.Scheme.Font,
        Text = Info.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = card,
    })

    local pill = New("Frame", {
        Size = UDim2.fromOffset(62, 28),
        Position = UDim2.new(1, -74, 0.5, -14),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "MuteColor" },
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = pill })
    local pillStroke = New("UIStroke", {
        Thickness = 1,
        Transparency = 0.4,
        ThemeTag = { Color = "OutlineColor" },
        Parent = pill,
    })
    local knob = New("Frame", {
        Size = UDim2.fromOffset(22, 22),
        Position = UDim2.fromOffset(3, 3),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "KnobOffColor" },
        Parent = pill,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })

    local click = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = card,
    })

    local enabled = Info.Default and true or false
    local tSmooth = TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tFast = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function SetVisual(on, instant)
        local ti = instant and TweenInfo.new(0) or tSmooth
        local tiLabel = instant and TweenInfo.new(0) or tFast
        Tween(card, ti, {
            BackgroundColor3 = on and Library.Scheme.ToggleOnCard or Library.Scheme.CardColor,
        })
        Tween(pill, ti, {
            BackgroundColor3 = on and Library.Scheme.ToggleOnPill or Library.Scheme.MuteColor,
        })
        Tween(pillStroke, ti, {
            Color = on and Library.Scheme.AccentColor or Library.Scheme.OutlineColor,
            Transparency = on and 0.12 or 0.4,
        })
        Tween(knob, ti, {
            Position = on and UDim2.fromOffset(37, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = on and Library.Scheme.AccentColor or Library.Scheme.KnobOffColor,
        })
        Tween(label, tiLabel, {
            TextColor3 = on and Library.Scheme.ToggleOnText or Library.Scheme.FontColor,
        })
    end

    local obj
    local function SetValue(v, fire)
        enabled = v and true or false
        SetVisual(enabled)
        if obj then
            obj.Value = enabled
        end
        if fire ~= false then
            Library:SafeCallback(Info.Callback, enabled)
        end
    end

    ApplyHover(card, function()
        return enabled
    end)
    Library:GiveSignal(click.MouseButton1Click:Connect(function()
        SetValue(not enabled, true)
    end))

    obj = {
        Type = "Toggle",
        Value = enabled,
        Get = function()
            return enabled
        end,
        SetValue = function(_, v)
            SetValue(v, true)
        end,
        Refresh = function()
            SetVisual(enabled, true)
        end,
    }
    Toggles[Idx] = obj
    SetValue(enabled, false)
    return obj
end

function Funcs:AddSlider(Idx, Info)
    Info = Library:Validate(Info, {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 1,
        Callback = function() end,
        Suffix = "",
    })

    local card = Library:CreateOuter(self.Container, 86)
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 8),
        Size = UDim2.new(1, -90, 0, 32),
        Font = Library.Scheme.Font,
        Text = Info.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = card,
    })
    local valueLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0, 8),
        Size = UDim2.fromOffset(66, 20),
        Font = Enum.Font.GothamBold,
        Text = "",
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        ThemeTag = { TextColor3 = "AccentColor" },
        Parent = card,
    })
    local bar = New("Frame", {
        Position = UDim2.fromOffset(14, 56),
        Size = UDim2.new(1, -28, 0, 10),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "TrackColor" },
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })
    local fill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "FillColor" },
        Parent = bar,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    local knob = New("Frame", {
        Size = UDim2.fromOffset(14, 14),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "SliderKnobColor" },
        Parent = bar,
    })
    New("UICorner", { CornerRadius = UDim.new(1, 0), Parent = knob })
    local dragArea = New("TextButton", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = bar,
    })

    local value = Info.Default
    local dragging = false
    local dragInput = nil
    local range = Info.Max - Info.Min

    local function Format(v)
        if Info.Rounding <= 0 then
            return tostring(math.floor(v + 0.5)) .. Info.Suffix
        end
        local mult = 10 ^ Info.Rounding
        return string.format("%." .. tostring(Info.Rounding) .. "f", math.floor(v * mult + 0.5) / mult) .. Info.Suffix
    end

    local function SetFromAlpha(alpha, fire)
        alpha = math.clamp(alpha, 0, 1)
        local n = Info.Min + range * alpha
        if Info.Rounding <= 0 then
            n = math.floor(n + 0.5)
        else
            local mult = 10 ^ Info.Rounding
            n = math.floor(n * mult + 0.5) / mult
        end
        value = n
        valueLabel.Text = Format(value)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        if fire ~= false then
            Library:SafeCallback(Info.Callback, value)
        end
    end

    SetFromAlpha((value - Info.Min) / math.max(range, 1e-6), false)

    Library:GiveSignal(dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            local w = bar.AbsoluteSize.X
            if w > 0 then
                SetFromAlpha((input.Position.X - bar.AbsolutePosition.X) / w, true)
            end
        end
    end))
    Library:GiveSignal(dragArea.InputEnded:Connect(function(input)
        if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            dragInput = nil
        end
    end))
    Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end
        if input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local w = bar.AbsoluteSize.X
            if w > 0 then
                SetFromAlpha((input.Position.X - bar.AbsolutePosition.X) / w, true)
            end
        end
    end))

    local obj = {
        Type = "Slider",
        Value = value,
        Get = function()
            return value
        end,
        SetValue = function(_, v)
            local n = tonumber(v)
            if not n then
                return
            end
            SetFromAlpha((n - Info.Min) / math.max(range, 1e-6), true)
            obj.Value = value
        end,
    }
    Options[Idx] = obj
    return obj
end

function Funcs:AddDropdown(Idx, Info)
    Info = Library:Validate(Info, {
        Text = "Dropdown",
        Values = { "One", "Two" },
        Default = 1,
        Callback = function() end,
    })

    local values = Info.Values
    local selected
    if typeof(Info.Default) == "number" then
        selected = values[Info.Default] or values[1]
    else
        selected = tostring(Info.Default or values[1])
    end

    local card = Library:CreateOuter(self.Container, 48)
    card.ClipsDescendants = true
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(0.55, 0, 0, 48),
        Font = Library.Scheme.Font,
        Text = Info.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = card,
    })
    local selectedLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -130, 0, 0),
        Size = UDim2.fromOffset(95, 48),
        Font = Enum.Font.Gotham,
        Text = selected,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        ThemeTag = { TextColor3 = "SubTextColor" },
        Parent = card,
    })
    local arrow = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.fromOffset(20, 48),
        Font = Enum.Font.GothamBold,
        Text = "v",
        TextSize = 12,
        ThemeTag = { TextColor3 = "AccentColor" },
        Parent = card,
    })
    local toggleBtn = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = card,
    })
    local list = New("Frame", {
        Position = UDim2.fromOffset(10, 48),
        Size = UDim2.new(1, -20, 0, #values * 30),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = card,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = list,
    })

    local open = false
    local expandedHeight = 48 + (#values * 30) + 8

    local function SetSelected(v, fire)
        selected = tostring(v)
        selectedLabel.Text = selected
        if fire ~= false then
            Library:SafeCallback(Info.Callback, selected)
        end
    end

    for _, opt in ipairs(values) do
        local optBtn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            Text = opt,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            AutoButtonColor = false,
            ThemeTag = {
                BackgroundColor3 = "MuteColor",
                TextColor3 = "FontColor",
            },
            Parent = list,
        })
        New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = optBtn })
        Library:GiveSignal(optBtn.MouseEnter:Connect(function()
            Tween(optBtn, nil, { BackgroundColor3 = Library.Scheme.CardHoverColor })
        end))
        Library:GiveSignal(optBtn.MouseLeave:Connect(function()
            Tween(optBtn, nil, { BackgroundColor3 = Library.Scheme.MuteColor })
        end))
        Library:GiveSignal(optBtn.MouseButton1Click:Connect(function()
            SetSelected(opt, true)
            open = false
            list.Visible = false
            arrow.Text = "v"
            Tween(card, nil, { Size = UDim2.new(1, -2, 0, 48) })
        end))
    end

    Library:GiveSignal(toggleBtn.MouseButton1Click:Connect(function()
        open = not open
        list.Visible = open
        arrow.Text = open and "^" or "v"
        Tween(card, nil, { Size = UDim2.new(1, -2, 0, open and expandedHeight or 48) })
    end))

    local obj = {
        Type = "Dropdown",
        Value = selected,
        Get = function()
            return selected
        end,
        SetValue = function(_, v)
            SetSelected(v, true)
            obj.Value = selected
        end,
        SetValues = function(_, newValues)
            
            values = newValues or values
        end,
    }
    Options[Idx] = obj
    return obj
end

function Funcs:AddKeyPicker(Idx, Info)
    Info = Library:Validate(Info, {
        Text = "Keybind",
        Default = Enum.KeyCode.E,
        Callback = function() end,
        Mode = "Toggle", 
    })

    local current = Info.Default
    if typeof(current) == "string" then
        current = Enum.KeyCode[current] or Enum.KeyCode.E
    end

    local card = Library:CreateOuter(self.Container, 48)
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Library.Scheme.Font,
        Text = Info.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = card,
    })
    local keyBtn = New("TextButton", {
        Size = UDim2.fromOffset(96, 30),
        Position = UDim2.new(1, -110, 0.5, -15),
        AutoButtonColor = false,
        Text = current.Name,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ThemeTag = {
            BackgroundColor3 = "TabIdleColor",
            TextColor3 = "AccentColor",
        },
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 8), Parent = keyBtn })

    local capturing = false
    local function apply(key, fire)
        if not key then
            return
        end
        current = key
        keyBtn.Text = key.Name
        capturing = false
        if fire ~= false then
            Library:SafeCallback(Info.Callback, key)
        end
    end

    Library:GiveSignal(keyBtn.MouseButton1Click:Connect(function()
        capturing = true
        keyBtn.Text = "..."
    end))
    Library:GiveSignal(UserInputService.InputBegan:Connect(function(input)
        if not capturing then
            return
        end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                capturing = false
                keyBtn.Text = current.Name
                return
            end
            apply(input.KeyCode, true)
        end
    end))

    local obj = {
        Type = "KeyPicker",
        Value = current,
        Get = function()
            return current
        end,
        SetValue = function(_, key)
            if typeof(key) == "string" then
                key = Enum.KeyCode[key]
            end
            apply(key, true)
            obj.Value = current
        end,
    }
    Options[Idx] = obj
    return obj
end

function Funcs:AddDivider()
    local holder = New("Frame", {
        Size = UDim2.new(1, -2, 0, 12),
        BackgroundTransparency = 1,
        Parent = self.Container,
    })
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, -8, 0, 1),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "OutlineColor" },
        Parent = holder,
    })
end

function Funcs:AddSection(Idx, Info)
    if typeof(Idx) == "table" then
        Info = Idx
        Idx = Info.Idx or Info.Text or Info.Title or Info.Name or ("Section_" .. tostring(os.clock()))
    elseif typeof(Idx) == "string" and Info == nil then
        Info = { Text = Idx }
    elseif typeof(Idx) == "string" and typeof(Info) == "table" then
        Info.Text = Info.Text or Info.Title or Info.Name or Idx
    end
    Info = Library:Validate(Info or {}, {
        Text = "Section",
        Title = nil,
        Name = nil,
    })

    local titleText = tostring(Info.Text or Info.Title or Info.Name or "Section")
    local title = New("TextLabel", {
        Name = "Section",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -2, 0, 20),
        Font = Enum.Font.GothamSemibold,
        Text = titleText,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ThemeTag = { TextColor3 = "SubTextColor" },
        Parent = self.Container,
    })

    local obj = {
        Type = "Section",
        Text = titleText,
        Frame = title,
        SetText = function(_, text)
            title.Text = tostring(text)
            obj.Text = title.Text
        end,
    }
    return obj
end

function Funcs:Section(Config)
    Config = typeof(Config) == "table" and Config or { Title = tostring(Config) }
    return Funcs.AddSection(self, {
        Text = Config.Title or Config.Text or Config.Name or "Section",
        Idx = Config.Idx,
    })
end

function Funcs:AddColorPicker(Idx, Info)
    Info = Library:Validate(Info, {
        Text = "Color",
        Default = Color3.new(1, 1, 1),
        Callback = function() end,
    })
    local color = typeof(Info.Default) == "Color3" and Info.Default or HexToColor(Info.Default) or Color3.new(1, 1, 1)

    local card = Library:CreateOuter(self.Container, 48)
    New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -160, 1, 0),
        Font = Library.Scheme.Font,
        Text = Info.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = card,
    })
    local swatch = New("Frame", {
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.new(1, -140, 0.5, -14),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = swatch })
    New("UIStroke", {
        Thickness = 1,
        Transparency = 0.3,
        ThemeTag = { Color = "OutlineColor" },
        Parent = swatch,
    })
    local hexBox = New("TextBox", {
        Size = UDim2.fromOffset(90, 28),
        Position = UDim2.new(1, -104, 0.5, -14),
        Text = ColorToHex(color),
        PlaceholderText = "hex",
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        TextSize = 12,
        ThemeTag = {
            BackgroundColor3 = "MuteColor",
            TextColor3 = "FontColor",
        },
        Parent = card,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = hexBox })

    local function SetColor(c, fire)
        color = c
        swatch.BackgroundColor3 = c
        hexBox.Text = ColorToHex(c)
        if fire ~= false then
            Library:SafeCallback(Info.Callback, c)
        end
    end

    Library:GiveSignal(hexBox.FocusLost:Connect(function()
        local c = HexToColor(hexBox.Text)
        if c then
            SetColor(c, true)
        else
            hexBox.Text = ColorToHex(color)
        end
    end))

    local obj = {
        Type = "ColorPicker",
        Value = color,
        Get = function()
            return color
        end,
        SetValue = function(_, c)
            if typeof(c) == "string" then
                c = HexToColor(c)
            end
            if typeof(c) == "Color3" then
                SetColor(c, true)
                obj.Value = color
            end
        end,
    }
    Options[Idx] = obj
    return obj
end

local function GetViewportSize()
    local cam = Workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

function Library:SetDPIScale(DPIScale)
    local pct = tonumber(DPIScale) or 100
    Library.DPIScale = math.clamp(pct / 100, 0.5, 1.5)
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale
    if Library.UpdateDeviceScale then
        Library.UpdateDeviceScale()
    elseif Library.Scales then
        local base = Library.IsMobile and 0.85 or 1
        for _, scaleObj in ipairs(Library.Scales) do
            if scaleObj and scaleObj.Parent then
                scaleObj.Scale = math.clamp(base * Library.DPIScale, 0.5, 1.5)
            end
        end
    end
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, {
        Title = "Danny Couch Competitive",
        Footer = "learn how to use it properly",
        Size = UDim2.fromScale(0.7, 0.7),
        Gradient = false,
        FooterGradient = false,
        GradientColors = nil,
        GradientSpeed = nil,
        Center = true,
        ToggleUIKeybind = Enum.KeyCode.RightShift,
        Theme = "Default",
    })

    if Library.IsMobile then
        local size = WindowInfo.Size
        if size.X.Scale == 0.7 and size.Y.Scale == 0.7 and size.X.Offset == 0 and size.Y.Offset == 0 then
            WindowInfo.Size = UDim2.fromScale(0.94, 0.86)
        end
    end

    if Library.ScreenGui then
        pcall(function()
            Library.ScreenGui:Destroy()
        end)
    end

    local parent = gethui()
    local gui = New("ScreenGui", {
        Name = "DannyUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 200,
        Parent = parent,
    })
    pcall(protectgui, gui)
    Library.ScreenGui = gui

    if WindowInfo.Theme and Themes[WindowInfo.Theme] then
        Library.ThemeManager:ApplyTheme(WindowInfo.Theme)
    end

    if typeof(WindowInfo.ToggleUIKeybind) == "EnumItem" then
        Library.ToggleKey = WindowInfo.ToggleUIKeybind
    end

    local HeaderHeight = Library.Scheme.HeaderHeight or 58
    if Library.IsMobile then
        HeaderHeight = math.min(HeaderHeight, 52)
    end
    local TabWidth = Library.Scheme.TabBarWidth or 130
    if Library.IsMobile then
        TabWidth = math.min(TabWidth, 100)
    end

    local overlay = New("Frame", {
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "BackgroundColor" },
        BackgroundTransparency = 1,
        Parent = gui,
    })

    local panel = New("Frame", {
        Name = "Panel",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5 - 0.35, 0),
        Size = WindowInfo.Size,
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "MainColor" },
        Parent = overlay,
    })
    New("UICorner", { CornerRadius = UDim.new(0, Library.Scheme.CornerRadius or 16), Parent = panel })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Thickness = 1.4,
        Transparency = 0.15,
        ThemeTag = { Color = "OutlineColor" },
        Parent = panel,
    })
    local PanelGrad = New("UIGradient", {
        Rotation = 125,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Scheme.PanelGradMid),
            ColorSequenceKeypoint.new(0.45, Library.Scheme.MainColor),
            ColorSequenceKeypoint.new(1, Library.Scheme.PanelGradEnd),
        }),
        Parent = panel,
    })
    local PanelScale = New("UIScale", { Scale = 1, Parent = panel })
    Library.Scales = { PanelScale }

    New("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 32, 1, 32),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageTransparency = 0.9,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        ZIndex = 0,
        ThemeTag = { ImageColor3 = "GlowColor" },
        Parent = panel,
    })

    local header = New("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HeaderHeight),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = panel,
    })

    local TitleLabel = New("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 8),
        Size = UDim2.new(1, -180, 0, 24),
        Font = Enum.Font.GothamBold,
        Text = WindowInfo.Title,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "FontColor" },
        Parent = header,
    })
    New("UIStroke", {
        Thickness = 1,
        Transparency = 0.35,
        ThemeTag = { Color = "TitleStrokeColor" },
        Parent = TitleLabel,
    })

    local subTitleLabel = New("TextLabel", {
        Name = "Subtitle",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 31),
        Size = UDim2.new(1, -180, 0, 18),
        Font = Enum.Font.Gotham,
        Text = WindowInfo.Footer,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = { TextColor3 = "SubTextColor" },
        Parent = header,
    })

    local function MakeTopButton(text, xOffset, colorKey)
        local b = New("TextButton", {
            Size = UDim2.fromOffset(32, 32),
            Position = UDim2.new(1, xOffset, 0, 12),
            AutoButtonColor = false,
            Text = text,
            Font = Enum.Font.GothamBold,
            TextSize = 16,
            ThemeTag = {
                BackgroundColor3 = "TopButtonColor",
                TextColor3 = colorKey,
            },
            Parent = header,
        })
        New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = b })
        New("UIStroke", {
            Thickness = 1,
            Transparency = 0.35,
            ThemeTag = { Color = "OutlineColor" },
            Parent = b,
        })
        return b
    end

    local MinBtn = MakeTopButton("—", -76, "AccentColor")
    local CloseBtn = MakeTopButton("×", -38, "DangerColor")

    local body = New("Frame", {
        Name = "Body",
        Position = UDim2.fromOffset(12, HeaderHeight),
        Size = UDim2.new(1, -24, 1, -(HeaderHeight + 12)),
        BackgroundTransparency = 1,
        Parent = panel,
    })

    local TabBar = New("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, TabWidth, 1, 0),
        BorderSizePixel = 0,
        ThemeTag = { BackgroundColor3 = "TabIdleColor" },
        Parent = body,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = TabBar })
    local TabBarGrad = New("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Scheme.TabIdleColor),
            ColorSequenceKeypoint.new(0.45, Library.Scheme.TabActiveColor),
            ColorSequenceKeypoint.new(1, Library.Scheme.AccentColor),
        }),
        Parent = TabBar,
    })
    Library.Chrome = {
        PanelGrad = PanelGrad,
        TabBarGrad = TabBarGrad,
    }
    New("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        Parent = TabBar,
    })

    local TabScroll = New("ScrollingFrame", {
        Name = "TabBarScroll",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = Library.Scheme.AccentColor,
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ClipsDescendants = true,
        Parent = TabBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Parent = TabScroll,
    })

    local ContentHolder = New("Frame", {
        Name = "ContentHolder",
        Position = UDim2.fromOffset(TabWidth + 8, 0),
        Size = UDim2.new(1, -(TabWidth + 8), 1, 0),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = body,
    })
    local ContentGlow = New("Frame", {
        Name = "ContentGlow",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0.86,
        BorderSizePixel = 0,
        ZIndex = 0,
        ThemeTag = { BackgroundColor3 = "MainColor" },
        Parent = ContentHolder,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = ContentGlow })
    local ContentGlowGrad = New("UIGradient", {
        Rotation = 25,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Library.Scheme.TabActiveColor),
            ColorSequenceKeypoint.new(1, Library.Scheme.MainColor),
        }),
        Parent = ContentGlow,
    })
    Library.Chrome.ContentGlowGrad = ContentGlowGrad

    local WidthFrac = Library.IsMobile and 0.94 or 0.7
    local HeightFrac = Library.IsMobile and 0.86 or 0.7
    local BaseScale = Library.IsMobile and 0.85 or 1
    local ScaleMin = Library.IsMobile and 0.55 or 0.66
    local ScaleMax = Library.IsMobile and 1.25 or 1.5
    local SizeUsesViewport = true
    local ViewportConn = nil

    local Window = {
        Panel = panel,
        TitleLabel = TitleLabel,
        SubTitleLabel = subTitleLabel,
        Tabs = {},
        Visible = true,
        Minimized = false,
        ExpandedSize = panel.Size,
        maxSize = Vector2.new(1280, 720),
        minSize = Library.MinSize,
    }

    if WindowInfo.Center then
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
    end

    local function ClampToViewport()
        if not panel.Parent or Window.Minimized then
            return
        end
        local vp = GetViewportSize()
        local absSize = panel.AbsoluteSize
        local absPos = panel.AbsolutePosition
        local maxX = math.max(8, vp.X - absSize.X - 8)
        local maxY = math.max(8, vp.Y - absSize.Y - 8)
        local x = math.clamp(absPos.X, 8, maxX)
        local y = math.clamp(absPos.Y, 8, maxY)
        if math.abs(x - absPos.X) > 0.5 or math.abs(y - absPos.Y) > 0.5 then
            panel.Position = UDim2.fromOffset(x + absSize.X * panel.AnchorPoint.X, y + absSize.Y * panel.AnchorPoint.Y)
        end
    end

    local function UpdateBounds()
        local vp = GetViewportSize()
        local maxW, maxH = vp.X * WidthFrac, vp.Y * HeightFrac
        Window.maxSize = Vector2.new(maxW, maxH)
        if Library.IsMobile then
            Window.minSize = Vector2.new(
                math.clamp(maxW * 0.72, 260, maxW),
                math.clamp(maxH * 0.55, 200, maxH)
            )
        else
            Window.minSize = Vector2.new(
                math.clamp(maxW * 0.50, 280, maxW),
                math.clamp(maxH * 0.46, 220, maxH)
            )
        end
        Library.MinSize = Window.minSize
    end

    local function UpdateDeviceScale()
        if not panel.Parent then
            return
        end
        PanelScale.Scale = math.clamp(BaseScale * Library.DPIScale, ScaleMin, ScaleMax)
        UpdateBounds()

        if SizeUsesViewport and not Window.Minimized then
            local size = panel.Size
            if size.X.Scale > 0 or size.Y.Scale > 0 then
                panel.Size = UDim2.fromScale(
                    size.X.Scale > 0 and math.min(size.X.Scale, WidthFrac) or size.X.Scale,
                    size.Y.Scale > 0 and math.min(size.Y.Scale, HeightFrac) or size.Y.Scale
                )
            end
        end
        task.defer(ClampToViewport)
    end
    Library.UpdateDeviceScale = UpdateDeviceScale

    local function BindViewport()
        if ViewportConn then
            ViewportConn:Disconnect()
            ViewportConn = nil
        end
        local cam = Workspace.CurrentCamera
        if cam then
            ViewportConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(UpdateDeviceScale)
            Library:GiveSignal(ViewportConn)
        end
        UpdateDeviceScale()
    end
    BindViewport()
    Library:GiveSignal(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(BindViewport))

    do
        local dragging, dragInput, dragStart, startPos
        Library:GiveSignal(header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragInput = input
                dragStart = input.Position
                startPos = panel.Position
            end
        end))
        Library:GiveSignal(header.InputEnded:Connect(function(input)
            if input == dragInput then
                dragging = false
                dragInput = nil
                ClampToViewport()
            end
        end))
        Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
            if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end))
        Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
            if input == dragInput then
                dragging = false
                dragInput = nil
                ClampToViewport()
            end
        end))
    end

    function Window:SetVisible(on)
        Window.Visible = on and true or false
        panel.Visible = Window.Visible
    end

    function Window:Toggle()
        Window:SetVisible(not Window.Visible)
    end

    function Window:SetTitle(text, gradientInfo)
        TitleLabel.Text = tostring(text)
        if gradientInfo then
            Library:SetLabelGradient(TitleLabel, gradientInfo)
        end
    end

    function Window:AddTab(Name, Icon)
        local page = New("ScrollingFrame", {
            Name = "Page_" .. tostring(Name),
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Scheme.AccentColor,
            CanvasSize = UDim2.fromOffset(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            Visible = false,
            ZIndex = 1,
            Parent = ContentHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 6),
            Parent = page,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = page,
        })

        local tabBtn = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 38),
            AutoButtonColor = false,
            Text = tostring(Name),
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            TextColor3 = Library.Scheme.FontColor,
            ThemeTag = {
                BackgroundColor3 = "TabIdleColor",
            },
            Parent = TabScroll,
        })
        New("UICorner", { CornerRadius = UDim.new(0, 10), Parent = tabBtn })
        New("UIStroke", {
            Thickness = 1,
            Transparency = 0.35,
            ThemeTag = { Color = "OutlineColor" },
            Parent = tabBtn,
        })

        local Tab = {
            Name = Name,
            Icon = Icon,
            Container = page,
            Button = tabBtn,
        }
        for k, fn in pairs(Funcs) do
            Tab[k] = function(self, ...)
                return fn(self, ...)
            end
        end

        local function Select()
            Library.ActiveTab = Tab
            for _, t in ipairs(Window.Tabs) do
                local active = t == Tab
                t.Container.Visible = active
                local bg = active and Library.Scheme.TabActiveColor or Library.Scheme.TabIdleColor
                local textColor = active and GetContrastColor(bg) or Library.Scheme.FontColor
                Tween(t.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = bg,
                    TextColor3 = textColor,
                })
                local stroke = t.Button:FindFirstChildOfClass("UIStroke")
                if stroke then
                    Tween(stroke, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Color = active and Library.Scheme.AccentColor or Library.Scheme.OutlineColor,
                        Transparency = active and 0.1 or 0.35,
                    })
                end
            end
        end

        Library:GiveSignal(tabBtn.MouseButton1Click:Connect(Select))
        Tab.Select = Select
        Window.Tabs[#Window.Tabs + 1] = Tab
        Library.Tabs[#Library.Tabs + 1] = Tab

        if #Window.Tabs == 1 then
            Select()
        end
        return Tab
    end

    local ResizePad = Library.IsMobile and 44 or 36
    local ResizeHandle = New("TextButton", {
        Name = "ResizeHandle",
        Size = UDim2.fromOffset(ResizePad, ResizePad),
        Position = UDim2.new(1, -(ResizePad + 2), 1, -(ResizePad + 2)),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 100,
        Active = true,
        Parent = panel,
    })

    for i = 0, 2 do
        New("Frame", {
            Size = UDim2.fromOffset(2, 10 + i * 3),
            Position = UDim2.new(1, -(8 + i * 6), 1, -6 - (10 + i * 3)),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = 45,
            BorderSizePixel = 0,
            Active = false,
            ZIndex = 101,
            ThemeTag = { BackgroundColor3 = "AccentColor" },
            Parent = ResizeHandle,
        })
    end

    local function ToUnscaled(absW, absH)
        local scale = PanelScale.Scale
        if not scale or scale <= 0 then
            scale = 1
        end
        return absW / scale, absH / scale
    end

    do
        local resizing = false
        local ResizeInput = nil
        local StartMouse, StartSize
        local ResizeConn = nil

        local function StopResize()
            if ResizeConn then
                ResizeConn:Disconnect()
                ResizeConn = nil
            end
        end

        local function GetResizePointer()
            if ResizeInput and ResizeInput.UserInputType == Enum.UserInputType.Touch then
                return ResizeInput.Position
            end
            return UserInputService:GetMouseLocation()
        end

        local function ApplyResize()
            if not resizing or not panel.Parent then
                return
            end
            UpdateBounds()
            local pos = GetResizePointer()
            local delta = pos - StartMouse
            local targetAbsX = math.clamp(StartSize.X + delta.X, Window.minSize.X, Window.maxSize.X)
            local targetAbsY = math.clamp(StartSize.Y + delta.Y, Window.minSize.Y, Window.maxSize.Y)
            local baseW, baseH = ToUnscaled(targetAbsX, targetAbsY)
            panel.Size = UDim2.fromOffset(baseW, baseH)
            Window.ExpandedSize = panel.Size
            SizeUsesViewport = false
        end

        Library:GiveSignal(ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if Window.Minimized then
                return
            end
            StopResize()
            resizing = true
            ResizeInput = input
            StartMouse = (input.UserInputType == Enum.UserInputType.Touch) and input.Position or UserInputService:GetMouseLocation()
            StartSize = panel.AbsoluteSize
            SizeUsesViewport = false
            ApplyResize()
            ResizeConn = RunService.RenderStepped:Connect(ApplyResize)
        end))
        Library:GiveSignal(ResizeHandle.InputEnded:Connect(function(input)
            if input == ResizeInput then
                resizing = false
                ResizeInput = nil
                StopResize()
                ClampToViewport()
            end
        end))
        Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
            if input == ResizeInput then
                resizing = false
                ResizeInput = nil
                StopResize()
                ClampToViewport()
            end
        end))
    end

    Library:GiveSignal(MinBtn.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Window.ExpandedSize = panel.Size
            Tween(panel, nil, { Size = UDim2.new(panel.Size.X.Scale, panel.Size.X.Offset, 0, HeaderHeight) })
            body.Visible = false
            ResizeHandle.Visible = false
        else
            body.Visible = true
            ResizeHandle.Visible = true
            Tween(panel, nil, { Size = Window.ExpandedSize or UDim2.fromScale(0.7, 0.7) })
        end
    end))
    Library:GiveSignal(CloseBtn.MouseButton1Click:Connect(function()
        Window:SetVisible(false)
    end))

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(input, gp)
        if gp then
            return
        end
        if input.KeyCode == Library.ToggleKey then
            Window:Toggle()
        end
    end))

    Library:GiveSignal(RunService.Heartbeat:Connect(function()
        if Library.Unloaded then
            return
        end
        local tNow = tick()
        if TabBarGrad and TabBarGrad.Parent then
            TabBarGrad.Offset = Vector2.new(0, math.sin(tNow * 0.7) * 0.15)
        end
        if ContentGlowGrad and ContentGlowGrad.Parent then
            ContentGlowGrad.Offset = Vector2.new(math.sin(tNow * 0.55) * 0.2, 0)
        end
    end))

    Library.Window = Window
    return Window
end

local ThemeManager = {
    Library = Library,
    Folder = "DannyUI/themes",
    AppliedToTab = false,
    Themes = Themes,
}

function ThemeManager:SetLibrary(lib)
    ThemeManager.Library = lib
end

function ThemeManager:SetFolder(folder)
    ThemeManager.Folder = folder or ThemeManager.Folder
end

local function GetCurrentTheme()
    local data = {}
    for _, key in ipairs(SchemeOrder) do
        local c = Library.Scheme[key]
        if typeof(c) == "Color3" then
            data[key] = ColorToHex(c)
        end
    end
    local grads = {}
    for _, c in ipairs(Library.Scheme.GradientColors or {}) do
        grads[#grads + 1] = ColorToHex(c)
    end
    data.GradientColors = grads
    return data
end

function ThemeManager:ApplyThemeData(themeData)
    if typeof(themeData) ~= "table" then
        return false, "Invalid theme data"
    end
    for index, value in pairs(themeData) do
        if index == "GradientColors" and typeof(value) == "table" then
            Library.Scheme.GradientColors = GetGradientColors(value)
        elseif index == "FooterGradientColors" and typeof(value) == "table" then
            Library.Scheme.FooterGradientColors = GetGradientColors(value)
        else
            local c = HexToColor(value)
            if c and (BaseScheme[index] ~= nil or table.find(SchemeOrder, index)) then
                Library.Scheme[index] = c
                local option = Options[index]
                if option and option.SetValue then
                    option:SetValue(c)
                end
            end
        end
    end
    Library:UpdateColorsUsingRegistry()
    return true
end

function ThemeManager:ApplyTheme(themeName)
    local pack = Themes[themeName]
    if not pack then
        return false, "Theme not found"
    end
    return ThemeManager:ApplyThemeData(pack[2])
end

function ThemeManager:GetThemeList()
    local names = {}
    for name in pairs(Themes) do
        names[#names + 1] = name
    end
    table.sort(names, function(a, b)
        return (Themes[a][1] or 99) < (Themes[b][1] or 99)
    end)
    return names
end

function ThemeManager:ApplyToTab(tab)
    if not tab or ThemeManager.AppliedToTab then
        return
    end
    ThemeManager.AppliedToTab = true

    tab:AddSection("Theme Manager")

    tab:AddDropdown("ThemePreset", {
        Text = "Built-in Theme",
        Values = ThemeManager:GetThemeList(),
        Default = 1,
        Callback = function(name)
            ThemeManager:ApplyTheme(name)
        end,
    })

    for _, schemeIndex in ipairs(SchemeOrder) do
        local pretty = schemeIndex:gsub("Color", " color"):gsub("(%u)", " %1"):gsub("^%s", "")
        tab:AddColorPicker(schemeIndex, {
            Text = pretty,
            Default = Library.Scheme[schemeIndex],
            Callback = function(c)
                Library.Scheme[schemeIndex] = c
                Library:UpdateColorsUsingRegistry()
            end,
        })
    end

    tab:AddSection("Gradient Colors")

    local gradCard = Library:CreateOuter(tab.Container, 48)
    local gradBox = New("TextBox", {
        Size = UDim2.new(1, -20, 0, 28),
        Position = UDim2.fromOffset(10, 10),
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ThemeTag = {
            BackgroundColor3 = "MuteColor",
            TextColor3 = "FontColor",
        },
        Parent = gradCard,
    })
    New("UICorner", { CornerRadius = UDim.new(0, 6), Parent = gradBox })
    do
        local parts = {}
        for _, c in ipairs(Library.Scheme.GradientColors) do
            parts[#parts + 1] = ColorToHex(c)
        end
        gradBox.Text = table.concat(parts, ",")
    end
    Library:GiveSignal(gradBox.FocusLost:Connect(function()
        local parts = string.split(gradBox.Text, ",")
        local cols = {}
        for _, p in ipairs(parts) do
            local c = HexToColor((p:gsub("%s+", "")))
            if c then
                cols[#cols + 1] = c
            end
        end
        if #cols >= 2 then
            Library.Scheme.GradientColors = cols
            Library:UpdateColorsUsingRegistry()
        end
    end))

    tab:AddButton("SaveThemeJSON", {
        Text = "Copy Theme JSON",
        Callback = function()
            local data = GetCurrentTheme()
            local encoded = HttpService:JSONEncode(data)
            if setclipboard then
                pcall(setclipboard, encoded)
            end
        end,
    })
end

Library.ThemeManager = ThemeManager

Library:GiveSignal(RunService.Heartbeat:Connect(function()
    if Library.Unloaded then
        return
    end
    local t = tick()
    for i = #Library.Gradients, 1, -1 do
        local Grad = Library.Gradients[i]
        if not Grad.Gradient or not Grad.Gradient.Parent then
            table.remove(Library.Gradients, i)
        elseif Grad.Enabled then
            local Speed = Grad.Speed or 0.45
            local Phase = Grad.Phase or 0
            if Grad.Mode == "Pendulum" then
                Grad.Gradient.Offset = Vector2.new(math.sin(t * Speed + Phase) * 0.32, 0)
            elseif Grad.TileRepeat then
                Grad.Gradient.Offset = Vector2.new(-((t * Speed) + Phase) % 1, 0)
            else
                Grad.Gradient.Offset = Vector2.zero
                Grad.Gradient.Color = OffsetColorSequence(Grad.Colors or Library.Scheme.GradientColors, (t * Speed) + Phase)
            end
        end
    end
end))

function Library:Unload()
    Library.Unloaded = true
    if Library.Signals then
        for _, c in ipairs(Library.Signals) do
            pcall(function()
                c:Disconnect()
            end)
        end
    end
    if Library.ScreenGui then
        pcall(function()
            Library.ScreenGui:Destroy()
        end)
    end
end

ThemeManager:ApplyTheme("Default")

return Library
