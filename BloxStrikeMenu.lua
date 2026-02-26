--[[
    TERMINATOR v4.1 // FIX & RECOVERY
    - FIXED: Исправлено исчезновение функций (pcall protection)
    - FIXED: Оптимизирован поиск цели (Targeting Fix)
    - NEW: Status Indicator (меню теперь пишет, если функция активна)
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")

-- Полная очистка перед запуском
for _, v in pairs(cg:GetChildren()) do 
    if v.Name == "Terminator_V4_1" or v.Name == "Terminator_V4" then v:Destroy() end 
end

local sg = Instance.new("ScreenGui", cg)
sg.Name = "Terminator_V4_1"
sg.ResetOnSpawn = false -- Чтобы меню не пропадало при смерти

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 500)
main.Position = UDim2.new(0.5, -160, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)
Instance.new("UIStroke", main).Color = Color3.fromRGB(0, 255, 150)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "TERMINATOR v4.1 // STABLE"
title.TextColor3 = Color3.new(1,1,1); title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(1, -20, 1, -60); scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.BackgroundTransparency = 1; scroll.CanvasSize = UDim2.new(0,0,2,0); scroll.ScrollBarThickness = 2
Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)

-- [ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ]
getgenv().T_Settings = {
    TPKill = false,
    Spin = false,
    Wallbang = false,
    ESP = false
}

local function addTgl(txt, var)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(1, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = txt; b.TextColor3 = Color3.new(0.8, 0.8, 0.8); b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    
    b.MouseButton1Click:Connect(function()
        getgenv().T_Settings[var] = not getgenv().T_Settings[var]
        b.BackgroundColor3 = getgenv().T_Settings[var] and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(25, 25, 30)
        b.TextColor3 = getgenv().T_Settings[var] and Color3.new(1, 1, 1) or Color3.new(0.8, 0.8, 0.8)
    end)
end

-- Добавляем кнопки заново
addTgl("CROSS-MAP WALLBANG", "Wallbang")
addTgl("TP-KILL + AUTO-FIRE", "TPKill")
addTgl("ULTIMATE ESP", "ESP")
addTgl("RAGE SPINBOT", "Spin")

--------------------------------------------------
-- ЛОГИКА (ОБЕРНУТА В PCALL ДЛЯ СТАБИЛЬНОСТИ)
--------------------------------------------------

local function getTarget()
    local t = nil; local d = math.huge
    pcall(function()
        for _, player in pairs(p:GetPlayers()) do
            if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("Head") then
                local mag = (player.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if mag < d then d = mag; t = player end
            end
        end
    end)
    return t
end

-- 1. WALLBANG HOOK
local old; old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if getgenv().T_Settings.Wallbang and (method == "Raycast" or method == "FindPartOnRay") and not checkcaller() then
        local t = getTarget()
        if t then
            args[1] = t.Character.Head.Position + Vector3.new(0, 2, 0)
            args[2] = Vector3.new(0, -5, 0)
            return old(self, unpack(args))
        end
    end
    return old(self, ...)
end)

-- 2. LOOPED FUNCTIONS (TP, SPIN, ESP)
rs.RenderStepped:Connect(function()
    pcall(function()
        -- TP Kill
        if getgenv().T_Settings.TPKill then
            local t = getTarget()
            if t and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                lp.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                if typeof(mouse1click) == "function" then mouse1click() end
            end
        end
        -- Spinbot
        if getgenv().T_Settings.Spin and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.CFrame = lp.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
        end
        -- ESP
        if getgenv().T_Settings.ESP then
            for _, player in pairs(p:GetPlayers()) do
                if player ~= lp and player.Character then
                    local h = player.Character:FindFirstChild("V4_ESP") or Instance.new("Highlight", player.Character)
                    h.Name = "V4_ESP"; h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillColor = (player.Team ~= lp.Team) and Color3.new(1,0,0) or Color3.new(0,1,0)
                end
            end
        end
    end)
end)

-- Клавиша L
uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.1 // STABLE RECOVERY LOADED")
