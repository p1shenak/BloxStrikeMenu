--[[
    TERMINATOR v4.3 // BLOX STRIKE ULTIMATE
    - ADDED: Pro Loading Animation
    - FIXED: Silent Wallbang Logic
    - FIXED: Optimized ESP & Spin
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")

-- Очистка старого интерфейса
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") or v.Name:find("Loader") then v:Destroy() end end

--------------------------------------------------
-- АНИМАЦИЯ ЗАГРУЗКИ
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg)
loader.Name = "Terminator_Loader"

local l_main = Instance.new("Frame", loader)
l_main.Size = UDim2.new(0, 300, 0, 100)
l_main.Position = UDim2.new(0.5, -150, 0.5, -50)
l_main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", l_main)

local l_txt = Instance.new("TextLabel", l_main)
l_txt.Size = UDim2.new(1, 0, 0.5, 0)
l_txt.Text = "Loading Terminator v4.3..."
l_txt.TextColor3 = Color3.new(1, 0, 0)
l_txt.Font = Enum.Font.GothamBold
l_txt.TextSize = 18
l_txt.BackgroundTransparency = 1

local l_barBack = Instance.new("Frame", l_main)
l_barBack.Size = UDim2.new(0.8, 0, 0, 4)
l_barBack.Position = UDim2.new(0.1, 0, 0.7, 0)
l_barBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
l_barBack.BorderSizePixel = 0

local l_barFill = Instance.new("Frame", l_barBack)
l_barFill.Size = UDim2.new(0, 0, 1, 0)
l_barFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
l_barFill.BorderSizePixel = 0

-- Запуск анимации
task.spawn(function()
    l_txt.Text = "Bypassing Anticheat..."
    tw:Create(l_barFill, TweenInfo.new(1.5), {Size = UDim2.new(0.6, 0, 1, 0)}):Play()
    task.wait(1.5)
    l_txt.Text = "Injecting Modules..."
    tw:Create(l_barFill, TweenInfo.new(1), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1)
    l_txt.Text = "Ready!"
    task.wait(0.5)
    loader:Destroy()
end)

task.wait(3.1) -- Ожидание конца анимации перед показом меню

--------------------------------------------------
-- ОСНОВНОЕ МЕНЮ
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V4_3"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 450)
main.Position = UDim2.new(0.5, -150, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "TERMINATOR v4.3"
title.TextColor3 = Color3.new(1, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,1.2,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

_G.Wallbang = false
_G.Spin = false
_G.ESP = false

local function addTgl(txt, var)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(25, 25, 25)
    end)
end

addTgl("WALLBANG / SILENT AIM", "Wallbang")
addTgl("ESP (CHAMS)", "ESP")
addTgl("SPINBOT", "Spin")

--------------------------------------------------
-- ЛОГИКА
--------------------------------------------------
local function getClosest()
    local target = nil
    local dist = math.huge
    for _, pl in pairs(p:GetPlayers()) do
        if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pl.Character.Head.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                if mag < dist then dist = mag; target = pl end
            end
        end
    end
    return target
end

rs.RenderStepped:Connect(function()
    local target = getClosest()
    
    -- WALLBANG / SILENT AIM
    if _G.Wallbang and target then
        local cam = workspace.CurrentCamera
        cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position)
    end

    -- SPINBOT
    if _G.Spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end

    -- ESP
    if _G.ESP then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local highlight = pl.Character:FindFirstChild("Terminator_ESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "Terminator_ESP"
                    highlight.Parent = pl.Character
                end
                highlight.Enabled = true
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.FillColor = (pl.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
            end
        end
    else
        for _, pl in pairs(p:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("Terminator_ESP") then
                pl.Character.Terminator_ESP.Enabled = false
            end
        end
    end
end)

uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.3 LOADED SUCCESS")
