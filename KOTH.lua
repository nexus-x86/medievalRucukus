local module = {}

local AlertRemote = game.ReplicatedStorage.Remotes.AlertRemote
local BindRemote = game.ServerStorage.BindableEvents.ModeOver

module.run = function()
	local connection
	local connection2
	local connection3
	
	local hill = game.ReplicatedStorage.ModeStorage.KingOfTheHill.Hill:Clone()
	hill.Parent = workspace
	
	for i,v in pairs(game.Players:GetPlayers()) do
		v.PlayerGui.HillIndicator.Enabled = true
	end
	local function Complete(winner)
		connection:Disconnect()
		connection2:Disconnect()
		connection3:Disconnect()
		for i,v in pairs(game.Players:GetPlayers()) do
			v.PlayerGui.HillIndicator.Enabled = false
		end
		hill:Destroy()
		AlertRemote:FireAllClients('The winner of this round was '..winner..'!')
		wait(5)
		BindRemote:Fire()
		return
	end
	
	local function PlayerAdded(plr)
		plr.PlayerGui.HillIndicator.Enabled = true
	end
	
	local function RedChanged()
		if game.ReplicatedStorage.ModeStorage.KingOfTheHill.RedTimeOnHill.Value > game.ReplicatedStorage.ModeStorage.KingOfTheHill.BlueTimeOnHill.Value then
			if game.ReplicatedStorage.ModeStorage.KingOfTheHill.RedTimeOnHill.Value == 30 then
				Complete('red')
			end
		end
	end
	local function BlueChanged()
		if game.ReplicatedStorage.ModeStorage.KingOfTheHill.RedTimeOnHill.Value < game.ReplicatedStorage.ModeStorage.KingOfTheHill.BlueTimeOnHill.Value then
			if game.ReplicatedStorage.ModeStorage.KingOfTheHill.BlueTimeOnHill.Value == 30 then
				Complete('blue')
			end
		end
	end
	connection = game.Players.PlayerAdded:Connect(PlayerAdded)
	connection2 = game.ReplicatedStorage.ModeStorage.KingOfTheHill.RedTimeOnHill:GetPropertyChangedSignal('Value'):Connect(RedChanged)
	connection3 = game.ReplicatedStorage.ModeStorage.KingOfTheHill.BlueTimeOnHill:GetPropertyChangedSignal('Value'):Connect(BlueChanged)
end

return module
