local event = game.ReplicatedStorage:WaitForChild("SakrijArtefakt")

event.OnClientEvent:Connect(function(artefaktObjekt)
	if artefaktObjekt then
		artefaktObjekt.Transparency = 1
		artefaktObjekt.CanTouch = false

		for _, child in pairs(artefaktObjekt:GetChildren()) do
			if child:IsA("ParticleEmitter") or child:IsA("Light") then
				child.Enabled = false
			end
		end
	end
end)