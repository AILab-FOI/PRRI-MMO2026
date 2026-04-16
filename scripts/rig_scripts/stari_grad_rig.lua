local prompt = script.Parent
local event = game.ReplicatedStorage:WaitForChild("OtvoriNPCGui")

local prica = {
	"Dobrodošli u Stari grad Varaždin!",
	"Ovo je jedna od najljepših feudalnih utvrda u Hrvatskoj.",
	"Danas je ovdje muzej koji čuva povijest našeg kraja."
}

prompt.Triggered:Connect(function(player)
	event:FireClient(player, prica, "Kustos")
end)