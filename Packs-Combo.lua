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

local myGradient = WindUI:Gradient({
    ["0"]   = { Color = Color3.fromHex("#ffffff"), Transparency = 0 },
    ["50"]   = { Color = Color3.fromHex("#666666"), Transparency = 0 },
    ["100"] = { Color = Color3.fromHex("#141414"), Transparency = 0 },
}, {
    Rotation = 0,
})

WindUI:AddTheme({
    Name        = "Light",
    Accent      = "#f4f4f5",
    Dialog      = "#f4f4f5",
    Outline     = "#000000", 
    Text        = myGradient,
    Placeholder = "#666666",
    Background  = "#000000",
    Button      = "#858585",
    Icon        = "#858585",
})

WindUI:SetNotificationLower(true)

local themes = {"Light"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local Window = WindUI:CreateWindow({
    Title = "<b><font size='26'> V̬uz͠o̵ Zilu͢x</font></b>", 
    Icon = "rbxassetid://103162489006184", 
    Author = "         By ZorVex",
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
ImgBtn.Image = "rbxassetid://103162489006184" 
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
    Title = "<font size='13'> VIP </font>", 
    Color = Color3.fromHex("#858585")
})

local farmPlusTab = Window:Tab({Title = "Farming", Icon = "cpu"})
local petPacksList = {"[ ☠️--PET PACKS--☠️ ]", "Tribal Overlord", "Swift Samurai", "Mighty Monster", "Wild Wizard"}
local crystalSection = farmPlusTab:Section({Title = "Pet Packs", Icon = "skull"})

farmPlusTab:Dropdown({
    Title = "Select Pet Pack",
    Desc = "Only Available for Those Who Have Packs",
    Values = petPacksList,
    Callback = function(v) 
        selectedPack = v 
    end
})

farmPlusTab:Button({
    Title = "Equip Pet Pack",
    Desc = "Using Pet Packs Automatically",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local petsFolder = player:WaitForChild("petsFolder")
        local rEvents = game:GetService("ReplicatedStorage"):WaitForChild("rEvents")

        if selectedPack == "" or selectedPack == nil then
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
                WindUI:Notify({Title = "Success", Content = "Successfully Using Pet: " .. selectedPack, Duration = 3})
            else
                WindUI:Notify({Title = "Not Found", Content = "You Don't Have a Pet: " .. selectedPack, Duration = 3})
            end
        end
    end
})

local VipUser = farmPlusTab:Section({Title = "Faster Strength", Icon = "gem"})

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
            local player = game:GetService("Players").LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
            local equipPet = function(petName) 
                if player.petsFolder:FindFirstChild("Unique") then
                    for _, n in pairs(player.petsFolder.Unique:GetChildren()) do 
                        if n.Name == petName then 
                            ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", n) 
                        end 
                    end 
                end
            end
            
            task.spawn(function()
                while getgenv().PushStrengthEnabled do
                    equipPet("Swift Samurai")
                    for y = 1, (repCount or 1) do 
                        if not getgenv().PushStrengthEnabled then break end 
                        if player:FindFirstChild("muscleEvent") then
                            player.muscleEvent:FireServer("rep")
                        else
                            ReplicatedStorage.rEvents.muscleEvent:FireServer("rep")
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

local VipUserrr = farmPlusTab:Section({Title = "Faster Strength Target", Icon = "gem"})

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
            local player = game:GetService("Players").LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            
            task.spawn(function()
                while getgenv().AutoPush do
                    local strength = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Strength")
                    if TargetStrength and TargetStrength > 0 and strength and strength.Value >= TargetStrength then
                        getgenv().AutoPush = false
                        break
                    end
                    
                    for i = 1, (repCount or 1) do
                        if not getgenv().AutoPush then break end
                        if player:FindFirstChild("muscleEvent") then 
                            player.muscleEvent:FireServer("rep") 
                        else
                            ReplicatedStorage.rEvents.muscleEvent:FireServer("rep")
                        end
                    end
                    task.wait()
                end
            end)
        end
    end
})

local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

local glitch_h = rebirthTab:Section({Title = "Fast Rebirth", Icon = "skull"})

