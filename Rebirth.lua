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
        Title = "--> REBIRTH <--",
        Color = Color3.fromHex("#000000")
    })
end

local rebirthTab = Window:Tab({Title = "Rebirth", Icon = "refresh-cw"})

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

-- Fungsi utama Noclip
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
        setNoclip(Value) -- Aktifkan noclip saat toggle ON
        
        if Value then
            task.spawn(function()
                while isTeleporting do
                    local char = player.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        root.CFrame = targetCFrame
                    end
                    task.wait(0.1) -- Ubah ke 0.1 agar lebih stabil
                end
            end)
        end
    end
})

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(2)
    warn("[RESPAWN] Character respawned â€” continuing automation...")

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

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local hb

local AntiKb = miscTab:Toggle({
    Title = "Anti Knockback",
    Value = true,
    Callback = function(state)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        
        if not hrp or not hum then return end

        if state then
            -- Hapus objek lama jika ada (biar tidak tumpang tindih)
            if hrp:FindFirstChild("AntiKbBV") then hrp.AntiKbBV:Destroy() end
            if hrp:FindFirstChild("AntiKbBG") then hrp.AntiKbBG:Destroy() end

            local bv = Instance.new("BodyVelocity", hrp)
            local bg = Instance.new("BodyGyro", hrp)
            bv.Name, bg.Name = "AntiKbBV", "AntiKbBG"
            
            bg.P = 10000
            bg.MaxTorque = Vector3.new(1e7, 1e7, 1e7)
            
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

            hb = runService.Heartbeat:Connect(function()
                if not hrp.Parent or not hum.Parent then hb:Disconnect() return end
                
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

pcall(function()
    AntiKb:Set(true)
end)

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

local ZorVexStatus = {}
ZorVexStatus.__index = ZorVexStatus

-- Menambahkan variasi nama internal yang mungkin digunakan game
local EXTRA_STATS = {"Durability", "Agility", "goodKarma", "evilKarma", "Brawl", "Brawls", "BrawlStats"}

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
    self.TimerLabel = nil
    self.StartTime = tick()

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
    local symbolIndex = math.floor(math.log10(n) / 3)
    if symbolIndex >= #symbols then symbolIndex = #symbols - 1 end
    local power = 10 ^ (symbolIndex * 3)
    local value = n / power
    local finalValue = math.floor(value * 10) / 10
    local formatted = string.format("%.1f", finalValue):gsub("%.0$", "")
    return formatted .. symbols[symbolIndex + 1]
end

function ZorVexStatus:FindStat(plr, name)
    if not plr then return nil end
    local nameLower = name:lower()
    
    -- Cek di folder utama pemain
    for _, obj in ipairs(plr:GetChildren()) do
        if obj.Name:lower() == nameLower and (obj:IsA("NumberValue") or obj:IsA("IntValue")) then
            return obj
        end
    end
    
    -- Cek di leaderstats
    local ls = plr:FindFirstChild("leaderstats")
    if ls then
        for _, obj in ipairs(ls:GetChildren()) do
            if obj.Name:lower() == nameLower then return obj end
        end
    end
    
    -- Cek folder data umum
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
    local trackList = {"Rebirths", "Strength", "Durability", "Kills", "evilKarma", "goodKarma", "Agility", "Brawl", "Brawls", "BrawlStats"}
    
    for _, name in ipairs(trackList) do
        local obj = self:FindStat(plr, name)
        if obj then
            statsTable[name] = obj.Value or 0
        end
    end
    self.PlayerOriginalStats[plr] = statsTable
end

function ZorVexStatus:CreateStatsUI()
    self.StatsTab = self.Window:Tab({Title = "Stats", Icon = "trending-up"})
    
    local configSection = self.StatsTab:Section({Title = "View Stats Player", Icon = "trending-up"})

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
    
    local Players = game:GetService("Players")
    local displayNames = {}
    for _, plr in ipairs(Players:GetPlayers()) do table.insert(displayNames, plr.DisplayName) end
    
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

    -- SUDAH DIKEMBALIKAN DISINI
    local displaySection = self.StatsTab:Section({Title = "View Stats V1 And View Stats V2", Icon = "eye"})

    self.StatsLabel = self.StatsTab:Paragraph({Title = "Loading stats...", Desc = ""})
    self.GainedLabel = self.StatsTab:Paragraph({Title = "Stats Gained", Desc = ""})
    self.TimerLabel = self.StatsTab:Paragraph({Title = "MODE AFK", Desc = ""})
end

function ZorVexStatus:UpdateDropdown()
    local displayNames = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do table.insert(displayNames, plr.DisplayName) end
    if self.PlayerDropdown then self.PlayerDropdown:Refresh(displayNames) end
end

function ZorVexStatus:InitPlayerStats()
    local Players = game:GetService("Players")
    for _, plr in ipairs(Players:GetPlayers()) do
        task.spawn(function() task.wait(1); self:StoreOriginalStats(plr) end)
    end
    Players.PlayerAdded:Connect(function(plr) 
        task.wait(2)
        self:StoreOriginalStats(plr)
        self:UpdateDropdown() 
    end)
    Players.PlayerRemoving:Connect(function() self:UpdateDropdown() end)
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
    local target = self.SelectedPlayer
    if not target or not target.Parent then target = game.Players.LocalPlayer end
    
    local statsText, gainedText = "", ""
    local fontSizeBody, fontSizeTitle = 18, 28 
    
    local orderedStats = {
        {Internal = "Rebirths", Display = "Rebirth"},
        {Internal = "Strength", Display = "Strength"},
        {Internal = "Durability", Display = "Durability"},
        {Internal = "Kills", Display = "Kill"},
        {Internal = "evilKarma", Display = "Evil Karma"},
        {Internal = "goodKarma", Display = "Good Karma"},
        {Internal = "Agility", Display = "Agility"},
        {Internal = "Brawl", Display = "Brawl"}
    }

    for _, statInfo in ipairs(orderedStats) do
        local obj = self:FindStat(target, statInfo.Internal)
        -- Fallback khusus untuk Brawl
        if not obj and statInfo.Internal == "Brawl" then
            obj = self:FindStat(target, "Brawls") or self:FindStat(target, "BrawlStats")
        end
        
        local val = obj and obj.Value or 0
        local orig = (self.PlayerOriginalStats[target] and (self.PlayerOriginalStats[target][statInfo.Internal] or self.PlayerOriginalStats[target]["Brawls"] or self.PlayerOriginalStats[target]["BrawlStats"])) or val
        local gained = val - orig
        
        statsText = statsText .. '<font size="'..fontSizeBody..'"><b>' .. statInfo.Display .. ": " .. self:FormatNumber(val) .. "</b></font>\n"
        gainedText = gainedText .. '<font size="'..fontSizeBody..'"><b>' .. statInfo.Display .. ": +" .. self:FormatNumber(gained) .. "</b></font>\n"
    end

    pcall(function()
        self.StatsLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>' .. target.DisplayName .. '</b></font>')
        self.StatsLabel:SetDesc(statsText)
        self.GainedLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>Stats Gained</b></font>')
        self.GainedLabel:SetDesc(gainedText)
        
local timeScale = 1 / 1.28
local elapsed = (tick() - self.StartTime) * timeScale

local hours = math.floor(elapsed / 3600)
local minutes = math.floor((elapsed % 3600) / 60)
local seconds = math.floor(elapsed % 60)

local timeStr = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        self.TimerLabel:SetTitle('<font size="'..fontSizeTitle..'"><b>MODE AFK</b></font>')
        self.TimerLabel:SetDesc('<font size="'..fontSizeBody..'"><b>AFK TIME: ' .. timeStr .. '</b></font>')
    end)
end

function ZorVexStatus:StartAutoRefresh()
    task.spawn(function()
        while true do 
            task.wait(0.1) 
            self:RefreshStats() 
        end
    end)
end

local StatsSystem = ZorVexStatus.new(Window)

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

RefreshRockButtons()
