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

   
    
    
    
    
    --particles 

    particle_heal = ParticleManager:CreateParticle("particles/items2_fx/tranquil_boots_healing_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControl(particle_heal, 0, self.caster:GetAbsOrigin())
    self:AddParticle(particle_heal, false, false, -1, false, true)

    Timers:CreateTimer(regen_duration, function()
        if self.caster:IsAlive() then
            self.caster:SetBaseHealthRegen(base_regen)
            ParticleManager:DestroyParticle(particle_heal,false)
            self.caster:RemoveModifierByName("modifier_eat_tree_regen")
        end
    end)

    --sound

    EmitSoundOn("DOTA_Item.HealingSalve.Activate", self.caster)

end

function modifier_eat_tree_regen:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function modifier_eat_tree_regen:IsHidden() return false end


function modifier_eat_tree_regen:OnAttackLanded(keys)
    local target = keys.target
    local attacker = keys.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if caster:PassivesDisabled() then return end

    if target == self.caster then 
       
        if target:IsAlive() then
            DebugPrint("target in 2")
            self:Destroy()
            local base_regen = 0
          caster:SetBaseHealthRegen(0)
        end
    end
    
   
end
    
    