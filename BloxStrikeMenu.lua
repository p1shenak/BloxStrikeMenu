--[[
    TERMINATOR v2.1 // BLOX STRIKE RAGE
    - FIXED: Spinbot (Can move now)
    - FIXED: Wallbang (Hitbox Expansion method)
    - NEW: FPS Optimizer
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

-- Очистка
for _, v in pairs(cg:GetChildren()) do if v.Name == "Terminator_V2_1" then v:Destroy() end end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V2_1"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 450)
main.Position = UDim2.new(0.5, -150, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,1.5,0); scroll.ScrollBarThickness = 0
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ ПЕРЕМЕННЫЕ ]
_G.Spin = false
_G.Wallbang = false
_G.ESP = false

local function addTgl(txt, cb)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    local act = false
    b.MouseButton1Click:Connect(function()
        act = not act
        b.BackgroundColor3 = act and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(25, 25, 30)
        cb(act)
    end)
end

--------------------------------------------------
-- 1. FIXED SPINBOT (ДВИЖЕНИЕ РАБОТАЕТ)
--------------------------------------------------
addTgl("FIXED SPINBOT", function(v)
    _G.Spin = v
    task.spawn(function()
        while _G.Spin do
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                -- Вращаем только визуальное смещение, не ломая Velocity
                lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            end
            rs.RenderStepped:Wait()
        end
    end)
end)

--------------------------------------------------
-- 2. WALLBANG (HITBOX EXPANDER) - СКВОЗЬ ВСЮ КАРТУ
--------------------------------------------------
addTgl("MAP WALLBANG (EXPAND)", function(v)
    _G.Wallbang = v
    task.spawn(function()
        while _G.Wallbang do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    head.Size = Vector3.new(30, 30, 30) -- Гигантская голова
                    head.Transparency = 0.7 -- Чтобы видеть сквоис неё
                    head.CanCollide = false
                end
            end
            task.wait(1)
        end
        -- Возврат в норму
        for _, player in pairs(p:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                player.Character.Head.Size = Vector3.new(1, 1, 1)
                player.Character.Head.Transparency = 0
            end
        end
    end)
end)

--------------------------------------------------
-- 3. ESP (HIGHLIGHT)
--------------------------------------------------
addTgl("ESP (ALWAYS ON TOP)", function(v)
    _G.ESP = v
    task.spawn(function()
        while _G.ESP do
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Character then
                    local h = player.Character:FindFirstChild("BS_ESP") or Instance.new("Highlight", player.Character)
                    h.Name = "BS_ESP"
                    h.FillColor = (player.Team ~= lp.Team) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
            task.wait(1)
        end
    end)
end)

addTgl("NO TEXTURES (FPS)", function(v)
    for _, obj in pairs(workspace:GetDescendants()) do
        if v and obj:IsA("BasePart") then obj.Material = Enum.Material.SmoothPlastic
        elseif v and (obj:IsA("Texture") or obj:IsA("Decal")) then obj.Transparency = 1 end
    end
end)

-- Скрытие на L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v2.1 LOADED")
