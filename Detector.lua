local ZorVexKillerUI = {}; ZorVexKillerUI.__index = ZorVexKillerUI
local DeadPlayers = {}
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    local function update(input) local delta = input.Position - dragStart gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end
    gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging, dragStart, startPos = true, input.Position, gui.Position input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end) end end)
    gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    game:GetService("UserInputService").InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end
function ZorVexKillerUI.new()
    local self = setmetatable({}, ZorVexKillerUI)
    self.SelectedPlayerName, self.AllHistoryStats, self.IsDropdownOpen, self.IsLogOpen = game.Players.LocalPlayer.Name, {}, false, false
    self:CreateBaseUI(); self:InitTracking(); self:StartUpdateLoop() return self
end
function ZorVexKillerUI:FormatNumber(n)
    n = tonumber(n) or 0 if n < 1000 then return tostring(math.floor(n)) end
    local symbols, symbolIndex = {"", "k", "M", "B", "T", "Qa", "Qi"}, math.floor(math.log10(n) / 3)
    if symbolIndex >= #symbols then symbolIndex = #symbols - 1 end
    return string.format("%.1f", n / 10^(symbolIndex * 3)):gsub("%.0$", "") .. symbols[symbolIndex + 1]
end
function ZorVexKillerUI:CreateBaseUI()
    local sg = Instance.new("ScreenGui"); sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.Parent = "ZorVexKillerFinal", false, true, game.CoreGui
    local main = Instance.new("Frame"); main.Name, main.Size, main.Position, main.BackgroundColor3, main.BackgroundTransparency, main.BorderSizePixel, main.Active, main.ClipsDescendants, main.Parent = "MainFrame", UDim2.new(0, 380, 0, 240), UDim2.new(0.5, -190, 0.5, -120), Color3.fromRGB(255, 255, 255), 0.1, 0, true, true, sg
    self.Gui, self.MainFrame = sg, main; MakeDraggable(main); Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    local stroke = Instance.new("UIStroke", main); stroke.Thickness, stroke.Color = 3, Color3.fromRGB(230, 230, 230)
    local contentFrame = Instance.new("Frame"); contentFrame.Name, contentFrame.Size, contentFrame.BackgroundTransparency, contentFrame.Parent = "ContentFrame", UDim2.new(1, 0, 1, 0), 1, main
    self.ContentFrame = contentFrame
    self.NameLabel = self:CreateLabel("LOADING...", 27, UDim2.new(0, 0, 0, 75), contentFrame)
    self.UserSubLabel = self:CreateLabel("@username", 16, UDim2.new(0, 0, 0, 95), contentFrame); self.UserSubLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
    self.StatsLabel = self:CreateLabel("Kill : 0 Players", 22, UDim2.new(0, 0, 0, 135), contentFrame); self.StatsLabel.TextColor3 = Color3.fromRGB(180, 0, 0)
    local dropBtn = Instance.new("TextButton"); dropBtn.Name, dropBtn.Size, dropBtn.Position, dropBtn.BackgroundColor3, dropBtn.BackgroundTransparency, dropBtn.Text, dropBtn.Font, dropBtn.TextSize, dropBtn.TextColor3, dropBtn.ZIndex, dropBtn.Parent = "DropdownBtn", UDim2.new(0.9, 0, 0, 45), UDim2.new(0.05, 0, 0, 15), Color3.fromRGB(35, 35, 35), 0.1, "Select Player ▼", Enum.Font.GothamBold, 18, Color3.fromRGB(255, 255, 255), 200, main; Instance.new("UICorner", dropBtn).CornerRadius = UDim.new(0, 8)
    local logBtn = Instance.new("TextButton"); logBtn.Name, logBtn.Size, logBtn.Position, logBtn.BackgroundColor3, logBtn.BackgroundTransparency, logBtn.Text, logBtn.Font, logBtn.TextSize, logBtn.TextColor3, logBtn.ZIndex, logBtn.Parent = "LogBtn", UDim2.new(0.9, 0, 0, 45), UDim2.new(0.05, 0, 1, -60), Color3.fromRGB(35, 35, 35), 0.1, "Korban ▼", Enum.Font.GothamBold, 18, Color3.fromRGB(255, 255, 255), 200, main; self.LogBtn = logBtn; Instance.new("UICorner", logBtn).CornerRadius = UDim.new(0, 8)
    self.DropList, self.LogList = self:CreateScrollList(main, 150), self:CreateScrollList(main, 150)
    self.DropList.Position, self.DropList.Size = UDim2.new(0.05, 0, 0, 65), UDim2.new(0.9, 0, 0, 155)
    self.LogList.Position, self.LogList.Size = UDim2.new(0.05, 0, 0, 65), UDim2.new(0.9, 0, 0, 110)
    dropBtn.MouseButton1Click:Connect(function() self.IsDropdownOpen, self.IsLogOpen = not self.IsDropdownOpen, false; self:RefreshUIState() if self.IsDropdownOpen then self:UpdateDropdownUI() end end)
    logBtn.MouseButton1Click:Connect(function() self.IsLogOpen, self.IsDropdownOpen = not self.IsLogOpen, false; self:RefreshUIState() if self.IsLogOpen then self:RenderLogList() end end)
