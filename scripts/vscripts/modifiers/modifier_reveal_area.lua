function RevealArea( event )

    if event.caster == nil or event.caster:GetPlayerOwner() == nil then
        return nil
    end

	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local visionRadius = string.match(GetMapName(),"winter") and event.Radius*1.75 or event.Radius
	local visionDuration = event.Duration
	AddFOWViewer(caster:GetTeamNumber(), point, visionRadius, visionDuration, false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
	local timeElapsed = 0
	Timers:CreateTimer(0.03,function()
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_invisible") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		timeElapsed = timeElapsed + 0.03
		if timeElapsed < visionDuration then
			return 0.03
		end
    end)
    
    if caster == nil then 
    end
end