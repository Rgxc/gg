-- ====================================================================
-- Mine A Mountain | Rgx Hub (Full Fixed Version - Auto Dig, Auto Low Server, ESP InstantMine & Clear Mountain)
-- ====================================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ====================================================================
-- SISTEM CONFIG (SAVE & LOAD)
-- ====================================================================
local CONFIG_FILE = "RgxHub_Config.json"

local Config = {
	AutoDrop = false,
	InstanMineCrystal = false,
	AutoSell = false,
	NocturniteFarm = false,
	CollectRune = false,
	MutasiTerminus = false,
	NocturniteESP = false,
	InstanMineESP = false,
	FastDig = false,
	DropRune = false,
	FarmingCrystal = false,
	CrystalMutasiTerminus = false,
	AutoDigMisc = true,
	AutoDigDuration = "60s",
	InfinityJump = false,
	AutoLowServer = false,
	HopDelay = "60s",
	OtomatisMinimize = true,
	ClearMountain = false,
	ClearMountainTool = "The Terminus"
}

local function saveConfig()
	pcall(function()
		local encoded = HttpService:JSONEncode(Config)
		writefile(CONFIG_FILE, encoded)
	end)
end

local function loadConfig()
	pcall(function()
		if isfile and isfile(CONFIG_FILE) then
			local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
			for k, v in pairs(decoded) do
				Config[k] = v
			end
		end
	end)
end

loadConfig()
Config.AutoDigMisc = true
saveConfig()

if CoreGui:FindFirstChild("FarmCrystalGUI") then
	CoreGui.FarmCrystalGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FarmCrystalGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "M"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 18

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(55, 55, 70)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = ToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Position = UDim2.new(0, 62, 0, 10)
MainFrame.Size = UDim2.new(0, 240, 0, 275)
MainFrame.Visible = not Config.OtomatisMinimize

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 32)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local FixCorner = Instance.new("Frame")
FixCorner.Parent = TopBar
FixCorner.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
FixCorner.BorderSizePixel = 0
FixCorner.Position = UDim2.new(0, 0, 1, -5)
FixCorner.Size = UDim2.new(1, 0, 0, 5)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(1, -12, 1, 0)
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.Text = "Mine A Mountain | Rgx Hub"
TitleLabel.TextColor3 = Color3.fromRGB(190, 190, 210)
TitleLabel.TextSize = 11
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local HeaderDivider = Instance.new("Frame")
HeaderDivider.Parent = MainFrame
HeaderDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
HeaderDivider.BorderSizePixel = 0
HeaderDivider.Position = UDim2.new(0, 0, 0, 32)
HeaderDivider.Size = UDim2.new(1, 0, 0, 1)

local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 8, 0, 42)
Sidebar.Size = UDim2.new(0, 75, 1, -50)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.ScrollBarThickness = 0

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Parent = Sidebar
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Padding = UDim.new(0, 4)

local ContentDivider = Instance.new("Frame")
ContentDivider.Parent = MainFrame
ContentDivider.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
ContentDivider.BorderSizePixel = 0
ContentDivider.Position = UDim2.new(0, 90, 0, 33)
ContentDivider.Size = UDim2.new(0, 1, 1, -33)

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = MainFrame

local function createPageContainer()
	local container = Instance.new("ScrollingFrame")
	container.Parent = PagesFolder
	container.BackgroundTransparency = 1
	container.Position = UDim2.new(0, 98, 0, 42)
	container.Size = UDim2.new(1, -106, 1, -50)
	container.CanvasSize = UDim2.new(0, 0, 0, 620)
	container.ScrollBarThickness = 2
	container.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)
	container.Visible = false
	
	local layout = Instance.new("UIListLayout")
	layout.Parent = container
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	
	return container
end

local MiningPage = createPageContainer()
MiningPage.Visible = true

local ESPPage = createPageContainer()
local RunePage = createPageContainer()
local MiscPage = createPageContainer()
local RejoinPage = createPageContainer()

local function createCategoryLabel(parent, text)
	local lbl = Instance.new("TextLabel")
	lbl.Parent = parent
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, 0, 0, 16)
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(140, 140, 165)
	lbl.TextSize = 9
	lbl.TextXAlignment = Enum.TextXAlignment.Left
end

createCategoryLabel(MiningPage, "Autopilot / Actions")
createCategoryLabel(ESPPage, "Visual / ESP")
createCategoryLabel(RunePage, "Rune Management")
createCategoryLabel(MiscPage, "Miscellaneous")
createCategoryLabel(RejoinPage, "Server Controls")

local function createToggleFeature(parent, labelText)
	local container = Instance.new("TextButton")
	container.Parent = parent
	container.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	container.Size = UDim2.new(1, -8, 0, 32)
	container.AutoButtonColor = false
	container.Text = ""
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = container
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(45, 45, 60)
	stroke.Thickness = 1
	stroke.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 8, 0, 0)
	label.Size = UDim2.new(1, -45, 1, 0)
	label.Font = Enum.Font.GothamMedium
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(220, 220, 235)
	label.TextSize = 9
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	local switchBg = Instance.new("Frame")
	switchBg.Name = "SwitchBg"
	switchBg.Parent = container
	switchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	switchBg.Position = UDim2.new(1, -38, 0.5, -10)
	switchBg.Size = UDim2.new(0, 32, 0, 20)
	
	local switchCorner = Instance.new("UICorner")
	switchCorner.CornerRadius = UDim.new(1, 0)
	switchCorner.Parent = switchBg
	
	local switchCircle = Instance.new("Frame")
	switchCircle.Name = "SwitchCircle"
	switchCircle.Parent = switchBg
	switchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 170)
	switchCircle.Position = UDim2.new(0, 2, 0.5, -8)
	switchCircle.Size = UDim2.new(0, 16, 0, 16)
	
	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = switchCircle
	
	return container, switchBg, switchCircle
end

local Btn1, Bg1, Circle1 = createToggleFeature(MiningPage, "Auto Drop")
local BtnInstanMine, BgInstanMine, CircleInstanMine = createToggleFeature(MiningPage, "Instan Mine Crystal")
local Btn3, Bg3, Circle3 = createToggleFeature(MiningPage, "Auto Sell")
local BtnFarmingCrystal, BgFarmingCrystal, CircleFarmingCrystal = createToggleFeature(MiningPage, "Farming Crystal")
local BtnCrystalTerminus, BgCrystalTerminus, CircleCrystalTerminus = createToggleFeature(MiningPage, "Crystal Mutasi Terminus")
local BtnNocturnite, BgNocturnite, CircleNocturnite = createToggleFeature(MiningPage, "Nocturnite Farm")
local BtnRune, BgRune, CircleRune = createToggleFeature(MiningPage, "Collect Rune")

-- ====================================================================
-- CLEAR MOUNTAIN INTEGRATION (MINING PAGE)
-- ====================================================================
createCategoryLabel(MiningPage, "Clear Mountain / Auto Dig")

local BtnClearMountain, BgClearMountain, CircleClearMountain = createToggleFeature(MiningPage, "Auto Mountain")

local ClearToolDropdownBtn = Instance.new("TextButton")
ClearToolDropdownBtn.Parent = MiningPage
ClearToolDropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
ClearToolDropdownBtn.Size = UDim2.new(1, -8, 0, 32)
ClearToolDropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
ClearToolDropdownBtn.Text = "  Tool: " .. (Config.ClearMountainTool or "The Terminus") .. " ▼"
ClearToolDropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
ClearToolDropdownBtn.TextSize = 9
ClearToolDropdownBtn.Font = Enum.Font.GothamMedium
ClearToolDropdownBtn.AutoButtonColor = false

local ClearToolCorner = Instance.new("UICorner") ClearToolCorner.CornerRadius = UDim.new(0, 6) ClearToolCorner.Parent = ClearToolDropdownBtn
local ClearToolStroke = Instance.new("UIStroke") ClearToolStroke.Color = Color3.fromRGB(45, 45, 60) ClearToolStroke.Thickness = 1 ClearToolStroke.Parent = ClearToolDropdownBtn

local ClearToolScrollingFrame = Instance.new("ScrollingFrame")
ClearToolScrollingFrame.Parent = MiningPage
ClearToolScrollingFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
ClearToolScrollingFrame.Size = UDim2.new(1, -8, 0, 64)
ClearToolScrollingFrame.BorderSizePixel = 0
ClearToolScrollingFrame.Visible = false
ClearToolScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 60)
ClearToolScrollingFrame.ScrollBarThickness = 2
ClearToolScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

local ClearToolUIListLayout = Instance.new("UIListLayout")
ClearToolUIListLayout.Parent = ClearToolScrollingFrame
ClearToolUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ClearToolUIListLayout.Padding = UDim.new(0, 3)

local selectedClearTool = Config.ClearMountainTool or "The Terminus"
local isAutoMountainRunning = Config.ClearMountain or false

local function createClearToolOption(toolName)
	local optBtn = Instance.new("TextButton")
	optBtn.Parent = ClearToolScrollingFrame
	optBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	optBtn.Size = UDim2.new(1, -4, 0, 28)
	optBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	optBtn.Text = "  " .. toolName
	optBtn.TextXAlignment = Enum.TextXAlignment.Left
	optBtn.TextSize = 9
	optBtn.Font = Enum.Font.Gotham
	local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = optBtn
	optBtn.MouseButton1Click:Connect(function()
		selectedClearTool = toolName
		Config.ClearMountainTool = selectedClearTool
		saveConfig()
		ClearToolDropdownBtn.Text = "  Tool: " .. selectedClearTool .. " ▼"
		ClearToolScrollingFrame.Visible = false
	end)
