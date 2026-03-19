--[[
    TERMINATOR v4.7 // PERFORMANCE FIX
    - FIXED: Lag from Anti-Flash/Smoke
    - FIXED: Wall-Piercing ESP (Highlight Mode)
    - NEW: Optimized Target System
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")

-- Удаление старого мусора
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

--------------------------------------------------
-- ИНТЕРФЕЙС (УПРОЩЕННЫЙ ДЛЯ ФПС)
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V4_7"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 380); main.Position = UDim2.new(0.5, -160, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); main.Active = true; main.Draggable = true
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 40); tabFrame.BackgroundTransparency = 1

local b1 = Instance.new("TextButton", tabFrame); b1.Size = UDim2.new(0.5,0,1,0); b1.Text = "COMBAT"; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.TextColor3 = Color3.new(1,1,1)
local b2 = Instance.new("TextButton", tabFrame); b2.Size = UDim2.new(0.5,0,1,0); b2.Position = UDim2.new(0.5,0,0,0); b2.Text = "VISUALS"; b2.BackgroundColor3 = Color3.fromRGB(30,30,30); b2.TextColor3 = Color3.new(1,1,1)

local p1 = Instance.new("ScrollingFrame", main); p1.Size = UDim2.new(1,-20,1,-60); p1.Position = UDim2.new(0,10,0,50); p1.BackgroundTransparency = 1; p1.Visible = true; p1.ScrollBarThickness = 0
local p2 = Instance.new("ScrollingFrame", main); p2.Size = UDim2.new(1,-20,1,-60); p2.Position = UDim2.new(0,10,0,50); p2.BackgroundTransparency = 1; p2.Visible = false; p2.ScrollBarThickness = 0
Instance.new("UIListLayout", p1).Padding = UDim.new(0,5); Instance.new("UIListLayout", p2).Padding = UDim.new(0,5)

b1.MouseButton1Click:Connect(function() p1.Visible = true; p2.Visible = false; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b2.BackgroundColor3 = Color3.fromRGB(30,30,30) end)
b2.MouseButton1Click:Connect(function() p1.Visible = false; p2.Visible = true; b2.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.BackgroundColor3 = Color3.fromRGB(30,30,30) end)

_G.Aimbot = false; _G.ESP = false; _G.AntiFlash = false; _G.AntiSmoke = false

local function addTgl(txt, var, parent)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1,0,0,40); btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.Text = txt; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(150,0,0) or Color3.fromRGB(25,25,25)
    end)
end

addTgl("HARD AIMBOT", "Aimbot", p1)
addTgl("WALLHACK (HIGHLIGHT)", "ESP", p2)
addTgl("NO FLASH", "AntiFlash", p2)
addTgl("NO SMOKE", "AntiSmoke", p2)

--------------------------------------------------
-- ЛОГИКА ОПТИМИЗАЦИИ
--------------------------------------------------

-- Чистка дыма (раз в 2 секунды, чтобы не лагало)
task.spawn(function()
    while task.wait(2) do
        if _G.AntiSmoke then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") and (v.Name:lower():find("smoke") or v.Name:lower():find("gas")) then
                    v.Enabled = false
                end
            end
        end
    end
end)

-- Анти-Флеш через слежку за GUI
lp.PlayerGui.DescendantAdded:Connect(function(v)
    if _G.AntiFlash and v:IsA("Frame") and (v.Name:lower():find("flash") or v.Name:lower():find("blind")) then
        task.wait()
        v.Visible = false
    end
end)

rs.RenderStepped:Connect(function()
    -- АИМБОТ
    if _G.Aimbot then
        local target, closestDist = nil, math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pl.Character.Head.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                    if mag < closestDist then closestDist = mag; target = pl end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end

    -- ВХ (HIGHLIGHT - ВИДНО СКВОЗЬ СТЕНЫ)
    if _G.ESP then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                hl.Name = "T_ESP"
                hl.Enabled = true
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- ПРИНУДИТЕЛЬНО ПОВЕРХ ВСЕГО
                hl.FillColor = (pl.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
                hl.FillTransparency = 0.4
                hl.OutlineColor = Color3.new(1,1,1)
            end
        end
    else
        for _, pl in pairs(p:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("T_ESP") then pl.Character.T_ESP.Enabled = false end
        end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)
print("TERMINATOR v4.7 LOADED")
