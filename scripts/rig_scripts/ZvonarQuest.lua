local npc = script.Parent
local prompt = npc:WaitForChild("ProximityPrompt")
local event = game.ReplicatedStorage:WaitForChild("QuestEvent")

prompt.Triggered:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local artefakti = leaderstats and leaderstats:FindFirstChild("Artefakti")

	if not artefakti or artefakti.Value < 3 then
		event:FireClient(player,
			"Zvonar: Prvo sakupi barem 3 artefakta, pa se vrati pozvoniti crkveno zvono."
		)
		return
	end

	player:SetAttribute("BellQuestActive", true)
	player:SetAttribute("BellRingsNeeded", 3)
	player:SetAttribute("BellRingsDone", 0)
	player:SetAttribute("LastBellRingTime", 0)

	event:FireClient(player,
		"Zvonar: Imaš dovoljno artefakata. Pozvoni crkveno zvono 3 puta, ali između svakog zvona pričekaj barem 2 sekunde!"
	)
end)
