--[[
    TERMINATOR v10.0 // FULL RESTORE
    - RESTORED: Aimbot, FullBright, ESP, SkinChanger
    - INTERFACE: Loading Bar + Notifications
    - HOTKEYS: [L] Menu, [Hold RMB] Aim
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- Очистка старых следов
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

--------------------------------------------------
-- [ СИСТЕМА УВЕДОМЛЕНИЙ ]
--------------------------------------------------
local function Notify(title, text, color)
    local n_sg = cg:FindFirstChild("T_Notify") or Instance.new("ScreenGui", cg); n_sg.Name = "T_Notify"
    local n_frame = Instance.new("Frame", n_sg)
    n_frame.Size = UDim2.new(0, 220, 0, 65); n_frame.Position = UDim2.new(1, 10, 0.8, 0)
    n_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", n_frame)
    Instance.new("UIStroke", n_frame).Color = color or Color3.new(0, 1, 1)
    
    local t_lab = Instance.new("TextLabel", n_frame)
    t_lab.Size = UDim2.new(1, 0, 0, 30); t_lab.Text = title; t_lab.TextColor3 = color; t_lab.Font = Enum.Font.GothamBold; t_lab.BackgroundTransparency = 1; t_lab.TextSize = 14
    
    local d_lab = Instance.new("TextLabel", n_frame)
    d_lab.Size = UDim2.new(1, 0, 0, 35); d_lab.Position = UDim2.new(0, 0, 0, 25); d_lab.Text = text; d_lab.TextColor3 = Color3.new(1,1,1); d_lab.Font = Enum.Font.Code; d_lab.BackgroundTransparency = 1; d_lab.TextSize = 12
    
    n_frame:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Back", 0.4)
    task.spawn(function()
        task.wait(2.5)
        if n_frame then
            n_frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.4)
            task.wait(0.5); n_frame:Destroy()
        end
    end)
end

--------------------------------------------------
-- [ ЭКРАН ЗАГРУЗКИ ]
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg); loader.Name = "Terminator_Loader"
local l_main = Instance.new("Frame", loader)
l_main.Size = UDim2.new(0, 350, 0, 120); l_main.Position = UDim2.new(0.5, -175, 0.5, -60)
l_main.BackgroundColor3 = Color3.fromRGB(5, 5, 10); Instance.new("UICorner", l_main)
Instance.new("UIStroke", l_main).Color = Color3.new(0, 1, 1)

local l_bar_bg = Instance.new("Frame", l_main)
l_bar_bg.Size = UDim2.new(0.8, 0, 0, 10); l_bar_bg.Position = UDim2.new(0.1, 0, 0.7, 0); l_bar_bg.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1); Instance.new("UICorner", l_bar_bg)

local l_bar = Instance.new("Frame", l_bar_bg)
l_bar.Size = UDim2.new(0, 0, 1, 0); l_bar.BackgroundColor3 = Color3.new(0, 1, 1); Instance.new("UICorner", l_bar)

local l_txt = Instance.new("TextLabel", l_main)
l_txt.Size = UDim2.new(1, 0, 0.5, 0); l_txt.Text = "PREPARING..."; l_txt.TextColor3 = Color3.new(0,1,1); l_txt.Font = Enum.Font.Code; l_txt.BackgroundTransparency = 1; l_txt.TextSize = 18

for i = 1, 100 do
    l_bar.Size = UDim2.new(i/100, 0, 1, 0)
    l_txt.Text = "BYPASSING BAC ["..i.."%]"
    task.wait(0.02)
end
loader:Destroy()
Notify("SYSTEM READY", "Terminator v10.0 Activated", Color3.new(0, 1, 0))

--------------------------------------------------
-- [ НАСТРОЙКИ ]
--------------------------------------------------
_G.Aimbot = false
_G.OutlineEsp = false
_G.FullBright = false
_G.SkinChanger = false
_G.SafeSky = false
_G.SafeRain = false

--------------------------------------------------
-- [ ГЛАВНОЕ МЕНЮ ]
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V10"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 340, 0, 420); main.Position = UDim2.new(0.5, -170, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(0, 1, 1)

local tabs = Instance.new("Frame", main); tabs.Size = UDim2.new(1, -20, 0, 35); tabs.Position = UDim2.new(0, 10, 0, 40); tabs.BackgroundTransparency = 1
local b_comb = Instance.new("TextButton", tabs); b_comb.Size = UDim2.new(0.5,-2,1,0); b_comb.Text = "COMBAT"; b_comb.BackgroundColor3 = Color3.fromRGB(30,30,35); b_comb.TextColor3 = Color3.new(1,1,1); b_comb.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_comb)
local b_vis = Instance.new("TextButton", tabs); b_vis.Size = UDim2.new(0.5,-2,1,0); b_vis.Position = UDim2.new(0.5,2,0,0); b_vis.Text = "VISUALS"; b_vis.BackgroundColor3 = Color3.fromRGB(0, 120, 120); b_vis.TextColor3 = Color3.new(1,1,1); b_vis.Font = Enum.Font.GothamBold; Instance.new("UICorner", b_vis)

