local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local startTime = os.time()
local startRebirths = player.leaderstats.Rebirths.Value
local displayName = player.DisplayName

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#f0f0f0",
    Button = "#000000",
    Icon = "#000000",
})

WindUI:SetNotificationLower(true)

local themes = {"Light"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "Team | Vuzo Zilux",
    Icon = "rbxassetid://76676105086715", 
    Author = "By ZorVex",
    Folder = "Vz Hub",
    Size = UDim2.fromOffset(500, 350),
    Transparent = getgenv().TransparencyEnabled,
    Theme = "Light",
    Resizable = true,
    SideBarWidth = 150,
    BackgroundImageTransparency = 0.8,
    HideSearchBar = true,
    ScrollBarEnabled = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            currentThemeIndex = currentThemeIndex + 1
            if currentThemeIndex > #themes then
                currentThemeIndex = 1
            end
            local newTheme = themes[currentThemeIndex]
            WindUI:SetTheme(newTheme)
            WindUI:Notify({
                Title = "ZorVex | Leader Of Vuzo Zilux",
                Duration = 8
            })
        end,
    },
})

Window:SetIconSize(55)
Window:EditOpenButton({ Enabled = false })

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UIBUTTON"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true 

local ImgBtn = Instance.new("ImageButton")
ImgBtn.Parent = ScreenGui
ImgBtn.Size = UDim2.new(0, 70, 0, 70)
ImgBtn.AnchorPoint = Vector2.new(1, 0) 
ImgBtn.Position = UDim2.new(0.9, -20, 0, 50) 
ImgBtn.BackgroundTransparency = 1
ImgBtn.Image = "rbxassetid://88635292278521" 
ImgBtn.ZIndex = 9999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ImgBtn
local isOpen = true

ImgBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 60, 0, 60)
    })
    local grow = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 70, 0, 70)
    })
    shrink:Play()
    shrink.Completed:Wait()
    grow:Play()
    Window:Toggle()
    isOpen = not isOpen
end)

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    ImgBtn.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end
ImgBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ImgBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
ImgBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

do
    Window:Tag({
        Title = "--> GLITCH <--",
        Color = Color3.fromHex("#000000")
    })
end

getgenv().autoFarm, getgenv().autoFarmV2 = false, false
local activeRock, curDur, targetCF, selectedEmoteName = nil, 0, nil, nil

local rockData = {
    {"Jungle Rock", 10000000, CFrame.new(-7666.7, 6.8, 2831.0, -0.69, 0, -0.72, 0, 1, 0, 0.72, 0, -0.69)},
    {"Muscle King Rock", 5000000, CFrame.new(-9039.3, 9.2, -6051.5, 0.31, 0, -0.94, 0, 1, 0, 0.94, 0, 0.31)},
    {"Legend Rock", 1000000, CFrame.new(4146.9, 991.5, -4030.8, 0.98, 0, 0.16, 0, 1, 0, -0.16, 0, 0.98)},
    {"Eternal Rock", 750000, CFrame.new(-7289.6, 7.6, -1290.4, -0.60, 0, -0.79, 0, 1, 0, 0.79, 0, -0.60)},
    {"Mythical Rock", 400000, CFrame.new(2181.2, 7.3, 1207.8, -0.99, 0, -0.13, 0, 1, 0, 0.13, 0, -0.99)},
    {"Frozen Rock", 150000, CFrame.new(-2520.7, 7.9, -218.4, 0.51, 0, 0.85, 0, 1, 0, -0.85, 0, 0.51)},
    {"Golden Rock", 5000, CFrame.new(302.0, 7.3, -622.9, -0.94, 0, -0.33, 0, 1, 0, 0.33, 0, -0.94)},
    {"Starter Rock", 100, CFrame.new(158.0, 7.3, -164.0, -0.80, 0, -0.59, 0, 1, 0, 0.59, 0, -0.80)},
    {"Tiny Rock", 0, CFrame.new(8.4, 4.3, 2101.2, -0.27, 0, -0.96, 0, 1, 0, 0.96, 0, -0.27)}
}

