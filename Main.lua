-- ==========================================
-- SCRIPT UTAMA: ALL FARM, AUTO MOUNTAIN & SAFE MULTI-INJECT
-- ==========================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. CLEANUP TOTAL: Hapus GUI dan koneksi lama agar tidak bentrok/error saat re-inject
if _G.ActiveConnections then
	for _, conn in ipairs(_G.ActiveConnections) do
		if typeof(conn) == "RBXScriptConnection" then
			conn:Disconnect()
		end
	end
end
_G.ActiveConnections = {}

if playerGui:FindFirstChild("UnifiedFarmGui") then playerGui.UnifiedFarmGui:Destroy() end
if playerGui:FindFirstChild("UnifiedToggleGui") then playerGui.UnifiedToggleGui:Destroy() end
if playerGui:FindFirstChild("AutoDigGui") then playerGui.AutoDigGui:Destroy() end
if playerGui:FindFirstChild("AutoFarmCrystalGui") then playerGui.AutoFarmCrystalGui:Destroy() end

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local digRequest = remotes:WaitForChild("DigRequest")
local sledgeSwing = remotes:WaitForChild("SledgeSwing")
local crystalDropRemote = remotes:WaitForChild("CrystalDropRequest")

local isAutoFarmRunning = false
local selectedToolName = nil 
local isListExpanded = false 

local lastPosition = Vector3.new(0, 0, 0)
local stuckStartTime = tick()

local TargetTerrainMaterials = {
	Enum.Material.CrackedLava,
	Enum.Material.Ground,
	Enum.Material.Sandstone,
	Enum.Material.Rock,
	Enum.Material.Snow,
	Enum.Material.Ice,
	Enum.Material.Glacier,
	Enum.Material.Slate,
	Enum.Material.Basalt,
	Enum.Material.Limestone
}

local isAllFarmRunning = false
local isDropping = false 
local targetPosition = Vector3.new(70.40643310546875, 26.42267417907715 + 3, 1046.040283203125)
local TWEEN_SPEED = 70 
local lastDropPosition = nil
local BLACKLIST_RADIUS = 50

local noclipConnection = nil
local gravityConnection = nil
local currentTween = nil

local CONFIG_FILE = "UnifiedFarmConfig.json"

local function saveConfig()
	if writefile then
		pcall(function()
			local data = {
				isAllFarmRunning = isAllFarmRunning,
				isAutoFarmRunning = isAutoFarmRunning,
				selectedToolName = selectedToolName
			}
			writefile(CONFIG_FILE, game:GetService("HttpService"):JSONEncode(data))
		end)
	end
end

local function loadConfig()
	if readfile and isfile and isfile(CONFIG_FILE) then
		local success, result = pcall(function()
			return game:GetService("HttpService"):JSONDecode(readfile(CONFIG_FILE))
		end)
		if success and type(result) == "table" then
			isAllFarmRunning = result.isAllFarmRunning or false
			isAutoFarmRunning = result.isAutoFarmRunning or false
			selectedToolName = result.selectedToolName or nil
		end
	end
end

loadConfig()

-- ================= 2. TOMBOL UI & SLOW RAINBOW =================
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "UnifiedToggleGui"
toggleGui.ResetOnSpawn = false
toggleGui.Parent = playerGui

local openCloseBtn = Instance.new("TextButton")
openCloseBtn.Name = "OpenCloseButton"
openCloseBtn.Size = UDim2.new(0, 36, 0, 36)
openCloseBtn.Position = UDim2.new(0, 10, 0, 35)
openCloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openCloseBtn.TextSize = 12
openCloseBtn.Font = Enum.Font.GothamBold
openCloseBtn.Text = "OP"
openCloseBtn.Active = true
openCloseBtn.Parent = toggleGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = openCloseBtn

-- Loop Rainbow Aman
local rainbowTask = task.spawn(function()
	while true do
		local hue = (tick() % 12) / 12 
		if openCloseBtn and openCloseBtn.Parent then
			openCloseBtn.BackgroundColor3 = Color3.fromHSV(hue, 0.9, 1)
		else
			break
		end
		task.wait(0.1)
	end
end)

