--[[
    TERMINATOR v5.1 // COSMIC UPDATE
    - NEW: Tab Settings (Right Click on Toggle)
    - NEW: Particle Rain ($, ★, ♥) - Right Click to Choose
    - NEW: Custom Sky Color - Right Click to Choose
    - NEW: Day / Night Cycle Buttons
    - OPTIMIZED: Apollyon Engine v2
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

-- Очистка
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") or v.Name:find("Loader") then v:Destroy() end end

--------------------------------------------------
-- [ ГЛОБАЛЬНЫЕ НАСТРОЙКИ v5.1 ]
--------------------------------------------------
_G.Aimbot = false; _G.ESP = false; _G.FullBright = false
_G.ParticleRain = false; _G.RainType = "$" -- Варианты: "$", "★", "♥"
_G.CustomSky = false; _G.SkyColor = Color3.fromRGB(255, 0, 0) -- Дефолт: Красный

--------------------------------------------------
-- [ МЕНЮ v5.1 ]
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V5_1"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 400); main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

-- Вкладки
local tabs = Instance.new("Frame", main); tabs.Size = UDim2.new(1, -20, 0, 40); tabs.Position = UDim2.new(0, 10, 0, 10); tabs.BackgroundTransparency = 1
local b1 = Instance.new("TextButton", tabs); b1.Size = UDim2.new(0.5,-2,1,0); b1.Text = "COMBAT"; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.TextColor3 = Color3.new(1,1,1); b1.Font = Enum.Font.GothamBold; Instance.new("UICorner", b1)
local b2 = Instance.new("TextButton", tabs); b2.Size = UDim2.new(0.5,-2,1,0); b2.Position = UDim2.new(0.5,2,0,0); b2.Text = "VISUALS"; b2.BackgroundColor3 = Color3.fromRGB(30,30,30); b2.TextColor3 = Color3.new(1,1,1); b2.Font = Enum.Font.GothamBold; Instance.new("UICorner", b2)

-- Страницы
local p1 = Instance.new("ScrollingFrame", main); p1.Size = UDim2.new(1,-20,1,-70); p1.Position = UDim2.new(0,10,0,60); p1.BackgroundTransparency = 1; p1.Visible = true; p1.ScrollBarThickness = 0; Instance.new("UIListLayout", p1).Padding = UDim.new(0,5)
local p2 = Instance.new("ScrollingFrame", main); p2.Size = UDim2.new(1,-20,1,-70); p2.Position = UDim2.new(0,10,0,60); p2.BackgroundTransparency = 1; p2.Visible = false; p2.ScrollBarThickness = 0; Instance.new("UIListLayout", p2).Padding = UDim.new(0,5)

b1.MouseButton1Click:Connect(function() p1.Visible = true; p2.Visible = false; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b2.BackgroundColor3 = Color3.fromRGB(30,30,30) end)
b2.MouseButton1Click:Connect(function() p1.Visible = false; p2.Visible = true; b2.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.BackgroundColor3 = Color3.fromRGB(30,30,30) end)

--------------------------------------------------
-- [ ОКНА НАСТРОЕК (ПОДМЕНЮ) ]
--------------------------------------------------
local function createSettingsFrame(name, size)
    local frame = Instance.new("Frame", main)
    frame.Name = name.."_Settings"
    frame.Size = size; frame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); frame.Visible = false; frame.ZIndex = 10
    Instance.new("UICorner", frame); Instance.new("UIStroke", frame).Color = Color3.fromRGB(255, 0, 0)
    Instance.new("UIListLayout", frame).Padding = UDim.new(0, 5)
    
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(1, 0, 0, 25); close.Text = "CLOSE"; close.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    close.TextColor3 = Color3.new(1, 1, 1); close.Font = Enum.Font.Code; close.ZIndex = 11
    close.MouseButton1Click:Connect(function() frame.Visible = false end)
    
    return frame
end

local rainSettings = createSettingsFrame("Rain", UDim2.new(0, 200, 0, 150))
local skySettings = createSettingsFrame("Sky", UDim2.new(0, 200, 0, 180))

local function addSettingBtn(parent, txt, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 30); b.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.Gotham; b.ZIndex = 11
    b.MouseButton1Click:Connect(callback)
end

-- Настройки дождя
addSettingBtn(rainSettings, "$ Dollars $", function() _G.RainType = "$"; rainSettings.Visible = false end)
addSettingBtn(rainSettings, "★ Stars ★", function() _G.RainType = "★"; rainSettings.Visible = false end)
addSettingBtn(rainSettings, "♥ Hearts ♥", function() _G.RainType = "♥"; rainSettings.Visible = false end)

-- Настройки неба
local function setSky(color) _G.SkyColor = color; skySettings.Visible = false end
addSettingBtn(skySettings, "Neon Red", function() setSky(Color3.fromRGB(255, 0, 0)) end)
addSettingBtn(skySettings, "Deep Blue", function() setSky(Color3.fromRGB(0, 0, 255)) end)
addSettingBtn(skySettings, "Toxic Green", function() setSky(Color3.fromRGB(0, 255, 0)) end)
addSettingBtn(skySettings, "Hot Pink", function() setSky(Color3.fromRGB(255, 0, 255)) end)

--------------------------------------------------
-- [ ДОБАВЛЕНИЕ КНОПОК ]
--------------------------------------------------
local function addTgl(txt, var, parent, rightClick)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,40); btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.Text = txt; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn)
    
    -- Левый клик: Вкл/Выкл
    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(100,0,0) or Color3.fromRGB(25,25,25)
    end)
    
    -- Правый клик: Настройки
    if rightClick then
        btn.MouseButton2Click:Connect(rightClick)
    end
