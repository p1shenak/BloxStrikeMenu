--[[
    TERMINATOR v4.9 // RADIANT UPDATE
    - RESTORED: FullBright (Night Vision)
    - ADDED: No Fog (Clear View)
    - UPDATED: Smooth Neon Interface
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

-- Очистка старого
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") or v.Name:find("Loader") then v:Destroy() end end

--------------------------------------------------
-- [ ЭКРАН ЗАГРУЗКИ v4.9 ]
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg); loader.Name = "Terminator_Loader"
local l_main = Instance.new("Frame", loader)
l_main.Size = UDim2.new(0, 300, 0, 100); l_main.Position = UDim2.new(0.5, -150, 0.5, -50)
l_main.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Instance.new("UICorner", l_main)
Instance.new("UIStroke", l_main).Color = Color3.fromRGB(255, 0, 0)

local l_txt = Instance.new("TextLabel", l_main)
l_txt.Size = UDim2.new(1, 0, 1, 0); l_txt.Text = "TERMINATOR v4.9: RADIANT"; l_txt.TextColor3 = Color3.new(1, 0, 0)
l_txt.Font = Enum.Font.GothamBold; l_txt.TextSize = 18; l_txt.BackgroundTransparency = 1

task.spawn(function() task.wait(2.5); loader:Destroy() end)
task.wait(2.6)

--------------------------------------------------
-- [ МЕНЮ v4.9 ]
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V4_9"; sg.ResetOnSpawn = false
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 420); main.Position = UDim2.new(0.5, -160, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, -20, 0, 40); tabFrame.Position = UDim2.new(0, 10, 0, 10); tabFrame.BackgroundTransparency = 1

local b1 = Instance.new("TextButton", tabFrame); b1.Size = UDim2.new(0.5,-2,1,0); b1.Text = "COMBAT"; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.TextColor3 = Color3.new(1,1,1); b1.Font = Enum.Font.GothamBold; Instance.new("UICorner", b1)
local b2 = Instance.new("TextButton", tabFrame); b2.Size = UDim2.new(0.5,-2,1,0); b2.Position = UDim2.new(0.5,2,0,0); b2.Text = "VISUALS"; b2.BackgroundColor3 = Color3.fromRGB(30,30,30); b2.TextColor3 = Color3.new(1,1,1); b2.Font = Enum.Font.GothamBold; Instance.new("UICorner", b2)

local p1 = Instance.new("ScrollingFrame", main); p1.Size = UDim2.new(1,-20,1,-70); p1.Position = UDim2.new(0,10,0,60); p1.BackgroundTransparency = 1; p1.Visible = true; p1.ScrollBarThickness = 0
local p2 = Instance.new("ScrollingFrame", main); p2.Size = UDim2.new(1,-20,1,-70); p2.Position = UDim2.new(0,10,0,60); p2.BackgroundTransparency = 1; p2.Visible = false; p2.ScrollBarThickness = 0
Instance.new("UIListLayout", p1).Padding = UDim.new(0,5); Instance.new("UIListLayout", p2).Padding = UDim.new(0,5)

b1.MouseButton1Click:Connect(function() p1.Visible = true; p2.Visible = false; b1.BackgroundColor3 = Color3.fromRGB(200,0,0); b2.BackgroundColor3 = Color3.fromRGB(30,30,30) end)
b2.MouseButton1Click:Connect(function() p1.Visible = false; p2.Visible = true; b2.BackgroundColor3 = Color3.fromRGB(200,0,0); b1.BackgroundColor3 = Color3.fromRGB(30,30,30) end)

--------------------------------------------------
-- [ ФУНКЦИИ ]
--------------------------------------------------
_G.Aimbot = false; _G.ESP = false; _G.AntiFlash = false; _G.AntiSmoke = false; _G.FullBright = false

local function addTgl(txt, var, parent)
    local btn = Instance.new("TextButton", parent); btn.Size = UDim2.new(1,0,0,40); btn.BackgroundColor3 = Color3.fromRGB(25,25,25); btn.Text = txt; btn.TextColor3 = Color3.new(1,1,1); btn.Font = Enum.Font.Gotham; Instance.new("UICorner", btn)
    local stroke = Instance.new("UIStroke", btn); stroke.Color = Color3.fromRGB(255,0,0); stroke.Transparency = 1
    
    btn.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        btn.BackgroundColor3 = _G[var] and Color3.fromRGB(40,0,0) or Color3.fromRGB(25,25,25)
        stroke.Transparency = _G[var] and 0 or 1
        
        -- Логика FullBright (Срабатывает сразу при клике)
        if var == "FullBright" then
            if _G.FullBright then
                lighting.Ambient = Color3.new(1, 1, 1)
                lighting.Brightness = 2
                lighting.FogEnd = 100000
                lighting.GlobalShadows = false
            else
                lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
                lighting.Brightness = 1
                lighting.FogEnd = 1000 -- Обычный туман
                lighting.GlobalShadows = true
            end
        end
    end)
end

addTgl("HARD AIMBOT", "Aimbot", p1)
addTgl("SPINBOT", "Spin", p1)

addTgl("WALLHACK (AlwaysOnTop)", "ESP", p2)
addTgl("FULLBRIGHT / NO FOG", "FullBright", p2)
addTgl("ANTI-FLASH (LOCAL)", "AntiFlash", p2)
addTgl("ANTI-SMOKE (LOCAL)", "AntiSmoke", p2)

--------------------------------------------------
-- [ ЯДРО ]
--------------------------------------------------
rs.RenderStepped:Connect(function()
    -- ANTI FLASH/SMOKE
    if _G.AntiFlash then
        for _, v in pairs(lp.PlayerGui:GetDescendants()) do
            if v:IsA("Frame") and v.Name:lower():find("flash") then v.Visible = false end
        end
    end
    if _G.AntiSmoke then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") and v.Name:lower():find("smoke") then v.Enabled = false end
        end
    end

    -- AIMBOT & ESP
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

    if _G.ESP then
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Character then
                local hl = pl.Character:FindFirstChild("T_ESP") or Instance.new("Highlight", pl.Character)
                hl.Name = "T_ESP"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = (pl.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
            end
        end
    end
end)

uis.InputBegan:Connect(function(k, m) if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end end)
print("TERMINATOR v4.9 LOADED")
