--[[
    TERMINATOR v8.0 // OUTLINE LEGIT EDITION
    - FEATURE: Replace Boxes with Smooth Outline (Highlight)
    - SAFETY: Use Roblox Internal Engine for Rendering
    - UPDATED: Tab System & Ghost Visuals
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- Чистка
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end
for _, v in pairs(cam:GetChildren()) do if v.Name:find("T_Ghost") then v:Destroy() end end

--------------------------------------------------
-- [ ГЛОБАЛКИ ]
--------------------------------------------------
_G.Aimbot = false; _G.SafeSky = false; _G.SafeRain = false
_G.RainType = "$"; _G.OutlineEsp = false; _G.FullBright = false

--------------------------------------------------
-- [ ИНТЕРФЕЙС v8.0 ]
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V8"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 400); main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(0, 1, 1)

-- Tabs
local tabs = Instance.new("Frame", main); tabs.Size = UDim2.new(1, -20, 0, 35); tabs.Position = UDim2.new(0, 10, 0, 40); tabs.BackgroundTransparency = 1
local b_comb = Instance.new("TextButton", tabs); b_comb.Size = UDim2.new(0.5,-2,1,0); b_comb.Text = "COMBAT"; b_comb.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b_comb.TextColor3 = Color3.new(1,1,1); b_comb.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_comb)
local b_vis = Instance.new("TextButton", tabs); b_vis.Size = UDim2.new(0.5,-2,1,0); b_vis.Position = UDim2.new(0.5,2,0,0); b_vis.Text = "VISUALS"; b_vis.BackgroundColor3 = Color3.fromRGB(0, 120, 120); b_vis.TextColor3 = Color3.new(1,1,1); b_vis.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_vis)

-- Pages
local p_comb = Instance.new("ScrollingFrame", main); p_comb.Size = UDim2.new(1,-20,1,-90); p_comb.Position = UDim2.new(0,10,0,80); p_comb.BackgroundTransparency = 1; p_comb.ScrollBarThickness = 0; p_comb.Visible = false; Instance.new("UIListLayout", p_comb).Padding = UDim.new(0,5)
local p_vis = Instance.new("ScrollingFrame", main); p_vis.Size = UDim2.new(1,-20,1,-90); p_vis.Position = UDim2.new(0,10,0,80); p_vis.BackgroundTransparency = 1; p_vis.ScrollBarThickness = 0; p_vis.Visible = true; Instance.new("UIListLayout", p_vis).Padding = UDim.new(0,5)

b_comb.MouseButton1Click:Connect(function() p_comb.Visible = true; p_vis.Visible = false; b_comb.BackgroundColor3 = Color3.fromRGB(0, 120, 120); b_vis.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end)
b_vis.MouseButton1Click:Connect(function() p_vis.Visible = true; p_comb.Visible = false; b_vis.BackgroundColor3 = Color3.fromRGB(0, 120, 120); b_comb.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end)

local function addTgl(txt, var, parent, rmb)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.Code; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(20, 20, 25)
    end)
    if rmb then b.MouseButton2Click:Connect(rmb) end
end

--------------------------------------------------
-- [ КНОПКИ ]
--------------------------------------------------
addTgl("SMOOTH AIMBOT", "Aimbot", p_comb)

-- VISUALS
addTgl("GHOST SKY (CYAN)", "SafeSky", p_vis)
addTgl("PARTICLE RAIN (RMB)", "SafeRain", p_vis, function()
    _G.RainType = (_G.RainType == "$") and "★" or (_G.RainType == "★") and "♥" or "$"
end)
addTgl("LEGIT ESP (OUTLINE)", "OutlineEsp", p_vis) -- ВОТ ЭТА КНОПКА ОБНОВИЛАСЬ
addTgl("FULLBRIGHT / NO FOG", "FullBright", p_vis)

--------------------------------------------------
-- [ GHOST LOGIC ]
--------------------------------------------------
local att = Instance.new("Attachment", cam); att.Name = "T_Ghost_Att"
local rain = Instance.new("ParticleEmitter", att); rain.Enabled = false; rain.Lifetime = NumberRange.new(3, 4); rain.Speed = NumberRange.new(45); rain.Acceleration = Vector3.new(0, -30, 0); rain.Rate = 0
local defAmb = lighting.Ambient

rs.RenderStepped:Connect(function()
    -- Дождь
    if _G.SafeRain then
        att.CFrame = cam.CFrame * CFrame.new(0, 25, -35)
        rain.Enabled = true; rain.Rate = 75
        rain.Texture = (_G.RainType == "$") and "rbxassetid://10849911874" or (_G.RainType == "★") and "rbxassetid://10849919137" or "rbxassetid://10849924294"
    else rain.Enabled = false end

    -- Небо
    if _G.SafeSky then lighting.Ambient = Color3.fromRGB(0, 255, 255) else lighting.Ambient = defAmb end
    if _G.FullBright then lighting.Brightness = 2; lighting.FogEnd = 1e6 end

    -- НОВОЕ ОБНОВЛЕННОЕ ВХ (OUTLINE)
    if _G.OutlineEsp then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                local char = pl.Character
                local hl = char:FindFirstChild("T_Outline_ESP") or Instance.new("Highlight", char)
                
                hl.Name = "T_Outline_ESP"
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Видит сквозь стены
                hl.FillTransparency = 1 -- Отключаем заливку внутри (чтобы был только контур)
                hl.OutlineTransparency = 0.2 -- Прозрачность контура
                
                -- Цвет контура
                if pl.Team ~= lp.Team then
                    hl.OutlineColor = Color3.new(1, 0, 0) -- Враг Красный
                else
                    hl.OutlineColor = Color3.new(0, 1, 0) -- Свой Зеленый
                end
            end
        end
    else
        -- Чистка при выключении
        for _, pl in pairs(p:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("T_Outline_ESP") then
                pl.Character.T_Outline_ESP:Destroy()
            end
        end
    end
    
    -- Аим
    if _G.Aimbot then
        local target, dist = nil, math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local m = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if m < dist then dist = m; target = pl end
            end
        end
        if target then cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.Head.Position) end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)

print("TERMINATOR v8.0 OUTLINE EDITION READY")
