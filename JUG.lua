local module = {}
local AlertRemote = game.ReplicatedStorage.Remotes.AlertRemote
local BindEvent = game.ServerStorage.BindableEvents.ModeOver
module.run = function()
	local Allplayers = game.Players:GetPlayers()
	local luckyBoy = Allplayers[math.random(#Allplayers)]
	luckyBoy:LoadCharacter()
	AlertRemote:FireAllClients('The juggernaut is '..luckyBoy.Name..'!')
	for i,v in pairs(luckyBoy.Character:GetDescendants()) do
		if v:IsA('BasePart') then
			local adornment = Instance.new('SelectionBox')
			adornment.Parent = v
			adornment.Adornee = v
		end
	end
	local connection
	local connection2
	local connection3
	local connection4
	for i,v in pairs(game.Players:GetPlayers()) do
		if v ~= luckyBoy then
			if v.TeamColor == luckyBoy.TeamColor then
				if luckyBoy.TeamColor == BrickColor.new('Really red') then
					v.TeamColor = BrickColor.new('Really blue')
				elseif luckyBoy.TeamColor == BrickColor.new('Really blue') then
					v.TeamColor = BrickColor.new('Really red')
				end
			end
		end
		v.PlayerGui.JuggernautUI.Enabled = true
	end
	local function Complete(winner)
		for i,v in pairs(game.Players:GetPlayers()) do
			v.PlayerGui.JuggernautUI.Enabled = false
		end
		connection:Disconnect()
		connection2:Disconnect()
		connection3:Disconnect()
		connection4:Disconnect()
		AlertRemote:FireAllClients('The winner of this round was '..winner..'!')
		wait(5)
		BindEvent:Fire()
	end
	local function PlayerLeft(plr)
		if plr == luckyBoy then
			Complete('everybody else')
		end
	end
	local function PlayerDied()
		Complete('everybody else')
	end
	local function ValueChanged()
		if game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value == 0 then
			Complete('the juggernaut')
		else
			wait(1)
			game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value = game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value - 1
		end
	end
	local function PlayerAdded(plr)
		if plr.TeamColor == luckyBoy.TeamColor then
			if luckyBoy.TeamColor == BrickColor.new('Really red') then
				plr.TeamColor = BrickColor.new('Really blue')
			else
				plr.TeamColor = BrickColor.new('Really red')
			end
		end
		plr.PlayerGui.JuggernautUI.Enabled = false
	end
	game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value = 120
	local char = luckyBoy.Character
	char.Humanoid.MaxHealth = #game.Players:GetPlayers() * 100
	char.Humanoid.Health = char.Humanoid.MaxHealth
	char.Humanoid.WalkSpeed = 16 + #game.Players:GetPlayers()
	connection = game.Players.PlayerRemoving:Connect(PlayerLeft)
	connection2 = char.Humanoid.Died:Connect(PlayerDied)
	connection3 = game.Players.PlayerAdded:Connect(PlayerAdded)
	connection4 = game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft:GetPropertyChangedSignal('Value'):Connect(ValueChanged)
	game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value = game.ReplicatedStorage.ModeStorage.Juggernaut.TimeLeft.Value - 1
end

return module
