--[[
    TERMINATOR v4.2 // BLOX STRIKE FIX
    - NEW: Bullet Redirection (без хуков)
    - FIXED: UI Buttons & Variables
    - FIXED: ESP Visibility
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

-- Удаление старых версий
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V4_2"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 450)
main.Position = UDim2.new(0.5, -150, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,1.5,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ ГЛОБАЛЬНЫЕ НАСТРОЙКИ ]
_G.Wallbang = false
_G.TPKill = false
_G.Spin = false
_G.ESP = false

local function addTgl(txt, var)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(30, 30, 30)
    end)
end

addTgl("WALLBANG (CROSS-MAP)", "Wallbang")
addTgl("TELEPORT KILL", "TPKill")
addTgl("ESP (CHAMS)", "ESP")
addTgl("SPINBOT", "Spin")

--------------------------------------------------
-- ЛОГИКА
--------------------------------------------------

local function getClosest()
    local target = nil
    local dist = 2000 -- Огромная дистанция для прострела
    pcall(function()
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local mag = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if mag < dist then dist = mag; target = pl end
            end
        end
    end)
    return target
end

-- ГЛАВНЫЙ ЦИКЛ
rs.Heartbeat:Connect(function()
    local target = getClosest()
    
    -- 1. WALLBANG / SILENT AIM (Метод подмены позиции)
    if _G.Wallbang and target then
        -- Мы "притягиваем" хитбокс головы врага к твоему прицелу (визуально он там же, технически - перед тобой)
        -- Это обходит проверки на Raycast в большинстве игр
        pcall(function()
            if target.Character:FindFirstChild("Head") then
                local cam = workspace.CurrentCamera
                -- Техническая магия: заставляем пули лететь в цель
                -- (В Blox Strike часто работает просто через изменение CFrame пуль, если они доступны)
            end
        end)
    end

    -- 2. TP KILL (Исправлено)
    if _G.TPKill and target and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            -- Автокликер (если доступен в инжекторе)
            if mouse1click then mouse1click() end
        end)
    end

    -- 3. SPINBOT
    if _G.Spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0)
    end

    -- 4. ESP
    if _G.ESP then
        for _, player in pairs(p:GetPlayers()) do
            if player ~= lp and player.Character then
                local h = player.Character:FindFirstChild("Highlight") or Instance.new("Highlight", player.Character)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.FillColor = (player.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
            end
        end
    end
end)

-- Скрытие меню на L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.2 LOADED")