-- ================= 3. PANEL GUI UTAMA =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UnifiedFarmGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 150, 0, 125) -- Disesuaikan sedikit untuk teks lebih besar
mainFrame.Position = UDim2.new(0, 52, 0, 35)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 18)
titleLabel.Position = UDim2.new(0, 0, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Mine Menu"
titleLabel.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 134, 0, 24)
toggleButton.Position = UDim2.new(0, 8, 0, 24)
toggleButton.BackgroundColor3 = isAllFarmRunning and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 13.5 -- 50% lebih besar dari 9
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = isAllFarmRunning and "All Farm: ON" or "All Farm: OFF"
toggleButton.Parent = mainFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 4)
btnCorner1.Parent = toggleButton

local btnAutoDig = Instance.new("TextButton")
btnAutoDig.Name = "BtnAutoDig"
btnAutoDig.Size = UDim2.new(0, 134, 0, 24)
btnAutoDig.Position = UDim2.new(0, 8, 0, 52)
btnAutoDig.BackgroundColor3 = isAutoFarmRunning and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
btnAutoDig.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAutoDig.TextSize = 13.5 -- 50% lebih besar dari 9
btnAutoDig.Font = Enum.Font.GothamBold
btnAutoDig.Text = isAutoFarmRunning and "Clear Map: ON" or "Clear Map: OFF"
btnAutoDig.Parent = mainFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 4)
btnCorner2.Parent = btnAutoDig

local toolListBtn = Instance.new("TextButton")
toolListBtn.Name = "ToolListBtn"
toolListBtn.Size = UDim2.new(1, -16, 0, 16)
toolListBtn.Position = UDim2.new(0, 8, 0, 80)
toolListBtn.BackgroundTransparency = 1
toolListBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toolListBtn.TextSize = 12 -- 50% lebih besar dari 8
toolListBtn.Font = Enum.Font.GothamBold
toolListBtn.Text = "Select Tools [+]"
toolListBtn.TextXAlignment = Enum.TextXAlignment.Left
toolListBtn.Parent = mainFrame

local btnTerminus = Instance.new("TextButton")
btnTerminus.Name = "BtnTerminus"
btnTerminus.Size = UDim2.new(0, 134, 0, 20)
btnTerminus.Position = UDim2.new(0, 8, 0, 100)
btnTerminus.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTerminus.TextSize = 11
btnTerminus.Font = Enum.Font.GothamMedium
btnTerminus.Text = "Terminus"
btnTerminus.Visible = false
btnTerminus.Parent = mainFrame

local terminusCorner = Instance.new("UICorner")
terminusCorner.CornerRadius = UDim.new(0, 4)
terminusCorner.Parent = btnTerminus

local btnSledge = Instance.new("TextButton")
btnSledge.Name = "BtnSledge"
btnSledge.Size = UDim2.new(0, 134, 0, 20)
btnSledge.Position = UDim2.new(0, 8, 0, 124)
btnSledge.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSledge.TextSize = 11
btnSledge.Font = Enum.Font.GothamMedium
btnSledge.Text = "Sledge"
btnSledge.Visible = false
btnSledge.Parent = mainFrame

local sledgeCorner = Instance.new("UICorner")
sledgeCorner.CornerRadius = UDim.new(0, 4)
sledgeCorner.Parent = btnSledge

local isPanelVisible = true
openCloseBtn.MouseButton1Click:Connect(function()
	isPanelVisible = not isPanelVisible
	mainFrame.Visible = isPanelVisible
end)

toolListBtn.MouseButton1Click:Connect(function()
	isListExpanded = not isListExpanded
	if isListExpanded then
		toolListBtn.Text = "Select Tools [-]"
		mainFrame.Size = UDim2.new(0, 150, 0, 150)
		btnTerminus.Visible = true
		btnSledge.Visible = true
	else
		toolListBtn.Text = "Select Tools [+]"
		mainFrame.Size = UDim2.new(0, 150, 0, 125)
		btnTerminus.Visible = false
		btnSledge.Visible = false
	end
end)

