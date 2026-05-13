local artefakt = script.Parent

task.spawn(function()
	while artefakt and artefakt.Parent do
		artefakt.CFrame = artefakt.CFrame * CFrame.Angles(0, math.rad(2), 0)
		task.wait(0.01)
	end
end)