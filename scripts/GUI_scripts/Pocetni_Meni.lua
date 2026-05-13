local menuGui = script.Parent
local Frame = menuGui:WaitForChild("Frame")
local label = Frame:WaitForChild("PocetniTekstLabel")
local poruka = [[Dobrodošli u srce baroknog Varaždina!

Pred tobom je drevna utvrda koja skriva tajne stare stoljećima. Tvoj zadatak je pronaći 8 izgubljenih artefakata. Svaki od njih podarit će ti posebne moći.

Skupi ih sve i uklesaj svoje ime u Varaždinski zid slavnih. Jesi li spreman?]]

local function tipkaj(objekt, tekst)
	for i = 1, #tekst do
		objekt.Text = string.sub(tekst, 1, i)
		task.wait(0.02)
	end
end

task.wait(1)
Frame.Visible = true
tipkaj(label, poruka)