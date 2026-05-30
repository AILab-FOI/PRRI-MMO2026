local prompt = script.Parent
local REQUIRED_ITEM = "kompjuter" 
local REWARD_ITEM_NAME = "collectible_10_FOI_diploma"

local event = game.ReplicatedStorage:WaitForChild("OtvoriNPCGui")
local serverStorage = game:GetService("ServerStorage")

-- The full story table (We define it globally here so both states can use it)
local prica = {
	"Zgrada FOI 2 izgradena je krajem 19. stoljeca u elegantnom stilu historicizma.",
	"Kroz povijest je bila posvecena obrazovanju, ponajviše kao Viša djevojacka škola.",
	"Danas je njezina unutrašnjost potpuno modernizirana za potrebe Fakulteta organizacije i informatike.",
	"I ja taman imam predavanje a laptop mi je ostao kod Ljubomira.",
	"Možeš li pronaci Ljubomira i vratiti mi laptop?"
}

-- SIGURNO TRAŽENJE SPAWN POINTA:
local npcModel = prompt:FindFirstAncestorOfClass("Model")
local spawnPoint = nil

if npcModel then
	spawnPoint = npcModel:FindFirstChild("DiplomaSpawn")
end

if not spawnPoint then
	spawnPoint = game.Workspace:FindFirstChild("DiplomaSpawn")
end

prompt.Triggered:Connect(function(player)
	local character = player.Character
	if not character then return end

	-- STATE 3: Provjera je li quest vec gotov (Velimir ponavlja pricu BEZ zadnje dvije recenice)
	local questFinished = player:GetAttribute("QuestFinished")
	if questFinished then
		-- Dohvacamo trenutni indeks recenice za ovog igraca (krece od 1)
		local currentIndex = player:GetAttribute("FoiSentenceIndex") or 1

		local sentenceToShow = prica[currentIndex]

		-- Mijenjamo tekst prompta da prikaže povijesnu recenicu
		local originalText = prompt.ActionText
		prompt.ActionText = sentenceToShow
		task.wait(3.5) -- Vrijeme za citanje recenice
		prompt.ActionText = originalText

		-- Pomakni na iducu recenicu
		currentIndex = currentIndex + 1

		-- LIMIT: Ako prode indeks 3 (izbacuje zadnje dvije recenice), vrati na prvu recenicu
		if currentIndex > (#prica - 2) then
			currentIndex = 1 
		end
		player:SetAttribute("FoiSentenceIndex", currentIndex)

		return 
	end

	-- STATE 2: Provjera predaje predmeta
	local heldItem = character:FindFirstChild(REQUIRED_ITEM)

	if heldItem and heldItem:IsA("Tool") then

		if not spawnPoint then
			warn("?? GREŠKA: Ne mogu naci dio koji se zove 'DiplomaSpawn' u Exploreru! Kreiraj Part pored NPC-a i nazovi ga tako.")
			prompt.ActionText = "[Greška na serveru]"
			task.wait(2)
			prompt.ActionText = "Talk"
			return 
		end

		local rewardSource = serverStorage:FindFirstChild(REWARD_ITEM_NAME)
		if not rewardSource then
			warn("?? GREŠKA: Ne mogu pronaci '" .. REWARD_ITEM_NAME .. "' unutar ServerStorage! Provjeri ime diplome.")
			prompt.ActionText = "[Diploma nedostaje u ServerStorage]"
			task.wait(2)
			prompt.ActionText = "Talk"
			return
		end

		-- Ako je sve u redu, uzmi laptop i oznaci quest gotovim
		heldItem:Destroy() 
		player:SetAttribute("QuestFinished", true)
		player:SetAttribute("FoiSentenceIndex", 1) -- Pripremi indeks za ponavljanje price

		-- Stvaranje diplome
		local rewardClone = rewardSource:Clone()

		if rewardClone:IsA("Model") then
			rewardClone:PivotTo(spawnPoint.CFrame)
		elseif rewardClone:IsA("BasePart") or rewardClone:IsA("Tool") then
			local primaryPart = rewardClone:IsA("Tool") and rewardClone:FindFirstChildWhichIsA("BasePart") or rewardClone
			if primaryPart then
				primaryPart.CFrame = spawnPoint.CFrame
			end
		end

		rewardClone.Parent = game.Workspace
		print("? " .. REWARD_ITEM_NAME .. " se uspješno stvorio na poziciji DiplomaSpawn!")

		local originalText = prompt.ActionText
		prompt.ActionText = "Hvala ti puno! Spasio si me."
		task.wait(3)
		prompt.ActionText = originalText
		return 
	end

	-- STATE 1: Pokretanje dijaloga (ako igrac nema laptop)
	local hasSpoken = player:GetAttribute("HasHeardNPC")

	if not hasSpoken then
		player:SetAttribute("HasHeardNPC", true)
		-- Šalje sve recenice u klijentski GUI (ukljucujuci zadnje dvije)
		event:FireClient(player, prica, "Velimir")
	else
		local originalText = prompt.ActionText
		prompt.ActionText = "Bok, frende. Jesi našao laptop kod Ljubomira?"
		task.wait(2)
		prompt.ActionText = originalText
	end
end)