local emoteList = {["Fly Zor"] = 106493972274585, ["Mager Buat Emote🗿"] = 339082039}
local blockedAnims = {["rbxassetid://3638729053"] = true, ["rbxassetid://3638767427"] = true}

local function useTool()
    local char = player.Character
    local hum, bp = char:FindFirstChild("Humanoid"), player:FindFirstChild("Backpack")
    local p = bp and bp:FindFirstChild("Punch") or char and char:FindFirstChild("Punch")
    if hum and p then
        if p.Parent == bp then hum:EquipTool(p) end
        if p:FindFirstChild("attackTime") then p.attackTime.Value = 0.001 end
    end
    local ev = player:FindFirstChild("muscleEvent")
    if ev then ev:FireServer("punch", "leftHand") ev:FireServer("punch", "rightHand") end
end

local function stopAnims()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, t in pairs(hum:GetPlayingAnimationTracks()) do
        local id = t.Animation and t.Animation.AnimationId
        if blockedAnims[id] or t.Name:lower():find("punch") or t.Name:lower():find("attack") then t:Stop(0) end
    end
end

local function playEmote()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    local desc = hum and hum:FindFirstChildOfClass("HumanoidDescription")
    if desc and selectedEmoteName then
        desc:SetEmotes({[selectedEmoteName] = {emoteList[selectedEmoteName]}})
        pcall(function() 
            hum:PlayEmote(selectedEmoteName)
            for _, t in pairs(hum:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
                t.Priority, t.Looped = Enum.AnimationPriority.Action4, true
            end
        end)
    end
end

local function startFarm(mode)
    task.spawn(function()
        if mode == 3 then stopAnims() playEmote() task.wait(0.5) end
        while (mode == 1 and getgenv().autoFarm) or (mode == 2 and getgenv().autoFarmV2) or (mode == 3 and getgenv().autoFarm) do
            local char = player.Character
            local hrp, dur = char and char:FindFirstChild("HumanoidRootPart"), player:FindFirstChild("Durability")
            if mode == 3 then stopAnims() end
            if hrp and dur and dur.Value >= curDur then
                if mode == 2 and targetCF then hrp.CFrame = targetCF hrp.Velocity = Vector3.new(0,0,0) end
                for _, obj in pairs(workspace.machinesFolder:GetDescendants()) do
                    if obj.Name == "neededDurability" and obj.Value == curDur then
                        local rock, lh, rh = obj.Parent:FindFirstChild("Rock"), char:FindFirstChild("LeftHand"), char:FindFirstChild("RightHand")
                        if rock and rh then
                            firetouchinterest(rock, rh, 0) firetouchinterest(rock, rh, 1)
                            if mode ~= 3 and lh then firetouchinterest(rock, lh, 0) firetouchinterest(rock, lh, 1) end
                            useTool()
                        end
                        break
                    end
                end
            end
            task.wait(mode == 1 and 0.001 or 0.05)
        end
    end)
end

local farmTab = Window:Tab({Title = "Rock Farm", Icon = "shield-check"})

local PunchFast = farmTab:Section({Title = "Animation", Icon = "omega"})

farmTab:Button({
    Title = "Remove Attack Animations",
    Callback = function()
        local blockedAnimations = {
            ["rbxassetid://3638729053"] = true,
            ["rbxassetid://3638767427"] = true,
        }

        local function setupAnimationBlocking()
            local char = player.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if not humanoid then
                return
            end
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local anim = track.Animation
                local name = track.Name:lower()
                if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
                    track:Stop()
                end
            end
            if not _G.AnimBlockConnection then
                _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(track)
                    local anim = track.Animation
                    local name = track.Name:lower()
                    if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
                        track:Stop()
                    end
                end)
            end
        end

        local function overrideToolActivation()
            local function processTool(tool)
                if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) and not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)
                    _G.ToolConnections[tool] = tool.Activated:Connect(function()
                        task.wait(0.05)
                        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                local anim = track.Animation
                                local name = track.Name:lower()
                                if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
                                    track:Stop()
                                end
                            end
                        end
                    end)
                end
            end

            local function watchTools(container)
                for _, tool in pairs(container:GetChildren()) do
                    processTool(tool)
                end
                return container.ChildAdded:Connect(function(tool)
                    task.wait(0.1)
                    processTool(tool)
                end)
            end

            _G.ToolConnections.Backpack = watchTools(player.Backpack)
            local char = player.Character
            if char then
                _G.ToolConnections.Character = watchTools(char)
            end
        end

        setupAnimationBlocking()
        overrideToolActivation()

        if not _G.AnimMonitorConnection then
            _G.AnimMonitorConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local char = player.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid and tick() % 0.5 < 0.01 then
                    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                        local anim = track.Animation
                        name = track.Name:lower()
                        if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
                            track:Stop()
                        end
                    end
                end
            end)
        end
        WindUI:Notify({Title = "Success", Content = "Attack animations removed"})
    end
})

