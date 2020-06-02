shock = class({})

LinkLuaModifier("modifier_shock", "abilities/unit/shock.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shock_debuff", "abilities/unit/shock.lua", LUA_MODIFIER_MOTION_NONE)

function shock:GetIntrinsicModifierName()
	return "modifier_shock"
end

modifier_shock = class({})

function modifier_shock:OnCreated()

    self.caster = self:GetCaster()
    self.parent = self:GetParent()
   
end

function modifier_shock:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
	return funcs
end

function modifier_shock:IsHidden() return true end

function modifier_shock:OnAttackLanded(keys)
    local target = keys.target
    local attacker = keys.attacker
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    
    local critchance = ability:GetSpecialValueFor("critchance")
    local critperc = ability:GetSpecialValueFor("critperc")

    if caster:PassivesDisabled() then return end
    
    if attacker == self.caster then 
        if target:IsAlive() then
            --CHANCES
            local chance = math.random(1,100)
            
            DebugPrint("chance is" .. chance )
            if chance <= critchance then 
                
                -- SOUND 
                local soundvar = math.random(1,100)
                if soundvar <= 45 then 
                    EmitSoundOn("Hero_Zuus.LightningBolt.Cast.Righteous", target)
                    
                elseif soundvar >= 46 and soundvar <= 89 then
                    EmitSoundOn("Hero_Zuus.Righteous.Layer", target)
                elseif soundvar >= 90 and soundvar <= 100 then
                    EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
                end

                --DAMAGE 
                local basedmg = caster:GetAttackDamage()
                local critdmg = (basedmg * critperc) - basedmg
            
                ApplyDamage({
                    victim = target,
                    damage = critdmg,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags 	= DOTA_DAMAGE_FLAG_HPLOSS,
                    attacker 		= self:GetCaster(),
                    ability 		= self:GetAbility()
                })
            end
        end
    end
end