local button = script.Parent
local prompt = button:WaitForChild("ProximityPrompt")

local bell = workspace.crkva.Sketchfab_model.Bell1
local sound = bell.Sound
local event = game.ReplicatedStorage:WaitForChild("QuestEvent")

local requiredDelay = 2

prompt.Triggered:Connect(function(player)
	if player:GetAttribute("BellQuestActive") ~= true then
		event:FireClient(player, "Prvo razgovaraj sa Zvonarom ispred crkve.")
		return
	end

	local now = os.clock()
	local last = player:GetAttribute("LastBellRingTime") or 0

	if last ~= 0 and now - last < requiredDelay then
		player:SetAttribute("BellRingsDone", 0)
		player:SetAttribute("LastBellRingTime", 0)

		event:FireClient(player,
			"Prebrzo si pozvonio! Kreni ispočetka i prati ritam."
		)
		return
	end

	sound:Play()
	player:SetAttribute("LastBellRingTime", now)

	local done = (player:GetAttribute("BellRingsDone") or 0) + 1
	local needed = player:GetAttribute("BellRingsNeeded") or 3

	player:SetAttribute("BellRingsDone", done)

	if done < needed then
		event:FireClient(player, "Dobro! Zvono: " .. done .. "/" .. needed)
	else
		player:SetAttribute("BellQuestActive", false)
		player:SetAttribute("BellQuestDone", true)

		local leaderstats = player:FindFirstChild("leaderstats")
		local artefakti = leaderstats and leaderstats:FindFirstChild("Artefakti")

		if artefakti then
			artefakti.Value += 1
		end

		event:FireClient(player,
			"🔔 Zadatak završen!\nDobio si poseban crkveni artefakt!"
		)
	end
end)