farmTab:Toggle({
    Title = "Fast Punch",
    Callback = function(bool)
        _G.FastPunch = bool

        local function startFastPunch()
            if _G.FastPunchActive then return end
            _G.FastPunchActive = true
            
            task.spawn(function()
                while _G.FastPunch do
                    local character = player.Character
                    if character then
                        local punch = character:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
                        if punch then
                            if punch:FindFirstChild("attackTime") then
                                punch.attackTime.Value = 0
                            end
                            if not character:FindFirstChild("Punch") and character:FindFirstChild("Humanoid") then
                                character.Humanoid:EquipTool(punch)
                            end
                        end
                    end
                    task.wait(0.0001)
                end
                _G.FastPunchActive = false
            end)
            
            task.spawn(function()
                while _G.FastPunch do
                    local character = player.Character
                    local muscleEvent = player:FindFirstChild("muscleEvent")
                    
                    if muscleEvent then
                        muscleEvent:FireServer("punch", "rightHand")
                        muscleEvent:FireServer("punch", "leftHand")
                    end

                    if character then
                        local punchTool = character:FindFirstChild("Punch")
                        if punchTool then
                            punchTool:Activate()
                        end
                    end

                    task.wait() 
                end
            end)
        end

        local function stopFastPunch()
            _G.FastPunch = false
            local character = player.Character
            if character then
                local equipped = character:FindFirstChild("Punch")
                if equipped and equipped:FindFirstChild("attackTime") then
                    equipped.attackTime.Value = 0.35
                end
                if equipped then
                    equipped.Parent = player.Backpack
                end
            end
            local backpackTool = player.Backpack:FindFirstChild("Punch")
            if backpackTool and backpackTool:FindFirstChild("attackTime") then
                backpackTool.attackTime.Value = 0.35
            end
        end
        
        if bool then
            startFastPunch()
            player.CharacterAdded:Connect(function(newChar)
                newChar:WaitForChild("HumanoidRootPart")
                task.wait(0.5)
                if _G.FastPunch then
                    startFastPunch()
                end
            end)
        else
            stopFastPunch()
        end
    end
})

farmTab:Toggle({
    Title = "Anti-AFK",
    Callback = function(state)
        if state then
            local VirtualUser = game:GetService("VirtualUser")

            _G.afkGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
            _G.afkGui.Name = "AntiAFKGui"
            _G.afkGui.ResetOnSpawn = false

            local timer = Instance.new("TextLabel", _G.afkGui)
            timer.Size = UDim2.new(0, 200, 0, 30)
            timer.Position = UDim2.new(1, -210, 0, -20)
            timer.Text = "0:00:00"
            timer.TextColor3 = Color3.fromRGB(255, 255, 255)
            timer.Font = Enum.Font.GothamBold
            timer.TextSize = 25
            timer.BackgroundTransparency = 1
            timer.TextTransparency = 0
            
            -- Outline untuk timer
local timerStroke = Instance.new("UIStroke", timer)
timerStroke.Thickness = 1
timerStroke.Color = Color3.fromRGB(39, 39, 39)

            local startTime = tick()

            task.spawn(function()
                while _G.afkGui and _G.afkGui.Parent do
                    local elapsed = tick() - startTime
                    local h = math.floor(elapsed / 3600)
                    local m = math.floor((elapsed % 3600) / 60)
                    local s = math.floor(elapsed % 60)
                    timer.Text = string.format("%02d:%02d:%02d", h, m, s)
                    task.wait(1)
                end
            end)
            
            _G.afkConnection = player.Idled:Connect(function()
                VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
            end)
        else
            if _G.afkConnection then
                _G.afkConnection:Disconnect()
                _G.afkConnection = nil
            end
            if _G.afkGui then
                _G.afkGui:Destroy()
                _G.afkGui = nil
            end
        end
    end
})

