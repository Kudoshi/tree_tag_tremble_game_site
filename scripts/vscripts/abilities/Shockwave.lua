LinkLuaModifier("modifier_shockwave_pull", "abilities/Shockwave", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_shockwave_slow", "abilities/Shockwave", LUA_MODIFIER_MOTION_NONE)

Shockwave = class({})


function Shockwave:GetAbilityTextureName()
	return "magnataur_shockwave"
end

function Shockwave:OnAbilityPhaseStart()
	if IsServer() then
		local caster = self:GetCaster()
		caster:EmitSound("Hero_Magnataur.ShockWave.Cast")
		self.swing_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
		local swing = self.swing_fx
		ParticleManager:SetParticleControlEnt(self.swing_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.swing_fx, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		Timers:CreateTimer(self:GetBackswingTime(), function()
			ParticleManager:DestroyParticle(swing, false)
			ParticleManager:ReleaseParticleIndex(swing)
		end)
		return true
	end
end

function Shockwave:OnAbilityPhaseInterrupted()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Magnataur.ShockWave.Cast")
		ParticleManager:DestroyParticle(self.swing_fx, false)
		return true
	end
end


function Shockwave:OnSpellStart()
	
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	local caster_loc = caster:GetAbsOrigin()
	local sound_cast = "Hero_Magnataur.ShockWave.Cast"
	local shockwave_dummy = CreateModifierThinker(caster, self, nil, {}, caster_loc, caster:GetTeamNumber(), false)
	local dummy = EntIndexToHScript(shockwave_dummy:entindex())
	local shockwave_particle = "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf"
	
	EmitGlobalSound(sound_cast)
	
	local damage = self:GetSpecialValueFor("shock_damage")
	local distance = self:GetCastRange(caster_loc,caster) + caster:GetCastRangeBonus()
	
	local speed = self:GetSpecialValueFor("shock_speed")
	local radius = self:GetSpecialValueFor("shock_width")
	local direction = (target_loc - caster_loc):Normalized()
	
	-- Creating a unique list of hit-Targets, delete it after 15 secs
	local index = "hit_targets_" .. tostring(GameRules:GetDOTATime(true,true))
	self[index] = {}
	self[index .. "_counter"] = secondary_occurance
	Timers:CreateTimer(15, function()
		self[index] = nil
		self[index .. "_counter"] = nil
	end)
	
	-- Play cast sound on dummy, which tracks the shockwave
	shockwave_dummy:EmitSound("Hero_Magnataur.ShockWave.Particle")
	
	ProjectileManager:CreateLinearProjectile({
		
		Ability						= self,
		Source						= caster,
		vSpawnOrigin				= caster_loc,
		
		iUnitTargetTeam				= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType				= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		
		EffectName					= shockwave_particle,
		fDistance					= distance,
		fStartRadius				= radius,
		fEndRadius					= radius,
		vVelocity					= (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("shock_speed") * Vector(1, 1, 0),

		bProvidesVision				= false,
		iVisionRadius				= 0,
		iVisionTeamNumber			= self:GetCaster():GetTeamNumber(),
		
		ExtraData = {
			index				= index,
			damage				= damage,
			distance			= distance,
			speed				= speed,
			direction_x			= direction.x,
			direction_y			= direction.y,
			radius				= radius,
			magnetize_shockwave	= 0,
			talent				= 1,
			caster_loc_x		= caster_loc.x,
			caster_loc_y		= caster_loc.y,
			main_shockwave		= true,
			dummy_index			= shockwave_dummy:entindex()
		}
	})
end


function Shockwave:OnProjectileThink_ExtraData(location, data)
	
	--destroy tree
	if data.dummy_index then
		EntIndexToHScript(data.dummy_index):SetAbsOrigin(location)
	end
	
	GridNav:DestroyTreesAroundPoint(location, 50, true)
end

function Shockwave:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target then
		local caster = self:GetCaster()

		target:AddNewModifier(caster, self, "modifier_shockwave_pull", {duration = self:GetSpecialValueFor("pull_duration") * (1 - target:GetStatusResistance()), x = location.x, y = location.y})
		target:AddNewModifier(caster, self, "modifier_shockwave_slow", {duration = self:GetSpecialValueFor("slow_duration") * (1 - target:GetStatusResistance())})
		ApplyDamage({victim = target, attacker = caster, ability = self, damage = ExtraData.damage, damage_type = self:GetAbilityDamageType()})
	end
end


-----------------------------
-- SHOCKWAVE PULL MODIFIER --
-----------------------------

modifier_shockwave_pull = class({})
		
function modifier_shockwave_pull:OnCreated(params)
	if not IsServer() then return end
	
	self.ability				= self:GetAbility()
	self.parent					= self:GetParent()
	
	-- AbilitySpecials
	self.pull_duration		= self.ability:GetSpecialValueFor("pull_duration")
	self.pull_distance		= self.ability:GetSpecialValueFor("pull_distance")
	
	-- Calculate speed at which modifier owner will be pulled towards
	self.pull_speed				= self.pull_distance / self.pull_duration
	
	-- Get the center of the shockwave to know which direction to get pulled towards
	self.position	= GetGroundPosition(Vector(params.x, params.y, 0), nil)

	self.parent:StartGesture(ACT_DOTA_FLAIL)
	
	if self:ApplyHorizontalMotionController() == false then 
		self:Destroy()
		return
	end
end

function modifier_shockwave_pull:UpdateHorizontalMotion( me, dt )
	if not IsServer() then return end

	local distance = (self.position - me:GetOrigin()):Normalized()
	
	me:SetOrigin( me:GetOrigin() + distance * self.pull_speed * dt )
end

function modifier_shockwave_pull:OnDestroy()
	if not IsServer() then return end

	-- Destroy trees around landing zone
	GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
	
	self.parent:FadeGesture(ACT_DOTA_FLAIL)
	
	self.parent:RemoveHorizontalMotionController( self )
end

-----------------------------
-- SHOCKWAVE SLOW MODIFIER --
-----------------------------

modifier_shockwave_slow = class({})

function modifier_shockwave_slow:GetEffectName()
	return "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf"
end

function modifier_shockwave_slow:OnCreated()
	self.movement_slow	= self:GetAbility():GetSpecialValueFor("movement_slow") * (-1)
end

function modifier_shockwave_slow:DeclareFunctions()
	local decFuncs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
	
	return decFuncs
end

function modifier_shockwave_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_slow
end
