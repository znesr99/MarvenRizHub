repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Connection
local TypeTool = {"Melee","Sword","Special","DevilFruit"}
local MethodList = {"Behind","Below","Upper","Front"}

_G.MainWeapon = "Melee"
_G.Select_EquipWeapon = {}
_G.Select_Method = "Upper"
_G.Distance_Farm = 5

local MethodFarm = CFrame.new(0,5,0) * CFrame.Angles(math.rad(-90),0,0)

local Teleport = function(Pos)
	local Character = LocalPlayer.Character
	if Character then
		Character:PivotTo(Pos)
	end
end
local NoVFX = function(State)
	if State then
		workspace:WaitForChild("VFX"):ClearAllChildren()
		Connection = workspace:WaitForChild("VFX").DescendantAdded:Connect(function(v)
			pcall(function()
				v:Destroy()
			end)
		end)
	else
		if Connection then
			Connection:Disconnect()
			Connection = nil
		end
	end
end
local AutoSkill = function()
	local Character = LocalPlayer.Character
	if not Character then return end
	local Skills = {}
	if _G.AutoSkillZ then table.insert(Skills,"z") end
	if _G.AutoSkillX then table.insert(Skills,"x") end
	if _G.AutoSkillC then table.insert(Skills,"c") end
	if _G.AutoSkillV then table.insert(Skills,"v") end
	if _G.AutoSkillF then table.insert(Skills,"f") end
	if #Skills == 0 then return end
	local Skill = Skills[math.random(#Skills)]
	for _,Tool in ipairs(Character:GetChildren()) do
		if Tool:IsA("Tool") then
			ReplicatedStorage.Remotes.Action:FireServer(Tool.Name,Skill)
		end
	end
end

local EquipWeapon = function()
	local Character = LocalPlayer.Character
	if not Character then return end
	local Backpack = LocalPlayer.Backpack
	local MainTool

	for _,v in ipairs(Character:GetChildren()) do
		if v:IsA("Tool") and v:GetAttribute("Type") == _G.MainWeapon then
			MainTool = v
			break
		end
	end

	if not MainTool then
		for _,v in ipairs(Backpack:GetChildren()) do
			if v:IsA("Tool") and v:GetAttribute("Type") == _G.MainWeapon then
				MainTool = v
				break
			end
		end
	end

	for _,v in ipairs(Character:GetChildren()) do
		if v:IsA("Tool") and v ~= MainTool then
			v.Parent = Backpack
		end
	end

	if MainTool and MainTool.Parent ~= Character then
		MainTool.Parent = Character
	end

	if type(_G.Select_EquipWeapon) == "table" then
		for _,Type in ipairs(_G.Select_EquipWeapon) do
			if Type ~= _G.MainWeapon then
				for _,v in ipairs(Backpack:GetChildren()) do
					if v:IsA("Tool") and v:GetAttribute("Type") == Type and v ~= MainTool then
						v.Parent = Character
					end
				end
			end
		end
	end
end

local Attack = function()
	local Character = LocalPlayer.Character
	if not Character then return end
	for _,v in ipairs(Character:GetChildren()) do
		if v:IsA("Tool") then
			ReplicatedStorage.Remotes.Action:FireServer(v.Name,"hit")
		end
	end
end

local GetItemAmount = function(ItemName)
	local Success,Inventory = pcall(function()
		return HttpService:JSONDecode(
			LocalPlayer:GetAttribute("Inventory") or "{}"
		)
	end)
	if not Success then return 0 end
	return Inventory[ItemName] and Inventory[ItemName].amount or 0
end

LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

local Library = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/znesr99/gui/refs/heads/main/MarvenRizLib.lua"
))()

local Window = Library:CreateWindow({
	Title = "MarvenRiz Hub",
	Subtitle = "Map : Rock Fruit",
	Size = UDim2.fromOffset(500,370),
	AccentColor = Color3.fromRGB(50,150,255),
	SideBarWidth = 120,
	Logo = "rbxassetid://87526284179554",
	LogoSize = 32,
	SphereText = false,
	SphereImage = "rbxassetid://87526284179554",
	SphereIconSize = 38,
	Map = "RockFruit"
})

local MySaveManager = Library.SaveManager

local Tab1 = Window:CreateTab("Settings",true,false)
local Settings = Tab1:CreatePage("Main Settings")

local Weapon = Settings:CreateSection("🗡️ Select Weapon","Left")
local AutoSkills = Settings:CreateSection("⚔️ Auto Skills","Left")
local Method = Settings:CreateSection("🎯 Select Method Farm","Right")
local Haki = Settings:CreateSection("👁️ Haki","Right")
local VFX = Settings:CreateSection("✨ VFX","Right")
local Tab2 = Window:CreateTab("Main",false,false)
local RaidPage = Tab2:CreatePage("Raid")
local RaidCard = RaidPage:CreateSection("🌋 Raid","Left")

local ConfigTab = Window:CreateTab("Config",false,false)

Weapon:Dropdown({
	Title = "Main Weapon (Attack)",
	Options = TypeTool,
	Multi = false,
	Value = "Melee",
	Callback = function(Value)
		_G.MainWeapon = Value
	end
})

Weapon:Dropdown({
	Title = "Select Support Weapon",
	Options = TypeTool,
	Multi = true,
	Callback = function(Value)
		_G.Select_EquipWeapon = Value
	end
})

AutoSkills:Toggle({
	Title = "Auto Skill Z",
	Value = false,
	Callback = function(Value)
		_G.AutoSkillZ = Value
	end
})