farmTab:Section({Title = "Ghost Rock", Icon = "ghost"})
for _, r in ipairs(rockData) do
    farmTab:Toggle({Title = "Ghost " .. r[1], Callback = function(v)
        activeRock, curDur, getgenv().autoFarm = r[1], r[2], v
        if v then startFarm(1) end
    end})
end

farmTab:Section({Title = "Teleport Rock", Icon = "map-pin"})
for _, r in ipairs(rockData) do
    farmTab:Toggle({Title = "TP " .. r[1], Callback = function(v)
        activeRock, curDur, targetCF, getgenv().autoFarmV2 = r[1], r[2], r[3], v
        if v then startFarm(2) end
    end})
end

farmTab:Section({Title = "Emote Rock", Icon = "sparkles"})
farmTab:Dropdown({Title = "Select Emote", Values = {"Fly Zor", "Mager Buat Emote🗿"}, Callback = function(v) selectedEmoteName = v end})
for _, r in ipairs(rockData) do
    farmTab:Toggle({Title = "Emote " .. r[1], Callback = function(v)
        if v and not selectedEmoteName then 
            WindUI:Notify({Title = "Peringatan", Content = "Pilih Emote!", Duration = 3}) 
            return 
        end
        activeRock, curDur, getgenv().autoFarm = r[1], r[2], v
        if v then startFarm(3) end
    end})
end

player.CharacterAdded:Connect(function() if getgenv().autoFarm then task.wait(2) startFarm(3) end end)

local ZorVexStatus = {}
ZorVexStatus.__index = ZorVexStatus

function ZorVexStatus.new(mainWindow)
    local self = setmetatable({}, ZorVexStatus)
    self.Window = mainWindow
    self.StatsTab = nil
    self.PlayerDropdown = nil
    self.SelectedPlayer = game.Players.LocalPlayer
    self.PlayerOriginalStats = {}
    self.UseCompact = true 
    self.StatsLabel = nil
    self.GainedLabel = nil

    self:CreateStatsUI()
    self:InitPlayerStats()
    self:StartAutoRefresh()

    return self
end

function ZorVexStatus:FormatNumber(n)
    n = tonumber(n) or 0
    if not self.UseCompact then
        local formatted = tostring(math.floor(n))
        while true do  
            local k
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k == 0) then break end
        end
        return formatted
    end
    if n < 1000 then return tostring(math.floor(n)) end
    local symbols = {"", "k", "M", "B", "T", "Qa", "Qi"}
    local symbolIndex = math.floor(math.log10(n) / 3)
    if symbolIndex >= #symbols then symbolIndex = #symbols - 1 end
    local power = 10 ^ (symbolIndex * 3)
    local value = n / power
    local finalValue = math.floor(value * 10) / 10
    local formatted = string.format("%.1f", finalValue):gsub("%.0$", "")
    return formatted .. symbols[symbolIndex + 1]
end

