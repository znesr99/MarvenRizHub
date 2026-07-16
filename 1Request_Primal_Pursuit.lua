
local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local Enabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,170,0,70)
Frame.Position = UDim2.new(0.5,-85,0.2,0)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

local Text = Instance.new("TextLabel")
Text.Size = UDim2.new(1,0,0,20)
Text.BackgroundTransparency = 1
Text.Text = "Kill Aura"
Text.Font = Enum.Font.GothamBold
Text.TextSize = 18
Text.TextColor3 = Color3.new(0,0,0)
Text.Parent = Frame

local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,90,0,40)
Toggle.Position = UDim2.new(0.5,-45,0,25)
Toggle.Text = ""
Toggle.AutoButtonColor = false
Toggle.BackgroundColor3 = Color3.fromRGB(255,40,40)
Toggle.Parent = Frame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1,0)
Corner.Parent = Toggle

local Circle = Instance.new("Frame")
Circle.Size = UDim2.new(0,36,0,36)
Circle.Position = UDim2.new(0,2,0.5,-18)
Circle.BackgroundColor3 = Color3.new(1,1,1)
Circle.Parent = Toggle

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1,0)
CircleCorner.Parent = Circle

local function UpdateToggle()
	if Enabled then
		Toggle.BackgroundColor3 = Color3.fromRGB(0,200,0)
		Circle:TweenPosition(UDim2.new(1,-38,0.5,-18),"Out","Quad",0.15,true)
	else
		Toggle.BackgroundColor3 = Color3.fromRGB(255,40,40)
		Circle:TweenPosition(UDim2.new(0,2,0.5,-18),"Out","Quad",0.15,true)
	end
end

Toggle.MouseButton1Click:Connect(function()
	Enabled = not Enabled
	UpdateToggle()
end)

UpdateToggle()

task.spawn(function()
	while task.wait() do
		if Enabled then
			pcall(function()
				for _,v in ipairs(Players:GetPlayers()) do
					if v.Team == Teams.Dinosaur and v.Character and v.Character:FindFirstChild("Hitbox") then
					game:GetService("ReplicatedStorage").CWep:FireServer("mf2",{
						v.Character.Hitbox,
						v.Character.Hitbox.Position
					})
					end
				end
			end)
		end
	end
end)
local UIS = game:GetService("UserInputService")

local dragging = false
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)
