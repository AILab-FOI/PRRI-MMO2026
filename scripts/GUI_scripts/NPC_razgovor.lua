local frame = script.Parent
local label = frame:WaitForChild("DialogueText")
local nameLabel = frame:WaitForChild("NPCName")
local nextBtn = frame:WaitForChild("NextButton")
local event = game.ReplicatedStorage:WaitForChild("OtvoriNPCGui")

local cijelaPrica = {}
local trenutnaStranica = 1
local isTyping = false
local trenutnoIme = ""

local function prikaziTekst(poruka)
	isTyping = true
	label.Text = ""
	for i = 1, #poruka do
		label.Text = string.sub(poruka, 1, i)
		task.wait(0.03)
	end
	isTyping = false
end

event.OnClientEvent:Connect(function(tablicaTeksta, imeNPCa)
	cijelaPrica = tablicaTeksta
	trenutnaStranica = 1
	trenutnoIme = imeNPCa

	nameLabel.Text = trenutnoIme
	frame.Visible = true
	prikaziTekst(cijelaPrica[trenutnaStranica])
end)

nextBtn.MouseButton1Click:Connect(function()
	if isTyping then return end

	if trenutnaStranica < #cijelaPrica then
		trenutnaStranica = trenutnaStranica + 1
		prikaziTekst(cijelaPrica[trenutnaStranica])
	else
		frame.Visible = false
	end
end)