end
function ZorVexKillerUI:RefreshUIState()
    local targetData = self.AllHistoryStats[self.SelectedPlayerName]
    self.LogBtn.Visible, self.DropList.Visible, self.LogList.Visible, self.ContentFrame.Visible = not self.IsDropdownOpen, self.IsDropdownOpen, self.IsLogOpen, not (self.IsDropdownOpen or self.IsLogOpen)
    self.MainFrame.DropdownBtn.Text = self.IsDropdownOpen and "Close ▲" or "Select Player ▼"
    if targetData then self.LogBtn.Text = self.IsLogOpen and "Close ▲" or "Korban [ "..#targetData.Logs.." ] ▼" end
end
function ZorVexKillerUI:CreateLabel(txt, size, pos, parent)
    local l = Instance.new("TextLabel"); l.Size, l.Position, l.BackgroundTransparency, l.Text, l.Font, l.TextSize, l.TextColor3, l.TextXAlignment, l.Parent = UDim2.new(1, 0, 0, 30), pos, 1, txt, Enum.Font.GothamBold, size, Color3.fromRGB(0, 0, 0), Enum.TextXAlignment.Center, parent; return l
end
function ZorVexKillerUI:CreateScrollList(parent, zindex)
    local sc = Instance.new("ScrollingFrame"); sc.Visible, sc.BackgroundColor3, sc.BackgroundTransparency, sc.ZIndex, sc.BorderSizePixel, sc.ScrollBarThickness, sc.ScrollBarImageColor3, sc.Parent = false, Color3.fromRGB(240, 240, 240), 0.1, zindex, 0, 4, Color3.fromRGB(180, 180, 180), parent
    local layout = Instance.new("UIListLayout", sc); layout.Padding, layout.HorizontalAlignment = UDim.new(0, 6), Enum.HorizontalAlignment.Center; return sc
