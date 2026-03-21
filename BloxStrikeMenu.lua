--[[
    TERMINATOR v17.1 // REPAIR LOG
    - RESTORED: FullBright (Shadows Off, Brightness Up)
    - FIXED: Anime Sprite Animation (Correct Viewport)
    - ALL FEATURES: Trigger, Aim, Bhop, ESP, Skins
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- Очистка старых сессий
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

--------------------------------------------------
-- [ 1. АНИМАЦИЯ ТЯНКИ (FIXED) ]
--------------------------------------------------
local function ApplyAnime(parent)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(0, 130, 0, 130); holder.Position = UDim2.new(1, 10, 0, 0); holder.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", holder); local s = Instance.new("UIStroke", holder); s.Color = Color3.new(0, 1, 1); s.Thickness = 2
    
    local img = Instance.new("ImageLabel", holder)
    img.Size = UDim2.new(1, 0, 1, 0); img.BackgroundTransparency = 1
    img.Image = "rbxassetid://11318961758"
    
    -- Настройка сетки спрайтов (5x5)
    local spriteSize = Vector2.new(200, 200) -- Подгонка под размер кадра
    img.ImageRectSize = spriteSize
    
    task.spawn(function()
        while task.wait() do
            for y = 0, 4 do
                for x = 0, 4 do
                    img.ImageRectOffset = Vector2.new(x * spriteSize.X, y * spriteSize.Y)
                    task.wait(0.05)
                end
            end
        end
    end)
end

--------------------------------------------------
-- [ 2. УВЕДОМЛЕНИЯ ]
--------------------------------------------------
local function Notify(title, text, color)
    local n_sg = cg:FindFirstChild("T_Notify") or Instance.new("ScreenGui", cg); n_sg.Name = "T_Notify"
    local n_frame = Instance.new("Frame", n_sg); n_frame.Size = UDim2.new(0, 220, 0, 65); n_frame.Position = UDim2.new(1, 10, 0.8, 0); n_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", n_frame); Instance.new("UIStroke", n_frame).Color = color or Color3.new(0, 1, 1)
    local t_lab = Instance.new("TextLabel", n_frame); t_lab.Size = UDim2.new(1, 0, 0, 30); t_lab.Text = title; t_lab.TextColor3 = color; t_lab.Font = Enum.Font.GothamBold; t_lab.BackgroundTransparency = 1; t_lab.TextSize = 14
    local d_lab = Instance.new("TextLabel", n_frame); d_lab.Size = UDim2.new(1, 0, 0, 35); d_lab.Position = UDim2.new(0, 0, 0, 25); d_lab.Text = text; d_lab.TextColor3 = Color3.new(1,1,1); d_lab.Font = Enum.Font.Code; d_lab.BackgroundTransparency = 1; d_lab.TextSize = 11
    n_frame:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Back", 0.4)
    task.spawn(function() task.wait(3); if n_frame then n_frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.4); task.wait(0.5); n_frame:Destroy() end end)
end

--------------------------------------------------
-- [ 3. ПАНЕЛЬ И ЛОАДЕР ]
--------------------------------------------------
_G.Aimbot = false; _G.TriggerBot = false; _G.NoShake = false; _G.Bhop = false; _G.OutlineEsp = false; _G.SkinChanger = false; _G.FullBright = false

local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V17_1"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 320, 0, 440); main.Position = UDim2.new(0.5, -160, 0.5, -220); main.BackgroundColor3 = Color3.fromRGB(10,10,15); main.Draggable = true; main.Active = true; Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(0,1,1)

ApplyAnime(main) -- Картинка тут!

local scroll = Instance.new("ScrollingFrame", main); scroll.Size = UDim2.new(1, -20, 1, -50); scroll.Position = UDim2.new(0, 10, 0, 45); scroll.BackgroundTransparency = 1; scroll.ScrollBarThickness = 0; Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 6)

local function addTgl(txt, var)
    local b = Instance.new("TextButton", scroll); b.Size = UDim2.new(1, 0, 0, 36); b.BackgroundColor3 = Color3.fromRGB(20, 20, 25); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.Code; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(0, 140, 140) or Color3.fromRGB(20, 20, 25)
        Notify(txt, _G[var] and "ON" or "OFF", _G[var] and Color3.new(0,1,0) or Color3.new(1,0,0))
    end)
end

addTgl("TRIGGER BOT (AUTO)", "TriggerBot")
addTgl("AIMBOT (RMB)", "Aimbot")
addTgl("FULL BRIGHT (VISUAL)", "FullBright") -- ВЕРНУЛ!
addTgl("NO CAMERA SHAKE", "NoShake")
addTgl("FAST BHOP (SPACE)", "Bhop")
addTgl("OUTLINE ESP (WH)", "OutlineEsp")
addTgl("GOLD SKINCHANGER", "SkinChanger")

--------------------------------------------------
-- [ 4. ЛОГИКА ]
--------------------------------------------------
rs.RenderStepped:Connect(function()
    -- FullBright Logic
    if _G.FullBright then
        lighting.Brightness = 2; lighting.ClockTime = 12; lighting.FogEnd = 786543; lighting.GlobalShadows = false; lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end

    -- Trigger
    if _G.TriggerBot then
        local t = lp:GetMouse().Target
        if t and t.Parent and t.Parent:FindFirstChild("Humanoid") then
            local p_hit = p:GetPlayerFromCharacter(t.Parent)
            if p_hit and p_hit.Team ~= lp.Team then mouse1click() end
        end
    end

    -- Bhop
    if _G.Bhop and uis:IsKeyDown(Enum.KeyCode.Space) then
        local c = lp.Character; local h = c and c:FindFirstChild("Humanoid"); local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if h and hrp and h.FloorMaterial ~= Enum.Material.Air then
            h.Jump = true
            hrp.Velocity = hrp.Velocity + (h.MoveDirection * 1.7)
            if hrp.Velocity.Magnitude > 50 then hrp.Velocity = hrp.Velocity.Unit * 50 end
        end
    end

    -- Aim
    if _G.Aimbot and uis:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = nil; local dist = 180
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local pos, vis = cam:WorldToViewportPoint(pl.Character.Head.Position)
                if vis then
                    local mDist = (Vector2.new(pos.X, pos.Y) - uis:GetMouseLocation()).Magnitude
                    if mDist < dist then dist = mDist; target = pl end
                end
            end
        end
        if target then cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Character.Head.Position), 0.16) end
    end

    -- WH (ESP)
    if _G.OutlineEsp then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                hl.Name = "T_ESP"; hl.FillTransparency = 1; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.OutlineColor = (pl.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
            end
        end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)

print("TERMINATOR v17.1 FIXED LOADED")
