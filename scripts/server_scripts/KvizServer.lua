local prompt = script.Parent
print("📡 SERVER: Skripta je pokrenuta. Pratim ProximityPrompt: " .. prompt:GetFullName())

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local kvizEvent = ReplicatedStorage:WaitForChild("KvizEvent")
local artefaktPredlozak = ReplicatedStorage:FindFirstChild("KvizArtefakt")

if not artefaktPredlozak then
	warn("📡 SERVER UPOZORENJE: 'KvizArtefakt' nije pronađen u ReplicatedStorage!")
else
	print("📡 SERVER: 'KvizArtefakt' uspješno lociran u ReplicatedStorage.")
end

local pitanja = {
	{
		Pitanje = "Koja je najpoznatija utvrda u Varaždinu?",
		Odgovori = {"Stari grad", "Kamerlengo", "Nehaj", "Medvedgrad"},
		Tocan = 1
	},
	{
		Pitanje = "Kako se zove poznati varaždinski festival u kasno ljeto?",
		Odgovori = {"InMusic", "Ultra", "Špancirfest", "Riječke ljetne noći"},
		Tocan = 3
	},
	{
		Pitanje = "Koje godine je Varaždin kratko bio glavni grad Hrvatske?",
		Odgovori = {"1526.", "1767.", "1914.", "1848."},
		Tocan = 2
	},
	{
		Pitanje = "Koji kukci imaju svoj jedinstveni muzej u palači Herzer?",
		Odgovori = {"Leptiri", "Kukci", "Mravi", "Pčele"},
		Tocan = 2
	},
	{
		Pitanje = "Što od navedenog NIJE tradicionalni varaždinski suvenir?",
		Odgovori = {"Varaždinski klipič", "Varaždinski klip", "Anđeli", "Plesač"},
		Tocan = 2
	}
}

local aktivniKvizovi = {}

prompt.Triggered:Connect(function(player)
	print("📡 SERVER: ProximityPrompt je AKTIVIRAN od strane igrača: " .. player.Name)

	if aktivniKvizovi[player.UserId] then 
		print("📡 SERVER: Igrač već ima aktivan kviz u pozadini.")
		return 
	end

	aktivniKvizovi[player.UserId] = {
		TrenutnoPitanje = 1,
		TocniOdgovori = 0
	}

	local podaci = pitanja[1]
	print("📡 SERVER: Šaljem prvo pitanje klijentu preko RemoteEventa...")
	kvizEvent:FireClient(player, "NovoPitanje", podaci.Pitanje, podaci.Odgovori, 1)
	print("📡 SERVER: Signal poslan!")
end)

kvizEvent.OnServerEvent:Connect(function(player, akcija, odabraniIndeks)
	print("📡 SERVER: Primio odgovor od " .. player.Name .. " | Akcija: " .. tostring(akcija) .. " | Indeks: " .. tostring(odabraniIndeks))

	local status = aktivniKvizovi[player.UserId]
	if not status or akcija ~= "Odgovor" then return end

	local trenutnoPitanjePodaci = pitanja[status.TrenutnoPitanje]

	if odabraniIndeks == trenutnoPitanjePodaci.Tocan then
		status.TocniOdgovori += 1
		print("📡 SERVER: Odgovor je TOČAN! Ukupno točnih: " .. status.TocniOdgovori)
	else
		print("📡 SERVER: Odgovor je NETOČAN!")
	end

	status.TrenutnoPitanje += 1

	if status.TrenutnoPitanje <= #pitanja then
		local podaci = pitanja[status.TrenutnoPitanje]
		kvizEvent:FireClient(player, "NovoPitanje", podaci.Pitanje, podaci.Odgovori, status.TrenutnoPitanje)
	else
		print("📡 SERVER: Kviz završen za igrača. Konačni bodovi: " .. status.TocniOdgovori)
		local konacniBodovi = status.TocniOdgovori

		if konacniBodovi >= 4 then
			print("📡 SERVER: Igrač je PROŠAO! Pokušavam stvoriti artefakt...")
			if not workspace:FindFirstChild("Sakupljeni_KvizArtefakt") then
				local noviArtefakt = artefaktPredlozak:Clone()
				noviArtefakt.Name = "Sakupljeni_KvizArtefakt"
				noviArtefakt:PivotTo(prompt.Parent:GetPivot() * CFrame.new(0, 0, -5)) 
				noviArtefakt.Parent = workspace
				print("📡 SERVER: Artefakt je uspješno stvoren u Workspaceu!")
			else
				print("📡 SERVER: Artefakt već postoji na mapi.")
			end
			kvizEvent:FireClient(player, "KrajKviz", true, konacniBodovi)
		else
			print("📡 SERVER: Igrač je PAO kviz.")
			kvizEvent:FireClient(player, "KrajKviz", false, konacniBodovi)
		end

		aktivniKvizovi[player.UserId] = nil
	end
end)