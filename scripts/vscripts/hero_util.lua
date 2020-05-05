--changing some api commands

function clearInventory(hero)
    for i=0,15 do
        local item = hero:GetItemInSlot(i)
        if item then
            item:RemoveSelf()
        end
    end
end

function pickHero(ownerId, unitId)
    --ent pick hero
    local hero = PlayerResource:ReplaceHeroWith(
    	ownerId,
    	unitId, 50, 0)
    for i=0,16 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(1)
        end
    end
    hero:SetAbilityPoints(0)
    return hero
end

function pickBadHero(ownerId, unitId)

    --inferno pick inferno hero
    local hero = PlayerResource:ReplaceHeroWith(
    	ownerId,
    	unitId, 100, 0)
    for i=0,16 do
       
        
    end
    
    return hero
end

function pickDeadEnt(ownerId, unitId)

   --pick dead ent hero
    local hero = PlayerResource:ReplaceHeroWith(
    	ownerId,
    	unitId, 0, 0)
    for i=0,16 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(1)
        end
    end
    hero:SetAbilityPoints(0)
    
    
    return hero
end