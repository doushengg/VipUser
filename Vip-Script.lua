local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local c = Players.LocalPlayer
local displayName = c.DisplayName
local startTime = os.time()
local startRebirths = c.leaderstats.Rebirths.Value
local petsFolder = c:WaitForChild("petsFolder")
local rEvents = ReplicatedStorage:WaitForChild("rEvents")
local tradingEvent = rEvents:WaitForChild("tradingEvent")

local TargetStrength = 0
local selectedPetName = ""
local selectedPlayer = nil
local autoTradeToSelected = false
local autoTradeToAll = false
local PET_COUNT = 6

local function parseInput(text)
    local result = text:lower():gsub(",", "")
    local multiplier = 1
    
    if result:find("k") then 
        multiplier = 1000
    elseif result:find("m") then 
        multiplier = 1000000
    elseif result:find("b") then 
        multiplier = 1000000000
    elseif result:find("t") then 
        multiplier = 1000000000000 
    end
    
    local num = tonumber(result:match("[%d%.]+"))
    return num and (num * multiplier) or 0
end

WindUI:AddTheme({
    Name        = "Light",
    Accent      = "#f4f4f5",
    Dialog      = "#f4f4f5",
    Outline     = "#000000", 
    Text        = "#000000",
    Placeholder = "#666666",
    Background  = "#f0f0f0",
    Button      = "#000000",
    Icon        = "#000000",
})

WindUI:SetNotificationLower(true)

local themes = {"Light"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "<b><font size='26'> V̬uz͠o̵ Zilu͢x</font></b>", 
    Icon = "rbxassetid://106459030518724", 
    Author = "              By ZorVex",
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

Window:SetIconSize(60)
Window:EditOpenButton({ Enabled = false })

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UIBUTTON"
ScreenGui.Parent = game.CoreGui
ScreenGui.IgnoreGuiInset = true 

local ImgBtn = Instance.new("ImageButton")
ImgBtn.Parent = ScreenGui
ImgBtn.Size = UDim2.new(0, 90, 0, 90)
ImgBtn.AnchorPoint = Vector2.new(1, 0) 
ImgBtn.Position = UDim2.new(0.9, -20, 0, 50) 
ImgBtn.BackgroundTransparency = 1
ImgBtn.Image = "rbxassetid://106459030518724" 
ImgBtn.ZIndex = 9999

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = ImgBtn

ImgBtn.MouseButton1Click:Connect(function()
    local shrink = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 70, 0, 70)
    })
    local grow = TweenService:Create(ImgBtn, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 90, 0, 90)
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
    Title = "<font size='20'>  VIP  </font>", 
    Color = Color3.fromHex("#000000")
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local muscleEvent = player:WaitForChild("muscleEvent")

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

local VipUser = farmPlusTab:Section({Title = "Vip Mode", Icon = "gem"})

farmPlusTab:Input({
    Title = "Set Repetition", 
    Placeholder = "Set Fast Strength", 
    Desc = "Need 7 Pet Packs To Work", 
    Callback = function(text)
        local num = tonumber(text) 
        if num then repCount = num end
    end
})

farmPlusTab:Toggle({
    Title = "Push Strength", 
    Desc = "Do Not Use If There Are No Packs", 
    Callback = function(l)
        getgenv().PushStrengthEnabled = l
        if l then
            local equipPet = function(petName) 
                for _, n in pairs(player.petsFolder.Unique:GetChildren()) do 
                    if n.Name == petName then 
                        ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", n) 
                    end 
                end 
            end
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    equipPet("Swift Samurai")
                    for y = 1, (repCount or 1) do 
                        if not getgenv().PushStrengthEnabled then break end 
                        player.muscleEvent:FireServer("rep") 
                    end
                    task.wait()
                end
            end)
        end
    end
})

farmPlusTab:Button({
    Title = "Hide Frames", 
    Desc = "Hide Frame Permanent", 
    Callback = function()
        for _, obj in pairs(ReplicatedStorage:GetChildren()) do 
            if obj.Name:match("Frame$") then 
                obj:Destroy() 
            end 
        end
        WindUI:Notify({Title = "Success", Content = "Frame Hide 100% Fps Boost"})
    end
})  

local VipUserrr = farmPlusTab:Section({Title = "Stop Strength", Icon = "gem"})

farmPlusTab:Input({
    Title = "Target For Strength",
    Desc = "Enter the Strength You Want To Stop",
    Callback = function(text) 
        TargetStrength = parseInput(text) 
    end
})

