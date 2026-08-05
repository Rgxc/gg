-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remotes & Target Path (Auto Dig)
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local digRequest = remotes:WaitForChild("DigRequest")
local sledgeSwing = remotes:WaitForChild("SledgeSwing")

-- Konfigurasi State
local isAutoFarmRunning = false
local selectedToolName = "The Terminus" -- Default tool awal

-- Target material tanah gunung, batu, dan gunung salju / es
local TargetTerrainMaterials = {
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

-- Hapus GUI lama jika ada agar tidak menumpuk
if playerGui:FindFirstChild("AutoDigGui") then
	playerGui.AutoDigGui:Destroy()
end

-- Membuat ScreenGui Utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoDigGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ================= MAIN PANEL (CONTAINER) =================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 160)
mainFrame.Position = UDim2.new(0.02, 0, 0.30, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Judul Panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Auto Mountain & Tool"
titleLabel.Parent = mainFrame

-- ================= TOMBOL AUTO FARM/DIG (ON/OFF) =================
local btnAutoDig = Instance.new("TextButton")
btnAutoDig.Name = "BtnAutoDig"
btnAutoDig.Size = UDim2.new(0, 180, 0, 35)
btnAutoDig.Position = UDim2.new(0, 10, 0, 35)
btnAutoDig.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
btnAutoDig.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAutoDig.TextSize = 14
btnAutoDig.Font = Enum.Font.GothamBold
btnAutoDig.Text = "Auto Mountain: OFF"
btnAutoDig.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = btnAutoDig

-- ================= LIST PEMILIHAN TOOL =================
local toolListLabel = Instance.new("TextLabel")
toolListLabel.Size = UDim2.new(1, -20, 0, 20)
toolListLabel.Position = UDim2.new(0, 10, 0, 80)
toolListLabel.BackgroundTransparency = 1
toolListLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
toolListLabel.TextSize = 12
toolListLabel.Font = Enum.Font.GothamBold
toolListLabel.Text = "Pilih Tool:"
toolListLabel.TextXAlignment = Enum.TextXAlignment.Left
toolListLabel.Parent = mainFrame

-- Tombol Pilihan: The Terminus
local btnTerminus = Instance.new("TextButton")
btnTerminus.Name = "BtnTerminus"
btnTerminus.Size = UDim2.new(0, 180, 0, 28)
btnTerminus.Position = UDim2.new(0, 10, 0, 102)
btnTerminus.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTerminus.TextSize = 12
btnTerminus.Font = Enum.Font.GothamMedium
btnTerminus.Text = "The Terminus"
btnTerminus.Parent = mainFrame

local terminusCorner = Instance.new("UICorner")
terminusCorner.CornerRadius = UDim.new(0, 6)
terminusCorner.Parent = btnTerminus

-- Tombol Pilihan: Sledge Hammer
local btnSledge = Instance.new("TextButton")
btnSledge.Name = "BtnSledge"
btnSledge.Size = UDim2.new(0, 180, 0, 28)
btnSledge.Position = UDim2.new(0, 10, 0, 133)
btnSledge.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSledge.TextSize = 12
btnSledge.Font = Enum.Font.GothamMedium
btnSledge.Text = "Sledge Hammer"
btnSledge.Parent = mainFrame

local sledgeCorner = Instance.new("UICorner")
sledgeCorner.CornerRadius = UDim.new(0, 6)
sledgeCorner.Parent = btnSledge

-- Fungsi memperbarui warna visual tombol tool yang aktif
local function refreshToolButtons()
	if selectedToolName == "The Terminus" then
		btnTerminus.BackgroundColor3 = Color3.fromRGB(50, 150, 200) -- Biru (Aktif)
		btnSledge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)     -- Abu-abu (Mati)
	else
		btnTerminus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btnSledge.BackgroundColor3 = Color3.fromRGB(50, 150, 200) -- Biru (Aktif)
	end
end
refreshToolButtons()

-- Fungsi helper aman untuk mengambil bagian karakter
local function getCharacterParts()
	local char = player.Character
	if not char then return nil, nil, nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local bp = player:FindFirstChild("Backpack")
	return char, hum, hrp, bp
end

