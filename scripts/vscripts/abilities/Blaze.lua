Blaze = class({})


function Blaze:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Play precast sound
	EmitGlobalSound(sound_precast)

	return true
end

function Blaze:OnAbilityPhaseInterrupted()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Stop precast sound
	StopGlobalSound(sound_precast)
end


function Blaze:OnSpellStart()

	local caster = self:GetCaster()
	local point = caster:GetAbsOrigin()
	local sound_cast = "Hero_Warlock.RainOfChaos"
	local particle_start = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf"
	local particle_main = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf" 
	
	--radius for destroy trees around spawn
	local radius = 500
	
	--delay before inferno spawns
	local effect_delay = 0.3
	
	--create sound of chaotic offering
	local particle_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 0, point)
	EmitGlobalSound(sound_cast)
	
	--destroy trees around self
	GridNav:DestroyTreesAroundPoint(point, radius, true)
	
	Timers:CreateTimer(effect_delay, function()
		--particle stuff
		local particle_main_fx = ParticleManager:CreateParticle(particle_main, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, point)
		ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		
		local hero = PlayerResource:ReplaceHeroWith(caster:GetPlayerOwnerID(), "npc_dota_hero_doom_bringer", 100, 0)
		DebugPrint(tostring(caster:GetPlayerOwnerID()))
		hero:SetRespawnsDisabled(false)
		
		if hero:HasAbility("pickinferno") then
			hero:RemoveAbility("pickinferno")
		end
		--Give inferno ward
		local item = CreateItem("item_ward_observe", hero, hero)
		hero:AddItem(item)
	end)
end
