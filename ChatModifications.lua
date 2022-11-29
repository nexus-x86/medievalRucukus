local Players = game:GetService('Players')
local ServerScriptService = game:GetService('ServerScriptService')

local ChatService = require(ServerScriptService:WaitForChild('ChatServiceRunner'):WaitForChild('ChatService'))

local ChatTags = {
	{
		['Tag'] = 'Owner',
		['NameColor'] = Color3.fromRGB(255,0,255),
		['ChatColor'] = Color3.fromRGB(255,255,0),
		['TagColor'] = Color3.fromRGB(255,0,0),
		['Players'] = {'nexus_x86'}
	},
	{
		['Tag'] = 'Head Admin',
		['NameColor'] = Color3.fromRGB(255,255,0),
		['ChatColor'] = Color3.fromRGB(255,0,255),
		['TagColor'] = Color3.fromRGB(255,0,255),
		['Players'] = {'GeometryDash6184'}
	}
}

ChatService.SpeakerAdded:Connect(function(PlayerName)
	local Speaker = ChatService:GetSpeaker(PlayerName)
	for i,v in pairs(ChatTags) do
		for _,plrname in pairs(v['Players']) do
			if plrname == PlayerName then
				Speaker:SetExtraData('NameColor', v['NameColor'])
				Speaker:SetExtraData('ChatColor', v['ChatColor'])
				Speaker:SetExtraData('Tags', {{TagText = v['Tag'], TagColor = v['TagColor']}})
			end
		end
	end
end)
