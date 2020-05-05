modifier_minimap = class({})

if IsServer() then
    function modifier_minimap:CheckState()
        local state = {
            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
            [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
            [MODIFIER_STATE_INVULNERABLE] = true,
            [MODIFIER_STATE_UNSELECTABLE] = true,
            [MODIFIER_STATE_NO_HEALTH_BAR] = true,
            [MODIFIER_STATE_OUT_OF_GAME] = true,
            [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
            [MODIFIER_STATE_PROVIDES_VISION] = false,
        }
        return state
    end
    function modifier_minimap:OnCreated( params )    
        local unit = self:GetParent()
        unit:SetDayTimeVisionRange(0)
        unit:SetNightTimeVisionRange(0)
        --unit:AddEffects(EF_NODRAW)
    end
end

function modifier_minimap:IsHidden()
    return true
end
-----------------------------------------------------------------
