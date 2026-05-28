local hitbox = script.Parent
local cijeliModel = hitbox.Parent
local event = game.ReplicatedStorage:WaitForChild("SakrijArtefakt")
local JUMP_BOOST = 50

hitbox.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and humanoid then
		local skupljeniFolder = player:FindFirstChild("SkupljeniArtefakti")
		if not skupljeniFolder then
			skupljeniFolder = Instance.new("Folder")
			skupljeniFolder.Name = "SkupljeniArtefakti"
			skupljeniFolder.Parent = player
		end

		if not skupljeniFolder:FindFirstChild(cijeliModel.Name) then
			local oznaka = Instance.new("BoolValue")
			oznaka.Name = cijeliModel.Name
			oznaka.Value = true
			oznaka.Parent = skupljeniFolder

			local stats = player:FindFirstChild("leaderstats")
			if stats and stats:FindFirstChild("Artefakti") then
				stats.Artefakti.Value = stats.Artefakti.Value + 1
			end

			humanoid.UseJumpPower = true
			humanoid.JumpPower = JUMP_BOOST

			event:FireClient(player, cijeliModel)
		end
	end
end)