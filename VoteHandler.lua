--[[
	Script authored by nexus_x86. Uses module scripts to not look messy.
]]--
 
local Remotes = {}
local Votes = {} -- Table to store player votes
local Values = {}
local VoteTime = 30 -- The time given for everyone to vote
local isVoting = false -- A value to verify whether vote requests are valid
local ModeOverBindEvent = game.ServerStorage.BindableEvents.ModeOver

local CurrentMap = workspace.ClassicMap
local maps = {[CurrentMap] = true}

for i,v in pairs(game.ServerStorage.Maps:GetChildren()) do
	maps[v] = true
end


for i,v in pairs(game.ReplicatedStorage:GetDescendants()) do
	if v:IsA("RemoteEvent") then
		Remotes[v.Name] = v
	end
	if v:IsA('ValueBase') then
		Values[v.Name] = v
	end
end

local VoteInfo = require(game.ReplicatedStorage.ServerClientModules.VoteInfo)

local function ValReset() 
	--[[
		This function will only affect values in ReplicatedStorage
		it turns all boolvalues to false and intvalues to 0
	]]--
	for i,v in pairs(Values) do
		if v:IsA('BoolValue') then
			Values[i].Value = false
		elseif v:IsA('IntValue') then
			Values[i].Value = 0
		end
	end
end
function shuffle(tbl) -- shuffles tables with numerical indices
	local len, random = #tbl, math.random ;
	for i = len, 2, -1 do
		local j = random( 1, i );
		tbl[i], tbl[j] = tbl[j], tbl[i];
	end
	return tbl;
end

Remotes['VoteRemote'].OnServerEvent:Connect(function(Player,Vote)
	if isVoting == true then
		if Votes[Player] then
			Votes[Player].Value = Votes[Player].Value - 1
		else
			Values['PeopleAmountThatVoted'].Value = Values['PeopleAmountThatVoted'].Value + 1
		end
		Votes[Player] = Vote
		Vote.Value = Vote.Value + 1
	end
end)

function InitiateVote()
	--[[
		A function that initiates the vote and runs the respective module scripts
	]]--
	if #game.Players:GetPlayers() == 0 then -- Can't do a vote if theres no players
		wait(1)
		InitiateVote()
		return
	end
	
	local NewMap = game.ServerStorage.Maps:GetChildren()[math.random(#game.ServerStorage.Maps:GetChildren())]
	NewMap.Parent = workspace
	CurrentMap.Parent = game.ServerStorage.Maps
	CurrentMap = NewMap
	
	
	for i,v in pairs(game.Players:GetPlayers()) do
		v:LoadCharacter()
	end
	ValReset()
	Remotes['VoteBegin']:FireAllClients(true) -- Displays voting UI on all clients
	isVoting = true
	
	local PlayerJoinedConnection
	local function PlayerJoinedWhileVoting(Plr)
		Remotes['VoteBegin']:FireClient(Plr,true)
	end
	PlayerJoinedConnection = game.Players.PlayerAdded:Connect(PlayerJoinedWhileVoting)
	
	local AllPlayers = shuffle(game.Players:GetPlayers())
	local Teams = game.Teams:GetTeams()
	local count = 1
	
	for i,v in pairs(AllPlayers) do -- scrambles teams
		if count > #game.Teams:GetTeams() then
			count = 1
		end
		v.TeamColor = Teams[count].TeamColor
		count = count + 1
	end
	
	for i,v in pairs(AllPlayers) do
		Votes[v] = nil
	end
	Values['SecondsLeft'].Value = VoteTime
	repeat
		wait(1)
		Values['SecondsLeft'].Value = Values['SecondsLeft'].Value - 1
	until
	Values['SecondsLeft'].Value <= 0 or #game.Players:GetPlayers() <= Values['PeopleAmountThatVoted'].Value
	
	isVoting = false
	Remotes['VoteBegin']:FireAllClients(false) -- Tells all clients to not display the GUI anymore
	PlayerJoinedConnection:Disconnect()
	
	local VoteVals = {}
	for i,v in pairs(VoteInfo) do
		table.insert(VoteVals,v['Value'].Value)
	end
	table.sort(VoteVals)
	if VoteVals[#VoteVals] == VoteVals[#VoteVals-1] then
		local children = script:GetChildren()
		require(children[math.random(#children)]).run()
	else
		for i,v in pairs(VoteInfo) do
			if v['Value'].Value == VoteVals[#VoteVals] then
				require(script:FindFirstChild(v.ShortForm)).run()
			end
		end
	end
	Remotes['AlertRemote']:FireAllClients('The next round is starting!')
	local ModeOverConnection
	local function Event()
		ModeOverConnection:Disconnect()
		InitiateVote()
		return
	end
	ModeOverConnection = ModeOverBindEvent.Event:Connect(Event)
end

InitiateVote()
