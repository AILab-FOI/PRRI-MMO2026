local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local ragdollEvent = ReplicatedStorage:WaitForChild("RampBallRagdoll")

local RAGDOLL_TIME = 1.4
local UP_FORCE = 35

local isRagdolled = false

ragdollEvent.OnClientEvent:Connect(function(direction, pushForce)
	print("CLIENT: Lopta me pogodila")

	if isRagdolled then return end
	isRagdolled = true

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		isRagdolled = false
		return
	end

	rootPart:ApplyImpulse(
		direction * rootPart.AssemblyMass * pushForce
			+ Vector3.new(0, rootPart.AssemblyMass * UP_FORCE, 0)
	)

	humanoid.PlatformStand = true
	humanoid:ChangeState(Enum.HumanoidStateType.Physics)

	task.wait(RAGDOLL_TIME)

	if humanoid and humanoid.Health > 0 then
		humanoid.PlatformStand = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	task.wait(0.3)
	isRagdolled = false
end)
