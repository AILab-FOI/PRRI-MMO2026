game.Players.PlayerAdded:Connect(function(player)
	local stats = Instance.new("Folder")
	stats.Name = "leaderstats"
	stats.Parent = player

	local bodovi = Instance.new("IntValue")
	bodovi.Name = "Artefakti"
	bodovi.Value = 0
	bodovi.Parent = stats
end)