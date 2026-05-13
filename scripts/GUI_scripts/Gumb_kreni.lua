local gumb = script.Parent
local pocetniGui = gumb.Parent.Parent
local event = game.ReplicatedStorage:WaitForChild("PokreniTimer")

gumb.MouseButton1Click:Connect(function()
	pocetniGui.Enabled = false
	event:FireServer()
end)