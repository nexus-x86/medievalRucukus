local module = {}
local AlertRemote = game.ReplicatedStorage.Remotes.AlertRemote
local BindRemote = game.ServerStorage.BindableEvents.ModeOver

module.run = function()
	local connection
	local connection2
	local connection3
	
	local RedFlag = game.ReplicatedStorage.ModeStorage.CaptureTheFlag.RedFlagStand:Clone()
	local BlueFlag = game.ReplicatedStorage.ModeStorage.CaptureTheFlag.BlueFlagStand:Clone()
	RedFlag.Parent = workspace
	BlueFlag.Parent = workspace
	
	for i,v in pairs(game.Players:GetPlayers()) do
		v.PlayerGui:WaitForChild('CaptureTheFlagUI').Enabled = true
	end
	
	local function Complete(winner)
		connection:Disconnect()
		connection2:Disconnect()
		connection3:Disconnect()
		for i,v in pairs(game.Players:GetPlayers()) do
			v.PlayerGui.CaptureTheFlagUI.Enabled = false
		end
		RedFlag:Destroy()
		BlueFlag:Destroy()
		AlertRemote:FireAllClients('The winner of this round was '..winner..'!')
		wait(5)
		BindRemote:Fire()
		return
	end
	
	local function PlayerAdded(plr)
		plr.PlayerGui.CaptureTheFlag.UI.Enabled = true
	end
	local function RedChanged()
		if game.ReplicatedStorage.ModeStorage.CaptureTheFlag.RedScore.Value > game.ReplicatedStorage.ModeStorage.CaptureTheFlag.BlueScore.Value then
			if game.ReplicatedStorage.ModeStorage.CaptureTheFlag.RedScore.Value == 3 then
				Complete('red')
			end
		end
	end
	local function BlueChanged()
		if game.ReplicatedStorage.ModeStorage.CaptureTheFlag.RedScore.Value < game.ReplicatedStorage.ModeStorage.CaptureTheFlag.BlueScore.Value then
			if game.ReplicatedStorage.ModeStorage.CaptureTheFlag.BlueScore.Value == 3 then
				Complete('blue')
			end
		end
	end
	connection = game.Players.PlayerAdded:Connect(PlayerAdded)
	connection2 = game.ReplicatedStorage.ModeStorage.CaptureTheFlag.RedScore:GetPropertyChangedSignal('Value'):Connect(RedChanged)
	connection3 = game.ReplicatedStorage.ModeStorage.CaptureTheFlag.BlueScore:GetPropertyChangedSignal('Value'):Connect(BlueChanged)
end

return module
