local ServerStorage = game:GetService("ServerStorage")

local npc = script.Parent
local root = npc:WaitForChild("HumanoidRootPart")
local prompt = root:WaitForChild("ProximityPrompt")
local head = npc:WaitForChild("Head")

local artifactTemplate = ServerStorage:WaitForChild("HNK_GoldenArtifact")

prompt.Enabled = true
prompt.RequiresLineOfSight = false
prompt.MaxActivationDistance = 12

local billboard = Instance.new("BillboardGui")
billboard.Name = "NpcText"
billboard.Size = UDim2.new(0, 420, 0, 130)
billboard.StudsOffset = Vector3.new(0, 3, 0)
billboard.AlwaysOnTop = true
billboard.Enabled = false
billboard.Parent = head

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.25
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.TextWrapped = true
textLabel.Font = Enum.Font.GothamBold
textLabel.Parent = billboard

local talking = false

local function say(text, seconds)
	billboard.Enabled = true
	textLabel.Text = text
	task.wait(seconds)
end

local function spawnArtifact(player)
	local artifact = artifactTemplate:Clone()
	artifact.Parent = workspace

	local spawnPosition = root.Position + root.CFrame.LookVector * 5 + Vector3.new(0, 2, 0)

	if artifact:IsA("Model") then
		artifact:PivotTo(CFrame.new(spawnPosition))
	else
		artifact.Position = spawnPosition
	end

	for _, obj in ipairs(artifact:GetDescendants()) do
		if obj:IsA("BasePart") then
			obj.Anchored = true
			obj.CanCollide = false
		end
	end
end

prompt.Triggered:Connect(function(player)
	if talking then return end
	talking = true

	if player:GetAttribute("HNKQuestDone") then
		say("Hvala ti još jednom! Nagrade su vracene i predstava može poceti.", 4)
		billboard.Enabled = false
		talking = false
		return
	end

	if player:GetAttribute("HNKAllAwardsCollected") then
		say("Odlicno! Pronašao si svih 5 izgubljenih kazališnih nagrada.", 4)
		say("Kao zahvalu dobivaš zlatni artefakt HNK-a.", 4)

		spawnArtifact(player)

		player:SetAttribute("HNKQuestDone", true)
		player:SetAttribute("HNKArtifact", true)

		billboard.Enabled = false
		talking = false
		return
	end

	if player:GetAttribute("HNKQuestStarted") then
		local collected = player:GetAttribute("HNKAwardsCollected") or 0
		say("Još uvijek trebam tvoju pomoc. Pronašao si " .. collected .. "/5 kazališnih nagrada.", 5)
		say("Pronadi sve nagrade oko HNK-a i vrati se meni.", 4)

		billboard.Enabled = false
		talking = false
		return
	end

	say("Ovo je Hrvatsko narodno kazalište u Varaždinu, važno kulturno mjesto grada.", 5)
	say("Kazalište nije samo zgrada za predstave, nego prostor gdje se cuvaju gluma, glazba i scenska umjetnost.", 6)
	say("U HNK-u se održavaju kazališne predstave, koncerti, svecani programi i drugi kulturni dogadaji.", 6)
	say("Takva mjesta su važna jer povezuju gradane s umjetnošcu, poviješcu i tradicijom grada.", 6)
	say("Danas imamo posebnu kazališnu vecer, ali dogodio se problem...", 5)
	say("Izgubila sam 5 zlatnih kazališnih nagrada koje trebaju biti izložene ispred HNK-a.", 6)
	say("Možeš li ih pronaci negdje oko okolice HNK-a i vratiti mi ih?", 5)

	player:SetAttribute("HNKQuestStarted", true)
	player:SetAttribute("HNKAwardsCollected", 0)

	billboard.Enabled = false
	talking = false
end)