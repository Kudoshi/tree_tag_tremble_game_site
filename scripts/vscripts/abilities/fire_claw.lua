fire_claw = class({})

LinkLuaModifier("modifier_fire_claw", "abilities/fire_claw.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_fire_claw_debuff", "abilities/fire_claw.lua", LUA_MODIFIER_MOTION_NONE)

function fire_claw:GetIntrinsicModifierName()
	return "modifier_fire_claw"
end

--MODIFIER

modifier_fire_claw = class({})

function modifier_fire_claw:OnCreated()

    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.damage = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_fire_claw:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function modifier_fire_claw:IsHidden() return true end

function modifier_fire_claw:OnAttackLanded(keys)
    local target = keys.target
    local attacker = keys.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local duration = ability:GetSpecialValueFor("duration")
    local damage = ability:GetSpecialValueFor("damage")

    if caster:PassivesDisabled() then return end
    
    if attacker == self.caster then 
        if target:IsAlive() then
            target:AddNewModifier(target, self, "modifier_fire_claw_debuff", { duration = duration})
        end
    end
end

function modifier_fire_claw:GetAbilityTextureName()
    return "fireclaw"
end

modifier_fire_claw_debuff = class({})


function modifier_fire_claw_debuff:IsDebuff() return true end
function modifier_fire_claw_debuff:IsHidden() return false end
function modifier_fire_claw_debuff:IsStunDebuff() return false end
function modifier_fire_claw_debuff:RemoveOnDeath() return true end

function modifier_fire_claw_debuff:OnCreated(keys)
    --Could not figure out how to get the value for damage so just going to hard bake it
    --self.damage = self:GetAbility():GetSpecialValueFor("damage")

  --Particle above head
  self.parent		= self:GetParent()
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_generic.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, true)

  self.particle2 = ParticleManager:CreateParticle("particles/econ/items/lina/lina_fire_lotus/lina_fire_lotus_ambient.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.particle2, 0, self.parent:GetAbsOrigin())
  self:AddParticle(self.particle2, false, false, -1, false, true)



    self:OnIntervalThink()
    self:StartIntervalThink(1)
end

function modifier_fire_claw_debuff:GetAbilityTextureName()
    return "fireclaw"
end


function modifier_fire_claw_debuff:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= 75,  --Change if necessary
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
	
	
end
