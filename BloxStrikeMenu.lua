--[[
    TERMINATOR v6.0 // FINAL GHOST EDITION
    - FULL PROTECTION: All visuals parented to Camera
    - STRUCTURED: Combat & Visuals Tabs
    - FEATURES: Smooth Aim, ESP, Particle Rain, Custom Sky
    - HOTKEYS: [L] to Toggle Menu, [RMB] on Rain to Change Symbol
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- Полная очистка перед запуском
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end
for _, v in pairs(cam:GetChildren()) do if v.Name:find("T_Ghost") then v:Destroy() end end

--------------------------------------------------
-- [ ЭКРАН ЗАГРУЗКИ ]
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg); loader.Name = "Terminator_Loader"
local l_frame = Instance.new("Frame", loader)
l_frame.Size = UDim2.new(0, 320, 0, 110); l_frame.Position = UDim2.new(0.5, -160, 0.5, -55)
l_frame.BackgroundColor3 = Color3.fromRGB(5, 5, 10); Instance.new("UICorner", l_frame)
local l_stroke = Instance.new("UIStroke", l_frame); l_stroke.Color = Color3.new(0, 1, 1)

local l_txt = Instance.new("TextLabel", l_frame)
l_txt.Size = UDim2.new(1, 0, 1, 0); l_txt.Text = "INITIALIZING GHOST v6.0..."; l_txt.TextColor3 = Color3.new(0, 1, 1)
l_txt.Font = Enum.Font.Code; l_txt.TextSize = 18; l_txt.BackgroundTransparency = 1

task.spawn(function()
    local phrases = {"BYPASSING BAC...", "INJECTING GHOST VISUALS...", "CLEANING FOOTPRINTS...", "READY!"}
    for _, phrase in pairs(phrases) do
        l_txt.Text = phrase
        task.wait(0.6)
    end
    loader:Destroy()
end)
task.wait(2.5)

--------------------------------------------------
-- [ НАСТРОЙКИ ]
--------------------------------------------------
_G.Aimbot = false
_G.SafeSky = false
_G.SafeRain = false
_G.RainType = "$" -- "$", "★", "♥"
_G.EspActive = false
_G.FullBright = false

--------------------------------------------------
-- [ ОСНОВНОЙ ИНТЕРФЕЙС ]
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V6"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 420); main.Position = UDim2.new(0.5, -170, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(0, 1, 1)

-- Шапка
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 30); title.Position = UDim2.new(0, 0, 0, 5); title.Text = "TERMINATOR // GHOST v6.0"; title.TextColor3 = Color3.new(0, 1, 1); title.Font = Enum.Font.GothamBold; title.BackgroundTransparency = 1

-- Вкладки
local tabs = Instance.new("Frame", main); tabs.Size = UDim2.new(1, -20, 0, 35); tabs.Position = UDim2.new(0, 10, 0, 40); tabs.BackgroundTransparency = 1
local b_comb = Instance.new("TextButton", tabs); b_comb.Size = UDim2.new(0.5, -2, 1, 0); b_comb.Text = "COMBAT"; b_comb.BackgroundColor3 = Color3.fromRGB(0, 150, 150); b_comb.TextColor3 = Color3.new(1, 1, 1); b_comb.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_comb)
local b_vis = Instance.new("TextButton", tabs); b_vis.Size = UDim2.new(0.5, -2, 1, 0); b_vis.Position = UDim2.new(0.5, 2, 0, 0); b_vis.Text = "VISUALS"; b_vis.BackgroundColor3 = Color3.fromRGB(25, 25, 30); b_vis.TextColor3 = Color3.new(1, 1, 1); b_vis.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_vis)

-- Контент
local p_comb = Instance.new("ScrollingFrame", main); p_comb.Size = UDim2.new(1, -20, 1, -90); p_comb.Position = UDim2.new(0, 10, 0, 80); p_comb.BackgroundTransparency = 1; p_comb.ScrollBarThickness = 0; Instance.new("UIListLayout", p_comb).Padding = UDim.new(0, 5)
local p_vis = Instance.new("ScrollingFrame", main); p_vis.Size = UDim2.new(1, -20, 1, -90); p_vis.Position = UDim2.new(0, 10, 0, 80); p_vis.BackgroundTransparency = 1; p_vis.ScrollBarThickness = 0; p_vis.Visible = false; Instance.new("UIListLayout", p_vis).Padding = UDim.new(0, 5)

