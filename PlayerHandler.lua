-- Master Script for all character handling in Medieval Ruckus, authored by nexus_x86 --

local TweenService = game:GetService('TweenService')

game.Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		local Humanoid = Character:WaitForChild('Humanoid')
		local PreviousHealth = 100
		local HealthBillboard = Character.HealthUI:Clone()
		Character.HealthUI:Destroy()
		Humanoid:GetPropertyChangedSignal('Health'):Connect(function()
			if PreviousHealth ~= 0 then
				local Difference = PreviousHealth - Humanoid.Health
				if Difference > 0 then
					PreviousHealth = Humanoid.Health
					local Billboard = HealthBillboard:Clone()
					Billboard.TextLabel.Text = '-'..Difference
					Billboard.Parent = Character
					local Tween = TweenService:Create(Billboard,TweenInfo.new(),{StudsOffset = Billboard.StudsOffset + Vector3.new(0,4,0)})
					Tween:Play()
					Tween.Completed:Wait()
					Billboard:Destroy()
				else
					Difference = Difference * -1
					PreviousHealth = Humanoid.Health
					local Billboard = HealthBillboard:Clone()
					Billboard.TextLabel.Text = '+'..Difference
					Billboard.TextLabel.TextColor3 = Color3.fromRGB(0,255,0)
					Billboard.Parent = Character
					local Tween = TweenService:Create(Billboard,TweenInfo.new(),{StudsOffset = Billboard.StudsOffset + Vector3.new(0,4,0)})
					Tween:Play()
					Tween.Completed:Wait()
					Billboard:Destroy()
				end
			end
		end)
		
		spawn(function()
			wait(.5)
			local ArrowWeld = Instance.new('Weld',Character.Arrow)
			ArrowWeld.Part0 = Character.Arrow
			ArrowWeld.Part1 = Character.LeftHand
			ArrowWeld.C0 = CFrame.new(0, 0, 0, 0.76604414, -0.111617014, 0.633023083, 0.111618854, 0.992945552, 0.0400059, -0.633022726, 0.0400110222, 0.773098588)
			ArrowWeld.C1 = CFrame.new(-0.00684833527, -0.427749634, -0.185126305, -0.803857982, 0.000168766361, -0.594821393, 0.000134474147, 1, 0.000101994054, 0.594821334, 2.00063369e-06, -0.803857923)
		end)
		
		local BagWeld = Instance.new('Weld',Character.ArrowBag.Main)
		BagWeld.Part0 = Character.ArrowBag.Main
		BagWeld.Part1 = Character.UpperTorso
		BagWeld.C0 = CFrame.new(0, 0, 0, 0.941021562, -0.3383452, 0.000997000607, 0.33834666, 0.941017509, -0.00275700144, -5.37685173e-06, 0.00293172989, 0.999995768)
		BagWeld.C1 = CFrame.new(-0.54271698, -1.19808388, 1.04211426, 1, 0, 0, 0, 1, 0, 0, 0, 1)
		
		Humanoid.BreakJointsOnDeath = false
		Humanoid.Died:Connect(function()
			local Descendants = Character:GetDescendants()
			for i,v in pairs(Descendants) do
				if v:IsA('Motor6D') then
					local socket = Instance.new("BallSocketConstraint")
					local part0 = v.Part0
					local joint_name = v.Name
					local attachment0 = v.Parent:FindFirstChild(joint_name.."Attachment") or v.Parent:FindFirstChild(joint_name.."RigAttachment")
					local attachment1 = v:FindFirstChild(joint_name.."Attachment") or part0:FindFirstChild(joint_name.."RigAttachment")
					if attachment0 and attachment1 then
						socket.Attachment0, socket.Attachment1 = attachment0, attachment1
						socket.Parent = v.Parent
						v:Destroy()
					end	
				end
			end
		end)
	end)
end)


