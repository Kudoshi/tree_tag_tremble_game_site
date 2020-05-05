unitinvi = class({})

LinkLuaModifier("modifier_go_invi", "abilities/unitinvi.lua", LUA_MODIFIER_MOTION_NONE)

function unitinvi:OnSpellStart()
    local caster = self:GetCaster()
    EmitSoundOn("Hero_Clinkz.WindWalk", caster)
    local target = self:GetCursorTarget()
    local duration = self:GetSpecialValueFor("duration")
    
   -- local bonus_movement_speed = self:GetSpecialValueFor("bonus_movement_speed")
    target:AddNewModifier(caster, self, "modifier_go_invi", { duration = duration, bonus_movement_speed = bonus_movement_speed })

end

--go invi modifier property below

modifier_go_invi = class({})


function modifier_go_invi:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
end

--------------------------------------------------------------------------------
-- Classifications
function modifier_go_invi:IsHidden()
	return false    
end

function modifier_go_invi:IsDebuff()
	return false
end

function modifier_go_invi:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_go_invi:OnCreated()
   
    
    self.ability = self:GetAbility()
    

    self.bonus_movement_speed = self.ability:GetSpecialValueFor("bonus_movement_speed")
end


function modifier_go_invi:GetModifierMoveSpeedBonus_Constant(params)
    return self.bonus_movement_speed
end

function modifier_go_invi:GetModifierInvisibilityLevel()
    return 1
end



function modifier_go_invi:OnAbilityExecuted(params)
    
    if params.unit == self:GetParent() then
        DebugPrint("Accessed ability executed")
     self:Destroy()
    end
end

function modifier_go_invi:CheckState() 
    local state = {
        [MODIFIER_STATE_INVISIBLE] = true
        
    }
  
    return state
end