-- Fungsi equip tool pintar dengan dukungan aktivasi otomatis
local function equipSelectedTool()
	local char, hum, _, bp = getCharacterParts()
	if not char or not hum or not bp then return end
	
	if char:FindFirstChild(selectedToolName) then
		local activeTool = char:FindFirstChild(selectedToolName)
		pcall(function() activeTool:Activate() end)
		return
	end
	
	local tool = bp:FindFirstChild(selectedToolName)
	if not tool and selectedToolName == "Sledge Hammer" then
		for _, item in ipairs(bp:GetChildren()) do
			if item:IsA("Tool") then
				local name = item.Name:lower()
				if name:find("sledge") or name:find("hammer") or name:find("dig") or name:find("shovel") then
					tool = item
					break
				end
			end
		end
	end
	
	if tool and tool:IsA("Tool") then
		hum:EquipTool(tool)
		pcall(function() tool:Activate() end)
	end
end

-- ================= FUNGSI PENCARIAN PUNCAK TERTINGGI (PEAK CLIMBER) =================
local function findHighestMountainPeak()
	local _, _, hrp, _ = getCharacterParts()
	if not hrp then return nil end
	local rootPos = hrp.Position

	local bestPos = nil
	local highestY = -math.huge

	local yawAngles = {0, 45, 90, 135, 180, 225, 270, 315}
	local pitchAngles = {15, 35, 55}

	for _, yaw in ipairs(yawAngles) do
		for _, pitch in ipairs(pitchAngles) do
			local yawRad = math.rad(yaw)
			local pitchRad = math.rad(pitch)
			
			local horizontalDist = 200 * math.cos(pitchRad)
			local verticalDist = 200 * math.sin(pitchRad)
			
			local dir = Vector3.new(
				math.cos(yawRad) * horizontalDist,
				verticalDist,
				math.sin(yawRad) * horizontalDist
			)
			
			local rayParams = RaycastParams.new()
			rayParams.IgnoreWater = true
			
			local rayResult = workspace:Raycast(rootPos + Vector3.new(0, 3, 0), dir, rayParams)
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

	if not bestPos then
		local downRay = workspace:Raycast(rootPos + Vector3.new(0, 5, 0), Vector3.new(0, -150, 0), RaycastParams.new())
		if downRay and downRay.Material then
			for _, mat in ipairs(TargetTerrainMaterials) do
				if downRay.Material == mat then
					bestPos = downRay.Position
					break
				end
			end
		end
	end

	return bestPos
end

-- Fungsi Tween Aman dengan Timeout
local function tweenToPosition(targetPos)
	local _, hum, hrp, _ = getCharacterParts()
	if not hrp or not hum or hum.Health <= 0 then return end

	local distance = (hrp.Position - targetPos).Magnitude
	local speed = 140
	local timeTaken = math.clamp(distance / speed, 0.1, 2.5)

	local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))})
	
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

-- ================= LOGIKA UTAMA (AUTO MOUNTAIN & DIG) =================
task.spawn(function()
	while true do
		task.wait(0.2)
		if isAutoFarmRunning then
			pcall(function()
				local _, hum, hrp, _ = getCharacterParts()
				if not hrp or not hum or hum.Health <= 0 then 
					return 
				end

				equipSelectedTool()
				local peakPos = findHighestMountainPeak()
				
				if peakPos then
					tweenToPosition(peakPos)
				end

				local currentHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if currentHrp then
					local pos = currentHrp.Position
					local feetPos = pos - Vector3.new(0, 3, 0)
					if selectedToolName == "The Terminus" then
						digRequest:FireServer("The Terminus", vector.create(pos.X, pos.Y, pos.Z))
					elseif selectedToolName == "Sledge Hammer" then
						sledgeSwing:FireServer(vector.create(feetPos.X, feetPos.Y, feetPos.Z))
					end
				end
			end)
		end
	end
end)

-- ================= EVENT LIST & TOMBOL UI =================
btnTerminus.MouseButton1Click:Connect(function()
	selectedToolName = "The Terminus"
	refreshToolButtons()
	if isAutoFarmRunning then
		equipSelectedTool()
	end
end)

btnSledge.MouseButton1Click:Connect(function()
	selectedToolName = "Sledge Hammer"
	refreshToolButtons()
	if isAutoFarmRunning then
		equipSelectedTool()
	end
end)

btnAutoDig.MouseButton1Click:Connect(function()
	isAutoFarmRunning = not isAutoFarmRunning
	
	if isAutoFarmRunning then
		btnAutoDig.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
		btnAutoDig.Text = "Auto Mountain: ON"
		equipSelectedTool()
	else
		btnAutoDig.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
		btnAutoDig.Text = "Auto Mountain: OFF"
	end
end)
