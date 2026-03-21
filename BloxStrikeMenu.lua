--[[
    TERMINATOR v17.2 // ULTIMATE REBORN
    - RESTORED: Loading Screen (0-100%)
    - FIXED: Texture ID 11318961749 (Anime Girl)
    - FEATURES: FullBright, Aim, Trigger, ESP, Bhop
    - HOTKEYS: [L] Menu, [Space] Bhop, [RMB] Aim
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local cam = workspace.CurrentCamera

-- Чистка старых скриптов
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

--------------------------------------------------
-- [ 1. ЭКРАН ЗАГРУЗКИ (0-100%) ]
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg); loader.Name = "Terminator_Loader"
local l_main = Instance.new("Frame", loader); l_main.Size = UDim2.new(0, 320, 0, 110); l_main.Position = UDim2.new(0.5, -160, 0.5, -55); l_main.BackgroundColor3 = Color3.fromRGB(5,5,10); Instance.new("UICorner", l_main); Instance.new("UIStroke", l_main).Color = Color3.new(0,1,1)
local l_bar = Instance.new("Frame", l_main); l_bar.Size = UDim2.new(0,0,0,6); l_bar.Position = UDim2.new(0.1,0,0.75,0); l_bar.BackgroundColor3 = Color3.new(0,1,1); Instance.new("UICorner", l_bar)
local l_txt = Instance.new("TextLabel", l_main); l_txt.Size = UDim2.new(1,0,0.6,0); l_txt.Text = "INITIALIZING..."; l_txt.TextColor3 = Color3.new(0,1,1); l_txt.BackgroundTransparency = 1; l_txt.Font = Enum.Font.Code; l_txt.TextSize = 17

-- Анимация загрузки
for i = 1, 100 do 
    l_bar.Size = UDim2.new(i/125, 0, 0, 6)
    l_txt.Text = "LOADING TERMINATOR ["..i.."%]"
    task.wait(0.012) 
end
loader:Destroy()

--------------------------------------------------
-- [ 2. УВЕДОМЛЕНИЯ ]
--------------------------------------------------
local function Notify(title, text, color)
    local n_sg = cg:FindFirstChild("T_Notify") or Instance.new("ScreenGui", cg); n_sg.Name = "T_Notify"
    local n_frame = Instance.new("Frame", n_sg); n_frame.Size = UDim2.new(0, 220, 0, 65); n_frame.Position = UDim2.new(1, 10, 0.8, 0); n_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15); Instance.new("UICorner", n_frame); Instance.new("UIStroke", n_frame).Color = color or Color3.new(0, 1, 1)
    local t_lab = Instance.new("TextLabel", n_frame); t_lab.Size = UDim2.new(1, 0, 0, 30); t_lab.Text = title; t_lab.TextColor3 = color; t_lab.Font = Enum.Font.CodeBold; t_lab.BackgroundTransparency = 1; t_lab.TextSize = 14
    local d_lab = Instance.new("TextLabel", n_frame); d_lab.Size = UDim2.new(1, 0, 0, 35); d_lab.Position = UDim2.new(0, 0, 0, 25); d_lab.Text = text; d_lab.TextColor3 = Color3.new(1,1,1); d_lab.Font = Enum.Font.Code; d_lab.BackgroundTransparency = 1; d_lab.TextSize = 11
    n_frame:TweenPosition(UDim2.new(1, -230, 0.8, 0), "Out", "Back", 0.4)
    task.spawn(function() task.wait(3); if n_frame then n_frame:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.4); task.wait(0.5); n_frame:Destroy() end end)
end

Notify("SYSTEM READY", "Welcome back, Operator", Color3.new(0, 1, 0))

--------------------------------------------------
-- [ 3. АНИМАЦИЯ ТЯНКИ (TEXTURE 11318961749) ]
--------------------------------------------------
local function ApplyAnime(parent)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(0, 130, 0, 130); holder.Position = UDim2.new(1, 10, 0, 0); holder.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", holder); Instance.new("UIStroke", holder).Color = Color3.new(0, 1, 1)
    
    local img = Instance.new("ImageLabel", holder)
    img.Size = UDim2.new(1, 0, 1, 0); img.BackgroundTransparency = 1
    img.Image = "rbxassetid://11318961749"
    
    local spriteSize = Vector2.new(200, 200) 
    img.ImageRectSize = spriteSize
    
    task.spawn(function()
        while task.wait() do
            for y = 0, 4 do
                for x = 0, 4 do
                    img.ImageRectOffset = Vector2.new(x * spriteSize.X, y * spriteSize.Y)
                    task.wait(0.06)
                end
            end
        end
    end)
end

--------------------------------------------------
-- [ 4. МЕНЮ ]
--------------------------------------------------
_G.Aimbot = false; _G.TriggerBot = false; _G.NoShake = false; _G.Bhop = false; _G.OutlineEsp = false; _G.FullBright = false

local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V17_2"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg); main.Size = UDim2.new(0, 320, 0, 440); main.Position = UDim2.new(0.5, -160, 0.5, -220); main.BackgroundColor3 = Color3.fromRGB(10,10,15); main.Draggable = true; main.Active = true; Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.new(0,1,1)

ApplyAnime(main)

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
addTgl("AIMBOT (HOLD RMB)", "Aimbot")
addTgl("FULL BRIGHT (VISUAL)", "FullBright")
addTgl("NO CAMERA SHAKE", "NoShake")
addTgl("FAST BHOP (SPACE)", "Bhop")
addTgl("OUTLINE WH (ESP)", "OutlineEsp")

--------------------------------------------------
-- [ 5. ЛОГИКА ФУНКЦИЙ ]
--------------------------------------------------
rs.RenderStepped:Connect(function()
    if _G.FullBright then
        lighting.Brightness = 2; lighting.ClockTime = 12; lighting.GlobalShadows = false
    end

    if _G.Bhop and uis:IsKeyDown(Enum.KeyCode.Space) then
        local c = lp.Character; local h = c and c:FindFirstChild("Humanoid"); local hrp = c and c:FindFirstChild("HumanoidRootPart")
        if h and hrp and h.FloorMaterial ~= Enum.Material.Air then
            h.Jump = true
            hrp.Velocity = hrp.Velocity + (h.MoveDirection * 1.7)
        end
    end

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

    if _G.OutlineEsp then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                hl.Name = "T_ESP"; hl.FillTransparency = 1; hl.OutlineColor = (pl.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
            end
        end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)

print("TERMINATOR v17.2 FINAL LOADED WITH LOADER")
