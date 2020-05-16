faerie_fire = class({})

LinkLuaModifier("modifier_faerie_fire", "abilities/faerie_fire.lua", LUA_MODIFIER_MOTION_NONE)

function faerie_fire:OnSpellStart()
    local caster = self:GetCaster()
    
    local target = self:GetCursorTarget()
    local cast_sound = "Hero_Ancient_Apparition.ChillingTouch.Cast"
    EmitSoundOn(cast_sound, caster)
    local duration = self:GetSpecialValueFor("duration")
    
   -- local bonus_movement_speed = self:GetSpecialValueFor("bonus_movement_speed")
    target:AddNewModifier(caster, self, "modifier_faerie_fire", { duration = duration, bonus_movement_speed = bonus_movement_speed })

end

modifier_faerie_fire = class({})

function modifier_faerie_fire:OnCreated()
    self.ability = self:GetAbility()
    self.armor_reduction = self.ability:GetSpecialValueFor("armor_reduction")
    
    self.parent		= self:GetParent()
    self.caster		= self:GetCaster()
    local duration = self.ability:GetSpecialValueFor("duration")
    --Particle above head
    self.particle = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff_retro/leshrac_tormented_staff_retro_lvl2_magic.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	--ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
    self:AddParticle(self.particle, false, false, -1, false, true)
   self:StartIntervalThink(FrameTime())

    --vision function 
   

end

function modifier_faerie_fire:OnIntervalThink()
    AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 100, FrameTime(), false)
end

function modifier_faerie_fire:DeclareFunctions()
    return {
		
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end



function modifier_faerie_fire:GetModifierPhysicalArmorBonus()
    return self.armor_reduction
end

-- Classifications
function modifier_faerie_fire:IsHidden()
	return false    
end

function modifier_faerie_fire:IsDebuff()
	return true
end

function modifier_faerie_fire:IsPurgable()
	return true
end