end
function ZorVexKillerUI:UpdateDropdownUI()
    for _, child in ipairs(self.DropList:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    local pCount = 0 for name, data in pairs(self.AllHistoryStats) do
        pCount = pCount + 1
        local item = Instance.new("Frame"); item.Size, item.BackgroundColor3, item.ZIndex, item.Parent = UDim2.new(1, -10, 0, 45), Color3.fromRGB(255, 255, 255), 160, self.DropList; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local btn = Instance.new("TextButton"); btn.Size, btn.BackgroundTransparency, btn.Text, btn.ZIndex, btn.Parent = UDim2.new(1, 0, 1, 0), 1, "", 165, item
        local dL = Instance.new("TextLabel"); dL.Size, dL.Position, dL.Text, dL.Font, dL.TextColor3, dL.TextSize, dL.TextXAlignment, dL.BackgroundTransparency, dL.ZIndex, dL.Parent = UDim2.new(1, 0, 0.6, 0), UDim2.new(0, 0, 0, 2), data.DisplayName, Enum.Font.GothamBold, data.IsOnline and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(150, 0, 0), 16, Enum.TextXAlignment.Center, 1, 162, item
        local uL = Instance.new("TextLabel"); uL.Size, uL.Position, uL.Text, uL.Font, uL.TextColor3, uL.TextSize, uL.TextXAlignment, uL.BackgroundTransparency, uL.ZIndex, uL.Parent = UDim2.new(1, 0, 0.4, 0), UDim2.new(0, 0, 0.5, 0), "@"..name..(data.IsOnline and "" or " (Offline)"), Enum.Font.Gotham, Color3.fromRGB(120, 120, 120), 12, Enum.TextXAlignment.Center, 1, 162, item
        btn.MouseButton1Click:Connect(function() self.SelectedPlayerName, self.IsDropdownOpen = name, false; self:RefreshUIState() end)
    end self.DropList.CanvasSize = UDim2.new(0, 0, 0, pCount * 52)
end
function ZorVexKillerUI:RenderLogList()
    for _, v in ipairs(self.LogList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    local targetData = self.AllHistoryStats[self.SelectedPlayerName] if not targetData then return end
    for _, data in ipairs(targetData.Logs) do
        local item = Instance.new("Frame"); item.Size, item.BackgroundColor3, item.ZIndex, item.Parent = UDim2.new(1, -10, 0, 50), Color3.fromRGB(255, 255, 255), 160, self.LogList; Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
        local tL = Instance.new("TextLabel"); tL.Size, tL.Position, tL.Text, tL.Font, tL.TextColor3, tL.TextSize, tL.TextXAlignment, tL.BackgroundTransparency, tL.ZIndex, tL.Parent = UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 5), data.displayName.." [ "..data.count.." Killed ]", Enum.Font.GothamBold, Color3.fromRGB(200, 0, 0), 16, Enum.TextXAlignment.Center, 1, 162, item
        local bL = Instance.new("TextLabel"); bL.Size, bL.Position, bL.Text, bL.Font, bL.TextColor3, bL.TextSize, bL.TextXAlignment, bL.BackgroundTransparency, bL.ZIndex, bL.Parent = UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 25), "[ Time "..data.time.." ] @"..data.userName, Enum.Font.Gotham, Color3.fromRGB(100, 100, 100), 13, Enum.TextXAlignment.Center, 1, 162, item
    end self.LogList.CanvasSize = UDim2.new(0, 0, 0, #targetData.Logs * 56)
end
function ZorVexKillerUI:GetKillValueObject(p) local ls = p:FindFirstChild("leaderstats") return ls and (ls:FindFirstChild("Kills") or ls:FindFirstChild("Kill")) or nil end
function ZorVexKillerUI:InitTracking()
    task.spawn(function() while true do for _, p in ipairs(game.Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then DeadPlayers[p.Name] = nil end end task.wait(0.1) end end)
    local function setup(p) task.spawn(function()
        local killObj = nil repeat killObj = self:GetKillValueObject(p) if not killObj then task.wait(0.5) end until killObj or not p.Parent
        if not killObj then return end
        if not self.AllHistoryStats[p.Name] then self.AllHistoryStats[p.Name] = {DisplayName = p.DisplayName, IsOnline = true, SessionKills = 0, LastTotal = killObj.Value, IsCalibrated = false, Logs = {}} else self.AllHistoryStats[p.Name].IsOnline, self.AllHistoryStats[p.Name].LastTotal = true, killObj.Value end
        task.wait(1.5) if self.AllHistoryStats[p.Name] then self.AllHistoryStats[p.Name].IsCalibrated = true end
        killObj.Changed:Connect(function(new)
            local d = self.AllHistoryStats[p.Name] if d and d.IsCalibrated and new > d.LastTotal then
                d.SessionKills = d.SessionKills + (new - d.LastTotal)
                for _, v in ipairs(game.Players:GetPlayers()) do if v ~= p and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health <= 0 and not DeadPlayers[v.Name] then
                    DeadPlayers[v.Name] = true; local ex = nil for _, log in ipairs(d.Logs) do if log.userName == v.Name then ex = log break end end
                    if ex then ex.count, ex.time = ex.count + 1, os.date("%H:%M") else table.insert(d.Logs, 1, {displayName = v.DisplayName, userName = v.Name, time = os.date("%H:%M"), count = 1}) end
                end end
            end if d then d.LastTotal = new end
        end); self:UpdateDropdownUI()
    end) end
    for _, p in ipairs(game.Players:GetPlayers()) do setup(p) end
    game.Players.PlayerAdded:Connect(setup); game.Players.PlayerRemoving:Connect(function(p) if self.AllHistoryStats[p.Name] then self.AllHistoryStats[p.Name].IsOnline = false self:UpdateDropdownUI() end end)
end
function ZorVexKillerUI:StartUpdateLoop() task.spawn(function() while task.wait(0.5) do local d = self.AllHistoryStats[self.SelectedPlayerName] if d then self.NameLabel.Text, self.UserSubLabel.Text, self.StatsLabel.Text = d.DisplayName, "@"..self.SelectedPlayerName, "Kill : "..self:FormatNumber(d.SessionKills).." Players" end end end) end
local KillerTracker = ZorVexKillerUI.new()
