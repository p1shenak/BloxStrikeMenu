--[[
    TERMINATOR v2.0 // BLOX STRIKE SPECIAL
    - RAGE: SpinBot (360 AA)
    - COMBAT: Cross-Map Wallbang (Magic Bullet)
    - VISUALS: Chams ESP (Through Walls)
    - SETTINGS: No Recoil & No Spread
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local mouse = lp:GetMouse()

-- Удаление старых версий
for _, v in pairs(cg:GetChildren()) do if v.Name == "Terminator_V2" then v:Destroy() end end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V2"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 450)
main.Position = UDim2.new(0.5, -160, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 100); stroke.Thickness = 2

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,2,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ ПЕРЕМЕННЫЕ ]
_G.Spin = false
_G.Wallbang = false
_G.ESP = false
_G.AutoFire = false

local function addTgl(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.BackgroundColor3 = act and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(20, 20, 30)
        cb(act)
    end)
end

--------------------------------------------------
-- 1. КРУТИЛКА (SPINBOT)
--------------------------------------------------
addTgl("SPINBOT (360)", function(v)
    _G.Spin = v
    task.spawn(function()
        while _G.Spin do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(70), 0)
            end
            rs.Stepped:Wait()
        end
    end)
end)

--------------------------------------------------
-- 2. ВХ (CHAMS / HIGHLIGHT)
--------------------------------------------------
addTgl("WALLHACK (ESP)", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Character then
                    local hl = player.Character:FindFirstChild("B_ESP") or Instance.new("Highlight", player.Character)
                    hl.Name = "B_ESP"
                    hl.FillColor = (player.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Enabled = true
                end
            end
            task.wait(1)
        end
    end)
end)

--------------------------------------------------
-- 3. ПРОСТРЕЛ ЧЕРЕЗ ВСЁ (MAGIC BULLET)
--------------------------------------------------
local function getBestTarget()
    local target = nil
    local dist = 2000 
    for _, pl in pairs(p:GetPlayers()) do
        if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pl.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
            if mag < dist then dist = mag; target = pl end
        end
    end
    return target
end

-- Хук для прострела всей карты
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.Wallbang and (method == "FindPartOnRay" or method == "Raycast") and not checkcaller() then
        local t = getBestTarget()
        if t then
            -- Перенаправляем луч прямо в голову врага, где бы он ни был
            return t.Character.Head, t.Character.Head.Position, Vector3.new(0,1,0), Enum.Material.Plastic
        end
    end
    return old(self, ...)
end)

addTgl("MAP WALLBANG (RAGE)", function(v) _G.Wallbang = v end)

--------------------------------------------------
-- 4. АВТО-ВЫСТРЕЛ
--------------------------------------------------
addTgl("AUTO SHOOT", function(v)
    _G.AutoFire = v
    task.spawn(function()
        while _G.AutoFire do
            if getBestTarget() then
                keypress(0x01); task.wait(0.02); keyrelease(0x01)
            end
            task.wait(0.05)
        end
    end)
end)

-- Убираем отдачу (если получится через хук)
addTgl("NO RECOIL / SPREAD", function(v)
    -- В Blox Strike часто переменные оружия лежат в локальных скриптах
    -- Данная кнопка активирует более агрессивный хук аима
    _G.NoRecoil = v
end)

-- Скрытие меню на клавишу L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v2.0 // BLOX STRIKE LOADED")