end

createClearToolOption("The Terminus")
createClearToolOption("Sledge Hammer")

local isClearToolDropdownOpen = false
ClearToolDropdownBtn.MouseButton1Click:Connect(function()
	isClearToolDropdownOpen = not isClearToolDropdownOpen
	ClearToolScrollingFrame.Visible = isClearToolDropdownOpen
end)

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

local function getCharacterPartsForMountain()
	local char = player.Character
	if not char then return nil, nil, nil, nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local bp = player:FindFirstChild("Backpack")
	return char, hum, hrp, bp
end

local function equipClearTool()
	local char, hum, _, bp = getCharacterPartsForMountain()
	if not char or not hum or not bp then return end
	
	if char:FindFirstChild(selectedClearTool) then
		local activeTool = char:FindFirstChild(selectedClearTool)
		pcall(function() activeTool:Activate() end)
		return
	end
	
	local tool = bp:FindFirstChild(selectedClearTool)
	if not tool and selectedClearTool == "Sledge Hammer" then
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

local function findHighestMountainPeak()
	local _, _, hrp, _ = getCharacterPartsForMountain()
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

local function tweenToMountainPosition(targetPos)
	local _, hum, hrp, _ = getCharacterPartsForMountain()
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
		local _, currentHum, currentHrp = getCharacterPartsForMountain()
		if tick() - startTime > timeTaken + 1 or not currentHrp or not currentHum or currentHum.Health <= 0 then
			tween:Cancel()
			break
		end
	end
end

task.spawn(function()
	local digReq = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DigRequest")
	local sledgeSwing = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SledgeSwing")
	while true do
		task.wait(0.2)
		if isAutoMountainRunning then
			pcall(function()
				local _, hum, hrp, _ = getCharacterPartsForMountain()
				if not hrp or not hum or hum.Health <= 0 then return end

				equipClearTool()
				local peakPos = findHighestMountainPeak()
				
				if peakPos then
					tweenToMountainPosition(peakPos)
				end

				local currentHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if currentHrp then
					local pos = currentHrp.Position
					local feetPos = pos - Vector3.new(0, 3, 0)
					if selectedClearTool == "The Terminus" then
						digReq:FireServer("The Terminus", vector.create(pos.X, pos.Y, pos.Z))
					elseif selectedClearTool == "Sledge Hammer" and sledgeSwing then
						sledgeSwing:FireServer(vector.create(feetPos.X, feetPos.Y, feetPos.Z))
					end
				end
			end)
		end
	end
end)

BtnClearMountain.MouseButton1Click:Connect(function()
	isAutoMountainRunning = not isAutoMountainRunning
	Config.ClearMountain = isAutoMountainRunning
	saveConfig()
	setToggleState(BgClearMountain, CircleClearMountain, isAutoMountainRunning)
	if isAutoMountainRunning then
		equipClearTool()
	end
end)
-- ====================================================================

local BtnESP1, BgESP1, CircleESP1 = createToggleFeature(ESPPage, "Mutasi Terminus")
local BtnESP2, BgESP2, CircleESP2 = createToggleFeature(ESPPage, "Nocturnite")
local BtnInstanMineESP, BgInstanMineESP, CircleInstanMineESP = createToggleFeature(ESPPage, "Instan Mine")
local BtnFastDig, BgFastDig, CircleFastDig = createToggleFeature(ESPPage, "Fast Dig")

local runeList = {
	"Weight Rune", "Detonation Rune", "Preservation Rune", "Colossus Rune",
	"Haste Rune", "Warmth Rune", "Luck Rune", "Excavator Rune", "Fortune Rune", "Storm Rune"
}

local selectedRunes = {}
local isDropRuneRunning = false
local isDropdownOpen = false

local DropRuneContainer = Instance.new("Frame")
DropRuneContainer.Parent = RunePage
DropRuneContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
DropRuneContainer.Size = UDim2.new(1, -8, 0, 32)
DropRuneContainer.BorderSizePixel = 0

local DropRuneCorner = Instance.new("UICorner") DropRuneCorner.CornerRadius = UDim.new(0, 6) DropRuneCorner.Parent = DropRuneContainer
local DropRuneStroke = Instance.new("UIStroke") DropRuneStroke.Color = Color3.fromRGB(45, 45, 60) DropRuneStroke.Thickness = 1 DropRuneStroke.Parent = DropRuneContainer

local DropRuneLabel = Instance.new("TextLabel")
DropRuneLabel.Parent = DropRuneContainer
DropRuneLabel.BackgroundTransparency = 1
DropRuneLabel.Position = UDim2.new(0, 8, 0, 0)
DropRuneLabel.Size = UDim2.new(1, -45, 1, 0)
DropRuneLabel.Font = Enum.Font.GothamMedium
DropRuneLabel.Text = "Drop Rune"
DropRuneLabel.TextColor3 = Color3.fromRGB(220, 220, 235)
DropRuneLabel.TextSize = 9
DropRuneLabel.TextXAlignment = Enum.TextXAlignment.Left

local DropSwitchBg = Instance.new("TextButton")
DropSwitchBg.Size = UDim2.new(0, 32, 0, 20)
DropSwitchBg.Position = UDim2.new(1, -38, 0.5, -10)
DropSwitchBg.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
DropSwitchBg.Text = ""
DropSwitchBg.AutoButtonColor = false
DropSwitchBg.Parent = DropRuneContainer

local DropSwitchBgCorner = Instance.new("UICorner") DropSwitchBgCorner.CornerRadius = UDim.new(1, 0) DropSwitchBgCorner.Parent = DropSwitchBg
local DropSwitchCircle = Instance.new("Frame") DropSwitchCircle.Size = UDim2.new(0, 16, 0, 16) DropSwitchCircle.Position = UDim2.new(0, 2, 0.5, -8) DropSwitchCircle.BackgroundColor3 = Color3.fromRGB(150, 150, 170) DropSwitchCircle.BorderSizePixel = 0 DropSwitchCircle.Parent = DropSwitchBg
local DropSwitchCircleCorner = Instance.new("UICorner") DropSwitchCircleCorner.CornerRadius = UDim.new(1, 0) DropSwitchCircleCorner.Parent = DropSwitchBg

local DropdownButton = Instance.new("TextButton")
DropdownButton.Parent = RunePage
DropdownButton.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
DropdownButton.Size = UDim2.new(1, -8, 0, 32)
DropdownButton.TextColor3 = Color3.fromRGB(220, 220, 235)
DropdownButton.Text = "  Select Runes ▼"
DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
DropdownButton.TextSize = 9
DropdownButton.Font = Enum.Font.GothamMedium
DropdownButton.AutoButtonColor = false

local DropdownCorner = Instance.new("UICorner") DropdownCorner.CornerRadius = UDim.new(0, 6) DropdownCorner.Parent = DropdownButton
local DropdownStroke = Instance.new("UIStroke") DropdownStroke.Color = Color3.fromRGB(45, 45, 60) DropdownStroke.Thickness = 1 DropdownStroke.Parent = DropdownButton

local RuneScrollingFrame = Instance.new("ScrollingFrame")
RuneScrollingFrame.Parent = RunePage
RuneScrollingFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
RuneScrollingFrame.Size = UDim2.new(1, -8, 0, 130)
RuneScrollingFrame.BorderSizePixel = 0
RuneScrollingFrame.Visible = false
RuneScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #runeList * 28)
RuneScrollingFrame.ScrollBarThickness = 2
RuneScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

local RuneUIListLayout = Instance.new("UIListLayout")
RuneUIListLayout.Parent = RuneScrollingFrame
RuneUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
RuneUIListLayout.Padding = UDim.new(0, 3)

for _, runeName in ipairs(runeList) do
	selectedRunes[runeName] = false
	local ItemButton = Instance.new("TextButton")
	ItemButton.Parent = RuneScrollingFrame
	ItemButton.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	ItemButton.Size = UDim2.new(1, -4, 0, 24)
	ItemButton.TextColor3 = Color3.fromRGB(180, 180, 195)
	ItemButton.Text = "  [ ] " .. runeName
	ItemButton.TextXAlignment = Enum.TextXAlignment.Left
	ItemButton.TextSize = 9
	ItemButton.Font = Enum.Font.Gotham
	
	local ItemCorner = Instance.new("UICorner") ItemCorner.CornerRadius = UDim.new(0, 4) ItemCorner.Parent = ItemButton
	
	ItemButton.MouseButton1Click:Connect(function()
		selectedRunes[runeName] = not selectedRunes[runeName]
		if selectedRunes[runeName] then
			ItemButton.Text = "  [✓] " .. runeName
			ItemButton.TextColor3 = Color3.fromRGB(80, 255, 150)
			ItemButton.BackgroundColor3 = Color3.fromRGB(38, 50, 42)
		else
			ItemButton.Text = "  [ ] " .. runeName
			ItemButton.TextColor3 = Color3.fromRGB(180, 180, 195)
			ItemButton.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
		end
	end)
end

local function updateDropRuneToggle()
	local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	if isDropRuneRunning then
		TweenService:Create(DropSwitchBg, info, {BackgroundColor3 = Color3.fromRGB(50, 140, 80)}):Play()
		TweenService:Create(DropSwitchCircle, info, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	else
		TweenService:Create(DropSwitchBg, info, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
		TweenService:Create(DropSwitchCircle, info, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 170)}):Play()
	end
