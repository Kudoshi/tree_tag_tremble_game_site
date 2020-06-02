abolish_magic = class({})

function abolish_magic:OnSpellStart()
    local caster = self:GetCaster()
    local casterteam = caster:GetTeamNumber()

    local target = self:GetCursorTarget()
    local targetteam = target:GetTeamNumber()
    
    
    --self.ability = self:GetAbility()
    self.damage = self:GetSpecialValueFor("damage")
    
    if casterteam == targetteam then 
        target:Purge(false, true, false, false, false)
    elseif casterteam ~= targetteam then 
        target:Purge(true, false, false, false, false)
    end
    EmitSoundOn("DOTA_Item.Nullifier.Cast" , target)
    --in future can do it to deal damage against summoned inf unit

end