Burnin = class({})


function Burnin:OnAbilityPhaseStart()
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Play precast sound
	EmitSoundOn(sound_precast, caster)

	return true
end

function Burnin:OnAbilityPhaseInterrupted()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Stop precast sound
	StopSoundOn(sound_precast, caster)
end


function Burnin:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetAbsOrigin()
	local sound_cast = "Hero_Warlock.RainOfChaos"
	local particle_start = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf"
	local particle_main = "particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf"
	
	local radius = 500
	local duration = self:GetSpecialValueFor("duration")
	local effect_delay = self:GetSpecialValueFor("effect_delay")
	
	local particle_start_fx = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 0, point)
	
	--destroy trees around self
	GridNav:DestroyTreesAroundPoint(point, radius, true)
	
	Timers:CreateTimer(effect_delay, function()
		
		local particle_main_fx = ParticleManager:CreateParticle(particle_main, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_main_fx)
		
		local hero = pickBadHero(caster:GetPlayerOwnerID(), "npc_dota_hero_doom_bringer")
		hero:SetRespawnsDisabled(false)
		hero:RemoveAbility("pickinferno")
		end)
end