end

DropdownButton.MouseButton1Click:Connect(function()
	isDropdownOpen = not isDropdownOpen
	RuneScrollingFrame.Visible = isDropdownOpen
end)

DropSwitchBg.MouseButton1Click:Connect(function()
	isDropRuneRunning = not isDropRuneRunning
	Config.DropRune = isDropRuneRunning
	saveConfig()
	updateDropRuneToggle()
end)

local crystalDropRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CrystalDropRequest")
task.spawn(function()
	while true do
		if isDropRuneRunning and crystalDropRemote then
			for runeName, isSelected in pairs(selectedRunes) do
				if isSelected and isDropRuneRunning then
					pcall(function()
						crystalDropRemote:FireServer(runeName)
					end)
				end
			end
		end
		task.wait(1)
	end
end)

local function createActionButton(parent, labelText, callback)
	local container = Instance.new("TextButton")
	container.Parent = parent
	container.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
	container.Size = UDim2.new(1, -8, 0, 32)
	container.AutoButtonColor = true
	container.Text = ""
	
	local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = container
	local stroke = Instance.new("UIStroke") stroke.Color = Color3.fromRGB(45, 45, 60) stroke.Thickness = 1 stroke.Parent = container
	
	local label = Instance.new("TextLabel")
	label.Parent = container
	label.BackgroundTransparency = 1
	label.Position = UDim2.new(0, 8, 0, 0)
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Font = Enum.Font.GothamBold
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(255, 100, 100)
	label.TextSize = 10
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	container.MouseButton1Click:Connect(callback)
	return container
end