function ZorVexStatus:InitPlayerStats()
    local Players = game:GetService("Players")
    
    -- Inisialisasi untuk player yang sudah ada saat script dijalankan
    for _, plr in ipairs(Players:GetPlayers()) do
        task.spawn(function()
            plr:WaitForChild("leaderstats", 10)
            task.wait(1) -- Jeda agar data replikasi dari server stabil
            self:StoreOriginalStats(plr)
        end)
    end

    -- Inisialisasi untuk player yang baru join ke server
    Players.PlayerAdded:Connect(function(plr)
        local ls = plr:WaitForChild("leaderstats", 20)
        if ls then
            -- JEDA KRUSIAL: Menunggu data "Strength/Stats" asli player ter-load dari database game
            -- Jika tanpa wait, script mengambil angka 0, lalu sedetik kemudian jadi 10M (menyebabkan Gained +10M)
            task.wait(2) 
            self:StoreOriginalStats(plr)
            self:UpdateDropdown()
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        if self.SelectedPlayer == plr then
            self.SelectedPlayer = Players.LocalPlayer
        end
        self.PlayerOriginalStats[plr] = nil
        self:UpdateDropdown()
    end)
end

function ZorVexStatus:StoreOriginalStats(plr)
    -- Sistem Pengunci: Jika data awal sudah ada, JANGAN ditimpa lagi.
    if not plr or self.PlayerOriginalStats[plr] then return end
    
    local statsTable = {}
    local ls = plr:FindFirstChild("leaderstats")
    
    -- Catat nilai yang ada sekarang sebagai "Original" (Titik Nol)
    if ls then
        for _, s in ipairs(ls:GetChildren()) do
            if s:IsA("NumberValue") or s:IsA("IntValue") then
                statsTable[s.Name] = s.Value or 0
            end
        end
    end

    -- Catat stats tambahan
    local extras = {"Durability", "Agility"}
    for _, name in ipairs(extras) do
        local obj = plr:FindFirstChild(name)
        statsTable[name] = obj and obj.Value or 0
    end

    -- Simpan permanen sampai player keluar
    self.PlayerOriginalStats[plr] = statsTable
end

function ZorVexStatus:CreateStatsUI()
    self.StatsTab = self.Window:Tab({
        Title = "Stats",
        Icon = "trending-up"
    })
    
    local configSection = self.StatsTab:Section({
        Title = "View Stats Player",
        Icon = "trending-up"
    })

    self.StatsTab:Button({
        Title = "Change Version Stats",
        Desc = "Change V1 Compact & V2 Details ",
        Callback = function()
            self.UseCompact = not self.UseCompact
            local statusDesc = self.UseCompact and "Compact Mode" or "Detail Mode"
            if WindUI then
                WindUI:Notify({
                    Title = "Type Stats Change",
                    Content = "Use " .. statusDesc,
                    Duration = 1.5,
                    Icon = "settings-2"
                })
            end
        end
    })

    self:UpdateDropdown()

    local displaySection = self.StatsTab:Section({
        Title = "View Stats V1 And View Stats V2",
    })

    self.StatsLabel = self.StatsTab:Paragraph({
        Title = "Loading stats...",
        Desc = ""
    })

    self.GainedLabel = self.StatsTab:Paragraph({
        Title = "Gained: 0",
        Desc = ""
    })
end

function ZorVexStatus:UpdateDropdown()
    local Players = game:GetService("Players")
    local playerNames = {}
    
    for _, plr in ipairs(Players:GetPlayers()) do
        table.insert(playerNames, plr.Name)
    end

    if self.PlayerDropdown then
        self.PlayerDropdown:Refresh(playerNames)
    else
        self.PlayerDropdown = self.StatsTab:Dropdown({
            Title = "Select Player Target",
            Values = playerNames,
            Callback = function(v)
                self.SelectedPlayer = Players:FindFirstChild(v) or Players.LocalPlayer
            end
        })
    end
end

