--[[
    TERMINATOR v4.4 // FINAL AIM & WALLBANG FIX
    - UPDATED: Version 4.4
    - ADDED: Advanced Camera Overwrite
    - FIXED: ESP Lag & Aim Targeting
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
-- АНИМАЦИЯ ЗАГРУЗКИ v4.4
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg)
loader.Name = "Terminator_Loader"

local l_main = Instance.new("Frame", loader)
l_main.Size = UDim2.new(0, 300, 0, 100)
l_main.Position = UDim2.new(0.5, -150, 0.5, -50)
l_main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
l_main.BorderSizePixel = 0
Instance.new("UICorner", l_main)

local l_txt = Instance.new("TextLabel", l_main)
l_txt.Size = UDim2.new(1, 0, 0.5, 0)
l_txt.Text = "TERMINATOR v4.4"
l_txt.TextColor3 = Color3.new(1, 1, 1)
l_txt.Font = Enum.Font.GothamBold
l_txt.TextSize = 22
l_txt.BackgroundTransparency = 1

local l_barBack = Instance.new("Frame", l_main)
l_barBack.Size = UDim2.new(0.8, 0, 0, 4)
l_barBack.Position = UDim2.new(0.1, 0, 0.75, 0)
l_barBack.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
l_barBack.BorderSizePixel = 0

local l_barFill = Instance.new("Frame", l_barBack)
l_barFill.Size = UDim2.new(0, 0, 1, 0)
l_barFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
l_barFill.BorderSizePixel = 0

-- Красивая анимация загрузки
task.spawn(function()
    l_txt.Text = "Loading Modules..."
    tw:Create(l_barFill, TweenInfo.new(1), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
    task.wait(1)
    l_txt.Text = "Bypassing Walls..."
    tw:Create(l_barFill, TweenInfo.new(1), {Size = UDim2.new(0.8, 0, 1, 0)}):Play()
    task.wait(1)
    l_txt.Text = "Apollyon Integrated!"
    tw:Create(l_barFill, TweenInfo.new(0.5), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(0.5)
    loader:Destroy()
end)

task.wait(2.6)

--------------------------------------------------
-- ГЛАВНОЕ МЕНЮ v4.4
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V4_4"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 280, 0, 400)
main.Position = UDim2.new(0.5, -140, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "TERMINATOR v4.4"
title.TextColor3 = Color3.new(1, 0, 0)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.BackgroundTransparency = 1

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -70); scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,1,0); scroll.ScrollBarThickness = 0
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
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(25, 25, 25)
    end)
end

addTgl("FORCE AIM / WALLBANG", "Wallbang")
addTgl("CHAMS ESP (ALWAYS ON)", "ESP")
addTgl("SPINBOT (RADIAL)", "Spin")

--------------------------------------------------
-- ЯДРО ЧИТА
--------------------------------------------------
local function getClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, pl in pairs(p:GetPlayers()) do
        if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
            -- Считаем дистанцию в 3D пространстве
            local mag = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
            if mag < dist then
                dist = mag
                target = pl
            end
        end
    end
    return target
end

-- Основной цикл рендера
rs:BindToRenderStep("TerminatorLogic", Enum.RenderPriority.Camera.Value + 1, function()
    local target = getClosestPlayer()
    local cam = workspace.CurrentCamera

    -- 1. Исправленный АИМ (Wallbang)
    if _G.Wallbang and target and target.Character then
        local head = target.Character.Head
        -- Прямая перезапись CFrame камеры для игнорирования защиты игры
        cam.CFrame = CFrame.lookAt(cam.CFrame.Position, head.Position)
    end

    -- 2. SPINBOT
    if _G.Spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0)
    end

    -- 3. ESP
    if _G.ESP then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local h = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                h.Name = "T_ESP"
                h.Enabled = true
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillColor = (pl.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
            end
        end
    end
end)

-- Управление интерфейсом
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.4 INJECTED SUCCESSFULLY")
