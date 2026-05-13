local event = game.ReplicatedStorage:WaitForChild("PokreniTimer")

event.OnServerEvent:Connect(function(player)
	event:FireClient(player)
	print("Server je primio start od: " .. player.Name)
end)