function ZorVexStatus:RefreshStats()
    if not self.SelectedPlayer or not self.SelectedPlayer.Parent then
        self.SelectedPlayer = game.Players.LocalPlayer
    end

    local target = self.SelectedPlayer
    local statsText = ""
    local gainedText = ""
    local extras = {"Durability", "Agility"}
    local fontSizeBody = 18   
    local fontSizeTitle = 28 

    -- Proteksi jika StoreOriginalStats luput saat join
    if not self.PlayerOriginalStats[target] then
        self:StoreOriginalStats(target)
    end

    local ls = target:FindFirstChild("leaderstats")
    if ls then
        for _, stat in ipairs(ls:GetChildren()) do
            if stat:IsA("NumberValue") or stat:IsA("IntValue") then
                local val = stat.Value or 0
                local orig = (self.PlayerOriginalStats[target] and self.PlayerOriginalStats[target][stat.Name]) or val
                statsText = statsText .. '<font size="'..fontSizeBody..'"><b>' .. stat.Name .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
                gainedText = gainedText .. '<font size="'..fontSizeBody..'"><b>' .. stat.Name .. ": +" .. self:FormatNumber(val - orig) .. "</b></font>\n"
            end
        end
    end

    for _, name in ipairs(extras) do
        local obj = target:FindFirstChild(name)
        local val = obj and obj.Value or 0
        local orig = (self.PlayerOriginalStats[target] and self.PlayerOriginalStats[target][name]) or val
        statsText = statsText .. '<font size="'..fontSizeBody..'"><b>' .. name .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
        gainedText = gainedText .. '<font size="'..fontSizeBody..'"><b>' .. name .. ": +" .. self:FormatNumber(val - orig) .. "</b></font>\n"
    end

    pcall(function()
        if self.StatsLabel then
            self.StatsLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>' .. target.DisplayName .. '</b></font>')
            self.StatsLabel:SetDesc(statsText)
        end
        if self.GainedLabel then
            self.GainedLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>Stats Gained</b></font>')
            self.GainedLabel:SetDesc(gainedText)
        end
    end)
end

function ZorVexStatus:StartAutoRefresh()
    task.spawn(function()
        while true do
            task.wait(0.5)
            self:RefreshStats()
        end
    end)
end

local StatsSystem = ZorVexStatus.new(Window)

local teleportTab = Window:Tab({Title = "Teleport", Icon = "map-pin"})
local CustomSection = teleportTab:Section({Title = "Teleport Custom", Icon = "user-cog"})

local customPosInput = "0, 0, 0"
local lockCustomPos = false

teleportTab:Input({
    Title = "Target Position",
    Desc = "You Are Free To Teleport Anywhere",
    Placeholder = "Enter Costume Position",
    Callback = function(text)
        customPosInput = text
    end
})

teleportTab:Button({
    Title = "Get Your Position",
    Desc = "Copy Your Position",
    Callback = function()
        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local pos = root.Position
            local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
            
            setclipboard(formattedPos)
            
            if WindUI then
                WindUI:Notify({
                    Title = "Position Done Copy",
                    Content = "You Have Copy The Position",
                    Duration = 1,
                    Icon = "clipboard-check"
                })
            end
        end
    end
})

teleportTab:Toggle({
    Title = "Teleport Your Position",
    Value = false,
    Callback = function(state)
        lockCustomPos = state
        
        if state then
            task.spawn(function()
                while lockCustomPos do
                    local coords = {}
                    for val in string.gmatch(customPosInput, "[^,]+") do
                        table.insert(coords, tonumber(val))
                    end
                    
                    if #coords >= 3 then
                        local targetCF = CFrame.new(coords[1], coords[2], coords[3])
                        local root = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root then
                            root.CFrame = targetCF
                        end
                    end
                    task.wait(0.005)
                end
            end)
        end
    end
})

local TeleportSection = teleportTab:Section({Title = "Teleport Mode", Icon = "map-pin"})

local currentVersion = "Portal Telpeort"
local toggleStates = {}
local activeLoops = {}

