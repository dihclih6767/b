local CloneRef = cloneref or clonereference or function(Inst)
    return Inst
end

local CoreGui = CloneRef(game:GetService("CoreGui"))
local Players = CloneRef(game:GetService("Players"))
local RunService = CloneRef(game:GetService("RunService"))
local UserInputService = CloneRef(game:GetService("UserInputService"))
local TextService = CloneRef(game:GetService("TextService"))
local TweenService = CloneRef(game:GetService("TweenService"))
local HttpService = CloneRef(game:GetService("HttpService"))

local GetHui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Toggles = {}
local Options = {}

local Library = {
    LocalPlayer = LocalPlayer,
    ScreenGui = nil,
    Window = nil,
    Toggles = Toggles,
    Options = Options,
    Tips = {},
    Tabs = {},
    KeyTab = {},
    Registry = {},
    AccentHooks = {},
    OutlineStrokes = {},
    PrimaryRegs = {},
    Signals = {},
    UnloadSignals = {},
    Notifications = {},
    NotifySide = "Right",
    Toggled = true,
    Unloaded = false,
    GlowIntensity = 0.25,
    CursorLight = true,
    ForceCheckbox = false,
    ShowToggleFrameInKeybinds = true,
    ToggleKeybind = Enum.KeyCode.RightControl,
    GuiNames = nil,
    Factory = {},
    Boxes = {},
    KeyPickers = {},
    Drag = nil,
    Binding = nil,
    Scheme = {
        BackgroundColor = Color3.fromRGB(25, 25, 25),
        MainColor = Color3.fromRGB(25, 25, 25),
        PanelColor = Color3.fromRGB(40, 40, 40),
        AccentColor = Color3.fromRGB(170, 170, 170),
        OutlineColor = Color3.fromRGB(120, 120, 120),
        FontColor = Color3.fromRGB(245, 245, 245),
        InactiveColor = Color3.fromRGB(125, 125, 125),
        Font = Enum.Font.GothamBold,
        BodyFont = Enum.Font.GothamMedium,
        CornerRadius = 10,
        PrimaryScale = 0.25,
        AlignLeft = Enum.TextXAlignment.Left,
    },
}

local ThemeManager = {}
local SaveManager = {
    Folder = "ware.gg",
    Ignore = {
        ConfigAutoload = true,
        ConfigName = true,
        ConfigList = true,
        ConfigTag = true,
        PanicKeybind = true,
    },
}

local Templates = {
    Window = {
        Title = "ware.gg",
        Footer = "",
        NotifySide = "Right",
        ShowCustomCursor = true,
    },
    Toggle = {
        Text = "Toggle",
        Default = false,
        Callback = function() end,
    },
    Slider = {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Compact = false,
        Suffix = "",
        Callback = function() end,
    },
    Dropdown = {
        Text = "Dropdown",
        Values = {},
        Multi = false,
        Callback = function() end,
    },
    Button = {
        Text = "Button",
        Func = function() end,
    },
    Input = {
        Text = "Input",
        Default = "",
        Placeholder = "",
        Callback = function() end,
    },
    KeyPicker = {
        Text = "Key",
        Default = "None",
        Mode = "Toggle",
        SyncToggleState = false,
        NoUI = false,
        Callback = function() end,
    },
    ColorPicker = {
        Default = Color3.fromRGB(170, 170, 170),
        Title = "Color",
        Callback = function() end,
    },
    Groupbox = {
        Side = "Left",
        Name = "Groupbox",
    },
}

local PrimaryPalette = {
    Color3.fromRGB(100, 100, 100), Color3.fromRGB(0, 0, 0), Color3.fromRGB(150, 150, 165), Color3.fromRGB(235, 64, 64),
    Color3.fromRGB(255, 140, 50), Color3.fromRGB(240, 200, 60), Color3.fromRGB(130, 220, 70), Color3.fromRGB(46, 204, 113),
    Color3.fromRGB(40, 200, 190), Color3.fromRGB(80, 210, 255), Color3.fromRGB(56, 140, 255), Color3.fromRGB(100, 90, 230),
    Color3.fromRGB(160, 90, 230), Color3.fromRGB(230, 70, 200), Color3.fromRGB(228, 91, 132), Color3.fromRGB(150, 100, 60),
}

local Palette = {
    Color3.fromRGB(170, 170, 170), Color3.fromRGB(225, 225, 225), Color3.fromRGB(90, 90, 95), Color3.fromRGB(235, 64, 64),
    Color3.fromRGB(255, 140, 50), Color3.fromRGB(240, 200, 60), Color3.fromRGB(130, 220, 70), Color3.fromRGB(46, 204, 113),
    Color3.fromRGB(40, 200, 190), Color3.fromRGB(80, 210, 255), Color3.fromRGB(56, 140, 255), Color3.fromRGB(100, 90, 230),
    Color3.fromRGB(160, 90, 230), Color3.fromRGB(230, 70, 200), Color3.fromRGB(228, 91, 132), Color3.fromRGB(150, 100, 60),
}

local TabIcons = {
    Main = "\u{2694}",
    Visuals = "\u{1F441}",
    Movement = "\u{26A1}",
    Players = "\u{1F465}",
    Misc = "\u{1F527}",
    Customize = "\u{1F3A8}",
    Configs = "\u{1F4BE}",
    Settings = "\u{2699}\u{FE0F}",
    Credits = "\u{2605}",
    Favorites = "\u{1F4CC}",
}

do
    local Rng = Random.new(tick() * 1000 % 2 ^ 31)
    local function RandStr(Count)
        local Chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        local Out = ""
        for _ = 1, Count do
            local Index = Rng:NextInteger(1, #Chars)
            Out = Out .. string.sub(Chars, Index, Index)
        end
        return Out
    end
    local Tag = RandStr(8)
    Library.GuiNames = {
        UI = "W_" .. Tag .. "_ui",
        Watermark = "W_" .. Tag .. "_wm",
        ESP = "W_" .. Tag .. "_esp",
        ESP2D = "W_" .. Tag .. "_e2d",
        Hud = "W_" .. Tag .. "_hud",
        Snow = "W_" .. Tag .. "_sn",
        HitboxVis = "W_" .. Tag .. "_hv",
        Mobile = "W_" .. Tag .. "_mb",
        Features = "W_" .. Tag .. "_ft",
        Hitmark = "W_" .. Tag .. "_hm",
        MenuBlur = "W_" .. Tag .. "_bl",
        Grade = "W_" .. Tag .. "_gr",
        Bloom = "W_" .. Tag .. "_bm",
        Sky = "W_" .. Tag .. "_sk",
        Atmo = "W_" .. Tag .. "_at",
        SkyCC = "W_" .. Tag .. "_cc",
        HitSound = "W_" .. Tag .. "_hs",
        Stretch = "W_" .. Tag .. "_st",
        Profile = "W_" .. Tag .. "_pf",
        Changelog = "W_" .. Tag .. "_cl",
    }
end

do
    for _, Store in ipairs({ Toggles, Options }) do
        setmetatable(Store, {
            __newindex = function(Table, Key, Value)
                rawset(Table, Key, Value)
                Library.KeyTab[Key] = {
                    Tab = Library.BuildTab,
                    Box = Library.BuildBox,
                }
                if Library.OnKey then
                    pcall(Library.OnKey, Key, Library.BuildTab, Library.LastRow, Library.LastInner, Library.LastBoxObj)
                end
            end,
        })
    end
end

local function DeepCopy(Value)
    if type(Value) ~= "table" then
        return Value
    end
    local Out = {}
    for Key, Item in pairs(Value) do
        Out[Key] = DeepCopy(Item)
    end
    return Out
end

function Library:Validate(Info, Template)
    Info = type(Info) == "table" and Info or {}
    local Out = DeepCopy(Template or {})
    for Key, Value in pairs(Info) do
        Out[Key] = Value
    end
    return Out
end

local function SafeCall(Fn, ...)
    if type(Fn) == "function" then
        pcall(Fn, ...)
    end
end

local function New(Class, Props, Parent)
    local Obj = Instance.new(Class)
    if Props then
        for Key, Value in pairs(Props) do
            Obj[Key] = Value
        end
    end
    if Parent then
        Obj.Parent = Parent
    end
    return Obj
end

local function Corner(Obj, Radius)
    return New("UICorner", {
        CornerRadius = UDim.new(0, Radius or Library.Scheme.CornerRadius),
    }, Obj)
end

local function Register(Inst, Prop)
    table.insert(Library.Registry, { Inst = Inst, Prop = Prop })
    Inst[Prop] = Library.Scheme.AccentColor
    return Inst
end

local function Stroke(Obj, Thickness, Transparency)
    local Line = New("UIStroke", {
        Thickness = Thickness,
        Transparency = Transparency,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, Obj)
    Register(Line, "Color")
    table.insert(Library.OutlineStrokes, Line)
    return Line
end

local function GiveSignal(Signal, Fn)
    local Conn = Signal:Connect(Fn)
    table.insert(Library.Signals, Conn)
    return Conn
end

local function SameColor(A, B)
    return math.floor(A.R * 255 + 0.5) == math.floor(B.R * 255 + 0.5)
        and math.floor(A.G * 255 + 0.5) == math.floor(B.G * 255 + 0.5)
        and math.floor(A.B * 255 + 0.5) == math.floor(B.B * 255 + 0.5)
end

local function Tween(Obj, Time, Props, Style, Dir)
    TweenService:Create(
        Obj,
        TweenInfo.new(Time, Style or Enum.EasingStyle.Sine, Dir or Enum.EasingDirection.Out),
        Props
    ):Play()
end

local function Hover(Btn, Rest, Over)
    Btn.MouseEnter:Connect(function()
        Library:Play("hover")
        Tween(Btn, 0.12, { BackgroundTransparency = Over })
    end)
    Btn.MouseLeave:Connect(function()
        Tween(Btn, 0.18, { BackgroundTransparency = Rest })
    end)
end

local function Ripple(Btn)
    Btn.ClipsDescendants = true
    Btn.Activated:Connect(function()
        Library:Play("click")
        local Scale = (Library.ScaleObj and Library.ScaleObj.Scale) or 1
        local Mouse = UserInputService:GetMouseLocation()
        local Size = Btn.AbsoluteSize / Scale
        local Rel = (Vector2.new(Mouse.X, Mouse.Y) - Btn.AbsolutePosition) / Scale
        Rel = Vector2.new(math.clamp(Rel.X, 0, Size.X), math.clamp(Rel.Y, 0, Size.Y))
        local Diam = math.max(Size.X, Size.Y) * 2.4
        local Ring = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(Rel.X, Rel.Y),
            Size = UDim2.fromOffset(0, 0),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.55,
            BorderSizePixel = 0,
            ZIndex = Btn.ZIndex + 1,
        }, Btn)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Ring)
        Tween(Ring, 0.5, {
            Size = UDim2.fromOffset(Diam, Diam),
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quint)
        task.delay(0.55, function()
            if Ring.Parent then
                Ring:Destroy()
            end
        end)
    end)
end

local function TextWidth(Text, Size, Font)
    return TextService:GetTextSize(Text, Size, Font, Vector2.new(1000, 100)).X
end

local function ParentUi(Gui)
    local Hui = nil
    if type(GetHui) == "function" then
        local Ok, Res = pcall(GetHui)
        if Ok and Res then
            Hui = Res
        end
    end
    Gui.Parent = Hui or CoreGui
    if protectgui then
        pcall(protectgui, Gui)
    elseif syn and syn.protect_gui then
        pcall(syn.protect_gui, Gui)
    end
end

local function SwatchGrid(Parent, Order, OnPick, Colors, Hooks)
    local Grid = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
        LayoutOrder = Order,
    }, Parent)
    New("UIGridLayout", {
            CellSize = UDim2.fromOffset(24, 24),
            CellPadding = UDim2.fromOffset(6, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
    }, Grid)
    New("UIPadding", {
            PaddingTop = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 3),
            PaddingBottom = UDim.new(0, 3),
    }, Grid)
    local Entries = {}
    for Index, Col in ipairs(Colors or Palette) do
        local Btn = New("TextButton", {
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
            BackgroundColor3 = Col,
            LayoutOrder = Index,
        }, Grid)
        Corner(Btn, 6)
        local Line = New("UIStroke", {
                Color = Color3.new(1, 1, 1),
                Thickness = 1,
                Transparency = 0.7,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, Btn)
        Btn.Activated:Connect(function()
            OnPick(Col)
        end)
        if Hooks then
            Btn.MouseEnter:Connect(function()
                if Hooks.Enter then
                    pcall(Hooks.Enter, Col)
                    end
                end)
            Btn.MouseLeave:Connect(function()
                if Hooks.Leave then
                    pcall(Hooks.Leave, Col)
                    end
                end)
            end
        Entries[Index] = { Col = Col, Stroke = Line }
    end
    local function Paint(Current)
        for _, Entry in ipairs(Entries) do
            local Selected = Current ~= nil and SameColor(Entry.Col, Current)
            Entry.Stroke.Thickness = Selected and 2 or 1
            Entry.Stroke.Transparency = Selected and 0 or 0.7
            end
        end
    return Grid, Paint
end

function Library:UpdateColorsUsingRegistry()
    local Accent = Library.Scheme.AccentColor
    for _, Entry in ipairs(Library.Registry) do
        pcall(function()
            Entry.Inst[Entry.Prop] = Accent
        end)
    end
    for _, Hook in ipairs(Library.AccentHooks) do
        SafeCall(Hook)
    end
    for _, Line in ipairs(Library.OutlineStrokes) do
        pcall(function()
            Line.Color = Library.Scheme.OutlineColor
        end)
    end
end

function Library:SetAccentColor(Color)
    Library.Scheme.AccentColor = Color
    Library:UpdateColorsUsingRegistry()
end

function Library:GetAccent()
    return Library.Scheme.AccentColor
end

function Library:SetOutlineColor(Color)
    Library.Scheme.OutlineColor = Color
    for _, Line in ipairs(Library.OutlineStrokes) do
        pcall(function()
            Line.Color = Color
        end)
    end
end

function Library:SetPrimaryColor(Color)
    Library.Scheme.MainColor = Color
    Library.Scheme.BackgroundColor = Color
    for _, Inst in ipairs(Library.PrimaryRegs) do
        pcall(function()
            Inst.BackgroundColor3 = Color
        end)
    end
    for _, Toggle in pairs(Library.Toggles) do
        if Toggle.Refresh then
            pcall(Toggle.Refresh)
        end
    end
end

function Library:SetTheme(MainColor, AccentColor)
    if MainColor then
        Library:SetPrimaryColor(MainColor)
    end
    if AccentColor then
        Library:SetAccentColor(AccentColor)
        end
    end

function Library:SetGlow(Value)
    Library.GlowIntensity = tonumber(Value) or 1
    if Library.ApplyGlow then
        Library.ApplyGlow()
    end
end

function Library:SetCursorLight(Value)
    Library.CursorLight = Value and true or false
end

function Library:SetNotifySide(Side)
    Library.NotifySide = Side or "Right"
    if Library.NotifyHolder then
        if Side == "Left" then
            Library.NotifyHolder.Position = UDim2.new(0, 12, 0, 12)
            Library.NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        else
            Library.NotifyHolder.Position = UDim2.new(1, -312, 0, 12)
            Library.NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        end
    end
end

function Library:SetTransparency(Value)
    if Library.MainFrame then
        Library.MainFrame.BackgroundTransparency = Value
    end
end

function Library:SetScale(Value)
    if Library.ScaleObj then
        Library.UserScale = Value
        Library.ScaleObj.Scale = Value
    end
end

function Library:SetBlurEnabled() end
function Library:SetBlurStrength() end
function Library:Play() end

function Library:OnUnload(Fn)
    if type(Fn) == "function" then
        table.insert(Library.UnloadSignals, Fn)
    end
end

function Library:Unload()
    if Library.Unloaded then
        return
    end
    Library.Unloaded = true
    if Library.Silent then
        pcall(function()
            if Library.ScreenGui then
                Library.ScreenGui.Enabled = false
            end
        end)
    end
    for _, Fn in ipairs(Library.UnloadSignals) do
        SafeCall(Fn)
    end
    for _, Conn in ipairs(Library.Signals) do
        pcall(function()
            Conn:Disconnect()
        end)
    end
    table.clear(Library.Signals)
    if Library.Silent then
        task.delay(0.05, function()
            pcall(function()
                if Library.ScreenGui then
                    Library.ScreenGui:Destroy()
                    Library.ScreenGui = nil
                end
            end)
        end)
        return
    end
    pcall(function()
        Library:Notify("Goodbye  \u{2022}  ware.gg unloaded", 1.2, "info")
        if Library.ScaleObj then
            Tween(Library.ScaleObj, 0.35, { Scale = 0.88 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        end
        if Library.Window and Library.Window.SetVisible then
            task.delay(0.15, function()
                pcall(function()
                    Library.Window:SetVisible(false)
                end)
            end)
        end
    end)
    task.delay(1.4, function()
        pcall(function()
            if Library.ScreenGui then
                Library.ScreenGui:Destroy()
                Library.ScreenGui = nil
            end
        end)
    end)
end

function Library:Panic()
    Library.Silent = true
    Library:Unload()
end

do
    local GuiParent = nil
    if type(GetHui) == "function" then
        local Ok, Res = pcall(GetHui)
        if Ok and Res then
            GuiParent = Res
        end
    end
    GuiParent = GuiParent or CoreGui

    local OldGui = GuiParent:FindFirstChild(Library.GuiNames.UI)
    if OldGui then
        OldGui:Destroy()
    end

    local ScreenGui = New("ScreenGui", {
        Name = Library.GuiNames.UI,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100,
    })
    ParentUi(ScreenGui)
    Library.ScreenGui = ScreenGui
    Library.KeybindFrame = New("Frame", {
        Visible = false,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(1, 1),
    }, ScreenGui)
end

do
    local Tip = New("TextLabel", {
        Name = "Tooltip",
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromOffset(0, 0),
        BackgroundColor3 = Color3.fromRGB(12, 12, 12),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "",
        TextColor3 = Library.Scheme.FontColor,
        TextTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        Visible = false,
        ZIndex = 200,
    }, Library.ScreenGui)
    Corner(Tip, 6)
    local TipLine = New("UIStroke", {
        Thickness = 1,
        Transparency = 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, Tip)
    Register(TipLine, "Color")
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 9),
        PaddingRight = UDim.new(0, 9),
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
    }, Tip)
    New("UISizeConstraint", { MaxSize = Vector2.new(240, 200) }, Tip)
    local TipToken = 0
    local function MoveTip()
        local M = UserInputService:GetMouseLocation()
        local Cam = workspace.CurrentCamera
        local Vp = Cam and Cam.ViewportSize or Vector2.new(1280, 720)
        local Sz = Tip.AbsoluteSize
        Tip.Position = UDim2.fromOffset(
            math.max(4, math.min(M.X + 14, Vp.X - Sz.X - 8)),
            math.max(4, math.min(M.Y + 18, Vp.Y - Sz.Y - 8))
        )
    end
    Library.TipMove = function()
        if Tip.Visible then
            MoveTip()
        end
    end
    Library.AttachTooltipFn = function(Obj, Text)
        if type(Text) ~= "string" or Text == "" then
            return
        end
        Obj.MouseEnter:Connect(function()
            TipToken = TipToken + 1
            local Mine = TipToken
            task.delay(0.45, function()
                if Mine ~= TipToken or Library.Unloaded then
                    return
                end
                Tip.Text = Text
                Tip.Visible = true
                MoveTip()
                Tween(Tip, 0.16, { BackgroundTransparency = 0.04, TextTransparency = 0 })
                Tween(TipLine, 0.16, { Transparency = 0.3 })
            end)
        end)
        Obj.MouseLeave:Connect(function()
            TipToken = TipToken + 1
            local Mine = TipToken
            Tween(Tip, 0.1, { BackgroundTransparency = 1, TextTransparency = 1 })
            Tween(TipLine, 0.1, { Transparency = 1 })
            task.delay(0.12, function()
                if Mine == TipToken then
                    Tip.Visible = false
                end
            end)
        end)
        end
    end

do
    local NotifyHolder = New("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 300, 1, -20),
        Position = UDim2.new(1, -312, 0, 12),
        BackgroundTransparency = 1,
    }, Library.ScreenGui)
    local NotifyLayout = New("UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    }, NotifyHolder)
    Library.NotifyHolder = NotifyHolder
    Library.NotifyLayout = NotifyLayout

    function Library:Notify(Text, Duration, Kind)
        if type(Text) == "table" then
            Duration = Text.Time or Text.Duration or Duration
            Text = Text.Description or Text.Title or ""
        end
        Text = tostring(Text)
        Duration = tonumber(Duration) or 4
        if not Kind then
            local Low = string.lower(Text)
            if string.find(Low, "couldn't", 1, true) or string.find(Low, "failed", 1, true)
                or string.find(Low, "not found", 1, true) or string.find(Low, "corrupt", 1, true)
                or string.find(Low, "no file", 1, true) or string.find(Low, "pick a", 1, true)
                or string.find(Low, "type a", 1, true) or string.find(Low, "void", 1, true)
                or string.find(Low, "no enemy", 1, true) or string.find(Low, "no open", 1, true) then
                Kind = "warn"
            elseif string.find(Low, "saved", 1, true) or string.find(Low, "loaded", 1, true)
                or string.find(Low, "copied", 1, true) or string.find(Low, "deleted", 1, true)
                or string.find(Low, "overwrote", 1, true) then
                Kind = "ok"
            else
                Kind = "info"
            end
        end
        local Tone = (Kind == "warn") and Color3.fromRGB(255, 170, 70) or Library.Scheme.AccentColor
        local Glyph = (Kind == "ok") and "\u{2713}" or ((Kind == "warn") and "!" or "i")
        local DirX = (Library.NotifySide == "Left") and -80 or 80
        local Bounds = TextService:GetTextSize(Text, 13, Enum.Font.GothamBold, Vector2.new(250, 1000))
        local W = math.floor(Bounds.X) + 62
        local H = math.max(42, math.floor(Bounds.Y) + 22)
        local Wrap = New("Frame", { Size = UDim2.fromOffset(W, H), BackgroundTransparency = 1 }, NotifyHolder)
        local Card = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.fromOffset(DirX, 0),
            BackgroundColor3 = Library.Scheme.MainColor,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
        }, Wrap)
        Corner(Card, 10)
        local CardLine = New("UIStroke", {
            Color = Tone,
            Thickness = 1,
            Transparency = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, Card)
        local IconFrame = New("Frame", {
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(0, 12, 0.5, -12),
            BackgroundColor3 = Tone,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, Card)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, IconFrame)
        local IconText = New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = Glyph,
            TextColor3 = Color3.fromRGB(20, 20, 20),
            Font = Enum.Font.GothamBlack,
            TextSize = 14,
            TextTransparency = 1,
        }, IconFrame)
        local Msg = New("TextLabel", {
            Position = UDim2.fromOffset(46, 0),
            Size = UDim2.new(1, -54, 1, -4),
            BackgroundTransparency = 1,
            Text = Text,
            TextColor3 = Library.Scheme.FontColor,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextWrapped = true,
            TextXAlignment = Library.Scheme.AlignLeft,
            TextTransparency = 1,
        }, Card)
        local Bar = New("Frame", {
            Position = UDim2.new(0, 12, 1, -5),
            Size = UDim2.new(1, -24, 0, 2),
            BackgroundColor3 = Tone,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
        }, Card)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Bar)
        Library:Play("notify")
        Tween(Card, 0.4, { Position = UDim2.fromOffset(0, 0), BackgroundTransparency = 0.06 }, Enum.EasingStyle.Quint)
        Tween(CardLine, 0.3, { Transparency = 0.35 })
        Tween(IconFrame, 0.3, { BackgroundTransparency = 0 })
        Tween(IconText, 0.3, { TextTransparency = 0 })
        Tween(Msg, 0.3, { TextTransparency = 0 })
        Tween(Bar, 0.3, { BackgroundTransparency = 0.45 })
        Tween(Bar, Duration, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Linear)
        task.delay(Duration, function()
            if not Wrap.Parent then
                return
            end
            Tween(Card, 0.3, { Position = UDim2.fromOffset(DirX, 0), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(CardLine, 0.25, { Transparency = 1 })
            Tween(IconFrame, 0.25, { BackgroundTransparency = 1 })
            Tween(IconText, 0.25, { TextTransparency = 1 })
            Tween(Msg, 0.25, { TextTransparency = 1 })
            Tween(Bar, 0.25, { BackgroundTransparency = 1 })
            task.delay(0.3, function()
                if Wrap.Parent then
                    Tween(Wrap, 0.22, { Size = UDim2.fromOffset(W, 0) })
                    task.delay(0.24, function()
                        if Wrap.Parent then
                            Wrap:Destroy()
                        end
                    end)
                end
            end)
        end)
    end
end

if not Library.Session then
    Library.Session = { T0 = tick(), Kills = 0, Deaths = 0 }
end

function Library:Splash(Title, OnDone)
    local Gui = Library.ScreenGui
    if not Gui then
        SafeCall(OnDone)
        return
    end
    local Rng = Random.new()
    local Base = Library:GetLoadupColor() or Library:GetSavedAccent() or Library.Scheme.AccentColor
    local Hi = Base
    local Word = string.lower(tostring(Title))
    local Who = (LocalPlayer and LocalPlayer.DisplayName) or ""
    local Finished = false
    local Labels, Fades = {}, {}
    local Layer = New("TextButton", {
            Name = "Splash",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 90,
            ClipsDescendants = true,
    }, Gui)
    Tween(Layer, 0.4, { BackgroundTransparency = 0.18 })
    local function Strip(Pos, Size, Rot)
        local F = New("Frame", {
            Position = Pos,
            Size = Size,
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 91,
        }, Layer)
        New("UIGradient", {
            Rotation = Rot,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.1),
                    NumberSequenceKeypoint.new(1, 1),
                }),
        }, F)
        Tween(F, 0.6, { BackgroundTransparency = 0 })
        Fades[#Fades + 1] = F
    end
    Strip(UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.4, 0), 90)
    Strip(UDim2.new(0, 0, 0.6, 0), UDim2.new(1, 0, 0.4, 0), 270)
    Strip(UDim2.new(0, 0, 0, 0), UDim2.new(0.28, 0, 1, 0), 0)
    Strip(UDim2.new(0.72, 0, 0, 0), UDim2.new(0.28, 0, 1, 0), 180)
    local function Ring(Delay, Size, Thick)
        task.delay(Delay, function()
            if not Layer.Parent then return end
            local R = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 0.5, -10),
                    Size = UDim2.fromOffset(40, 40),
                    BackgroundTransparency = 1,
                    ZIndex = 92,
            }, Layer)
            New("UICorner", { CornerRadius = UDim.new(1, 0) }, R)
            local Rs = New("UIStroke", {
                Color = Hi,
                Thickness = Thick,
                    Transparency = 0.2,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            }, R)
            Tween(R, 1.7, { Size = UDim2.fromOffset(Size, Size) }, Enum.EasingStyle.Quint)
            Tween(Rs, 1.7, { Transparency = 1 })
                task.delay(1.8, function()
                if R.Parent then R:Destroy() end
                end)
            end)
        end
    Ring(0.15, 780, 2.5)
    Ring(0.45, 1000, 2)
    Ring(0.75, 1250, 1.5)
    local Scan = New("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
            Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Base,
            BorderSizePixel = 0,
            ZIndex = 93,
    }, Layer)
    New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0.05),
                NumberSequenceKeypoint.new(1, 1),
            }),
    }, Scan)
    Tween(Scan, 1.5, { Position = UDim2.new(0, 0, 1, 130) }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
        task.delay(1.6, function()
        if Scan.Parent then Scan:Destroy() end
        end)
        for _ = 1, 28 do
        local Sz = Rng:NextInteger(2, 5)
        local Px = Rng:NextNumber()
        local Y0 = Rng:NextNumber(0.4, 1)
        local Life = Rng:NextNumber(1.8, 3.2)
        local P = New("Frame", {
            Size = UDim2.fromOffset(Sz, Sz),
            Position = UDim2.new(Px, 0, Y0, 0),
            BackgroundColor3 = Hi,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 92,
        }, Layer)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, P)
        task.delay(Rng:NextNumber(0, 1.2), function()
            if not P.Parent then return end
            Tween(P, 0.4, { BackgroundTransparency = Rng:NextNumber(0.2, 0.55) })
            Tween(P, Life, { Position = UDim2.new(Px, 0, Y0 - Rng:NextNumber(0.15, 0.35), 0) }, Enum.EasingStyle.Sine)
            task.delay(Life * 0.55, function()
                if P.Parent then
                    Tween(P, Life * 0.45, { BackgroundTransparency = 1 })
                    end
                end)
            end)
        end
    local Total = 0
    for I = 1, #Word do
        Total = Total + ((string.sub(Word, I, I) == ".") and 16 or 33)
    end
    local Cells = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, -14),
        Size = UDim2.fromOffset(Total, 64),
            BackgroundTransparency = 1,
            ZIndex = 94,
    }, Layer)
    New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
    }, Cells)
    local Pool = "abcdefghijklmnopqrstuvwxyz0123456789#$%&@*+="
    for I = 1, #Word do
        local Ch = string.sub(Word, I, I)
        local Cell = New("Frame", {
            Size = UDim2.fromOffset((Ch == ".") and 16 or 33, 64),
                BackgroundTransparency = 1,
            LayoutOrder = I,
                ZIndex = 94,
        }, Cells)
        local Lbl = New("TextLabel", {
                Size = UDim2.fromScale(1, 1),
                Position = UDim2.fromOffset(0, 20),
                BackgroundTransparency = 1,
                Text = "",
                Font = Enum.Font.GothamBlack,
                TextSize = 54,
            TextColor3 = (I <= 4) and Base or Hi,
                TextTransparency = 1,
                ZIndex = 95,
        }, Cell)
        Labels[I] = { Lbl = Lbl, Ch = Ch }
        task.delay(0.35 + (I - 1) * 0.11, function()
            if not Lbl.Parent then return end
            Tween(Lbl, 0.4, { TextTransparency = 0, Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back)
            local T0 = os.clock()
            while Lbl.Parent and os.clock() - T0 < 0.45 do
                local K = Rng:NextInteger(1, #Pool)
                Lbl.Text = string.sub(Pool, K, K)
                    task.wait(0.04)
                end
            if Lbl.Parent then
                Lbl.Text = Ch
                end
            end)
        end
    local Under = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 34),
            Size = UDim2.fromOffset(0, 2),
        BackgroundColor3 = Hi,
            BorderSizePixel = 0,
            ZIndex = 94,
    }, Layer)
    New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
    }, Under)
        task.delay(0.9, function()
        if Under.Parent then
            Tween(Under, 0.9, { Size = UDim2.fromOffset(320, 2) }, Enum.EasingStyle.Quint)
            end
        end)
    Fades[#Fades + 1] = Under
    local Hello = New("TextLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 56),
            Size = UDim2.fromOffset(320, 18),
            BackgroundTransparency = 1,
        Text = (Who ~= "") and ("welcome, " .. Who) or "welcome",
        TextColor3 = Hi,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextTransparency = 1,
            ZIndex = 94,
    }, Layer)
        task.delay(1.1, function()
        if Hello.Parent then
            Tween(Hello, 0.6, { TextTransparency = 0.1 })
            end
        end)
    local Track = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 100),
            Size = UDim2.fromOffset(240, 3),
        BackgroundColor3 = Base:Lerp(Color3.new(0, 0, 0), 0.8),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 94,
    }, Layer)
    Corner(Track, 2)
    local Fill = New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Base,
            BorderSizePixel = 0,
            ZIndex = 95,
    }, Track)
    Corner(Fill, 2)
    local Status = New("TextLabel", {
            Position = UDim2.new(0.5, -120, 0.5, 110),
            Size = UDim2.fromOffset(170, 14),
            BackgroundTransparency = 1,
            Text = "",
        TextColor3 = Base,
            Font = Enum.Font.Gotham,
            TextSize = 11,
        TextXAlignment = Library.Scheme.AlignLeft,
            TextTransparency = 1,
            ZIndex = 94,
    }, Layer)
    local Pct = New("TextLabel", {
            Position = UDim2.new(0.5, 40, 0.5, 110),
            Size = UDim2.fromOffset(80, 14),
            BackgroundTransparency = 1,
            Text = "0%",
        TextColor3 = Hi,
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextTransparency = 1,
            ZIndex = 94,
    }, Layer)
    local function Finish()
        if Finished or not Layer.Parent then return end
        Finished = true
        for _, L in ipairs(Labels) do
            L.Lbl.Text = L.Ch
            Tween(L.Lbl, 0.5, { TextTransparency = 1, TextSize = 76 }, Enum.EasingStyle.Quint)
        end
        Ring(0, 1000, 3.5)
        Ring(0.1, 1300, 2)
        for _, O in ipairs({ Under, Track, Fill }) do
            Tween(O, 0.35, { BackgroundTransparency = 1 })
        end
        for _, O in ipairs({ Hello, Status, Pct }) do
            Tween(O, 0.35, { TextTransparency = 1 })
        end
        for _, F in ipairs(Fades) do
            Tween(F, 0.5, { BackgroundTransparency = 1 })
        end
        Tween(Layer, 0.55, { BackgroundTransparency = 1 })
        SafeCall(OnDone)
            task.delay(0.9, function()
            if Layer.Parent then
                Layer:Destroy()
                end
            end)
        end
    Layer.Activated:Connect(Finish)
        task.delay(0.25, function()
        if not Layer.Parent then return end
        Tween(Track, 0.3, { BackgroundTransparency = 0 })
        Tween(Status, 0.3, { TextTransparency = 0.15 })
        Tween(Pct, 0.3, { TextTransparency = 0 })
        local Steps = { { 0, "initializing" }, { 22, "loading modules" }, { 50, "building interface" }, { 76, "applying theme" }, { 100, "ready" } }
        local T0, Dur = os.clock(), 2.1
        while Layer.Parent and not Finished do
            local X = math.clamp((os.clock() - T0) / Dur, 0, 1)
            local E = X * X * (3 - 2 * X)
            local Pc = math.floor(E * 100 + 0.5)
            Fill.Size = UDim2.new(E, 0, 1, 0)
            Pct.Text = Pc .. "%"
            for _, St in ipairs(Steps) do
                if Pc >= St[1] then
                    Status.Text = St[2]
                end
            end
            if X >= 1 then break end
                task.wait()
            end
        if Layer.Parent and not Finished then
                task.wait(0.4)
            Finish()
            end
        end)
    end

