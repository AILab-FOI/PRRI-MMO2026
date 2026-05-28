local event = game.ReplicatedStorage:WaitForChild("SakrijArtefakt")

event.OnClientEvent:Connect(function(objekt)
	if objekt then

		local sound = workspace:FindFirstChild("pickupobject")
		if sound then
			sound:Play()
		end

		local confetti = objekt:FindFirstChild("Confetti")

		if confetti then
			for _, obj in ipairs(confetti:GetDescendants()) do
				if obj:IsA("ParticleEmitter") then
					obj.Speed = NumberRange.new(25, 45)
					obj.Lifetime = NumberRange.new(0.5, 0.8)
					obj:Emit(150)
				end
			end
		else
			print("[WARN] Ovaj artefakt nema 'Confetti' unutar sebe!")
		end

		for _, child in pairs(objekt:GetDescendants()) do
			if child ~= confetti then
				if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("DataModelMesh") then
					child.Transparency = 1
					child.CanCollide = false
				end

				if child:IsA("ParticleEmitter") or child:IsA("Light") or child:IsA("BillboardGui") then
					child.Enabled = false
				end
			end
		end

		if objekt:IsA("BasePart") then
			objekt.Transparency = 1
			objekt.CanCollide = false
		end
	end
end)