rebirthTab:Toggle({
    Title = "Auto Farm Rebirth V1",
    Desc = "Requires 7 Pet Packs to Succes",
    Callback = function(state)
        getgenv().IsAutoFarming = state
        
        local a = game:GetService("ReplicatedStorage")
        local b = game:GetService("Players")
        local c = b.LocalPlayer

        local DURASI_SIZE_TOTAL = 15
        local SPEED_SIZE = 0.01
        local DURASI_WEIGHT_TOTAL = 10
        local SPEED_WEIGHT = 0.1
        local JEDA_RESPAWN = 1

        local respawnConn
        local currentProcessThread 
        local sizeThread
        local autoFarmThread

        -- FUNGSI UNTUK MEMBERSIHKAN SEMUA PROSES AGAR TIDAK MENUMPUK
        local function stopAllProcesses()
            if currentProcessThread then task.cancel(currentProcessThread) currentProcessThread = nil end
            if sizeThread then task.cancel(sizeThread) sizeThread = nil end
            if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end
        end

        -- FUNGSI LOOP FARMING (PET & STRENGTH)
        local function runAutoFarmLoop()
            -- Pastikan tidak ada loop farm lain yang jalan sebelum mulai
            if autoFarmThread then task.cancel(autoFarmThread) end 
            
            autoFarmThread = task.spawn(function()
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
        end

        -- FUNGSI FULL (DIPANGGIL SAAT RESPAWN)
        local function startFullProcess(character)
            stopAllProcesses() -- MATIKAN SEMUA SEBELUM MULAI BARU
            if not getgenv().IsAutoFarming then return end

            -- Jalankan Size
            sizeThread = task.spawn(function()
                local startTime = tick()
                while (tick() - startTime) < DURASI_SIZE_TOTAL and getgenv().IsAutoFarming do
                    pcall(function() a.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2) end)
                    task.wait(SPEED_SIZE)
                end
            end)

            currentProcessThread = task.spawn(function()
                task.wait(JEDA_RESPAWN) -- Tunggu karakter stabil
                
                local backpack = c:WaitForChild("Backpack")
                local humanoid = character:WaitForChild("Humanoid")
                local weightItem = backpack:FindFirstChild("Weight") or character:FindFirstChild("Weight")

                -- Tahap Persiapan: Latihan Weight
                if weightItem and getgenv().IsAutoFarming then
                    humanoid:EquipTool(weightItem)
                    local weightStartTime = tick()
                    while (tick() - weightStartTime) < DURASI_WEIGHT_TOTAL and getgenv().IsAutoFarming do
                        if not character or not character.Parent then break end
                        pcall(function() weightItem:Activate() end)
                        task.wait(SPEED_WEIGHT)
                    end
                end

                if not getgenv().IsAutoFarming then return end

                -- Teleport ke Mesin (3x)
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

                -- Mulai Farming
                runAutoFarmLoop()
            end)
        end

        if state then
            -- JIKA BARU NYALA: Langsung Teleport & Farm
            if c.Character then 
                task.spawn(function()
                    stopAllProcesses() -- Bersihkan thread lama jika ada
                    
                    -- Jalankan Size di background
                    sizeThread = task.spawn(function()
                        local startTime = tick()
                        while (tick() - startTime) < DURASI_SIZE_TOTAL and getgenv().IsAutoFarming do
                            pcall(function() a.rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2) end)
                            task.wait(SPEED_SIZE)
                        end
                    end)
                    
                    -- Langsung Teleport 3x
                    local o = function(p)
                        local q = workspace.machinesFolder:FindFirstChild(p)
                        if not q then
                            for r, s in pairs(workspace:GetChildren()) do
                                if s:IsA("Folder") and s.Name:find("machines") then q = s:FindFirstChild(p) if q then break end end
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
                    if z and z:FindFirstChild("interactSeat") and c.Character:FindFirstChild("HumanoidRootPart") then
                        for i = 1, 3 do
                            c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                            task.wait(.01)
                            t()
                            task.wait(.1)
                        end
                    end
                    runAutoFarmLoop()
                end)
            end

            -- EVENT RESPAWN: Reset alur ke awal (Weight dulu)
            respawnConn = c.CharacterAdded:Connect(function(newChar)
                startFullProcess(newChar)
            end)
        else
            -- MATIKAN SEMUA JIKA TOGGLE OFF
            stopAllProcesses()
            if respawnConn then respawnConn:Disconnect() respawnConn = nil end
        end
    end
})

local createdPlatforms = {} 
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = game.Players.LocalPlayer

local function stopEverything()
    getgenv().IsAutoFarming = false
    if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    if circleConnection then circleConnection:Disconnect() circleConnection = nil end
    for _, platform in pairs(createdPlatforms) do if platform then platform:Destroy() end end
    createdPlatforms = {}
end

