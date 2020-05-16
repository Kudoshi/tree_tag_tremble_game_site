force_of_nature = class({})

require("abilities/tree_management")

function force_of_nature:OnSpellStart()
    local caster = self:GetCaster()
    local radius = self:GetSpecialValueFor("radius")
    local target_point = self:GetCursorPosition()
    local trees = GridNav:GetAllTreesAroundPoint(target_point, radius, false)
    local amounttrees = 0
    local caster_team = caster:GetTeam()
    
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local creepcount = 0
   
    for i, tree in ipairs(trees) do
		tree:CutDown(caster_team)
        AddDestroyedTree(tree)
        amounttrees = amounttrees + 1
    end
   

    while(amounttrees>creepcount and creepcount>=0 and creepcount<3)
    do
        local creep = CreateUnitByName("npc_treetag_creep_elite_tree_fighter", target_point, true, nil, nil, caster:GetTeamNumber())
        creep:SetOwner(self:GetCaster())
        creep:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(),true)
        local position = creep:GetAbsOrigin()
     FindClearSpaceForUnit(creep, position, true)
        creepcount = creepcount + 1
    end
end

function force_of_nature:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