local function refreshToolButtons()
	if selectedToolName == "Terminus" then
		btnTerminus.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
		btnSledge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	elseif selectedToolName == "Sledge Hammer" then
		btnTerminus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btnSledge.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
	else
		btnTerminus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btnSledge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end
refreshToolButtons()

local function getCharacterParts()
	local char = player.Character
	if not char then return nil, nil, nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local bp = player:FindFirstChild("Backpack")
	return char, hum, hrp, bp
end

local function equipSelectedTool()
	if not selectedToolName then return end
	local char, hum, _, bp = getCharacterParts()
	if not char or not hum or not bp then return end
	
	for _, item in ipairs(char:GetChildren()) do
		if item:IsA("Tool") then
			local name = item.Name:lower()
			if selectedToolName == "Terminus" and name:find("terminus") then
				pcall(function() item:Activate() end)
				return
			elseif selectedToolName == "Sledge Hammer" and (name:find("sledge") or name:find("hammer")) then
				pcall(function() item:Activate() end)
				return
			end
		end
	end
	
	local targetTool = nil
	for _, item in ipairs(bp:GetChildren()) do
		if item:IsA("Tool") then
			local name = item.Name:lower()
			if selectedToolName == "Terminus" and name:find("terminus") then
				targetTool = item
				break
			elseif selectedToolName == "Sledge Hammer" and (name:find("sledge") or name:find("hammer")) then
				targetTool = item
				break
			end
		end
	end
	
	if targetTool and targetTool:IsA("Tool") then
		hum:EquipTool(targetTool)
		pcall(function() targetTool:Activate() end)
	end
end

local function findHighestMountainPeak()
	local _, hum, hrp, _ = getCharacterParts()
	if not hrp or not hum or hum.Health <= 0 then return nil end
	local rootPos = hrp.Position

	local bestPos = nil
	local highestY = -math.huge

	local yawAngles = {0, 60, 120, 180, 240, 300}
	local pitchAngles = {15, 30}

	for _, yaw in ipairs(yawAngles) do
		for _, pitch in ipairs(pitchAngles) do
			local yawRad = math.rad(yaw)
			local pitchRad = math.rad(pitch)
			
			local horizontalDist = 120 * math.cos(pitchRad)
			local verticalDist = 120 * math.sin(pitchRad)
			
			local dir = Vector3.new(
				math.cos(yawRad) * horizontalDist,
				verticalDist,
				math.sin(yawRad) * horizontalDist
			)
			
			local rayParams = RaycastParams.new()
			rayParams.IgnoreWater = true
			
			local rayResult = workspace:Raycast(rootPos + Vector3.new(0, 10, 0), dir, rayParams)
			if rayResult and rayResult.Material then
				for _, mat in ipairs(TargetTerrainMaterials) do
					if rayResult.Material == mat then
						if rayResult.Position.Y > highestY then
							highestY = rayResult.Position.Y
							bestPos = rayResult.Position
						end
						break
					end
				end
			end
		end
	end

	return bestPos
end

