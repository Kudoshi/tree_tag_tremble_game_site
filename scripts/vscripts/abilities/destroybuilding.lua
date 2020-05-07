item_destroy_building= class({})

function item_destroy_building:OnAbilityPhaseStart()
    local target = self:GetCursorTarget()
    local buildingownerid = target:GetPlayerOwnerID()
    local caster = self:GetCaster()
    local casterid = caster:GetPlayerOwnerID()

    if casterid == buildingownerid then 
        return true
    else
        return nil 
    end
end

function item_destroy_building:GetAbilityTextureName()
    return "item_destroy"
end 

function item_destroy_building:OnChannelFinish(bInterrupted)
    
    local target = self:GetCursorTarget()
    
    
    if bInterrupted then
        return nil
    else
        ApplyDamage({

            victim		= target,

            attacker	= self:GetCaster(),

            damage		= 500,

            damage_type	= DAMAGE_TYPE_MAGICAL,

            ability		= self.ability,

        })
       -- target:ForceKill(false)
    end
end
