betainvis = class({})

function betainvis:OnSpellStart()
    DebugPrint("[EXPERIMENT] BetaInvis Spell started")
    local unit = self:GetCaster()
    EmitSoundOn("Hero_Clinkz.WindWalk", unit)
    local duration = self:GetSpecialValueFor("duration")
    local bonus_movement_speed = self:GetSpecialValueFor("bonus_movement_speed")
    unit:AddNewModifier(unit, self, "modifier_generic_invisibility", { duration = duration, bonus_movement_speed = bonus_movement_speed })
end