local function tweenToPosition(targetPos)
	local _, hum, hrp, _ = getCharacterParts()
	if not hrp or not hum or hum.Health <= 0 then return end

	local safeTargetPos = targetPos + Vector3.new(0, 12, 0)
	local distance = (hrp.Position - safeTargetPos).Magnitude
	local speed = 70
	local timeTaken = math.clamp(distance / speed, 0.1, 2.0)

	local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(safeTargetPos)})
	
	tween:Play()
	local startTime = tick()
	while tween.PlaybackState == Enum.PlaybackState.Playing do
		task.wait(0.05)
		local _, currentHum, currentHrp = getCharacterParts()
		if tick() - startTime > timeTaken + 1 or not currentHrp or not currentHum or currentHum.Health <= 0 then
			tween:Cancel()
			break
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.3)
		if isAutoFarmRunning then
			pcall(function()
				local _, hum, hrp, _ = getCharacterParts()
				if not hrp or not hum or hum.Health <= 0 then return end

				local currentPos = hrp.Position
				if (currentPos - lastPosition).Magnitude < 2 then
					if tick() - stuckStartTime > 1.5 then
						hrp.CFrame = CFrame.new(currentPos + Vector3.new(math.random(-10, 10), 25, math.random(-10, 10)))
						stuckStartTime = tick()
						return
					end
				else
					lastPosition = currentPos
					stuckStartTime = tick()
				end

				if selectedToolName then
					equipSelectedTool()
				end

				local peakPos = findHighestMountainPeak()
				if peakPos then
					tweenToPosition(peakPos)
				end

				if selectedToolName then
					local currentHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					local currentHum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
					if currentHrp and currentHum and currentHum.Health > 0 then
						local pos = currentHrp.Position
						local feetPos = pos - Vector3.new(0, 3, 0)
						if selectedToolName == "Terminus" then
							digRequest:FireServer("The Terminus", Vector3.new(pos.X, pos.Y, pos.Z))
						elseif selectedToolName == "Sledge Hammer" then
							sledgeSwing:FireServer(Vector3.new(feetPos.X, feetPos.Y, feetPos.Z))
						end
					end
				end
			end)
		end
	end
end)

local function enableNoclip()
	local character = player.Character
	if not character then return end
	noclipConnection = RunService.Stepped:Connect(function()
		if character and character.Parent then
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = false end
			end
		else
			if noclipConnection then noclipConnection:Disconnect() end
		end
	end)
	table.insert(_G.ActiveConnections, noclipConnection)
end

local function disableNoclip()
	if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
	local character = player.Character
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = true end
		end
	end
end

local function enableAntiGravity()
	local character = player.Character
	if not character then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")
	if not rootPart or not humanoid then return end

	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

	gravityConnection = RunService.RenderStepped:Connect(function()
		if rootPart and rootPart.Parent then
			rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, rootPart.CFrame:ToEulerAnglesYXZ())
		else
			if gravityConnection then gravityConnection:Disconnect() end
		end
	end)
	table.insert(_G.ActiveConnections, gravityConnection)
end

local function disableAntiGravity()
	if gravityConnection then gravityConnection:Disconnect(); gravityConnection = nil end
end

local function tweenTo(targetCFrame)
	local character = player.Character
	if not character or not targetCFrame then return end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not rootPart or not humanoid or humanoid.Health <= 0 then return end

	if currentTween then currentTween:Cancel(); currentTween = nil end

	local distance = (rootPart.Position - targetCFrame.Position).Magnitude
	if distance < 1 then return end
	
	local duration = distance / 80
	local adjustedCFrame = CFrame.new(targetCFrame.Position) * CFrame.Angles(0, rootPart.CFrame:ToEulerAnglesYXZ())
	
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	currentTween = TweenService:Create(rootPart, tweenInfo, {CFrame = adjustedCFrame})
	currentTween:Play()
	
	local elapsed = 0
	while elapsed < duration and currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing and isAllFarmRunning do
		task.wait(0.05)
		elapsed = elapsed + 0.05
	end
end

local function getCapacity()
	if player:GetAttribute("InfBackpack") == true then return (1 / 0) end
	local playerData = player:FindFirstChild("PlayerData")
	local realStats = playerData and playerData:FindFirstChild("RealStats")
	local carryWeight = realStats and realStats:FindFirstChild("CarryWeight")
	local baseWeight = carryWeight and carryWeight.Value or 10
	
	local gamepasses = player:FindFirstChild("GamepassesOwned")
	if gamepasses then
		local plus4 = gamepasses:FindFirstChild("CarryKgPlus4")
		if plus4 and plus4:IsA("BoolValue") and plus4.Value == true then baseWeight = baseWeight * 4 end
	end
	
	local bonus = realStats and realStats:FindFirstChild("CarryWeightBonus")
	local totalWeight = baseWeight + (bonus and bonus.Value or 0)
	return totalWeight
