modifier_eat_tree_regen = class({})

function modifier_eat_tree_regen:OnCreated()

    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
    --DebugPrint(self.caster:GetEntityIndex())

    local base_regen = 0
    local temp_regen = 14
    local regen_duration = 30
    
    self.caster:SetBaseHealthRegen(temp_regen)

   
    
    Timers:CreateTimer(regen_duration, function()
        if self.caster:IsAlive() then
            self.caster:SetBaseHealthRegen(base_regen)
        end
		
		
    end)
    
    DebugPrint("Modifier accessed")
    --particles 

    self.particle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor_seedlings_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControl(self.particle, 0, self.caster:GetAbsOrigin())
    self:AddParticle(self.particle, false, false, -1, false, true)

end

function modifier_eat_tree_regen:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
	return funcs
end

function modifier_eat_tree_regen:IsHidden() return false end


function modifier_eat_tree_regen:OnDeath(keys)
    local target = keys.unit    
    local caster = self:GetCaster()

    for k, v in ipairs(keys) do
        DebugPrint(keys)
    
    end
end
    
    