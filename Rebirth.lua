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
    Author = "            By ZorVex",
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

local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

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

local zoomAmount, zoomActive = 10000, false

rebirthTab:Input({
    Title = "Zoom Distance", 
    Desc = "Enter The Viewing Distance You Want", 
    Default = "10000", 
    Numeric = true, 
    Callback = function(t) 
        local player = game:GetService("Players").LocalPlayer
        zoomAmount = tonumber(t) or 10000
        if zoomActive then player.CameraMaxZoomDistance = zoomAmount end 
    end
})

rebirthTab:Toggle({
    Title = "Enable Costume Zoom", 
    Desc = "The Field Of View Can Be Very Wide", 
    Default = false, 
    Callback = function(v) 
        local player = game:GetService("Players").LocalPlayer
        local camera = workspace.CurrentCamera
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