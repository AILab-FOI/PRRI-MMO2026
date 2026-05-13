local artefakt = script.Parent
local event = game.ReplicatedStorage:WaitForChild("SakrijArtefakt")
local skupio = false

local JUMP_BOOST = 100 

artefakt.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid = character:FindFirstChild("Humanoid")
	local player = game.Players:GetPlayerFromCharacter(character)

	if player and humanoid and not skupio then
		skupio = true
		
		local stats = player:FindFirstChild("leaderstats")
		if stats and stats:FindFirstChild("Artefakti") then
			stats.Artefakti.Value = stats.Artefakti.Value + 1
		end
		
		local staraSnaga = humanoid.JumpPower
		humanoid.UseJumpPower = true
		humanoid.JumpPower = JUMP_BOOST

		event:FireClient(player, artefakt)

	end
end)