end

-- COMBAT
addTgl("HARD AIMBOT", "Aimbot", p1)

-- VISUALS
addTgl("WALLHACK (CHAMS)", "ESP", p2)
addTgl("FULLBRIGHT / NO FOG", "FullBright", p2)
addTgl("PARTICLE RAIN (RMB)", "ParticleRain", p2, function() rainSettings.Visible = not rainSettings.Visible end)
addTgl("CUSTOM SKY (RMB)", "CustomSky", p2, function() skySettings.Visible = not skySettings.Visible end)

-- Кнопки ДЕНЬ / НОЧЬ (Они не триггеры, а разовые)
local cycleBtn = Instance.new("TextButton", p2)
cycleBtn.Size = UDim2.new(1, 0, 0, 40); cycleBtn.Text = "SET DAY / NIGHT"; cycleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 150)
cycleBtn.TextColor3 = Color3.new(1, 1, 1); cycleBtn.Font = Enum.Font.GothamBold; Instance.new("UICorner", cycleBtn)
cycleBtn.MouseButton1Click:Connect(function()
    lighting.ClockTime = (lighting.ClockTime < 12) and 14 or 0 -- Переключение День(14) / Ночь(0)
end)

--------------------------------------------------
-- [ ЯДРО v5.1 "Cosmic" ]
--------------------------------------------------

-- Локальный дождь из партиклов
local rainAttachment = Instance.new("Attachment", workspace.Terrain)
local rainEmitter = Instance.new("ParticleEmitter", rainAttachment)
rainEmitter.Enabled = false
rainEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds" -- Дефолт
rainEmitter.Lifetime = NumberRange.new(5, 7)
rainEmitter.Speed = NumberRange.new(20, 30)
rainEmitter.VelocitySpread = 180
rainEmitter.EmissionDirection = Enum.NormalId.Bottom
rainEmitter.Acceleration = Vector3.new(0, -10, 0)
rainEmitter.Rate = 0 -- Дефолт

-- Кастомное небо
local cSky = Instance.new("Sky", lighting)
cSky.Enabled = false

rs.RenderStepped:Connect(function()
    -- ОБНОВЛЕНИЕ НЕБА
    if _G.CustomSky then
        cSky.Enabled = true
        cSky.SkyboxBk = _G.SkyColor
        cSky.SkyboxDn = _G.SkyColor
        cSky.SkyboxFt = _G.SkyColor
        cSky.SkyboxLf = _G.SkyColor
        cSky.SkyboxRt = _G.SkyColor
        cSky.SkyboxUp = _G.SkyColor
    else
        cSky.Enabled = false
    end

    -- ОБНОВЛЕНИЕ ДОЖДЯ
    if _G.ParticleRain and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = lp.Character.HumanoidRootPart
        rainAttachment.Position = hrp.Position + Vector3.new(0, 50, 0) -- Позиция над головой
        rainEmitter.Enabled = true
        rainEmitter.Rate = 50 -- Плотность дождя
        
        -- Смена типа партикла
        if _G.RainType == "$" then rainEmitter.Texture = "rbxassetid://10849911874" -- $
        elseif _G.RainType == "★" then rainEmitter.Texture = "rbxassetid://10849919137" -- ★
        elseif _G.RainType == "♥" then rainEmitter.Texture = "rbxassetid://10849924294" -- ♥
        end
    else
        rainEmitter.Enabled = false
    end

    -- FULLBRIGHT
    if _G.FullBright then lighting.Brightness = 3; lighting.Ambient = Color3.new(1,1,1); lighting.FogEnd = 1e5 end

    -- ESP & AIM (Классика)
    if _G.ESP then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character); hl.Name = "T_ESP"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop; hl.FillColor = Color3.new(1, 0, 0)
            end
        end
    end
    if _G.Aimbot then
        local target = nil; local dist = math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local mag = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if mag < dist then dist = mag; target = pl end
            end
        end
        if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)
print("TERMINATOR v5.1 COSMIC LOADED")