local teleportData = {
    ["Portal Teleport"] = {
        {"Spawn", CFrame.new(2, 8, 115)}, {"Secret Area", CFrame.new(1947, 2, 6191)}, {"Tiny Island", CFrame.new(-34, 7, 1903)},
        {"Frozen", CFrame.new(-2600, 3, -403)}, {"Mythical", CFrame.new(2255, 7, 1071)}, {"Inferno", CFrame.new(-6768, 7, -1287)},
        {"Legend", CFrame.new(4604, 991, -3887)}, {"Muscle King", CFrame.new(-8646, 17, -5738)}, {"Jungle", CFrame.new(-8659, 6, 2384)}
    },
    ["Area Spawn"] = {
        {"Area Spawn V1", CFrame.new(-288.63, 34.37, -1242.75)}, {"Area Spawn V2", CFrame.new(198.11, 43.87, -1281.25)}, {"Area Spawn V3", CFrame.new(753.85, 37.22, -953.21)},
        {"Area Spawn V4", CFrame.new(867.29, 36.51, -153.79)}, {"Area Spawn V5", CFrame.new(911.35, 41.67, 328.53)}, {"Area Spawn V6", CFrame.new(176.71, 34.37, 678.06)},
        {"Area Spawn V7", CFrame.new(-278.76, 41.67, 803.21)}, {"Area Spawn V8", CFrame.new(-820.03, 34.37, 323.52)}, {"Area Spawn V9", CFrame.new(-864.29, 41.67, -148.20)}
    }, 
    ["Area Frost"] = {
        {"Frost V1", CFrame.new(-3632.78, 41.67, -611.01)}, {"Frost V2", CFrame.new(-3018.51, 34.37, -1133.93)}, {"Frost V3", CFrame.new(-2540.17, 41.67, -1139.82)},
        {"Frost V4", CFrame.new(-2076.97, 34.37, -572.28)}, {"Frost V5", CFrame.new(-2030.41, 41.67, -99.55)}, {"Frost V6", CFrame.new(-2549.26, 34.37, 314.38)},
        {"Frost V7", CFrame.new(-3024.51, 41.67, 322.30)}, {"Frost V8", CFrame.new(-3666.25, 34.37, -136.61)}, {"Frost V9", CFrame.new(-2846.15, 89.44, -406.46)}
    }, 
    ["Area Mythical"] = {
        {"Mythical V1", CFrame.new(1611.91, 41.67, 831.43)}, {"Mythical V2", CFrame.new(2231.55, 34.37, 307.55)}, {"Mythical V3", CFrame.new(2702.26, 41.67, 299.23)},
        {"Mythical V4", CFrame.new(3168.63, 34.37, 869.02)}, {"Mythical V5", CFrame.new(3216.70, 41.67, 1340.99)}, {"Mythical V6", CFrame.new(2697.76, 34.37, 1756.94)},
        {"Mythical V7", CFrame.new(2219.95, 41.67, 1765.28)}, {"Mythical V8", CFrame.new(1580.94, 34.37, 1304.18)}, {"Mythical V9", CFrame.new(1613.45, 41.67, 834.61)}
    },
    ["Area Inferno"] = {
        {"Inferno V1", CFrame.new(-6171.77, 41.67, -980.01)}, {"Inferno V2", CFrame.new(-6694.84, 34.37, -564.37)}, {"Inferno V3", CFrame.new(-7168.48, 41.67, -555.94)},
        {"Inferno V4", CFrame.new(-7808.35, 34.37, -998.05)}, {"Inferno V5", CFrame.new(-7775.84, 41.67, -1485.05)}, {"Inferno V6", CFrame.new(-7158.84, 34.37, -2013.57)},
        {"Inferno V7", CFrame.new(-6685.91, 41.67, -2022.32)}, {"Inferno V8", CFrame.new(-6223.72, 34.37, -1448.29)}, {"Inferno V9", CFrame.new(-6986.32, 89.65, -1287.44)}
    }, 
    ["Area Jungle"] = {
        {"jungle V1", CFrame.new(-7429.39, 137.64, 3539.27)}, {"jungle V2", CFrame.new(-7111.83, 137.06, 3076.58)}, {"jungle V3", CFrame.new(-7055.04, 102.05, 2162.77)},
        {"jungle V4", CFrame.new(-7733.45, 55.73, 1369.46)}, {"jungle V5", CFrame.new(-8480.99, 134.16, 1414.67)}, {"jungle V6", CFrame.new(-9138.68, 149.24, 1827.94)},
        {"jungle V7", CFrame.new(-9430.28, 53.89, 2438.14)}, {"jungle V8", CFrame.new(-8183.44, 76.41, 1383.64)}, {"jungle V9", CFrame.new(-8116.44, 223.95, 2397.24)}
    },
    ["Void Brawl"] = {
        {"Void Brawl V1", CFrame.new(3674.49, 36.89, -8295.16)}, {"Void Brawl V2", CFrame.new(3493.97, 43.50, -9086.34)}, {"Void Brawl V3", CFrame.new(3738.08, 44.34, -9585.31)},
        {"Void Brawl V4", CFrame.new(4338.64, 34.36, -9808.24)}, {"Void Brawl V5", CFrame.new(4930.11, 41.82, -9722.39)}, {"Void Brawl V6", CFrame.new(5391.56, 34.33, -9308.55)},
        {"Void Brawl V7", CFrame.new(5442.33, 41.82, -8625.02)}, {"Void Brawl V8", CFrame.new(5197.84, 41.72, -8176.37)}, {"Void Brawl V9", CFrame.new(4725.28, 37.66, -7899.020)}
    }, 
    ["Desert Brawl"] = {
        {"Desert Brawl V1", CFrame.new(1931.75, 40.69, -7161.35)}, {"Desert Brawl V2", CFrame.new(1684.34, 36.89, -6721.88)}, {"Desert Brawl V3", CFrame.new(1219.53, 33.80, -6438.87)},
        {"Desert Brawl V4", CFrame.new(720.85, 41.19, -6453.78)}, {"Desert Brawl V5", CFrame.new(164.57, 36.33, -6832.94)}, {"Desert Brawl V6", CFrame.new(-20.00, 42.37, -7631.01)},
        {"Desert Brawl V7", CFrame.new(232.82, 43.22, -8137.93)}, {"Desert Brawl V8", CFrame.new(819.16, 35.41, -8351.83)}, {"Desert Brawl V9", CFrame.new(1420.26, 39.57, -8256.59)}
    },
    ["Ori Brawl"] = {
        {"Ori Brawl V1", CFrame.new(-1139.72, 40.46, -5530.67)}, {"Ori Brawl V2", CFrame.new(-1606.91, 31.70, -5256.56)}, {"Ori Brawl V3", CFrame.new(-2098.54, 45.80, -5250.18)},
        {"Ori Brawl V4", CFrame.new(-2655.81, 32.86, -5641.19)}, {"Ori Brawl V5", CFrame.new(-2826.76, 40.16, -6442.06)}, {"Ori Brawl V6", CFrame.new(-2599.99, 40.03, -6931.56)},
        {"Ori Brawl V7", CFrame.new(-1389.05, 38.73, -7072.45)}, {"Ori Brawl V8", CFrame.new(-940.97, 36.17, -6660.76)}, {"Ori Brawl V9", CFrame.new(-1403.06, 39.54, -7063.23)}
    }
}

