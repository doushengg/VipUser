local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local player = Players.LocalPlayer
local displayName = player.DisplayName
local startTime = os.time()
local startRebirths = player.leaderstats.Rebirths.Value
local petsFolder = player:WaitForChild("petsFolder")
local rEvents = ReplicatedStorage:WaitForChild("rEvents")
local tradingEvent = rEvents:WaitForChild("tradingEvent")

local selectedPetName = ""
local selectedPlayer = nil
local autoTradeToSelected = false
local autoTradeToAll = false
local PET_COUNT = 6

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
end)

local dragging, dragInput, dragStart, startPos
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

Window:Tag({
    Title = "--> VIP <--",
    Color = Color3.fromHex("#000000")
})

local rocks = {
    {"Jungle Rock", 10000000},
    {"Muscle King Rock", 5000000},
    {"Legend Rock", 1000000},
    {"Eternal Rock", 750000},
    {"Mythical Rock", 400000},
    {"Frozen Rock", 150000},
    {"Golden Rock", 5000},
    {"Starter Rock", 100},
    {"Tiny Rock", 0}
}

local farmPlusTab = Window:Tab({Title = "Farming", Icon = "cpu"})

local VipUser = farmPlusTab:Section({
    Title = "Vip Mode",
    Icon = "gem"
})

local c = game.Players.LocalPlayer
local a = game.ReplicatedStorage
local repSetting = 1

farmPlusTab:Input({
    Title = "Set Repetition",
    Placeholder = "Set Fast Strength",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            repSetting = num
        end
    end
})

farmPlusTab:Toggle({
    Title = "Push Strength",
    Callback = function(state)
        getgenv().PushStrengthEnabled = state
        
        if state then
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    for y = 1, repSetting do
                        if not getgenv().PushStrengthEnabled then break end
                        c.muscleEvent:FireServer("rep")
                    end
                    task.wait()
                end
            end)
        end
    end
})

farmPlusTab:Button({
    Title = "Fps Frames",
    Callback = function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if obj.Name:match("Frame$") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "Success", Content = "Frame 100% Fps Boost"})
    end
})  

local unlockGp = farmPlusTab:Section({
    Title = "Farm Tools",
    Icon = "circle-dollar-sign"
})

farmPlusTab:Button({
    Title = "Unlock Gamepass AutoLift",
    Desc = "Unlock Free No Robux",
    Callback = function()
        local gamepassFolder = ReplicatedStorage:FindFirstChild("gamepassIds")
        local ownedFolder = player:FindFirstChild("ownedGamepasses")
        if gamepassFolder and ownedFolder then
            for _, gamepass in pairs(gamepassFolder:GetChildren()) do
                if not ownedFolder:FindFirstChild(gamepass.Name) then
                    local value = Instance.new("IntValue")
                    value.Name = gamepass.Name
                    value.Value = gamepass.Value
                    value.Parent = ownedFolder
                end
            end
            WindUI:Notify({Title = "Success", Content = "AutoLift Gamepass Unlocked!"})
        end
    end
})

local Farmingg = farmPlusTab:Section({
    Title = "Farm Tools",
    Icon = "swords"
})

local muscleEvent = player:WaitForChild("muscleEvent")

local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    local char = player.Character
    if backpack and char and char:FindFirstChild("Humanoid") then
        local tool = backpack:FindFirstChild(toolName)
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
end

local function unequipTool(toolName)
    local char = player.Character
    if char then
        local equipped = char:FindFirstChild(toolName)
        if equipped then
            equipped.Parent = player.Backpack
        end
    end
end

local function startAutoRep(flagName, toolName)
    task.spawn(function()
        while _G[flagName] do
            local char = player.Character
            if not char or not char:FindFirstChild("Humanoid") then
                task.wait(0.5)
                continue
            end
            if not char:FindFirstChild(toolName) then
                equipTool(toolName)
            end
            muscleEvent:FireServer("rep")
            task.wait(0.1)
        end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1.5)
    local tools = {
        {flag = "AutoWeight", tool = "Weight"},
        {flag = "AutoPushups", tool = "Pushups"},
        {flag = "AutoHandstands", tool = "Handstands"},
        {flag = "AutoSitups", tool = "Situps"},
    }
    for _, info in ipairs(tools) do
        if _G[info.flag] then
            equipTool(info.tool)
            startAutoRep(info.flag, info.tool)
        end
    end
end)

local toolConfigs = {
    {"Auto Weight", "AutoWeight", "Weight"},
    {"Auto Pushups", "AutoPushups", "Pushups"},
    {"Auto Handstands", "AutoHandstands", "Handstands"},
    {"Auto Situps", "AutoSitups", "Situps"}
}

for _, tool in ipairs(toolConfigs) do
    farmPlusTab:Toggle({
        Title = tool[1],
        Callback = function(Value)
            _G[tool[2]] = Value
            if Value then
                equipTool(tool[3])
                startAutoRep(tool[2], tool[3])
            else
                unequipTool(tool[3])
            end
        end
    })
end

local function createComboSection(sectionTitle, durNeeded)
    farmPlusTab:Section({Title = sectionTitle, Icon = "diamond-plus"})
    
    local state = {push = false, sit = false, hand = false}

    local function punchRock()
        local char = player.Character
        local bp = player:FindFirstChild("Backpack")
        if char and bp and char:FindFirstChild("Humanoid") then
            local punch = bp:FindFirstChild("Punch") or char:FindFirstChild("Punch")
            if punch then
                if punch.Parent == bp then char.Humanoid:EquipTool(punch) end
                local at = punch:FindFirstChild("attackTime")
                if at then at.Value = 0.0001 end
                muscleEvent:FireServer("punch", "rightHand")
                muscleEvent:FireServer("punch", "leftHand")
                punch:Activate()
            end
        end
    end

    local function tryRockTouch()
        local char = player.Character
        local dur = player:FindFirstChild("Durability")
        if dur and dur.Value >= durNeeded then
            local machines = workspace:FindFirstChild("machinesFolder")
            if machines then
                for _, v in pairs(machines:GetDescendants()) do
                    if v.Name == "neededDurability" and v.Value == durNeeded then
                        local rock = v.Parent:FindFirstChild("Rock")
                        if rock and char then
                            local rh = char:FindFirstChild("RightHand")
                            local lh = char:FindFirstChild("LeftHand")
                            if rh and lh then
                                firetouchinterest(rock, rh, 0)
                                firetouchinterest(rock, rh, 1)
                                firetouchinterest(rock, lh, 0)
                                firetouchinterest(rock, lh, 1)
                                punchRock()
                            end
                        end
                    end
                end
            end
        end
    end

    local function doRep(toolName)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            if not char:FindFirstChild(toolName) then
                equipTool(toolName)
            end
            muscleEvent:FireServer("rep")
        end
    end

    task.spawn(function()
        while true do
            if state.push then doRep("Pushups"); tryRockTouch() end
            if state.sit then doRep("Situps"); tryRockTouch() end
            if state.hand then doRep("Handstands"); tryRockTouch() end
            task.wait(0.1)
        end
    end)

    local cleanTitle = sectionTitle:gsub("Combo ", "")
    farmPlusTab:Toggle({Title = "Pushups + " .. cleanTitle, Callback = function(s) state.push = s end})
    farmPlusTab:Toggle({Title = "Situps + " .. cleanTitle, Callback = function(s) state.sit = s end})
    farmPlusTab:Toggle({Title = "Handstands + " .. cleanTitle, Callback = function(s) state.hand = s end})
end

for _, rockData in ipairs(rocks) do
    createComboSection("Combo " .. rockData[1], rockData[2])
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

local function pressE()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

getgenv().working = false

local function autoLift()
    while getgenv().working do
        player.muscleEvent:FireServer("rep")
        task.wait() 
    end
end

