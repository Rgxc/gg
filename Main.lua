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
local selectedToolName = nil -- Default tidak ada tool yang dipilih (Hanya Tween)
local isListExpanded = false -- Status list tertutup/terbuka

-- Variabel Anti-Stuck (1.5 Detik)
local lastPosition = Vector3.new(0, 0, 0)
local stuckStartTime = tick()

-- Target material dengan CrackedLava di urutan paling atas
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
mainFrame.Size = UDim2.new(0, 120, 0, 56) -- Ukuran micro sangat kecil
mainFrame.Position = UDim2.new(0.02, 0, 0.30, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainFrame

-- Judul Panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 18)
titleLabel.Position = UDim2.new(0, 0, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 9
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Auto Mountain"
titleLabel.Parent = mainFrame

-- ================= TOMBOL AUTO FARM/DIG (ON/OFF) =================
local btnAutoDig = Instance.new("TextButton")
btnAutoDig.Name = "BtnAutoDig"
btnAutoDig.Size = UDim2.new(0, 104, 0, 20)
btnAutoDig.Position = UDim2.new(0, 8, 0, 20)
btnAutoDig.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (OFF)
btnAutoDig.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAutoDig.TextSize = 9
btnAutoDig.Font = Enum.Font.GothamBold
btnAutoDig.Text = "Auto: OFF"
btnAutoDig.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = btnAutoDig

-- ================= LIST PEMILIHAN TOOL (COLLAPSIBLE) =================
local toolListBtn = Instance.new("TextButton")
toolListBtn.Name = "ToolListBtn"
toolListBtn.Size = UDim2.new(1, -16, 0, 12)
toolListBtn.Position = UDim2.new(0, 8, 0, 42)
toolListBtn.BackgroundTransparency = 1
toolListBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
toolListBtn.TextSize = 8
toolListBtn.Font = Enum.Font.GothamBold
toolListBtn.Text = "Tool [+]"
toolListBtn.TextXAlignment = Enum.TextXAlignment.Left
toolListBtn.Parent = mainFrame

-- Tombol Pilihan: Terminus
local btnTerminus = Instance.new("TextButton")
btnTerminus.Name = "BtnTerminus"
btnTerminus.Size = UDim2.new(0, 104, 0, 18)
btnTerminus.Position = UDim2.new(0, 8, 0, 56)
btnTerminus.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTerminus.TextSize = 8
btnTerminus.Font = Enum.Font.GothamMedium
btnTerminus.Text = "Terminus"
btnTerminus.Visible = false
btnTerminus.Parent = mainFrame

local terminusCorner = Instance.new("UICorner")
terminusCorner.CornerRadius = UDim.new(0, 4)
terminusCorner.Parent = btnTerminus

-- Tombol Pilihan: Sledge Hammer
local btnSledge = Instance.new("TextButton")
btnSledge.Name = "BtnSledge"
btnSledge.Size = UDim2.new(0, 104, 0, 18)
btnSledge.Position = UDim2.new(0, 8, 0, 76)
btnSledge.TextColor3 = Color3.fromRGB(255, 255, 255)
btnSledge.TextSize = 8
btnSledge.Font = Enum.Font.GothamMedium
btnSledge.Text = "Sledge"
btnSledge.Visible = false
btnSledge.Parent = mainFrame

local sledgeCorner = Instance.new("UICorner")
sledgeCorner.CornerRadius = UDim.new(0, 4)
sledgeCorner.Parent = btnSledge

-- Event Klik untuk Membuka/Menutup List Tool
toolListBtn.MouseButton1Click:Connect(function()
	isListExpanded = not isListExpanded
	if isListExpanded then
		toolListBtn.Text = "Tool [-]"
		mainFrame.Size = UDim2.new(0, 120, 0, 100)
		btnTerminus.Visible = true
		btnSledge.Visible = true
	else
		toolListBtn.Text = "Tool [+]"
		mainFrame.Size = UDim2.new(0, 120, 0, 56)
		btnTerminus.Visible = false
		btnSledge.Visible = false
	end
end)

-- Fungsi memperbarui warna visual tombol tool (Aktif / Unselect)
local function refreshToolButtons()
	if selectedToolName == "Terminus" then
		btnTerminus.BackgroundColor3 = Color3.fromRGB(50, 150, 200) -- Biru (Aktif)
		btnSledge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	elseif selectedToolName == "Sledge Hammer" then
		btnTerminus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btnSledge.BackgroundColor3 = Color3.fromRGB(50, 150, 200) -- Biru (Aktif)
	else
		btnTerminus.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		btnSledge.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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

-- Fungsi equip tool pintar dengan pencarian fleksibel
local function equipSelectedTool()
	if not selectedToolName then return end
	
	local char, hum, _, bp = getCharacterParts()
	if not char or not hum or not bp then return end
	
	-- Cek apakah sudah di tangan karakter
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
	
	-- Cek di dalam Backpack menggunakan pencarian kata kunci
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

				-- FITUR ANTI-STUCK (1.5 Detik): Cek apakah posisi terjebak tidak berubah
				local currentPos = hrp.Position
				if (currentPos - lastPosition).Magnitude < 2 then
					if tick() - stuckStartTime > 1.5 then
						-- Jika terjebak selama > 1.5 detik, teleport sedikit ke atas & keluar dari halangan
						hrp.CFrame = CFrame.new(currentPos + Vector3.new(math.random(-15, 15), 25, math.random(-15, 15)))
						stuckStartTime = tick()
						return
					end
				else
					lastPosition = currentPos
					stuckStartTime = tick()
				end

				-- Equip tool jika ada yang dipilih
				if selectedToolName then
					equipSelectedTool()
				end

				-- Jalankan Tween pencari puncak gunung (Auto Mountain)
				local peakPos = findHighestMountainPeak()
				if peakPos then
					tweenToPosition(peakPos)
				end

				-- Kirim remote sesuai tool yang aktif
				if selectedToolName then
					local currentHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
					if currentHrp then
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

-- ================= EVENT LIST & TOMBOL UI =================
btnTerminus.MouseButton1Click:Connect(function()
	if selectedToolName == "Terminus" then
		selectedToolName = nil -- Unselect
	else
		selectedToolName = "Terminus"
	end
	refreshToolButtons()
end)

btnSledge.MouseButton1Click:Connect(function()
	if selectedToolName == "Sledge Hammer" then
		selectedToolName = nil -- Unselect
	else
		selectedToolName = "Sledge Hammer"
	end
	refreshToolButtons()
end)

btnAutoDig.MouseButton1Click:Connect(function()
	isAutoFarmRunning = not isAutoFarmRunning
	
	if isAutoFarmRunning then
		btnAutoDig.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
		btnAutoDig.Text = "Auto: ON"
		if selectedToolName then
			equipSelectedTool()
		end
	else
		btnAutoDig.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
		btnAutoDig.Text = "Auto: OFF"
	end
end)