local p_comb = Instance.new("ScrollingFrame", main); p_comb.Size = UDim2.new(1,-20,1,-90); p_comb.Position = UDim2.new(0,10,0,80); p_comb.BackgroundTransparency = 1; p_comb.Visible = false; Instance.new("UIListLayout", p_comb).Padding = UDim.new(0,5)
local p_vis = Instance.new("ScrollingFrame", main); p_vis.Size = UDim2.new(1,-20,1,-90); p_vis.Position = UDim2.new(0,10,0,80); p_vis.BackgroundTransparency = 1; p_vis.Visible = true; Instance.new("UIListLayout", p_vis).Padding = UDim.new(0,5)

b_comb.MouseButton1Click:Connect(function() p_comb.Visible = true; p_vis.Visible = false; b_comb.BackgroundColor3 = Color3.fromRGB(0,120,120); b_vis.BackgroundColor3 = Color3.fromRGB(30,30,35) end)
b_vis.MouseButton1Click:Connect(function() p_vis.Visible = true; p_comb.Visible = false; b_vis.BackgroundColor3 = Color3.fromRGB(0,120,120); b_comb.BackgroundColor3 = Color3.fromRGB(30,30,35) end)

local function addTgl(txt, var, parent)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.Code; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(20, 20, 25)
        Notify(txt, _G[var] and "ENABLED" or "DISABLED", _G[var] and Color3.new(0,1,0) or Color3.new(1,0,0))
    end)
end

--------------------------------------------------
-- [ НАПОЛНЕНИЕ ФУНКЦИЯМИ ]
--------------------------------------------------
addTgl("AIMBOT (RMB HOLD)", "Aimbot", p_comb)

addTgl("OUTLINE ESP (WALLS)", "OutlineEsp", p_vis)
addTgl("FULLBRIGHT / NO FOG", "FullBright", p_vis)
addTgl("VISUAL SKINCHANGER (GOLD)", "SkinChanger", p_vis)
addTgl("GHOST SKY (CYAN)", "SafeSky", p_vis)
addTgl("PARTICLE RAIN", "SafeRain", p_vis)

--------------------------------------------------
-- [ ГЛАВНАЯ ЛОГИКА ]
--------------------------------------------------
local att = Instance.new("Attachment", cam)
local rain = Instance.new("ParticleEmitter", att); rain.Enabled = false; rain.Texture = "rbxassetid://10849911874"; rain.Rate = 80; rain.Lifetime = NumberRange.new(3,4); rain.Speed = NumberRange.new(40); rain.Acceleration = Vector3.new(0,-30,0)

rs.RenderStepped:Connect(function()
    -- AIMBOT (Плавная наводка на правую кнопку мыши)
    if _G.Aimbot and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local pos, vis = cam:WorldToViewportPoint(pl.Character.Head.Position)
                if vis then
                    local mag = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                    if mag < dist and mag < 300 then dist = mag; target = pl end
                end
            end
        end
        if target then
            cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Character.Head.Position), 0.15)
        end
    end

    -- ESP (Обводка)
    if _G.OutlineEsp then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                hl.Name = "T_ESP"; hl.FillTransparency = 1; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.OutlineColor = (pl.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
            end
        end
    end

    -- FULLBRIGHT
    if _G.FullBright then lighting.Brightness = 2; lighting.FogEnd = 1e5; lighting.GlobalShadows = false
    else lighting.Brightness = 1; lighting.GlobalShadows = true end

    -- SKINCHANGER (Визуальный)
    if _G.SkinChanger then
        for _, v in pairs(cam:GetDescendants()) do
            if v:IsA("MeshPart") or v:IsA("Part") then
                v.Color = Color3.fromRGB(255, 215, 0); v.Material = Enum.Material.Metal
            end
        end
    end

    -- RAIN & SKY
    if _G.SafeRain then att.CFrame = cam.CFrame * CFrame.new(0,25,-35); rain.Enabled = true else rain.Enabled = false end
    if _G.SafeSky then lighting.Ambient = Color3.fromRGB(0, 255, 255) end
end)

-- Уведомление о спавне
lp.CharacterAdded:Connect(function()
    Notify("SPAWNED", "Good luck in battle!", Color3.new(1, 1, 0))
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)
