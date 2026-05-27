local gui = script.Parent
local text = gui:WaitForChild("QuestText")

game.ReplicatedStorage:WaitForChild("QuestEvent").OnClientEvent:Connect(function(message)

	text.Text = message
	text.Visible = true

	task.wait(5)

	text.Visible = false

end)
