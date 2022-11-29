local module = {}

local AlertRemote = game.ReplicatedStorage.Remotes.AlertRemote
local BindRemote = game.ServerStorage.BindableEvents.ModeOver

module.run = function()
	local PlayerAddedConnection
	local PumpkinDiedConnection
	local PumpkinMan = game.ReplicatedStorage.ModeStorage.PumpkinMan["Pumpkin Man"]:Clone()
	for i,v in pairs(game.Players:GetPlayers()) do
		v.TeamColor = BrickColor.new('Really red')
	end
	local function PlayerAdded(v) 
		v.TeamColor = BrickColor.new('Really red')
	end
	local function Complete()
		PlayerAddedConnection:Disconnect()
		PumpkinDiedConnection:Disconnect()
		AlertRemote:FireAllClients('The winner of this round was Everybody Else :D :D!')
		wait(5)
		BindRemote:Fire()
		return
	end
	local function PumpkinDied()
		PumpkinMan:Destroy()
		Complete()
	end
	PumpkinMan.Parent = workspace
	PumpkinDiedConnection = PumpkinMan.Humanoid.Died:Connect(PumpkinDied)
	PlayerAddedConnection = game.Players.PlayerAdded:Connect(PlayerAdded)
end

return module
