local label = script.Parent
local timerGui = label.Parent.Parent
local event = game.ReplicatedStorage:WaitForChild("PokreniTimer")

local player = game.Players.LocalPlayer
local stats = player:WaitForChild("leaderstats")
local artefakti = stats:WaitForChild("Artefakti")

local vrijeme = 0
local tajmerRadi = false

local function formatVrijeme(s)
	return string.format("%02d:%02d", math.floor(s/60), s%60)
end

event.OnClientEvent:Connect(function()
	if tajmerRadi then return end

	timerGui.Enabled = true
	tajmerRadi = true
	vrijeme = 0

	task.spawn(function()
		while tajmerRadi do
			label.Text = "Vrijeme: " .. formatVrijeme(vrijeme)
			task.wait(1)
			vrijeme = vrijeme + 1

			if artefakti.Value >= 8 then
				tajmerRadi = false
				label.Text = "KRAJ! " .. formatVrijeme(vrijeme)
				game.ReplicatedStorage.PokreniTimer:FireServer(vrijeme)
			end
		end
	end)
end)