Library.Shared = {
    New = New,
    Corner = Corner,
    Stroke = Stroke,
    Tween = Tween,
    Hover = Hover,
    Ripple = Ripple,
    Register = Register,
    GiveSignal = GiveSignal,
    SafeCall = SafeCall,
    TextWidth = TextWidth,
    SameColor = SameColor,
    SwatchGrid = SwatchGrid,
    ParentUi = ParentUi,
    Palette = Palette,
    PrimaryPalette = PrimaryPalette,
    TabIcons = TabIcons,
    UserInputService = UserInputService,
    TweenService = TweenService,
    TextService = TextService,
    RunService = RunService,
    HttpService = HttpService,
}

GiveSignal(UserInputService.InputChanged, function(Input)
    local Kind = Input.UserInputType
    if Kind == Enum.UserInputType.MouseMovement or Kind == Enum.UserInputType.Touch then
        if Library.Drag and Library.Drag.Update then
            Library.Drag.Update(Input.Position.X)
        end
        if Library.TipMove then
            Library.TipMove()
        end
        if Library.WinDrag then
            Library.WinDrag(Input.Position)
        end
    end
end)

GiveSignal(UserInputService.InputEnded, function(Input)
    local Kind = Input.UserInputType
    if Kind == Enum.UserInputType.MouseButton1 or Kind == Enum.UserInputType.Touch then
        if Library.Drag and Library.Drag.Release then
            pcall(Library.Drag.Release)
        end
        Library.Drag = nil
        Library.WinDrag = nil
    end
    if Kind == Enum.UserInputType.Keyboard then
        local Name = Input.KeyCode.Name
        for _, Picker in ipairs(Library.KeyPickers) do
            if Picker.Mode == "Hold" and Picker.Value == Name then
                Picker.State = false
            end
            end
        end
    end)

GiveSignal(UserInputService.InputBegan, function(Input, GameProcessed)
    if Library.Unloaded or Input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
    local Name = Input.KeyCode.Name

    if Library.Binding then
        local Picker = Library.Binding
        Library.Binding = nil
        if Input.KeyCode == Enum.KeyCode.Escape or Input.KeyCode == Enum.KeyCode.Backspace then
            Picker:SetValue("None")
        else
            Picker:SetValue(Name)
            end
            return
        end

    if Input.KeyCode == Enum.KeyCode.K and (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)) then
        if Library.FocusSearch then
            Library.FocusSearch()
            end
            return
        end

    if GameProcessed then
            return
        end

    for _, Picker in ipairs(Library.KeyPickers) do
        if Picker.Value == Name then
            if Picker.Mode == "Hold" then
                Picker.State = true
            elseif Picker.Mode == "Toggle" then
                if Picker.Sync and Picker.Toggle then
                    Picker.Toggle:SetValue(not Picker.Toggle.Value)
                    Picker.State = Picker.Toggle.Value
                else
                    Picker.State = not Picker.State
                end
                SafeCall(Picker.Callback, Picker.State)
                end
            end
        end
    end)

local function AttachTooltip(Obj, Text)
    if Library.AttachTooltipFn then
        Library.AttachTooltipFn(Obj, Text)
    end
end