rebirthTab:Toggle({
    Title = "Auto Farm Rebirth V2",
    Desc = "Mode Fly Around The Island Need 7 Pet Packs",
    Callback = function(state)
        _G.AutoSizeEnabled = state
        getgenv().IsAutoFarming = state 

        if state then
            -- 1. PEMBUATAN PLATFORM
            local posisiLantai = {
                Vector3.new(0, 150, 0), Vector3.new(2000, 150, 0), Vector3.new(-2000, 150, 0),
                Vector3.new(0, 150, 2000), Vector3.new(0, 150, -2000), Vector3.new(2000, 150, -2000),
                Vector3.new(2000, 150, 2000), Vector3.new(-2000, 150, -2000), Vector3.new(-2000, 150, 2000)
            }

            for _, posisi in pairs(posisiLantai) do
                local lantai = Instance.new("Part")
                lantai.Name = "LantaiUtama_VIP"; lantai.Anchored = true; lantai.CanCollide = true
                lantai.Transparency = 1; lantai.Size = Vector3.new(2000, 5, 2000); lantai.Position = posisi
                lantai.Parent = workspace
                table.insert(createdPlatforms, lantai)
            end

            task.wait(1) 

            local startCFrame = CFrame.new(6.23, 540.76, -34.36)
            local radius, speed, angle = 1100, 1.3, 0
            local centerPoint = startCFrame.Position 
            local emoteName, emoteId = "Godlike Emote", 106493972274585

            local function startNoClip()
                if noclipConnection then noclipConnection:Disconnect() end
                noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    if _G.AutoSizeEnabled and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end)
            end

            local function runLogic(character)
                -- Proteksi Anti-Numpuk saat Respawn
                if autoFarmThread then task.cancel(autoFarmThread) autoFarmThread = nil end
                
                local humanoid = character:WaitForChild("Humanoid")
                local rootPart = character:WaitForChild("HumanoidRootPart")
                
                -- [A] NOCLIP & TELEPORT
                startNoClip()
                rootPart.CFrame = startCFrame
                task.wait(0.3)
                
                -- [B] SPAM KLIK & SPAM REP (PRE-WARM)
                local weightItem = character:FindFirstChild("Weight") or player.Backpack:FindFirstChild("Weight")
                if weightItem then
                    -- 1. Spam Klik di Backpack (3 detik)
                    weightItem.Parent = player.Backpack
                    local startClick = tick()
                    while tick() - startClick < 3 and getgenv().IsAutoFarming do
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                        task.wait(0.05)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                        task.wait(0.05)
                    end

                    -- 2. Equip & Spam Rep (3 detik, speed 0.1)
                    weightItem.Parent = character
                    local startRep = tick()
                    while tick() - startRep < 4 and getgenv().IsAutoFarming do
                        player.muscleEvent:FireServer("rep")
                        task.wait(0.1)
                    end

                    -- 3. Unequip lagi buat persiapan Size
                    weightItem.Parent = player.Backpack
                end

                -- [C] UBAH SIZE
                local remoteSize = ReplicatedStorage:FindFirstChild("rEvents") and ReplicatedStorage.rEvents:FindFirstChild("changeSpeedSizeRemote")
                if remoteSize then remoteSize:InvokeServer("changeSize", 100) end
                task.wait(0.5)

                -- [D] EMOTE SETUP
                local desc = humanoid:FindFirstChildOfClass("HumanoidDescription") or Instance.new("HumanoidDescription", humanoid)
                desc:SetEmotes({[emoteName] = {emoteId}})
                pcall(function() humanoid:PlayEmote(emoteName) end)
                
                task.defer(function()
                    task.wait(0.1)
                    local animator = humanoid:FindFirstChildOfClass("Animator")
                    if animator then
                        for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                            track.Priority = Enum.AnimationPriority.Action4
                            track.Looped = true
                        end
                    end
                end)
                task.wait(0.2)

                -- [E] EQUIP FINAL (Setelah Emote)
                if weightItem then
                    weightItem.Parent = character
                    if weightItem:FindFirstChild("repTime") then weightItem.repTime.Value = 0 end
                end

                -- [F] AUTO FARM & REBIRTH THREAD
                task.wait(1.5)

                local unequipAllPets = function()
                    local folder = player:FindFirstChild("petsFolder")
                    if folder then
                        for _, h in pairs(folder:GetChildren()) do
                            if h:IsA("Folder") then
                                for _, j in pairs(h:GetChildren()) do
                                    ReplicatedStorage.rEvents.equipPetEvent:FireServer("unequipPet", j)
                                end
                            end
                        end
                    end
                end

                local equipPetByName = function(name)
                    unequipAllPets()
                    task.wait(.01)
                    local uniqueFolder = player:FindFirstChild("petsFolder") and player.petsFolder:FindFirstChild("Unique")
                    if uniqueFolder then
                        for _, n in pairs(uniqueFolder:GetChildren()) do
                            if n.Name == name then
                                ReplicatedStorage.rEvents.equipPetEvent:FireServer("equipPet", n)
                            end
                        end
                    end
                end

                autoFarmThread = task.spawn(function()
                    while getgenv().IsAutoFarming do
                        local v = player.leaderstats.Rebirths.Value
                        local targetStr = 10000 + (5000 * v)
                        if player:FindFirstChild("ultimatesFolder") and player.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                            local x = player.ultimatesFolder["Golden Rebirth"].Value
                            targetStr = math.floor(targetStr * (1 - (x * 0.1)))
                        end
                        
                        unequipAllPets()
                        task.wait(.1)
                        equipPetByName("Swift Samurai")
                        
                        while player.leaderstats.Strength.Value < targetStr and getgenv().IsAutoFarming do
                            for y = 1, 13 do
                                player.muscleEvent:FireServer("rep")
                            end
                            task.wait()
                        end
                        
                        if not getgenv().IsAutoFarming then break end

                        unequipAllPets()
                        task.wait(.1)
                        equipPetByName("Tribal Overlord")
                        
                        local currentRebirths = player.leaderstats.Rebirths.Value
                        repeat
                            ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                            task.wait(.1)
                            if not getgenv().IsAutoFarming then break end
                        until player.leaderstats.Rebirths.Value > currentRebirths
                        task.wait()
                    end
                end)
            end

            -- Jalankan Logic Utama
            if player.Character then task.spawn(runLogic, player.Character) end
            characterAddedConn = player.CharacterAdded:Connect(runLogic)

            -- Heartbeat Orbit
            circleConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
                if not _G.AutoSizeEnabled then return end
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    angle = angle + (speed * dt)
                    local x = math.cos(angle) * radius
                    local z = math.sin(angle) * radius
                    local newPos = centerPoint + Vector3.new(x, 0, z)
                    local lookPos = centerPoint + Vector3.new(math.cos(angle + 0.1) * radius, 0, math.sin(angle + 0.1) * radius)
                    character.HumanoidRootPart.CFrame = CFrame.lookAt(newPos, lookPos)
                end
            end)

        else
            -- CLEANUP MUTLAK
            stopEverything()
            if characterAddedConn then characterAddedConn:Disconnect() characterAddedConn = nil end

            if player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then tool.Parent = player.Backpack end
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

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

    -- Kode baru yang ditambahkan di bawah dropdown:
    self.StatsTab:Button({
        Title = "Refresh Player List",
        Desc = "Update list target player terbaru",
        Callback = function()
            self:UpdateDropdown()
            if WindUI then
                WindUI:Notify({
                    Title = "Player List",
                    Content = "List player berhasil diperbarui!",
                    Duration = 1.5,
                    Icon = "refresh-cw"
                })
            end
        end
    })

    self.StatsTab:Section({Title = "View Stats V1 And View Stats V2", Icon = "eye"})
    
    self.StatsLabel  = self.StatsTab:Paragraph({Title = "Loading stats...", Desc = ""})
    self.GainedLabel = self.StatsTab:Paragraph({Title = "Stats Gained", Desc = ""})
    self.TimerLabel  = self.StatsTab:Paragraph({Title = "MODE AFK", Desc = ""})
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
    end)

    Plrs.PlayerRemoving:Connect(function(plr)
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
        {I = "Brawl",     D = "Brawls"}
    }

    for _, s in ipairs(orderedStats) do
        local obj = self:FindStat(target, s.I) or (s.I == "Brawl" and (self:FindStat(target, "Brawls") or self:FindStat(target, "BrawlStats")))
        local val = obj and obj.Value or 0
        
        -- PROSES PENYARINGAN (Membuang teks/simbol aneh, hanya ambil angka)
        if type(val) == "string" then
            val = val:gsub("%D", "") -- Menghapus semua karakter non-angka (termasuk garis-garis itu)
        end
        val = tonumber(val) or 0 -- Memastikan formatnya murni angka
        
        local orig = (self.PlayerOriginalStats[target] and (self.PlayerOriginalStats[target][s.I] or self.PlayerOriginalStats[target]["Brawls"] or self.PlayerOriginalStats[target]["BrawlStats"])) or val
        
        -- Tambahan proteksi untuk nilai original stat agar tidak error
        if type(orig) == "string" then orig = tonumber(orig:gsub("%D", "")) or 0 end
        orig = tonumber(orig) or 0

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

