local award = script.Parent

local prompt = award:FindFirstChildWhichIsA("ProximityPrompt", true)

if not prompt then
	warn("Nema ProximityPrompt u nagradi: " .. award.Name)
	return
end

local collected = false

local function hideAward()
	for _, obj in pairs(award:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Transparency = 1
			obj.CanCollide = false
		end
	end

	prompt.Enabled = false
end

prompt.Triggered:Connect(function(player)
	if collected then return end

	if not player:GetAttribute("HNKQuestStarted") then
		return
	end

	if player:GetAttribute("HNKQuestDone") then
		return
	end

	collected = true

	local currentAmount = player:GetAttribute("HNKAwardsCollected") or 0
	currentAmount += 1

	player:SetAttribute("HNKAwardsCollected", currentAmount)

	print(player.Name .. " je pokupio nagradu. Ukupno: " .. currentAmount .. "/5")

	hideAward()

	if currentAmount >= 5 then
		player:SetAttribute("HNKAllAwardsCollected", true)
		print(player.Name .. " je skupio sve HNK nagrade.")
	end
end)