local BaseAddons = {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(KeyIndex, KeyConfig)
        KeyConfig = KeyConfig or {}
        local Parent = self
        local Right = Parent.ExtraRight or 0
        local function Reserve(Width)
            local X = Right + Width
            Right = Right + Width + 6
            Parent.ExtraRight = Right
            Parent.Label.Size = UDim2.new(1, -(Right + 2), 1, 0)
            return X
        end

        local Picker = {
                Type = "KeyPicker",
            Value = tostring(KeyConfig.Default or "None"),
            Mode = KeyConfig.Mode or "Toggle",
            Sync = KeyConfig.SyncToggleState,
            Toggle = (Parent.Type == "Toggle") and Parent or nil,
            Callback = KeyConfig.Callback,
                State = false,
            }
        local X = Reserve(44)
        local Btn = New("TextButton", {
                Size = UDim2.fromOffset(44, 22),
            Position = UDim2.new(1, -X, 0.5, -11),
            BackgroundColor3 = Library.Scheme.PanelColor,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Font = Enum.Font.GothamBold,
                TextSize = 12,
            TextColor3 = Library.Scheme.FontColor,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = "-",
        }, Parent.Row)
        Corner(Btn, 6)
        Stroke(Btn, 1, 0.3)
        Hover(Btn, 0.1, 0)

        local function Show()
            Btn.Text = (Picker.Value == "None") and "-" or Picker.Value
        end

        function Picker:GetState()
                if self.Mode == "Always" then
                    return true
                end
                return self.State
            end

        function Picker:SetValue(Value)
            if type(Value) == "table" then
                self.Value = tostring(Value[1] or "None")
                self.Mode = Value[2] or self.Mode
            else
                self.Value = tostring(Value or "None")
            end
            Show()
        end

        Btn.Activated:Connect(function()
            Library.Binding = Picker
            Btn.Text = "..."
        end)

        Show()
        table.insert(Library.KeyPickers, Picker)
        if KeyIndex then
            Library.Options[KeyIndex] = Picker
        end
        return Picker
    end

    function Funcs:AddColorPicker(ColorIndex, ColorConfig)
        ColorConfig = ColorConfig or {}
        local Parent = self
        local Right = Parent.ExtraRight or 0
        local SubOrder = (Parent.SubOrder or 1) + 1
        Parent.SubOrder = SubOrder

        local function Reserve(Width)
            local X = Right + Width
            Right = Right + Width + 6
            Parent.ExtraRight = Right
            Parent.Label.Size = UDim2.new(1, -(Right + 2), 1, 0)
            return X
        end

        local Picker = {
            Type = "ColorPicker",
            Value = ColorConfig.Default or Color3.new(1, 1, 1),
        }
        local X = Reserve(22)
        local Swatch = New("TextButton", {
                Size = UDim2.fromOffset(22, 22),
            Position = UDim2.new(1, -X, 0.5, -11),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
            BackgroundColor3 = Picker.Value,
        }, Parent.Row)
        Corner(Swatch, 6)
        local SwatchStroke = New("UIStroke", {
                Color = Color3.fromRGB(230, 230, 230),
                Thickness = 1,
                Transparency = 0.3,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, Swatch)

        local Holder = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Visible = false,
            LayoutOrder = SubOrder,
        }, Parent.Holder)
        local Sub = New("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.fromOffset(0, -16),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
        }, Holder)
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Sub)
        local _, PaintSwatches = SwatchGrid(Sub, 1, function(Col)
            Picker:SetValue(Col)
        end)
        local function Sync()
            Swatch.BackgroundColor3 = Picker.Value
            PaintSwatches(Picker.Value)
        end

        function Picker:SetValue(Value)
            if typeof(Value) ~= "Color3" then
                    return
                end
            self.Value = Value
            Sync()
            SafeCall(ColorConfig.Callback, Value)
        end

        local PickerOpen, PickerToken = false, 0
        Swatch.MouseEnter:Connect(function()
            Tween(Swatch, 0.15, {
                Size = UDim2.fromOffset(25, 25),
                Position = UDim2.new(1, -X - 1.5, 0.5, -12.5),
            }, Enum.EasingStyle.Back)
        end)
        Swatch.MouseLeave:Connect(function()
            Tween(Swatch, 0.2, {
                Size = UDim2.fromOffset(22, 22),
                Position = UDim2.new(1, -X, 0.5, -11),
            })
        end)
        Swatch.Activated:Connect(function()
            PickerOpen = not PickerOpen
            PickerToken = PickerToken + 1
            local Mine = PickerToken
            if PickerOpen then
                Tween(SwatchStroke, 0.2, { Thickness = 2, Transparency = 0 })
                Holder.Visible = true
                Sub.Position = UDim2.fromOffset(0, -16)
                    task.spawn(function()
                        task.wait()
                    if PickerToken ~= Mine then
                        return
                    end
                    local ScaleValue = (Library.ScaleObj and Library.ScaleObj.Scale) or 1
                    local Height = math.ceil(Sub.AbsoluteSize.Y / math.max(ScaleValue, 0.01)) + 2
                    Tween(Holder, 0.4, { Size = UDim2.new(1, 0, 0, Height) }, Enum.EasingStyle.Quint)
                    Tween(Sub, 0.45, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Quint)
                    end)
                else
                Tween(SwatchStroke, 0.25, { Thickness = 1, Transparency = 0.3 })
                Tween(Sub, 0.22, {
                    Position = UDim2.fromOffset(0, -16),
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                Tween(Holder, 0.25, {
                    Size = UDim2.new(1, 0, 0, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                    task.delay(0.27, function()
                    if PickerToken == Mine then
                        Holder.Visible = false
                        end
                    end)
                end
            end)

        Sync()
        if ColorIndex then
            Library.Options[ColorIndex] = Picker
        end
        return Picker
    end

    BaseAddons.__index = Funcs
end

local function AttachExtras(Obj, Holder, Row, Label, Base)
    Obj.Holder = Holder
    Obj.Row = Row
    Obj.Label = Label
    Obj.ExtraRight = Base or 0
    Obj.SubOrder = 1
    setmetatable(Obj, BaseAddons)
end

local BaseGroupbox = {}
do
    local Funcs = {}

    function Funcs:IsCollapsed()
        return self.Collapsed == true
    end

    function Funcs:SetCollapsed(State, Instant)
        State = State and true or false
        if State == self.Collapsed then
            return
        end
        self.Collapsed = State
        local Token = (self.CollapseToken or 0) + 1
        self.CollapseToken = Token
        local Frame = self.Frame
        local ScaleValue = math.max(self.Scale.Scale, 0.01)
        local Current = Frame.AbsoluteSize.Y / ScaleValue
        local function FullHeight()
            return self.Layout.AbsoluteContentSize.Y / ScaleValue + 18
        end
        Tween(self.Chevron, Instant and 0 or 0.3, {
            Rotation = State and -90 or 0,
        }, Enum.EasingStyle.Back)
        local ArmColor = State and Library.Scheme.AccentColor or Library.Scheme.InactiveColor
        for _, Arm in ipairs(self.ChevronArms) do
            Tween(Arm, 0.25, { BackgroundColor3 = ArmColor })
        end
        Frame.ClipsDescendants = true
        Frame.AutomaticSize = Enum.AutomaticSize.None
        Frame.Size = UDim2.new(1, 0, 0, Current)
        if State then
            Tween(Frame, Instant and 0 or 0.32, { Size = UDim2.new(1, 0, 0, 42) }, Enum.EasingStyle.Quint)
        else
            Tween(Frame, 0.34, { Size = UDim2.new(1, 0, 0, FullHeight()) }, Enum.EasingStyle.Quint)
                task.delay(0.38, function()
                if self.CollapseToken == Token and not self.Collapsed then
                    Frame.AutomaticSize = Enum.AutomaticSize.Y
                    Frame.Size = UDim2.new(1, 0, 0, 0)
                    Frame.ClipsDescendants = false
                    end
                end)
            end
        end

    function Funcs:AddToggle(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local Holder, Row = self:MakeRow(30)
        local Label = New("TextLabel", {
                Size = UDim2.new(1, -58, 1, 0),
                BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
                TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)

        local SweepRow = New("Frame", {
                Size = UDim2.new(1, 0, 1, -4),
                Position = UDim2.fromOffset(0, 2),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 0,
        }, Row)
        Corner(SweepRow, 7)
        Register(SweepRow, "BackgroundColor3")
        local SweepGrad = New("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.5, 0.82),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Offset = Vector2.new(-1, 0),
        }, SweepRow)
        local Track = New("TextButton", {
                Size = UDim2.fromOffset(48, 26),
                Position = UDim2.new(1, -48, 0.5, -13),
                Text = "",
                AutoButtonColor = false,
                BorderSizePixel = 0,
            BackgroundColor3 = Scheme.PanelColor,
                BackgroundTransparency = 0.14,
        }, Row)
        Corner(Track, 12)
        local Glow = Stroke(Track, 0.8, 0.8)
        local Knob = New("Frame", {
                Size = UDim2.fromOffset(18, 18),
                Position = UDim2.new(0, 4, 0.5, -9),
            BackgroundColor3 = Scheme.FontColor,
                BorderSizePixel = 0,
        }, Track)
        Corner(Knob, 9)
        local KnobGlow = Stroke(Knob, 2, 1)

        local Toggle = {
            Type = "Toggle",
            Value = Config.Default and true or false,
            Changed = {},
        }

        local function Render(Animate)
            local On = Toggle.Value
            local Bg = On and Scheme.MainColor or Scheme.PanelColor
            local BgT = On and 0.08 or 0.16
            local KnobPos = On and UDim2.new(1, -22, 0.5, -9) or UDim2.new(0, 4, 0.5, -9)
            local GlowT = On and 0.08 or 0.7
            local LabelColor = On and Scheme.FontColor or Color3.fromRGB(185, 185, 185)
            local KnobGlowT = On and 0.55 or 1
            if Animate then
                Tween(KnobGlow, 0.2, { Transparency = KnobGlowT })
                Tween(Track, 0.18, { BackgroundColor3 = Bg, BackgroundTransparency = BgT })
                Tween(Glow, 0.18, { Transparency = GlowT })
                Tween(Knob, 0.22, { Position = KnobPos }, Enum.EasingStyle.Quint)
                Tween(Label, 0.18, { TextColor3 = LabelColor })
                Tween(Knob, 0.09, { Size = UDim2.fromOffset(24, 18) })
                    task.delay(0.09, function()
                    if Knob.Parent then
                        Tween(Knob, 0.14, { Size = UDim2.fromOffset(18, 18) })
                        end
                    end)
                else
                Track.BackgroundColor3 = Bg
                Track.BackgroundTransparency = BgT
                Glow.Transparency = GlowT
                Knob.Position = KnobPos
                Label.TextColor3 = LabelColor
                KnobGlow.Transparency = KnobGlowT
                end
            end

        function Toggle:SetValue(Value)
            Value = Value and true or false
            if Value == self.Value then
                    return
                end
            self.Value = Value
            Render(true)
            SafeCall(Config.Callback, Value)
            for _, Fn in ipairs(self.Changed) do
                SafeCall(Fn, Value)
                end
            end

        function Toggle:OnChanged(Fn)
            table.insert(self.Changed, Fn)
        end

        Track.Activated:Connect(function()
            Toggle:SetValue(not Toggle.Value)
            Library:Play(Toggle.Value and "on" or "off")
            if Toggle.Value then
                SweepRow.BackgroundTransparency = 0
                SweepGrad.Offset = Vector2.new(-1, 0)
                Tween(SweepGrad, 0.55, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Quint)
                    task.delay(0.6, function()
                    SweepRow.BackgroundTransparency = 1
                    end)
                end
            end)

        Render(false)
        Toggle.Refresh = function()
            Render(false)
        end
        AttachExtras(Toggle, Holder, Row, Label, 54)
        AttachTooltip(Row, Config.Tooltip or Library.Tips[Index])
        Library.Toggles[Index] = Toggle

        if Toggle.Value and Config.Callback then
            task.defer(SafeCall, Config.Callback, true)
        end
        return Toggle
    end

    function Funcs:AddSlider(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local Min, Max, Rounding = Config.Min or 0, Config.Max or 100, Config.Rounding or 0
        local Holder, Row = self:MakeRow(46)

        local SliderTitle = New("TextLabel", {
                Size = UDim2.new(1, -88, 0, 22),
                BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
                TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)

        local ValBox = New("TextBox", {
                Size = UDim2.fromOffset(80, 22),
                Position = UDim2.new(1, -80, 0, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.08,
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.Gotham,
                TextSize = 13,
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
        }, Row)
        Corner(ValBox, 7)
        local ValStroke = Stroke(ValBox, 1.2, 0.02)
        ValBox.Focused:Connect(function()
            Tween(ValStroke, 0.15, { Thickness = 2.2 })
        end)
        ValBox.FocusLost:Connect(function()
            Tween(ValStroke, 0.2, { Thickness = 1.2 })
        end)

        local Hit = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.fromOffset(0, 26),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
        }, Row)
        local Bar = New("Frame", {
                Size = UDim2.new(1, 0, 0, 8),
                Position = UDim2.fromOffset(0, 6),
                BackgroundColor3 = Color3.fromRGB(52, 52, 56),
                BackgroundTransparency = 0.18,
                BorderSizePixel = 0,
        }, Hit)
        Corner(Bar, 4)
        local Fill = New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.05,
        }, Bar)
        Corner(Fill, 4)
        Register(Fill, "BackgroundColor3")
        New("UIGradient", {
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.7, 0.7, 0.7)),
        }, Fill)
        local Knob = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(1, 0, 0.5, 0),
                Size = UDim2.fromOffset(12, 12),
                BackgroundColor3 = Color3.fromRGB(245, 245, 245),
                BorderSizePixel = 0,
        }, Fill)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Knob)
        Stroke(Knob, 1, 0.08)

        local KnobHalo = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 0,
        }, Knob)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, KnobHalo)
        Register(KnobHalo, "BackgroundColor3")
        Hit.MouseEnter:Connect(function()
            Tween(Knob, 0.14, { Size = UDim2.fromOffset(16, 16) }, Enum.EasingStyle.Back)
            Tween(KnobHalo, 0.25, {
                Size = UDim2.fromOffset(30, 30),
                BackgroundTransparency = 0.8,
            }, Enum.EasingStyle.Quint)
        end)
        Hit.MouseLeave:Connect(function()
            Tween(Knob, 0.16, { Size = UDim2.fromOffset(12, 12) })
            Tween(KnobHalo, 0.25, {
                Size = UDim2.fromOffset(12, 12),
                BackgroundTransparency = 1,
            })
        end)

        local Slider = {
            Type = "Slider",
            Min = Min,
            Max = Max,
            Value = math.clamp(Config.Default or Min, Min, Max),
        }

        local ShownVal, CountTok = nil, 0
        local function Show()
            local Frac = (Slider.Value - Min) / math.max(Max - Min, 1e-9)
            Tween(Fill, 0.08, { Size = UDim2.new(math.clamp(Frac, 0, 1), 0, 1, 0) })
            local Fmt = "%." .. Rounding .. "f"
            local function Put(Value)
                local Str = string.format(Fmt, Value)
                if Rounding > 0 then
                    Str = Str:gsub("(%.%d-)0+$", "%1"):gsub("%.$", "")
                end
                ValBox.Text = Str .. (Config.Suffix or "")
            end

            CountTok = CountTok + 1
            local Mine, From, To = CountTok, ShownVal, Slider.Value
            if From == nil or From == To or not ValBox.Parent then
                ShownVal = To
                Put(To)
                    return
                end
                task.spawn(function()
                local T0 = os.clock()
                while CountTok == Mine and os.clock() - T0 < 0.2 do
                    local Alpha = (os.clock() - T0) / 0.2
                    Alpha = 1 - (1 - Alpha) ^ 3
                    ShownVal = From + (To - From) * Alpha
                    Put(ShownVal)
                        task.wait()
                    end
                if CountTok == Mine then
                    ShownVal = To
                    Put(To)
                    end
                end)
            end

        function Slider:SetValue(Value)
            Value = tonumber(Value)
            if not Value then
                    return
                end
            local Mult = 10 ^ Rounding
            Value = math.clamp(math.floor(Value * Mult + 0.5) / Mult, Min, Max)
            if Value == self.Value then
                Show()
                    return
                end
            self.Value = Value
            Show()
            SafeCall(Config.Callback, Value)
        end

        function Slider:SetVisible(Visible)
            Holder.Visible = Visible and true or false
        end

        local TagLbl, TagPill, TagDot, TagStroke
        local TagShown, TagColor = false, Color3.new(1, 1, 1)
        local function TintSlider(On)
            if On then
                Tween(Fill, 0.2, { BackgroundColor3 = TagColor })
                Tween(KnobHalo, 0.2, { BackgroundColor3 = TagColor })
            else
                Tween(Fill, 0.3, { BackgroundColor3 = Scheme.AccentColor })
                Tween(KnobHalo, 0.3, { BackgroundColor3 = Scheme.AccentColor })
                end
            end
        local function ShowTag(On)
            TagShown = On
            if not TagPill then
                return
            end
            if On then
                TagPill.Position = UDim2.new(1, -154, 0, 2)
                Tween(TagPill, 0.35, {
                    Position = UDim2.new(1, -166, 0, 2),
                    BackgroundTransparency = 0.78,
                }, Enum.EasingStyle.Back)
                Tween(TagStroke, 0.25, { Transparency = 0.2 })
                Tween(TagDot, 0.25, { BackgroundTransparency = 0 })
                Tween(TagLbl, 0.25, { TextTransparency = 0 })
            else
                Tween(TagPill, 0.35, {
                    Position = UDim2.new(1, -156, 0, 2),
                    BackgroundTransparency = 1,
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                Tween(TagStroke, 0.3, { Transparency = 1 })
                Tween(TagDot, 0.3, { BackgroundTransparency = 1 })
                Tween(TagLbl, 0.3, { TextTransparency = 1 })
            end
            Tween(SliderTitle, 0.2, {
                Size = On and UDim2.new(1, -172, 0, 22) or UDim2.new(1, -88, 0, 22),
            })
            TintSlider(On)
        end

        function Slider:SetTag(Text, Color)
            if not TagPill then
                TagPill = New("Frame", {
                        AnchorPoint = Vector2.new(0, 0),
                        Position = UDim2.new(1, -156, 0, 2),
                        Size = UDim2.fromOffset(76, 18),
                    BackgroundColor3 = Color,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                }, Row)
                New("UICorner", { CornerRadius = UDim.new(1, 0) }, TagPill)
                TagStroke = New("UIStroke", {
                    Color = Color,
                    Thickness = 1.2,
                    Transparency = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                }, TagPill)
                TagDot = New("Frame", {
                        Position = UDim2.fromOffset(8, 6),
                        Size = UDim2.fromOffset(6, 6),
                    BackgroundColor3 = Color,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                }, TagPill)
                New("UICorner", { CornerRadius = UDim.new(1, 0) }, TagDot)
                TagLbl = New("TextLabel", {
                        Position = UDim2.fromOffset(19, 0),
                        Size = UDim2.new(1, -22, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                    TextColor3 = Color,
                        Font = Enum.Font.GothamBlack,
                        TextSize = 11,
                        TextTransparency = 1,
                    TextXAlignment = Scheme.AlignLeft,
                }, TagPill)
            end
            TagColor = Color
            if TagLbl.Text ~= Text then
                TagLbl.Text = Text
                if TagShown then
                    TagPill.Size = UDim2.fromOffset(84, 21)
                    Tween(TagPill, 0.3, { Size = UDim2.fromOffset(76, 18) }, Enum.EasingStyle.Back)
                    end
                end
            Tween(TagPill, 0.2, { BackgroundColor3 = Color })
            Tween(TagStroke, 0.2, { Color = Color })
            Tween(TagDot, 0.2, { BackgroundColor3 = Color })
            Tween(TagLbl, 0.2, { TextColor3 = Color })
            if TagShown then
                TintSlider(true)
            end
        end

        Hit.InputBegan:Connect(function(Input)
            local Kind = Input.UserInputType
            if Kind == Enum.UserInputType.MouseButton1 or Kind == Enum.UserInputType.Touch then
                local function Update(X)
                    local Frac = math.clamp(
                        (X - Bar.AbsolutePosition.X) / math.max(Bar.AbsoluteSize.X, 1),
                        0,
                        1
                    )
                    Slider:SetValue(Min + (Max - Min) * Frac)
                end
                Library.Drag = {
                    Update = Update,
                    Release = function()
                        Tween(Knob, 0.16, { Size = UDim2.fromOffset(12, 12) })
                        ShowTag(false)
                        end,
                    }
                Tween(Knob, 0.12, { Size = UDim2.fromOffset(18, 18) }, Enum.EasingStyle.Back)
                ShowTag(true)
                Update(Input.Position.X)
                end
            end)

        ValBox.FocusLost:Connect(function()
            local Num = tonumber(string.match(ValBox.Text, "-?%d+%.?%d*"))
            if Num then
                Slider:SetValue(Num)
            end
            Show()
        end)

        Show()
        AttachTooltip(Row, Config.Tooltip or Library.Tips[Index])
        Library.Options[Index] = Slider
        return Slider
    end

    function Funcs:AddDropdown(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local Holder, Row = self:MakeRow(30)
        New("TextLabel", {
                Size = UDim2.new(1, -148, 1, 0),
                BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
                TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)
        local Btn = New("TextButton", {
                Size = UDim2.fromOffset(140, 28),
                Position = UDim2.new(1, -140, 0.5, -14),
            BackgroundColor3 = Scheme.PanelColor,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
            TextColor3 = Scheme.FontColor,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Text = "-",
        }, Row)
        Corner(Btn, 7)
        Stroke(Btn, 1.2, 0.1)
        Hover(Btn, 0.1, 0)
        New("UIPadding", {
            PaddingRight = UDim.new(0, 16),
            PaddingLeft = UDim.new(0, 6),
        }, Btn)
        local Chev = New("TextLabel", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromOffset(14, 14),
                Position = UDim2.new(1, 0, 0.5, 0),
                BackgroundTransparency = 1,
                Text = "\u{25BE}",
            TextColor3 = Scheme.InactiveColor,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                ZIndex = 2,
        }, Btn)

        local List = New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Scheme.PanelColor,
                BackgroundTransparency = 0.2,
                BorderSizePixel = 0,
                ScrollBarThickness = 4,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(),
                Visible = false,
                LayoutOrder = 2,
        }, Holder)
        Corner(List, 7)
        New("UIListLayout", {
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, List)
        New("UIPadding", {
                PaddingTop = UDim.new(0, 3),
                PaddingBottom = UDim.new(0, 3),
                PaddingLeft = UDim.new(0, 4),
                PaddingRight = UDim.new(0, 4),
        }, List)

        local Dropdown = {
            Type = "Dropdown",
            Values = Config.Values or {},
            Value = nil,
            Height = 0,
            Open = false,
        }

        local function SetList(Open)
            Dropdown.Open = Open
            Tween(Chev, 0.2, { Rotation = Open and 180 or 0 }, Enum.EasingStyle.Quint)
            if Open then
                List.Size = UDim2.new(1, 0, 0, 0)
                List.Visible = true
                Tween(List, 0.22, { Size = UDim2.new(1, 0, 0, Dropdown.Height) }, Enum.EasingStyle.Quint)
            else
                Tween(List, 0.14, { Size = UDim2.new(1, 0, 0, 0) })
                    task.delay(0.15, function()
                    if not Dropdown.Open then
                        List.Visible = false
                        end
                    end)
                end
            end

        local function Rebuild()
            for _, Child in ipairs(List:GetChildren()) do
                if Child:IsA("TextButton") then
                    Child:Destroy()
                    end
                end
            for IndexValue, Value in ipairs(Dropdown.Values) do
                local Item = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = Color3.fromRGB(44, 44, 44),
                        BackgroundTransparency = 0.08,
                        BorderSizePixel = 0,
                    Text = tostring(Value),
                    TextColor3 = Scheme.FontColor,
                        Font = Enum.Font.Gotham,
                        TextSize = 12,
                    LayoutOrder = IndexValue,
                }, List)
                Corner(Item, 6)
                Item.Activated:Connect(function()
                    SetList(false)
                    Dropdown:SetValue(Value)
                    end)
                end
            Dropdown.Height = math.min(#Dropdown.Values * 26 + 6, 158)
            if Dropdown.Open then
                List.Size = UDim2.new(1, 0, 0, Dropdown.Height)
                end
            end

        function Dropdown:SetValue(Value)
            if type(Value) == "number" then
                Value = self.Values[Value]
            end
            if Value ~= nil and not table.find(self.Values, Value) then
                    return
                end
            self.Value = Value
            Btn.Text = (Value ~= nil) and tostring(Value) or "-"
            SafeCall(Config.Callback, Value)
        end

        function Dropdown:SetValues(Values)
            self.Values = Values or {}
            Rebuild()
                if self.Value ~= nil and not table.find(self.Values, self.Value) then
                    self:SetValue(nil)
                end
            end

        Rebuild()
        if type(Config.Default) == "number" then
            Dropdown.Value = Dropdown.Values[Config.Default]
        elseif Config.Default ~= nil then
            Dropdown.Value = Config.Default
        end
        Btn.Text = (Dropdown.Value ~= nil) and tostring(Dropdown.Value) or "-"

        Btn.Activated:Connect(function()
                Library:Play("click")
            SetList(not Dropdown.Open)
        end)
        AttachTooltip(Row, Config.Tooltip or Library.Tips[Index])
        Library.Options[Index] = Dropdown
        return Dropdown
    end

    function Funcs:AddButton(ArgA, ArgB)
        local Text, Func
        if type(ArgA) == "table" then
            Text, Func = ArgA.Text, ArgA.Func or ArgA.Callback
        else
            Text, Func = ArgA, ArgB
        end
        local _, Row = self:MakeRow(28)
        local Btn = New("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 0.03,
                BorderSizePixel = 0,
            Text = tostring(Text or "Button"),
                TextColor3 = Color3.fromRGB(20, 20, 20),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
        }, Row)
        Corner(Btn, 7)
        Register(Btn, "BackgroundColor3")
        Hover(Btn, 0.03, 0.22)
        Ripple(Btn)
        Btn.Activated:Connect(function()
            SafeCall(Func)
        end)
        local Button = {}
        function Button:SetText(Value)
            Btn.Text = tostring(Value)
        end
        return Button
    end

    function Funcs:AddInput(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local _, Row = self:MakeRow(30)
        New("TextLabel", {
            Size = UDim2.new(1, -148, 1, 0),
            BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)
        local Box = New("TextBox", {
            Size = UDim2.fromOffset(140, 28),
            Position = UDim2.new(1, -140, 0.5, -14),
            BackgroundColor3 = Scheme.PanelColor,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            TextColor3 = Scheme.FontColor,
            PlaceholderText = Config.Placeholder or "",
            PlaceholderColor3 = Scheme.InactiveColor,
            Text = Config.Default or "",
            ClearTextOnFocus = false,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)
        Corner(Box, 7)
        local BoxStroke = Stroke(Box, 1.2, 0.1)
        Hover(Box, 0.1, 0)
        Box.Focused:Connect(function()
            Tween(BoxStroke, 0.15, { Thickness = 2.2, Transparency = 0 })
        end)
        Box.FocusLost:Connect(function()
            Tween(BoxStroke, 0.2, { Thickness = 1.2, Transparency = 0.1 })
        end)

        local Input = { Type = "Input", Value = Config.Default or "" }
        function Input:SetValue(Value)
            self.Value = tostring(Value or "")
            Box.Text = self.Value
            SafeCall(Config.Callback, self.Value)
        end
        Box.FocusLost:Connect(function()
            Input.Value = Box.Text
            SafeCall(Config.Callback, Input.Value)
        end)
        Library.Options[Index] = Input
        return Input
    end

    function Funcs:AddLabel(Text)
        local Holder, Row = self:MakeRow(22)
        local Label = New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = tostring(Text),
            TextColor3 = Library.Scheme.FontColor,
            Font = Enum.Font.GothamSemibold,
            TextSize = 13,
            TextXAlignment = Library.Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)
        local Obj = { Type = "Label" }
        function Obj:SetText(Value)
            Label.Text = tostring(Value)
        end
        AttachExtras(Obj, Holder, Row, Label, 0)
        return Obj
    end

    function Funcs:AddDivider()
        local _, Row = self:MakeRow(8)
        local Line = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0.5, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.35,
        }, Row)
        New("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.25, 0.2),
                NumberSequenceKeypoint.new(0.75, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, Line)
        Register(Line, "BackgroundColor3")
    end

    function Funcs:AddButtonRow(Items)
        local _, Row = self:MakeRow(28)
        New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
        }, Row)
        local Count = #Items
        for Index, Item in ipairs(Items) do
            local Btn = New("TextButton", {
                Size = UDim2.new(1 / Count, -6 * (Count - 1) / Count, 1, 0),
                    BackgroundTransparency = 0.03,
                    BorderSizePixel = 0,
                Text = tostring(Item.Text),
                    TextColor3 = Color3.fromRGB(20, 20, 20),
                    Font = Enum.Font.GothamBold,
                    TextSize = 12,
                LayoutOrder = Index,
            }, Row)
            Corner(Btn, 7)
            Register(Btn, "BackgroundColor3")
            Hover(Btn, 0.03, 0.22)
            Ripple(Btn)
            Btn.Activated:Connect(function()
                SafeCall(Item.Func)
                end)
            end
        end

    function Funcs:AddCustom(Height)
        local Holder, Row = self:MakeRow(Height)
        return Row, Holder
    end

    function Funcs:AddColorGrid(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local Holder, Row = self:MakeRow(22)
        New("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)

        local Grid = {
            Type = "ColorPicker",
            Value = Config.Default or Palette[1],
        }
        local Colors = Config.Colors
        if Config.WithWhite then
            Colors = { Color3.new(1, 1, 1) }
            for _, Col in ipairs(Config.Colors or Palette) do
                if not SameColor(Col, Color3.fromRGB(225, 225, 225)) then
                    table.insert(Colors, Col)
                end
            end
        end
        local Hooks = nil
        if Config.OnHover or Config.OnHoverEnd then
            Hooks = { Enter = Config.OnHover, Leave = Config.OnHoverEnd }
        end
        local _, Paint = SwatchGrid(Holder, 2, function(Col)
            Grid:SetValue(Col)
        end, Colors, Hooks)

        function Grid:SetValue(Value)
            if typeof(Value) ~= "Color3" then
                return
            end
            self.Value = Value
            Paint(Value)
            SafeCall(Config.Callback, Value)
        end

        Paint(Grid.Value)
        Library.Options[Index] = Grid
        return Grid
    end

    function Funcs:AddSegmented(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local _, Row = self:MakeRow(30)
        New("TextLabel", {
            Size = UDim2.new(1, -160, 1, 0),
            BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
            Font = Enum.Font.GothamSemibold,
            TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, Row)
        local Holder = New("Frame", {
            Size = UDim2.fromOffset(152, 28),
            Position = UDim2.new(1, -152, 0.5, -14),
            BackgroundColor3 = Scheme.PanelColor,
            BackgroundTransparency = 0.1,
            BorderSizePixel = 0,
        }, Row)
        Corner(Holder, 8)
        Stroke(Holder, 1.2, 0.1)
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 3),
            PaddingRight = UDim.new(0, 3),
            PaddingTop = UDim.new(0, 3),
            PaddingBottom = UDim.new(0, 3),
        }, Holder)
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 3),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Holder)

        local Values = Config.Values or {}
        local Segmented = { Type = "Dropdown", Values = Values, Value = nil }
        local Buttons = {}

        local function Paint()
            for Value, Btn in pairs(Buttons) do
                local Selected = Value == Segmented.Value
                Btn.BackgroundTransparency = Selected and 0.05 or 1
                Btn.TextColor3 = Selected and Color3.fromRGB(20, 20, 20) or Scheme.InactiveColor
            end
        end

        for IndexValue, Value in ipairs(Values) do
            local Btn = New("TextButton", {
                Size = UDim2.new(1 / #Values, -3 * (#Values - 1) / #Values, 1, 0),
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = tostring(Value),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                LayoutOrder = IndexValue,
            }, Holder)
            Corner(Btn, 6)
            Register(Btn, "BackgroundColor3")
            Btn.MouseEnter:Connect(function()
                if Value ~= Segmented.Value then
                    Tween(Btn, 0.12, { BackgroundTransparency = 0.85 })
                end
            end)
            Btn.MouseLeave:Connect(function()
                if Value ~= Segmented.Value then
                    Tween(Btn, 0.15, { BackgroundTransparency = 1 })
                end
            end)
            Buttons[Value] = Btn
            Btn.Activated:Connect(function()
                Library:Play("click")
                Segmented:SetValue(Value)
            end)
        end

        function Segmented:SetValue(Value)
            if type(Value) == "number" then
                Value = self.Values[Value]
            end
            if Value == nil or not table.find(self.Values, Value) then
                return
            end
            self.Value = Value
            Paint()
            SafeCall(Config.Callback, Value)
        end

        if type(Config.Default) == "number" then
            Segmented.Value = Values[Config.Default]
        else
            Segmented.Value = Config.Default or Values[1]
        end
        Paint()
        AttachTooltip(Row, Config.Tooltip or Library.Tips[Index])
        Library.Options[Index] = Segmented
        return Segmented
    end

    function Funcs:AddPresetGrid(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local Values = Config.Values or {}
        local Columns = Config.Columns or 3
        local Rows = math.ceil(#Values / Columns)
        local Holder, Row = self:MakeRow(22 + Rows * 50)
        New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = Config.Text or Index,
            TextColor3 = Scheme.FontColor,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Scheme.AlignLeft,
        }, Row)

        local Dropdown = { Type = "Dropdown", Values = Values, Value = nil }
        local Cards = {}

        local function Paint(Selected, Animate)
            for Name, Card in pairs(Cards) do
                local On = Name == Selected
                local Time = Animate and 0.22 or 0
                Tween(Card.Stroke, Time, {
                    Thickness = On and 2.4 or 1,
                    Transparency = On and 0 or 0.7,
                    Color = On and Scheme.AccentColor or Color3.new(1, 1, 1),
                })
                Tween(Card.Check, Time, {
                    TextTransparency = On and 0 or 1,
                    Position = On and UDim2.new(1, -6, 0, 4) or UDim2.new(1, -6, 0, 10),
                }, Enum.EasingStyle.Back)
                Tween(Card.Shade, Time, { BackgroundTransparency = On and 0.55 or 0.35 })
            end
        end

        for IndexValue, Name in ipairs(Values) do
            local Col = (IndexValue - 1) % Columns
            local RowIndex = math.floor((IndexValue - 1) / Columns)
            local Pair = (Config.Colors and Config.Colors[Name])
                or { Color3.fromRGB(120, 120, 120), Color3.fromRGB(40, 40, 40) }
            local Card = New("TextButton", {
                Size = UDim2.new(1 / Columns, -5, 0, 44),
                Position = UDim2.new(Col / Columns, 2, 0, 24 + RowIndex * 50),
                BackgroundColor3 = Pair[1],
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = "",
                ClipsDescendants = true,
            }, Row)
            Corner(Card, 9)
            New("UIGradient", {
                Rotation = 90,
                Color = ColorSequence.new(Pair[1], Pair[2]),
            }, Card)
            local CardStroke = New("UIStroke", {
                Color = Color3.new(1, 1, 1),
                Thickness = 1,
                Transparency = 0.7,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            }, Card)

            local Shade = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 17),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.35,
                BorderSizePixel = 0,
            }, Card)
            New("TextLabel", {
                Size = UDim2.new(1, -4, 1, 0),
                Position = UDim2.fromOffset(2, 0),
                BackgroundTransparency = 1,
                Text = Name,
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold,
                TextSize = 11,
                TextTruncate = Enum.TextTruncate.AtEnd,
            }, Shade)
            local Check = New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -6, 0, 10),
                Size = UDim2.fromOffset(14, 14),
                BackgroundTransparency = 1,
                Text = "\u{2713}",
                TextColor3 = Color3.new(1, 1, 1),
                TextStrokeTransparency = 0.3,
                Font = Enum.Font.GothamBlack,
                TextSize = 14,
                TextTransparency = 1,
            }, Card)
            Cards[Name] = { Stroke = CardStroke, Check = Check, Shade = Shade, Btn = Card }

            Card.MouseEnter:Connect(function()
                Library:Play("hover")
                if Dropdown.Value ~= Name then
                    Tween(CardStroke, 0.15, { Transparency = 0.2, Thickness = 1.6 })
                end
                Tween(Card, 0.18, {
                    Size = UDim2.new(1 / Columns, -3, 0, 46),
                    Position = UDim2.new(Col / Columns, 1, 0, 23 + RowIndex * 50),
                }, Enum.EasingStyle.Back)
            end)
            Card.MouseLeave:Connect(function()
                if Dropdown.Value ~= Name then
                    Tween(CardStroke, 0.2, { Transparency = 0.7, Thickness = 1 })
                end
                Tween(Card, 0.2, {
                    Size = UDim2.new(1 / Columns, -5, 0, 44),
                    Position = UDim2.new(Col / Columns, 2, 0, 24 + RowIndex * 50),
                }, Enum.EasingStyle.Quint)
            end)
            Card.Activated:Connect(function()
                Library:Play("click")
                Dropdown:SetValue(Name)
            end)
        end

        function Dropdown:SetValue(Value)
            if type(Value) == "number" then
                Value = self.Values[Value]
            end
            if Value ~= nil and not table.find(self.Values, Value) then
                return
            end
            self.Value = Value
            Paint(Value, true)
            SafeCall(Config.Callback, Value)
        end

        function Dropdown:SetVisible(Visible)
            Holder.Visible = Visible and true or false
        end

        if type(Config.Default) == "number" then
            Dropdown.Value = Values[Config.Default]
        elseif Config.Default ~= nil then
            Dropdown.Value = Config.Default
        end
        Paint(Dropdown.Value, false)
        AttachTooltip(Row, Config.Tooltip or Library.Tips[Index])
        Library.Options[Index] = Dropdown
        return Dropdown
    end

    function Funcs:AddItemList(Index, Config)
        Config = Config or {}
        local Scheme = Library.Scheme
        local _, Row = self:MakeRow(Config.Height or 150)
        local Frame = New("ScrollingFrame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.55,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(),
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Active = true,
        }, Row)
        Corner(Frame, 8)
        Register(Frame, "ScrollBarImageColor3")
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Frame)
        New("UIPadding", {
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5),
        }, Frame)
        local Empty = New("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
            Text = Config.Empty or "nothing here yet",
            TextColor3 = Scheme.InactiveColor,
                Font = Enum.Font.GothamSemibold,
                TextSize = 12,
                Visible = false,
                ZIndex = 2,
        }, Row)

        local List = {
            Type = "Dropdown",
            Values = {},
            Value = nil,
            Marker = nil,
            Tags = nil,
        }
        local Items = {}
            local RiskColors = {
                legit = Color3.fromRGB(80, 220, 110),
                risky = Color3.fromRGB(255, 190, 60),
                blatant = Color3.fromRGB(255, 80, 80),
            }

        local function Paint()
            for Name, Item in pairs(Items) do
                local Selected = Name == List.Value
                Item.Btn.BackgroundColor3 = Selected and Scheme.AccentColor or Color3.fromRGB(44, 44, 44)
                Item.Btn.BackgroundTransparency = Selected and 0.05 or 0.25
                Item.Name.TextColor3 = Selected and Color3.fromRGB(20, 20, 20) or Scheme.FontColor
                Item.Tag.TextColor3 = Selected and Color3.fromRGB(20, 20, 20) or Scheme.AccentColor
                Item.Tag.Text = (Name == List.Marker) and "autoload" or ""
                local RiskKey = List.Tags and List.Tags[Name]
                local RiskColor = RiskKey and RiskColors[RiskKey]
                Item.Risk.Visible = RiskColor ~= nil
                if RiskColor then
                    Item.Risk.BackgroundColor3 = RiskColor
                    Item.Risk.BackgroundTransparency = Selected and 0.55 or 0.82
                    Item.RiskText.Text = string.upper(RiskKey)
                    Item.RiskText.TextColor3 = Selected and Color3.fromRGB(20, 20, 20) or RiskColor
                    end
                end
            end
        table.insert(Library.AccentHooks, Paint)

        local function Rebuild()
            for _, Item in pairs(Items) do
                Item.Btn:Destroy()
            end
            Items = {}
            for IndexValue, Value in ipairs(List.Values) do
                local Btn = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 28),
                        BorderSizePixel = 0,
                        AutoButtonColor = false,
                        Text = "",
                    LayoutOrder = IndexValue,
                }, Frame)
                Corner(Btn, 7)
                local NameLbl = New("TextLabel", {
                        Size = UDim2.new(1, -140, 1, 0),
                        Position = UDim2.fromOffset(10, 0),
                        BackgroundTransparency = 1,
                    Text = tostring(Value),
                        Font = Enum.Font.GothamBold,
                        TextSize = 13,
                    TextXAlignment = Scheme.AlignLeft,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                }, Btn)
                local Risk = New("Frame", {
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -6, 0.5, 0),
                        Size = UDim2.fromOffset(58, 18),
                        BorderSizePixel = 0,
                        Visible = false,
                }, Btn)
                Corner(Risk, 9)
                local RiskText = New("TextLabel", {
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1,
                        Text = "",
                        Font = Enum.Font.GothamBold,
                        TextSize = 10,
                }, Risk)
                local Tag = New("TextLabel", {
                        Size = UDim2.fromOffset(56, 28),
                        Position = UDim2.new(1, -124, 0, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        Font = Enum.Font.GothamBold,
                        TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Right,
                }, Btn)
                Btn.MouseEnter:Connect(function()
                    if Value ~= List.Value then
                        Tween(Btn, 0.12, { BackgroundTransparency = 0.08 })
                        end
                    end)
                Btn.MouseLeave:Connect(function()
                    if Value ~= List.Value then
                        Tween(Btn, 0.15, { BackgroundTransparency = 0.25 })
                        end
                    end)
                Items[Value] = {
                    Btn = Btn,
                    Name = NameLbl,
                    Tag = Tag,
                    Risk = Risk,
                    RiskText = RiskText,
                }
                Btn.Activated:Connect(function()
                        Library:Play("click")
                    List:SetValue(Value)
                    end)
                end
            Empty.Visible = #List.Values == 0
            Paint()
            end

        function List:SetValue(Value)
            if Value ~= nil and not table.find(self.Values, Value) then
                    return
                end
            self.Value = Value
            Paint()
            SafeCall(Config.Callback, Value)
        end

        function List:SetValues(Values)
            self.Values = Values or {}
                if self.Value ~= nil and not table.find(self.Values, self.Value) then
                    self.Value = nil
                end
            Rebuild()
        end

        function List:SetMarker(Name)
            self.Marker = Name
            Paint()
        end

        function List:SetTags(Map)
            self.Tags = Map
            Paint()
        end

        Rebuild()
        Library.Options[Index] = List
        return List
    end

    BaseGroupbox.__index = Funcs
end

do
    local SmoothCols, SmoothStarted = {}, false
    Library.SmoothOn = true

    function Library:SetSmoothScroll(Value)
        Library.SmoothOn = Value and true or false
        for _, St in ipairs(SmoothCols) do
            pcall(function()
                St.Col.ScrollingEnabled = not (Library.SmoothOn and UserInputService.MouseEnabled)
                St.Anim = false
            end)
                end
            end

    function Library:RegisterScroll(Col)
        local St = { Col = Col, Target = 0, Hover = false, Anim = false }
        table.insert(SmoothCols, St)
        Col.MouseEnter:Connect(function()
            St.Hover = true
        end)
        Col.MouseLeave:Connect(function()
            St.Hover = false
        end)
        Col.ScrollingEnabled = not (Library.SmoothOn and UserInputService.MouseEnabled)
        if not SmoothStarted then
            SmoothStarted = true
            GiveSignal(UserInputService.InputChanged, function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseWheel or not (Library.SmoothOn and UserInputService.MouseEnabled) then
                    return
                end
                for _, C in ipairs(SmoothCols) do
                    local Pg = C.Col.Parent
                    if C.Hover and Pg and Pg.Visible then
                        if not C.Anim then
                            C.Target = C.Col.CanvasPosition.Y
                        end
                        local MaxY = math.max(0, C.Col.AbsoluteCanvasSize.Y - C.Col.AbsoluteWindowSize.Y)
                        C.Target = math.clamp(C.Target - Input.Position.Z * 64, 0, MaxY)
                        C.Anim = true
                    end
                end
            end)
            GiveSignal(RunService.RenderStepped, function(Dt)
                local Alpha = 1 - math.exp(-Dt * 13)
                for _, C in ipairs(SmoothCols) do
                    if C.Anim then
                        local Y = C.Col.CanvasPosition.Y
                        local D = C.Target - Y
                        if math.abs(D) < 0.4 then
                            C.Col.CanvasPosition = Vector2.new(0, C.Target)
                            C.Anim = false
                        else
                            C.Col.CanvasPosition = Vector2.new(0, Y + D * Alpha)
                        end
                    end
                end
            end)
        end
    end
end

local function MakeColumn(Parent, Pos, Size)
    local Col = New("ScrollingFrame", {
        Position = Pos,
        Size = Size,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
        ScrollBarThickness = 3,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Active = true,
    }, Parent)
    Register(Col, "ScrollBarImageColor3")
    Col.ScrollBarImageTransparency = 0.45
    New("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Col)
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 3),
        PaddingTop = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 8),
    }, Col)
    Library:RegisterScroll(Col)
    return Col
