local model = script.Parent
local BRZINA_ROTACIJE = 2

while true do
	local trenutniPivot = model:GetPivot()
	local pozicija = trenutniPivot.Position

	local rotacijaY = CFrame.Angles(0, math.rad(BRZINA_ROTACIJE), 0)

	model:PivotTo(CFrame.new(pozicija) * (trenutniPivot - pozicija) * rotacijaY)

	task.wait()
end