createActionButton(RejoinPage, "Rejoin Server (Safe)", function()
	pcall(function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
end)

local function setToggleState(bg, circle, state, instant)
	local tweenInfo = TweenInfo.new(instant and 0 or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	if state then
		TweenService:Create(bg, tweenInfo, {BackgroundColor3 = Color3.fromRGB(50, 140, 80)}):Play()
		TweenService:Create(circle, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	else
		TweenService:Create(bg, tweenInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
		TweenService:Create(circle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Color3.fromRGB(150, 150, 170)}):Play()
	end
end

local function createSidebarButton(name, pageContainer, isActive)
	local btn = Instance.new("TextButton")
	btn.Parent = Sidebar
	btn.BackgroundColor3 = isActive and Color3.fromRGB(35, 35, 48) or Color3.fromRGB(24, 24, 30)
	btn.Size = UDim2.new(1, 0, 0, 26)
	btn.Font = Enum.Font.GothamMedium
	btn.Text = "  " .. name
	btn.TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 170)
	btn.TextSize = 10
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	
	local corner = Instance.new("UICorner") corner.CornerRadius = UDim.new(0, 6) corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		for _, child in ipairs(Sidebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
				child.TextColor3 = Color3.fromRGB(150, 150, 170)
			end
		end
		for _, page in ipairs(PagesFolder:GetChildren()) do
			if page:IsA("ScrollingFrame") then
				page.Visible = false
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		pageContainer.Visible = true
	end)
	
	return btn
end

createSidebarButton("Mining", MiningPage, true)
createSidebarButton("ESP", ESPPage, false)
createSidebarButton("Rune", RunePage, false)
createSidebarButton("Misc", MiscPage, false)
createSidebarButton("Rejoin", RejoinPage, false)

local isOpen = not Config.OtomatisMinimize
ToggleBtn.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	MainFrame.Visible = isOpen
end)

-- ====================================================================
-- MINING & FARMING CRYSTAL / MUTASI TERMINUS / COLLECT RUNE
-- ====================================================================
local remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CrystalDropRequest")

local isAutoDropRunning = false
local function runAutoDrop()
	while isAutoDropRunning do
		local inventory = player:FindFirstChild("Inventory") 
			or player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("Inventory")
			or player:FindFirstChild("Backpack")

		if inventory then
			for _, item in ipairs(inventory:GetDescendants()) do
				if not isAutoDropRunning then break end
				if item:IsA("TextButton") or item:IsA("Frame") or item:IsA("Model") or item:IsA("IntValue") or item:IsA("StringValue") then
					local itemName = item.Name
					if string.match(itemName, "%[.*kg%]") or string.match(itemName, "%[S%]") then
						remote:FireServer(itemName)
						task.wait(0.15)
					end
				end
			end
		end
		task.wait(1) 
	end
end

Btn1.MouseButton1Click:Connect(function()
	isAutoDropRunning = not isAutoDropRunning
	Config.AutoDrop = isAutoDropRunning
	saveConfig()
	setToggleState(Bg1, Circle1, isAutoDropRunning)
	if isAutoDropRunning then task.spawn(runAutoDrop) end
end)

local isInstanMineRunning = false
task.spawn(function()
    while task.wait(0.3) do
        if isInstanMineRunning then
            pcall(function()
                local player = game.Players.LocalPlayer
                local character = player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local targetRadius = 100 
                local rootPos = character.HumanoidRootPart.Position

                local function isValidCrystalPrompt(prompt)
                    local parent = prompt.Parent
                    local ancestor = parent
                    
                    while ancestor and ancestor ~= workspace do
                        local name = ancestor.Name
                        if name == "Crystals" or name == "DroppedCrystals" then
                            return true
                        end
                        ancestor = ancestor.Parent
                    end
                    return false
                end

                local function checkAndFire(v)
                    if v:IsA("ProximityPrompt") and isValidCrystalPrompt(v) then
                        local parent = v.Parent
                        local targetPos = nil

                        if parent then
                            if parent:IsA("BasePart") then
                                targetPos = parent.Position
                            elseif parent:IsA("Model") then
                                local primary = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart", true)
                                if primary then
                                    targetPos = primary.Position
                                end
                            end
                        end

                        if targetPos then
                            local distance = (rootPos - targetPos).Magnitude
                            if distance <= targetRadius then
                                v.MaxActivationDistance = targetRadius
                                v.HoldDuration = 0
                                fireproximityprompt(v)
                            end
                        end
                    end
                end

                local things = workspace:FindFirstChild("Things")
                local crystalsFolder = things and things:FindFirstChild("Crystals")
                local droppedFolder = workspace:FindFirstChild("DroppedCrystals")

                if crystalsFolder then
                    for _, v in ipairs(crystalsFolder:GetDescendants()) do
                        checkAndFire(v)
                    end
                end

                if droppedFolder then
                    for _, v in ipairs(droppedFolder:GetDescendants()) do
                        checkAndFire(v)
                    end
                end
            end)
        end
    end
end)

BtnInstanMine.MouseButton1Click:Connect(function()
	isInstanMineRunning = not isInstanMineRunning
	Config.InstanMineCrystal = isInstanMineRunning
	saveConfig()
	setToggleState(BgInstanMine, CircleInstanMine, isInstanMineRunning)
end)

local function getRootPart()
	local character = player.Character or player.CharacterAdded:Wait()
	return character:FindFirstChild("HumanoidRootPart")
end

local function executeSell()
	pcall(function()
		local rootPart = getRootPart()
		if not rootPart then return end
		local originalCFrame = rootPart.CFrame
		local remotes = ReplicatedStorage:FindFirstChild("Remotes")
		if remotes then
			local goHome = remotes:FindFirstChild("GoHome")
			if goHome then goHome:FireServer("sell") end
			task.wait(0.6)
			local sellReq = remotes:FindFirstChild("SellRequest")
			if sellReq then sellReq:FireServer("all") end
			task.wait(0.6)
			local currentRoot = getRootPart()
			if currentRoot then currentRoot.CFrame = originalCFrame end
		end
	end)
end

local function isBackpackFull()
	local playerGui = player:FindFirstChild("PlayerGui")
	if not playerGui then return false end
	for _, gui in ipairs(playerGui:GetDescendants()) do
		if gui:IsA("TextLabel") or gui:IsA("TextButton") then
			local text = string.lower(gui.Text)
			if text:find("full") then return true end
			local current, max = text:match("(%d+)%s*/%s*(%d+)")
			if current and max and tonumber(current) >= tonumber(max) then return true end
		end
	end
	return false
end

local isSellRunning = false
task.spawn(function()
	local isSelling = false
	while true do
		task.wait(1)
		if isSellRunning and not isSelling and isBackpackFull() then
			isSelling = true
			executeSell()
			task.wait(10)
			isSelling = false
		end
	end
end)

Btn3.MouseButton1Click:Connect(function()
	isSellRunning = not isSellRunning
	Config.AutoSell = isSellRunning
	saveConfig()
	setToggleState(Bg3, Circle3, isSellRunning)
end)

-- Farming Crystal Logic
local isFarmingCrystalRunning = false
local noclipConnectionCrystal
local gravityConnectionCrystal
local currentTweenCrystal = nil
local TWEEN_SPEED_CRYSTAL = 100

local function tweenToCrystal(targetCFrame)
    if currentTweenCrystal then
        currentTweenCrystal:Cancel()
        currentTweenCrystal = nil
    end

    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    if distance < 1 then return end
    
    local duration = distance / TWEEN_SPEED_CRYSTAL
    local adjustedCFrame = CFrame.new(targetCFrame.Position) * rootPart.CFrame.Rotation
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentTweenCrystal = TweenService:Create(rootPart, tweenInfo, {CFrame = adjustedCFrame})
    
    currentTweenCrystal:Play()
    
    local elapsed = 0
    while elapsed < duration and currentTweenCrystal and currentTweenCrystal.PlaybackState == Enum.PlaybackState.Playing do
        if not isFarmingCrystalRunning then
            currentTweenCrystal:Cancel()
            break
        end
        task.wait(0.05)
        elapsed = elapsed + 0.05
    end
end

local function getCrystalValue(crystal)
    local val = crystal:GetAttribute("Value") or crystal:GetAttribute("Price") or crystal:GetAttribute("Worth") or crystal:GetAttribute("Tier")
    if val and tonumber(val) then
        return tonumber(val)
    end
    
    for _, child in ipairs(crystal:GetChildren()) do
        if (child:IsA("IntValue") or child:IsA("NumberValue")) and (child.Name:lower():find("value") or child.Name:lower():find("price") or child.Name:lower():find("worth")) then
            return child.Value
        end
    end
    
    local name = crystal.Name:lower()
    if name:find("diamond") or name:find("rainbow") or name:find("mythic") then
        return 1000
    elseif name:find("gold") or name:find("epic") then
        return 500
    elseif name:find("silver") or name:find("rare") then
        return 100
    end
    
    return 1
end

local function getAllCrystalsSorted()
    local crystals = {}
    local droppedCrystals = Workspace:FindFirstChild("DroppedCrystals")
    if droppedCrystals then
        for _, crystal in ipairs(droppedCrystals:GetChildren()) do
            table.insert(crystals, crystal)
        end
    end
    
    local things = Workspace:FindFirstChild("Things")
    if things then
        local crystalsFolder = things:FindFirstChild("Crystals")
        if crystalsFolder then
            for _, crystal in ipairs(crystalsFolder:GetChildren()) do
                table.insert(crystals, crystal)
            end
        end
    end
    
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name:lower():find("crystal") then
            local alreadyAdded = false
            for _, c in ipairs(crystals) do
                if c == obj then
                    alreadyAdded = true
                    break
                end
            end
            if not alreadyAdded then
                table.insert(crystals, obj)
            end
        end
    end
    
    table.sort(crystals, function(a, b)
        return getCrystalValue(a) > getCrystalValue(b)
    end)
    
    return crystals
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if isFarmingCrystalRunning then
            pcall(function()
                local char = player.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end

                local crystals = getAllCrystalsSorted()
                if #crystals > 0 then
                    for _, crystal in ipairs(crystals) do
                        if not isFarmingCrystalRunning then break end
                        if crystal and crystal.Parent then
                            local targetPart = crystal:IsA("Model") and crystal.PrimaryPart or crystal
                            if not targetPart and crystal:IsA("Model") then
                                targetPart = crystal:FindFirstChildWhichIsA("BasePart")
                            end
                            if not targetPart and crystal:IsA("BasePart") then
                                targetPart = crystal
                            end
                            
                            if targetPart and targetPart:IsA("BasePart") then
                                tweenToCrystal(targetPart.CFrame)
                                if not isFarmingCrystalRunning then break end
                                
                                local startTime = tick()
                                while crystal and crystal.Parent and (tick() - startTime < 4) and isFarmingCrystalRunning do
                                    rootPart.CFrame = CFrame.new(targetPart.Position) * rootPart.CFrame.Rotation
                                    
                                    local prompt = crystal:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then
                                        prompt.MaxActivationDistance = 99999
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                    end
                                    
                                    if firetouchinterest then
                                        firetouchinterest(rootPart, targetPart, 0)
                                        task.wait(0.05)
                                        firetouchinterest(rootPart, targetPart, 1)
                                    end
                                    
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

BtnFarmingCrystal.MouseButton1Click:Connect(function()
    isFarmingCrystalRunning = not isFarmingCrystalRunning
    Config.FarmingCrystal = isFarmingCrystalRunning
    saveConfig()
    setToggleState(BgFarmingCrystal, CircleFarmingCrystal, isFarmingCrystalRunning)
    
    if isFarmingCrystalRunning then
        noclipConnectionCrystal = RunService.Stepped:Connect(function()
            local char = player.Character
            if char and char.Parent then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        gravityConnectionCrystal = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Parent then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if currentTweenCrystal then
            currentTweenCrystal:Cancel()
            currentTweenCrystal = nil
        end
        if noclipConnectionCrystal then noclipConnectionCrystal:Disconnect() noclipConnectionCrystal = nil end
        if gravityConnectionCrystal then gravityConnectionCrystal:Disconnect() gravityConnectionCrystal = nil end
        
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end
end)

-- Crystal Mutasi Terminus Logic
local isCrystalTerminusRunning = false
local noclipConnectionTerminus
local gravityConnectionTerminus
local currentTweenTerminus = nil
local TWEEN_SPEED_TERMINUS = 100

local function equipPickaxeTerminus()
    pcall(function()
        local backpack = player:FindFirstChild("Backpack")
        local char = player.Character
        if not backpack or not char then return end
        
        local alreadyEquipped = false
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item.Name:lower():find("pickaxe") or item.Name:lower():find("terminus")) then
                alreadyEquipped = true
                break
            end
        end
        
        if not alreadyEquipped then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") and (item.Name:lower():find("pickaxe") or item.Name:lower():find("terminus")) then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:EquipTool(item)
                        task.wait(0.1)
                    end
                    break
                end
            end
        end
    end)
end

local function tweenToTerminus(targetCFrame)
    if currentTweenTerminus then
        currentTweenTerminus:Cancel()
        currentTweenTerminus = nil
    end

    local char = player.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    if distance < 1 then return end
    
    local duration = distance / TWEEN_SPEED_TERMINUS
    local adjustedCFrame = CFrame.new(targetCFrame.Position) * rootPart.CFrame.Rotation
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    currentTweenTerminus = TweenService:Create(rootPart, tweenInfo, {CFrame = adjustedCFrame})
    currentTweenTerminus:Play()
    
    local elapsed = 0
    while elapsed < duration and currentTweenTerminus and currentTweenTerminus.PlaybackState == Enum.PlaybackState.Playing do
        if not isCrystalTerminusRunning then 
            currentTweenTerminus:Cancel()
            break 
        end
        task.wait(0.05)
        elapsed = elapsed + 0.05
    end
end

local function getTerminusMutationCrystals()
    local crystals = {}
    local droppedCrystals = Workspace:FindFirstChild("DroppedCrystals")
    if droppedCrystals then
        for _, obj in ipairs(droppedCrystals:GetChildren()) do
            local mutationAttr = obj:GetAttribute("Mutation")
            if mutationAttr and tostring(mutationAttr):lower() == "terminus" then
                table.insert(crystals, obj)
            end
        end
    end
    
    local things = Workspace:FindFirstChild("Things")
    if things then
        local crystalsFolder = things:FindFirstChild("Crystals")
        if crystalsFolder then
            for _, obj in ipairs(crystalsFolder:GetChildren()) do
                local mutationAttr = obj:GetAttribute("Mutation")
                if mutationAttr and tostring(mutationAttr):lower() == "terminus" then
                    table.insert(crystals, obj)
                end
            end
        end
    end
    return crystals
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if isCrystalTerminusRunning then
            pcall(function()
                local char = player.Character
                if not char then return end
                local rootPart = char:FindFirstChild("HumanoidRootPart")
                if not rootPart then return end
                
                local crystals = getTerminusMutationCrystals()
                if #crystals > 0 then
                    for _, crystal in ipairs(crystals) do
                        if not isCrystalTerminusRunning then break end
                        if crystal and crystal.Parent then
                            local targetPart = crystal:IsA("Model") and crystal.PrimaryPart or crystal
                            if not targetPart and crystal:IsA("Model") then
                                targetPart = crystal:FindFirstChildWhichIsA("BasePart")
                            end
                            if not targetPart and crystal:IsA("BasePart") then
                                targetPart = crystal
                            end
                            
                            if targetPart and targetPart:IsA("BasePart") then
                                tweenToTerminus(targetPart.CFrame)
                                if not isCrystalTerminusRunning then break end
                                equipPickaxeTerminus()
                                
                                local startTime = tick()
                                while crystal and crystal.Parent and (tick() - startTime < 4) and isCrystalTerminusRunning do
                                    rootPart.CFrame = CFrame.new(targetPart.Position) * rootPart.CFrame.Rotation
                                    
                                    local activeTool = char:FindFirstChildOfClass("Tool")
                                    if activeTool then activeTool:Activate() end
                                    
                                    local prompt = crystal:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then
                                        prompt.MaxActivationDistance = 99999
                                        prompt.HoldDuration = 0
                                        fireproximityprompt(prompt)
                                    end
                                    
                                    if firetouchinterest then
                                        firetouchinterest(rootPart, targetPart, 0)
                                        task.wait(0.02)
                                        firetouchinterest(rootPart, targetPart, 1)
                                    end
                                    
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

BtnCrystalTerminus.MouseButton1Click:Connect(function()
    isCrystalTerminusRunning = not isCrystalTerminusRunning
    Config.CrystalMutasiTerminus = isCrystalTerminusRunning
    saveConfig()
    setToggleState(BgCrystalTerminus, CircleCrystalTerminus, isCrystalTerminusRunning)
    
    if isCrystalTerminusRunning then
        noclipConnectionTerminus = RunService.Stepped:Connect(function()
            local char = player.Character
            if char and char.Parent then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
        
        gravityConnectionTerminus = RunService.RenderStepped:Connect(function()
            local char = player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root and root.Parent then
                    root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
                    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        if currentTweenTerminus then currentTweenTerminus:Cancel() currentTweenTerminus = nil end
        if noclipConnectionTerminus then noclipConnectionTerminus:Disconnect() noclipConnectionTerminus = nil end
        if gravityConnectionTerminus then gravityConnectionTerminus:Disconnect() gravityConnectionTerminus = nil end
        
        local char = player.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
    end
end)

-- Collect Rune Logic
local isCollectRuneRunning = false
local isCollecting = false
local noclipConnection = RunService.Stepped:Connect(function()
    if isCollecting then
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end
            end
        end
    else
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

task.spawn(function()
	while true do
		task.wait(0.2)
		if isCollectRuneRunning then
			pcall(function()
				local character = player.Character
				if not character or not character:FindFirstChild("HumanoidRootPart") then return end
				local rootPart = character.HumanoidRootPart
				
				for _, v in ipairs(Workspace:GetDescendants()) do
					if not isCollectRuneRunning then break end
					if v:IsA("ProximityPrompt") then
						local part = v.Parent
						if part and part:IsA("BasePart") then
							local objectName = part.Name:lower()
							local parentName = part.Parent and part.Parent.Name:lower() or ""
							local fullName = v:GetFullName():lower()
							local isPlaced = fullName:find("plot") or fullName:find("base") or fullName:find("placed") or parentName:find("plot")
							
							if not isPlaced then
								if objectName:find("rune") or parentName:find("rune") or v.ActionText:lower() == "collect" then
									isCollecting = true
									v.MaxActivationDistance = 99999
									v.HoldDuration = 0
									rootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
									
									for i = 1, 3 do
										if not isCollectRuneRunning then break end
										fireproximityprompt(v)
										task.wait(0.02)
									end
									task.wait(0.05)
									isCollecting = false
								end
							end
						end
					end
				end
			end)
		end
	end
end)

BtnRune.MouseButton1Click:Connect(function()
	isCollectRuneRunning = not isCollectRuneRunning
	Config.CollectRune = isCollectRuneRunning
	saveConfig()
	setToggleState(BgRune, CircleRune, isCollectRuneRunning)
	if not isCollectRuneRunning then isCollecting = false end
end)

-- ESP Mutasi Terminus & Nocturnite
local isEspTerminusRunning = false

local function addTerminusESP(crystal)
    if not isEspTerminusRunning then return end
    pcall(function()
        local isTerminus = false
        pcall(function()
            if crystal.Mutation == "Terminus" then isTerminus = true end
        end)
        if crystal:GetAttribute("Mutation") == "Terminus" then isTerminus = true end

        if isTerminus and not crystal:FindFirstChild("TerminusESP") then
            local espFolder = Instance.new("Folder")
            espFolder.Name = "TerminusESP"
            espFolder.Parent = crystal

            local highlight = Instance.new("Highlight")
            highlight.Name = "HighlightESP"
            highlight.Adornee = crystal
            highlight.FillColor = Color3.fromRGB(231, 76, 60)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.Parent = espFolder

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "TextESP"
            billboard.Adornee = crystal
            billboard.Size = UDim2.new(0, 100, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = "MUTASI TERMINUS"
            textLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
            textLabel.TextScaled = true
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextStrokeTransparency = 0.5
            textLabel.Parent = billboard

            billboard.Parent = espFolder
        end
    end)
end

local function removeTerminusESP(crystal)
    if crystal and crystal:FindFirstChild("TerminusESP") then
        crystal.TerminusESP:Destroy()
    end
end

local function clearAllTerminusESP()
    pcall(function()
        local droppedCrystals = Workspace:FindFirstChild("DroppedCrystals")
        if droppedCrystals then
            for _, child in ipairs(droppedCrystals:GetChildren()) do
                removeTerminusESP(child)
            end
        end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:FindFirstChild("TerminusESP") then obj.TerminusESP:Destroy() end
        end
    end)
end

local droppedCrystalsFolder = Workspace:WaitForChild("DroppedCrystals", 5)
if droppedCrystalsFolder then
    droppedCrystalsFolder.ChildAdded:Connect(function(child)
        if isEspTerminusRunning then
            task.wait(0.5)
            addTerminusESP(child)
        end
    end)
end

BtnESP1.MouseButton1Click:Connect(function()
	isEspTerminusRunning = not isEspTerminusRunning
	Config.MutasiTerminus = isEspTerminusRunning
	saveConfig()
	setToggleState(BgESP1, CircleESP1, isEspTerminusRunning)
	
	if isEspTerminusRunning then
		pcall(function()
			local droppedCrystals = Workspace:FindFirstChild("DroppedCrystals")
			if droppedCrystals then
				for _, child in ipairs(droppedCrystals:GetChildren()) do
					addTerminusESP(child)
				end
			end
		end)
	else
		clearAllTerminusESP()
	end
end)

local espHoldFolder = Instance.new("Folder")
espHoldFolder.Name = "RgxHub_ESP_Folder"
espHoldFolder.Parent = CoreGui

local function createOrUpdateESP(item, textName, color)
	if not item or not item:IsA("BasePart") then return end
	local billboard = item:FindFirstChild("RgxHub_Billboard")
	if not billboard then
		billboard = Instance.new("BillboardGui")
		billboard.Name = "RgxHub_Billboard"
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.StudsOffset = Vector3.new(0, 2.5, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = item
		
		local textLbl = Instance.new("TextLabel")
		textLbl.Name = "ESPText"
		textLbl.Size = UDim2.new(1, 0, 1, 0)
		textLbl.BackgroundTransparency = 1
		textLbl.Font = Enum.Font.GothamBold
		textLbl.TextSize = 10
		textLbl.TextColor3 = color
		textLbl.TextStrokeTransparency = 0.5
		textLbl.Parent = billboard
	end
	
	local tLbl = billboard:FindFirstChild("ESPText")
	if tLbl then
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local dist = math.floor((char.HumanoidRootPart.Position - item.Position).Magnitude)
			tLbl.Text = textName .. "\n[" .. dist .. "m]"
		end
	end
end

local function removeESP(item)
	if item and item:FindFirstChild("RgxHub_Billboard") then
		item.RgxHub_Billboard:Destroy()
	end
end

local isEspNocturniteRunning = false
local nocturniteESPParts = {}

local function clearAllNocturniteESP()
	for part, _ in pairs(nocturniteESPParts) do
		removeESP(part)
	end
	nocturniteESPParts = {}
end

task.spawn(function()
	while true do
		task.wait(1)
		if isEspNocturniteRunning then
			pcall(function()
				local nocFolder = Workspace:FindFirstChild("MountainDecorations") 
					and Workspace.MountainDecorations:FindFirstChild("Boulders") 
					and Workspace.MountainDecorations.Boulders:FindFirstChild("Nocturnite")
				
				if nocFolder then
					local parts = {}
					for _, obj in ipairs(nocFolder:GetDescendants()) do
						if obj:IsA("BasePart") then
							table.insert(parts, obj)
						end
					end

					local clusters = {}
					local maxDistance = 30
					for _, part in ipairs(parts) do
						local added = false
						for _, cluster in ipairs(clusters) do
							for _, cp in ipairs(cluster) do
								if (part.Position - cp.Position).Magnitude <= maxDistance then
									table.insert(cluster, part)
									added = true
									break
								end
							end
							if added then break end
						end
						if not added then
							table.insert(clusters, {part})
						end
					end

					local activeParts = {}
					for _, cluster in ipairs(clusters) do
						local representative = cluster[1]
						if representative then
							activeParts[representative] = true
							createOrUpdateESP(representative, "Nocturnite", Color3.fromRGB(155, 89, 182))
						end
					end

					for part, _ in pairs(nocturniteESPParts) do
						if not activeParts[part] then removeESP(part) end
					end

					nocturniteESPParts = activeParts
				else
					clearAllNocturniteESP()
				end
			end)
		else
			if next(nocturniteESPParts) then clearAllNocturniteESP() end
		end
	end
end)

BtnESP2.MouseButton1Click:Connect(function()
	isEspNocturniteRunning = not isEspNocturniteRunning
	Config.NocturniteESP = isEspNocturniteRunning
	saveConfig()
	setToggleState(BgESP2, CircleESP2, isEspNocturniteRunning)
	if not isEspNocturniteRunning then clearAllNocturniteESP() end
end)

-- ====================================================================
-- INSTAN MINE (INSTANT MINE CONTROLLER BYPASS DI TAB ESP)
-- ====================================================================
local isInstanMineESPRunning = false
local imTargets = {
    { parent = "Things", child = "Crystals" },
    { parent = nil, child = "DroppedCrystals" },
    { parent = nil, child = "Crystals" }
}
local hookedFoldersIM = {}

local function patchPromptIM(p6)
    if p6:IsA("ProximityPrompt") then
        local v7 = p6:GetAttribute("IMC_OrigHold")
        if typeof(v7) ~= "number" then
            p6:SetAttribute("IMC_OrigHold", p6.HoldDuration)
        end
        if isInstanMineESPRunning then
            p6.HoldDuration = 0
        end
    end
end

local function restorePromptIM(p6)
    if p6:IsA("ProximityPrompt") then
        local orig = p6:GetAttribute("IMC_OrigHold")
        if typeof(orig) == "number" then
            p6.HoldDuration = orig
        end
    end
end

local function hookFolderIM(p9)
    if not hookedFoldersIM[p9] then
        hookedFoldersIM[p9] = true
        p9.DescendantAdded:Connect(function(desc)
            if isInstanMineESPRunning then
                patchPromptIM(desc)
            end
        end)
    end
    for _, v12 in ipairs(p9:GetDescendants()) do
        if isInstanMineESPRunning then
            patchPromptIM(v12)
        else
            restorePromptIM(v12)
        end
    end
end

local function sweepHomesIM()
    for _, v15 in ipairs(imTargets) do
        local v16 = v15.parent and Workspace:FindFirstChild(v15.parent) or Workspace
        if v16 then
            v16 = v16:FindFirstChild(v15.child)
        end
        if v16 then
            hookFolderIM(v16)
        end
    end
end

task.spawn(function()
    Workspace.DescendantAdded:Connect(function(p20)
        if p20:IsA("Folder") or p20:IsA("Model") then
            for _, v21 in ipairs(imTargets) do
                if p20.Name == v21.child and (v21.parent and Workspace:FindFirstChild(v21.parent) or Workspace) == p20.Parent then
                    task.wait(0.05)
                    hookFolderIM(p20)
                end
            end
        end
    end)
end)

BtnInstanMineESP.MouseButton1Click:Connect(function()
	isInstanMineESPRunning = not isInstanMineESPRunning
	Config.InstanMineESP = isInstanMineESPRunning
	saveConfig()
	setToggleState(BgInstanMineESP, CircleInstanMineESP, isInstanMineESPRunning)
	
	if isInstanMineESPRunning then
		sweepHomesIM()
	else
		for folder, _ in pairs(hookedFoldersIM) do
			if folder and folder.Parent then
				for _, v in ipairs(folder:GetDescendants()) do
					restorePromptIM(v)
				end
			end
		end
	end
end)

-- ====================================================================
-- FAST DIG (AUTO INFINITE FAST MINE BOOST)
-- ====================================================================
local isFastDigRunning = false

task.spawn(function()
	local playerData = player:WaitForChild("PlayerData", 30)
	local realStats = playerData and playerData:WaitForChild("RealStats", 30)
	local boostSeconds = realStats and realStats:WaitForChild("FastMineBoostSeconds", 30)

	while true do
		if isFastDigRunning and boostSeconds then
			pcall(function()
				if boostSeconds.Value < 3600 then
					boostSeconds.Value = 99999
				end
			end)
		end
		task.wait(2)
	end
end)

BtnFastDig.MouseButton1Click:Connect(function()
	isFastDigRunning = not isFastDigRunning
	Config.FastDig = isFastDigRunning
	saveConfig()
	setToggleState(BgFastDig, CircleFastDig, isFastDigRunning)
end)

-- Nocturnite Farm Handler
local nocturniteFolder = Workspace:WaitForChild("MountainDecorations"):WaitForChild("Boulders"):WaitForChild("Nocturnite")
local digRequest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DigRequest")

local TWEEN_SPEED_NOC = 90 
local DETECTION_RADIUS = 50 
local BASE_HOVER_HEIGHT = 5 
local activeTween = nil
local isNocturniteFarmRunning = false
local isFloating = false

local function equipTerminus()
	local character = player.Character
	if not character then return end
	if character:FindFirstChild("The Terminus") then return end
	local backpack = player:FindFirstChild("Backpack")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if backpack and humanoid then
		local tool = backpack:FindFirstChild("The Terminus")
		if tool and tool:IsA("Tool") then humanoid:EquipTool(tool) end
	end
end

local function startFloating()
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not humanoid then return end
	if isFloating then return end
	isFloating = true
	humanoid.PlatformStand = true
	if not humanoidRootPart:FindFirstChild("FloatVelocity") then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "FloatVelocity"
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = humanoidRootPart
	end
end

local function stopFloating()
	if activeTween then activeTween:Cancel() activeTween = nil end
	isFloating = false
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoidRootPart and humanoidRootPart:FindFirstChild("FloatVelocity") then
		humanoidRootPart.FloatVelocity:Destroy()
	end
	if humanoid then humanoid.PlatformStand = false end
end

local function getSafeHoverPosition(targetPart)
	local bottomOffset = (targetPart.Size.Y / 2) + BASE_HOVER_HEIGHT
	return targetPart.CFrame - Vector3.new(0, bottomOffset, 0)
end

local function tweenToNocturnite(targetCFrame)
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	startFloating()
	if activeTween then activeTween:Cancel() activeTween = nil end
	local distance = (humanoidRootPart.Position - targetCFrame.Position).Magnitude
	local duration = distance / TWEEN_SPEED_NOC
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	activeTween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = targetCFrame})
	activeTween:Play()
	activeTween.Completed:Wait()
	activeTween = nil
end

local function farmSinglePart(partName, targetPart)
	while isNocturniteFarmRunning and targetPart and targetPart.Parent and targetPart:IsA("BasePart") do
		equipTerminus()
		local character = player.Character
		if not character or not character:FindFirstChild("HumanoidRootPart") then break end
		local humanoidRootPart = character.HumanoidRootPart
		local safeTargetCFrame = getSafeHoverPosition(targetPart)
		local distance = (humanoidRootPart.Position - targetPart.Position).Magnitude
		if distance > DETECTION_RADIUS then
			tweenToNocturnite(safeTargetCFrame)
		else
			startFloating()
			humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(safeTargetCFrame, 0.3)
		end
		digRequest:FireServer("The Terminus", targetPart.Position)
		task.wait(0.3)
		targetPart = nocturniteFolder:FindFirstChild(partName)
	end
	stopFloating()
end

local function farmAllCells()
	while isNocturniteFarmRunning do
		local foundAny = false
		local baseCell = nocturniteFolder:FindFirstChild("Nocturnite_cell")
		if baseCell and baseCell:IsA("BasePart") and isNocturniteFarmRunning then
			foundAny = true
			farmSinglePart("Nocturnite_cell", baseCell)
		end
		for i = 1, 29 do
			if not isNocturniteFarmRunning then break end
			local targetPart = nocturniteFolder:FindFirstChild(string.format("Nocturnite_cell.%03d", i))
			if targetPart and targetPart:IsA("BasePart") and isNocturniteFarmRunning then
				foundAny = true
				farmSinglePart(string.format("Nocturnite_cell.%03d", i), targetPart)
			end
		end
		if not foundAny and isNocturniteFarmRunning then
			stopFloating()
			task.wait(3)
		else
			task.wait(1)
		end
	end
	stopFloating()
end

BtnNocturnite.MouseButton1Click:Connect(function()
	isNocturniteFarmRunning = not isNocturniteFarmRunning
	Config.NocturniteFarm = isNocturniteFarmRunning
	saveConfig()
	setToggleState(BgNocturnite, CircleNocturnite, isNocturniteFarmRunning)
	if isNocturniteFarmRunning then
		equipTerminus()
		task.spawn(farmAllCells)
	else
		stopFloating()
	end
end)

-- ====================================================================
-- MISC AUTO DIG, OTOMATIS MINIMIZE & AUTO LOW SERVER
-- ====================================================================

local BtnAutoMin, BgAutoMin, CircleAutoMin = createToggleFeature(MiscPage, "Otomatis Minimize")
BtnAutoMin.MouseButton1Click:Connect(function()
	Config.OtomatisMinimize = not Config.OtomatisMinimize
	saveConfig()
	setToggleState(BgAutoMin, CircleAutoMin, Config.OtomatisMinimize)
end)

local selectedAutoDigDuration = Config.AutoDigDuration or "60s"
local isAutoDigRunning = Config.AutoDigMisc
local autoDigSession = 0

local MiscToggleBtn, MiscBg, MiscCircle = createToggleFeature(MiscPage, "Auto Dig: ON")

local AutoDigDropdownBtn = Instance.new("TextButton")
AutoDigDropdownBtn.Parent = MiscPage
AutoDigDropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
AutoDigDropdownBtn.Size = UDim2.new(1, -8, 0, 32)
AutoDigDropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
AutoDigDropdownBtn.Text = "  Auto Dig Time: " .. selectedAutoDigDuration .. " ▼"
AutoDigDropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
AutoDigDropdownBtn.TextSize = 9
AutoDigDropdownBtn.Font = Enum.Font.GothamMedium
AutoDigDropdownBtn.AutoButtonColor = false

local AutoDigDropdownCorner = Instance.new("UICorner") AutoDigDropdownCorner.CornerRadius = UDim.new(0, 6) AutoDigDropdownCorner.Parent = AutoDigDropdownBtn
local AutoDigDropdownStroke = Instance.new("UIStroke") AutoDigDropdownStroke.Color = Color3.fromRGB(45, 45, 60) AutoDigDropdownStroke.Thickness = 1 AutoDigDropdownStroke.Parent = AutoDigDropdownBtn

local AutoDigScrollingFrame = Instance.new("ScrollingFrame")
AutoDigScrollingFrame.Parent = MiscPage
AutoDigScrollingFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
AutoDigScrollingFrame.Size = UDim2.new(1, -8, 0, 140)
AutoDigScrollingFrame.BorderSizePixel = 0
AutoDigScrollingFrame.Visible = false
AutoDigScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 180)
AutoDigScrollingFrame.ScrollBarThickness = 2
AutoDigScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

local AutoDigUIListLayout = Instance.new("UIListLayout")
AutoDigUIListLayout.Parent = AutoDigScrollingFrame
AutoDigUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
AutoDigUIListLayout.Padding = UDim.new(0, 3)

local function updateAutoDigButtonText()
	local labelComp = MiscToggleBtn:FindFirstChildOfClass("TextLabel")
	if labelComp then
		if isAutoDigRunning then
			labelComp.Text = "Auto Dig (" .. selectedAutoDigDuration .. "): ON"
		else
			labelComp.Text = "Auto Dig (" .. selectedAutoDigDuration .. "): OFF"
		end
	end
end

local function createAutoDigOption(name, val, callback)
	local optBtn = Instance.new("TextButton")
	optBtn.Parent = AutoDigScrollingFrame
	optBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	optBtn.Size = UDim2.new(1, -4, 0, 28)
	optBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	optBtn.Text = "  " .. name
	optBtn.TextXAlignment = Enum.TextXAlignment.Left
	optBtn.TextSize = 9
	optBtn.Font = Enum.Font.Gotham
	local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = optBtn
	optBtn.MouseButton1Click:Connect(callback)
end

createAutoDigOption("10 Detik", "10s", function() selectedAutoDigDuration = "10s" Config.AutoDigDuration = selectedAutoDigDuration saveConfig() AutoDigDropdownBtn.Text = "  Auto Dig Time: 10s ▼" updateAutoDigButtonText() AutoDigScrollingFrame.Visible = false end)
createAutoDigOption("20 Detik", "20s", function() selectedAutoDigDuration = "20s" Config.AutoDigDuration = selectedAutoDigDuration saveConfig() AutoDigDropdownBtn.Text = "  Auto Dig Time: 20s ▼" updateAutoDigButtonText() AutoDigScrollingFrame.Visible = false end)
createAutoDigOption("30 Detik", "30s", function() selectedAutoDigDuration = "30s" Config.AutoDigDuration = selectedAutoDigDuration saveConfig() AutoDigDropdownBtn.Text = "  Auto Dig Time: 30s ▼" updateAutoDigButtonText() AutoDigScrollingFrame.Visible = false end)
createAutoDigOption("40 Detik", "40s", function() selectedAutoDigDuration = "40s" Config.AutoDigDuration = selectedAutoDigDuration saveConfig() AutoDigDropdownBtn.Text = "  Auto Dig Time: 40s ▼" updateAutoDigButtonText() AutoDigScrollingFrame.Visible = false end)
createAutoDigOption("60 Detik", "60s", function() selectedAutoDigDuration = "60s" Config.AutoDigDuration = selectedAutoDigDuration saveConfig() AutoDigDropdownBtn.Text = "  Auto Dig Time: 60s ▼" updateAutoDigButtonText() AutoDigScrollingFrame.Visible = false end)

local isAutoDigDropdownOpen = false
AutoDigDropdownBtn.MouseButton1Click:Connect(function()
	isAutoDigDropdownOpen = not isAutoDigDropdownOpen
	AutoDigScrollingFrame.Visible = isAutoDigDropdownOpen
end)

local function getCharacterParts()
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")
	local hrp = char:WaitForChild("HumanoidRootPart")
	local bp = player:WaitForChild("Backpack")
	return char, hum, hrp, bp
end

local function equipTerminusTool()
	local char, hum, _, bp = getCharacterParts()
	if char:FindFirstChild("The Terminus") then return end
	local tool = bp:FindFirstChild("The Terminus")
	if tool and tool:IsA("Tool") then hum:EquipTool(tool) end
end

task.spawn(function()
	while true do
		if isAutoDigRunning then
			pcall(function()
				equipTerminusTool()
				local _, _, hrp, _ = getCharacterParts()
				if hrp then
					local pos = hrp.Position
					digRequest:FireServer("The Terminus", Vector3.new(pos.X, pos.Y, pos.Z))
				end
			end)
		end
		task.wait(0.3)
	end
end)

local function getDurationSeconds(durStr)
	if durStr == "10s" then return 10
	elseif durStr == "20s" then return 20
	elseif durStr == "30s" then return 30
	elseif durStr == "40s" then return 40
	elseif durStr == "60s" then return 60
	end
	return 60
end

local function startAutoDigTimer()
	autoDigSession = autoDigSession + 1
	local currentSession = autoDigSession
	local totalSeconds = getDurationSeconds(selectedAutoDigDuration)
	local timeLeft = totalSeconds
	
	task.spawn(function()
		local labelComp = MiscToggleBtn:FindFirstChildOfClass("TextLabel")
		while isAutoDigRunning and timeLeft > 0 and autoDigSession == currentSession do
			local minutes = math.floor(timeLeft / 60)
			local seconds = timeLeft % 60
			if labelComp then
				if minutes > 0 then
					labelComp.Text = string.format("Auto Dig (%d:%02d)", minutes, seconds)
				else
					labelComp.Text = string.format("Auto Dig (%ds)", seconds)
				end
			end
			task.wait(1)
			if isAutoDigRunning and autoDigSession == currentSession then
				timeLeft = timeLeft - 1
			end
		end
		
		if isAutoDigRunning and autoDigSession == currentSession then
			isAutoDigRunning = false
			Config.AutoDigMisc = false
			saveConfig()
			setToggleState(MiscBg, MiscCircle, false)
			if labelComp then labelComp.Text = "Auto Dig (" .. selectedAutoDigDuration .. "): OFF" end
		end
	end)
end

MiscToggleBtn.MouseButton1Click:Connect(function()
	isAutoDigRunning = not isAutoDigRunning
	Config.AutoDigMisc = isAutoDigRunning
	saveConfig()
	setToggleState(MiscBg, MiscCircle, isAutoDigRunning)
	
	local labelComp = MiscToggleBtn:FindFirstChildOfClass("TextLabel")
	if isAutoDigRunning then
		updateAutoDigButtonText()
		equipTerminusTool()
		startAutoDigTimer()
	else
		autoDigSession = autoDigSession + 1
		if labelComp then labelComp.Text = "Auto Dig (" .. selectedAutoDigDuration .. "): OFF" end
	end
end)

local isInfinityJumpRunning = false
local InfJumpToggleBtn, InfJumpBg, InfJumpCircle = createToggleFeature(MiscPage, "Infinity Jump")
InfJumpToggleBtn.MouseButton1Click:Connect(function()
	isInfinityJumpRunning = not isInfinityJumpRunning
	Config.InfinityJump = isInfinityJumpRunning
	saveConfig()
	setToggleState(InfJumpBg, InfJumpCircle, isInfinityJumpRunning)
end)

UserInputService.JumpRequest:Connect(function()
	if isInfinityJumpRunning then
		pcall(function()
			local character = player.Character
			if character then
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
			end
		end)
	end
end)

-- ====================================================================
-- AUTO LOW SERVER (FIXED STATUS BAR & NOCTURNITE DETECTION)
-- ====================================================================
local selectedHopDelayMode = Config.HopDelay or "60s"
local isAutoLowServerRunning = false

local AutoLowServerToggleBtn, AutoLowServerBg, AutoLowServerCircle = createToggleFeature(MiscPage, "Auto Hop: ON")

local HopStatusBar = Instance.new("TextLabel")
HopStatusBar.Name = "HopStatusBar"
HopStatusBar.Parent = MiscPage
HopStatusBar.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
HopStatusBar.Size = UDim2.new(1, -8, 0, 24)
HopStatusBar.Font = Enum.Font.GothamMedium
HopStatusBar.Text = "  Status: Nonaktif"
HopStatusBar.TextColor3 = Color3.fromRGB(150, 150, 170)
HopStatusBar.TextSize = 8
HopStatusBar.TextXAlignment = Enum.TextXAlignment.Left

local HopStatusCorner = Instance.new("UICorner") HopStatusCorner.CornerRadius = UDim.new(0, 4) HopStatusCorner.Parent = HopStatusBar
local HopStatusStroke = Instance.new("UIStroke") HopStatusStroke.Color = Color3.fromRGB(40, 40, 52) HopStatusStroke.Thickness = 1 HopStatusStroke.Parent = HopStatusBar

local HopDropdownBtn = Instance.new("TextButton")
HopDropdownBtn.Parent = MiscPage
HopDropdownBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
HopDropdownBtn.Size = UDim2.new(1, -8, 0, 32)
HopDropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 235)
HopDropdownBtn.Text = "  Select Hop Time ▼"
HopDropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
HopDropdownBtn.TextSize = 9
HopDropdownBtn.Font = Enum.Font.GothamMedium
HopDropdownBtn.AutoButtonColor = false

local HopDropdownCorner = Instance.new("UICorner") HopDropdownCorner.CornerRadius = UDim.new(0, 6) HopDropdownCorner.Parent = HopDropdownBtn
local HopDropdownStroke = Instance.new("UIStroke") HopDropdownStroke.Color = Color3.fromRGB(45, 45, 60) HopDropdownStroke.Thickness = 1 HopDropdownStroke.Parent = HopDropdownBtn

local HopScrollingFrame = Instance.new("ScrollingFrame")
HopScrollingFrame.Parent = MiscPage
HopScrollingFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
HopScrollingFrame.Size = UDim2.new(1, -8, 0, 160)
HopScrollingFrame.BorderSizePixel = 0
HopScrollingFrame.Visible = false
HopScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 210)
HopScrollingFrame.ScrollBarThickness = 2
HopScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

local HopUIListLayout = Instance.new("UIListLayout")
HopUIListLayout.Parent = HopScrollingFrame
HopUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
HopUIListLayout.Padding = UDim.new(0, 3)

local function updateHopButtonText()
	local labelComp = AutoLowServerToggleBtn:FindFirstChildOfClass("TextLabel")
	local timeStr = selectedHopDelayMode or "60s"
	if labelComp then
		if isAutoLowServerRunning then
			labelComp.Text = "Auto Hop (" .. timeStr .. "): ON"
		else
			labelComp.Text = "Auto Low Server"
		end
	end
end

local function createHopOption(name, val, callback)
	local optBtn = Instance.new("TextButton")
	optBtn.Parent = HopScrollingFrame
	optBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
	optBtn.Size = UDim2.new(1, -4, 0, 28)
	optBtn.TextColor3 = Color3.fromRGB(180, 180, 195)
	optBtn.Text = "  " .. name
	optBtn.TextXAlignment = Enum.TextXAlignment.Left
	optBtn.TextSize = 9
	optBtn.Font = Enum.Font.Gotham
	local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, 4) c.Parent = optBtn
	optBtn.MouseButton1Click:Connect(callback)
end

createHopOption("Tunggu 30 Detik", "30s", function() selectedHopDelayMode = "30s" Config.HopDelay = selectedHopDelayMode saveConfig() updateHopButtonText() HopScrollingFrame.Visible = false end)
createHopOption("Tunggu 60 Detik", "60s", function() selectedHopDelayMode = "60s" Config.HopDelay = selectedHopDelayMode saveConfig() updateHopButtonText() HopScrollingFrame.Visible = false end)
createHopOption("Tunggu 120 Detik", "120s", function() selectedHopDelayMode = "120s" Config.HopDelay = selectedHopDelayMode saveConfig() updateHopButtonText() HopScrollingFrame.Visible = false end)
createHopOption("Tunggu 180 Detik", "180s", function() selectedHopDelayMode = "180s" Config.HopDelay = selectedHopDelayMode saveConfig() updateHopButtonText() HopScrollingFrame.Visible = false end)
createHopOption("Tunggu 240 Detik", "240s", function() selectedHopDelayMode = "240s" Config.HopDelay = selectedHopDelayMode saveConfig() updateHopButtonText() HopScrollingFrame.Visible = false end)

local isHopDropdownOpen = false
HopDropdownBtn.MouseButton1Click:Connect(function()
	isHopDropdownOpen = not isHopDropdownOpen
	HopScrollingFrame.Visible = isHopDropdownOpen
end)

local function hasNocturniteToFarm()
	if isNocturniteFarmRunning then return true end
	local found = false
	pcall(function()
		local folder = Workspace:FindFirstChild("MountainDecorations") 
			and Workspace.MountainDecorations:FindFirstChild("Boulders") 
			and Workspace.MountainDecorations.Boulders:FindFirstChild("Nocturnite")
			
		if folder then
			for _, obj in ipairs(folder:GetDescendants()) do
				if obj:IsA("BasePart") and string.lower(obj.Name):find("nocturnite") then
					found = true
					break
				end
			end
		end
	end)
	return found
end

local function HopLowServer()
	local maxWaitTime = 60
	if selectedHopDelayMode == "30s" then maxWaitTime = 30
	elseif selectedHopDelayMode == "60s" then maxWaitTime = 60
	elseif selectedHopDelayMode == "120s" then maxWaitTime = 120
	elseif selectedHopDelayMode == "180s" then maxWaitTime = 180
	elseif selectedHopDelayMode == "240s" then maxWaitTime = 240 end
	
	local waitTime = maxWaitTime
	
	while waitTime > 0 and isAutoLowServerRunning do
		if hasNocturniteToFarm() then
			HopStatusBar.Text = "  Status: Nocturnite Found"
			HopStatusBar.TextColor3 = Color3.fromRGB(46, 204, 113)
			task.wait(2)
			waitTime = maxWaitTime
			continue
		else
			HopStatusBar.Text = "  Status: Nocturnite Not Found (" .. waitTime .. "s)"
			HopStatusBar.TextColor3 = Color3.fromRGB(241, 196, 15)
		end
		task.wait(1)
		waitTime = waitTime - 1
	end
	
	if not isAutoLowServerRunning then 
		HopStatusBar.Text = "  Status: Nonaktif"
		HopStatusBar.TextColor3 = Color3.fromRGB(150, 150, 170)
		return 
	end

	if hasNocturniteToFarm() then
		HopStatusBar.Text = "  Status: Nocturnite Found (Hop Cancelled)"
		HopStatusBar.TextColor3 = Color3.fromRGB(46, 204, 113)
		task.wait(3)
		if isAutoLowServerRunning then task.spawn(HopLowServer) end
		return
	end

	HopStatusBar.Text = "  Status: Nocturnite Not Found (Hop Server...)"
	HopStatusBar.TextColor3 = Color3.fromRGB(52, 152, 219)

	pcall(function()
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local response = game:HttpGet(url)
		local data = HttpService:JSONDecode(response)
		
		if data and data.data then
			for _, server in ipairs(data.data) do
				if not isAutoLowServerRunning then return end
				if server.id ~= game.JobId and server.playing < server.maxPlayers then
					HopStatusBar.Text = "  Status: Berpindah server..."
					HopStatusBar.TextColor3 = Color3.fromRGB(46, 204, 113)
					TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
					return
				end
			end
		end
		task.wait(3)
		if isAutoLowServerRunning then task.spawn(HopLowServer) end
	end)
end

AutoLowServerToggleBtn.MouseButton1Click:Connect(function()
	isAutoLowServerRunning = not isAutoLowServerRunning
	Config.AutoLowServer = isAutoLowServerRunning
	saveConfig()
	setToggleState(AutoLowServerBg, AutoLowServerCircle, isAutoLowServerRunning)
	updateHopButtonText()
	
	if isAutoLowServerRunning then
		task.spawn(HopLowServer)
	else
		HopStatusBar.Text = "  Status: Nonaktif"
		HopStatusBar.TextColor3 = Color3.fromRGB(150, 150, 170)
	end
end)

-- Load Config Inisialisasi
task.spawn(function()
	task.wait(0.5)
	
	if Config.OtomatisMinimize ~= nil then
		setToggleState(BgAutoMin, CircleAutoMin, Config.OtomatisMinimize, true)
	end

	if Config.AutoDrop then isAutoDropRunning = true setToggleState(Bg1, Circle1, true, true) task.spawn(runAutoDrop) end
	if Config.InstanMineCrystal then isInstanMineRunning = true setToggleState(BgInstanMine, CircleInstanMine, true, true) end
	if Config.AutoSell then isSellRunning = true setToggleState(Bg3, Circle3, true, true) end
	if Config.FarmingCrystal then isFarmingCrystalRunning = true setToggleState(BgFarmingCrystal, CircleFarmingCrystal, true, true) end
	if Config.CrystalMutasiTerminus then isCrystalTerminusRunning = true setToggleState(BgCrystalTerminus, CircleCrystalTerminus, true, true) end
	if Config.NocturniteFarm then isNocturniteFarmRunning = true setToggleState(BgNocturnite, CircleNocturnite, true, true) equipTerminus() task.spawn(farmAllCells) end
	if Config.CollectRune then isCollectRuneRunning = true setToggleState(BgRune, CircleRune, true, true) end
	if Config.DropRune then isDropRuneRunning = true updateDropRuneToggle() end
	if Config.ClearMountain then isAutoMountainRunning = true setToggleState(BgClearMountain, CircleClearMountain, true, true) end
	if Config.MutasiTerminus then 
		isEspTerminusRunning = true 
		setToggleState(BgESP1, CircleESP1, true, true) 
		pcall(function()
			local droppedCrystals = Workspace:FindFirstChild("DroppedCrystals")
			if droppedCrystals then
				for _, child in ipairs(droppedCrystals:GetChildren()) do
					addTerminusESP(child)
				end
			end
		end)
	end
	if Config.NocturniteESP then isEspNocturniteRunning = true setToggleState(BgESP2, CircleESP2, true, true) end
	if Config.InstanMineESP then
		isInstanMineESPRunning = true
		setToggleState(BgInstanMineESP, CircleInstanMineESP, true, true)
		sweepHomesIM()
	end
	if Config.FastDig then isFastDigRunning = true setToggleState(BgFastDig, CircleFastDig, true, true) end
	if Config.InfinityJump then isInfinityJumpRunning = true setToggleState(InfJumpBg, InfJumpCircle, true, true) end

	selectedAutoDigDuration = Config.AutoDigDuration or "60s"
	AutoDigDropdownBtn.Text = "  Auto Dig Time: " .. selectedAutoDigDuration .. " ▼"
	if Config.AutoDigMisc then
		isAutoDigRunning = true
		setToggleState(MiscBg, MiscCircle, true, true)
		updateAutoDigButtonText()
		equipTerminusTool()
		startAutoDigTimer()
	else
		isAutoDigRunning = false
		setToggleState(MiscBg, MiscCircle, false, true)
		updateAutoDigButtonText()
	end

	if Config.AutoLowServer then
		isAutoLowServerRunning = true
		setToggleState(AutoLowServerBg, AutoLowServerCircle, true, true)
		updateHopButtonText()
		task.spawn(HopLowServer)
	end
	
	selectedHopDelayMode = Config.HopDelay or "60s"
	updateHopButtonText()
end)

print("Mine A Mountain Full Fixed Berhasil Dimuat!")