teleportTab:Dropdown({
    Title = "Change Teleport Version",
    Desc = "Version Details",
    Values = {"Portal Teleport", "Area Spawn", "Area Frost", "Area Mythical", "Area Inferno", "Area Jungle", "Void Brawl", "Desert Brawl", "Ori Brawl"},
    Callback = function(v)
        currentVersion = v
        RefreshButtons()
    end
})

local ButtonSection = teleportTab:Section({ 
    Title = "Teleport",
    Icon = "list"
})

local function safeTeleport(cframe)
    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = cframe end
end

local TeleportToggles = {}

for i = 1, 9 do
    toggleStates[i] = false
    TeleportToggles[i] = teleportTab:Toggle({
        Title = "Select Version Teleport",
        Desc = "Teleport Detail Mode",
        Value = false,
        Callback = function(state)
            toggleStates[i] = state
            
            if state then
                task.spawn(function()
                    while toggleStates[i] do
                        local data = teleportData[currentVersion][i]
                        if data then
                            safeTeleport(data[2])
                        end
                        task.wait(0.005)
                    end
                end)
            end
        end
    })
end

function RefreshButtons()
    local locations = teleportData[currentVersion]
    for i = 1, 9 do
        if locations[i] then
            TeleportToggles[i]:SetTitle(locations[i][1])
        end
    end
end

RefreshButtons()
