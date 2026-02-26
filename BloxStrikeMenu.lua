--[[
    TERMINATOR v4.0 // BLOX STRIKE ULTIMATE
    - NEW: CROSS-MAP WALLBANG (Raycast Hook)
    - NEW: AUTO-KILL (Trigger integration)
    - UPDATED: TP-Kill (Smoother logic)
    - FIXED: ESP & Spinbot
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local mouse = lp:GetMouse()

-- Очистка старого UI
for _, v in pairs(cg:GetChildren()) do if v.Name == "Terminator_V4" then v:Destroy() end end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V4"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 520)
main.Position = UDim2.new(0.5, -160, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(15, 0, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 255, 150)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,2,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ СОСТОЯНИЕ ]
_G.TPKill = false
_G.Spin = false
_G.Wallbang = false
_G.AutoKill = false
_G.ESP = false

local function addTgl(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 10, 30)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.BackgroundColor3 = act and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(25, 10, 30)
        cb(act)
    end)
end

--------------------------------------------------
-- ЛОГИКА ПОИСКА (ДЛЯ ВСЕХ МОДУЛЕЙ)
--------------------------------------------------
local function getTarget()
    local target = nil; local dist = math.huge
    for _, player in pairs(p:GetPlayers()) do
        if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("Head") then
            local mag = (player.Character.Head.Position - lp.Character.Head.Position).Magnitude
            if mag < dist then dist = mag; target = player end
        end
    end
    return target
end

--------------------------------------------------
-- 1. CROSS-MAP WALLBANG (ГЛАВНАЯ ФИШКА)
--------------------------------------------------
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if _G.Wallbang and (method == "Raycast" or method == "FindPartOnRay") and not checkcaller() then
        local t = getTarget()
        if t then
            -- Телепортируем луч прямо к голове врага
            args[1] = t.Character.Head.Position + Vector3.new(0, 1, 0)
            args[2] = Vector3.new(0, -2, 0)
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

addTgl("CROSS-MAP WALLBANG", function(v) _G.Wallbang = v end)

--------------------------------------------------
-- 2. ТЕЛЕПОРТ-КИЛЛ + АВТО-КИЛЛ
--------------------------------------------------
addTgl("TP-KILL + AUTO-FIRE", function(v)
    _G.TPKill = v
    task.spawn(function()
        while _G.TPKill do
            local t = getTarget()
            if t and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                
                -- Быстрый выстрел
                if typeof(mouse1click) == "function" then mouse1click()
                else keypress(0x01); task.wait(0.01); keyrelease(0x01) end
            end
            task.wait(0.1)
        end
    end)
end)

--------------------------------------------------
-- 3. ESP & SPINBOT & TEXTURES
--------------------------------------------------
addTgl("ULTIMATE ESP", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Character then
                    local h = player.Character:FindFirstChild("V4_ESP") or Instance.new("Highlight", player.Character)
                    h.Name = "V4_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillColor = (player.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
                end
            end
            task.wait(1)
        end
    end)
end)

addTgl("RAGE SPINBOT", function(v)
    _G.Spin = v
    task.spawn(function()
        while _G.Spin do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(70), 0)
            end
            rs.Heartbeat:Wait()
        end
    end)
end)

addTgl("NO TEXTURES (FPS BOOST)", function(v)
    for _, obj in pairs(workspace:GetDescendants()) do
        if v and obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
        elseif v and (obj:IsA("Texture") or obj:IsA("Decal")) then obj.Transparency = 1 end
    end
end)

-- Скрытие на L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.0 // GOD MODE ENABLED")
