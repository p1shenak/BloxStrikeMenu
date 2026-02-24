--[[
    TERMINATOR v2.2 // TP-KILL EDITION
    - NEW: TP-Kill (Teleport behind enemy)
    - FIXED: Spinbot & Movement
    - COMBAT: Hitbox Expander & ESP
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

-- Очистка интерфейса
for _, v in pairs(cg:GetChildren()) do if v.Name == "Terminator_V2_2" then v:Destroy() end end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V2_2"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 480)
main.Position = UDim2.new(0.5, -150, 0.5, -240)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 10)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(200, 0, 255)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,1.8,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ ПЕРЕМЕННЫЕ ]
_G.TPKill = false
_G.Spin = false
_G.Wallbang = false

local function addTgl(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(30, 10, 35)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.BackgroundColor3 = act and Color3.fromRGB(150, 0, 200) or Color3.fromRGB(30, 10, 35)
        cb(act)
    end)
end

--------------------------------------------------
-- ЛОГИКА ПОИСКА ЦЕЛИ
--------------------------------------------------
local function getClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, player in pairs(p:GetPlayers()) do
        if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (player.Character.HumanoidRootPart.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                target = player
            end
        end
    end
    return target
end

--------------------------------------------------
-- 1. ТЕЛЕПОРТ-КИЛЛ (TP KILL)
--------------------------------------------------
addTgl("ACTIVATE TP-KILL", function(v)
    _G.TPKill = v
    task.spawn(function()
        while _G.TPKill do
            local target = getClosestPlayer()
            if target and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                -- Телепорт за спину врага (на 3 студа сзади)
                local enemyRoot = target.Character.HumanoidRootPart
                lp.Character.HumanoidRootPart.CFrame = enemyRoot.CFrame * CFrame.new(0, 0, 3)
                
                -- Авто-выстрел (эмуляция клика)
                if typeof(mouse1click) == "function" then
                    mouse1click()
                else
                    keypress(0x01); task.wait(0.01); keyrelease(0x01)
                end
            end
            task.wait(0.1) -- Задержка между прыжками
        end
    end)
end)

--------------------------------------------------
-- 2. ФИКСИРОВАННАЯ КРУТИЛКА
--------------------------------------------------
addTgl("SPINBOT", function(v)
    _G.Spin = v
    task.spawn(function()
        while _G.Spin do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(60), 0)
            end
            rs.Heartbeat:Wait()
        end
    end)
end)

--------------------------------------------------
-- 3. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
--------------------------------------------------
addTgl("ESP (CHAMS)", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Character then
                    local h = player.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", player.Character)
                    h.Name = "T_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
            task.wait(1)
        end
    end)
end)

addTgl("MAP WALLBANG (HEADS)", function(v)
    _G.Wallbang = v
    task.spawn(function()
        while _G.Wallbang do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("Head") then
                    player.Character.Head.Size = v and Vector3.new(15, 15, 15) or Vector3.new(1, 1, 1)
                    player.Character.Head.CanCollide = false
                    player.Character.Head.Transparency = v and 0.5 or 0
                end
            end
            task.wait(1)
        end
    end)
end)

-- Скрытие меню на L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v2.2 // TP-KILL LOADED")