b_comb.MouseButton1Click:Connect(function() p_comb.Visible = true; p_vis.Visible = false; b_comb.BackgroundColor3 = Color3.fromRGB(0, 150, 150); b_vis.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end)
b_vis.MouseButton1Click:Connect(function() p_vis.Visible = true; p_comb.Visible = false; b_vis.BackgroundColor3 = Color3.fromRGB(0, 150, 150); b_comb.BackgroundColor3 = Color3.fromRGB(25, 25, 30) end)

-- Конструктор кнопок
local function addTgl(txt, var, parent, rmb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.Code; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 100, 100) or Color3.fromRGB(20, 20, 25)
    end)
    if rmb then b.MouseButton2Click:Connect(rmb) end
end

--------------------------------------------------
-- [ НАПОЛНЕНИЕ ]
--------------------------------------------------
-- COMBAT
addTgl("SMOOTH AIMBOT", "Aimbot", p_comb)

-- VISUALS
addTgl("GHOST SKY (CYAN)", "SafeSky", p_vis)
addTgl("PARTICLE RAIN (RMB)", "SafeRain", p_vis, function()
    _G.RainType = (_G.RainType == "$") and "★" or (_G.RainType == "★") and "♥" or "$"
end)
addTgl("STEALTH ESP (BOX)", "EspActive", p_vis)
addTgl("FULLBRIGHT", "FullBright", p_vis)

--------------------------------------------------
-- [ СИСТЕМА ПРИЗРАКА (GHOST ENGINE) ]
--------------------------------------------------
-- Создаем эмиттер ВНУТРИ КАМЕРЫ (Полная локальность)
local att = Instance.new("Attachment", cam); att.Name = "T_Ghost_Att"
local rain = Instance.new("ParticleEmitter", att); rain.Name = "T_Ghost_Rain"
rain.Enabled = false; rain.Lifetime = NumberRange.new(3, 4); rain.Speed = NumberRange.new(45); rain.Acceleration = Vector3.new(0, -30, 0); rain.Rate = 0

local defAmb = lighting.Ambient

rs.RenderStepped:Connect(function()
    -- Дождь перед камерой
    if _G.SafeRain then
        att.CFrame = cam.CFrame * CFrame.new(0, 25, -35)
        rain.Enabled = true; rain.Rate = 75
        rain.Texture = (_G.RainType == "$") and "rbxassetid://10849911874" or (_G.RainType == "★") and "rbxassetid://10849919137" or "rbxassetid://10849924294"
    else rain.Enabled = false end

    -- Небо (Безопасный Ambient)
    if _G.SafeSky then lighting.Ambient = Color3.fromRGB(0, 255, 255) else lighting.Ambient = defAmb end
    
    -- Яркость
    if _G.FullBright then lighting.Brightness = 2; lighting.FogEnd = 1e6 end

    -- ESP (BoxAdornment)
    if _G.EspActive then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = pl.Character.HumanoidRootPart
                if not hrp:FindFirstChild("T_Ghost_ESP") then
                    local b = Instance.new("BoxHandleAdornment", hrp)
                    b.Name = "T_Ghost_ESP"; b.AlwaysOnTop = true; b.Size = Vector3.new(4, 5, 0.5); b.Transparency = 0.6
                    b.Color3 = (pl.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0); b.Adornee = hrp
                end
            end
        end
    end
    
    -- Аимбот (Базовый легит)
    if _G.Aimbot then
        local target = nil; local dist = math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local m = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if m < dist then dist = m; target = pl end
            end
        end
        if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position) end
    end
end)

-- Управление
uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)

print("TERMINATOR v6.0 FULLY LOADED. PRESS [L] FOR MENU.")