end

local function isBackpackFull()
	local totalCurrentWeight = 0
	local function scanContainer(container)
		if container then
			for _, item in ipairs(container:GetChildren()) do
				if item:IsA("Tool") and item:GetAttribute("Tier") ~= nil and item:GetAttribute("WeightKg") ~= nil then
					totalCurrentWeight = totalCurrentWeight + (item:GetAttribute("WeightKg") or 0)
				end
			end
		end
	end
	scanContainer(player:FindFirstChildOfClass("Backpack"))
	scanContainer(player.Character)
	
	local maxCapacity = getCapacity()
	if maxCapacity == (1 / 0) then return false end
	return totalCurrentWeight >= maxCapacity
end

local function isBackpackEmpty()
	local totalCurrentWeight = 0
	local function scanContainer(container)
		if container then
			for _, item in ipairs(container:GetChildren()) do
				if item:IsA("Tool") and item:GetAttribute("Tier") ~= nil and item:GetAttribute("WeightKg") ~= nil then
					totalCurrentWeight = totalCurrentWeight + (item:GetAttribute("WeightKg") or 0)
				end
			end
		end
	end
	scanContainer(player:FindFirstChildOfClass("Backpack"))
	scanContainer(player.Character)
	return totalCurrentWeight == 0
end

local function getCrystalValue(crystal)
	local val = crystal:GetAttribute("Value") or crystal:GetAttribute("Price") or crystal:GetAttribute("Worth") or crystal:GetAttribute("Tier")
	if val and tonumber(val) then return tonumber(val) end
	return 1
end

local function getAllCrystalsSorted()
	local crystals = {}
	local function isValidPosition(pos)
		if not pos then return false end
		if lastDropPosition and (pos - lastDropPosition).Magnitude <= BLACKLIST_RADIUS then return false end
		return true
	end
	
	local droppedCrystals = workspace:FindFirstChild("DroppedCrystals")
	if droppedCrystals then
		for _, crystal in ipairs(droppedCrystals:GetChildren()) do
			local part = crystal:IsA("Model") and (crystal.PrimaryPart or crystal:FindFirstChildWhichIsA("BasePart")) or crystal
			if part and part:IsA("BasePart") and isValidPosition(part.Position) then table.insert(crystals, crystal) end
		end
	end
	
	local things = workspace:FindFirstChild("Things")
	if things then
		local crystalsFolder = things:FindFirstChild("Crystals")
		if crystalsFolder then
			for _, crystal in ipairs(crystalsFolder:GetChildren()) do
				local part = crystal:IsA("Model") and (crystal.PrimaryPart or crystal:FindFirstChildWhichIsA("BasePart")) or crystal
				if part and part:IsA("BasePart") and isValidPosition(part.Position) then table.insert(crystals, crystal) end
			end
		end
	end
	
	table.sort(crystals, function(a, b) return getCrystalValue(a) > getCrystalValue(b) end)
	return crystals
end

local function dropAllCrystals()
	local container = player:FindFirstChild("Backpack") or player
	for _, item in ipairs(container:GetChildren()) do
		if string.find(item.Name:lower(), "kg") or string.find(item.Name, "%[") or string.find(item.Name:lower(), "berlian") then
			pcall(function() crystalDropRemote:FireServer(item.Name) end)
			task.wait(0.1)
		end
	end
end