farmPlusTab:Toggle({
    Title = "Auto Rep Using All tools",
    Desc = "Will Stop When Strength Reaches Target",
    Callback = function(state)
        getgenv().AutoPush = state
        if state then
            task.spawn(function()
                while getgenv().AutoPush do
                    local strength = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Strength")
                    if TargetStrength > 0 and strength and strength.Value >= TargetStrength then
                        getgenv().AutoPush = false
                        break
                    end
                    if player:FindFirstChild("muscleEvent") then 
                        player.muscleEvent:FireServer("rep") 
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

local unlockGp = farmPlusTab:Section({Title = "Farm Tools", Icon = "circle-dollar-sign"})

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
    if char and char:FindFirstChild(toolName) then 
        char[toolName].Parent = player.Backpack 
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
            task.wait(0.3)
        end
    end)
end

local function toggleAnimation(Value)
    if Value then
        local blockedAnimations = {["rbxassetid://3638729053"] = true, ["rbxassetid://3638767427"] = true}
        local function setupAnimationBlocking()
            local char = player.Character 
            local humanoid = char and char:FindFirstChild("Humanoid")
            if not humanoid then return end
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
            _G.ToolConnections = _G.ToolConnections or {}
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
                for _, tool in pairs(container:GetChildren()) do processTool(tool) end
                return container.ChildAdded:Connect(function(tool) task.wait(0.1) processTool(tool) end)
            end
            _G.ToolConnections.Backpack = watchTools(player.Backpack)
            if player.Character then 
                _G.ToolConnections.Character = watchTools(player.Character) 
            end
        end
        setupAnimationBlocking() 
        overrideToolActivation()
        if not _G.AnimMonitorConnection then
            _G.AnimMonitorConnection = RunService.Heartbeat:Connect(function()
                local char = player.Character 
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid and tick() % 0.5 < 0.01 then
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
    else
        if _G.AnimBlockConnection then _G.AnimBlockConnection:Disconnect() _G.AnimBlockConnection = nil end
        if _G.AnimMonitorConnection then _G.AnimMonitorConnection:Disconnect() _G.AnimMonitorConnection = nil end
        if _G.ToolConnections then 
            for _, v in pairs(_G.ToolConnections) do 
                if v.Disconnect then v:Disconnect() end 
            end 
            _G.ToolConnections = nil 
        end
    end
end

local Farmingg = farmPlusTab:Section({Title = "Farm Tools", Icon = "swords"})

player.CharacterAdded:Connect(function()
    task.wait(1.5) 
    local tools = {
        {flag = "AutoWeight", tool = "Weight"}, 
        {flag = "AutoPushups", tool = "Pushups"}, 
        {flag = "AutoHandstands", tool = "Handstands"}, 
        {flag = "AutoSitups", tool = "Situps"}
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
    {"Auto Push Ups", "AutoPushups", "Pushups"}, 
    {"Auto Hand Stands", "AutoHandstands", "Handstands"}, 
    {"Auto Sit Ups", "AutoSitups", "Situps"}
}

for _, tool in ipairs(toolConfigs) do
    farmPlusTab:Toggle({
        Title = tool[1], 
        Desc = "Automatic Farming", 
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
    
    local function updateCombo() 
        local active = state.push or state.sit or state.hand 
        toggleAnimation(active) 
    end
    
    local function punchRock()
        local char = player.Character
        local bp = player:FindFirstChild("Backpack")
        if char and bp and char:FindFirstChild("Humanoid") then
            local punch = bp:FindFirstChild("Punch") or char:FindFirstChild("Punch")
            if punch then
                if punch.Parent == bp then 
                    char.Humanoid:EquipTool(punch) 
                end
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
            if state.push then doRep("Pushups") tryRockTouch() end 
            if state.sit then doRep("Situps") tryRockTouch() end 
            if state.hand then doRep("Handstands") tryRockTouch() end 
            task.wait(0.1) 
        end 
    end)
    
    local cleanTitle = sectionTitle:gsub("Combo ", "")
    
    farmPlusTab:Toggle({
        Title = "Push Ups + "..cleanTitle, 
        Desc = "Perfect Combination With Push Ups", 
        Callback = function(s) 
            state.push = s 
            updateCombo() 
        end
    })
    
    farmPlusTab:Toggle({
        Title = "Sit Ups + "..cleanTitle, 
        Desc = "Perfect Combination With Sit Ups", 
        Callback = function(s) 
            state.sit = s 
            updateCombo() 
        end
    })
    
    farmPlusTab:Toggle({
        Title = "Hand Stands + "..cleanTitle, 
        Desc = "Perfect Combination With Hand Stands", 
        Callback = function(s) 
            state.hand = s 
            updateCombo() 
        end
    })
end

for _, rockData in ipairs(rocks) do 
    createComboSection("Combo " .. rockData[1], rockData[2]) 
end

local player = game.Players.LocalPlayer
local activeRock, curDur, targetCF, selectedEmoteName = nil, 0, nil, nil
local animPlayedConn, toolConns = nil, {}

local rockData = {
    {"Jungle Rock",      10000000, CFrame.new(-7666.7, 6.8, 2831.0, -0.69, 0, -0.72, 0, 1, 0, 0.72, 0, -0.69)},
    {"Muscle King Rock", 5000000,  CFrame.new(-9039.3, 9.2, -6051.5, 0.31, 0, -0.94, 0, 1, 0, 0.94, 0, 0.31)},
    {"Legend Rock",      1000000,  CFrame.new(4146.9, 991.5, -4030.8, 0.98, 0, 0.16, 0, 1, 0, -0.16, 0, 0.98)},
    {"Eternal Rock",     750000,   CFrame.new(-7289.6, 7.6, -1290.4, -0.60, 0, -0.79, 0, 1, 0, 0.79, 0, -0.60)},
    {"Mythical Rock",    400000,   CFrame.new(2181.2, 7.3, 1207.8, -0.99, 0, -0.13, 0, 1, 0, 0.13, 0, -0.99)},
    {"Frozen Rock",      150000,   CFrame.new(-2520.7, 7.9, -218.4, 0.51, 0, 0.85, 0, 1, 0, -0.85, 0, 0.51)},
    {"Golden Rock",      5000,     CFrame.new(302.0, 7.3, -622.9, -0.94, 0, -0.33, 0, 1, 0, 0.33, 0, -0.94)},
    {"Starter Rock",     100,      CFrame.new(158.0, 7.3, -164.0, -0.80, 0, -0.59, 0, 1, 0, 0.59, 0, -0.80)},
    {"Tiny Rock",        0,        CFrame.new(8.4, 4.3, 2101.2, -0.27, 0, -0.96, 0, 1, 0, 0.96, 0, -0.27)}
}

local emoteList = {
    ["God V1"]          = 106493972274585,
    ["Fly Mode"]        = 106493972274585,
    ["Style Arena"]     = 126681258672147,
    ["BlockyKick Dance"] = 97629500912487,
    ["God V2"]          = 81359407734079,
    ["Style Human"]     = 117648669357990,
    ["Boxing"]          = 115203580644128
}

local blockedAnimations = {
    ["rbxassetid://3638729053"] = true,
    ["rbxassetid://3638767427"] = true
}

local function startFastPunch()
    if _G.FastPunchActive then return end
    _G.FastPunchActive = true

    task.spawn(function()
        while _G.FastPunch do
            local char = player.Character
            if char then
                local p = char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
                if p then
                    if p:FindFirstChild("attackTime") then p.attackTime.Value = 0 end
                    if not char:FindFirstChild("Punch") and char:FindFirstChild("Humanoid") then
                        char.Humanoid:EquipTool(p)
                    end
                end
            end
            task.wait(0.0001)
        end
        _G.FastPunchActive = false
    end)

    task.spawn(function()
        while _G.FastPunch do
            local char, ev = player.Character, player:FindFirstChild("muscleEvent")
            if ev then
                ev:FireServer("punch", "rightHand")
                ev:FireServer("punch", "leftHand")
            end
            if char and char:FindFirstChild("Punch") then
                char.Punch:Activate()
            end
            task.wait()
        end
    end)
end

local function stopFastPunch()
    _G.FastPunch = false
    local p1 = player.Character and player.Character:FindFirstChild("Punch")
    local p2 = player.Backpack:FindFirstChild("Punch")
    if p1 and p1:FindFirstChild("attackTime") then p1.attackTime.Value = 0.35 end
    if p2 and p2:FindFirstChild("attackTime") then p2.attackTime.Value = 0.35 end
end

local function applyAgressiveStop()
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    if not hum then return end

    for _, t in pairs(hum:GetPlayingAnimationTracks()) do
        local anim, name = t.Animation, t.Name:lower()
        if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
            t:Stop()
        end
    end

    if not animPlayedConn then
        animPlayedConn = hum.AnimationPlayed:Connect(function(t)
            local anim, name = t.Animation, t.Name:lower()
            if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then
                t:Stop()
            end
        end)
    end
end

local function useTool()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local bp = player:FindFirstChild("Backpack")
    local p = bp and bp:FindFirstChild("Punch") or char and char:FindFirstChild("Punch")

    if hum and p then
        if p.Parent == bp then hum:EquipTool(p) end
        if p:FindFirstChild("attackTime") then p.attackTime.Value = 0.001 end
    end

    local ev = player:FindFirstChild("muscleEvent")
    if ev then
        ev:FireServer("punch", "leftHand")
        ev:FireServer("punch", "rightHand")
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
                t.Priority = Enum.AnimationPriority.Action4
                t.Looped = true
            end
        end)
    end
end

local function startFarm(mode)
    task.spawn(function()
        if mode == 3 then
            applyAgressiveStop()
            playEmote()
            task.wait(0.5)
        end

        if mode == 1 or mode == 2 then
            _G.FastPunch = true
            startFastPunch()
        end

        while (mode == 1 and getgenv().autoFarm) or (mode == 2 and getgenv().autoFarmV2) or (mode == 3 and getgenv().autoFarm) do
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local dur = player:FindFirstChild("Durability")

            if mode == 3 then applyAgressiveStop() end

            if hrp and dur and dur.Value >= curDur then
                if mode == 2 and targetCF then
                    hrp.CFrame = targetCF
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end

                for _, obj in pairs(workspace.machinesFolder:GetDescendants()) do
                    if obj.Name == "neededDurability" and obj.Value == curDur then
                        local rock = obj.Parent:FindFirstChild("Rock")
                        local lh = char:FindFirstChild("LeftHand")
                        local rh = char:FindFirstChild("RightHand")

                        if rock and rh then
                            firetouchinterest(rock, rh, 0)
                            firetouchinterest(rock, rh, 1)
                            if mode ~= 3 and lh then
                                firetouchinterest(rock, lh, 0)
                                firetouchinterest(rock, lh, 1)
                            end
                            useTool()
                        end
                        break
                    end
                end
            end
            task.wait(mode == 1 and 0.001 or 0.05)
        end

        if mode == 3 then
            if animPlayedConn then
                animPlayedConn:Disconnect()
                animPlayedConn = nil
            end
        end
        stopFastPunch()
    end)
end

local farmTab = Window:Tab({Title = "Rock Farm", Icon = "shield-check"})

farmTab:Section({Title = "Ghost Rock", Icon = "ghost"})
for _, r in ipairs(rockData) do
    farmTab:Toggle({
        Title = "Ghost " .. r[1],
        Desc = "Farming Rock Without Touching",
        Callback = function(v)
            activeRock, curDur, getgenv().autoFarm = r[1], r[2], v
            if v then startFarm(1) else stopFastPunch() end
        end
    })
end

farmTab:Section({Title = "Teleport Rock", Icon = "map-pin"})
for _, r in ipairs(rockData) do
    farmTab:Toggle({
        Title = "TP " .. r[1],
        Desc = "Farming Rock With Teleport Op",
        Callback = function(v)
            activeRock, curDur, targetCF, getgenv().autoFarmV2 = r[1], r[2], r[3], v
            if v then startFarm(2) else stopFastPunch() end
        end
    })
end

farmTab:Section({Title = "Emote Rock", Icon = "sparkles"})
farmTab:Dropdown({
    Title = "Select Emote",
    Values = {"God V1", "Fly Mode", "Style Arena", "BlockyKick Dance", "God V2", "Style Human", "Boxing"},
    Desc = "Select the Emote You Like",
    Callback = function(v)
        selectedEmoteName = v
    end
})

for _, r in ipairs(rockData) do
    farmTab:Toggle({
        Title = "Emote " .. r[1],
        Desc = "Farming Rock With Cool Style",
        Callback = function(v)
            if v and not selectedEmoteName then
                WindUI:Notify({Title = "Peringatan", Content = "Pilih Emote!", Duration = 3})
                return
            end
            activeRock, curDur, getgenv().autoFarm = r[1], r[2], v
            if v then
                startFarm(3)
            else
                if animPlayedConn then
                    animPlayedConn:Disconnect()
                    animPlayedConn = nil
                end
            end
        end
    })
end

game:GetService("RunService").Heartbeat:Connect(function()
    if getgenv().autoFarm and activeRock and animPlayedConn then
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum and tick() % 0.5 < 0.02 then
            for _, t in pairs(hum:GetPlayingAnimationTracks()) do
                if t.Animation and (blockedAnimations[t.Animation.AnimationId] or t.Name:lower():match("punch")) then
                    t:Stop()
                end
            end
        end
    end
end)

local Player = game.Players.LocalPlayer

local function pressE()
    VirtualInputManager:SendKeyEvent(true, "E", false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, "E", false, game)
end

getgenv().working = false

local function autoLift()
    while getgenv().working do
        Player.muscleEvent:FireServer("rep")
        task.wait(0.3) 
    end
end

local function teleportAndStart(machineName, position)
    local Character = Player.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
        for i = 1, 9 do 
            Character.HumanoidRootPart.CFrame = position
            task.wait(0.01)
            pressE()
            task.spawn(autoLift) 
        end 
    end
end

local function CreateGymToggle(parent, title, name, pos)
    parent:Toggle({
        Title = title,
        Desc = "Auto Teleport To Your Destination Effortlessly",
        Callback = function(bool)
            if getgenv().working and not bool then 
                getgenv().working = false 
                return 
            end
            getgenv().working = bool
            if bool then 
                teleportAndStart(name, pos) 
            end
        end
    })
end

local function CreateTreadmillToggle(parent, title, size, pos)
    parent:Toggle({
        Title = title,
        Desc = "Automatic Treadmill Running Without Hassle",
        Default = false,
        Callback = function(bool)
            _G.AutoTreadmillActive = bool
            local Character = Player.Character or Player.CharacterAdded:Wait()
            local Humanoid = Character:WaitForChild("Humanoid")
            local RootPart = Character:WaitForChild("HumanoidRootPart")
            
            if bool then
                task.spawn(function()
                    local Events = ReplicatedStorage:FindFirstChild("rEvents")
                    if Events and Events:FindFirstChild("changeSpeedSizeRemote") then 
                        Events.changeSpeedSizeRemote:InvokeServer("changeSize", size) 
                    end
                end)
                task.wait(0.3)
                RootPart.CFrame = pos
                _G.LockedCFrame = pos
                task.spawn(function()
                    while _G.AutoTreadmillActive and Character and Humanoid and RootPart do
                        RootPart.Velocity = Vector3.new(0, 0, 0)
                        RootPart.CFrame = _G.LockedCFrame
                        Humanoid:Move(Vector3.new(0, 0, -1), true)
                        task.wait()
                    end
                end)
            else
                _G.LockedCFrame = nil
                if Humanoid then Humanoid:Move(Vector3.new(0, 0, 0), true) end
                if RootPart then RootPart.Velocity = Vector3.new(0, 0, 0) end
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

local player = Players.LocalPlayer
local petsFolder = player:WaitForChild("petsFolder")

local petList = {
    "[🟡--UNIQUE--🟡]", "Neon Guardian", "Muscle Sensei", "Gold Warrior", "Cool Guy Larry", "Hank", "Sky Hawk", 
    "Cybernetic Showdown Dragon", "Darkstar Hunter", "Ultra Birdie", "Magic Butterfly", "Infernal Dragon", 
    "[🟣--EPIC--🟣]", "Golden Viking", "Lightning Strike Phantom", "Phantom Genesis Dragon", "White Pheonix", 
    "Golden Pheonix", "Red Firecaster", "Green Firecaster", "Blue Firecaster", "Blue Phoenix", 
    "[🔵--RARE--🔵]", "Eternal Strike Leviathan", "White Pegasus", "Purple Falcon", "Red Dragon", 
    "Dark Legends Manticore", "Orange Pegasus", "Purple Dragon", "Crimson Falcon", 
    "[🟢--COMMON--🟢]", "Yellow Butterfly", "Green Butterfly", "Dark Golem", "Dark Vampy", "Silver Dog", 
    "Blue Bunny", "Blue Birdie", "Red Kitty", "Orange Hedgehog"
}

local petOptions = {
    "[🟡--UNIQUE--🟡]", "Neon Guardian", "Muscle Sensei", "Cybernetic Showdown Dragon", "Darkstar Hunter", 
    "Ultra Birdie", "Magic Butterfly", "Infernal Dragon", "[🟣--EPIC--🟣]", "Golden Viking", 
    "Lightning Strike Phantom", "Dark Legends Manticore", "White Pheonix", "Golden Pheonix", 
    "Red Firecaster", "Green Firecaster", "Blue Firecaster", "Blue Phoenix", "[🔵--RARE--🔵]", 
    "Eternal Strike Leviathan", "White Pegasus", "Purple Falcon", "Red Dragon", "Phantom Genesis Dragon", 
    "Orange Pegasus", "Purple Dragon", "Crimson Falcon", "[🟢--COMMON--🟢]", "Yellow Butterfly", 
    "Green Butterfly", "Dark Golem", "Dark Vampy", "Silver Dog", "Blue Bunny", "Blue Birdie", 
    "Red Kitty", "Orange Hedgehog"
}

local petPacksList = {"[ ☠️--PET PACKS--☠️ ]", "Tribal Overlord", "Swift Samurai", "Mighty Monster", "Wild Wizard"}
local crystalNames = {"Blue Crystal", "Green Crystal", "Frozen Crystal", "Mythical Crystal", "Inferno Crystal", "Legends Crystal", "Muscle Elite Crystal", "Galaxy Oracle Crystal", "Sky Eclipse Crystal", "Jungle Crystal"}

local crystalLocations = {
    ["Blue Crystal"]         = CFrame.new(146.02, 13.71, 442.12, -0.99, 0, 0, 0, 1, 0, 0, 0, -0.99),
    ["Green Crystal"]        = CFrame.new(401.80, 12.89, -199.83, -0.99, 0, -0.03, 0, 1, 0, 0.03, 0, -0.99),
    ["Frozen Crystal"]       = CFrame.new(-2826.17, 12.44, -136.56, -0.99, 0, -0.001, 0, 1, 0, 0.001, 0, -0.99),
    ["Mythical Crystal"]     = CFrame.new(2740.39, 12.46, 1160.81, -0.009, 0, -0.99, 0, 1, 0, 0.99, 0, -0.009),
    ["Inferno Crystal"]      = CFrame.new(-6896.38, 11.78, -1544.02, 0.99, 0, -0.03, 0, 1, 0, 0.03, 0, 0.99),
    ["Legends Crystal"]      = CFrame.new(4089.46, 1001.05, -3561.76, -0.76, 0, 0.63, 0, 1, 0, -0.63, 0, -0.76),
    ["Muscle Elite Crystal"] = CFrame.new(0, 10, 0),
    ["Galaxy Oracle Crystal"] = CFrame.new(-9025.96, 27.11, -5866.43, 0, 0, 1, 0, 1, 0, -1, 0, 0),
    ["Sky Eclipse Crystal"]  = CFrame.new(0, 10, 0),
    ["Jungle Crystal"]       = CFrame.new(-7521.36, 19.35, 2394.26, -0.01, 0, -0.99, 0, 1, 0, 0.99, 0, -0.01)
}

local selectedCrystal = "Galaxy Oracle Crystal"
local autoCrystalRunning = false
local selectedPack = ""
local currentSelectedPet = ""
local selectedPetName = ""
local selectedPlayer = nil
local autoTradeToSelected = false
local autoTradeToAll = false
local PET_COUNT = 6

local function autoOpenCrystal()
    while autoCrystalRunning do
        local r = ReplicatedStorage:FindFirstChild("rEvents")
        if r and r:FindFirstChild("openCrystalRemote") then
            pcall(function()
                r.openCrystalRemote:InvokeServer("openCrystal", selectedCrystal)
            end)
        end
        task.wait(0.1)
    end
end

local function getPlayerDisplay(plr)
    return (plr.DisplayName and plr.DisplayName ~= "") and plr.DisplayName or plr.Name
end

local function buildPlayerDisplayList()
    local l = {}
    if not player then return {"None"} end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player then
            table.insert(l, getPlayerDisplay(p))
        end
    end
    if #l == 0 then table.insert(l, "None") end
    return l
end

local function getPetInstances(petName, n)
    local pets = {}
    if not player then return pets end
    local pf = player:FindFirstChild("petsFolder")
    if pf then
        for _, f in ipairs(pf:GetChildren()) do
            if f:IsA("Folder") then
                for _, p in ipairs(f:GetChildren()) do
                    if p.Name == petName then
                        table.insert(pets, p)
                        if #pets >= n then return pets end
                    end
                end
            end
        end
    end
    return pets
end

local function isTradePending()
    return player and player:FindFirstChild("CurrentTrade") ~= nil
end

local function isTradeAccepted()
    if not player then return false end
    local ct = player:FindFirstChild("CurrentTrade")
    return ct and ct:FindFirstChild("Accepted") and ct.Accepted.Value or false
end

local function mainTradeLoop()
    while true do
        if autoTradeToSelected and selectedPetName and selectedPlayer and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            if #pets > 0 then
                pcall(function() tradingEvent:FireServer("sendTradeRequest", selectedPlayer) end)
                task.wait(0.2)
                for _, p in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", p) end)
                    task.wait(0.01)
                end
                if not isTradeAccepted() then
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(0.01)
            end
        end

        if autoTradeToAll and selectedPetName and not isTradePending() then
            local pets = getPetInstances(selectedPetName, PET_COUNT)
            if #pets > 0 then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player then
                        pcall(function() tradingEvent:FireServer("sendTradeRequest", plr) end)
                        task.wait(0.2)
                    end
                end
                for _, p in ipairs(pets) do
                    pcall(function() tradingEvent:FireServer("offerItem", p) end)
                    task.wait()
                end
                if not isTradeAccepted() then
                    pcall(function() tradingEvent:FireServer("confirmTrade") end)
                    pcall(function() tradingEvent:FireServer("acceptTrade") end)
                end
                task.wait(0.01)
            end
        end

        local ct = player:FindFirstChild("CurrentTrade")
        if ct then
            pcall(function() tradingEvent:FireServer("acceptTrade") end)
            task.wait(0.01)
            local ti
            local ts = tick()
            repeat
                task.wait()
                ti = ct:FindFirstChild("OfferedItems")
            until (ti and #ti:GetChildren() > 0) or (tick() - ts > 8)
            pcall(function() tradingEvent:FireServer("confirmTrade") end)
            pcall(function() tradingEvent:FireServer("acceptTrade") end)
        end
        task.wait()
    end
end

local Crystal = Window:Tab({Title = "Crystal", Icon = "gem"})

local crystalSection = Crystal:Section({Title = "Pet Packs", Icon = "skull"})

Crystal:Dropdown({
    Title = "Select Pet Pack",
    Desc = "Only Available for Those Who Have Packs",
    Values = petPacksList,
    Callback = function(v) 
        selectedPack = v 
    end
})

Crystal:Button({
    Title = "Equip Pet Pack",
    Desc = "Using Pet Packs Automatically",
    Callback = function()
        if selectedPack == "" then
            WindUI:Notify({Title = "Error", Content = "Silahkan pilih pet pack terlebih dahulu!", Duration = 3})
            return
        end
        for _, f in pairs(petsFolder:GetChildren()) do
            if f:IsA("Folder") then
                for _, p in pairs(f:GetChildren()) do
                    rEvents.equipPetEvent:FireServer("unequipPet", p)
                end
            end
        end
        task.wait(0.3)
        local tf = petsFolder:FindFirstChild("Unique")
        if tf then
            local found = false
            for _, p in pairs(tf:GetChildren()) do
                if p.Name == selectedPack then
                    rEvents.equipPetEvent:FireServer("equipPet", p)
                    found = true
                end
            end
            if found then
                WindUI:Notify({Title = "Success", Content = "Berhasil memasang pet: " .. selectedPack, Duration = 3})
            else
                WindUI:Notify({Title = "Not Found", Content = "Kamu tidak memiliki pet: " .. selectedPack, Duration = 3})
            end
        end
    end
})

local crystalSectionAll = Crystal:Section({Title = "Auto All Pet", Icon = "gitlab"})

Crystal:Dropdown({
    Title = "Select Pet",
    Values = petOptions,
    Callback = function(v) 
        currentSelectedPet = v 
    end
})

Crystal:Button({
    Title = "Equip Selected Pet",
    Desc = "Using The Selected Pet",
    Callback = function()
        if currentSelectedPet ~= "" then
            for _, f in pairs(petsFolder:GetChildren()) do
                if f:IsA("Folder") then
                    for _, p in pairs(f:GetChildren()) do
                        rEvents.equipPetEvent:FireServer("unequipPet", p)
                    end
                end
            end
            task.wait(0.3)
            for _, f in pairs(petsFolder:GetChildren()) do
                if f:IsA("Folder") then
                    for _, p in pairs(f:GetChildren()) do
                        if p.Name == currentSelectedPet then
                            rEvents.equipPetEvent:FireServer("equipPet", p)
                        end
                    end
                end
            end
        end
    end
})

Crystal:Button({
    Title = "Unequip All Pets",
    Desc = "Unequip All Used Pets",
    Callback = function()
        for _, f in pairs(petsFolder:GetChildren()) do
            if f:IsA("Folder") then
                for _, p in pairs(f:GetChildren()) do
                    rEvents.equipPetEvent:FireServer("unequipPet", p)
                end
            end
        end
    end
})

Crystal:Toggle({
    Title = "Auto Buy Pet",
    Desc = "Buy the Pet You Want",
    Callback = function(s)
        getgenv().AutoBuy = s
        task.spawn(function()
            while getgenv().AutoBuy do
                if currentSelectedPet ~= "" then
                    local po = ReplicatedStorage.cPetShopFolder:FindFirstChild(currentSelectedPet)
                    if po then
                        ReplicatedStorage.cPetShopRemote:InvokeServer(po)
                    end
                end
                task.wait()
            end
        end)
    end
})

Crystal:Toggle({
    Title = "Auto Evolve Pet",
    Desc = "Evolve All Selected Pets",
    Callback = function(s)
        getgenv().AutoEvolve = s
        task.spawn(function()
            while getgenv().AutoEvolve do
                if currentSelectedPet ~= "" then
                    rEvents.petEvolveEvent:FireServer("evolvePet", currentSelectedPet)
                end
                task.wait()
            end
        end)
    end
})

local TradeTab = Crystal:Section({Title = "Auto Trade", Icon = "refresh-cw"})

Crystal:Dropdown({
    Title = "Select Pet",
    Desc = "Select The Pet You Will Trade",
    Values = petList,
    Value = selectedPetName,
    Callback = function(p) 
        selectedPetName = p 
    end
})

Crystal:Dropdown({
    Title = "Select Player",
    Desc = "Select The Player You Want To Trade Pets With",
    Values = buildPlayerDisplayList(),
    Callback = function(sd)
        selectedPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and getPlayerDisplay(p) == sd then
                selectedPlayer = p
                break
            end
        end
    end
})

Crystal:Toggle({
    Title = "Trade Select Player",
    Desc = "Instant Auto Trade",
    Callback = function(s) 
        autoTradeToSelected = s 
    end
})

Crystal:Toggle({
    Title = "Trade All Player",
    Desc = "Trade To All Players Automatically",
    Callback = function(s) 
        autoTradeToAll = s 
    end
})

task.spawn(mainTradeLoop)

local crystalOpenSection = Crystal:Section({Title = "Open Crystal", Icon = "gem"})

Crystal:Dropdown({
    Title = "Select Crystal",
    Desc = "Select the Crystal You Want to Open",
    Values = crystalNames,
    Value = selectedCrystal,
    Callback = function(t) 
        selectedCrystal = t 
    end
})

Crystal:Toggle({
    Title = "Auto Crystal",
    Desc = "Auto Open Crystal Your Selected",
    Callback = function(s)
        autoCrystalRunning = s
        if autoCrystalRunning then
            task.spawn(autoOpenCrystal)
        end
    end
})

Crystal:Button({
    Title = "Teleport To Crystal",
    Desc = "Towards Where Crystal Is",
    Callback = function()
        local tp = crystalLocations[selectedCrystal]
        if tp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = tp
        else
            warn("Lokasi tidak ditemukan atau Karakter belum load.")
        end
    end
})

local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local killTargets = {}
local radiusVisuals = {}
local manualWhitelist = {}
local currentRadius = 50
local runAura = false
local spyingEnabled = false
local autoKillEnabled = false
local tpToTargetEnabled = false
local whitelistedPlayer = ""

local function getDisplayList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do 
        if p ~= lp then 
            table.insert(list, p.DisplayName .. "  [ " .. p.Name .. " ]") 
        end 
    end
    return list
end

local function getName(text) 
    return text and text:match("%[%s*(.-)%s*%]$") 
end

local function handleFastPunch(state)
    _G.FastPunch = state
    if state then
        task.spawn(function()
            while _G.FastPunch do
                local char = lp.Character
                local punch = char and (char:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch"))
                local muscleEvent = lp:FindFirstChild("muscleEvent")
                
                if punch then
                    if punch:FindFirstChild("attackTime") then 
                        punch.attackTime.Value = 0 
                    end
                    if punch.Parent ~= char and char:FindFirstChild("Humanoid") then 
                        char.Humanoid:EquipTool(punch) 
                    end
                    punch:Activate()
                end
                
                if muscleEvent then 
                    muscleEvent:FireServer("punch", "rightHand") 
                    muscleEvent:FireServer("punch", "leftHand") 
                end
                task.wait()
            end
        end)
    else
        local punch = lp.Character and lp.Character:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
        if punch and punch:FindFirstChild("attackTime") then 
            punch.attackTime.Value = 0.35 
        end
    end
end

local function handleRemoveAnimation(state)
    local blockedAnimations = {["rbxassetid://3638729053"] = true, ["rbxassetid://3638767427"] = true}
    if state then
        local function stopAnims()
            local char = lp.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    local anim, name = track.Animation, track.Name:lower()
                    if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then 
                        track:Stop() 
                    end
                end
            end
        end
        _G.AnimMonitorConnection = RunService.Heartbeat:Connect(function()
            stopAnims()
            local char = lp.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid and not _G.AnimBlockConnection then
                _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(track)
                    local anim, name = track.Animation, track.Name:lower()
                    if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then 
                        track:Stop() 
                    end
                end)
            end
        end)
    else
        if _G.AnimMonitorConnection then _G.AnimMonitorConnection:Disconnect() _G.AnimMonitorConnection = nil end
        if _G.AnimBlockConnection then _G.AnimBlockConnection:Disconnect() _G.AnimBlockConnection = nil end
    end
end

local function updateVisual(radius)
    for _, v in ipairs(radiusVisuals) do v:Destroy() end
    radiusVisuals = {}
    
    local d = Instance.new("Part", workspace)
    d.Name = "AuraDomain"
    d.Shape = Enum.PartType.Ball
    d.Anchored = true
    d.CanCollide = false
    d.CastShadow = false
    d.Transparency = (_G.DomainTransparent and 1 or 0.7)
    d.Material = Enum.Material.ForceField
    d.Color = Color3.new(0, 0, 0)
    d.Size = Vector3.new(radius * 2, radius * 2, radius * 2)
    radiusVisuals[1] = d
end

local KillSelect = Window:Tab({Title = "Killer", Icon = "locate-fixed"})

local KillerV1 = KillSelect:Section({Title = "Animation", Icon = "omega"})

KillSelect:Button({
    Title = "Remove Attack Animations", 
    Desc = "Remove Punch Animation to Make it Cool",
    Callback = function()
        local blockedAnimations = {["rbxassetid://3638729053"] = true, ["rbxassetid://3638767427"] = true}
        
        local function setupAnimationBlocking()
            local char = lp.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                local anim, name = track.Animation, track.Name:lower()
                if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then 
                    track:Stop() 
                end
            end
            
            if not _G.AnimBlockConnection then
                _G.AnimBlockConnection = humanoid.AnimationPlayed:Connect(function(track)
                    local anim, name = track.Animation, track.Name:lower()
                    if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then 
                        track:Stop() 
                    end
                end)
            end
        end

        local function overrideToolActivation()
            _G.ToolConnections = _G.ToolConnections or {}
            local function processTool(tool)
                if tool and (tool.Name == "Punch" or tool.Name:match("Attack") or tool.Name:match("Right")) and not tool:GetAttribute("ActivatedOverride") then
                    tool:SetAttribute("ActivatedOverride", true)
                    _G.ToolConnections[tool] = tool.Activated:Connect(function()
                        task.wait(0.05)
                        local humanoid = lp.Character and lp.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                                local anim, name = track.Animation, track.Name:lower()
                                if anim and (blockedAnimations[anim.AnimationId] or name:match("punch") or name:match("attack") or name:match("right")) then 
                                    track:Stop() 
                                end
                            end
                        end
                    end)
                end
            end
            
            local function watchTools(container)
                for _, tool in pairs(container:GetChildren()) do processTool(tool) end
                return container.ChildAdded:Connect(function(tool) task.wait(0.1) processTool(tool) end)
            end
            
            _G.ToolConnections.Backpack = watchTools(lp.Backpack)
            if lp.Character then 
                _G.ToolConnections.Character = watchTools(lp.Character) 
            end
        end

        setupAnimationBlocking() 
        overrideToolActivation()

        if not _G.AnimMonitorConnection then
            _G.AnimMonitorConnection = RunService.Heartbeat:Connect(function()
                local char = lp.Character
                local humanoid = char and char:FindFirstChild("Humanoid")
                if humanoid and tick() % 0.5 < 0.01 then
                    for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                        local anim, name = track.Animation, track.Name:lower()
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
    Desc = "Punch Very Fast",
    Callback = function(bool)
        _G.FastPunch = bool
        if bool then
            task.spawn(function()
                while _G.FastPunch do
                    local character = lp.Character
                    if character then
                        local punch = character:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
                        if punch then
                            if punch:FindFirstChild("attackTime") then punch.attackTime.Value = 0 end
                            if punch.Parent ~= character and character:FindFirstChild("Humanoid") then 
                                character.Humanoid:EquipTool(punch) 
                            end
                            punch:Activate()
                        end
                    end
                    task.wait()
                end
            end)
            task.spawn(function()
                while _G.FastPunch do
                    local muscleEvent = lp:FindFirstChild("muscleEvent") or ReplicatedStorage:FindFirstChild("muscleEvent")
                    if muscleEvent then
                        muscleEvent:FireServer("punch", "rightHand")
                        muscleEvent:FireServer("punch", "leftHand")
                    end
                    task.wait() 
                end
            end)
        else
            local punch = lp.Character:FindFirstChild("Punch") or lp.Backpack:FindFirstChild("Punch")
            if punch and punch:FindFirstChild("attackTime") then 
                punch.attackTime.Value = 0.35 
            end
        end
    end
})

KillSelect:Section({Title = "Auto Killer", Icon = "skull"})

local whitelistDropdown = KillSelect:Dropdown({
    Title = "Whitelist Player", 
    Desc = "Players Who Are Safe From Kill All", 
    Values = getDisplayList(), 
    Callback = function(v) 
        whitelistedPlayer = getName(v) 
    end
})

KillSelect:Button({
    Title = "Refresh Whitelist", 
    Icon = "refresh-cw", 
    Callback = function() 
        whitelistDropdown:Refresh(getDisplayList()) 
    end
})

KillSelect:Toggle({
    Title = "Auto Kill All Players", 
    Desc = "Kill All Players On The Server",
    Callback = function(bool)
        _G.GhostKill = bool
        handleFastPunch(bool)
        
        task.spawn(function()
            while _G.GhostKill do
                local char = lp.Character
                local rh = char and char:FindFirstChild("RightHand")
                local lh = char and char:FindFirstChild("LeftHand")
                
                if rh or lh then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= lp and target.Name ~= whitelistedPlayer and target.Character then
                            local trp = target.Character:FindFirstChild("HumanoidRootPart")
                            local hum = target.Character:FindFirstChild("Humanoid")
                            
                            if trp and hum and hum.Health > 0 and not target.Character:FindFirstChildOfClass("ForceField") then
                                if rh then
                                    local oldRH = rh.CFrame
                                    rh.CFrame = trp.CFrame
                                    for i = 1, 10 do
                                        firetouchinterest(rh, trp, 1)
                                        firetouchinterest(rh, trp, 0)
                                    end
                                    rh.CFrame = oldRH
                                end
                                
                                if lh then
                                    local oldLH = lh.CFrame
                                    lh.CFrame = trp.CFrame
                                    for i = 1, 10 do
                                        firetouchinterest(lh, trp, 1)
                                        firetouchinterest(lh, trp, 0)
                                    end
                                    lh.CFrame = oldLH
                                end
                            end
                        end
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end
})

KillSelect:Toggle({
    Title = "Auto Good Karma", 
    Desc = "Kill Players Who Have Good Karma",
    Callback = function(bool)
        autoGoodKarma = bool 
        handleFastPunch(bool)
        task.spawn(function()
            while autoGoodKarma do
                local char = lp.Character
                local rh, lh = char and char:FindFirstChild("RightHand"), char and char:FindFirstChild("LeftHand")
                if char and rh and lh then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= lp then
                            local evil, good = target:FindFirstChild("evilKarma"), target:FindFirstChild("goodKarma")
                            if evil and good and evil.Value > good.Value then
                                local trp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if trp then 
                                    firetouchinterest(rh, trp, 1) 
                                    firetouchinterest(rh, trp, 0) 
                                    firetouchinterest(lh, trp, 1) 
                                    firetouchinterest(lh, trp, 0) 
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
    Desc = "Kill Players Who Have Evil Karma",
    Callback = function(bool)
        autoEvilKarma = bool 
        handleFastPunch(bool)
        task.spawn(function()
            while autoEvilKarma do
                local char = lp.Character
                local rh, lh = char and char:FindFirstChild("RightHand"), char and char:FindFirstChild("LeftHand")
                if char and rh and lh then
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= lp then
                            local evil, good = target:FindFirstChild("evilKarma"), target:FindFirstChild("goodKarma")
                            if evil and good and good.Value > evil.Value then
                                local trp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                                if trp then 
                                    firetouchinterest(rh, trp, 1) 
                                    firetouchinterest(rh, trp, 0) 
                                    firetouchinterest(lh, trp, 1) 
                                    firetouchinterest(lh, trp, 0) 
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

KillSelect:Section({Title = "Player Target", Icon = "crosshair"})

local spyDropdown = KillSelect:Dropdown({
    Title = "Spectate Player", 
    Desc = "Select The Player You Want To View", 
    Values = getDisplayList(), 
    Callback = function(v) 
        selectedSpyName = getName(v) 
    end
})

KillSelect:Button({
    Title = "Refresh Spectate List", 
    Icon = "refresh-cw", 
    Callback = function() 
        spyDropdown:Refresh(getDisplayList()) 
    end
})

KillSelect:Toggle({
    Title = "Spectate Player", 
    Desc = "Viewing Players Remotely",
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
    Desc = "Select The Player You Want To Kill", 
    Values = getDisplayList(), 
    Callback = function(v) 
        killTargets = {getName(v)} 
    end
})

KillSelect:Button({
    Title = "Refresh Player Target", 
    Icon = "refresh-cw", 
    Callback = function() 
        targetDropdown:Refresh(getDisplayList()) 
    end
})

KillSelect:Toggle({
    Title = "Kill Target", 
    Desc = "Kill The Player You Select Personally",
    Callback = function(v)
        autoKillEnabled = v 
        handleFastPunch(v)
        task.spawn(function()
            while autoKillEnabled do
                local char = lp.Character
                if char and #killTargets > 0 then
                    local t = Players:FindFirstChild(killTargets[1])
                    local hrp = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
                    local rh, lh = char:FindFirstChild("RightHand"), char:FindFirstChild("LeftHand")
                    if hrp and rh and lh then 
                        firetouchinterest(rh, hrp, 1) 
                        firetouchinterest(rh, hrp, 0) 
                        firetouchinterest(lh, hrp, 1) 
                        firetouchinterest(lh, hrp, 0) 
                    end
                end
                task.wait(0.05)
            end
        end)
    end
})

KillSelect:Toggle({
    Title = "Bring Target", 
    Desc = "The Target Will Teleport To You",
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

KillSelect:Section({Title = "Teleport Player", Icon = "map-pin-plus-inside"})

local tpDropdown = KillSelect:Dropdown({
    Title = "Select Teleport Target", 
    Desc = "Select The Player You Want To Teleport", 
    Values = getDisplayList(), 
    Callback = function(v) 
        selectedTpName = getName(v) 
    end
})

KillSelect:Button({
    Title = "Refresh TP List", 
    Icon = "refresh-cw", 
    Callback = function() 
        tpDropdown:Refresh(getDisplayList()) 
    end
})

KillSelect:Toggle({
    Title = "Teleport to Player", 
    Desc = "Teleport To The Player Chosen By You",
    Callback = function(v)
        tpToTargetEnabled = v
        while tpToTargetEnabled do
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            local t = selectedTpName and Players:FindFirstChild(selectedTpName)
            local thrp = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
            if hrp and thrp then 
                hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, 3) 
            end
            task.wait(0.1)
        end
    end
})

KillSelect:Section({Title = "Domain Killer", Icon = "rotate-3d"})

KillSelect:Input({
    Title = "Set Domain Size", 
    Placeholder = "Size...", 
    Desc = "Set Domain Size According to Your Wishes", 
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
    Callback = function() 
        domainWhitelistDropdown:Refresh(getDisplayList()) 
    end
})

KillSelect:Toggle({
    Title = "Active Domain Killer", 
    Desc = "This Domain Will Kill Those In The Domain",
    Callback = function(v)
        runAura = v 
        handleFastPunch(v) 
        handleRemoveAnimation(v)
        
        if auraConn then auraConn:Disconnect() end
        for _, vis in ipairs(radiusVisuals) do vis:Destroy() end 
        radiusVisuals = {}
        
        if v then
            updateVisual(currentRadius)
            auraConn = RunService.Heartbeat:Connect(function()
                local c = lp.Character
                local hrp = c and c:FindFirstChild("HumanoidRootPart")
                local rh = c and c:FindFirstChild("RightHand")
                local lh = c and c:FindFirstChild("LeftHand")
                
                if hrp and rh and lh then
                    if radiusVisuals[1] then 
                        radiusVisuals[1].CFrame = hrp.CFrame 
                    end
                    for _, p in ipairs(Players:GetPlayers()) do
                        local e = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                        if p ~= lp and not manualWhitelist[p.UserId] and e and (e.Position - hrp.Position).Magnitude <= currentRadius and p.Character.Humanoid.Health > 0 then
                            firetouchinterest(rh, e, 1) 
                            firetouchinterest(rh, e, 0) 
                            firetouchinterest(lh, e, 1) 
                            firetouchinterest(lh, e, 0)
                        end
                    end
                end
            end)
        end
    end
})

KillSelect:Toggle({
    Title = "Invisible Domain", 
    Desc = "Domain Does Not Obstruct View", 
    Callback = function(v) 
        _G.DomainTransparent = v 
        if radiusVisuals[1] then 
            radiusVisuals[1].Transparency = v and 1 or 0.7 
        end 
    end
})

local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

local glitch_h = rebirthTab:Section({Title = "Fast Rebirth", Icon = "skull"})

rebirthTab:Toggle({
    Title = "Auto Farm Rebirth",
    Desc = "Requires 7 Pet Packs to Succes",
    Callback = function(state)
        getgenv().IsAutoFarming = state
        
        local a = game:GetService("ReplicatedStorage")
        local b = game:GetService("Players")
        local c = b.LocalPlayer

        local DURASI_SIZE_TOTAL = 300
        local SPEED_SIZE = 0.01
        local DURASI_WEIGHT_TOTAL = 20
        local SPEED_WEIGHT = 0.1
        local JEDA_RESPAWN = 3

        local respawnConn
        local currentProcessThread 
        local sizeThread

        local function stopAllProcesses()
            if currentProcessThread then task.cancel(currentProcessThread) currentProcessThread = nil end
            if sizeThread then task.cancel(sizeThread) sizeThread = nil end
            if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end
        end

        local function startFullProcess(character)
            stopAllProcesses()
            if not getgenv().IsAutoFarming then return end

            sizeThread = task.spawn(function()
                local startTime = tick()
                while (tick() - startTime) < DURASI_SIZE_TOTAL and getgenv().IsAutoFarming do
                    pcall(function()
                        a.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
                    end)
                    task.wait(SPEED_SIZE)
                end
            end)

            currentProcessThread = task.spawn(function()
                task.wait(JEDA_RESPAWN)
                
                local backpack = c:WaitForChild("Backpack")
                local humanoid = character:WaitForChild("Humanoid")
                local weightItem = backpack:FindFirstChild("Weight") or character:FindFirstChild("Weight")

                if weightItem and getgenv().IsAutoFarming then
                    humanoid:EquipTool(weightItem)
                    if weightItem:FindFirstChild("repTime") then
                        weightItem.repTime.Value = 0
                    end
                    
                    local weightStartTime = tick()
                    while (tick() - weightStartTime) < DURASI_WEIGHT_TOTAL and getgenv().IsAutoFarming do
                        if not character or not character.Parent then break end
                        pcall(function()
                            weightItem:Activate()
                        end)
                        task.wait(SPEED_WEIGHT)
                    end
                end

                if not getgenv().IsAutoFarming then return end

                local o = function(p)
                    local q = workspace.machinesFolder:FindFirstChild(p)
                    if not q then
                        for r, s in pairs(workspace:GetChildren()) do
                            if s:IsA("Folder") and s.Name:find("machines") then
                                q = s:FindFirstChild(p)
                                if q then break end
                            end
                        end
                    end
                    return q
                end

                local t = function()
                    local u = game:GetService("VirtualInputManager")
                    u:SendKeyEvent(true, "E", false, game)
                    task.wait(.1)
                    u:SendKeyEvent(false, "E", false, game)
                end
                
                local z = o("Jungle Bar Lift")
                if z and z:FindFirstChild("interactSeat") and character:FindFirstChild("HumanoidRootPart") then
                    for i = 1, 3 do
                        if not getgenv().IsAutoFarming then break end
                        character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                        task.wait(.01)
                        t()
                        task.wait(.1)
                    end
                end

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
            end)
        end

        if state then
            if c.Character then startFullProcess(c.Character) end
            respawnConn = c.CharacterAdded:Connect(function(newChar)
                startFullProcess(newChar)
            end)
        else
            stopAllProcesses()
            if respawnConn then respawnConn:Disconnect() respawnConn = nil end
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

local Farminjgg = rebirthTab:Section({Title = "Rebirth Infinity", Icon = "flame"})

local autoRebirthActive = false

rebirthTab:Toggle({
    Title = "Auto Rebirth Infinity",
    Desc = "Take Unlimited Rebirth 24/7",
    Callback = function(bool)
        autoRebirthActive = bool
        if autoRebirthActive then
            task.spawn(function()
                while autoRebirthActive do 
                    game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                    task.wait(0.1) 
                end
            end)
        end
    end
})

local Farmingg = rebirthTab:Section({Title = "Rebirth Target", Icon = "crosshair"})

local rebirthTarget = 0
local rebirthingToTarget = false
local sizeValue = 2
_G.autoSizeActive = false

rebirthTab:Input({
    Title = "Rebirth Target",
    Desc = "Enter The Number Of Rebirths You Want To Achieve",
    Callback = function(text)
        rebirthTarget = tonumber(text) or 0
    end
})

rebirthTab:Toggle({
    Title = "Auto Rebirth",
    Desc = "Doing Rebirth Farming Automatic",
    Callback = function(bool)
        rebirthingToTarget = bool
        if bool then
            task.spawn(function()
                while rebirthingToTarget do
                    local leaderstats = c:FindFirstChild("leaderstats")
                    local rebirths = leaderstats and leaderstats:FindFirstChild("Rebirths")

                    if rebirths and rebirthTarget > 0 and rebirths.Value >= rebirthTarget then
                        rebirthingToTarget = false
                        break
                    end

                    rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                    task.wait(0.1)
                end
            end)
        end
    end
})

rebirthTab:Input({
    Title = "Set Size",
    Placeholder = "Size Default 2",
    Callback = function(text)
        sizeValue = tonumber(text) or 2
    end
})

rebirthTab:Toggle({
    Title = "Auto Size",
    Desc = "Automatic Size",
    Callback = function(bool)
        _G.autoSizeActive = bool
        if bool then
            task.spawn(function()
                while _G.autoSizeActive do
                    rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", sizeValue)
                    task.wait(0.5)
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

local Farmingg = rebirthTab:Section({Title = "Farming", Icon = "dumbbell"})

rebirthTab:Toggle({
    Title = "Auto Eat Egg | 30mins",
    Desc = "Get 2x Strength | 30 Minute",
    Callback = function(state)
        getgenv().AutoEatProtein = state
        
        local function activateProteinEgg()
            local character = game.Players.LocalPlayer.Character
            if not character then return end
            
            local tool = character:FindFirstChild("Protein Egg") or game.Players.LocalPlayer.Backpack:FindFirstChild("Protein Egg")
            
            if tool and c and c.muscleEvent then
                c.muscleEvent:FireServer("proteinEgg", tool)
            end
        end

        if state then
            task.spawn(function()
                while getgenv().AutoEatProtein do
                    activateProteinEgg()
                    task.wait(1800)
                end
            end)
            
            WindUI:Notify({Title = "Success", Content = "Auto Eat Egg Enabled"})
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
                    local player = game:GetService("Players").LocalPlayer
                    local char = player.Character
                    
                    if char then
                        local weight = char:FindFirstChild("Weight") or player.Backpack:FindFirstChild("Weight")
                        
                        if weight then
                            if weight:FindFirstChild("repTime") then
                                weight.repTime.Value = 0
                            end
                            
                            if weight.Parent ~= char then
                                char.Humanoid:EquipTool(weight)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)

            task.spawn(function()
                while _G.FastWeight do
                    local player = game:GetService("Players").LocalPlayer
                    local event = player:FindFirstChild("muscleEvent") or game:GetService("ReplicatedStorage"):FindFirstChild("muscleEvent")
                    if event then
                        event:FireServer("rep")
                    end
                    task.wait(0.5)
                end
            end)
        else
            local player = game:GetService("Players").LocalPlayer
            local weight = (player.Character and player.Character:FindFirstChild("Weight")) or player.Backpack:FindFirstChild("Weight")
            if weight and weight:FindFirstChild("repTime") then
                weight.repTime.Value = 1
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
    warn("[RESPAWN] Character respawned — continuing automation...")

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
                task.wait(0.3)
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

local ultimateOptions = {
    "+1 Daily Spin", "+1 Pet Slot", "+10 Item Capacity", "+5% Rep Speed",
    "Demon Damage", "Galaxy Gains", "Golden Rebirth", "Jungle Swift",
    "Muscle Mind", "x2 Chest Rewards", "Infernal Health", "x2 Quest Rewards"
}

local autoBuyAll = false

rebirthTab:Toggle({
    Title = "Upgrade All Ultimates",
    Desc = "Upgrade All Ultimate features simultaneously",
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

local Teleport1 = rebirthTab:Section({Title = "Teleport To Save Zone", Icon = "map"})

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

local Farmingg = rebirthTab:Section({Title = "Upgrade Ultimate V2", Icon = "sparkles"})

local ultimateSelect = {
    "+1 Daily Spin", "+1 Pet Slot", "+10 Item Capacity", "+5% Rep Speed",
    "Demon Damage", "Galaxy Gains", "Golden Rebirth", "Jungle Swift",
    "Muscle Mind", "x2 Chest Rewards", "Infernal Health", "x2 Quest Rewards"
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

local TeleportTab    = Window:Tab({Title = "Teleport", Icon = "map-pin"})
local CustomSection  = TeleportTab:Section({Title = "Teleport Custom", Icon = "user-cog"})

local CustomPosInput = "0, 0, 0"
local LockCustomPos  = false

TeleportTab:Input({
    Title       = "Target Position", 
    Desc        = "You Are Free To Teleport Anywhere", 
    Placeholder = "Enter Costume Position",
    Callback    = function(text) 
        CustomPosInput = text 
    end
})

TeleportTab:Button({
    Title    = "Get Your Position", 
    Desc     = "Copy Your Position",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        
        if root then
            local pos = root.Position
            local formattedPos = string.format("%.2f, %.2f, %.2f", pos.X, pos.Y, pos.Z)
            setclipboard(formattedPos)
            
            if WindUI then 
                WindUI:Notify({
                    Title    = "Position Done Copy", 
                    Content  = "You Have Copy The Position", 
                    Duration = 1, 
                    Icon     = "clipboard-check"
                }) 
            end
        end
    end
})

TeleportTab:Toggle({
    Title    = "Teleport Your Position", 
    Value    = false,
    Callback = function(state)
        LockCustomPos = state
        if state then
            task.spawn(function()
                while LockCustomPos do
                    local coords = {}
                    for val in string.gmatch(CustomPosInput, "[^,]+") do 
                        table.insert(coords, tonumber(val)) 
                    end
                    
                    if #coords >= 3 then
                        local character = game.Players.LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if root then 
                            root.CFrame = CFrame.new(coords[1], coords[2], coords[3]) 
                        end
                    end
                    task.wait(0.005)
                end
            end)
        end
    end
})

local TeleportSection = TeleportTab:Section({Title = "Teleport Mode", Icon = "map-pin"})

local CurrentVersion = "Portal Teleport"
local ToggleStates   = {}
local ActiveLoops    = {}

local TeleportData   = {
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

local function SafeTeleport(cframe)
    local player    = game.Players.LocalPlayer
    local character = player.Character
    local root      = character and character:FindFirstChild("HumanoidRootPart")
    
    if root then 
        root.CFrame = cframe 
    end
end

TeleportTab:Dropdown({
    Title    = "Change Teleport Version", 
    Values   = {"Portal Teleport", "Area Spawn", "Area Frost", "Area Mythical", "Area Inferno", "Area Jungle", "Void Brawl", "Desert Brawl", "Ori Brawl"},
    Callback = function(v) 
        CurrentVersion = v 
        RefreshButtons() 
    end
})

local ButtonSection    = TeleportTab:Section({Title = "Teleport", Icon = "list"})
local TeleportToggles  = {}

local ZorVexStatus = {}
ZorVexStatus.__index = ZorVexStatus

local EXTRA_STATS = {"Durability", "Agility", "goodKarma", "evilKarma", "Brawl", "Brawls", "BrawlStats"}

_G.DeathQueue = _G.DeathQueue or {}
local DeathQueue = _G.DeathQueue
local KillLogs = {}
local PlayerJoinTime = {}

local function MonitorPlayer(plr)
    plr.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        hum.Died:Connect(function()
            table.insert(DeathQueue, {Name = plr.DisplayName, Time = tick()})
            if #DeathQueue > 30 then 
                table.remove(DeathQueue, 1) 
            end
        end)
    end)
end

for _, p in ipairs(game.Players:GetPlayers()) do 
    PlayerJoinTime[p] = tick() 
    MonitorPlayer(p) 
end

game.Players.PlayerAdded:Connect(function(plr) 
    PlayerJoinTime[plr] = tick() 
    MonitorPlayer(plr) 
end)

function ZorVexStatus.new(mainWindow)
    local self = setmetatable({}, ZorVexStatus)
    
    self.Window             = mainWindow
    self.StatsTab           = nil
    self.PlayerDropdown     = nil
    self.SelectedPlayer     = game.Players.LocalPlayer
    self.PlayerOriginalStats = {}
    self.UseCompact         = true
    self.StatsLabel         = nil
    self.GainedLabel        = nil
    self.TimerLabel         = nil
    self.StartTime          = tick()
    
    self.LastKillTrack      = {}
    self.AllNames           = {}
    self.NameMap            = {}
    self.SelectedKillPlayer = game.Players.LocalPlayer

    for _, p in ipairs(game.Players:GetPlayers()) do
        local dName = p.DisplayName
        table.insert(self.AllNames, dName)
        self.NameMap[dName] = {Status = "Online"}
        
        local killObj = self:FindStat(p, "Kills")
        if killObj then 
            self.LastKillTrack[p] = killObj.Value 
        end
    end

    self:CreateStatsUI()
    self:InitPlayerStats()
    self:StartAutoRefresh()
    self:InitAntiAFKLogic()
    
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
    local symbolIndex = math.min(math.floor(math.log10(n) / 3), #symbols - 1)
    local value = math.floor((n / 10^(symbolIndex * 3)) * 10) / 10
    
    return string.format("%.1f", value):gsub("%.0$", "") .. symbols[symbolIndex + 1]
end

function ZorVexStatus:FindStat(plr, name)
    if not plr then return nil end
    local nameLower = name:lower()
    
    for _, obj in ipairs(plr:GetChildren()) do 
        if obj.Name:lower() == nameLower and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then 
            return obj 
        end 
    end
    
    local ls = plr:FindFirstChild("leaderstats")
    if ls then 
        for _, obj in ipairs(ls:GetChildren()) do 
            if obj.Name:lower() == nameLower then return obj end 
        end 
    end
    
    local dataFolder = plr:FindFirstChild("Data") or plr:FindFirstChild("Stats")
    if dataFolder then 
        for _, obj in ipairs(dataFolder:GetChildren()) do 
            if obj.Name:lower() == nameLower then return obj end 
        end 
    end
    
    return nil
end

function ZorVexStatus:StoreOriginalStats(plr)
    if not plr or self.PlayerOriginalStats[plr] then return end
    
    local statsTable = {}
    local trackList  = {"Rebirths", "Strength", "Durability", "Kills", "evilKarma", "goodKarma", "Agility", "Brawl", "Brawls", "BrawlStats"}
    
    for _, name in ipairs(trackList) do 
        local obj = self:FindStat(plr, name) 
        if obj then 
            statsTable[name] = obj.Value or 0 
        end 
    end
    
    self.PlayerOriginalStats[plr] = statsTable
end

function ZorVexStatus:GetRenderedList()
    local rendered = {}
    for _, name in ipairs(self.AllNames) do
        local data = self.NameMap[name]
        if data and data.Status == "Offline" then 
            table.insert(rendered, '<font color="#ff4444">' .. name .. ' (Left)</font>') 
        else 
            table.insert(rendered, name) 
        end
    end
    return rendered
end

function ZorVexStatus:CreateStatsUI()
    local Players = game:GetService("Players")
    
    self.StatsTab = self.Window:Tab({Title = "Stats", Icon = "trending-up"})
    self.StatsTab:Section({Title = "View Stats Player", Icon = "trending-up"})
    
    self.StatsTab:Button({
        Title = "Change Version Stats", 
        Desc = "V1 Compact / V2 Detailed", 
        Callback = function() 
            self.UseCompact = not self.UseCompact
            if WindUI then 
                WindUI:Notify({
                    Title = "UI Update", 
                    Content = "Mode " .. (self.UseCompact and "Compact" or "Detailed") .. " Aktif", 
                    Duration = 1.5, 
                    Icon = "settings-2"
                }) 
            end 
        end
    })

    local displayNames = {}
    for _, plr in ipairs(Players:GetPlayers()) do 
        table.insert(displayNames, plr.DisplayName) 
    end

    self.PlayerDropdown = self.StatsTab:Dropdown({
        Title = "Select Player Target", 
        Values = displayNames, 
        Callback = function(v) 
            for _, plr in ipairs(Players:GetPlayers()) do 
                if plr.DisplayName == v then 
                    self.SelectedPlayer = plr 
                    break 
                end 
            end 
        end
    })

    self.StatsTab:Section({Title = "View Stats V1 And View Stats V2", Icon = "eye"})
    
    self.StatsLabel  = self.StatsTab:Paragraph({Title = "Loading stats...", Desc = ""})
    self.GainedLabel = self.StatsTab:Paragraph({Title = "Stats Gained", Desc = ""})
    self.TimerLabel  = self.StatsTab:Paragraph({Title = "MODE AFK", Desc = ""})

    self.StatsTab:Section({Title = "View Who Was Killed", Icon = "swords"})
    
    self.KillDropdown = self.StatsTab:Dropdown({
        Title = "Select Player Who Kills",
        Values = self:GetRenderedList(),
        Callback = function(v)
            local cleanName = v:gsub("<[^>]*>", ""):gsub(" %(Left%)", "")
            local foundPlayer = nil
            for _, p in ipairs(game.Players:GetPlayers()) do 
                if p.DisplayName == cleanName then 
                    foundPlayer = p 
                    break 
                end 
            end
            self.SelectedKillPlayer = foundPlayer or {DisplayName = cleanName, IsOffline = true}
            self:UpdateKillDisplay()
        end
    })

    self.SessionKillLabel = self.StatsTab:Paragraph({Title = "Gained Kills: 0", Desc = "Getting the Current Kill"})
    self.KillLogLabel     = self.StatsTab:Paragraph({Title = "--> Player Killed <--", Desc = "Haven't Killed Anyone Yet"})
end

function ZorVexStatus:UpdateKillDisplay()
    local fullText = ""
    local targetName = self.SelectedKillPlayer.DisplayName
    local found = false
    local totalSessionKills = 0
    
    for i = #KillLogs, 1, -1 do
        local log = KillLogs[i]
        if log.Killer == targetName then
            found = true
            totalSessionKills = totalSessionKills + log.Count
            local countText = log.Count > 1 and " <b>(" .. log.Count .. ")</b>" or ""
            fullText = fullText .. '<font size="14">[' .. log.Time .. '] <b>Killed -> </b><font color="#ff4444"><b>' .. log.Victim .. '</b></font>' .. countText .. '</font>\n'
        end
    end
    
    self.SessionKillLabel:SetTitle(targetName .. " -> Gained Kills: <b>" .. totalSessionKills .. "</b>")
    self.KillLogLabel:SetDesc(found and fullText or "No Players Killed <b>" .. targetName .. "</b>")
end

function ZorVexStatus:UpdateDropdown()
    local names = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do 
        table.insert(names, plr.DisplayName) 
    end
    
    if self.PlayerDropdown then 
        self.PlayerDropdown:Refresh(names) 
    end
    
    if self.KillDropdown then 
        self.KillDropdown:Refresh(self:GetRenderedList()) 
    end
end

function ZorVexStatus:InitPlayerStats()
    local Plrs = game:GetService("Players")
    
    for _, plr in ipairs(Plrs:GetPlayers()) do 
        task.spawn(function() 
            task.wait(1) 
            self:StoreOriginalStats(plr) 
        end) 
    end

    Plrs.PlayerAdded:Connect(function(plr)
        local dName = plr.DisplayName
        if self.NameMap[dName] then 
            self.NameMap[dName].Status = "Online" 
        else 
            table.insert(self.AllNames, dName) 
            self.NameMap[dName] = {Status = "Online"} 
        end
        task.wait(2)
        self:StoreOriginalStats(plr)
        self:UpdateDropdown() 
    end)

    Plrs.PlayerRemoving:Connect(function(plr)
        if self.NameMap[plr.DisplayName] then 
            self.NameMap[plr.DisplayName].Status = "Offline" 
        end
        PlayerJoinTime[plr] = nil
        self.LastKillTrack[plr] = nil
        self:UpdateDropdown() 
    end)
end

function ZorVexStatus:InitAntiAFKLogic()
    local player = game:GetService("Players").LocalPlayer
    pcall(function() 
        if getconnections then 
            for _, v in pairs(getconnections(player.Idled)) do 
                if v.Disable then v:Disable() elseif v.Disconnect then v:Disconnect() end 
            end 
        end 
    end)
    player.Idled:Connect(function() 
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new()) 
    end)
end

function ZorVexStatus:RefreshStats()
    local target = (self.SelectedPlayer and self.SelectedPlayer.Parent) and self.SelectedPlayer or game.Players.LocalPlayer
    local statsText, gainedText = "", ""
    local fsB, fsT = 18, 28
    
    local orderedStats = {
        {I = "Rebirths",  D = "Rebirth"}, 
        {I = "Strength",  D = "Strength"}, 
        {I = "Durability", D = "Durability"}, 
        {I = "Kills",     D = "Kill"}, 
        {I = "evilKarma", D = "Evil Karma"}, 
        {I = "goodKarma", D = "Good Karma"}, 
        {I = "Agility",   D = "Agility"}, 
        {I = "Brawl",     D = "Brawl"}
    }

    for _, s in ipairs(orderedStats) do
        local obj = self:FindStat(target, s.I) or (s.I == "Brawl" and (self:FindStat(target, "Brawls") or self:FindStat(target, "BrawlStats")))
        local val = obj and obj.Value or 0
        local orig = (self.PlayerOriginalStats[target] and (self.PlayerOriginalStats[target][s.I] or self.PlayerOriginalStats[target]["Brawls"] or self.PlayerOriginalStats[target]["BrawlStats"])) or val
        
        statsText = statsText .. '<font size="'..fsB..'"><b>' .. s.D .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
        gainedText = gainedText .. '<font size="'..fsB..'"><b>' .. s.D .. ": +" .. self:FormatNumber(val - orig) .. "</b></font>\n"
    end

    pcall(function()
        self.StatsLabel:SetTitle('<font size="'..fsT..'"><b>' .. target.DisplayName .. '</b></font>')
        self.StatsLabel:SetDesc(statsText)
        
        self.GainedLabel:SetTitle('<font size="'..fsT..'"><b>Stats Gained</b></font>')
        self.GainedLabel:SetDesc(gainedText)
        
        local elapsed = tick() - self.StartTime
        local timeStr = string.format("%02d:%02d:%02d", math.floor(elapsed/3600), math.floor((elapsed%3600)/60), math.floor(elapsed%60))
        
        self.TimerLabel:SetTitle('<font size="'..fsT..'"><b>MODE AFK</b></font>')
        self.TimerLabel:SetDesc('<font size="'..fsB..'"><b>AFK TIME: ' .. timeStr .. '</b></font>')
    end)
end

function ZorVexStatus:RefreshKillLogic()
    local now = tick()
    for _, p in ipairs(game.Players:GetPlayers()) do
        if PlayerJoinTime[p] and (now - PlayerJoinTime[p]) < 1.5 then
            local pKillObj = self:FindStat(p, "Kills")
            if pKillObj then self.LastKillTrack[p] = pKillObj.Value end
            continue 
        end

        local pKillObj = self:FindStat(p, "Kills")
        if pKillObj then
            local pKills = pKillObj.Value
            if not self.LastKillTrack[p] then 
                self.LastKillTrack[p] = pKills 
            end
            
            local diff = pKills - self.LastKillTrack[p]
            if diff > 0 then
                local currentTime = tick()
                local victimName = nil
                
                for i = #DeathQueue, 1, -1 do
                    local d = DeathQueue[i]
                    if math.abs(currentTime - d.Time) < 4 and d.Name ~= p.DisplayName then 
                        victimName = d.Name
                        table.remove(DeathQueue, i) 
                        break 
                    end
                end

                if not victimName then
                    for _, v in ipairs(game.Players:GetPlayers()) do
                        if v ~= p and v.Character and v.Character:FindFirstChild("Humanoid") then
                            if v.Character.Humanoid.Health <= 0 then 
                                victimName = v.DisplayName 
                                break 
                            end
                        end
                    end
                end

                victimName = victimName or "Unknown/NPC"
                local existingLog = nil
                for _, log in ipairs(KillLogs) do 
                    if log.Killer == p.DisplayName and log.Victim == victimName then 
                        existingLog = log 
                        break 
                    end 
                end

                if existingLog then 
                    existingLog.Count = existingLog.Count + diff 
                    existingLog.Time = os.date("%H:%M:%S")
                else 
                    table.insert(KillLogs, {
                        Time = os.date("%H:%M:%S"), 
                        Killer = p.DisplayName, 
                        Victim = victimName, 
                        Count = diff
                    }) 
                end

                if #KillLogs > 150 then 
                    table.remove(KillLogs, 1) 
                end

                if self.SelectedKillPlayer and p.DisplayName == self.SelectedKillPlayer.DisplayName then 
                    self:UpdateKillDisplay() 
                end
            end
            self.LastKillTrack[p] = pKills
        end
    end
end

function ZorVexStatus:StartAutoRefresh() 
    task.spawn(function() 
        while true do 
            task.wait(0.1) 
            self:RefreshStats() 
            pcall(function() self:RefreshKillLogic() end) 
        end 
    end) 
end

local StatsSystem = ZorVexStatus.new(Window)

local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local hb = nil
local lockCustomPos = false
local antiKbEnabled = false
local renderConnection = nil
local screenGui = nil

local miscTab = Window:Tab({Title = "Misc", Icon = "settings"})

local miscccFolder = miscTab:Section({Title = "Players", Icon = "user"})

miscTab:Toggle({
    Title = "Lock Position",
    Desc = "Locking Your Current Position",
    Value = false,
    Callback = function(state)
        lockCustomPos = state
        if not state then return end
        
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local lockedCFrame = root.CFrame
        task.spawn(function()
            while lockCustomPos do
                if root and root.Parent then 
                    root.CFrame = lockedCFrame 
                else 
                    root = player.Character and player.Character:FindFirstChild("HumanoidRootPart") 
                end
                task.wait()
            end
        end)
    end
})

local function ApplyAntiKb(state)
    if hb then hb:Disconnect() hb = nil end
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    
    if not hrp or not hum then return end
    
    if state then
        if hrp:FindFirstChild("AntiKbBV") then hrp.AntiKbBV:Destroy() end
        if hrp:FindFirstChild("AntiKbBG") then hrp.AntiKbBG:Destroy() end
        
        local bv = Instance.new("BodyVelocity")
        local bg = Instance.new("BodyGyro")
        
        bv.Name, bg.Name = "AntiKbBV", "AntiKbBG"
        bv.Parent, bg.Parent = hrp, hrp
        
        bg.P = 10000
        bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
        
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        
        hb = RunService.Heartbeat:Connect(function()
            if not hrp.Parent or not hum.Parent then hb:Disconnect() return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv.MaxForce = Vector3.new(0, 0, 0)
                bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + moveDir), 0.1)
            else
                bv.MaxForce = Vector3.new(1e7, 0, 1e7)
                bv.Velocity = Vector3.new(0, 0, 0)
                bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 0.1)
            end
        end)
    else
        if hrp:FindFirstChild("AntiKbBV") then hrp.AntiKbBV:Destroy() end
        if hrp:FindFirstChild("AntiKbBG") then hrp.AntiKbBG:Destroy() end
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
    end
end

local AntiKb = miscTab:Toggle({
    Title = "Anti Knockback",
    Desc = "Never Bounce",
    Value = true,
    Callback = function(state)
        antiKbEnabled = state
        ApplyAntiKb(state)
    end
})

player.CharacterAdded:Connect(function() 
    if antiKbEnabled then 
        task.wait(0.5) 
        ApplyAntiKb(true) 
    end 
end)

pcall(function() AntiKb:Set(true) end)

miscTab:Toggle({
    Title = "Fly Mode",
    Desc = "Fly With God Mode",
    Default = false,
    Callback = function(Value)
        _G.FlyEnabled = Value
        local char = player.Character or player.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local desc = hum:WaitForChild("HumanoidDescription")
        
        _G.FlySpeed = 70
        local normalSpeed, boostSpeed = 70, 300
        local isDraining, canBoost = false, true
        local emoteIdleName, emoteIdleId = "GodlikeIdle", 81359407734079 
        local emoteMoveName, emoteMoveId = "FlyingMove", 106493972274585 
        
        local function createBlackHole(part)
            local DIRECTION = Enum.NormalId.Bottom
            local BOOST_SPEED = NumberRange.new(20, 40)
            local BOOST_ACCEL = Vector3.new(0, -25, 0)
            local SPREAD = Vector2.new(15, 15)
            local INHERIT, DRAG = 0.9, 1.2     

            local blackHoleCore = Instance.new("ParticleEmitter")
            blackHoleCore.Name = "BlackHoleCore"
            blackHoleCore.Parent = part
            blackHoleCore.Texture = "rbxasset://textures/particles/smoke_main.dds"
            blackHoleCore.LockedToPart = false
            blackHoleCore.VelocityInheritance = INHERIT
            blackHoleCore.Drag = DRAG
            blackHoleCore.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
            })
            blackHoleCore.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.3, 1.5),
                NumberSequenceKeypoint.new(1, 2.5)
            })
            blackHoleCore.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.2, 0.1),
                NumberSequenceKeypoint.new(0.8, 0.4),
                NumberSequenceKeypoint.new(1, 1)
            })
            blackHoleCore.Lifetime = NumberRange.new(0.4, 0.7)
            blackHoleCore.Rate = 450
            blackHoleCore.Speed = BOOST_SPEED
            blackHoleCore.SpreadAngle = SPREAD
            blackHoleCore.ZOffset = -1
            blackHoleCore.EmissionDirection = DIRECTION
            blackHoleCore.Acceleration = BOOST_ACCEL

            local redFlame = Instance.new("ParticleEmitter")
            redFlame.Name = "RedFlame"
            redFlame.Parent = part
            redFlame.Texture = "rbxasset://textures/particles/fire_main.dds"
            redFlame.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
            })
            redFlame.Size = NumberSequence.new(1.5, 0.3)
            redFlame.Lifetime = NumberRange.new(0.3, 0.5)
            redFlame.Rate = 300
            redFlame.LightEmission = 1
            redFlame.ZOffset = 2
            redFlame.EmissionDirection = DIRECTION
            redFlame.Speed = BOOST_SPEED
            redFlame.Acceleration = BOOST_ACCEL

            local darkSmoke = Instance.new("ParticleEmitter")
            darkSmoke.Name = "DarkSmoke"
            darkSmoke.Parent = part
            darkSmoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            darkSmoke.Color = ColorSequence.new(Color3.fromRGB(100, 0, 0), Color3.fromRGB(0, 0, 0))
            darkSmoke.Size = NumberSequence.new(1.2, 2.5)
            darkSmoke.Transparency = NumberSequence.new(0.4, 1)
            darkSmoke.Lifetime = NumberRange.new(0.5, 0.9)
            darkSmoke.Rate = 450
            darkSmoke.EmissionDirection = DIRECTION
            darkSmoke.Speed = BOOST_SPEED
            darkSmoke.Acceleration = BOOST_ACCEL

            local energySparks = Instance.new("ParticleEmitter")
            energySparks.Name = "EnergySparks"
            energySparks.Parent = part
            energySparks.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            energySparks.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 0, 0))
            energySparks.Size = NumberSequence.new(0.4, 0)
            energySparks.Lifetime = NumberRange.new(0.4, 0.7)
            energySparks.Rate = 150
            energySparks.LightEmission = 1
            energySparks.ZOffset = 3
            energySparks.EmissionDirection = DIRECTION
            energySparks.Speed = BOOST_SPEED
            energySparks.Acceleration = BOOST_ACCEL

            local redLight = Instance.new("PointLight")
            redLight.Name = "BlackHoleGlow"
            redLight.Parent = part
            redLight.Color = Color3.fromRGB(255, 0, 0)
            redLight.Brightness = 8
            redLight.Range = 10
            redLight.Shadows = false
        end

        local function clearEffects()
            local targetNames = {"BlackHoleCore", "RedFlame", "DarkSmoke", "EnergySparks", "BlackHoleGlow"}
            for _, v in pairs(char:GetDescendants()) do
                for _, name in pairs(targetNames) do
                    if v.Name == name then v:Destroy() end
                end
            end
        end

        if player.PlayerGui:FindFirstChild("SwordBoosterUI_Final_v2") then 
            player.PlayerGui.SwordBoosterUI_Final_v2:Destroy() 
        end
        clearEffects()

        if _G.FlyEnabled then
            local feet = {"LeftFoot", "RightFoot", "Left Leg", "Right Leg"}
            for _, footName in pairs(feet) do
                local f = char:FindFirstChild(footName)
                if f then createBlackHole(f); createBlackHole(f) end
            end

            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "SwordBoosterUI_Final_v2"
            screenGui.Parent = player.PlayerGui
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true 

            local container = Instance.new("Frame")
            container.Size = UDim2.new(0.2, 0, 0.08, 0)
            container.Position = UDim2.new(0.5, 0, 0.8, 0)
            container.AnchorPoint = Vector2.new(0.5, 0.5)
            container.BackgroundTransparency = 1
            container.Parent = screenGui

            local energyBg = Instance.new("Frame")
            energyBg.Size = UDim2.new(1.2, 0, 0.35, 0)
            energyBg.Position = UDim2.new(0.5, 0, 0.5, 0)
            energyBg.AnchorPoint = Vector2.new(0.5, 0.5)
            energyBg.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
            energyBg.BorderSizePixel = 0
            energyBg.Visible = false
            energyBg.Parent = container

            local function createSharpTip(side)
                local tip = Instance.new("Frame")
                tip.SizeConstraint = Enum.SizeConstraint.RelativeYY
                tip.Size = UDim2.new(1, 0, 1, 0)
                tip.Rotation = 45
                tip.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
                tip.BorderSizePixel = 0
                tip.Position = (side == "Left") and UDim2.new(0, 0, 0.5, 0) or UDim2.new(1, 0, 0.5, 0)
                tip.AnchorPoint = Vector2.new(0.5, 0.5)
                tip.Parent = energyBg
                Instance.new("UIStroke", tip).Thickness = 1
                tip.UIStroke.Color = Color3.fromRGB(255, 0, 0)
            end
            createSharpTip("Left"); createSharpTip("Right")

            Instance.new("UIStroke", energyBg).Thickness = 1
            energyBg.UIStroke.Color = Color3.fromRGB(255, 0, 0)

            local energyFill = Instance.new("Frame")
            energyFill.Size = UDim2.new(1, 0, 1, 0)
            energyFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            energyFill.ZIndex = 2
            energyFill.Parent = energyBg

            local fireGradient = Instance.new("UIGradient")
            fireGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            fireGradient.Parent = energyFill

            local boostBtn = Instance.new("TextButton")
            boostBtn.Size = UDim2.new(0.50, 0, 0.50, 0)
            boostBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
            boostBtn.AnchorPoint = Vector2.new(0.5, 0.5)
            boostBtn.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
            boostBtn.Text = "BOOSTER"
            boostBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
            boostBtn.TextScaled = true
            boostBtn.Font = Enum.Font.GothamBold
            boostBtn.Parent = container
            Instance.new("UICorner", boostBtn).CornerRadius = UDim.new(0.15, 0)

            local bs = Instance.new("UIStroke", boostBtn)
            bs.Thickness = 1.3
            bs.Color = Color3.fromRGB(255, 0, 0)
            bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

            local function createErodeParticle()
                local p = Instance.new("Frame")
                local progress = energyFill.Size.X.Scale
                p.Size = UDim2.new(0.18, 0, 0.18, 0)
                p.SizeConstraint = Enum.SizeConstraint.RelativeYY
                p.Rotation = math.random(0, 360)
                p.BackgroundColor3 = Color3.fromRGB(255, math.random(0, 70), 0)
                p.Position = UDim2.new(progress, 0, 0.5, 0)
                p.AnchorPoint = Vector2.new(0.5, 0.5)
                p.Parent = energyBg
                
                TweenService:Create(p, TweenInfo.new(0.6), {
                    Position = UDim2.new(progress + (math.random(-30, 10)/100), 0, math.random(-5, 6), 0),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 0, 0, 0)
                }):Play()
                task.delay(0.6, function() p:Destroy() end)
            end

            boostBtn.MouseButton1Click:Connect(function()
                if not canBoost then return end
                canBoost, boostBtn.Visible, energyBg.Visible, isDraining, _G.FlySpeed = false, false, true, true, boostSpeed
                local drain = TweenService:Create(energyFill, TweenInfo.new(10, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)})
                drain:Play()
                drain.Completed:Connect(function()
                    isDraining, _G.FlySpeed = false, normalSpeed
                    task.wait(0.5)
                    local fill = TweenService:Create(energyFill, TweenInfo.new(3), {Size = UDim2.new(1, 0, 1, 0)})
                    fill:Play()
                    fill.Completed:Connect(function() 
                        energyBg.Visible, boostBtn.Visible, canBoost = false, true, true 
                    end)
                end)
            end)

            pcall(function() desc:SetEmotes({[emoteIdleName] = {emoteIdleId}, [emoteMoveName] = {emoteMoveId}}) end)
            
            local currentMode = ""
            local function playEmote(name)
                if currentMode == name then return end
                currentMode = name
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then return end
                for _, track in pairs(animator:GetPlayingAnimationTracks()) do track:Stop(0.5) end
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

            hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            hum:ChangeState(Enum.HumanoidStateType.Physics)
            
            local bv = hrp:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
            bv.Name, bv.MaxForce, bv.Parent = "FlyBV", Vector3.new(math.huge, math.huge, math.huge), hrp
            
            local bg = hrp:FindFirstChild("FlyBG") or Instance.new("BodyGyro")
            bg.Name, bg.MaxTorque, bg.P, bg.Parent = "FlyBG", Vector3.new(math.huge, math.huge, math.huge), 5000, hrp

            task.spawn(function()
                while _G.FlyEnabled and char.Parent do
                    if isDraining then for i = 1, 2 do createErodeParticle() end end 
                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0 then
                        playEmote(emoteMoveName)
                        local look = camera.CFrame.LookVector
                        local vel = moveDir * _G.FlySpeed
                        if moveDir:Dot(Vector3.new(look.X, 0, look.Z).Unit) > 0.8 then vel = look * _G.FlySpeed end
                        bv.Velocity = vel
                        bg.CFrame = bg.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + vel), 0.15)
                    else
                        playEmote(emoteIdleName)
                        bv.Velocity = Vector3.zero
                        bg.CFrame = bg.CFrame:Lerp(CFrame.new(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 0.15)
                    end
                    RunService.RenderStepped:Wait()
                end
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
                clearEffects()
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
        else 
            _G.FlyEnabled = false
            clearEffects() 
        end
    end
})

local function ToggleFreecam(state)
    if state then
        local MOVE_SPEED, ROTATION_SPEED = 0.8, 1.5
        local ROTATION_SMOOTHNESS, MOVEMENT_SMOOTHNESS = 0.08, 0.1          
        local targetRotation, currentRotation = Vector2.new(0, 0), Vector2.new(0, 0)
        local velocity = Vector3.new(0, 0, 0)
        
        camera.CameraType = Enum.CameraType.Scriptable
        screenGui = Instance.new("ScreenGui", player.PlayerGui)
        screenGui.Name, screenGui.ResetOnSpawn = "CinematicFreecamUI", false
        
        local function createBtn(name, parent, pos, text)
            local btn = Instance.new("TextButton", parent)
            btn.Name, btn.Size, btn.Position, btn.Text = name, UDim2.new(0, 60, 0, 60), pos, text
            btn.Font, btn.TextSize = Enum.Font.GothamBold, 25
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundTransparency, btn.TextColor3 = 0.5, Color3.fromRGB(0, 0, 0)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
            local stroke = Instance.new("UIStroke", btn)
            stroke.Thickness, stroke.Transparency = 2, 0.5
            return btn
        end

        local moveFrame = Instance.new("Frame", screenGui)
        moveFrame.Size, moveFrame.Position, moveFrame.BackgroundTransparency = UDim2.new(0, 200, 0, 200), UDim2.new(0, 50, 1, -250), 1
        
        local rotateFrame = Instance.new("Frame", screenGui)
        rotateFrame.Size, rotateFrame.Position, rotateFrame.BackgroundTransparency = UDim2.new(0, 260, 0, 200), UDim2.new(1, -310, 1, -250), 1
        
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
            targetRotation = targetRotation + Vector2.new((inputState.LookUp - inputState.LookDown) * ROTATION_SPEED, (inputState.LookLeft - inputState.LookRight) * ROTATION_SPEED)
            currentRotation = currentRotation:Lerp(targetRotation, ROTATION_SMOOTHNESS)
            local direction = Vector3.new(inputState.D - inputState.A, inputState.Up - inputState.Down, inputState.S - inputState.W)
            local cameraCFrame = CFrame.Angles(0, math.rad(currentRotation.Y), 0) * CFrame.Angles(math.rad(currentRotation.X), 0, 0)
            velocity = velocity:Lerp(cameraCFrame:VectorToWorldSpace(direction) * MOVE_SPEED, MOVEMENT_SMOOTHNESS)
            camera.CFrame = CFrame.new(camera.CFrame.Position + velocity) * cameraCFrame
        end)
    else
        if renderConnection then renderConnection:Disconnect() renderConnection = nil end
        if screenGui then screenGui:Destroy() screenGui = nil end
        camera.CameraType = Enum.CameraType.Custom
    end
end

miscTab:Toggle({Title = "Freecam", Default = false, Callback = function(Value) ToggleFreecam(Value) end})

miscTab:Toggle({
    Title = "No-Clip",
    Desc = "Can Pass Through All Walls",
    Callback = function(bool)
        _G.NoClip = bool
        if bool then
            local noclipLoop
            noclipLoop = RunService.Stepped:Connect(function()
                if _G.NoClip then 
                    for _, part in pairs(player.Character:GetDescendants()) do 
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end 
                    end 
                else 
                    noclipLoop:Disconnect() 
                end
            end)
            WindUI:Notify({Title = "No-Clip", Content = "Success Load No-Clip"})
        end
    end
})

local miscccFolderZoom = miscTab:Section({Title = "Zoom Distance", Icon = "radar"})
local zoomAmount, zoomActive = 10000, false

miscTab:Input({
    Title = "Zoom Distance", 
    Desc = "Enter The Viewing Distance You Want", 
    Default = "10000", 
    Numeric = true, 
    Callback = function(t) 
        zoomAmount = tonumber(t) or 128
        if zoomActive then player.CameraMaxZoomDistance = zoomAmount end 
    end
})

miscTab:Toggle({
    Title = "Enable Costume Zoom", 
    Desc = "The Field Of View Can Be Very Wide", 
    Default = false, 
    Callback = function(v) 
        zoomActive = v
        if v then 
            player.CameraMaxZoomDistance = zoomAmount
            camera.FieldOfView = 90 
        else 
            player.CameraMaxZoomDistance = 128
            camera.FieldOfView = 70 
        end 
    end
})

local miscccFolderVisual = miscTab:Section({Title = "Visual", Icon = "eye"})
local parts, partSize, totalDistance, startPosition = {}, 2048, 50000, Vector3.new(-2, -9.5, -2)
local numberOfParts = math.ceil(totalDistance / partSize)

local function createParts()
    for x = 0, numberOfParts - 1 do
        for z = 0, numberOfParts - 1 do
            local function make(name, offset) 
                local p = Instance.new("Part")
                p.Size, p.Position, p.Anchored = Vector3.new(partSize, 1, partSize), startPosition + offset, true
                p.Transparency, p.CanCollide, p.Name, p.Parent = 1, true, name, workspace
                table.insert(parts, p) 
            end
            make("P_Side", Vector3.new(x * partSize, 0, z * partSize))
            make("P_LR", Vector3.new(-x * partSize, 0, z * partSize))
            make("P_UL", Vector3.new(-x * partSize, 0, -z * partSize))
            make("P_UR", Vector3.new(x * partSize, 0, -z * partSize))
        end
    end
end

local function makePartsWalkthrough() 
    for _, part in ipairs(parts) do 
        if part and part.Parent then part.CanCollide = false end 
    end 
end

miscTab:Toggle({
    Title = "Walk on Water", 
    Desc = "Walking On Water Without Falling", 
    Callback = function(bool) 
        if bool then createParts() else makePartsWalkthrough() end 
    end
})

miscTab:Toggle({
    Title = "Hide All Players",
    Desc = "Eliminate All Players To Increase FPS",
    Default = false,
    Callback = function(Value)
        _G.PlayerHideConn = _G.PlayerHideConn or nil
        if Value then
            _G.PlayerHideConn = RunService.RenderStepped:Connect(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        for _, obj in ipairs(p.Character:GetDescendants()) do 
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
            if _G.PlayerHideConn then _G.PlayerHideConn:Disconnect(); _G.PlayerHideConn = nil end
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character then 
                    for _, obj in ipairs(p.Character:GetDescendants()) do 
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
    Desc = "Makes Backpack Empty And Fps Increases",
    Callback = function(isOn)
        local petsFolder = player:WaitForChild("petsFolder")
        local storage = ReplicatedStorage:FindFirstChild("HiddenPets_Storage") or Instance.new("Folder", ReplicatedStorage)
        storage.Name = "HiddenPets_Storage"
        if isOn then 
            for _, pet in ipairs(petsFolder:GetChildren()) do pet.Parent = storage end 
        else 
            for _, pet in ipairs(storage:GetChildren()) do pet.Parent = petsFolder end 
        end
    end
})

local miscccFolderMuscle = miscTab:Section({Title = "Event Muscle", Icon = "sword"})

miscTab:Toggle({
    Title = "Auto Farm Brawl",
    Desc = "Auto Farm Fix Bug",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmBrawl = Value
        if not Value then 
            _G.AutoJoinBrawl, _G.FastPunch, _G.CombatAktif = false, false, false
            if typeof(activateDomainKiller) == "function" then activateDomainKiller(false) end
            return 
        end
        
        local safeZones = {
            {Position = Vector3.new(4429.12, 16.82, -8669.67), Radius = 1200}, 
            {Position = Vector3.new(1005.82, 17.22, -7204.38), Radius = 1200}, 
            {Position = Vector3.new(-1866.51, 17.22, -6310.42), Radius = 1200}
        }
        
        local function isInSafeZone(pos) 
            for _, zone in ipairs(safeZones) do 
                if (pos - zone.Position).Magnitude <= zone.Radius then return true end 
            end 
            return false 
        end

        local brawlEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("brawlEvent")
        local currentRadius, auraConnection = 2000, nil
        _G.CombatAktif = false
        
        local function activateDomainKiller(state)
            if auraConnection then auraConnection:Disconnect() end
            if state then
                auraConnection = RunService.Heartbeat:Connect(function()
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= player and p.Character then
                                local eRoot = p.Character:FindFirstChild("HumanoidRootPart")
                                local eHum = p.Character:FindFirstChild("Humanoid")
                                if eRoot and eHum and eHum.Health > 0 and (eRoot.Position - root.Position).Magnitude <= currentRadius then
                                    local rHand, lHand = char:FindFirstChild("RightHand"), char:FindFirstChild("LeftHand")
                                    if rHand then firetouchinterest(rHand, eRoot, 1); firetouchinterest(rHand, eRoot, 0) end
                                    if lHand then firetouchinterest(lHand, eRoot, 1); firetouchinterest(lHand, eRoot, 0) end
                                end
                            end
                        end
                    end
                end)
            end
        end

        local function startFastPunch()
            if _G.FastPunchActive then return end
            _G.FastPunchActive = true
            task.spawn(function()
                while _G.FastPunch and _G.AutoFarmBrawl do
                    local char = player.Character
                    local tool = char and char:FindFirstChild("Punch") or player.Backpack:FindFirstChild("Punch")
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
                    local muscleEvent = player:FindFirstChild("muscleEvent")
                    if muscleEvent then 
                        muscleEvent:FireServer("punch", "rightHand")
                        muscleEvent:FireServer("punch", "leftHand") 
                    end
                    local tool = player.Character and player.Character:FindFirstChild("Punch")
                    if tool then tool:Activate() end
                    task.wait(0.05) 
                end
                _G.FastPunchActive = false
            end)
        end

        task.spawn(function()
            while _G.AutoFarmBrawl do
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    if isInSafeZone(root.Position) then 
                        if not _G.CombatAktif then 
                            _G.CombatAktif, _G.FastPunch = true, true
                            activateDomainKiller(true)
                            startFastPunch() 
                        end
                    else 
                        if _G.CombatAktif then 
                            _G.CombatAktif, _G.FastPunch = false, false
                            activateDomainKiller(false) 
                        end
                        brawlEvent:FireServer("joinBrawl") 
                    end
                end
                task.wait(7)
            end
        end)
    end
})

miscTab:Toggle({
    Title = "Eat All Snacks",
    Desc = "Eating All Snack Items",
    Callback = function(state)
        _G.AutoEatAll = state
        if state then
            local mE = player:WaitForChild("muscleEvent")
            local itemList = {"Tropical Shake", "Energy Shake", "Protein Bar", "TOUGH Bar", "Protein Shake", "ULTRA Shake", "Energy Bar"}
            
            local function formatEventName(itemName)
                local parts = {}
                for word in itemName:gmatch("%S+") do table.insert(parts, word:lower()) end
                for i = 2, #parts do parts[i] = parts[i]:sub(1,1):upper() .. parts[i]:sub(2) end
                return table.concat(parts)
            end

            task.spawn(function()
                while _G.AutoEatAll do
                    for _, itemName in ipairs(itemList) do
                        if not _G.AutoEatAll then break end
                        local tool = player.Character and player.Character:FindFirstChild(itemName) or player.Backpack:FindFirstChild(itemName)
                        if tool then mE:FireServer(formatEventName(itemName), tool) end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

miscTab:Toggle({
    Title = "Auto Spin Wheel", 
    Desc ="Perform Auto Spin Without Animation", 
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
    Desc ="Claim All Completed Quests", 
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

local serverTab = Window:Tab({
    Title = "Server", 
    Icon  = "server"
})

local serverSection = serverTab:Section({
    Title = "Server", 
    Icon  = "power"
})

local currentJobID = ""

serverTab:Input({
    Title       = "Enter Server JobID",
    Placeholder = "Enter ID here...",
    Callback    = function(text)
        currentJobID = text
    end
})

serverTab:Button({
    Title    = "Join Server ID",
    Desc     = "Join Using The JobID You Enter",
    Callback = function()
        if currentJobID ~= "" then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, currentJobID, game.Players.LocalPlayer)
        else
            WindUI:Notify({
                Title   = "Error",
                Content = "Please Enter A Valid JobID First!"
            })
        end
    end
})

serverTab:Button({
    Title    = "Get Server's JobID ",
    Desc     = "Copying Your Current Server JobID",
    Callback = function()
        setclipboard(game.JobId)
        WindUI:Notify({
            Title   = "Success",
            Content = "JobID Copied To Clipboard!"
        })
    end
})

serverTab:Toggle({
    Title    = "Join Low Player",
    Desc     = "There Won't Be Many Players",
    Callback = function(bool)
        if bool then
            local module = loadstring(game:HttpGet("https://raw.githubusercontent.com/LeoKholYt/roblox/main/lk_serverhop.lua"))()
            module:Teleport(game.PlaceId, "Lowest")
        end
    end
})

serverTab:Button({
    Title    = "Rejoin Server",
    Desc     = "Rejoin Your Current Server",
    Callback = function()
        local ts = game:GetService("TeleportService")
        ts:Teleport(game.PlaceId, player)
    end
})

serverTab:Button({
    Title    = "Delete Portals",
    Desc     = "Remove Ads To Prevent Teleporting Out Of The Game",
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
            Title   = "Ads Delete",
            Content = "Portal Ads Delete"
        })
    end
})

serverTab:Button({
    Title    = "FPS Boost",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
        end
 
        local lighting    = game:GetService("Lighting")
        lighting.GlobalShadows = false
        lighting.FogEnd        = 9e9
        lighting.Brightness    = 0
 
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
            Title   = "Boost",
            Content = "Done Booster FPS"
        })
    end
})

for i = 1, 9 do
    ToggleStates[i] = false
    TeleportToggles[i] = TeleportTab:Toggle({
        Title    = "Select Version Teleport", 
        Desc     = "Teleport Detail Mode", 
        Value    = false,
        Callback = function(state)
            ToggleStates[i] = state
            if state then
                task.spawn(function()
                    while ToggleStates[i] do
                        local data = TeleportData[CurrentVersion][i]
                        if data then 
                            SafeTeleport(data[2]) 
                        end
                        task.wait(0.005)
                    end
                end)
            end
        end
    })
end

function RefreshButtons()
    local locations = TeleportData[CurrentVersion]
    if not locations then return end

    for i = 1, 9 do 
        if locations[i] and TeleportToggles[i] then 
            TeleportToggles[i]:SetTitle(locations[i][1]) 
        end 
    end
end

RefreshButtons()