local misc99Folder = miscTab:Section({Title = "Distance", Icon = "user"})

local miscccFolderZoom = miscTab:Section({Title = "Zoom Distance", Icon = "radar"})
local zoomAmount, zoomActive = 10000, false

miscTab:Input({
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

miscTab:Toggle({
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

local hbUtama = nil
local hbCadangan = nil

local function ApplyAntiKb(state)
    if hbUtama then hbUtama:Disconnect() hbUtama = nil end
    if hbCadangan then hbCadangan:Disconnect() hbCadangan = nil end
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    
    if not hrp or not hum then return end
    
    if hrp:FindFirstChild("AntiKbBV_1") then hrp.AntiKbBV_1:Destroy() end
    if hrp:FindFirstChild("AntiKbBG_1") then hrp.AntiKbBG_1:Destroy() end
    if hrp:FindFirstChild("AntiKbBV_2") then hrp.AntiKbBV_2:Destroy() end
    if hrp:FindFirstChild("AntiKbBG_2") then hrp.AntiKbBG_2:Destroy() end
    
    if state then
        local bv1 = Instance.new("BodyVelocity")
        local bg1 = Instance.new("BodyGyro")
        bv1.Name, bg1.Name = "AntiKbBV_1", "AntiKbBG_1"
        bv1.Parent, bg1.Parent = hrp, hrp
        
        bg1.P, bg1.D, bg1.MaxTorque = 30000, 400, Vector3.new(1e7, 1e7, 1e7)
        
        local bv2 = Instance.new("BodyVelocity")
        local bg2 = Instance.new("BodyGyro")
        bv2.Name, bg2.Name = "AntiKbBV_2", "AntiKbBG_2"
        bv2.Parent, bg2.Parent = hrp, hrp
        
        bg2.P, bg2.D, bg2.MaxTorque = 30000, 400, Vector3.new(1e7, 1e7, 1e7)
        
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        
        hbUtama = RunService.Heartbeat:Connect(function()
            if not hrp.Parent or not hum.Parent then hbUtama:Disconnect() return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv1.MaxForce = Vector3.new(0, 0, 0)
                bg1.CFrame = bg1.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + moveDir), 0.25)
            else
                bv1.MaxForce = Vector3.new(1e7, 0, 1e7)
                bv1.Velocity = Vector3.new(0, 0, 0)
                bg1.CFrame = bg1.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 0.25)
            end
        end)
        
        hbCadangan = RunService.Heartbeat:Connect(function()
            if not hrp.Parent or not hum.Parent then hbCadangan:Disconnect() return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv2.MaxForce = Vector3.new(0, 0, 0)
                bg2.CFrame = bg2.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + moveDir), 0.25)
            else
                bv2.MaxForce = Vector3.new(1e7, 0, 1e7)
                bv2.Velocity = Vector3.new(0, 0, 0)
                bg2.CFrame = bg2.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 0.25)
            end
        end)
    else
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