AutoSkills:Toggle({
	Title = "Auto Skill X",
	Value = false,
	Callback = function(Value)
		_G.AutoSkillX = Value
	end
})

AutoSkills:Toggle({
	Title = "Auto Skill C",
	Value = false,
	Callback = function(Value)
		_G.AutoSkillC = Value
	end
})

AutoSkills:Toggle({
	Title = "Auto Skill V",
	Value = false,
	Callback = function(Value)
		_G.AutoSkillV = Value
	end
})

AutoSkills:Toggle({
	Title = "Auto Skill F",
	Value = false,
	Callback = function(Value)
		_G.AutoSkillF = Value
	end
})

Method:Dropdown({
	Title = "Select Method Farm",
	Options = MethodList,
	Multi = false,
	Value = "Upper",
	Callback = function(Value)
		_G.Select_Method = Value
	end
})

Method:Slider({
	Title = "Distance Farm",
	Min = 0,
	Max = 30,
	Value = 5,
	Callback = function(Value)
		_G.Distance_Farm = Value
	end
})

Haki:Toggle({
	Title = "Auto Enabled Haki",
	Value = false,
	Callback = function(Value)
		_G.Auto_Haki = Value
	end
})
VFX:Toggle({
	Title = "Disable VFX",
	Value = false,
	Callback = function(Value)
		NoVFX(Value)
	end
})
RaidCard:Toggle({
	Title = "Auto Raid Moon (Full)",
	Value = false,
	Callback = function(Value)
		_G.Auto_Raid = Value
		if Value then
			ReplicatedStorage.Modules.NetworkFramework.NetworkEvent:FireServer("fire",nil,"Quest","Cancel")
		end
	end
})

task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Select_Method == "Behind" then
				MethodFarm = CFrame.new(0,0,_G.Distance_Farm)
			elseif _G.Select_Method == "Front" then
				MethodFarm = CFrame.new(0,0,-_G.Distance_Farm) * CFrame.Angles(0,math.rad(180),0)
			elseif _G.Select_Method == "Below" then
				MethodFarm = CFrame.new(0,-_G.Distance_Farm,0) * CFrame.Angles(math.rad(90),0,0)
			elseif _G.Select_Method == "Upper" then
				MethodFarm = CFrame.new(0,_G.Distance_Farm,0) * CFrame.Angles(math.rad(-90),0,0)
			elseif _G.Select_Method == "None" then
				MethodFarm = CFrame.new(0,_G.Distance_Farm,0) * CFrame.Angles(math.rad(-90),0,0)
			else
				MethodFarm = CFrame.new(0,_G.Distance_Farm,0) * CFrame.Angles(math.rad(-90),0,0)
			end
		end)
	end
end)
task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Auto_Haki then
				if not game.Players.LocalPlayer.Character:FindFirstChild("HakiFolder") then
				game.ReplicatedStorage.Remotes.Action:FireServer("Misc", "buso")
				end
			end
		end)
	end
end)

task.spawn(function()
	while task.wait() do
		pcall(function()
			if _G.Auto_Raid then
				if game.PlaceId == 82878101790702 then
					for _, v in pairs(workspace.Mob:GetChildren()) do
						if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart")and v.Humanoid.Health > 0 then
							v.Humanoid.WalkSpeed = 0
							v.Humanoid.JumpPower = 0
							repeat task.wait()
								EquipWeapon()
								AutoSkill()
								Attack()
								Teleport(v.HumanoidRootPart.CFrame * MethodFarm)
							until not _G.Auto_Raid or not v.Parent or v.Humanoid.Health <= 0
						end
					end
				end
			end
		end)
	end
end)
task.spawn(function()
	while task.wait() do
		if _G.Auto_Farm_Level or _G.Auto_CraftWeapon or _G.Auto_Farm_Material or _G.Auto_FarmBoss_Automatically or _G.Auto_FarmBoss or _G.Auto_DuckAutomatically or _G.Auto_Duck  or _G.Auto_Farm_Set or _G.Auto_Raid or _G.Auto_BaconThief or _G.Auto_Dungeon or _G.Auto_Piccolo then
			pcall(function()
				local Character = game.Players.LocalPlayer.Character
				local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
				if HRP then
						HRP.AssemblyAngularVelocity = Vector3.zero
					local Vel = HRP.AssemblyLinearVelocity
					HRP.AssemblyLinearVelocity = Vector3.new(0, Vel.Y, 0)
				end
			end)
		end
	end
end)
task.spawn(function()
	pcall(function()
		game:GetService("RunService").Stepped:Connect(function()
			if _G.Auto_Farm_Level or _G.Auto_CraftWeapon or _G.Auto_Farm_Material or _G.Auto_FarmBoss_Automatically or _G.Auto_FarmBoss or _G.Auto_DuckAutomatically or _G.Auto_Duck  or _G.Auto_Farm_Set or _G.Auto_Raid or _G.Auto_BaconThief or _G.Auto_Dungeon or _G.Auto_Piccolo then
				if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
				local Noclip = Instance.new("BodyVelocity")
					Noclip.Name = "BodyClip"
					Noclip.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
					Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
					Noclip.Velocity = Vector3.new(0, 0, 0)
					end
				else    
					if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
					game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
				end
			end
		end)
	end)
end)  
MySaveManager:BuildConfigTab(ConfigTab)

task.spawn(function()
	task.wait(1)
	MySaveManager:LoadAutoloadConfig()
end)