task.spawn(function()
    while true do
        task.wait(0.3)
        if isAllFarmRunning and not isDropping then
            pcall(function()
                local character = player.Character
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                if not character or not character:FindFirstChild("HumanoidRootPart") or not hum or hum.Health <= 0 then return end
                local targetRadius = 45 
                
                for _, v in ipairs(workspace:GetDescendants()) do
                    if v:IsA("ProximityPrompt") then
                        local part = v.Parent
                        if part and part:IsA("BasePart") and part.Position then
                            local isBlacklisted = false
                            if lastDropPosition and (part.Position - lastDropPosition).Magnitude <= BLACKLIST_RADIUS then isBlacklisted = true end
                            
                            if not isBlacklisted then
                                local objectName = part.Name:lower()
                                local parentName = part.Parent and part.Parent.Name:lower() or ""
                                if objectName:find("crystal") or parentName:find("crystal") then
                                    local distance = (character.HumanoidRootPart.Position - part.Position).Magnitude
                                    if distance <= targetRadius then
                                        v.MaxActivationDistance = targetRadius
                                        v.HoldDuration = 0
                                        fireproximityprompt(v)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
	while true do
		if isAllFarmRunning then
			local character = player.Character
			local rootPart = character and character:FindFirstChild("HumanoidRootPart")
			local hum = character and character:FindFirstChildOfClass("Humanoid")
			
			if character and rootPart and hum and hum.Health > 0 then
				if isBackpackFull() then
					isDropping = true
					tweenTo(CFrame.new(targetPosition))
					
					if not isAllFarmRunning then break end
					if rootPart then lastDropPosition = rootPart.Position end
					
					while isAllFarmRunning do
						dropAllCrystals()
						task.wait(1)
						if isBackpackEmpty() then task.wait(0.5); break end
					end
					isDropping = false
				else
					local crystals = getAllCrystalsSorted()
					if #crystals > 0 then
						for _, crystal in ipairs(crystals) do
							if not isAllFarmRunning or isDropping then break end
							if isBackpackFull() then break end
							
							if crystal and crystal.Parent then
								local targetPart = crystal:IsA("Model") and crystal.PrimaryPart or crystal
								if not targetPart and crystal:IsA("Model") then targetPart = crystal:FindFirstChildWhichIsA("BasePart") end
								
								if targetPart and targetPart:IsA("BasePart") and targetPart.Position then
									if not lastDropPosition or (targetPart.Position - lastDropPosition).Magnitude > BLACKLIST_RADIUS then
										tweenTo(targetPart.CFrame + Vector3.new(0, 2, 0))
										
										while isAllFarmRunning and not isDropping and crystal and crystal.Parent do
											if isBackpackFull() then break end
											pcall(function()
												character:PivotTo(CFrame.new(targetPart.Position + Vector3.new(0, 2, 0)) * CFrame.Angles(0, rootPart.CFrame:ToEulerAnglesYXZ()))
											end)
											local prompt = crystal:FindFirstChildWhichIsA("ProximityPrompt", true)
											if prompt then fireproximityprompt(prompt) end
											task.wait(0.1)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		task.wait(0.5)
	end
end)

btnTerminus.MouseButton1Click:Connect(function()
	selectedToolName = (selectedToolName == "Terminus") and nil or "Terminus"
	refreshToolButtons()
	saveConfig()
end)

btnSledge.MouseButton1Click:Connect(function()
	selectedToolName = (selectedToolName == "Sledge Hammer") and nil or "Sledge Hammer"
	refreshToolButtons()
	saveConfig()
end)

btnAutoDig.MouseButton1Click:Connect(function()
	isAutoFarmRunning = not isAutoFarmRunning
	btnAutoDig.BackgroundColor3 = isAutoFarmRunning and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
	btnAutoDig.Text = isAutoFarmRunning and "Clear Map: ON" or "Clear Map: OFF"
	if isAutoFarmRunning and selectedToolName then equipSelectedTool() end
	saveConfig()
end)

toggleButton.MouseButton1Click:Connect(function()
	isAllFarmRunning = not isAllFarmRunning
	if isAllFarmRunning then
		toggleButton.Text = "All Farm: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
		isDropping = false
		enableNoclip()
		enableAntiGravity()
	else
		toggleButton.Text = "All Farm: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		isDropping = false
		lastDropPosition = nil
		disableNoclip()
		disableAntiGravity()
		if currentTween then currentTween:Cancel(); currentTween = nil end
	end
	saveConfig()
end)

if isAllFarmRunning then
	isDropping = false
	enableNoclip()
	enableAntiGravity()
end