Players.PlayerAdded:Connect(function(newPlayer)
    task.wait(0.1) 
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    -- Cek langsung ke tubuh: jika perisai utama (1) ada, berarti fitur sedang menyala
    if hrp and hum and hrp:FindFirstChild("AntiKbBV_1") then
        if hbCadangan then hbCadangan:Disconnect() hbCadangan = nil end
        if hrp:FindFirstChild("AntiKbBV_2") then hrp.AntiKbBV_2:Destroy() end
        if hrp:FindFirstChild("AntiKbBG_2") then hrp.AntiKbBG_2:Destroy() end
        
        task.wait(1) 
        
        -- Cek ulang setelah jeda 1 detik, pastikan perisai utama masih aktif sebelum menyalakan cadangan
        if not hrp.Parent or not hrp:FindFirstChild("AntiKbBV_1") then return end
        
        local bv2 = Instance.new("BodyVelocity")
        local bg2 = Instance.new("BodyGyro")
        bv2.Name, bg2.Name = "AntiKbBV_2", "AntiKbBG_2"
        bv2.Parent, bg2.Parent = hrp, hrp
        bg2.P, bg2.D, bg2.MaxTorque = 30000, 400, Vector3.new(1e7, 1e7, 1e7)
        
        hbCadangan = RunService.Heartbeat:Connect(function()
            if not hrp.Parent or not hum.Parent then hbCadangan:Disconnect() return end
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude > 0 then
                bv2.MaxForce = Vector3.new(0, 0, 0)
                bg2.CFrame = bg2.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + moveDir), 0.25)
            else
                bv2.MaxForce = Vector3.new(1e7, 0, 1e7)
                bv2.Velocity = Vector3.new(0, 0, 0)
                bg2.CFrame = bg2.CFrame:Lerp(CFrame.lookAt(hrp.Position, hrp.Position + hrp.CFrame.LookVector), 0.25)
            end
        end)
    end
end)

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
