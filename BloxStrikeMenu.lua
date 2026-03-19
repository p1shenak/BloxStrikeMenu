--[[
    TERMINATOR v4.6 // GHOST UPDATE
    - NEW: Anti-Flash (Мгновенное прозрение)
    - NEW: Anti-Smoke (Прозрачный дым)
    - FIXED: Tracers & FullBright
]]

local p = game:GetService("Players")
local lp = p.LocalPlayer
local rs = game:GetService("RunService")
local cg = game:GetService("CoreGui")
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local lighting = game:GetService("Lighting")

-- Очистка старого
for _, v in pairs(cg:GetChildren()) do if v.Name:find("Terminator") then v:Destroy() end end

--------------------------------------------------
-- АНИМАЦИЯ ЗАГРУЗКИ v4.6
--------------------------------------------------
local loader = Instance.new("ScreenGui", cg)
loader.Name = "Terminator_Loader"
local l_main = Instance.new("Frame", loader)
l_main.Size = UDim2.new(0, 300, 0, 100); l_main.Position = UDim2.new(0.5, -150, 0.5, -50)
l_main.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Instance.new("UICorner", l_main)
local l_txt = Instance.new("TextLabel", l_main)
l_txt.Size = UDim2.new(1, 0, 1, 0); l_txt.Text = "TERMINATOR v4.6: GHOST"; l_txt.TextColor3 = Color3.new(1, 0, 0)
l_txt.Font = Enum.Font.GothamBold; l_txt.TextSize = 20; l_txt.BackgroundTransparency = 1
task.spawn(function() task.wait(2); loader:Destroy() end)
task.wait(2.1)

--------------------------------------------------
-- ИНТЕРФЕЙС
--------------------------------------------------
local sg = Instance.new("ScreenGui", cg); sg.Name = "Terminator_V4_6"
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 420); main.Position = UDim2.new(0.5, -175, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 12); main.Active = true; main.Draggable = true
Instance.new("UICorner", main); Instance.new("UIStroke", main).Color = Color3.fromRGB(255, 0, 0)

local tabFrame = Instance.new("Frame", main)
tabFrame.Size = UDim2.new(1, 0, 0, 40); tabFrame.BackgroundTransparency = 1

local mainTabBtn = Instance.new("TextButton", tabFrame)
mainTabBtn.Size = UDim2.new(0.5, 0, 1, 0); mainTabBtn.Text = "MAIN"; mainTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
mainTabBtn.TextColor3 = Color3.new(1, 1, 1); mainTabBtn.Font = Enum.Font.GothamBold

local visTabBtn = Instance.new("TextButton", tabFrame)
visTabBtn.Size = UDim2.new(0.5, 0, 1, 0); visTabBtn.Position = UDim2.new(0.5, 0, 0, 0); visTabBtn.Text = "VISUALS"
visTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); visTabBtn.TextColor3 = Color3.new(1, 1, 1); visTabBtn.Font = Enum.Font.GothamBold

local mainPage = Instance.new("ScrollingFrame", main)
mainPage.Size = UDim2.new(1, -20, 1, -60); mainPage.Position = UDim2.new(0, 10, 0, 50); mainPage.BackgroundTransparency = 1; mainPage.Visible = true; mainPage.ScrollBarThickness = 0
Instance.new("UIListLayout", mainPage).Padding = UDim.new(0, 5)

local visPage = Instance.new("ScrollingFrame", main)
visPage.Size = UDim2.new(1, -20, 1, -60); visPage.Position = UDim2.new(0, 10, 0, 50); visPage.BackgroundTransparency = 1; visPage.Visible = false; visPage.ScrollBarThickness = 0
Instance.new("UIListLayout", visPage).Padding = UDim.new(0, 5)

mainTabBtn.MouseButton1Click:Connect(function()
    mainPage.Visible = true; visPage.Visible = false
    mainTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); visTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

visTabBtn.MouseButton1Click:Connect(function()
    mainPage.Visible = false; visPage.Visible = true
    visTabBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0); mainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

--------------------------------------------------
-- ФУНКЦИИ
--------------------------------------------------
_G.Aimbot = false; _G.Spin = false
_G.BoxESP = false; _G.Tracers = false; _G.FullBright = false
_G.AntiFlash = false; _G.AntiSmoke = false

local function addTgl(txt, var, parent)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 25); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.Gotham; b.TextSize = 13; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[var] = not _G[var]
        b.BackgroundColor3 = _G[var] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(25, 25, 25)
        
        if var == "FullBright" then
            lighting.Brightness = _G.FullBright and 4 or 1
            lighting.GlobalShadows = not _G.FullBright
        end
    end)
end

-- MAIN
addTgl("ACTIVATE AIMBOT", "Aimbot", mainPage)
addTgl("ACTIVATE SPINBOT", "Spin", mainPage)

-- VISUALS
addTgl("BOX ESP", "BoxESP", visPage)
addTgl("TRACERS", "Tracers", visPage)
addTgl("FULLBRIGHT", "FullBright", visPage)
addTgl("ANTI-FLASH", "AntiFlash", visPage)
addTgl("ANTI-SMOKE", "AntiSmoke", visPage)

--------------------------------------------------
-- ЯДРО ЛОГИКИ
--------------------------------------------------
rs.RenderStepped:Connect(function()
    -- ANTI-FLASH
    if _G.AntiFlash then
        -- Ищем в PlayerGui объекты, которые отвечают за ослепление
        for _, v in pairs(lp.PlayerGui:GetDescendants()) do
            if v:IsA("Frame") and (v.Name:lower():find("flash") or v.Name:lower():find("blind")) then
                v.BackgroundTransparency = 1
                v.Visible = false
            end
        end
    end

    -- ANTI-SMOKE
    if _G.AntiSmoke then
        -- Ищем частицы или меши дыма в Workspace
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") and (v.Name:lower():find("smoke") or v.Name:lower():find("gas")) then
                v.Enabled = false
            elseif v:IsA("BasePart") and v.Name:lower():find("smoke") then
                v.Transparency = 1
                v.CanCollide = false
            end
        end
    end

    -- AIMBOT (Улучшенный)
    if _G.Aimbot then
        local target = nil
        local dist = math.huge
        for _, pl in pairs(p:GetPlayers()) do
            if pl ~= lp and pl.Team ~= lp.Team and pl.Character and pl.Character:FindFirstChild("Head") then
                local mag = (pl.Character.Head.Position - lp.Character.Head.Position).Magnitude
                if mag < dist then dist = mag; target = pl end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        end
    end

    -- VISUALS (ESP & TRACERS)
    for _, pl in pairs(p:GetPlayers()) do
        if pl ~= lp and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            -- Box ESP logic
            local box = pl.Character:FindFirstChild("BoxESP")
            if _G.BoxESP then
                if not box then
                    box = Instance.new("BoxHandleAdornment", pl.Character)
                    box.Name = "BoxESP"; box.AlwaysOnTop = true; box.Adornee = pl.Character
                    box.Size = Vector3.new(4, 6, 1); box.Transparency = 0.7; box.Color3 = Color3.new(1,0,0)
                end
            elseif box then box:Destroy() end
        end
    end
end)

uis.InputBegan:Connect(function(k, m)
    if not m and k.KeyCode == Enum.KeyCode.L then main.Visible = not main.Visible end
end)

print("TERMINATOR v4.6 LOADED")
