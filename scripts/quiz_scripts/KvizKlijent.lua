print("🖥️ KLIJENT: Pokrećem KvizKlijent skriptu...")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local kvizEvent = ReplicatedStorage:WaitForChild("KvizEvent")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🖥️ KLIJENT: Tražim GUI elemente...")
local quizGui = playerGui:WaitForChild("QuizGui")
local mainFrame = quizGui:WaitForChild("MainFrame")
local questionLabel = mainFrame:WaitForChild("QuestionLabel")
local progressLabel = mainFrame:WaitForChild("ProgressLabel")
local gumbiFolder = mainFrame:WaitForChild("Folder")

local gumbi = {
	gumbiFolder:WaitForChild("AnswerA"),
	gumbiFolder:WaitForChild("AnswerB"),
	gumbiFolder:WaitForChild("AnswerC"),
	gumbiFolder:WaitForChild("AnswerD")
}
print("🖥️ KLIJENT: Svi GUI elementi uspješno učitani!")

mainFrame.Visible = false

kvizEvent.OnClientEvent:Connect(function(akcija, p1, p2, p3)
	print("🖥️ KLIJENT: RemoteEvent okinut sa servera! Akcija: " .. tostring(akcija))

	if akcija == "NovoPitanje" then
		local pitanjeTekst = p1
		local odgovoriTablica = p2
		local brojPitanja = p3

		mainFrame.Visible = true
		questionLabel.Text = pitanjeTekst
		progressLabel.Text = "Pitanje: " .. brojPitanja .. " / 5"
		print("🖥️ KLIJENT: Prikazujem pitanje broj " .. brojPitanja)

		for i, gumb in ipairs(gumbi) do
			if odgovoriTablica[i] then
				gumb.Text = odgovoriTablica[i]
				gumb.Visible = true
				gumb.Active = true
			else
				gumb.Visible = false
			end
		end

	elseif akcija == "KrajKviz" then
		local prosao = p1
		local bodovi = p2
		print("🖥️ KLIJENT: Kviz završio. Rezultat prošao: " .. tostring(prosao) .. " | Bodovi: " .. bodovi)

		if prosao then
			questionLabel.Text = "🎉 Točno si odgovorio na " .. bodovi .. "/5 pitanja! Artefakt se pojavio!"
		else
			questionLabel.Text = "❌ Pao si. Imao si " .. bodovi .. "/5 točnih odgovora. Potrebno je barem 4. Pokušaj ponovno!"
		end

		for _, gumb in ipairs(gumbi) do
			gumb.Visible = false
		end
		progressLabel.Text = "KVIZ ZAVRŠEN"

		task.wait(4)
		mainFrame.Visible = false
	end
end)

for indeks, gumb in ipairs(gumbi) do
	gumb.MouseButton1Click:Connect(function()
		print("🖥️ KLIJENT: Igrač je kliknuo na gumb broj: " .. indeks)
		for _, g in ipairs(gumbi) do g.Active = false end
		kvizEvent:FireServer("Odgovor", indeks)
	end)
end