local function teleportAndStart(machineName, position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 9 do 
            character.HumanoidRootPart.CFrame = position
            task.wait(0.01)
            pressE()
            task.spawn(autoLift) 
        end 
    end
end

local function CreateGymToggle(parent, title, name, pos)
    parent:Toggle({
        Title = title,
        Callback = function(bool)
            if getgenv().working and not bool then getgenv().working = false return end
            getgenv().working = bool
            if bool then teleportAndStart(name, pos) end
        end
    })
end

local function CreateTreadmillToggle(parent, title, size, pos)
    parent:Toggle({
        Title = title,
        Default = false,
        Callback = function(bool)
            _G.AutoTreadmillActive = bool
            local char = player.Character or player.CharacterAdded:Wait()
            local hum, hrp = char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
            if bool then
                task.spawn(function()
                    local r = ReplicatedStorage:FindFirstChild("rEvents")
                    if r and r:FindFirstChild("changeSpeedSizeRemote") then
                        r.changeSpeedSizeRemote:InvokeServer("changeSize", size)
                    end
                end)
                task.wait(0.3)
                hrp.CFrame = pos
                _G.LockedCFrame = pos
                task.spawn(function()
                    while _G.AutoTreadmillActive and char and hum and hrp do
                        hrp.Velocity = Vector3.new(0, 0, 0)
                        hrp.CFrame = _G.LockedCFrame
                        hum:Move(Vector3.new(0, 0, -1), true)
                        task.wait()
                    end
                end)
            else
                _G.LockedCFrame = nil
                if hum then hum:Move(Vector3.new(0, 0, 0), true) end
                if hrp then hrp.Velocity = Vector3.new(0, 0, 0) end
            end
        end
    })
end

local farmGymTab = Window:Tab({Title = "Gym Farm", Icon = "dumbbell"})

farmGymTab:Section({Title = "Farm ( Jungle Gym )", Icon = "tree-palm"})
CreateGymToggle(farmGymTab, "Jungle Press", "Bench Press", CFrame.new(-8173, 64, 1898))
CreateGymToggle(farmGymTab, "Jungle Squat", "Squat", CFrame.new(-8352, 34, 2878))
CreateGymToggle(farmGymTab, "Jungle Pull Ups", "Pull Up", CFrame.new(-8666, 34, 2070))
CreateGymToggle(farmGymTab, "Jungle Boulder", "Boulder", CFrame.new(-8621, 34, 2684))
CreateTreadmillToggle(farmGymTab, "Treadmill Jungle V1", 10, CFrame.new(-8131.98, 60.97, 2828.13, -0.999, 0, 0.017, 0, 1, 0, -0.017, 0, -0.999))

farmGymTab:Section({Title = "Farm ( Muscle King )", Icon = "crown"})
CreateGymToggle(farmGymTab, "Muscle King Press", "Bench Press", CFrame.new(-8590.23, 51, -6044.59, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Muscle King Squat", "Squat", CFrame.new(-8758.44, 44.14, -6043.06, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Muscle King Lifting", "Pull Up", CFrame.new(-8772.97, 49.73, -5663.56, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Muscle King Boulder", "Boulder", CFrame.new(-8942.12, 49.60, -5691.63, -1, 0, 0, 0, 1, 0, 0, 0, -1))

farmGymTab:Section({Title = "Farm ( Legends Gym )", Icon = "dumbbell"})
CreateGymToggle(farmGymTab, "Legends Press", "Bench Press", CFrame.new(4109.91, 1019.8, -3802.15, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Legends Squat", "Squat", CFrame.new(4439.77, 1019.3, -4058.48, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Legends Lifting", "Squat", CFrame.new(4532.21, 1023.0, -4002.71, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Legends Pull Ups", "Pull Up", CFrame.new(4304.02, 1020.0, -4122.27, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Legends Boulder", "Boulder", CFrame.new(4189.96, 1010.2, -3903.01, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateTreadmillToggle(farmGymTab, "Treadmill Legends V1", 10, CFrame.new(4363.27, 1032.3, -3657.75, -0.972, 0, -0.233, 0, 1, 0, 0.233, 0, -0.972))

farmGymTab:Space()

farmGymTab:Section({Title = "Farm ( Inferno Gym )", Icon = "flame"})
CreateGymToggle(farmGymTab, "Inferno Press", "Bench Press", CFrame.new(-7173.34, 44.73, -1105.02, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateTreadmillToggle(farmGymTab, "Treadmill Inferno V1", 20, CFrame.new(-7041.82, 99.33, -1456.46, -0.037, 0, 0.999, 0, 1, 0, -0.999, 0, -0.037))

farmGymTab:Section({Title = "Farm ( Mythical Gym )", Icon = "biohazard"})
CreateGymToggle(farmGymTab, "Mythical Press", "Bench Press", CFrame.new(2369.7, 38.55, 1243.02, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Mythical Pull Ups", "Pull Up", CFrame.new(2487.12, 29.9, 848.28, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Mythical Boulder", "Boulder", CFrame.new(2667.74, 46.02, 1203.33, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateTreadmillToggle(farmGymTab, "Treadmill Mythical V1", 15, CFrame.new(2659.21, 72.97, 945.43, 0.999, 0, -0.005, 0, 1, 0, 0.005, 0, 0.999))
CreateTreadmillToggle(farmGymTab, "Treadmill Mythical V2", 7, CFrame.new(2570.9, 37.69, 901.21, 0.999, 0, -0.033, 0, 1, 0, 0.033, 0, 0.999))

farmGymTab:Section({Title = "Farm ( Frost Gym )", Icon = "gem"})
CreateGymToggle(farmGymTab, "Frost Press V1", "Frost Press", CFrame.new(-3008.66, 61.61, -337.74, -0.006, 0, -0.999, 0, 1, 0, 0.999, 0, -0.006))
CreateGymToggle(farmGymTab, "Frost Press V2", "Frost Press", CFrame.new(-2748.75, 22.52, -181.81, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Frost Lifting", "Frost Lift", CFrame.new(-2917.47, 58.21, -209.56, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateGymToggle(farmGymTab, "Frost Squat", "Frost Squat", CFrame.new(-2720.05, 50.42, -591.25, -1, 0, 0, 0, 1, 0, 0, 0, -1))
CreateTreadmillToggle(farmGymTab, "Treadmill Frozen V1", 20, CFrame.new(-2901.66, 99.33, -583.27, 0, 0, 1, 0, 1, 0, -1, 0, 0))
CreateTreadmillToggle(farmGymTab, "Treadmill Frozen V2", 7, CFrame.new(-2991.59, 36.32, -466.85, -0.015, 0, 0.999, 0, 1, 0, -0.999, 0, -0.015))

local petList = {
    "Pet Type Unique",
    "Neon Guardian",
    "Darkstar Hunter",
    "Ultra Birdie",
    "Infernal Dragon",
    "Blue Pheonix",
    "Pet Type Epic/Rare",
    "Muscle Sensei",
    "Magic Butterfly",
    "Blue Firecaster",
    "Orange Pegasus",
    "Golden Pheonix",
    "Blue Birdie",
    "Red Kitty",
    "Green Butterfly",
    "Crimson Falcon",
    "Pet Type Common",
    "Golden Viking",
    "Eternal Strike Leviathan",
    "White Pheonix",
    "Green Firecaster",
    "White Pegasus",
    "Red Firecaster",
    "Purple Falcon",
    "Red Dragon",
    "Purple Dragon",
    "Yellow Butterfly",
    "Dark Golem",
    "Silver Dog",
    "Dark Vampy",
    "Orange Hedgehog",
    "Blue Bunny"
}

local selectedCrystal = "Galaxy Oracle Crystal"
local autoCrystalRunning = false
local crystalNames = {
    "Blue Crystal", "Green Crystal", "Frozen Crystal", "Mythical Crystal",
    "Inferno Crystal", "Legends Crystal", "Muscle Elite Crystal",
    "Galaxy Oracle Crystal", "Sky Eclipse Crystal", "Jungle Crystal"
}

local crystalLocations = {
    ["Blue Crystal"] = CFrame.new(146.028351, 13.717124, 442.124329, -0.999997497, 2.62351296e-08, 0.00223747967, 2.63625104e-08, 1, 5.69004186e-08, -0.00223747967, 5.69592622e-08, -0.999997497),
    ["Green Crystal"] = CFrame.new(401.801666, 12.8904247, -199.838928, -0.999205112, 2.66482854e-08, -0.0398644879, 2.42038656e-08, 1, 6.180084e-08, 0.0398644879, 6.07868387e-08, -0.999205112),
    ["Frozen Crystal"] = CFrame.new(-2826.17505, 12.4487514, -136.568451, -0.999998152, -1.6662014e-08, -0.0019335954, -1.65819678e-08, 1, -4.14137098e-08, 0.0019335954, -4.13815719e-08, -0.999998152),
    ["Mythical Crystal"] = CFrame.new(2740.39575, 12.4637852, 1160.8103, -0.00988711324, 2.64721205e-08, -0.999951124, 6.02656203e-10, 1, 2.64674558e-08, 0.999951124, -3.40940054e-10, -0.00988711324),
    ["Inferno Crystal"] = CFrame.new(-6896.38135, 11.7803707, -1544.02441, 0.99954325, -5.91624305e-09, -0.0302205067, 3.04653303e-09, 1, -9.50050776e-08, 0.0302205067, 9.48696126e-08, 0.99954325),
    ["Legends Crystal"] = CFrame.new(4089.46289, 1001.05115, -3561.76465, -0.769366682, 2.05982467e-08, 0.638807416, 1.54783064e-09, 1, -3.03806686e-08, -0.638807416, -2.23851089e-08, -0.769366682),
    ["Muscle Elite Crystal"] = CFrame.new(0, 10, 0),
    ["Galaxy Oracle Crystal"] = CFrame.new(-9025.96582, 27.1186676, -5866.43164, -5.73926897e-08, -6.97595297e-08, 1, 5.31985584e-08, 1, 6.97595297e-08, -1, 5.31985656e-08, -5.73926826e-08),
    ["Sky Eclipse Crystal"] = CFrame.new(0, 10, 0),
    ["Jungle Crystal"] = CFrame.new(-7521.36963, 19.3545113, 2394.26147, -0.0145458542, -3.72062097e-08, -0.999894202, -9.37216349e-09, 1, -3.70738071e-08, 0.999894202, 8.83190143e-09, -0.0145458542)
}

local function autoOpenCrystal()
    while autoCrystalRunning do
        local rEvents = ReplicatedStorage:FindFirstChild("rEvents")
        if rEvents and rEvents:FindFirstChild("openCrystalRemote") then
            pcall(function() rEvents.openCrystalRemote:InvokeServer("openCrystal", selectedCrystal) end)
        end
        task.wait(0.1)
    end
end

local function getPlayerDisplay(plr)
    return (plr.DisplayName and plr.DisplayName ~= "") and plr.DisplayName or plr.Name
end

local function buildPlayerDisplayList()
    local list = {}
    if not player then return {"None"} end 
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(list, getPlayerDisplay(plr))
        end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

local function getPetInstances(petName, n)
    local pets = {}
    if not player then return pets end 
    local petsFolder = player:FindFirstChild("petsFolder")
    
    if petsFolder then
        for _, folder in ipairs(petsFolder:GetChildren()) do
            if folder:IsA("Folder") then
                for _, pet in ipairs(folder:GetChildren()) do
                    if pet.Name == petName then
                        table.insert(pets, pet)
                        if #pets >= n then 
                            return pets 
                        end
                    end
                end
            end
        end
    end
    
    return pets
end

local function isTradePending()
    if not player then return false end 
    return player:FindFirstChild("CurrentTrade") ~= nil
end

local function isTradeAccepted()
    if not player then return false end 
    local currentTrade = player:FindFirstChild("CurrentTrade")
    if currentTrade and currentTrade:FindFirstChild("Accepted") then
        return currentTrade.Accepted.Value
    end
    return false
end

local function mainTradeLoop()
    while true do
        if autoTradeToSelected and selectedPetName and selectedPlayer and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            if #pets > 0 then
                pcall(function() tradingEvent:FireServer("sendTradeRequest", selectedPlayer) end)
                task.wait(0.2)
                for _, pet in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", pet) end)
                    task.wait(0.1)
                end
                if not isTradeAccepted() then 
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(0.5) 
            end
        end

        if autoTradeToAll and selectedPetName and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            if #pets > 0 then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player then
                        pcall(function() tradingEvent:FireServer("sendTradeRequest", plr) end)
                        task.wait()
                    end
                end
                for _, pet in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", pet) end)
                    task.wait()
                end
                if not isTradeAccepted() then
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(3)
            end
        end

        local currentTrade = player:FindFirstChild("CurrentTrade")
        if currentTrade then
            pcall(function() tradingEvent:FireServer("acceptTrade") end) 
            task.wait(0.1)
            local tradeItems
            local timeoutStart = tick()
            repeat
                task.wait()
                tradeItems = currentTrade:FindFirstChild("OfferedItems")
                if tick() - timeoutStart > 8 then break end
            until tradeItems and #tradeItems:GetChildren() > 0
            pcall(function() tradingEvent:FireServer("confirmTrade") end)
            pcall(function() tradingEvent:FireServer("acceptTrade") end)
        end
        task.wait()
    end
end

local Crystal = Window:Tab({Title = "Crystal", Icon = "gem"})
local crystalSection = Crystal:Section({Title = "Pet Packs", Icon = "skull"})

local petPacksList = {
    "Tribal Overlord", 
    "Swift Samurai", 
    "Mighty Monster", 
    "Wild Wizard"
}

local selectedPack = ""

Crystal:Dropdown({
    Title = "Select Pet Pack",
    Values = petPacksList,
    Callback = function(value)
        selectedPack = value
    end
})

Crystal:Button({
    Title = "Equip Pet Pack",
    Callback = function()
        if selectedPack == "" then 
            WindUI:Notify({
                Title = "Error", 
                Content = "Silahkan pilih pet pack terlebih dahulu!", 
                Duration = 3
            })
            return 
        end

        for _, folder in pairs(petsFolder:GetChildren()) do
            if folder:IsA("Folder") then
                for _, petObj in pairs(folder:GetChildren()) do
                    rEvents.equipPetEvent:FireServer("unequipPet", petObj)
                end
            end
        end
        
        task.wait(0.3)

        local targetFolder = petsFolder:FindFirstChild("Unique")
        if targetFolder then
            local found = false
            for _, pet in pairs(targetFolder:GetChildren()) do
                if pet.Name == selectedPack then
                    rEvents.equipPetEvent:FireServer("equipPet", pet)
                    found = true
                end
            end
            
            if found then
                WindUI:Notify({
                    Title = "Success", 
                    Content = "Berhasil memasang pet: " .. selectedPack, 
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Not Found", 
                    Content = "Kamu tidak memiliki pet: " .. selectedPack, 
                    Duration = 3
                })
            end
        end
    end
})

local crystalSectionAll = Crystal:Section({Title = "Auto All Pet", Icon = "gitlab"})

local petOptions = {
    "Pet Type Unique",
    "Neon Guardian",
    "Darkstar Hunter",
    "Ultra Birdie",
    "Infernal Dragon",
    "Blue Pheonix",
    "Pet Type Epic/Rare",
    "Muscle Sensei",
    "Magic Butterfly",
    "Blue Firecaster",
    "Orange Pegasus",
    "Golden Pheonix",
    "Blue Birdie",
    "Red Kitty",
    "Green Butterfly",
    "Crimson Falcon",
    "Pet Type Common",
    "Golden Viking",
    "Eternal Strike Leviathan",
    "White Pheonix",
    "Green Firecaster",
    "White Pegasus",
    "Red Firecaster",
    "Purple Falcon",
    "Red Dragon",
    "Purple Dragon",
    "Yellow Butterfly",
    "Dark Golem",
    "Silver Dog",
    "Dark Vampy",
    "Orange Hedgehog",
    "Blue Bunny"
}

local currentSelectedPet = ""

Crystal:Dropdown({
    Title = "Select Pet",
    Values = petOptions,
    Callback = function(val)
        currentSelectedPet = val
    end
})

Crystal:Button({
    Title = "Equip Selected Pet",
    Callback = function()
        if currentSelectedPet ~= "" then
            for _, folder in pairs(petsFolder:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, petObj in pairs(folder:GetChildren()) do
                        rEvents.equipPetEvent:FireServer("unequipPet", petObj)
                    end
                end
            end

            task.wait(0.3)

            for _, folder in pairs(petsFolder:GetChildren()) do
                if folder:IsA("Folder") then
                    for _, pet in pairs(folder:GetChildren()) do
                        if pet.Name == currentSelectedPet then
                            rEvents.equipPetEvent:FireServer("equipPet", pet)
                            -- Break dihapus agar dia terus mencari pet lain dengan nama yang sama
                        end
                    end
                end
            end
        end
    end
})

Crystal:Button({
    Title = "Unequip All Pets",
    Callback = function()
        for _, folder in pairs(petsFolder:GetChildren()) do
            if folder:IsA("Folder") then
                for _, petObj in pairs(folder:GetChildren()) do
                    rEvents.equipPetEvent:FireServer("unequipPet", petObj)
                end
            end
        end
    end
})

Crystal:Toggle({
    Title = "Auto Buy Pet",
    Callback = function(state)
        getgenv().AutoBuy = state
        task.spawn(function()
            while getgenv().AutoBuy do
                if currentSelectedPet ~= "" then
                    local petObj = ReplicatedStorage.cPetShopFolder:FindFirstChild(currentSelectedPet)
                    if petObj then
                        ReplicatedStorage.cPetShopRemote:InvokeServer(petObj)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

Crystal:Toggle({
    Title = "Auto Evolve Pet",
    Callback = function(state)
        getgenv().AutoEvolve = state
        task.spawn(function()
            while getgenv().AutoEvolve do
                if currentSelectedPet ~= "" then
                    rEvents.petEvolveEvent:FireServer("evolvePet", currentSelectedPet)
                end
                task.wait(1)
            end
        end)
    end
})

local TradeTab = Crystal:Section({
    Title = "Auto Trade",
    Icon = "refresh-cw"
})

Crystal:Dropdown({
    Title = "Select Pet",
    Values = petList,
    Value = selectedPetName,
    Callback = function(p)
        selectedPetName = p
    end
})

Crystal:Dropdown({
    Title = "Select Player",
    Values = buildPlayerDisplayList(),
    Callback = function(selectedDisplay)
        selectedPlayer = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and getPlayerDisplay(plr) == selectedDisplay then
                selectedPlayer = plr
                break
            end
        end
    end
})

Crystal:Toggle({
    Title = "Trade Select Player",
    Callback = function(state)
        autoTradeToSelected = state
    end
})

Crystal:Toggle({
    Title = "Trade All Player",
    Callback = function(state)
        autoTradeToAll = state
    end
})

task.spawn(mainTradeLoop)

local crystalOpenSection = Crystal:Section({Title = "Open Crystal", Icon = "gem"})

Crystal:Dropdown({
    Title = "Select Crystal",
    Values = crystalNames,
    Value = selectedCrystal,
    Callback = function(text)
        selectedCrystal = text
    end
})

Crystal:Toggle({
    Title = "Auto Crystal",
    Callback = function(state)
        autoCrystalRunning = state
        if autoCrystalRunning then
            task.spawn(autoOpenCrystal)
        end
    end
})

Crystal:Button({
    Title = "Teleport To Crystal",
    Callback = function()
        local targetPos = crystalLocations[selectedCrystal]
        local player = game.Players.LocalPlayer
        
        if targetPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPos
        else
            warn("Lokasi tidak ditemukan atau Karakter belum load.")
        end
    end
})

local Players, RunService = game:GetService("Players"), game:GetService("RunService")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local killTargets, radiusVisuals, manualWhitelist = {}, {}, {}
local currentRadius, runAura, spyingEnabled, autoKillEnabled, tpToTargetEnabled = 50, false, false, false, false

-- Fungsi untuk mendapatkan list pemain terbaru
local function getDisplayList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then 
            table.insert(list, p.DisplayName .. "  [ " .. p.Name .. " ]") 
        end
    end
    return list
end

local function getName(text) return text and text:match("%[%s*(.-)%s*%]$") end

local KillSelect = Window:Tab({Title = "Killer", Icon = "locate-fixed"})
local KillerV1 = KillSelect:Section({Title = "Animation", Icon = "omega"})

KillSelect:Button({
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

KillSelect:Toggle({
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

-- SECTION: AUTO KILLER
KillSelect:Section({Title = "Auto Killer", Icon = "skull"})

local whitelistDropdown = KillSelect:Dropdown({
    Title = "Whitelist Player", 
    Values = getDisplayList(), 
    Callback = function(v) whitelistedPlayer = getName(v) end
})

KillSelect:Button({
    Title = "Refresh Whitelist",
    Icon = "refresh-cw",
    Callback = function() whitelistDropdown:Refresh(getDisplayList()) end
})

KillSelect:Toggle({
    Title = "Auto Kill All Players",
    Callback = function(v)
        autoKillAll = v
        if autoKillAll then
            task.spawn(function()
                while autoKillAll do
                    local char = lp.Character
                    local rh = char and char:FindFirstChild("RightHand")
                    local lh = char and char:FindFirstChild("LeftHand")
                    if rh or lh then
                        for _, t in ipairs(Players:GetPlayers()) do
                            if t ~= lp and t.Name ~= whitelistedPlayer and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                                local hrp = t.Character.HumanoidRootPart
                                local hum = t.Character:FindFirstChild("Humanoid")
                                if hum and hum.Health > 0 then
                                    if rh then firetouchinterest(rh, hrp, 1) firetouchinterest(rh, hrp, 0) end
                                    if lh then firetouchinterest(lh, hrp, 1) firetouchinterest(lh, hrp, 0) end
                                end
                            end
                        end
                    end
                    task.wait(0.1) 
                end
            end)
        end
    end
})

KillSelect:Toggle({
    Title = "Auto Good Karma",
    Callback = function(bool)
        autoGoodKarma = bool
        task.spawn(function()
            while autoGoodKarma do
                local char = lp.Character
                local rh, lh = char and char:FindFirstChild("RightHand"), char and char:FindFirstChild("LeftHand")
                if char and rh and lh then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= lp then
                            local evil = target:FindFirstChild("evilKarma")
                            local good = target:FindFirstChild("goodKarma")
                            if evil and good and evil.Value > good.Value then
                                local trp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if trp then
                                    firetouchinterest(rh, trp, 1) firetouchinterest(rh, trp, 0)
                                    firetouchinterest(lh, trp, 1) firetouchinterest(lh, trp, 0)
                                end
                            end
                        end
                    end
                end
                task.wait(0.01)
            end
        end)
    end
})

KillSelect:Toggle({
    Title = "Auto Evil Karma",
    Callback = function(bool)
        autoEvilKarma = bool
        task.spawn(function()
            while autoEvilKarma do
                local char = lp.Character
                local rh, lh = char and char:FindFirstChild("RightHand"), char and char:FindFirstChild("LeftHand")
                if char and rh and lh then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= lp then
                            local evil = target:FindFirstChild("evilKarma")
                            local good = target:FindFirstChild("goodKarma")
                            if evil and good and good.Value > evil.Value then
                                local trp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if trp then
                                    firetouchinterest(rh, trp, 1) firetouchinterest(rh, trp, 0)
                                    firetouchinterest(lh, trp, 1) firetouchinterest(lh, trp, 0)
                                end
                            end
                        end
                    end
                end
                task.wait(0.01)
            end
        end)
    end
})

-- SECTION: PLAYER TARGET
KillSelect:Section({Title = "Player Target", Icon = "crosshair"})

local spyDropdown = KillSelect:Dropdown({
    Title = "Spectate Player", 
    Values = getDisplayList(), 
    Callback = function(v) selectedSpyName = getName(v) end
})

KillSelect:Button({
    Title = "Refresh Spectate List",
    Icon = "refresh-cw",
    Callback = function() spyDropdown:Refresh(getDisplayList()) end
})

KillSelect:Toggle({
    Title = "Spectate Player", 
    Callback = function(v)
        spyingEnabled = v
        if not v then 
            Camera.CameraSubject = lp.Character.Humanoid 
        else
            task.spawn(function()
                while spyingEnabled do
                    local t = selectedSpyName and Players:FindFirstChild(selectedSpyName)
                    if t and t.Character and t.Character:FindFirstChild("Humanoid") then 
                        Camera.CameraSubject = t.Character.Humanoid 
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

local targetDropdown = KillSelect:Dropdown({
    Title = "Target Killer", 
    Values = getDisplayList(), 
    Callback = function(v) killTargets = {getName(v)} end
})

KillSelect:Button({
    Title = "Refresh Player Target",
    Icon = "refresh-cw",
    Callback = function() targetDropdown:Refresh(getDisplayList()) end
})

KillSelect:Toggle({
    Title = "Kill Target",
    Callback = function(v)
        autoKillEnabled = v
        while autoKillEnabled do
            local char = lp.Character
            if char and #killTargets > 0 then
                local t = Players:FindFirstChild(killTargets[1])
                local hrp = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
                local rh, lh = char:FindFirstChild("RightHand"), char:FindFirstChild("LeftHand")
                if hrp and rh and lh then
                    firetouchinterest(rh, hrp, 1) firetouchinterest(rh, hrp, 0)
                    firetouchinterest(lh, hrp, 1) firetouchinterest(lh, hrp, 0)
                end
            end
            task.wait(0.05)
        end
    end
})

KillSelect:Toggle({
    Title = "Bring Target",
    Callback = function(v)
        bringTargetsEnabled = v
        while bringTargetsEnabled do
            local char = lp.Character
            local hand = char and (char:FindFirstChild("RightHand") or char:FindFirstChild("LeftHand"))
            if hand and #killTargets > 0 then
                local t = Players:FindFirstChild(killTargets[1])
                if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then 
                    t.Character.HumanoidRootPart.CFrame = hand.CFrame 
                end
            end
            task.wait(0.1)
        end
    end
})

-- SECTION: TELEPORT
KillSelect:Section({Title = "Teleport Player", Icon = "map-pin-plus-inside"})

local tpDropdown = KillSelect:Dropdown({
    Title = "Select Teleport Target", 
    Values = getDisplayList(), 
    Callback = function(v) selectedTpName = getName(v) end
})

KillSelect:Button({
    Title = "Refresh Teleport Target",
    Icon = "refresh-cw",
    Callback = function() tpDropdown:Refresh(getDisplayList()) end
})

KillSelect:Toggle({
    Title = "Teleport to Player", 
    Callback = function(v)
        tpToTargetEnabled = v
        while tpToTargetEnabled do
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local t = selectedTpName and Players:FindFirstChild(selectedTpName)
            local thrp = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if hrp and thrp then hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) end
            task.wait(0.1)
        end
    end
})

-- SECTION: DOMAIN KILLER
KillSelect:Section({Title = "Domain Killer", Icon = "rotate-3d"})

local function updateVisual(radius)
    for _, v in ipairs(radiusVisuals) do v:Destroy() end
    radiusVisuals = {}
    local d = Instance.new("Part", workspace)
    d.Name, d.Shape, d.Anchored, d.CanCollide, d.CastShadow = "AuraDomain", "Ball", true, false, false
    d.Transparency, d.Material, d.Color = (_G.DomainTransparent and 1 or 0.7), "ForceField", Color3.new(0,0,0)
    d.Size = Vector3.new(radius*2, radius*2, radius*2)
    radiusVisuals[1] = d
end

KillSelect:Input({
    Title = "Set Domain Size", 
    Placeholder = "Size...", 
    Callback = function(v) 
        currentRadius = tonumber(v) or 50 
        if runAura then updateVisual(currentRadius) end 
    end
})

local domainWhitelistDropdown = KillSelect:Dropdown({
    Title = "Whitelist Players",
    Desc = "Player Save In Domain",
    Multi = true, 
    Values = getDisplayList(), 
    Callback = function(v)
        manualWhitelist = {} 
        for _, opt in ipairs(v) do 
            local n = getName(opt) 
            if n and Players:FindFirstChild(n) then 
                manualWhitelist[Players[n].UserId] = true 
            end 
        end
    end
})

KillSelect:Button({
    Title = "Player Refresh",
    Icon = "refresh-cw",
    Callback = function() domainWhitelistDropdown:Refresh(getDisplayList()) end
})

KillSelect:Toggle({
    Title = "Active Domain Killer", 
    Callback = function(v)
        runAura = v
        if auraConn then auraConn:Disconnect() end
        for _, vis in ipairs(radiusVisuals) do vis:Destroy() end radiusVisuals = {}
        if v then
            updateVisual(currentRadius)
            auraConn = RunService.Heartbeat:Connect(function()
                local c = lp.Character
                local hrp, rh, lh = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChild("RightHand"), c and c:FindFirstChild("LeftHand")
                if hrp and rh and lh then
                    if radiusVisuals[1] then radiusVisuals[1].CFrame = hrp.CFrame end
                    for _, p in ipairs(Players:GetPlayers()) do
                        local e = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if p ~= lp and not manualWhitelist[p.UserId] and e and (e.Position - hrp.Position).Magnitude <= currentRadius and p.Character.Humanoid.Health > 0 then
                            firetouchinterest(rh, e, 1) firetouchinterest(rh, e, 0)
                            firetouchinterest(lh, e, 1) firetouchinterest(lh, e, 0)
                        end
                    end
                end
            end)
        end
    end
})

KillSelect:Toggle({
    Title = "Invisible Domain", 
    Callback = function(v) 
        _G.DomainTransparent = v 
        if radiusVisuals[1] then radiusVisuals[1].Transparency = v and 1 or 0.7 end 
    end
})

local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

local glitch_h = rebirthTab:Section({
Title = "Fast Rebirth",
Icon = "skull"})

rebirthTab:Toggle({
    Title = "Fast Rebirth",
    Desc = "Fast Rebirth Only Works If You Have 7 Pet Packs",
    Callback = function(state)
        getgenv().IsAutoFarming = state

        if state then
            
            local d = function() 
                local f = c.petsFolder
                for g, h in pairs(f:GetChildren()) do
                    if h:IsA("Folder") then
                        for i, j in pairs(h:GetChildren()) do
                            a.rEvents.equipPetEvent:FireServer("unequipPet", j)
                        end
                    end
                end
                task.wait(.1)
            end

            local k = function(l) 
                d()
                task.wait(.01)
                for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
                    if n.Name == l then
                        a.rEvents.equipPetEvent:FireServer("equipPet", n)
                    end
                end
            end

            autoFarmThread = task.spawn(function()
                while getgenv().IsAutoFarming do
                    local v = c.leaderstats.Rebirths.Value
                    local w = 10000 + (5000 * v)
                    if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                        local x = c.ultimatesFolder["Golden Rebirth"].Value
                        w = math.floor(w * (1 - (x * 0.1)))
                    end
                    
                    d()
                    task.wait(.1)
                    k("Swift Samurai")
                    while c.leaderstats.Strength.Value < w and getgenv().IsAutoFarming do
                        for y = 1, 15 do
                            c.muscleEvent:FireServer("rep")
                        end
                        task.wait()
                    end
                    
                    if not getgenv().IsAutoFarming then break end

                    d()
                    task.wait(.1)
                    k("Tribal Overlord")
                    local A = c.leaderstats.Rebirths.Value
                    repeat
                        a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                        task.wait(.1)
                        if not getgenv().IsAutoFarming then break end 
                    until c.leaderstats.Rebirths.Value > A

                    task.wait() 
                end
            end)
        else
            if autoFarmThread and task.cancel then
                task.cancel(autoFarmThread)
                autoFarmThread = nil
            end
        end
    end
})

rebirthTab:Button({
    Title = "Delete Frames",
    Desc = "It Will Be Very Stable If You Push Rebirth",
    Callback = function()
        for _, obj in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if obj.Name:match("Frame$") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "Success", Content = "Frame Delete 100% Fps Boost"})
    end
})

local Farminjgg = rebirthTab:Section({
Title = "Rebirth Infinity",
Icon = "flame"})

rebirthTab:Toggle({
    Title = "Auto Rebirth Infinity",
    Desc = "Take Unlimited Rebirth 24/7",
    Callback = function(bool)
        local isAutoRebirthing = bool

        task.spawn(function()
            while isAutoRebirthing do 
                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1) 
            end
        end)
    end
})

local Farmingg = rebirthTab:Section({
Title = "Rebirth Target",
Icon = "crosshair"})

local rebirthTarget = 0
local rebirthingToTarget = false
local teleportActive = false
_G.FastWeight = false
_G.autoSizeActive = false

rebirthTab:Input({
    Title = "Rebirth Target",
    Callback = function(text)
        rebirthTarget = tonumber(text) or 0
    end
})

rebirthTab:Toggle({
    Title = "Auto Rebirth",
    Callback = function(bool)
        rebirthingToTarget = bool

        task.spawn(function()
            while rebirthingToTarget do
                local leaderstats = player:FindFirstChild("leaderstats")
                local rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths")

                if rebirths and rebirths.Value >= rebirthTarget then
                    rebirthingToTarget = false
                    break
                end

                ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(0.1)
            end
        end)
    end
})

local sizeValue = 1

rebirthTab:Input({
    Title = "Set Size",
    Placeholder = "Enter Your Size",
    Callback = function(text)
        local num = tonumber(text)
        if num then
            sizeValue = num
        end
    end
})

rebirthTab:Toggle({
    Title = "Auto Size",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive and task.wait() do
                    game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeValue)
                end
            end)
        end
    end
})

rebirthTab:Toggle({
    Title = "Hide Frame",
    Desc = "Fps Becomes More Booster",
    Callback = function(bool)
        for _, obj in pairs(ReplicatedStorage:GetChildren()) do
            if obj.Name:match("Frame$") then
                obj.Visible = not bool
            end
        end
    end
})

local Farmingg = rebirthTab:Section({
Title = "Farming",
Icon = "dumbbell"})

local function activateProteinEgg()
    local tool = player.Character:FindFirstChild("Protein Egg") or player.Backpack:FindFirstChild("Protein Egg")
    if tool then
        muscleEvent:FireServer("proteinEgg", tool)
    end
end

local running = false

task.spawn(function()
    while true do
        if running then
            activateProteinEgg()
            task.wait(1800)
        else
            task.wait(1)
        end
    end
end)

rebirthTab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = " Get 2x Strength | 30 Minute",
    Callback = function(state)
        running = state
        if state then
            activateProteinEgg()
        end
    end
})

rebirthTab:Toggle({
    Title = "Auto Weight",
    Callback = function(bool)
        _G.FastWeight = bool

        if bool then
            task.spawn(function()
                while _G.FastWeight do
                    local char = player.Character
                    if char and not char:FindFirstChild("Weight") then
                        local weightTool = player.Backpack:FindFirstChild("Weight")
                        if weightTool then
                            if weightTool:FindFirstChild("repTime") then
                                weightTool.repTime.Value = 0
                            end
                            char.Humanoid:EquipTool(weightTool)
                        end
                    elseif char and char:FindFirstChild("Weight") then
                        local equipped = char:FindFirstChild("Weight")
                        if equipped:FindFirstChild("repTime") then
                            equipped.repTime.Value = 0
                        end
                    end
                    task.wait(0.1)
                end
            end)

            task.spawn(function()
                while _G.FastWeight do
                    player.muscleEvent:FireServer("rep")
                    task.wait(0)
                end
            end)
        else
            local char = player.Character
            local equipped = char and char:FindFirstChild("Weight")
            if equipped then
                if equipped:FindFirstChild("repTime") then
                    equipped.repTime.Value = 1
                end
                equipped.Parent = player.Backpack
            end
            local backpackTool = player.Backpack:FindFirstChild("Weight")
            if backpackTool and backpackTool:FindFirstChild("repTime") then
                backpackTool.repTime.Value = 1
            end
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local targetCFrame = CFrame.new(-8744.83496, 13.5662804, -5855.75977, -0.705150843, 3.96503417e-08, -0.709057271, -2.71093832e-08, 1, 8.28798292e-08, 0.709057271, 7.76648861e-08, -0.705150843)

local isTeleporting = false
local noclipLoop = nil

local function setNoclip(state)
    if state then
        noclipLoop = RunService.Stepped:Connect(function()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipLoop then
            noclipLoop:Disconnect()
            noclipLoop = nil
        end
    end
end

rebirthTab:Toggle({
    Title = "Teleport To King",
    Desc = "Recomended Size 1",
    Default = false,
    Callback = function(Value)
        isTeleporting = Value
        setNoclip(Value) 
        
        if Value then
            task.spawn(function()
                while isTeleporting do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        root.CFrame = targetCFrame
                    end
                    task.wait(0.1) 
                end
            end)
        end
    end
})

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Character respawned continuing automation...")

    if _G.FastWeight then
        task.spawn(function()
            while _G.FastWeight do
                local c = player.Character
                if c and not c:FindFirstChild("Weight") then
                    local tool = player.Backpack:FindFirstChild("Weight")
                    if tool then
                        c.Humanoid:EquipTool(tool)
                    end
                end
                player.muscleEvent:FireServer("rep")
                task.wait(0.1)
            end
        end)
    end

    if teleportActive then
        task.spawn(function()
            local hrp = char:WaitForChild("HumanoidRootPart")
            while teleportActive do
                if (hrp.Position - targetPosition.Position).Magnitude > 5 then
                    hrp.CFrame = targetPosition
                end
                task.wait(0.05)
            end
        end)
    end
end)

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

_G.afkGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
_G.afkGui.Name = "AntiAFKGui"
_G.afkGui.ResetOnSpawn = true

rebirthTab:Toggle({
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

local Teleport1 = rebirthTab:Section({
    Title = "Teleport To Save Zone",
    Icon = "map"
})

local function safeTeleport(cframe)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then
        root.CFrame = cframe
    end
end

local teleportLocations = {
    {"Save Zone V1", CFrame.new(-16000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V2", CFrame.new(-12000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V3", CFrame.new(-8000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V4", CFrame.new(-4000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V5", CFrame.new(0, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V6", CFrame.new(4000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)},
    {"Save Zone V7", CFrame.new(8000, 12135.4023, -16847.418, -0.999634326, -1.30947875e-09, 0.0270406175, -1.66118291e-12, 1, 4.83649494e-08, -0.0270406175, 4.83472213e-08, -0.999634326)}
}

local activeLoops = {}

for _, location in ipairs(teleportLocations) do
    local locName = location[1]
    local locCFrame = location[2]

    rebirthTab:Toggle({
        Title = locName,
        Desc = "Rebirth Will Always Be Safe",
        Default = false,
        Callback = function(Value)
            activeLoops[locName] = Value
            
            if Value then
                task.spawn(function()
                    while activeLoops[locName] do
                        safeTeleport(locCFrame)
                        task.wait(0.001) 
                    end
                end)
            end
        end
    })
end

local lokasiLantai = {
    {"Object 1", CFrame.new(-16000, 12128, -16847.418)},
    {"Object 2", CFrame.new(-12000, 12128, -16847.418)},
    {"Object 3", CFrame.new(-8000, 12128, -16847.418)},
    {"Object 4", CFrame.new(-4000, 12128, -16847.418)},
    {"Object 5", CFrame.new(0, 12128, -16847.418)},
    {"Object 6", CFrame.new(4000, 12128, -16847.418)},
    {"Object 7", CFrame.new(8000, 12128, -16847.418)}
}

local function buatLantaiLogo(nama, posisi)
    local platform = Instance.new("Part")
    platform.Name = nama
    platform.Size = Vector3.new(20, 0.2, 20)
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 1 
    platform.CastShadow = false
    
    platform.CFrame = posisi
    
    local logo = Instance.new("Decal")
    logo.Texture = "rbxassetid://76676105086715" 
    logo.Face = Enum.NormalId.Top 
    logo.Parent = platform
    
    platform.Parent = workspace
end

for _, data in ipairs(lokasiLantai) do
    buatLantaiLogo(data[1], data[2])
end

local Farmingg = rebirthTab:Section({
    Title = "Upgrade Ultimate V1",
    Icon = "sparkles"
})

local ultimateOptions = {
    "+1 Daily Spin",
    "+1 Pet Slot",
    "+10 Item Capacity",
    "+5% Rep Speed",
    "Demon Damage",
    "Galaxy Gains",
    "Golden Rebirth",
    "Jungle Swift",
    "Muscle Mind",
    "x2 Chest Rewards",
    "Infernal Health",
    "x2 Quest Rewards"
}

local autoBuyAll = false

rebirthTab:Toggle({
    Title = "Upgrade All Ultimates",
    Desc = "Auto Upgrade All Ultimate",
    Default = false,
    Callback = function(state)
        autoBuyAll = state
        if state then
            task.spawn(function()
                while autoBuyAll do
                    for _, ultimate in ipairs(ultimateOptions) do
                        if not autoBuyAll then break end
                        
                        pcall(function()
                            game:GetService("ReplicatedStorage").rEvents.ultimatesRemote:InvokeServer("upgradeUltimate", ultimate)
                        end)
                    end
                    task.wait(1) 
                end
            end)
        end
    end
})

local Farmingg = rebirthTab:Section({
Title = "Upgrade Ultimate V2",
Icon = "sparkles"})

local ultimateSelect = {
    "+1 Daily Spin",
    "+1 Pet Slot",
    "+10 Item Capacity",
    "+5% Rep Speed",
    "Demon Damage",
    "Galaxy Gains",
    "Golden Rebirth",
    "Jungle Swift",
    "Muscle Mind",
    "x2 Chest Rewards",
    "Infernal Health",
    "x2 Quest Rewards"
}

local autoUltimateToggles = {}

for _, ultimate in ipairs(ultimateSelect) do
    autoUltimateToggles[ultimate] = false
    rebirthTab:Toggle({
        Title = "Upgrade " .. ultimate,
        Desc = "Only One Upgrade Ultimate",
        Callback = function(state)
            autoUltimateToggles[ultimate] = state
            if state then
                task.spawn(function()
                    while autoUltimateToggles[ultimate] do
                        pcall(function()
                            ReplicatedStorage.rEvents.ultimatesRemote:InvokeServer("upgradeUltimate", ultimate)
                        end)
                        task.wait(1)
                    end
                end)
            end
        end
    })
end

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

local miscTab = Window:Tab({Title = "Misc", Icon = "settings"})

local miscccFolder = miscTab:Section({
Title = "Players", 
Icon = "user"
})

miscTab:Toggle({
    Title = "Lock Position",
    Value = false,
    Callback = function(state)
        lockCustomPos = state
        if not state then return end

        local lp = game.Players.LocalPlayer
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local lockedCFrame = root.CFrame
        task.spawn(function()
            while lockCustomPos do
                if root and root.Parent then
                    root.CFrame = lockedCFrame
                else
                    root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                end
                task.wait()
            end
        end)
    end
})

local runService = game:GetService("RunService")
local hb

miscTab:Toggle({
    Title = "Anti Knockback",
    Value = false,
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        if state then
            local bv = Instance.new("BodyVelocity", hrp)
            local bg = Instance.new("BodyGyro", hrp)
            bv.Name, bg.Name = "AntiKbBV", "AntiKbBG"
            bg.P, bg.MaxTorque = 10000, Vector3.new(1e7, 1e7, 1e7)
            
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

            hb = runService.Heartbeat:Connect(function()
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.MaxForce = Vector3.new(0, 0, 0)
                    bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + moveDir), 1)
                else
                    bv.MaxForce = Vector3.new(1e7, 0, 1e7)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 1)
                end
            end)
        else
            if hb then hb:Disconnect() end
            if hrp:FindFirstChild("AntiKbBV") then hrp.AntiKbBV:Destroy() end
            if hrp:FindFirstChild("AntiKbBG") then hrp.AntiKbBG:Destroy() end
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        end
    end
})

miscTab:Toggle({
    Title = "Fly Mode",
    Default = false,
    Callback = function(Value)
        _G.FlyEnabled = Value
        
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local desc = hum:WaitForChild("HumanoidDescription")
        local runService = game:GetService("RunService")

        -- Emote Settings
        local emoteIdleName = "GodlikeIdle"
        local emoteIdleId = 3823158750 
        local emoteMoveName = "FlyingMove"
        local emoteMoveId = 106493972274585 

        if _G.FlyEnabled then
            -- SETUP TERBANG
            pcall(function()
                desc:SetEmotes({
                    [emoteIdleName] = {emoteIdleId},
                    [emoteMoveName] = {emoteMoveId}
                })
            end)

            local currentMode = ""
            local function playEmote(name)
                if currentMode == name then return end
                currentMode = name
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then return end

                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                    track:Stop(0.5)
                end

                pcall(function()
                    hum:PlayEmote(name)
                    task.delay(0.05, function()
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                track.Priority = Enum.AnimationPriority.Action4
                                track.Looped = true
                                track:AdjustSpeed(1)
                            end
                        end
                    end)
                end)
            end

            local speed = 70
            local turnSpeed = 0.15

            hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hum:ChangeState(Enum.HumanoidStateType.Physics)

            local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
            bv.Name = "FlyBV"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Parent = hrp

            local bg = hrp:FindFirstChild("FlyBG") or Instance.new("BodyGyro")
            bg.Name = "FlyBG"
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 5000
            bg.Parent = hrp

            task.spawn(function()
                while _G.FlyEnabled and char.Parent do
                    local moveDir = hum.MoveDirection
                    local camera = workspace.CurrentCamera
                    
                    if moveDir.Magnitude > 0 then
                        playEmote(emoteMoveName)
                        local look = camera.CFrame.LookVector
                        local vel = moveDir * speed
                        if moveDir:Dot(Vector3.new(look.X, 0, look.Z).Unit) > 0.8 then
                            vel = look * speed
                        end
                        bv.Velocity = vel
                        bg.CFrame = bg.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + vel), turnSpeed)
                    else
                        playEmote(emoteIdleName)
                        bv.Velocity = Vector3.zero
                        bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector), turnSpeed)
                    end
                    runService.RenderStepped:Wait()
                end

                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                
                local animator = hum:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end
            end)
        else
            _G.FlyEnabled = false
        end
    end
})

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local camera = workspace.CurrentCamera
local renderConnection = nil
local screenGui = nil

local function ToggleFreecam(state)
    if state then
        local MOVE_SPEED = 0.8          
        local ROTATION_SPEED = 1.5      
        local ROTATION_SMOOTHNESS = 0.08 
        local MOVEMENT_SMOOTHNESS = 0.1  
        local targetRotation = Vector2.new(0, 0)
        local currentRotation = Vector2.new(0, 0)
        local velocity = Vector3.new(0, 0, 0)
        local isRightMouseDown = false

        camera.CameraType = Enum.CameraType.Scriptable

        screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.Name = "CinematicFreecamUI"
        screenGui.ResetOnSpawn = false

        local function createBtn(name, parent, pos, text)
            local btn = Instance.new("TextButton", parent)
            btn.Name = name
            btn.Size = UDim2.new(0, 60, 0, 60)
            btn.Position = pos
            btn.Text = text
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 25
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency = 0.5
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Thickness = 2
            stroke.Transparency = 0.5
            return btn
        end

        local moveFrame = Instance.new("Frame", screenGui)
        moveFrame.Size = UDim2.new(0, 200, 0, 200)
        moveFrame.Position = UDim2.new(0, 50, 1, -250)
        moveFrame.BackgroundTransparency = 1

        local rotateFrame = Instance.new("Frame", screenGui)
        rotateFrame.Size = UDim2.new(0, 260, 0, 200)
        rotateFrame.Position = UDim2.new(1, -310, 1, -250)
        rotateFrame.BackgroundTransparency = 1

        local buttons = {
            W = createBtn("Forward", moveFrame, UDim2.new(0, 70, 0, 0), "▲"),
            S = createBtn("Backward", moveFrame, UDim2.new(0, 70, 0, 140), "▼"),
            A = createBtn("Left", moveFrame, UDim2.new(0, 0, 0, 70), "◄"),
            D = createBtn("Right", moveFrame, UDim2.new(0, 140, 0, 70), "►"),
            LookUp = createBtn("LookUp", rotateFrame, UDim2.new(0, 70, 0, 0), "▲"),
            LookDown = createBtn("LookDown", rotateFrame, UDim2.new(0, 70, 0, 140), "▼"),
            LookLeft = createBtn("LookLeft", rotateFrame, UDim2.new(0, 0, 0, 70), "◄"),
            LookRight = createBtn("LookRight", rotateFrame, UDim2.new(0, 140, 0, 70), "►"),
            Up = createBtn("Up", rotateFrame, UDim2.new(0, 210, 0, 35), "N"),
            Down = createBtn("Down", rotateFrame, UDim2.new(0, 210, 0, 105), "T")
        }

        local inputState = {}
        for k, _ in pairs(buttons) do inputState[k] = 0 end

        for key, btn in pairs(buttons) do
            btn.MouseButton1Down:Connect(function() inputState[key] = 1 end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    inputState[key] = 0
                end
            end)
        end

        renderConnection = RunService.RenderStepped:Connect(function(dt)
            local rotDirX = inputState.LookUp - inputState.LookDown
            local rotDirY = inputState.LookLeft - inputState.LookRight
            targetRotation = targetRotation + Vector2.new(rotDirX * ROTATION_SPEED, rotDirY * ROTATION_SPEED)
            currentRotation = currentRotation:Lerp(targetRotation, ROTATION_SMOOTHNESS)
            
            local direction = Vector3.new(inputState.D - inputState.A, inputState.Up - inputState.Down, inputState.S - inputState.W)
            local cameraCFrame = CFrame.Angles(0, math.rad(currentRotation.Y), 0) * CFrame.Angles(math.rad(currentRotation.X), 0, 0)
            local worldDir = cameraCFrame:VectorToWorldSpace(direction)
            velocity = velocity:Lerp(worldDir * MOVE_SPEED, MOVEMENT_SMOOTHNESS)
            camera.CFrame = CFrame.new(camera.CFrame.Position + velocity) * cameraCFrame
        end)
    else
        if renderConnection then renderConnection:Disconnect() renderConnection = nil end
        if screenGui then screenGui:Destroy() screenGui = nil end
        camera.CameraType = Enum.CameraType.Custom
    end
end

miscTab:Toggle({
    Title = "Freecam",
    Default = false,
    Callback = function(Value)
        ToggleFreecam(Value)
    end
})

miscTab:Toggle({
    Title = "No-Clip",
    Callback = function(bool)
        _G.NoClip = bool
        if bool then
            local noclipLoop
            noclipLoop = game:GetService("RunService").Stepped:Connect(function()
                if _G.NoClip then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                else
                    noclipLoop:Disconnect()
                end
            end)
            WindUI:Notify({Title = "No-Clip", Content = "Success Load No-Clip"})
        end
    end
})

miscTab:Toggle({
    Title = "ESP Highlight (Red)",
    Callback = function(bool)
        getgenv().RedESP = bool

        local function applyRedHighlight(targetChar)
            if not targetChar then return end
            
            local existing = targetChar:FindFirstChild("VuzoRedESP")
            if existing then existing:Destroy() end

            local hl = Instance.new("Highlight")
            hl.Name = "VuzoRedESP"
            hl.Parent = targetChar
            -- Warna Fill & Outline diset ke Merah
            hl.FillColor = Color3.fromRGB(255, 0, 0) 
            hl.OutlineColor = Color3.fromRGB(255, 0, 0)
            hl.FillTransparency = 0.5 -- Transparansi isi (0 = Solid, 1 = Transparan)
            hl.OutlineTransparency = 0
        end

        if bool then
            -- Jalankan untuk semua player saat ini
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    applyRedHighlight(p.Character)
                end
                
                p.CharacterAdded:Connect(function(char)
                    if getgenv().RedESP then
                        applyRedHighlight(char)
                    end
                end)
            end

            -- Support untuk player baru join
            _G.RedESPConnection = Players.PlayerAdded:Connect(function(newPlayer)
                newPlayer.CharacterAdded:Connect(function(char)
                    if getgenv().RedESP then
                        applyRedHighlight(char)
                    end
                end)
            end)
        else
            -- Matikan dan bersihkan
            if _G.RedESPConnection then _G.RedESPConnection:Disconnect() end
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("VuzoRedESP") then
                    p.Character.VuzoRedESP:Destroy()
                end
            end
        end
    end
})

local miscccFolder = miscTab:Section({
Title = "Zoom Distance", 
Icon = "radar"
})

local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local zoomAmount = 10000
local zoomActive = false

miscTab:Input({
    Title = "Zoom Distance",
    Default = "10000",
    Numeric = true,
    Callback = function(t)
        zoomAmount = tonumber(t) or 128
        if zoomActive then
            Player.CameraMaxZoomDistance = zoomAmount
        end
    end
})

miscTab:Toggle({
    Title = "Enable Costume Zoom",
    Default = false,
    Callback = function(v)
        zoomActive = v
        if v then
            Player.CameraMaxZoomDistance = zoomAmount
            Camera.FieldOfView = 90
        else
            Player.CameraMaxZoomDistance = 128
            Camera.FieldOfView = 70
        end
    end
})

local miscccFolder = miscTab:Section({
Title = "Visual", 
Icon = "eye"
})

local parts = {}
local partSize = 2048
local totalDistance = 50000
local startPosition = Vector3.new(-2, -9.5, -2)
local numberOfParts = math.ceil(totalDistance / partSize)

local function createParts()
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local newPartSide = Instance.new("Part")
            newPartSide.Size = Vector3.new(partSize, 1, partSize)
            newPartSide.Position = startPosition + Vector3.new(x * partSize, 0, z * partSize)
            newPartSide.Anchored = true
            newPartSide.Transparency = 1
            newPartSide.CanCollide = true
            newPartSide.Name = "Part_Side_" .. x .. "_" .. z
            newPartSide.Parent = workspace
            table.insert(parts, newPartSide)
            
            local newPartLeftRight = Instance.new("Part")
            newPartLeftRight.Size = Vector3.new(partSize, 1, partSize)
            newPartLeftRight.Position = startPosition + Vector3.new(-x * partSize, 0, z * partSize)
            newPartLeftRight.Anchored = true
            newPartLeftRight.Transparency = 1
            newPartLeftRight.CanCollide = true
            newPartLeftRight.Name = "Part_LeftRight_" .. x .. "_" .. z
            newPartLeftRight.Parent = workspace
            table.insert(parts, newPartLeftRight)
            
            local newPartUpLeft = Instance.new("Part")
            newPartUpLeft.Size = Vector3.new(partSize, 1, partSize)
            newPartUpLeft.Position = startPosition + Vector3.new(-x * partSize, 0, -z * partSize)
            newPartUpLeft.Anchored = true
            newPartUpLeft.Transparency = 1
            newPartUpLeft.CanCollide = true
            newPartUpLeft.Name = "Part_UpLeft_" .. x .. "_" .. z
            newPartUpLeft.Parent = workspace
            table.insert(parts, newPartUpLeft)
            
            local newPartUpRight = Instance.new("Part")
            newPartUpRight.Size = Vector3.new(partSize, 1, partSize)
            newPartUpRight.Position = startPosition + Vector3.new(x * partSize, 0, -z * partSize)
            newPartUpRight.Anchored = true
            newPartUpRight.Transparency = 1
            newPartUpRight.CanCollide = true
            newPartUpRight.Name = "Part_UpRight_" .. x .. "_" .. z
            newPartUpRight.Parent = workspace
            table.insert(parts, newPartUpRight)
        end
    end
end

local function makePartsWalkthrough()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = false
        end
    end
end

local function makePartsSolid()
    for _, part in ipairs(parts) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
end

miscTab:Toggle({
    Title = "Walk on Water",
    Callback = function(bool)
        if bool then
            createParts()
        else
            makePartsWalkthrough()
        end
    end
})

miscTab:Toggle({
    Title = "Hide All Players",
    Default = false,
    Callback = function(Value)
        -- Simpan koneksi di global variable agar bisa diakses/dimatikan di dalam callback
        _G.PlayerHideConn = _G.PlayerHideConn or nil

        if Value then
            -- Jalankan Loop Sembunyikan Player
            _G.PlayerHideConn = game:GetService("RunService").RenderStepped:Connect(function()
                for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= game:GetService("Players").LocalPlayer and player.Character then
                        for _, obj in ipairs(player.Character:GetDescendants()) do
                            if obj:IsA("BasePart") or obj:IsA("Decal") then
                                obj.LocalTransparencyModifier = 1
                            elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                                obj.Enabled = false
                            end
                        end
                    end
                end
            end)
        else
            -- Matikan Loop
            if _G.PlayerHideConn then
                _G.PlayerHideConn:Disconnect()
                _G.PlayerHideConn = nil
            end
            
            -- Kembalikan Player ke Normal (Visible)
            for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
                if player.Character then
                    for _, obj in ipairs(player.Character:GetDescendants()) do
                        if obj:IsA("BasePart") or obj:IsA("Decal") then
                            obj.LocalTransparencyModifier = 0
                        elseif obj:IsA("BillboardGui") or obj:IsA("SurfaceGui") then
                            obj.Enabled = true
                        end
                    end
                end
            end
        end
    end
})

miscTab:Toggle({
    Title = "Hide Inventory Pets",
    Callback = function(isOn)
        local player = game:GetService("Players").LocalPlayer
        local petsFolder = player:WaitForChild("petsFolder")
        local storage = game:GetService("ReplicatedStorage"):FindFirstChild("HiddenPets_Storage") 
        if not storage then
            storage = Instance.new("Folder", game:GetService("ReplicatedStorage"))
            storage.Name = "HiddenPets_Storage"
        end

        if isOn then
            local count = 0
            for _, pet in ipairs(petsFolder:GetChildren()) do
                pet.Parent = storage
                count = count + 1
            end
            print("Berhasil menyembunyikan " .. count .. " pet.")
        else
            local count = 0
            for _, pet in ipairs(storage:GetChildren()) do
                pet.Parent = petsFolder
                count = count + 1
            end
            print("Berhasil mengembalikan " .. count .. " pet ke Inventory.")
        end
    end
})

local miscccFolder = miscTab:Section({
Title = "Event Muscle", 
Icon = "sword"
})

miscTab:Toggle({
    Title = "Auto Farm Brawl",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmBrawl = Value
        
        if not Value then
            _G.AutoJoinBrawl = false
            _G.FastPunch = false
            if typeof(activateDomainKiller) == "function" then
                activateDomainKiller(false)
            end
            return
        end

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local brawlEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("brawlEvent")

        local currentRadius = 2000 
        local radiusVisuals = {} 
        local manualWhitelist = {} 
        local auraConnection = nil

        _G.AutoJoinBrawl = true
        _G.FastPunch = false
        _G.DomainTransparent = false
        _G.CombatDuration = 40 

        local function createCircleVisual(radius)
            for _, part in ipairs(radiusVisuals) do part:Destroy() end
            radiusVisuals = {}
            
            local domain = Instance.new("Part")
            domain.Name = "AuraDomain"
            domain.Shape = Enum.PartType.Ball
            domain.Anchored = true
            domain.CanCollide = false
            domain.CastShadow = false 
            domain.Transparency = _G.DomainTransparent and 1 or 0.8
            domain.Material = Enum.Material.ForceField
            domain.Color = Color3.fromRGB(255, 0, 0) 
            domain.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
            domain.Parent = workspace
            table.insert(radiusVisuals, domain)
        end

        local function activateDomainKiller(state)
            if auraConnection then auraConnection:Disconnect() end
            if state then
                createCircleVisual(currentRadius)
                auraConnection = RunService.Heartbeat:Connect(function()
                    local char = LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    local rHand = char and char:FindFirstChild("RightHand")
                    local lHand = char and char:FindFirstChild("LeftHand")

                    if root then
                        if radiusVisuals[1] and radiusVisuals[1].Parent then 
                            radiusVisuals[1].CFrame = root.CFrame 
                        end
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and not manualWhitelist[p.UserId] and p.Character then
                                local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                                local eHum = p.Character:FindFirstChild("Humanoid")
                                if eRoot and eHum and eHum.Health > 0 then
                                    local dist = (eRoot.Position - root.Position).Magnitude
                                    if dist <= currentRadius then
                                        if rHand then firetouchinterest(rHand, eRoot, 1); firetouchinterest(rHand, eRoot, 0) end
                                        if lHand then firetouchinterest(lHand, eRoot, 1); firetouchinterest(lHand, eRoot, 0) end
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                for _, v in ipairs(radiusVisuals) do v:Destroy() end
                radiusVisuals = {}
            end
        end

        local function startFastPunch()
            if _G.FastPunchActive then return end
            _G.FastPunchActive = true
            
            task.spawn(function()
                while _G.FastPunch and _G.AutoFarmBrawl do
                    local char = LocalPlayer.Character
                    local tool = char and char:FindFirstChild("Punch") or LocalPlayer.Backpack:FindFirstChild("Punch")
                    if tool then
                        if tool:FindFirstChild("attackTime") then tool.attackTime.Value = 0 end
                        if not char:FindFirstChild("Punch") and char:FindFirstChild("Humanoid") then
                            char.Humanoid:EquipTool(tool)
                        end
                    end
                    task.wait(0.1)
                end
            end)
            
            task.spawn(function()
                while _G.FastPunch and _G.AutoFarmBrawl do
                    local muscleEvent = LocalPlayer:FindFirstChild("muscleEvent")
                    if muscleEvent then
                        muscleEvent:FireServer("punch", "rightHand")
                        muscleEvent:FireServer("punch", "leftHand")
                    end
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Punch")
                    if tool then tool:Activate() end
                    task.wait(0.05) 
                end
                _G.FastPunchActive = false
            end)
        end

        task.spawn(function()
            local lastPosition = nil
            while _G.AutoFarmBrawl do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if _G.AutoJoinBrawl and root then
                    local currentPos = root.Position
                    if lastPosition then
                        local distance = (currentPos - lastPosition).Magnitude
                        
                        if distance > 200 then
                            _G.AutoJoinBrawl = false 
                            _G.FastPunch = true
                            activateDomainKiller(true) 
                            startFastPunch()
                            
                            task.wait(_G.CombatDuration)
                            
                            _G.FastPunch = false
                            activateDomainKiller(false)
                            _G.AutoJoinBrawl = true
                        end
                    end
                    lastPosition = root.Position
                    brawlEvent:FireServer("joinBrawl")
                end
                task.wait(1) 
            end
        end)
    end
})

miscTab:Toggle({
    Title = "Eat All Snacks",
    Callback = function(state)
        _G.AutoEatAll = state

        if state then
            local player = game:GetService("Players").LocalPlayer
            local muscleEvent = player:WaitForChild("muscleEvent")
            local itemList = { 
                "Tropical Shake", "Energy Shake", "Protein Bar", 
                "TOUGH Bar", "Protein Shake", "ULTRA Shake", "Energy Bar" 
            }

            local function formatEventName(itemName)
                local parts = {}
                for word in itemName:gmatch("%S+") do
                    table.insert(parts, word:lower())
                end
                for i = 2, #parts do
                    parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2)
                end
                return table.concat(parts)
            end

            task.spawn(function()
                while _G.AutoEatAll do
                    for _, itemName in ipairs(itemList) do
                        if not _G.AutoEatAll then break end
                        
                        local character = player.Character
                        if character then
                            local tool = character:FindFirstChild(itemName) or player.Backpack:FindFirstChild(itemName)
                            if tool then
                                local eventName = formatEventName(itemName)
                                muscleEvent:FireServer(eventName, tool)
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

miscTab:Toggle({
    Title = "Auto Spin Wheel",
    Callback = function(bool)
        _G.AutoSpinWheel = bool
        if bool then
            task.spawn(function()
                while _G.AutoSpinWheel do
                    ReplicatedStorage.rEvents.openFortuneWheelRemote:InvokeServer("openFortuneWheel", ReplicatedStorage.fortuneWheelChances["Fortune Wheel"])
                    task.wait(1)
                end
            end)
        end
    end
})

miscTab:Toggle({
    Title = "Auto Claim Gifts",
    Callback = function(bool)
        _G.AutoClaimGifts = bool
        if bool then
            task.spawn(function()
                while _G.AutoClaimGifts do
                    for i = 1, 8 do
                        ReplicatedStorage.rEvents.freeGiftClaimRemote:InvokeServer("claimGift", i)
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local serverTab = Window:Tab({Title = "Server", Icon = "server"})

local serverSection = serverTab:Section({Title = "Server", Icon = "power"})

serverTab:Toggle({
    Title = "Join Low Player",
    Callback = function(bool)
        if bool then
            local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
            module:Teleport(game.PlaceId, "Lowest")
        end
    end
})

serverTab:Button({
    Title = "Rejoin Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, player)
    end
})

serverTab:Button({
    Title = "Delete Portals",
    Callback = function()
        for _, portal in pairs(game:GetDescendants()) do
            if portal.Name == "RobloxForwardPortals" then
                portal:Destroy()
            end
        end
    
        if _G.AdRemovalConnection then
            _G.AdRemovalConnection:Disconnect()
        end
        
        _G.AdRemovalConnection = game.DescendantAdded:Connect(function(descendant)
            if descendant.Name == "RobloxForwardPortals" then
                descendant:Destroy()
            end
        end)
        
        WindUI:Notify({
            Title = "Ads Delete",
            Content = "Portal Ads Delete"
        })
    end
})

serverTab:Button({
    Title = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
 
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd = 9e9
        lighting.Brightness = 0
 
        settings().Rendering.QualityLevel = 1
 
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                if v.Parent and (v.Parent:FindFirstChild("Humanoid") or v.Parent.Parent:FindFirstChild("Humanoid")) then
                else
                    v.Reflectance = 0
                end
            end
        end
 
        for _, v in pairs(lighting:GetChildren()) do
            if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
                v.Enabled = false
            end
        end
 
        WindUI:Notify({
            Title = "Boost",
            Content = "Done Booster FPS"
        })
    end
})

serverTab:Button({
    Title = "Copy Server JobID",
    Callback = function()
        setclipboard(game.JobId)
        WindUI:Notify({Title = "Copied!", Content = "JobID copied to clipboard"})
    end
})

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

WindUI:Notify({
    Title = "ZorVex Hub Loaded",
    Content = "Halo " .. player.DisplayName .. " Vip Features Done",
    Duration = 5
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