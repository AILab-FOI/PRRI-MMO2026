local prompt = script.Parent
local toolName = "kompjuter" 
local storage = game:GetService("ServerStorage")
local tool = storage:WaitForChild(toolName)

local isGivingItem = false
local itemGiven = false -- Tracks if the item was already taken

prompt.Triggered:Connect(function(player)
	-- If someone already took the item, just repeat the line nonstop
	if itemGiven then
		local originalText = prompt.ActionText
		prompt.ActionText = "Vec sam ti dao laptop, odnesi ga Velimiru!" -- Your repeatable line
		task.wait(2)
		prompt.ActionText = originalText
		return
	end

	-- Prevents multiple clicks at the exact same millisecond
	if isGivingItem then return end
	isGivingItem = true

	local character = player.Character
	if character then
		local clonedTool = tool:Clone()
		clonedTool.Parent = character

		itemGiven = true -- Mark as given so the top condition triggers next time
		isGivingItem = false -- Reset debounced click state

		-- Quick temporary text change to confirm they got it
		local originalText = prompt.ActionText
		prompt.ActionText = "Evo ti laptop!"
		task.wait(2)
		prompt.ActionText = originalText
	else
		isGivingItem = false
	end
end)