end

local function MakeGroupbox(Column, Order, Name)
    local Box = {
        Name = Name,
        Rows = {},
        Collapsed = false,
        CollapseToken = 0,
        TabName = nil,
    }
    setmetatable(Box, BaseGroupbox)

    local Frame = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        LayoutOrder = Order,
    }, Column)
    Corner(Frame, 8)
    local Outline = New("UIStroke", {
        Color = Library.Scheme.OutlineColor,
        Thickness = 1.5,
        Transparency = 0.15,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, Frame)
    table.insert(Library.OutlineStrokes, Outline)
    Box.Frame = Frame
    Box.Outline = Outline
    Box.Scale = New("UIScale", { Scale = 1 }, Frame)
    Frame.MouseEnter:Connect(function()
        Tween(Outline, 0.2, { Transparency = 0 })
    end)
    Frame.MouseLeave:Connect(function()
        Tween(Outline, 0.28, { Transparency = 0.15 })
    end)
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 18),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 10),
    }, Frame)
    local BoxLay = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Frame)
    Box.Layout = BoxLay

    local RowIndex = 1
    local Head = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = RowIndex,
    }, Frame)

    local Chev = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -11, 0, 9),
        Size = UDim2.fromOffset(22, 22),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, Head)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, Chev)
    local ChevronArms = {}
    for Index = 1, 2 do
        local Arm = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, Index == 1 and -2.8 or 2.8, 0.5, -1),
            Size = UDim2.fromOffset(8, 2),
            Rotation = Index == 1 and 45 or -45,
            BackgroundColor3 = Library.Scheme.InactiveColor,
            BorderSizePixel = 0,
        }, Chev)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Arm)
        ChevronArms[Index] = Arm
    end
    Box.Chevron = Chev
    Box.ChevronArms = ChevronArms

    local function ChevColor(Color, Time)
        for _, Arm in ipairs(ChevronArms) do
            Tween(Arm, Time or 0.2, { BackgroundColor3 = Color })
        end
    end

    New("TextLabel", {
        Size = UDim2.new(1, -22, 0, 18),
                BackgroundTransparency = 1,
        Text = Name,
        TextColor3 = Library.Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
        TextXAlignment = Library.Scheme.AlignLeft,
    }, Head)
    Register(New("Frame", {
        Size = UDim2.fromOffset(TextWidth(Name, 14, Enum.Font.GothamBold) + 6, 2),
        Position = UDim2.fromOffset(0, 20),
        BorderSizePixel = 0,
    }, Head), "BackgroundColor3")

    Head.MouseEnter:Connect(function()
        Tween(Chev, 0.15, { BackgroundTransparency = 0.88 })
        if not Box.Collapsed then
            ChevColor(Library.Scheme.FontColor, 0.15)
        end
    end)
    Head.MouseLeave:Connect(function()
        Tween(Chev, 0.2, { BackgroundTransparency = 1 })
        if not Box.Collapsed then
            ChevColor(Library.Scheme.InactiveColor, 0.2)
        end
    end)
    Head.Activated:Connect(function()
        Library:Play("click")
        Box:SetCollapsed(not Box.Collapsed)
    end)

    local PinBtn = New("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -36, 0, 9),
        Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1,
        Text = "\u{2605}",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextTransparency = 1,
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 4,
    }, Head)
    Register(PinBtn, "TextColor3")

    function Box:RefreshPin()
        local Pinned, Total = Library:SectionPinState(Box)
        local Transparency = 1
        if Total > 0 then
            Transparency = (Pinned == Total) and 0 or ((Pinned > 0) and 0.35 or 0.7)
        end
        Tween(PinBtn, 0.15, { TextTransparency = Transparency })
    end

    function Box:InitPin(TabName)
        if TabName == "Configs" or TabName == "Credits" or TabName == "Favorites" then
                    return
                end
        PinBtn.Visible = true
        table.insert(Library.Boxes, Box)
        task.defer(function()
            Box:RefreshPin()
        end)
    end

    PinBtn.MouseEnter:Connect(function()
        Tween(PinBtn, 0.1, { TextSize = 15, TextTransparency = 0 })
    end)
    PinBtn.MouseLeave:Connect(function()
        Tween(PinBtn, 0.15, { TextSize = 12 })
        Box:RefreshPin()
    end)
    PinBtn.Activated:Connect(function()
        Library:Play("click")
        Library:PinSection(Box)
    end)

    function Box:MakeRow(Height)
        Library.BuildTab = Box.TabName
        Library.BuildBox = Box.Name
        RowIndex = RowIndex + 1
        local Holder = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
            LayoutOrder = RowIndex,
        }, Frame)
        New("UIListLayout", {
            Padding = UDim.new(0, 4),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, Holder)
        local Row = New("Frame", {
            Size = UDim2.new(1, 0, 0, Height),
            BackgroundTransparency = 1,
            LayoutOrder = 1,
        }, Holder)
        table.insert(Box.Rows, Holder)
        Library.LastRow = Holder
        Library.LastInner = Row
        Library.LastBoxObj = Box
        return Holder, Row
    end

    local FactoryMethods = { "AddToggle", "AddSlider", "AddDropdown", "AddColorGrid", "AddInput", "AddSegmented", "AddPresetGrid" }
    for _, M in ipairs(FactoryMethods) do
        local F = Box[M]
        if F then
            Box[M] = function(Self, Idx, Cfg, ...)
                if type(Idx) == "string" and type(Cfg) == "table" then
                    Library.Factory[Idx] = { Method = M, Config = Cfg }
                end
                return F(Self, Idx, Cfg, ...)
            end
        end
    end

    return Box
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    Library:SetNotifySide(WindowInfo.NotifySide)

    local Gui = Library.ScreenGui
    local Scheme = Library.Scheme
    local Title = tostring(WindowInfo.Title or "ware.gg")
    local Cam = workspace.CurrentCamera
    local Vp = Cam and Cam.ViewportSize or Vector2.new(1280, 720)
    local Width = math.clamp(math.floor(Vp.X - 24), 420, 700)
    local Height = math.clamp(math.floor(Vp.Y - 60), 300, 480)
    local Side = (Width < 560) and 104 or 132
    local Top = 34

    local Main = New("Frame", {
            Name = "MainFrame",
            AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Width, Height),
        BackgroundColor3 = Scheme.MainColor,
            BackgroundTransparency = 0.14,
            BorderSizePixel = 0,
            Active = true,
        ClipsDescendants = true,
        ZIndex = 1,
    }, Gui)
    Corner(Main, 10)

    local MainStroke = New("UIStroke", {
            Thickness = 3,
            Transparency = 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, Main)
    local function PaintEdge()
        MainStroke.Color = Scheme.AccentColor:Lerp(Color3.new(1, 1, 1), 0.35)
    end
    PaintEdge()
    table.insert(Library.AccentHooks, PaintEdge)

    local Sweep = New("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
                ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 150, 150)),
                ColorSequenceKeypoint.new(0.75, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
            }),
    }, MainStroke)
    local SweepAngle = 0

    New("UIGradient", {
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0.74, 0.74, 0.74)),
            Rotation = 90,
    }, Main)

    local Scale = New("UIScale", { Scale = 1 }, Main)
    Library.MainFrame = Main
    Library.ScaleObj = Scale
    Library.UserScale = 1

    local Shadow = New("ImageLabel", {
            Name = "Shadow",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6014261993",
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0.4,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 0,
    }, Gui)
    local Halo = New("ImageLabel", {
            Name = "Halo",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "rbxassetid://6014261993",
            ImageTransparency = 0.5,
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(49, 49, 450, 450),
            ZIndex = 0,
    }, Gui)
    Register(Halo, "ImageColor3")

    local function SyncShadow()
        local Abs = Main.AbsoluteSize
        Shadow.Size = UDim2.fromOffset(Abs.X + 64, Abs.Y + 64)
        Shadow.Position = Main.Position
        Shadow.Visible = Main.Visible
        Halo.Size = UDim2.fromOffset(Abs.X + 44, Abs.Y + 44)
        Halo.Position = Main.Position
        Halo.Visible = Main.Visible
    end
    GiveSignal(Main:GetPropertyChangedSignal("AbsoluteSize"), SyncShadow)
    GiveSignal(Main:GetPropertyChangedSignal("Position"), SyncShadow)
    GiveSignal(Main:GetPropertyChangedSignal("Visible"), SyncShadow)
    SyncShadow()
    table.insert(Library.PrimaryRegs, Main)

    local TopGlow = New("Frame", {
            Size = UDim2.new(1, -4, 0, 190),
            Position = UDim2.fromOffset(2, 2),
            BorderSizePixel = 0,
    }, Main)
    Corner(TopGlow, 9)
    local TopGlowGrad = New("UIGradient", { Rotation = 90 }, TopGlow)
    Register(TopGlow, "BackgroundColor3")

    local function ApplyGlow()
        local Intensity = Library.GlowIntensity or 1
        local Base = math.clamp(1 - 0.36 * Intensity, 0, 1)
        local Peak = math.clamp(1 - 0.9 * Intensity, 0, 1)
        Sweep.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, Base),
            NumberSequenceKeypoint.new(0.4, Base),
            NumberSequenceKeypoint.new(0.75, Peak),
            NumberSequenceKeypoint.new(1, Peak),
        })
        TopGlowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, math.clamp(1 - 0.62 * Intensity, 0, 1)),
            NumberSequenceKeypoint.new(0.4, math.clamp(1 - 0.34 * Intensity, 0, 1)),
                NumberSequenceKeypoint.new(1, 1),
            })
        end
    Library.ApplyGlow = ApplyGlow
    ApplyGlow()

    local Sheen = New("Frame", {
        Size = UDim2.fromScale(1, 1),
            BorderSizePixel = 0,
    }, Main)
    Corner(Sheen, 10)
    Register(Sheen, "BackgroundColor3")
    local SheenGrad = New("UIGradient", {
            Rotation = 25,
            Offset = Vector2.new(-1, 0),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.38, 1),
                NumberSequenceKeypoint.new(0.5, 0.88),
                NumberSequenceKeypoint.new(0.62, 1),
                NumberSequenceKeypoint.new(1, 1),
            }),
    }, Sheen)
    TweenService:Create(SheenGrad, TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 1.2), {
            Offset = Vector2.new(1, 0),
        }):Play()

    local SpotHolder = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1,
            Visible = false,
    }, Main)
    local SpotRings = {}
    for Index = 1, 8 do
        local Diam = 50 + Index * 42
        local Ring = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.fromOffset(Diam, Diam),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
        }, SpotHolder)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Ring)
        Register(Ring, "BackgroundColor3")
        SpotRings[Index] = Ring
    end
    local SpotX, SpotY, SpotS = 0, 0, 0

    local TitleLabel = New("TextLabel", {
        Size = UDim2.new(1, -90, 0, Top),
            Position = UDim2.fromOffset(14, 0),
            BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Scheme.FontColor,
            TextStrokeTransparency = 0.6,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
        TextXAlignment = Scheme.AlignLeft,
            ZIndex = 4,
    }, Main)
    local TitleGrad = New("UIGradient", {}, TitleLabel)
    local function PaintTitle()
        TitleGrad.Color = ColorSequence.new(Color3.new(1, 1, 1), Scheme.AccentColor:Lerp(Color3.new(1, 1, 1), 0.35))
    end
    PaintTitle()
    table.insert(Library.AccentHooks, PaintTitle)
    TitleGrad.Offset = Vector2.new(-0.45, 0)
    TweenService:Create(TitleGrad, TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Offset = Vector2.new(0.45, 0),
        }):Play()

    local TitleLine = New("Frame", {
            Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.fromOffset(0, Top),
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            ZIndex = 3,
    }, Main)
    local TitleLineGrad = New("UIGradient", {
            Offset = Vector2.new(-0.25, 0),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.08),
                NumberSequenceKeypoint.new(0.8, 0.08),
                NumberSequenceKeypoint.new(1, 1),
            }),
    }, TitleLine)
    TweenService:Create(TitleLineGrad, TweenInfo.new(3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Offset = Vector2.new(0.25, 0),
        }):Play()
    Register(TitleLine, "BackgroundColor3")

    local DragBar = New("Frame", {
        Size = UDim2.new(1, -40, 0, Top),
        BackgroundTransparency = 1,
        Active = true,
        ZIndex = 5,
    }, Main)

    local CollapseBtn = New("TextButton", {
            Size = UDim2.fromOffset(22, 22),
            Position = UDim2.new(1, -30, 0, 6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.4,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 6,
    }, Main)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, CollapseBtn)
    local CollapseStroke = Stroke(CollapseBtn, 1.4, 0.35)
    local CollapseDash = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(9, 2),
            BorderSizePixel = 0,
            ZIndex = 7,
    }, CollapseBtn)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, CollapseDash)
    Register(CollapseDash, "BackgroundColor3")
    CollapseBtn.MouseEnter:Connect(function()
        Tween(CollapseBtn, 0.2, {
            BackgroundTransparency = 0.15,
            Size = UDim2.fromOffset(24, 24),
            Position = UDim2.new(1, -31, 0, 5),
        }, Enum.EasingStyle.Back)
        Tween(CollapseStroke, 0.2, { Thickness = 2, Transparency = 0 })
        Tween(CollapseDash, 0.2, { Size = UDim2.fromOffset(12, 2) }, Enum.EasingStyle.Back)
    end)
    CollapseBtn.MouseLeave:Connect(function()
        Tween(CollapseBtn, 0.25, {
            BackgroundTransparency = 0.4,
            Size = UDim2.fromOffset(22, 22),
            Position = UDim2.new(1, -30, 0, 6),
        }, Enum.EasingStyle.Quint)
        Tween(CollapseStroke, 0.25, { Thickness = 1.4, Transparency = 0.35 })
        Tween(CollapseDash, 0.25, { Size = UDim2.fromOffset(9, 2) }, Enum.EasingStyle.Quint)
    end)
    CollapseBtn.MouseButton1Down:Connect(function()
        Tween(CollapseBtn, 0.08, {
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.new(1, -28, 0, 8),
        })
    end)

    local Mini = New("TextButton", {
            AnchorPoint = Vector2.new(1, 0),
            Size = UDim2.fromOffset(220, 34),
        BackgroundColor3 = Scheme.MainColor,
            BackgroundTransparency = 0.08,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 22,
    }, Gui)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, Mini)
    local MiniStroke = Stroke(Mini, 1.35, 0.1)
    table.insert(Library.PrimaryRegs, Mini)
    local MiniDot = New("Frame", {
            Position = UDim2.new(0, 14, 0.5, -4),
            Size = UDim2.fromOffset(8, 8),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            ZIndex = 23,
    }, Mini)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, MiniDot)
    Register(MiniDot, "BackgroundColor3")
    TweenService:Create(MiniDot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.fromOffset(6, 6),
        Position = UDim2.new(0, 15, 0.5, -3),
    }):Play()
    local MiniTitle = New("TextLabel", {
            Position = UDim2.fromOffset(32, 0),
            Size = UDim2.new(1, -90, 1, 0),
            BackgroundTransparency = 1,
        Text = string.upper(Title),
        TextColor3 = Scheme.FontColor,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
        TextXAlignment = Scheme.AlignLeft,
            TextTransparency = 1,
            ZIndex = 23,
    }, Mini)
    local MiniHint = New("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -14, 0, 0),
            Size = UDim2.fromOffset(60, 34),
            BackgroundTransparency = 1,
            Text = "OPEN  +",
            TextColor3 = Color3.fromRGB(150, 150, 150),
            Font = Enum.Font.GothamBold,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextTransparency = 1,
            ZIndex = 23,
    }, Mini)
    Mini.MouseEnter:Connect(function()
        Tween(MiniStroke, 0.2, { Thickness = 2, Transparency = 0 })
        Tween(MiniHint, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
    end)
    Mini.MouseLeave:Connect(function()
        Tween(MiniStroke, 0.25, { Thickness = 1.35, Transparency = 0.1 })
        Tween(MiniHint, 0.25, { TextColor3 = Color3.fromRGB(150, 150, 150) })
    end)

    local PosScaleX, PosScaleY = Main.Position.X.Scale, Main.Position.Y.Scale
    local TargetX, TargetY, CurrentX, CurrentY = 0, 0, 0, 0
    DragBar.InputBegan:Connect(function(Input)
        local Kind = Input.UserInputType
        if Kind == Enum.UserInputType.MouseButton1 or Kind == Enum.UserInputType.Touch then
            local StartX, StartY = TargetX, TargetY
            local StartIn = Input.Position
            Library.WinDrag = function(Pos)
                local Delta = Pos - StartIn
                TargetX, TargetY = StartX + Delta.X, StartY + Delta.Y
                end
            end
        end)

    GiveSignal(UserInputService.InputChanged, function(Input)
        if Library.WinDrag and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
            Library.WinDrag(Input.Position)
        end
    end)
    GiveSignal(UserInputService.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            Library.WinDrag = nil
        end
    end)

    GiveSignal(RunService.RenderStepped, function(Dt)
        if not Main.Visible then
                return
            end
        local AbsPos, AbsSize = Main.AbsolutePosition, Main.AbsoluteSize
        local Mouse = UserInputService:GetMouseLocation()
        local ScaleValue = Scale.Scale
        local Near = Mouse.X >= AbsPos.X - 90
            and Mouse.X <= AbsPos.X + AbsSize.X + 90
            and Mouse.Y >= AbsPos.Y - 90
            and Mouse.Y <= AbsPos.Y + AbsSize.Y + 90
        local TargetAngle
        if Near then
            TargetAngle = math.deg(math.atan2(Mouse.Y - (AbsPos.Y + AbsSize.Y / 2), Mouse.X - (AbsPos.X + AbsSize.X / 2)))
        else
            TargetAngle = (os.clock() * 55) % 360
        end
        local Diff = ((TargetAngle - SweepAngle + 540) % 360) - 180
        SweepAngle = SweepAngle + Diff * (1 - math.exp(-Dt * (Near and 12 or 3)))
        Sweep.Rotation = SweepAngle % 360

        local Glow = Library.GlowIntensity or 1
        Halo.ImageTransparency = math.clamp(1 - Glow * (0.5 + 0.18 * math.sin(os.clock() * 1.8)), 0, 1)

        local Inside = Mouse.X >= AbsPos.X
            and Mouse.X <= AbsPos.X + AbsSize.X
            and Mouse.Y >= AbsPos.Y
            and Mouse.Y <= AbsPos.Y + AbsSize.Y
        local Want = (Library.CursorLight and Inside and UserInputService.MouseEnabled) and 1 or 0
        SpotS = SpotS + (Want - SpotS) * (1 - math.exp(-Dt * 9))
        if SpotS < 0.01 then
            SpotHolder.Visible = false
        else
            local RelX, RelY = (Mouse.X - AbsPos.X) / ScaleValue, (Mouse.Y - AbsPos.Y) / ScaleValue
            SpotX = SpotX + (RelX - SpotX) * (1 - math.exp(-Dt * 14))
            SpotY = SpotY + (RelY - SpotY) * (1 - math.exp(-Dt * 14))
            SpotHolder.Position = UDim2.fromOffset(SpotX, SpotY)
            SpotHolder.Visible = true
            local Fade = 1 - 0.03 * SpotS * math.clamp(Glow, 0, 1.5)
            for _, Ring in ipairs(SpotRings) do
                Ring.BackgroundTransparency = Fade
                end
            end

        if CurrentX ~= TargetX or CurrentY ~= TargetY then
            local Alpha = 1 - math.exp(-Dt * 22)
            CurrentX = CurrentX + (TargetX - CurrentX) * Alpha
            CurrentY = CurrentY + (TargetY - CurrentY) * Alpha
            if math.abs(TargetX - CurrentX) < 0.05 then
                CurrentX = TargetX
            end
            if math.abs(TargetY - CurrentY) < 0.05 then
                CurrentY = TargetY
            end
            Main.Position = UDim2.new(PosScaleX, CurrentX, PosScaleY, CurrentY)
            end
        end)

    local Sidebar = New("Frame", {
        Size = UDim2.new(0, Side, 1, -Top),
        Position = UDim2.fromOffset(0, Top),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
    }, Main)
    New("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Sidebar)
    New("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
    }, Sidebar)
    Register(New("Frame", {
        Size = UDim2.new(0, 1, 1, -Top),
        Position = UDim2.fromOffset(Side, Top),
            BorderSizePixel = 0,
            BackgroundTransparency = 0.5,
            ZIndex = 3,
    }, Main), "BackgroundColor3")

    local ContentHost = New("Frame", {
        Position = UDim2.fromOffset(Side, Top),
        Size = UDim2.new(1, -Side, 1, -Top),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 2,
    }, Main)

    local AvatarImage = ""
        task.spawn(function()
        local Ok, Img = pcall(function()
            return Players:GetUserThumbnailAsync(
                LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size150x150
            )
        end)
        if Ok and Img then
            AvatarImage = Img
            Library.AvatarImage = Img
            end
        end)

    local ProfileBtn = New("TextButton", {
        Size = UDim2.new(0, Side - 16, 0, 30),
            Position = UDim2.new(0, 8, 1, -66),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.55,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 3,
    }, Main)
    Corner(ProfileBtn, 15)
    local ProfileStroke = Stroke(ProfileBtn, 1, 0.65)
    local ProfileAv = New("ImageLabel", {
            Position = UDim2.fromOffset(4, 4),
            Size = UDim2.fromOffset(22, 22),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0,
            ZIndex = 4,
    }, ProfileBtn)
    New("UICorner", { CornerRadius = UDim.new(1, 0) }, ProfileAv)
    New("TextLabel", {
            Position = UDim2.fromOffset(32, 0),
            Size = UDim2.new(1, -38, 1, 0),
            BackgroundTransparency = 1,
            Text = (LocalPlayer and LocalPlayer.DisplayName) or "profile",
            TextColor3 = Color3.fromRGB(190, 190, 190),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
        TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 4,
    }, ProfileBtn)
        task.spawn(function()
            for _ = 1, 40 do
            if AvatarImage ~= "" then
                ProfileAv.Image = AvatarImage
                    return
                end
                task.wait(0.25)
            end
        end)
    ProfileBtn.MouseEnter:Connect(function()
        Tween(ProfileBtn, 0.15, { BackgroundTransparency = 0.3 })
        Tween(ProfileStroke, 0.15, { Transparency = 0, Thickness = 1.6 })
    end)
    ProfileBtn.MouseLeave:Connect(function()
        Tween(ProfileBtn, 0.2, { BackgroundTransparency = 0.55 })
        Tween(ProfileStroke, 0.2, { Transparency = 0.65, Thickness = 1 })
    end)
    ProfileBtn.Activated:Connect(function()
            Library:ShowProfile()
        end)

    local Indicator = New("Frame", {
            Size = UDim2.fromOffset(3, 18),
        Position = UDim2.fromOffset(11, Top + 14),
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = 4,
    }, Main)
    Corner(Indicator, 2)
    Register(Indicator, "BackgroundColor3")

    local Window = {
        Tabs = {},
        Main = Main,
        Sidebar = Sidebar,
        ContentHost = ContentHost,
        Side = Side,
        Top = Top,
        Width = Width,
        Height = Height,
        Mini = Mini,
        Indicator = Indicator,
    }
    local Tabs = Window.Tabs

    local function PaintTabs()
        for _, Tab in ipairs(Tabs) do
            Tween(Tab.Button, 0.18, {
                TextColor3 = Tab.Selected and Scheme.FontColor or Scheme.InactiveColor,
                BackgroundTransparency = Tab.Selected and 0.82 or 1,
            })
            if Tab.Icon then
                Tween(Tab.Icon, 0.18, {
                    TextColor3 = Tab.Selected and Scheme.FontColor or Scheme.InactiveColor,
                })
                end
            end
        end

    local function PlayEntrance(Tab)
        for Index, Box in ipairs(Tab.Boxes) do
            Box.Scale.Scale = 0.965
            Box.Frame.BackgroundTransparency = 0.9
            Box.Outline.Transparency = 0.9
            task.delay((Index - 1) * 0.045, function()
                if not Tab.Selected or not Box.Frame.Parent then
                        return
                    end
                Tween(Box.Scale, 0.38, { Scale = 1 }, Enum.EasingStyle.Quint)
                Tween(Box.Frame, 0.3, { BackgroundTransparency = 0.5 })
                Tween(Box.Outline, 0.3, { Transparency = 0.15 })
                end)
            end
        end

    local OpenToken = 0
    local function SetOpen(Open, FromMini)
        Library.Toggled = Open and true or false
        Library:Play(Open and "open" or "close")
        Mini.Visible = false
        OpenToken = OpenToken + 1
        local Mine = OpenToken
        local Base = Library.UserScale or 1
        if Open then
            if not Library.Welcomed then
                Library.Welcomed = true
                    if Library.OnFirstOpen then
                        task.spawn(Library.OnFirstOpen)
                    end
                end
            if FromMini then
                local OrigPos = Main.Position
                Main.Position = UDim2.new(
                    OrigPos.X.Scale,
                    OrigPos.X.Offset + math.floor(Width * Base / 2) - 17,
                    OrigPos.Y.Scale,
                    OrigPos.Y.Offset - math.floor(Height * Base / 2) + 17
                )
                Scale.Scale = Base * 0.03
                Main.Visible = true
                Tween(Scale, 0.5, { Scale = Base }, Enum.EasingStyle.Quint)
                Tween(Main, 0.5, { Position = OrigPos }, Enum.EasingStyle.Quint)
            else
                Scale.Scale = Base * 0.55
                Main.Visible = true
                Tween(Scale, 0.42, { Scale = Base }, Enum.EasingStyle.Back)
                end
                task.defer(function()
                for Index, Tab in ipairs(Tabs) do
                    Tab.Button.TextTransparency = 1
                    if Tab.Icon then
                        Tab.Icon.TextTransparency = 1
                    end
                    task.delay(0.05 + (Index - 1) * 0.04, function()
                        if Tab.Button.Parent then
                            Tween(Tab.Button, 0.3, { TextTransparency = 0 })
                            if Tab.Icon then
                                Tween(Tab.Icon, 0.3, { TextTransparency = 0 })
                                end
                            end
                        end)
                    if Tab.Selected then
                        PlayEntrance(Tab)
                        end
                    end
                end)
            else
            Tween(Scale, 0.42, { Scale = Base * 0.02 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
                task.delay(0.44, function()
                if OpenToken == Mine then
                    Main.Visible = false
                    Scale.Scale = Base
                    end
                end)
            end
        SyncShadow()
    end

    function Window:Toggle()
        SetOpen(not Library.Toggled)
    end

    function Window:SetVisible(Visible)
        SetOpen(Visible and true or false)
    end

    function Window:Select(Tab)
        for _, Entry in ipairs(Tabs) do
            local Was = Entry.Selected
            Entry.Selected = Entry == Tab
            Entry.Page.Visible = Entry.Selected
            if Entry.Selected and not Was then
                Entry.Page.Position = UDim2.fromOffset(Side + 15, Top + 1)
                Tween(Entry.Page, 0.24, {
                    Position = UDim2.fromOffset(Side + 1, Top + 1),
                }, Enum.EasingStyle.Quint)
                PlayEntrance(Entry)
                if Entry.Pop then
                    Entry.Pop()
                end
            end
        end
        local Index = table.find(Tabs, Tab) or 1
        local YPos = UDim2.fromOffset(11, Top + 8 + (Index - 1) * 33 + 6)
        if Indicator.Visible then
            Tween(Indicator, 0.3, { Position = YPos }, Enum.EasingStyle.Quint)
        else
            Indicator.Position = YPos
            Indicator.Visible = true
        end
        PaintTabs()
    end

    function Window:AddTab(Name, Icon)
        local Tab = {
            Name = Name,
            Selected = false,
            Boxes = {},
        }

        Tab.Button = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "       " .. Name,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextColor3 = Scheme.InactiveColor,
            TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
            AutoButtonColor = false,
            LayoutOrder = #Tabs + 1,
        }, Sidebar)
        Corner(Tab.Button, 7)
        Register(Tab.Button, "BackgroundColor3")
        local TabPad = New("UIPadding", {
            PaddingLeft = UDim.new(0, 12),
        }, Tab.Button)
        Tab.Icon = New("TextLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(20, 20),
            BackgroundTransparency = 1,
            Text = Icon or TabIcons[Name] or "\u{2022}",
            TextColor3 = Scheme.InactiveColor,
            Font = Enum.Font.GothamBold,
            TextSize = 15,
        }, Tab.Button)

        function Tab.Pop()
            Tab.Icon.Rotation = 0
            Tab.Icon.TextSize = 15
            Tween(Tab.Icon, 0.13, {
                TextSize = 21,
                Rotation = -16,
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            task.delay(0.13, function()
                if Tab.Icon.Parent then
                    Tween(Tab.Icon, 0.55, {
                        TextSize = 15,
                        Rotation = 0,
                    }, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                end
            end)
        end

        Tab.Button.MouseEnter:Connect(function()
            Tween(Tab.Icon, 0.18, {
                Rotation = 12,
                TextSize = 17,
            }, Enum.EasingStyle.Back)
        end)
        Tab.Button.MouseLeave:Connect(function()
            Tween(Tab.Icon, 0.3, {
                Rotation = 0,
                TextSize = 15,
            }, Enum.EasingStyle.Quint)
        end)
        Tab.Button.MouseEnter:Connect(function()
            Tween(TabPad, 0.2, {
                PaddingLeft = UDim.new(0, 17),
            }, Enum.EasingStyle.Quint)
            if not Tab.Selected then
                Tween(Tab.Button, 0.12, {
                    BackgroundTransparency = 0.92,
                    TextColor3 = Color3.fromRGB(195, 195, 195),
                })
            end
        end)
        Tab.Button.MouseLeave:Connect(function()
            Tween(TabPad, 0.25, {
                PaddingLeft = UDim.new(0, 12),
            }, Enum.EasingStyle.Quint)
            if not Tab.Selected then
                Tween(Tab.Button, 0.15, {
                    BackgroundTransparency = 1,
                    TextColor3 = Scheme.InactiveColor,
                })
            end
        end)

        Tab.Page = New("Frame", {
            Name = Name .. "Page",
            Position = UDim2.fromOffset(Side + 1, Top + 1),
            Size = UDim2.new(1, -(Side + 1), 1, -(Top + 1)),
            BackgroundTransparency = 1,
            Visible = false,
        }, Main)
        local LeftCol = MakeColumn(Tab.Page, UDim2.fromOffset(8, 8), UDim2.new(0.5, -12, 1, -16))
        local RightCol = MakeColumn(Tab.Page, UDim2.new(0.5, 4, 0, 8), UDim2.new(0.5, -12, 1, -16))

        local LeftOrder, RightOrder = 0, 0
        function Tab:AddLeftGroupbox(GroupName)
            LeftOrder = LeftOrder + 1
            local Box = MakeGroupbox(LeftCol, LeftOrder, GroupName)
            Box.TabName = Name
            Box:InitPin(Name)
            table.insert(Tab.Boxes, Box)
            return Box
        end
        function Tab:AddRightGroupbox(GroupName)
            RightOrder = RightOrder + 1
            local Box = MakeGroupbox(RightCol, RightOrder, GroupName)
            Box.TabName = Name
            Box:InitPin(Name)
            table.insert(Tab.Boxes, Box)
            return Box
        end
        function Tab:AddGroupbox(GroupConfig)
            GroupConfig = GroupConfig or {}
            local SideName = tostring(GroupConfig.Side or "Left")
            local GroupName = GroupConfig.Name or GroupConfig.Title or "group"
            if string.lower(SideName) == "right" then
                return self:AddRightGroupbox(GroupName)
            end
            return self:AddLeftGroupbox(GroupName)
        end

        table.insert(Tabs, Tab)
        Tab.Button.Activated:Connect(function()
            Library:Play("click")
            Window:Select(Tab)
        end)
        if #Tabs == 1 then
            Window:Select(Tab)
        end
        return Tab
    end

    CollapseBtn.Activated:Connect(function()
        local UserScale = Library.UserScale or 1
        OpenToken = OpenToken + 1
        local Mine = OpenToken
        Library.Toggled = false
        local OrigPos = Main.Position
        local MiniPos = UDim2.new(
            OrigPos.X.Scale,
            OrigPos.X.Offset + math.floor(Width * UserScale / 2),
            OrigPos.Y.Scale,
            OrigPos.Y.Offset - math.floor(Height * UserScale / 2)
        )
        local Dest = UDim2.new(
            OrigPos.X.Scale,
            OrigPos.X.Offset + math.floor(Width * UserScale / 2) - 17,
            OrigPos.Y.Scale,
            OrigPos.Y.Offset - math.floor(Height * UserScale / 2) + 17
        )
        Tween(Scale, 0.42, { Scale = UserScale * 0.03 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
        Tween(Main, 0.42, { Position = Dest }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            task.delay(0.43, function()
            if OpenToken ~= Mine then
                    return
                end
            Mini.Position = MiniPos
            Main.Position = OrigPos
            Scale.Scale = UserScale
            Main.Visible = false
            Mini.Size = UDim2.fromOffset(34, 34)
            Mini.BackgroundTransparency = 1
            MiniDot.BackgroundTransparency = 1
            MiniTitle.TextTransparency = 1
            MiniHint.TextTransparency = 1
            Mini.Visible = true
            Tween(Mini, 0.45, {
                Size = UDim2.fromOffset(220, 34),
                BackgroundTransparency = 0.08,
            }, Enum.EasingStyle.Back)
            Tween(MiniDot, 0.3, { BackgroundTransparency = 0 })
                task.delay(0.12, function()
                if OpenToken == Mine then
                    Tween(MiniTitle, 0.3, { TextTransparency = 0 })
                    Tween(MiniHint, 0.3, { TextTransparency = 0 })
                    end
                end)
            SyncShadow()
            end)
        end)

    Mini.Activated:Connect(function()
        SetOpen(true, true)
    end)

    GiveSignal(UserInputService.InputBegan, function(Input, GameProcessed)
        if GameProcessed then
            return
        end
        if Input.KeyCode == Library.ToggleKeybind then
            Window:Toggle()
        end
    end)

    local SearchBox = New("TextBox", {
            Size = UDim2.fromOffset(130, 22),
            Position = UDim2.new(1, -168, 0, 6),
        BackgroundColor3 = Scheme.PanelColor,
            BackgroundTransparency = 0.25,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamBold,
            TextSize = 12,
        TextColor3 = Scheme.FontColor,
            PlaceholderText = "\u{1F50D} search",
        PlaceholderColor3 = Scheme.InactiveColor,
            Text = "",
            ClearTextOnFocus = false,
        TextXAlignment = Scheme.AlignLeft,
            ZIndex = 7,
    }, Main)
    Corner(SearchBox, 8)
    New("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 6) }, SearchBox)
    local SearchStroke = Stroke(SearchBox, 1, 0.55)
    SearchBox.Focused:Connect(function()
        Tween(SearchStroke, 0.15, { Thickness = 1.8, Transparency = 0 })
    end)
    SearchBox.FocusLost:Connect(function()
        Tween(SearchStroke, 0.2, { Thickness = 1, Transparency = 0.55 })
    end)
    Library.SearchBox = SearchBox
    AttachTooltip(SearchBox, "Search every setting. Press Ctrl+K anywhere to jump here.")

    local HlList = {}
    local function ClearHL()
        for _, O in ipairs(HlList) do
            pcall(function() O:Destroy() end)
        end
        HlList = {}
    end

    local function HighlightRow(Row, Q)
        for _, D in ipairs(Row:GetDescendants()) do
            if D:IsA("TextLabel") and D.Text ~= "" and D.TextXAlignment == Scheme.AlignLeft then
                local SPos, EPos = string.find(string.lower(D.Text), Q, 1, true)
                if SPos then
                    local Pre = string.sub(D.Text, 1, SPos - 1)
                    local X = (Pre == "") and 0 or TextWidth(Pre, D.TextSize, D.Font)
                    local W = TextWidth(string.sub(D.Text, SPos, EPos), D.TextSize, D.Font)
                    local Hl = New("Frame", {
                        Position = UDim2.new(0, X - 2, 0.5, -9),
                        Size = UDim2.fromOffset(W + 4, 18),
                        BackgroundColor3 = Scheme.AccentColor,
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                        ZIndex = D.ZIndex + 1,
                    }, D)
                    Corner(Hl, 5)
                    Tween(Hl, 0.25, { BackgroundTransparency = 0.7 })
                    HlList[#HlList + 1] = Hl
                    end
                end
            end
        end

    local function RowText(Row)
        local Parts = {}
        for _, D in ipairs(Row:GetDescendants()) do
            if (D:IsA("TextLabel") or D:IsA("TextButton")) and D.Text ~= "" then
                Parts[#Parts + 1] = D.Text
                end
            end
        return string.lower(table.concat(Parts, " "))
    end

    local function SetRowShown(Row, Show)
        if Show then
            if Row:GetAttribute("SearchHidden") then
                Row:SetAttribute("SearchHidden", nil)
                Row.Visible = Row:GetAttribute("PrevVisible") ~= false
                end
            else
            if not Row:GetAttribute("SearchHidden") then
                Row:SetAttribute("PrevVisible", Row.Visible)
                Row:SetAttribute("SearchHidden", true)
            end
            Row.Visible = false
            end
        end

    local function ApplySearch(Q)
        Q = string.lower((tostring(Q or ""):gsub("^%s+", ""):gsub("%s+$", "")))
        local Counts = {}
        ClearHL()
        for _, T in ipairs(Tabs) do
            local Total = 0
            for _, Gb in ipairs(T.Boxes) do
                local Any = false
                local NameHit = Q ~= "" and string.find(string.lower(Gb.Name or ""), Q, 1, true) ~= nil
                for _, Row in ipairs(Gb.Rows) do
                    local Show = true
                    if Q ~= "" and not NameHit then
                        Show = string.find(RowText(Row), Q, 1, true) ~= nil
                    elseif Q ~= "" and NameHit then
                        Show = RowText(Row) ~= ""
                    end
                    SetRowShown(Row, Show)
                    if Show then
                        Any = true
                        if Q ~= "" and not NameHit then
                            HighlightRow(Row, Q)
                            end
                        end
                    end
                Gb.Frame.Visible = (Q == "") or Any
                if Q ~= "" and Any and Gb.SetCollapsed then
                    Gb:SetCollapsed(false)
                end
                if Q ~= "" and Any then
                    Total = Total + 1
                    end
                end
            Counts[T] = Total
        end
        if Q ~= "" then
            local Cur
            for _, T in ipairs(Tabs) do
                if T.Selected then Cur = T end
            end
            if Cur and Counts[Cur] == 0 then
                for _, T in ipairs(Tabs) do
                    if Counts[T] > 0 then
                        Window:Select(T)
                            break
                        end
                    end
                end
            end
        end
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        ApplySearch(SearchBox.Text)
        end)

        do
            local FavFile, RecFile = "ware.gg/favorites.txt", "ware.gg/recent.txt"
            local MaxFav, MaxRec = 14, 5
        local NoStar = { Configs = true, Credits = true, Favorites = true }
        local Suggest = { "Hitbox", "AutoWeave", "SmartWeave", "ESPEnabled", "FOVEnabled", "RainbowAccent" }
        local FavOrder, FavSet, Recents = {}, {}, {}
        local RowOf, InnerOf, BoxOf, TabOf, StarOf, RowKeyed = {}, {}, {}, {}, {}, {}
        local Pins, Syncing = {}, {}
        local FavBox, EmptyLbl

        local function ReadList(Path)
            local Out = {}
            if isfile and readfile and isfile(Path) then
                local Ok, Txt = pcall(readfile, Path)
                if Ok and Txt then
                    for K in string.gmatch(Txt, "[^,%s]+") do
                        Out[#Out + 1] = K
                        end
                    end
                end
            return Out
        end
        local function WriteList(Path, List)
            if not writefile then return end
                if makefolder and isfolder and not isfolder("ware.gg") then
                    pcall(makefolder, "ware.gg")
                end
            pcall(writefile, Path, table.concat(List, ","))
        end
        Recents = ReadList(RecFile)

        local function UpdateEmpty()
            if EmptyLbl then
                EmptyLbl.Visible = #FavOrder == 0
                end
            end
        local function IdleStar(Key)
            return FavSet[Key] and 0 or 0.72
        end
        local function PaintStar(Key)
            local St = StarOf[Key]
            if St then
                Tween(St, 0.15, { TextTransparency = IdleStar(Key) })
                end
            end

        local function StarPop(St)
            St.Rotation = -28
            Tween(St, 0.12, { TextSize = 20, Rotation = 18 }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                task.delay(0.12, function()
                if St.Parent then
                    Tween(St, 0.5, { TextSize = 13, Rotation = 0 }, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
                    end
                end)
            local Ring = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(6, 6),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 7,
            }, St)
            New("UICorner", { CornerRadius = UDim.new(1, 0) }, Ring)
            local Rs = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 1.6, Transparency = 0.1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Ring)
            Tween(Ring, 0.45, { Size = UDim2.fromOffset(30, 30) }, Enum.EasingStyle.Quint)
            Tween(Rs, 0.45, { Transparency = 1, Thickness = 0.5 })
                task.delay(0.5, function()
                Ring:Destroy()
                end)
            end
        Library.StarPop = StarPop

        local function MakeStar(Inner, C, Key, Solid)
            local St = New("TextButton", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, -16, 0.5, 0),
                    Size = UDim2.fromOffset(14, 18),
                    BackgroundTransparency = 1,
                    Text = "\u{2605}",
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                TextTransparency = Solid and 0 or IdleStar(Key),
                    AutoButtonColor = false,
                    ZIndex = 8,
            }, Inner)
            Register(St, "TextColor3")
            C.MouseEnter:Connect(function()
                if not Solid and not FavSet[Key] then
                    Tween(St, 0.15, { TextTransparency = 0.3 })
                    end
                end)
            C.MouseLeave:Connect(function()
                if not Solid and not FavSet[Key] then
                    Tween(St, 0.2, { TextTransparency = IdleStar(Key) })
                    end
                end)
            St.MouseEnter:Connect(function()
                Tween(St, 0.1, { TextTransparency = 0 })
                end)
            St.MouseLeave:Connect(function()
                Tween(St, 0.15, { TextTransparency = Solid and 0 or IdleStar(Key) })
                end)
            St.Activated:Connect(function()
                    Library:Play("click")
                StarPop(St)
                Library:SetFavorite(Key, not FavSet[Key])
            end)
            return St
        end

        function Library:SetFavoritesBox(Gb)
            FavBox = Gb
            EmptyLbl = New("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundTransparency = 1,
                    Text = "nothing pinned yet. click the star on the left edge of any setting to pin a copy here.",
                TextColor3 = Scheme.InactiveColor,
                    Font = Enum.Font.GothamSemibold,
                    TextSize = 12,
                    TextWrapped = true,
                TextXAlignment = Scheme.AlignLeft,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    LayoutOrder = 2,
            }, Gb.Frame)
            UpdateEmpty()
        end

        function Library:SetFavorite(Key, On, Silent)
            if not FavBox then return false end
            if On then
                local F = Library.Factory[Key]
                local O = Library.Toggles[Key] or Library.Options[Key]
                if FavSet[Key] or not F or not O then return false end
                if #FavOrder >= MaxFav then
                    if not Silent then
                            Library:WindowToast("favorites are full (" .. MaxFav .. ")", 2.5)
                        end
                        return false
                    end
                local Mk = Key .. "__fav"
                SaveManager.Ignore[Mk] = true
                Library.Tips[Mk] = Library.Tips[Key]
                local Cfg2 = {}
                for K, V in pairs(F.Config) do
                    Cfg2[K] = V
                end
                if F.Method == "AddDropdown" or F.Method == "AddSegmented" or F.Method == "AddPresetGrid" then
                    Cfg2.Default = nil
                else
                    Cfg2.Default = O.Value
                end
                Cfg2.Callback = function(V)
                    if Syncing[Key] then return end
                    Syncing[Key] = true
                    pcall(function() O:SetValue(V) end)
                    Syncing[Key] = false
                end
                Syncing[Key] = true
                local OkMake = pcall(function()
                    FavBox[F.Method](FavBox, Mk, Cfg2)
                end)
                local MRow, MInner = Library.LastRow, Library.LastInner
                local Mo = Library.Toggles[Mk] or Library.Options[Mk]
                if Mo and O.Value ~= nil then
                    pcall(function() Mo:SetValue(O.Value) end)
                end
                Syncing[Key] = false
                if not OkMake or not Mo or not MRow then return false end
                FavSet[Key] = true
                FavOrder[#FavOrder + 1] = Key
                Pins[Key] = { Row = MRow, Mk = Mk, O = O, Mo = Mo }
                MakeStar(MInner, MRow, Key, true)
                if not Silent then
                    MRow.Parent = nil
                    MRow.Parent = FavBox.Frame
                    end
                else
                if not FavSet[Key] then return false end
                FavSet[Key] = nil
                local Fi = table.find(FavOrder, Key)
                if Fi then table.remove(FavOrder, Fi) end
                local Pin = Pins[Key]
                Pins[Key] = nil
                if Pin then
                    local I = table.find(FavBox.Rows, Pin.Row)
                    if I then table.remove(FavBox.Rows, I) end
                    Pin.Row:Destroy()
                    Library.Toggles[Pin.Mk] = nil
                    Library.Options[Pin.Mk] = nil
                end
            end
            PaintStar(Key)
            UpdateEmpty()
            if Library.RefreshPins then
                Library.RefreshPins()
            end
            if not Silent then
                WriteList(FavFile, FavOrder)
                end
                return true
            end

        Library.RefreshPins = function()
            for _, Gb in ipairs(Library.Boxes) do
                if Gb.RefreshPin then
                    Gb:RefreshPin()
                    end
                end
            end

        function Library:SectionPinState(Gb)
            local Pinned, Total = 0, 0
            for _, R in ipairs(Gb.Rows) do
                local K = RowKeyed[R]
                if K then
                    Total = Total + 1
                    if FavSet[K] then
                        Pinned = Pinned + 1
                        end
                    end
                end
            return Pinned, Total
        end

        function Library:PinSection(Gb)
            local Keys = {}
            for _, R in ipairs(Gb.Rows) do
                local K = RowKeyed[R]
                if K then Keys[#Keys + 1] = K end
            end
            if #Keys == 0 then
                    Library:WindowToast("nothing in this section can be pinned", 2.5)
                    return
                end
            local All = true
            for _, K in ipairs(Keys) do
                if not FavSet[K] then All = false end
            end
            local Changed, Full = 0, false
            for _, K in ipairs(Keys) do
                if All then
                    if Library:SetFavorite(K, false, true) then Changed = Changed + 1 end
                elseif not FavSet[K] then
                    if Library:SetFavorite(K, true, true) then
                        Changed = Changed + 1
                    elseif #FavOrder >= MaxFav then
                        Full = true
                    end
                end
            end
            WriteList(FavFile, FavOrder)
            if All then
                Library:WindowToast("unpinned " .. Changed .. " from " .. tostring(Gb.Name), 2.5)
            elseif Full then
                Library:WindowToast("pinned " .. Changed .. " (favorites are full)", 2.5)
            else
                Library:WindowToast("pinned " .. Changed .. " from " .. tostring(Gb.Name), 2.5)
                end
            end

            do
            local Acc = 0
            GiveSignal(RunService.Heartbeat, function(Dt)
                Acc = Acc + Dt
                if Acc < 0.2 then return end
                Acc = 0
                for Key, Pin in pairs(Pins) do
                    local A, B = Pin.O.Value, Pin.Mo.Value
                    if typeof(A) ~= "table" and typeof(B) ~= "table" and A ~= B and not Syncing[Key] then
                        Syncing[Key] = true
                        pcall(function() Pin.Mo:SetValue(A) end)
                        Syncing[Key] = false
                        end
                    end
                end)
            end

        local function PushRecent(Key)
            if Recents[1] == Key then return end
            local I = table.find(Recents, Key)
            if I then table.remove(Recents, I) end
            table.insert(Recents, 1, Key)
            while #Recents > MaxRec do
                table.remove(Recents)
            end
            WriteList(RecFile, Recents)
        end

        Library.OnKey = function(Key, TabName, C, Inner, BoxObj)
            if NoStar[TabName or ""] or SaveManager.Ignore[Key] or RowOf[Key] or not C or not Inner or RowKeyed[C] then
                    return
                end
            if not Library.Factory[Key] then return end
            RowKeyed[C] = Key
            RowOf[Key], InnerOf[Key], BoxOf[Key], TabOf[Key] = C, Inner, BoxObj, TabName
            StarOf[Key] = MakeStar(Inner, C, Key, false)
            C.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    PushRecent(Key)
                    end
                end)
            end

            function Library:ApplyFavorites()
            for _, K in ipairs(ReadList(FavFile)) do
                Library:SetFavorite(K, true, true)
            end
            Recents = ReadList(RecFile)
        end

        local function NameOf(Key)
            local Row = RowOf[Key]
            if Row then
                for _, D in ipairs(Row:GetDescendants()) do
                    if D:IsA("TextLabel") and #D.Text > 2 then
                        return D.Text
                        end
                    end
                end
            return Key
        end

        function Library:JumpTo(Key)
            local Row = RowOf[Key]
            if not Row then return end
            local TabObj
            for _, T in ipairs(Tabs) do
                if T.Name == TabOf[Key] then TabObj = T end
            end
            if not TabObj then return end
            if SearchBox.Text ~= "" then SearchBox.Text = "" end
            Window:Select(TabObj)
            local Gb = BoxOf[Key]
            if Gb and Gb.SetCollapsed then Gb:SetCollapsed(false) end
                task.delay(0.4, function()
                local Col = Row:FindFirstAncestorOfClass("ScrollingFrame")
                if Col then
                    local Y = (Row.AbsolutePosition.Y - Col.AbsolutePosition.Y) / math.max(Scale.Scale, 0.01) + Col.CanvasPosition.Y - 24
                    local MaxY = math.max(0, Col.AbsoluteCanvasSize.Y - Col.AbsoluteWindowSize.Y)
                    Tween(Col, 0.4, { CanvasPosition = Vector2.new(0, math.clamp(Y, 0, MaxY)) }, Enum.EasingStyle.Quint)
                end
                local Inner = InnerOf[Key]
                if Inner then
                    local Flash = New("Frame", {
                            Position = UDim2.new(0, -4, 0, -2),
                            Size = UDim2.new(1, 8, 1, 4),
                        BackgroundColor3 = Scheme.AccentColor,
                            BackgroundTransparency = 0.55,
                            BorderSizePixel = 0,
                    }, Inner)
                    Corner(Flash, 6)
                    Tween(Flash, 1.1, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quint)
                    task.delay(1.2, function() Flash:Destroy() end)
                    end
                end)
            end

        local Panel = New("Frame", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -38, 0, 32),
                Size = UDim2.fromOffset(220, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Scheme.MainColor,
                BackgroundTransparency = 0.03,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 40,
        }, Main)
        Corner(Panel, 10)
        Stroke(Panel, 1.2, 0.15)
        table.insert(Library.PrimaryRegs, Panel)
        New("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, Panel)
        New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, Panel)

        local function BuildPanel()
            for _, Ch in ipairs(Panel:GetChildren()) do
                if Ch:IsA("GuiObject") then Ch:Destroy() end
            end
            local POrder = 0
            local function Header(Text)
                POrder = POrder + 1
                New("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 18),
                        BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Scheme.InactiveColor,
                        Font = Enum.Font.GothamBold,
                        TextSize = 10,
                    TextXAlignment = Scheme.AlignLeft,
                        ZIndex = 41,
                    LayoutOrder = POrder,
                }, Panel)
            end
            local function Item(Key)
                POrder = POrder + 1
                local B = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 24),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 41,
                    LayoutOrder = POrder,
                }, Panel)
                Corner(B, 6)
                New("TextLabel", {
                        Position = UDim2.fromOffset(8, 0),
                        Size = UDim2.new(1, -70, 1, 0),
                        BackgroundTransparency = 1,
                    Text = NameOf(Key),
                    TextColor3 = Scheme.FontColor,
                        Font = Enum.Font.GothamSemibold,
                        TextSize = 12,
                    TextXAlignment = Scheme.AlignLeft,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        ZIndex = 42,
                }, B)
                New("TextLabel", {
                        AnchorPoint = Vector2.new(1, 0),
                        Position = UDim2.new(1, -8, 0, 0),
                        Size = UDim2.fromOffset(56, 24),
                        BackgroundTransparency = 1,
                    Text = string.lower(TabOf[Key] or ""),
                    TextColor3 = Scheme.InactiveColor,
                        Font = Enum.Font.GothamBold,
                        TextSize = 10,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 42,
                }, B)
                B.MouseEnter:Connect(function()
                    Tween(B, 0.1, { BackgroundTransparency = 0.88 })
                end)
                B.MouseLeave:Connect(function()
                    Tween(B, 0.15, { BackgroundTransparency = 1 })
                end)
                B.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                        Panel.Visible = false
                        Library:JumpTo(Key)
                        end
                    end)
                end
            local Shown, Any = {}, false
            local RecentKeys = {}
            for _, K in ipairs(Recents) do
                if RowOf[K] then RecentKeys[#RecentKeys + 1] = K end
            end
            if #RecentKeys > 0 then
                Header("RECENT")
                for _, K in ipairs(RecentKeys) do
                    Item(K)
                    Shown[K] = true
                    Any = true
                end
            end
            local Sug = {}
            for _, K in ipairs(Suggest) do
                if RowOf[K] and not Shown[K] and #Sug < 4 then
                    Sug[#Sug + 1] = K
                end
            end
            if #Sug > 0 then
                Header("SUGGESTED")
                for _, K in ipairs(Sug) do
                    Item(K)
                    Any = true
                end
            end
            return Any
        end

        local function ShowPanel()
            if SearchBox.Text ~= "" then return end
            if BuildPanel() then
                Panel.Position = UDim2.new(1, -38, 0, 26)
                Panel.Visible = true
                Tween(Panel, 0.2, { Position = UDim2.new(1, -38, 0, 32) }, Enum.EasingStyle.Quint)
            end
        end
        SearchBox.Focused:Connect(ShowPanel)
        SearchBox.FocusLost:Connect(function()
                task.delay(0.2, function()
                if not SearchBox:IsFocused() then
                    Panel.Visible = false
                    end
                end)
            end)
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if SearchBox.Text ~= "" then
                Panel.Visible = false
            elseif SearchBox:IsFocused() then
                ShowPanel()
                end
            end)
        end

    do
        local StatBase = {}
        local function LeaderStat(Name)
            local Char = LocalPlayer and LocalPlayer.Character
            local Ls = Char and Char:FindFirstChild("leaderstats")
            if not Ls then
                local PlayerGui = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
                Ls = PlayerGui and PlayerGui:FindFirstChild("leaderstats")
            end
            if Ls then
                local V = Ls:FindFirstChild(Name)
                if V and V:IsA("ValueBase") and type(V.Value) == "number" then
                    if StatBase[Name] == nil then StatBase[Name] = V.Value end
                    return V.Value - StatBase[Name]
                end
            end
            return nil
        end
        function Library:GetSessionStats()
            local Sess = Library.Session or { T0 = tick(), Kills = 0, Deaths = 0 }
            local K = LeaderStat("Kills") or Sess.Kills or 0
            local D = LeaderStat("Deaths") or Sess.Deaths or 0
            return math.floor(tick() - (Sess.T0 or tick())), K, D
        end
    end

    function Library:ShowProfile()
        if Main:FindFirstChild(Library.GuiNames.Profile) then return end
        local Dim = New("TextButton", {
            Name = Library.GuiNames.Profile,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "",
            ZIndex = 70,
        }, Main)
        Corner(Dim, 10)
        local Card = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 26),
            Size = UDim2.fromOffset(340, 270),
            BackgroundColor3 = Scheme.MainColor,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 71,
        }, Dim)
        Corner(Card, 12)
        local Cs = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 1.4, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Card)
        Register(Cs, "Color")
        local FadeList = {}
        local function Fade(Inst, Prop, Shown)
            table.insert(FadeList, { Inst, Prop, Shown })
            Inst[Prop] = 1
        end
        local Av = New("ImageLabel", {
            Position = UDim2.fromOffset(20, 20),
            Size = UDim2.fromOffset(72, 72),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BorderSizePixel = 0,
            Image = Library.AvatarImage or "",
            ImageTransparency = 1,
            ZIndex = 72,
        }, Card)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Av)
        local Avs = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 2.5, Transparency = 1 }, Av)
        Register(Avs, "Color")
        Fade(Av, "ImageTransparency", 0)
        Fade(Av, "BackgroundTransparency", 0)
        table.insert(FadeList, { Avs, "Transparency", 0 })
        local NameL = New("TextLabel", {
            Position = UDim2.fromOffset(106, 28),
            Size = UDim2.new(1, -126, 0, 26),
            BackgroundTransparency = 1,
            Text = LocalPlayer.DisplayName,
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 20,
            TextXAlignment = Scheme.AlignLeft,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 72,
        }, Card)
        Fade(NameL, "TextTransparency", 0)
        local UserL = New("TextLabel", {
            Position = UDim2.fromOffset(106, 56),
            Size = UDim2.new(1, -126, 0, 18),
            BackgroundTransparency = 1,
            Text = "@" .. LocalPlayer.Name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            TextXAlignment = Scheme.AlignLeft,
            ZIndex = 72,
        }, Card)
        Fade(UserL, "TextTransparency", 0)
        local Line = New("Frame", {
            Position = UDim2.fromOffset(20, 108),
            Size = UDim2.new(1, -40, 0, 2),
            BorderSizePixel = 0,
            ZIndex = 72,
        }, Card)
        Register(Line, "BackgroundColor3")
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Line)
        Fade(Line, "BackgroundTransparency", 0.2)
        local ValueLabels = {}
        local Tiles = { { "SESSION", 20, 120 }, { "K/D", 180, 120 }, { "KILLS", 20, 172 }, { "DEATHS", 180, 172 } }
        for _, T in ipairs(Tiles) do
            local Tile = New("Frame", {
                Position = UDim2.fromOffset(T[2], T[3]),
                Size = UDim2.fromOffset(140, 44),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BorderSizePixel = 0,
                ZIndex = 72,
            }, Card)
            Corner(Tile, 8)
            local Ts = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 1, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Tile)
            Register(Ts, "Color")
            Fade(Tile, "BackgroundTransparency", 0.5)
            table.insert(FadeList, { Ts, "Transparency", 0.6 })
            local Cap = New("TextLabel", {
                Position = UDim2.fromOffset(10, 4),
                Size = UDim2.new(1, -20, 0, 14),
                BackgroundTransparency = 1,
                Text = T[1],
                TextColor3 = Color3.fromRGB(140, 140, 140),
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextXAlignment = Scheme.AlignLeft,
                ZIndex = 73,
            }, Tile)
            Fade(Cap, "TextTransparency", 0)
            local Val = New("TextLabel", {
                Position = UDim2.fromOffset(10, 18),
                Size = UDim2.new(1, -20, 0, 22),
                BackgroundTransparency = 1,
                Text = "-",
                TextColor3 = Color3.new(1, 1, 1),
                Font = Enum.Font.GothamBold,
                TextSize = 18,
                TextXAlignment = Scheme.AlignLeft,
                ZIndex = 73,
            }, Tile)
            Fade(Val, "TextTransparency", 0)
            ValueLabels[T[1]] = Val
        end
        local CloseBtn = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -12),
            Size = UDim2.fromOffset(110, 28),
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Text = "Close",
            TextColor3 = Color3.fromRGB(20, 20, 20),
            Font = Enum.Font.GothamBold,
            TextSize = 13,
            ZIndex = 72,
        }, Card)
        Corner(CloseBtn, 8)
        Register(CloseBtn, "BackgroundColor3")
        Fade(CloseBtn, "BackgroundTransparency", 0)
        Fade(CloseBtn, "TextTransparency", 0)
        Tween(Dim, 0.3, { BackgroundTransparency = 0.45 })
        Tween(Card, 0.45, { Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.04 }, Enum.EasingStyle.Quint)
        Tween(Cs, 0.4, { Transparency = 0.15 })
        for _, F in ipairs(FadeList) do
            Tween(F[1], 0.45, { [F[2]] = F[3] })
        end
        local Closed = false
        local function DoClose()
            if Closed then return end
            Closed = true
            Tween(Card, 0.25, { Position = UDim2.new(0.5, 0, 0.5, 20), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Cs, 0.2, { Transparency = 1 })
            for _, F in ipairs(FadeList) do
                Tween(F[1], 0.2, { [F[2]] = 1 })
            end
            Tween(Dim, 0.3, { BackgroundTransparency = 1 })
            task.delay(0.35, function() Dim:Destroy() end)
        end
        CloseBtn.Activated:Connect(DoClose)
        Dim.Activated:Connect(DoClose)
        task.spawn(function()
            while not Closed and Dim.Parent do
                if Av.Image == "" and Library.AvatarImage then
                    Av.Image = Library.AvatarImage
                end
                local Secs, K, D = Library:GetSessionStats()
                ValueLabels["SESSION"].Text = string.format("%02d:%02d:%02d", math.floor(Secs / 3600), math.floor(Secs / 60) % 60, Secs % 60)
                ValueLabels["KILLS"].Text = tostring(K)
                ValueLabels["DEATHS"].Text = tostring(D)
                ValueLabels["K/D"].Text = string.format("%.2f", D == 0 and K or K / D)
                task.wait(0.5)
            end
        end)
    end

    if WindowInfo.Footer then
        local Ft = (tostring(WindowInfo.Footer):gsub("^[Vv]ersion:%s*", "v"))
        local Pill = New("Frame", {
            Size = UDim2.new(0, Side - 16, 0, 22),
            Position = UDim2.new(0, 8, 1, -30),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 0.55,
            BorderSizePixel = 0,
            ZIndex = 3,
        }, Main)
        Corner(Pill, 11)
        Stroke(Pill, 1, 0.65)
        local Dot = New("Frame", {
            Size = UDim2.fromOffset(6, 6),
            Position = UDim2.new(0, 10, 0.5, -3),
            BorderSizePixel = 0,
            ZIndex = 4,
        }, Pill)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Dot)
        Register(Dot, "BackgroundColor3")
        TweenService:Create(Dot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            BackgroundTransparency = 0.7,
        }):Play()
        New("TextLabel", {
            Size = UDim2.new(1, -26, 1, 0),
            Position = UDim2.fromOffset(23, 0),
            BackgroundTransparency = 1,
            Text = Ft,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextXAlignment = Scheme.AlignLeft,
            ZIndex = 4,
        }, Pill)
    end

    function Library:WindowToast(Text, Duration)
        local Bounds = TextService:GetTextSize(tostring(Text), 13, Enum.Font.GothamBold, Vector2.new(400, 30))
        local W = math.floor(Bounds.X) + 56
        local Pill = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, 30),
            Size = UDim2.fromOffset(W, 34),
            BackgroundColor3 = Scheme.MainColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 60,
        }, Main)
        Corner(Pill, 17)
        local Ps = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 1.2, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Pill)
        Register(Ps, "Color")
        local Dot = New("Frame", {
                Position = UDim2.fromOffset(14, 13),
                Size = UDim2.fromOffset(8, 8),
            BackgroundColor3 = Scheme.AccentColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 61,
        }, Pill)
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, Dot)
        Register(Dot, "BackgroundColor3")
        local Lbl = New("TextLabel", {
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -38, 1, 0),
                BackgroundTransparency = 1,
            Text = tostring(Text),
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextTransparency = 1,
            TextXAlignment = Scheme.AlignLeft,
                ZIndex = 61,
        }, Pill)
        Tween(Pill, 0.5, { Position = UDim2.new(0.5, 0, 1, -14), BackgroundTransparency = 0.05 }, Enum.EasingStyle.Back)
        Tween(Ps, 0.4, { Transparency = 0.2 })
        Tween(Dot, 0.4, { BackgroundTransparency = 0 })
        Tween(Lbl, 0.4, { TextTransparency = 0 })
        task.delay(Duration or 4, function()
            if not Pill.Parent then return end
            Tween(Pill, 0.35, { Position = UDim2.new(0.5, 0, 1, 30), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Ps, 0.3, { Transparency = 1 })
            Tween(Dot, 0.3, { BackgroundTransparency = 1 })
            Tween(Lbl, 0.3, { TextTransparency = 1 })
                task.delay(0.4, function()
                if Pill.Parent then Pill:Destroy() end
                end)
            end)
        end

        local ChangelogFile = "ware.gg/changelog.txt"

    function Library:ShowChangelog(Version, Notes)
        if Main:FindFirstChild(Library.GuiNames.Changelog) then return end
        local Hex = Scheme.AccentColor:Lerp(Color3.new(1, 1, 1), 0.25):ToHex()
        local function Esc(Text)
            Text = tostring(Text or "")
            Text = Text:gsub("&", "&amp;")
            Text = Text:gsub("<", "&lt;")
            Text = Text:gsub(">", "&gt;")
            Text = Text:gsub('"', "&quot;")
            return Text
        end
        local Rich, Plain = {}, {}
        for _, N in ipairs(Notes or {}) do
            if type(N) == "table" then
                local TagColor = (N.tag == "NEW") and Hex or "9a9a9a"
                table.insert(
                    Rich,
                    string.format(
                        '<font color="#%s"><b>%s</b></font>  <font color="#ffffff"><b>%s</b></font>\n%s',
                        TagColor,
                        Esc(N.tag or ""),
                        Esc(N.title or ""),
                        Esc(N.text or "")
                    )
                )
                table.insert(Plain, string.format("%s  %s\n%s", N.tag or "", N.title or "", N.text or ""))
            else
                table.insert(Rich, Esc(N))
                table.insert(Plain, tostring(N))
                end
            end
        local Body = table.concat(Rich, "\n\n")
        local Bounds = TextService:GetTextSize(table.concat(Plain, "\n\n"), 13, Enum.Font.GothamSemibold, Vector2.new(330, 2000))
        local CardH = math.min(math.floor(Bounds.Y) + 120, Height - 40)
        local Dim = New("TextButton", {
            Name = Library.GuiNames.Changelog,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                AutoButtonColor = false,
                Text = "",
                ZIndex = 70,
        }, Main)
        Corner(Dim, 10)
        local Card = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.5, 24),
            Size = UDim2.fromOffset(380, CardH),
            BackgroundColor3 = Scheme.MainColor,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 71,
        }, Dim)
        Corner(Card, 12)
        local Cs = New("UIStroke", { Color = Scheme.AccentColor, Thickness = 1.4, Transparency = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, Card)
        Register(Cs, "Color")
        local Head = New("TextLabel", {
                Position = UDim2.fromOffset(20, 14),
                Size = UDim2.new(1, -40, 0, 22),
                BackgroundTransparency = 1,
            Text = "What's new  \u{2022}  v" .. tostring(Version),
            TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 16,
            TextXAlignment = Scheme.AlignLeft,
                TextTransparency = 1,
                ZIndex = 72,
        }, Card)
        local HLine = New("Frame", {
                Position = UDim2.fromOffset(20, 42),
                Size = UDim2.new(1, -40, 0, 2),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                ZIndex = 72,
        }, Card)
        Register(HLine, "BackgroundColor3")
        New("UICorner", { CornerRadius = UDim.new(1, 0) }, HLine)
        local Scroller = New("ScrollingFrame", {
                Position = UDim2.fromOffset(20, 54),
                Size = UDim2.new(1, -40, 1, -110),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
            CanvasSize = UDim2.fromOffset(0, math.floor(Bounds.Y) + 12),
                ScrollBarThickness = 3,
                ZIndex = 72,
        }, Card)
        local BodyLbl = New("TextLabel", {
            Size = UDim2.new(1, -8, 0, math.floor(Bounds.Y) + 8),
                BackgroundTransparency = 1,
                RichText = true,
            Text = Body,
                TextColor3 = Color3.fromRGB(210, 210, 210),
                Font = Enum.Font.GothamSemibold,
                TextSize = 13,
                TextWrapped = true,
            TextXAlignment = Scheme.AlignLeft,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextTransparency = 1,
                ZIndex = 72,
        }, Scroller)
        local OkBtn = New("TextButton", {
                AnchorPoint = Vector2.new(0.5, 1),
                Position = UDim2.new(0.5, 0, 1, -14),
                Size = UDim2.fromOffset(120, 30),
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                AutoButtonColor = false,
                Text = "Got it",
                TextColor3 = Color3.fromRGB(20, 20, 20),
                Font = Enum.Font.GothamBold,
                TextSize = 13,
                TextTransparency = 1,
                ZIndex = 72,
        }, Card)
        Corner(OkBtn, 8)
        Register(OkBtn, "BackgroundColor3")
        OkBtn.MouseEnter:Connect(function()
            Tween(OkBtn, 0.15, { Size = UDim2.fromOffset(128, 32) }, Enum.EasingStyle.Back)
        end)
        OkBtn.MouseLeave:Connect(function()
            Tween(OkBtn, 0.15, { Size = UDim2.fromOffset(120, 30) })
        end)
        Tween(Dim, 0.3, { BackgroundTransparency = 0.45 })
        Tween(Card, 0.45, { Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0.04 }, Enum.EasingStyle.Quint)
        Tween(Cs, 0.4, { Transparency = 0.15 })
        Tween(HLine, 0.4, { BackgroundTransparency = 0.2 })
        Tween(Head, 0.4, { TextTransparency = 0 })
        Tween(BodyLbl, 0.5, { TextTransparency = 0 })
        Tween(OkBtn, 0.4, { BackgroundTransparency = 0, TextTransparency = 0 })
        local Closed = false
        local function DoClose()
            if Closed then return end
            Closed = true
                pcall(function()
                    if writefile then
                        if makefolder and isfolder and not isfolder("ware.gg") then makefolder("ware.gg") end
                    writefile(ChangelogFile, tostring(Version))
                    end
                end)
            Tween(Card, 0.25, { Position = UDim2.new(0.5, 0, 0.5, 20), BackgroundTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
            Tween(Cs, 0.2, { Transparency = 1 })
            Tween(HLine, 0.2, { BackgroundTransparency = 1 })
            Tween(Head, 0.2, { TextTransparency = 1 })
            Tween(BodyLbl, 0.2, { TextTransparency = 1 })
            Tween(OkBtn, 0.2, { BackgroundTransparency = 1, TextTransparency = 1 })
            Tween(Dim, 0.3, { BackgroundTransparency = 1 })
            task.delay(0.35, function() Dim:Destroy() end)
        end
        OkBtn.Activated:Connect(DoClose)
        Dim.Activated:Connect(DoClose)
    end

    function Library:ChangelogUnseen(Version)
        local ChangelogFile2 = "ware.gg/changelog.txt"
        if isfile and readfile and isfile(ChangelogFile2) then
            local OkRead, Txt = pcall(readfile, ChangelogFile2)
            if OkRead and tostring(Txt) == tostring(Version) then
                    return false
                end
            end
            return true
        end

    Library.FocusSearch = function()
            if not Library.Toggled then
            SetOpen(true)
            end
            task.defer(function()
            SearchBox:CaptureFocus()
                task.delay(0.03, function()
                local T = string.lower(SearchBox.Text)
                if T == "k" then
                    SearchBox.Text = ""
                    end
                end)
            end)
        end

    Library.Window = Window
    Main.Visible = false
    Library.Toggled = false
    if Library:GetStartupAnim() then
        Library:Splash(Title, function()
            SetOpen(true)
        end)
    else
        task.defer(SetOpen, true)
    end
    return Window
end

local function EnsureFolder(Path)
    if not (makefolder and isfolder) then
                            return
                        end
    local Cur = ""
    for Part in string.gmatch(Path, "[^/]+") do
        Cur = (Cur == "") and Part or (Cur .. "/" .. Part)
        if not isfolder(Cur) then
            pcall(makefolder, Cur)
        end
                            end
                        end

local function CleanName(Name)
    local Str = tostring(Name or "")
    Str = Str:gsub("[^%w _%-]", "")
    Str = Str:gsub("^%s+", "")
    Str = Str:gsub("%s+$", "")
    return Str
end

local function IsValidFolderPath(Name)
    if type(Name) ~= "string" then
        return false
    end
    local Trimmed = Name:gsub("^%s+", ""):gsub("%s+$", "")
    if Trimmed == "" then
        return false
    end
    if Name:find('[<>:"|%?%*%z]', 1) then
        return false
    end
    if Name:find("%.%.", 1, true) then
        return false
    end
    return true
end

local function ParseColorValue(Value)
    if typeof(Value) == "Color3" then
        return Value
    end
    if type(Value) ~= "table" then
        return nil
    end
    local R, G, B = tonumber(Value[1]), tonumber(Value[2]), tonumber(Value[3])
    if not R or not G or not B then
        return nil
    end
    return Color3.fromRGB(
        math.clamp(math.floor(R + 0.5), 0, 255),
        math.clamp(math.floor(G + 0.5), 0, 255),
        math.clamp(math.floor(B + 0.5), 0, 255)
    )
end

local MaxImportChars = 200000
local MaxImportKeys = 2000

do
    function ThemeManager:SetLibrary() end

    function ThemeManager:SetFolder(Folder)
        if Folder ~= nil and not IsValidFolderPath(Folder) then
            return
        end
        ThemeManager.Folder = Folder or ThemeManager.Folder
    end

    function ThemeManager:ApplyToTab(Tab)
        local Scheme = Library.Scheme
        local Box = Tab:AddLeftGroupbox("theme")

        do
            local PvAcc, PvPri = {}, {}
            local function Pa(Inst, Prop)
                Register(Inst, Prop)
                PvAcc[#PvAcc + 1] = { Inst, Prop }
                return Inst
            end
            local PvRow = Box:AddCustom(142)
            local Shell = New("Frame", {
                Size = UDim2.new(1, 0, 0, 104),
                BackgroundColor3 = Scheme.MainColor,
                BorderSizePixel = 0,
                ClipsDescendants = true,
            }, PvRow)
            Corner(Shell, 8)
            table.insert(Library.PrimaryRegs, Shell)
            PvPri[#PvPri + 1] = Shell
            local Pst = New("UIStroke", {
                Color = Scheme.OutlineColor,
                Thickness = 1.5,
                Transparency = 0.15,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            }, Shell)
            table.insert(Library.OutlineStrokes, Pst)
            local Bar = New("Frame", {
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.6,
                BorderSizePixel = 0,
            }, Shell)
            Pa(New("Frame", {
                Position = UDim2.fromOffset(7, 6),
                Size = UDim2.fromOffset(4, 4),
                BorderSizePixel = 0,
            }, Bar), "BackgroundColor3")
            New("TextLabel", {
                Position = UDim2.fromOffset(15, 0),
                Size = UDim2.new(1, -20, 1, 0),
                BackgroundTransparency = 1,
                Text = "ware.gg",
                TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 9,
                TextXAlignment = Scheme.AlignLeft,
            }, Bar)
            local Side = New("Frame", {
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(0, 34, 1, -16),
                BackgroundColor3 = Color3.new(0, 0, 0),
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
            }, Shell)
            local Ind = New("Frame", {
                Position = UDim2.fromOffset(0, 8),
                Size = UDim2.fromOffset(2, 12),
                BorderSizePixel = 0,
            }, Side)
            Pa(Ind, "BackgroundColor3")
            for Index = 1, 4 do
                New("Frame", {
                    Position = UDim2.fromOffset(9, 10 + (Index - 1) * 17),
                    Size = UDim2.fromOffset(18, 6),
                    BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                    BackgroundTransparency = 0.5,
                    BorderSizePixel = 0,
                }, Side)
            end
            local function Bars(Y, W)
                local T = New("Frame", {
                    Position = UDim2.fromOffset(46, Y),
                    Size = UDim2.fromOffset(W, 5),
                    BackgroundColor3 = Color3.fromRGB(190, 190, 190),
                    BackgroundTransparency = 0.55,
                    BorderSizePixel = 0,
                }, Shell)
                Corner(T, 3)
            end

            for R = 1, 2 do
                local Y = 24 + (R - 1) * 20
                Bars(Y + 3, 48 + R * 8)
                local Trk = New("Frame", {
                    Position = UDim2.new(1, -34, 0, Y),
                    Size = UDim2.fromOffset(24, 11),
                    BorderSizePixel = 0,
                }, Shell)
                Corner(Trk, 6)
                Pa(Trk, "BackgroundColor3")
                local Kn = New("Frame", {
                    Position = UDim2.fromOffset(R == 1 and 14 or 2, 2),
                    Size = UDim2.fromOffset(7, 7),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                }, Trk)
                Corner(Kn, 4)
                if R == 2 then
                    pcall(function()
                        TweenService:Create(
                            Kn,
                            TweenInfo.new(1.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut, -1, true, 0.4),
                            { Position = UDim2.fromOffset(14, 2) }
                        ):Play()
                    end)
                end
            end

            Bars(66, 38)
            local Sl = New("Frame", {
                Position = UDim2.new(0, 46, 0, 80),
                Size = UDim2.new(1, -58, 0, 6),
                BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                BorderSizePixel = 0,
            }, Shell)
            Corner(Sl, 3)
            local Fill = New("Frame", {
                Size = UDim2.new(0.3, 0, 1, 0),
                BorderSizePixel = 0,
            }, Sl)
            Corner(Fill, 3)
            Pa(Fill, "BackgroundColor3")

            local Pill = New("Frame", {
                Position = UDim2.fromOffset(0, 112),
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundColor3 = Scheme.MainColor,
                BorderSizePixel = 0,
            }, PvRow)
            Corner(Pill, 14)
            table.insert(Library.PrimaryRegs, Pill)
            PvPri[#PvPri + 1] = Pill
            PvAcc[#PvAcc + 1] = { Stroke(Pill, 1.35, 0.1), "Color" }
            local Pdot = New("Frame", {
                Position = UDim2.new(0, 12, 0.5, -3),
                Size = UDim2.fromOffset(6, 6),
                BorderSizePixel = 0,
            }, Pill)
            Corner(Pdot, 3)
            Pa(Pdot, "BackgroundColor3")
            New("TextLabel", {
                Position = UDim2.fromOffset(26, 0),
                Size = UDim2.new(1, -90, 1, 0),
                BackgroundTransparency = 1,
                Text = "WARE.GG",
                TextColor3 = Scheme.FontColor,
                Font = Enum.Font.GothamBold,
                TextSize = 10,
                TextXAlignment = Scheme.AlignLeft,
            }, Pill)
            New("TextLabel", {
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -12, 0, 0),
                Size = UDim2.fromOffset(60, 28),
                BackgroundTransparency = 1,
                Text = "OPEN  +",
                TextColor3 = Color3.fromRGB(150, 150, 150),
                Font = Enum.Font.GothamBold,
                TextSize = 9,
                TextXAlignment = Enum.TextXAlignment.Right,
            }, Pill)
            pcall(function()
                TweenService:Create(
                    Fill,
                    TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    { Size = UDim2.new(0.85, 0, 1, 0) }
                ):Play()
                TweenService:Create(
                    Ind,
                    TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    { Position = UDim2.fromOffset(0, 42) }
                ):Play()
            end)
            Library.PreviewTheme = {
                Accent = function(C)
                    for _, R in ipairs(PvAcc) do
                        pcall(function()
                            R[1][R[2]] = C
                        end)
                    end
                    Pst.Color = C
                end,
                Primary = function(Bg)
                    for _, O in ipairs(PvPri) do
                        O.BackgroundColor3 = Bg
                    end
                end,
                Reset = function()
                    for _, R in ipairs(PvAcc) do
                        pcall(function()
                            R[1][R[2]] = Scheme.AccentColor
                        end)
                    end
                    Pst.Color = Scheme.OutlineColor
                    for _, O in ipairs(PvPri) do
                        O.BackgroundColor3 = Scheme.MainColor
                    end
                end,
            }
        end
        Box:AddDivider()

        local PrimaryScale = Scheme.PrimaryScale or 0.25
        Box:AddColorGrid("PrimaryColor", {
            Text = "Primary Color",
            Colors = PrimaryPalette,
            Default = PrimaryPalette[1],
            OnHover = function(C)
                if Library.PreviewTheme then
                    Library.PreviewTheme.Primary(Color3.new(C.R * PrimaryScale, C.G * PrimaryScale, C.B * PrimaryScale))
                end
            end,
            OnHoverEnd = function()
                if Library.PreviewTheme then
                    Library.PreviewTheme.Reset()
                end
            end,
            Callback = function(C)
                local Bg = Color3.new(C.R * PrimaryScale, C.G * PrimaryScale, C.B * PrimaryScale)
                Library:SetPrimaryColor(Bg)
                if Library.OnPrimary then
                    SafeCall(Library.OnPrimary, Bg)
                end
            end,
        })
        Box:AddDivider()

        Box:AddColorGrid("AccentColor", {
            Text = "Secondary Color",
            Default = Scheme.AccentColor,
            OnHover = function(C)
                if Library.PreviewTheme then
                    Library.PreviewTheme.Accent(C)
                end
            end,
            OnHoverEnd = function()
                if Library.PreviewTheme then
                    Library.PreviewTheme.Reset()
                end
            end,
            Callback = function(C)
                Library:SetAccentColor(C)
                Library:SetOutlineColor(C)
                if Library.OnTheme then
                    SafeCall(Library.OnTheme, C)
                end
            end,
        })

        Box:AddToggle("RainbowAccent", {
            Text = "Rainbow",
            Default = false,
            Callback = function(V)
                Library.RainbowOn = V
                if not V then
                    local O = Library.Options.AccentColor
                    if O then
                        Library:SetAccentColor(O.Value)
                    end
                end
            end,
        })

        Box:AddDivider()
        Box:AddToggle("LoadupCustom", {
            Text = "Custom Loadup Color",
            Default = Library:GetLoadupColor() ~= nil,
            Callback = function(Value)
                if Value then
                    Library:SetLoadupColor(Library.Options.LoadupColor and Library.Options.LoadupColor.Value)
                else
                    Library:SetLoadupColor(nil)
                end
            end,
        })
        Box:AddColorGrid("LoadupColor", {
            Text = "Loadup Color",
            Default = Library:GetLoadupColor() or Color3.fromRGB(235, 64, 64),
            Callback = function(C)
                if Library.Toggles.LoadupCustom and Library.Toggles.LoadupCustom.Value then
                    Library:SetLoadupColor(C)
                end
            end,
        })
    end
end

do
    function SaveManager:SetLibrary() end
    function SaveManager:IgnoreThemeSettings() end

    function SaveManager:SetFolder(Folder)
        if Folder ~= nil and not IsValidFolderPath(Folder) then
            return
        end
        self.Folder = Folder or self.Folder
    end

    function SaveManager:SetIgnoreIndexes(List)
        for _, Key in ipairs(List or {}) do
            self.Ignore[Key] = true
        end
    end

    function SaveManager:Path(Name)
        return self.Folder .. "/configs/" .. Name .. ".json"
    end

    function SaveManager:Encode()
        local Data = { Toggles = {}, Options = {} }
        for Index, Toggle in pairs(Library.Toggles) do
            if not self.Ignore[Index] then
                Data.Toggles[Index] = Toggle.Value
            end
        end
        for Index, Option in pairs(Library.Options) do
            if not self.Ignore[Index] then
                if Option.Type == "ColorPicker" then
                    Data.Options[Index] = {
                        Option.Value.R * 255,
                        Option.Value.G * 255,
                        Option.Value.B * 255,
                    }
                elseif Option.Type == "KeyPicker" then
                    Data.Options[Index] = { Option.Value, Option.Mode }
                elseif Option.Value ~= nil then
                    Data.Options[Index] = Option.Value
                end
            end
        end
        return Data
    end

    local function InScope(Key, Scope)
        if not Scope then
            return true
        end
        local Info = Library.KeyTab[Key]
        if not Info then
            return false
        end
        if Scope == "combat" then
            return Info.Tab == "Main" or Info.Box == "combat visuals"
        end
        return Info.Tab == "Customize" or Info.Tab == "Settings"
    end

    function SaveManager:Apply(Data, Scope)
        if type(Data) ~= "table" then
            return
        end
        for Index, Value in pairs(Data.Toggles or {}) do
            local Toggle = Library.Toggles[Index]
            if Toggle and not self.Ignore[Index] and InScope(Index, Scope) then
                pcall(function()
                    Toggle:SetValue(Value)
                end)
            end
        end

        local function ApplyOption(Index, Value)
            local Option = Library.Options[Index]
            if not Option or self.Ignore[Index] or not InScope(Index, Scope) then
                return
            end
            pcall(function()
                if Option.Type == "ColorPicker" then
                    local Color = ParseColorValue(Value)
                    if Color then
                        Option:SetValue(Color)
                    end
                else
                    Option:SetValue(Value)
                end
            end)
        end

        local First = { "PrimaryColor", "AccentColor" }
        local IsFirst = {}
        for _, Key in ipairs(First) do
            IsFirst[Key] = true
            local Value = (Data.Options or {})[Key]
            if Value ~= nil then
                ApplyOption(Key, Value)
            end
        end
        for Index, Value in pairs(Data.Options or {}) do
            if not IsFirst[Index] then
                ApplyOption(Index, Value)
            end
        end
    end

    local function FmtNum(Value)
        local Rounded = math.floor(Value * 1000 + 0.5) / 1000
        if Rounded == math.floor(Rounded) then
            return string.format("%d", Rounded)
        end
        local Text = string.format("%.3f", Rounded)
        Text = Text:gsub("0+$", "")
        return Text
    end
    local function Esc(Text)
        return (Text:gsub("[%%|]", function(Char)
            return string.format("%%%02X", string.byte(Char))
        end))
    end
    local function Unesc(Text)
        return (Text:gsub("%%(%x%x)", function(Hex)
            return string.char(tonumber(Hex, 16))
        end))
    end
    local function IsColor(Value)
        return type(Value) == "table"
            and #Value == 3
            and type(Value[1]) == "number"
            and type(Value[2]) == "number"
            and type(Value[3]) == "number"
    end
    local function TokVal(Value, IsToggle)
        local Kind = type(Value)
        if Kind == "boolean" or IsToggle then
            return (IsToggle and "b" or "B") .. (Value and "1" or "0")
        elseif Kind == "number" then
            return "n" .. FmtNum(Value)
        elseif Kind == "string" then
            return "s" .. Esc(Value)
        elseif IsColor(Value) then
            local function H(X)
                return math.clamp(math.floor(X + 0.5), 0, 255)
            end
            return string.format("c%02x%02x%02x", H(Value[1]), H(Value[2]), H(Value[3]))
        end
        return "j" .. Esc(HttpService:JSONEncode(Value))
    end
    local function Untok(Token)
        local Kind, Body = string.sub(Token, 1, 1), string.sub(Token, 2)
        if Kind == "b" then
            return true, Body == "1"
        elseif Kind == "B" then
            return false, Body == "1"
        elseif Kind == "n" then
            return false, tonumber(Body)
        elseif Kind == "s" then
            return false, Unesc(Body)
        elseif Kind == "c" then
            return false, {
                tonumber(string.sub(Body, 1, 2), 16),
                tonumber(string.sub(Body, 3, 4), 16),
                tonumber(string.sub(Body, 5, 6), 16),
            }
        elseif Kind == "j" then
            return false, HttpService:JSONDecode(Unesc(Body))
        end
        return false, nil
    end

    function SaveManager:Tokenize(Data)
        local Map = {}
        for Key, Value in pairs(Data.Toggles or {}) do
            Map["T:" .. Key] = TokVal(Value, true)
        end
        for Key, Value in pairs(Data.Options or {}) do
            Map["O:" .. Key] = TokVal(Value, false)
        end
        return Map
    end

    function SaveManager:SnapshotDefaults()
        self.DefaultData = self:Encode()
    end

    function SaveManager:ToCode(Data)
        local Cur = self:Tokenize(Data)
        local Def = self.DefaultData and self:Tokenize(self.DefaultData) or {}
        local Keys = {}
        for Key in pairs(Cur) do
            Keys[#Keys + 1] = Key
        end
        table.sort(Keys)
        local Parts = { "ware2" }
        for _, Key in ipairs(Keys) do
            if Cur[Key] ~= Def[Key] then
                Parts[#Parts + 1] = string.sub(Key, 3) .. ":" .. Cur[Key]
            end
        end
        return table.concat(Parts, "|")
    end

    function SaveManager:FromCode(Code)
        Code = (tostring(Code or ""):gsub("^%s+", ""):gsub("%s+$", ""))
        if #Code > MaxImportChars then
            return nil, "config code is too large"
        end
        if string.sub(Code, 1, 6) ~= "ware2|" then
            return nil, "that code isn't a valid config"
        end
        local Full
        if self.DefaultData then
            Full = HttpService:JSONDecode(HttpService:JSONEncode(self.DefaultData))
        else
            Full = { Toggles = {}, Options = {} }
        end
        Full.Toggles = Full.Toggles or {}
        Full.Options = Full.Options or {}
        local KeyCount = 0
        for Item in string.gmatch(string.sub(Code, 7), "[^|]+") do
            KeyCount = KeyCount + 1
            if KeyCount > MaxImportKeys then
                return nil, "config code has too many entries"
            end
            local Colon = string.find(Item, ":", 1, true)
            if Colon then
                local Key = string.sub(Item, 1, Colon - 1)
                local Ok, IsT, Val = pcall(Untok, string.sub(Item, Colon + 1))
                if Ok and Val ~= nil then
                    if IsT then
                        Full.Toggles[Key] = Val
                    else
                        Full.Options[Key] = Val
                    end
                end
            end
        end
        return Full
    end

    function SaveManager:List()
        local Out = {}
        if not (listfiles and isfolder) then
            return Out
        end
        local Dir = self.Folder .. "/configs"
        if not isfolder(Dir) then
            return Out
        end
        local Ok, Files = pcall(listfiles, Dir)
        if not Ok or type(Files) ~= "table" then
            return Out
        end
        for _, File in ipairs(Files) do
            local Name = tostring(File):match("([^/\\]+)%.json$")
            if Name then
                table.insert(Out, Name)
            end
        end
        table.sort(Out, function(A, B)
            return A:lower() < B:lower()
        end)
        return Out
    end

    function SaveManager:Save(Name)
        Name = CleanName(Name)
        if Name == "" then
            return false, "type a config name first"
        end
        if not writefile then
            return false, "no file access"
        end
        EnsureFolder(self.Folder .. "/configs")
        local Data = self:Encode()
        local Ok = pcall(writefile, self:Path(Name), HttpService:JSONEncode(Data))
        if not Ok then
            return false, "couldn't write the file"
        end
        if not self:LoadTags()[Name] then
            self:SetTag(Name, self:RiskOf(Data))
        end
        return true, Name
    end

    local RiskNames = { "legit", "risky", "blatant" }
    local RiskLevel = { legit = 1, risky = 2, blatant = 3 }

    function SaveManager:TagsPath()
        return self.Folder .. "/configtags.txt"
    end

    function SaveManager:LoadTags()
        local Map = {}
        if isfile and readfile and isfile(self:TagsPath()) then
            local Ok, Text = pcall(readfile, self:TagsPath())
            if Ok and Text then
                for Line in string.gmatch(Text, "[^\r\n]+") do
                    local Tag, Name = string.match(Line, "^(%a+)|(.+)$")
                    if Tag and Name and RiskLevel[Tag] then
                        Map[Name] = Tag
                    end
                end
            end
        end
        return Map
    end

    function SaveManager:SaveTags(Map)
        if not writefile then
            return
        end
        EnsureFolder(self.Folder)
        local Lines = {}
        for Name, Tag in pairs(Map) do
            Lines[#Lines + 1] = Tag .. "|" .. Name
        end
        table.sort(Lines)
        pcall(writefile, self:TagsPath(), table.concat(Lines, "\n"))
    end

    function SaveManager:RiskOf(Data)
        local Level = 1
        local Tg, Op = (Data and Data.Toggles) or {}, (Data and Data.Options) or {}
        if Tg.Hitbox and type(Op.HitboxSize) == "number" then
            local V = Op.HitboxSize
            Level = math.max(Level, (V <= 3.5) and 1 or ((V <= 6) and 2 or 3))
        end
        if Tg.PunchSpeed and type(Op.PunchSpeedAmount) == "number" then
            local V = Op.PunchSpeedAmount
            Level = math.max(Level, (V <= 1.8) and 1 or ((V <= 2.0) and 2 or 3))
        end
        return RiskNames[Level]
    end

    function SaveManager:AllTags(Names)
        local Stored = self:LoadTags()
        local Out = {}
        for _, Name in ipairs(Names or {}) do
            if Stored[Name] then
                Out[Name] = Stored[Name]
            else
                local TagV = "legit"
                if isfile and readfile and isfile(self:Path(Name)) then
                    local Ok, Data = pcall(function()
                        return HttpService:JSONDecode(readfile(self:Path(Name)))
                    end)
                    if Ok and type(Data) == "table" then
                        TagV = self:RiskOf(Data)
                    end
                end
                Out[Name] = TagV
            end
        end
        return Out
    end

    function SaveManager:GetTag(Name)
        return self:AllTags({ Name })[Name] or "legit"
    end

    function SaveManager:SetTag(Name, TagV)
        if Name == nil or Name == "" or not RiskLevel[TagV] then
            return
        end
        local Map = self:LoadTags()
        Map[Name] = TagV
        self:SaveTags(Map)
    end

    function SaveManager:ClearTag(Name)
        local Map = self:LoadTags()
        if Map[Name] then
            Map[Name] = nil
            self:SaveTags(Map)
        end
    end

    function SaveManager:Load(Name, Scope)
        Name = CleanName(Name)
        if Name == "" then
            return false, "pick a config first"
        end
        if not (isfile and readfile) then
            return false, "no file access"
        end
        local Path = self:Path(Name)
        if not isfile(Path) then
            return false, "config not found"
        end
        local Ok, Data = pcall(function()
            return HttpService:JSONDecode(readfile(Path))
        end)
        if not Ok or type(Data) ~= "table" then
            return false, "config is corrupted"
        end
        self:Apply(Data, Scope)
        return true, Name
    end

    function SaveManager:Delete(Name)
        Name = CleanName(Name)
        if Name == "" then
            return false, "pick a config first"
        end
        if not (isfile and delfile) then
            return false, "no file access"
        end
        local Path = self:Path(Name)
        if not isfile(Path) then
            return false, "config not found"
        end
        pcall(delfile, Path)
        self:ClearTag(Name)
        if self:GetAutoload() == Name then
            self:ClearAutoload()
        end
        return true, Name
    end

    function SaveManager:GetAutoload()
        if not (isfile and readfile) then
            return nil
        end
        local Path = self.Folder .. "/autoload.txt"
        if not isfile(Path) then
            return nil
        end
        local Ok, Text = pcall(readfile, Path)
        if not Ok then
            return nil
        end
        local Name = CleanName(Text)
        if Name ~= "" and isfile(self:Path(Name)) then
            return Name
        end
        return nil
    end

    function SaveManager:SetAutoload(Name)
        if not writefile then
            return false
        end
        EnsureFolder(self.Folder)
        return (pcall(writefile, self.Folder .. "/autoload.txt", CleanName(Name)))
    end

    function SaveManager:ClearAutoload()
        local Path = self.Folder .. "/autoload.txt"
        if isfile and delfile and isfile(Path) then
            pcall(delfile, Path)
        end
    end

    function SaveManager:LoadAutoloadConfig()
        local Name = self:GetAutoload()
        if Name then
            self:Load(Name)
        end
    end

    function SaveManager:BuildConfigSection(Tab)
        local Legacy = self.Folder .. "/config.json"
        if isfile and readfile and writefile and isfile(Legacy) and not isfile(self:Path("default")) then
            EnsureFolder(self.Folder .. "/configs")
            pcall(function()
                writefile(self:Path("default"), readfile(Legacy))
            end)
            local Ap = self.Folder .. "/autoload.txt"
            if isfile(Ap) then
                local Ok, Text = pcall(readfile, Ap)
                if Ok and CleanName(Text) == "1" then
                    self:SetAutoload("default")
                end
            end
        end

        local Left = Tab:AddLeftGroupbox("new config")
        local Right = Tab:AddRightGroupbox("saved configs")
        local List, AutoToggle, AutoLabel
        local Suppress = false
        local SuppressTag = false

        local function UpdateStatus()
            local Auto = SaveManager:GetAutoload()
            AutoLabel:SetText("autoload: " .. (Auto or "none"))
            List:SetMarker(Auto)
        end

        local function SyncAutoToggle()
            if not AutoToggle then
                return
            end
            Suppress = true
            AutoToggle:SetValue(List.Value ~= nil and SaveManager:GetAutoload() == List.Value)
            Suppress = false
            UpdateStatus()
        end

        local function SyncTagSeg()
            local Seg = Library.Options.ConfigTag
            if Seg and List.Value then
                SuppressTag = true
                Seg:SetValue(SaveManager:GetTag(List.Value))
                SuppressTag = false
            end
        end

        local function RefreshList(Select)
            List:SetValues(SaveManager:List())
            List:SetTags(SaveManager:AllTags(List.Values))
            if Select then
                List:SetValue(Select)
            end
            SyncAutoToggle()
            SyncTagSeg()
        end

        Left:AddLabel("name your config, then create it")
        Left:AddInput("ConfigName", { Text = "Name", Placeholder = "my config" })
        Left:AddButton({
            Text = "Create Config",
            Func = function()
                local Ok, Res = SaveManager:Save(Library.Options.ConfigName.Value)
                Library:Notify(Ok and ("saved config: " .. Res) or Res, 3)
                if Ok then
                    RefreshList(Res)
                end
            end,
        })
        Left:AddDivider()
        Left:AddLabel("saves combat, visuals, ui + colors")
        Left:AddDivider()
        Left:AddLabel("share configs")
        Left:AddButton({
            Text = "Copy Selected As Code",
            Func = function()
                local Name = List.Value
                if not Name then
                    Library:Notify("pick a config first", 3)
                    return
                end
                local OkR, Text = pcall(function()
                    return SaveManager:ToCode(HttpService:JSONDecode(readfile(SaveManager:Path(Name))))
                end)
                if OkR and Text and setclipboard then
                    setclipboard(Text)
                    Library:Notify("copied config code for: " .. Name, 3)
                else
                    Library:Notify("couldn't copy that config", 3)
                end
            end,
        })
        Left:AddInput("ConfigImportCode", { Text = "Import Code", Placeholder = "paste a config code" })
        Left:AddButton({
            Text = "Import As New Config",
            Func = function()
                local Code = Library.Options.ConfigImportCode.Value
                local Nm = CleanName(Library.Options.ConfigName.Value)
                if Code == "" or not Code then
                    Library:Notify("paste a config code first", 3)
                    return
                end
                if type(Code) == "string" and #Code > MaxImportChars then
                    Library:Notify("config code is too large", 3)
                    return
                end
                if Nm == "" then
                    Nm = "imported"
                end
                local Data
                local Err
                if string.sub(Code, 1, 1) == "{" then
                    local OkJ, D = pcall(function()
                        return HttpService:JSONDecode(Code)
                    end)
                    Data = OkJ and D or nil
                    if OkJ and type(D) == "table" then
                        local Count = 0
                        for _ in pairs(D.Toggles or {}) do
                            Count = Count + 1
                        end
                        for _ in pairs(D.Options or {}) do
                            Count = Count + 1
                        end
                        if Count > MaxImportKeys then
                            Data = nil
                            Err = "config code has too many entries"
                        end
                    end
                else
                    local OkC, D, E = pcall(function()
                        return SaveManager:FromCode(Code)
                    end)
                    if OkC then
                        Data, Err = D, E
                    end
                end
                if type(Data) ~= "table" or not Data.Toggles then
                    Library:Notify(Err or "that code isn't a valid config", 3)
                    return
                end
                EnsureFolder(SaveManager.Folder .. "/configs")
                pcall(writefile, SaveManager:Path(Nm), HttpService:JSONEncode(Data))
                SaveManager:SetTag(Nm, SaveManager:RiskOf(Data))
                Library:Notify("imported config: " .. Nm, 3)
                RefreshList(Nm)
            end,
        })

        List = Right:AddItemList("ConfigList", {
            Height = 140,
            Empty = "no configs yet",
            Callback = function()
                SyncAutoToggle()
                SyncTagSeg()
            end,
        })
        Right:AddSegmented("ConfigTag", {
            Text = "Risk Tag",
            Values = { "legit", "risky", "blatant" },
            Callback = function(V)
                if SuppressTag or not List.Value then
                    return
                end
                SaveManager:SetTag(List.Value, V)
                List:SetTags(SaveManager:AllTags(List.Values))
            end,
        })
        Right:AddButtonRow({
            {
                Text = "Load",
                Func = function()
                    local Ok, Res = SaveManager:Load(List.Value)
                    Library:Notify(Ok and ("loaded config: " .. Res) or Res, 3)
                end,
            },
            {
                Text = "Overwrite",
                Func = function()
                    local Ok, Res = SaveManager:Save(List.Value)
                    Library:Notify(Ok and ("overwrote config: " .. Res) or Res, 3)
                end,
            },
            {
                Text = "Delete",
                Func = function()
                    local Ok, Res = SaveManager:Delete(List.Value)
                    Library:Notify(Ok and ("deleted config: " .. Res) or Res, 3)
                    if Ok then
                        RefreshList()
                    end
                end,
            },
        })
        Right:AddButtonRow({
            {
                Text = "Load Combat Only",
                Func = function()
                    local Ok, Res = SaveManager:Load(List.Value, "combat")
                    Library:Notify(Ok and ("loaded combat settings from: " .. Res) or Res, 3)
                end,
            },
            {
                Text = "Load Menu Only",
                Func = function()
                    local Ok, Res = SaveManager:Load(List.Value, "menu")
                    Library:Notify(Ok and ("loaded menu settings from: " .. Res) or Res, 3)
                end,
            },
        })
        Right:AddButton({
            Text = "Duplicate",
            Func = function()
                local Name = List.Value
                if not Name then
                    Library:Notify("pick a config first", 3)
                    return
                end
                local OkR, Text = pcall(function()
                    return readfile(SaveManager:Path(Name))
                end)
                if OkR then
                    local CopyName = Name .. " copy"
                    pcall(writefile, SaveManager:Path(CopyName), Text)
                    SaveManager:SetTag(CopyName, SaveManager:GetTag(Name))
                    Library:Notify("duplicated config: " .. CopyName, 3)
                    RefreshList(CopyName)
                else
                    Library:Notify("couldn't duplicate that config", 3)
                end
            end,
        })
        Right:AddButton({
            Text = "Refresh List",
            Func = function()
                RefreshList(List.Value)
            end,
        })

        Right:AddDivider()
        AutoToggle = Right:AddToggle("ConfigAutoload", {
            Text = "Autoload selected",
            Default = false,
            Callback = function(V)
                if Suppress then
                    return
                end
                if not List.Value then
                    Library:Notify("pick a config first", 3)
                    SyncAutoToggle()
                    return
                end
                if V then
                    SaveManager:SetAutoload(List.Value)
                elseif SaveManager:GetAutoload() == List.Value then
                    SaveManager:ClearAutoload()
                end
                UpdateStatus()
            end,
        })
        AutoLabel = Right:AddLabel("autoload: none")

        List:SetValues(SaveManager:List())
        local Auto = SaveManager:GetAutoload()
        if Auto then
            List:SetValue(Auto)
        end
        SyncAutoToggle()
    end
end

function Library:GetStartupAnim()
    if isfile and readfile and isfile("ware.gg/startup.txt") then
        local Ok, Txt = pcall(readfile, "ware.gg/startup.txt")
        if Ok and string.find(string.lower(tostring(Txt)), "off", 1, true) then
            return false
                end
            end
    return true
end
function Library:SetStartupAnim(V)
    if not writefile then
        return
    end
    EnsureFolder("ware.gg")
    pcall(writefile, "ware.gg/startup.txt", V and "on" or "off")
end
function Library:GetSavedAccent()
    local Ok, Res = pcall(function()
        if not (isfile and readfile) then
            return nil
        end
        local Folder = SaveManager.Folder or "ware.gg/main"
        local Ap = Folder .. "/autoload.txt"
        if not isfile(Ap) then
            return nil
        end
        local Name = CleanName(readfile(Ap))
        if Name == "" then
            return nil
        end
        local Cp = Folder .. "/configs/" .. Name .. ".json"
        if not isfile(Cp) then
            return nil
        end
        local Data = HttpService:JSONDecode(readfile(Cp))
        local V = Data and Data.Options and Data.Options.AccentColor
        if type(V) == "table" and #V >= 3 then
            return Color3.fromRGB(V[1], V[2], V[3])
        end
        return nil
    end)
    return Ok and Res or nil
end
function Library:GetLoadupColor()
    local Ok, Res = pcall(function()
        if not (isfile and readfile and isfile("ware.gg/loadup.txt")) then
            return nil
        end
        local R, G, B = string.match(readfile("ware.gg/loadup.txt"), "(%d+),(%d+),(%d+)")
        if R then
            return Color3.fromRGB(tonumber(R), tonumber(G), tonumber(B))
        end
        return nil
    end)
    return Ok and Res or nil
end
function Library:SetLoadupColor(C)
    if not writefile then
        return
    end
    EnsureFolder("ware.gg")
    local Txt = "auto"
    if typeof(C) == "Color3" then
        Txt = string.format(
            "%d,%d,%d",
            math.floor(C.R * 255 + 0.5),
            math.floor(C.G * 255 + 0.5),
            math.floor(C.B * 255 + 0.5)
        )
    end
    pcall(writefile, "ware.gg/loadup.txt", Txt)
end
function Library:GetFlag(Name, Default)
    Name = CleanName(Name)
    if Name == "" then
        return Default
    end
    local F = "ware.gg/flag_" .. Name .. ".txt"
    if isfile and readfile and isfile(F) then
        local Ok, Txt = pcall(readfile, F)
        if Ok then
            return not string.find(string.lower(tostring(Txt)), "off", 1, true)
        end
    end
    return Default
end
function Library:SetFlag(Name, V)
    if not writefile then
        return
    end
    Name = CleanName(Name)
    if Name == "" then
        return
    end
    EnsureFolder("ware.gg")
    pcall(writefile, "ware.gg/flag_" .. Name .. ".txt", V and "on" or "off")
end
function Library:Rate() end

Library.Toggles = Toggles
Library.Options = Options
Library.PrimaryPalette = PrimaryPalette
Library.Palette = Palette
Library.TabIcons = TabIcons

return Library, ThemeManager, SaveManager
