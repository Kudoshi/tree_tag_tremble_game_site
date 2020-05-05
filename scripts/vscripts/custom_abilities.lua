require("addon_game_mode")
require("_util")

moditem = nil

function placeGhost(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 55.0;
    blocking_counter = 0;
    groundclickpos = GetGroundPosition(keys.target_points[1], nil);
    xpos = GridNav:WorldToGridPosX(groundclickpos.x);
    ypos = GridNav:WorldToGridPosY(groundclickpos.y);
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos);
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos);

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
    else
        --keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(),
            "Not enough mana on hero")
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        return nil
    end




--[[
    local player = keys.caster:GetPlayerOwner()

    if player == nil then
        return nil
    end


    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)




    if player.modelGhostDummy ~= nil then
        player.modelGhostDummy:RemoveSelf()
        player.modelGhostDummy = nil
    end


    local OutOfWorldVector = Vector(11000,11000,0)


    player.modelGhostDummy = CreateUnitByName(keys.unitname, OutOfWorldVector, false, nil, nil, keys.caster:GetTeam())


    local mgd = player.modelGhostDummy -- alias
    mgd.isBuildingDummy = true -- store this for later use

    local modelParticle = ParticleManager:CreateParticleForPlayer("particles/buildinghelper/ghost_model.vpcf", PATTACH_ABSORIGIN, mgd, player)

    player.ghostParticle = modelParticle;

    if modelParticle ~= nil then
        ParticleManager:SetParticleControlEnt(modelParticle, 1, mgd, 1, "follow_origin", mgd:GetAbsOrigin(), true)                      
        ParticleManager:SetParticleControl(modelParticle, 3, Vector(40,0,0))   -- alpha 0-100

        ParticleManager:SetParticleControl(modelParticle, 4, Vector(keys.unitscale,0,0))  -- scale 0-1

    end

    local centerX = groundclickpos.x;
    local centerY = groundclickpos.y;
    local z = groundclickpos.z;

    local vBuildingCenter = Vector(centerX,centerY,z)


    if modelParticle ~= nil then
        -- move model ghost particle
        ParticleManager:SetParticleControl(modelParticle, 0, vBuildingCenter)

        -- this stuff is not done yet. Recolor model green probably best
        if RECOLOR_GHOST_MODEL then
            if areaBlocked then
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,0,0))   
            else
                ParticleManager:SetParticleControl(modelParticle, 2, Vector(0,255,0))
            end
        else
            ParticleManager:SetParticleControl(modelParticle, 2, Vector(255,255,255)) -- Draws the ghost with the original colors
        end
    end
]]

end

function removeGhost(keys)
    local player = keys.caster:GetPlayerOwner()

    if player ~= nil then

        if player.ghostParticle ~= nil then
            ParticleManager:DestroyParticle(player.ghostParticle, true)
            player.ghostParticle = nil
        end
        if player.modelGhostDummy ~= nil then
            player.modelGhostDummy:RemoveSelf()
            player.modelGhostDummy = nil
        end
    
    end
end

function placeminenogold(keys)
   

    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_minenogold", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetAngles(0.0,100.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end

       
        
        
       
        
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
        
    end
end

function placeBuilding(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end

    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)

    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)

    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)


    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_mine_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if tower ~= nil then
            tower:SetAngles(0.0,100.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end

       
        
        
       
        
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
        
    end
end

function spawnghost(keys)
    print("spawning ghost");
    if keys.caster:GetClassname() == "npc_dota_hero_furion" then
        local helper = CreateUnitByName("npc_treetag_radiant_ghost_furion",
            keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber()) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    else 
        local helper = CreateUnitByName("npc_treetag_radiant_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
        
        if helper ~= nil then
            helper:SetAngles(0.0,90.0,0.0)
            helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
        end
    end
end

function spawnghostdire(keys)
    print("spawning ghost");
    local helper = CreateUnitByName("npc_treetag_dire_ghost", keys.caster:GetAbsOrigin(), false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber() ) 
    
    if helper ~= nil then
        helper:SetAngles(0.0,90.0,0.0)
        helper:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
        helper:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(helper)
    end
end

function placeWall(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;
    blocking_counter = 0

    local groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_wall_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())

        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_wall", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            learnabilities(tower)
        end

        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)

    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placeWallHelper(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;
    blocking_counter = 0

    local groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)
    local caster = keys.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end
    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_wall_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())

        if tower ~= nil then
            tower:SetContext("tagtype", "npc_treetag_building_wall", 0)
            tower:SetContext("tagtypelevel", "1", 0)
            tower:SetOwner(hero)
            tower:SetControllableByPlayer(playerID, true);
            learnabilities(tower)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        hero:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function learnyourfuckingspells(keys)
    learnabilities(keys.target)
end

function learnabilities(unit)

    if unit==nil then 
        return nil;
    end
    if not unit:IsAlive() then
        return nil;
    end

    for aaaai=0, unit:GetAbilityCount()-1 do
        local aab = unit:GetAbilityByIndex(aaaai)
        if aab ~= nil then
            if aab:GetLevel() <1 then
                aab:SetLevel(1)
            end
        end
    end
end

function placeTurret(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
    attempt_place_location = keys.target_points[1]

    local groundclickpos = GetGroundPosition(attempt_place_location, nil)
    local xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    local ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_turret_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        hero:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placesentrytower(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_sentrytower_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,270.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
            local itemNames = {
        
                "item_gem_of_true_sight"
            }
            for _, itemName in pairs(itemNames) do
                local item = CreateItem(itemName, tower, tower)
                
                tower:AddItem(item)
            end
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placeinvisiblewall(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_invisible_wall", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,270.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
            tower:SpendMana(200, nil)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placesentrytowerhelper(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)
    local caster = keys.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_sentrytower_1", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,270.0,0.0)
            tower:SetControllableByPlayer(playerID, true);
            tower:SetOwner(hero);
            learnabilities(tower)
            local itemNames = {
        
                "item_gem_of_true_sight"
            }
            for _, itemName in pairs(itemNames) do
                local item = CreateItem(itemName, tower, tower)
                
                tower:AddItem(item)
            end
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placebirdoflife(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_bird_of_life", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,270.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placebarracks(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 65.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_barracks", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,270.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end

function placelittlesaver(keys)
    if(keys.caster:GetTeam()==3) then
        return nil;
    end
    PLACED_BUILDING_RADIUS = 45.0;

    blocking_counter = 0
   

    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    if GridNav:IsTraversable(groundclickpos) then
    else
        blocking_counter = blocking_counter + 1
    end

    for _,thing in pairs(Entities:FindAllInSphere(groundclickpos, PLACED_BUILDING_RADIUS) )  do
        if thing:GetClassname() == "npc_dota_creep" or string.match(thing:GetClassname(),"npc_dota_hero") then
            blocking_counter = blocking_counter + 1
        end
    end

    if( blocking_counter < 1) then
        tower = CreateUnitByName("npc_treetag_building_littlesaver", groundclickpos, false, keys.caster, keys.caster:GetOwner(), keys.caster:GetTeamNumber())
        if tower ~= nil then
            
            tower:SetAngles(0.0,0.0,0.0)
            tower:SetControllableByPlayer(keys.caster:GetPlayerID(), true);
            tower:SetOwner(keys.caster:GetPlayerOwner():GetAssignedHero());
            learnabilities(tower)
        end
        local position = keys.caster:GetAbsOrigin()
        FindClearSpaceForUnit(keys.caster, position, true)
    else
        keys.caster:ModifyGold(keys.AbilityGoldCost,false,0)
        sendError(keys.caster:GetPlayerOwnerID(), "Cannot build there")
    end
end


function createmoditem(caster)
    if not moditem then
        moditem = CreateItem( "item_apply_modifiers", caster, caster )
    end
end






function suicidefarm(keys)
    -- farm refund amounts
    if keys.caster:GetUnitName() == "npc_treetag_building_mine_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(400+200+100+50,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(3200+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(256+128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(12800+6400+1600+800+400+200+100+50,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(512+256+128+64+32)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_mine_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(25,true,0)
    end

    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
    keys.caster:RemoveSelf()   -- must come AFTER refunds
end

function resetfarm(keys)
    if keys.caster:GetPlayerOwner() == nil then
        return
    end
    keys.caster:GetPlayerOwner():GetAssignedHero():GetItemInSlot(0):SetActivated(true)
end

function swapteam(keys)
    print("Current team of player "..keys.caster:GetPlayerOwnerID()..": "..keys.caster:GetTeam())
    if keys.caster:GetTeam()==2 then
        local newteam = 3;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        print("new team: "..newteam);
    elseif keys.caster:GetTeam()==3 then
        local newteam = 2;
        local owner = keys.caster:GetOwner();
        owner:SetTeam(newteam);
        keys.caster:SetTeam(newteam);
        print("new team: "..newteam);
    end
end

function explosionsoundoncaster(keys)
    EmitSoundOnLocationWithCaster(keys.caster:GetAbsOrigin(),"Creep_Siege_Radiant.Destruction",keys.caster)
end

function suicide(keys)
    local refundwallmod = 0.75
    local refundwallmodmana = 0.75

    if keys.caster:GetUnitName() == "npc_treetag_building_wall_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(12)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(28)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(60)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(124)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(252)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(508)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(1020)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(2044)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(4092)),true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(8188)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(32)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(16380)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(96)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(32764)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(224)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_14" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(65532)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(480)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_15" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(131068)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(992)))
    elseif keys.caster:GetUnitName() == "npc_treetag_building_wall_16" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(math.floor(refundwallmod*(262140)),true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(math.floor(refundwallmodmana*(2016)))

    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(192,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_well_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(448,true,0)

    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(8,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_2" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(32,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_3" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(64,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_4" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(128,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_5" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(256,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_6" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(512,true,0)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_7" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1024,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(16)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_8" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(2048,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_9" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(4096,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_10" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(8192,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_11" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(2000+128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_12" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(3000+2000+128+64+48)
    elseif keys.caster:GetUnitName() == "npc_treetag_building_turret_13" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(999999,true,0)
        keys.caster:GetPlayerOwner():GetAssignedHero():GiveMana(4000+3000+2000+128+64+48)

    elseif keys.caster:GetUnitName() == "npc_treetag_building_sentrytower_1" then
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(25,true,0)
        
    end

    keys.caster:RemoveSelf()   -- must come after refunds because checking info of unit
end




-- set caster's mana to assigned hero's mana


--used for cosmetic pets in a thinker
function followcaster(keys)
    if keys.target == nil then
        return nil
    end
    if keys.caster == nil then
        keys.target:RemoveSelf()
        return
    end
    if not keys.caster:IsAlive() then
        keys.target:RemoveSelf()
        return
    end
    
    local dist = CalcDistanceBetweenEntityOBB(keys.caster,keys.target);
    if dist > 450 then
        FindClearSpaceForUnit( keys.target, keys.caster:GetAbsOrigin(), true )
    end

    if dist > 60 then
        --keys.target:MoveToNPC(keys.caster)

        --local difvec = keys.target:GetAbsOrigin()+keys.caster:GetAbsOrigin()

        --local targetloc = keys.caster:GetAbsOrigin()-65*difvec:Normalized()
        local targetloc = keys.caster:GetAbsOrigin()

        local randomvec = Vector(math.random()*2-1,math.random()*2-1,0)

        targetloc = targetloc + randomvec:Normalized()*50

        keys.target:MoveToPosition(targetloc)
    end
end

function validatesuicidetarget(keys)
    if keys.target:GetPlayerOwner()~=keys.caster:GetPlayerOwner() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        return nil
    end

    keys.ability.suicidetarget = keys.target

    if string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_wall") then
    elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_turret") then
    elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_well") then
    elseif string.find(keys.ability.suicidetarget:GetUnitName(),"npc_treetag_building_sentrytower") then
    else
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
        sendError(keys.caster:GetPlayerOwnerID(), "That unit cannot be sacrificed")
        return nil
    end

end


function speedifnobuildings(keys)
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 500)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if string.find(unit:GetUnitName(), "npc_treetag_building_turret")
            or string.find(unit:GetunitName(), "npc_treetag_building_sentrytower") 
            or string.find(unit:GetUnitName(), "npc_treetag_building_wall") 
            or string.find(unit:GetUnitName(), "npc_treetag_building_well")
            or string.find(unit:GetUnitName(), "npc_treetag_building_mine") then
                return 0.5
            end
        end
    end

    createmoditem(keys.caster)
    moditem:ApplyDataDrivenModifier(keys.caster, keys.caster, "lone_wolf", {duration="0.6"})

end



function toggleautocast(keys)
    keys.ability:ToggleAutoCast()
end

--gem of true sight see invis

function givetruesight(keys)
    if not gemitem then
        gemitem = CreateItem("item_gem", keys.caster, keys.caster)
    end
    keys.caster:AddNewModifier(keys.caster, gemitem, "modifier_item_gem_of_true_sight", {duration=keys.Duration})

end 

function setabilitytarget(keys)
    keys.ability.target=keys.target
end

function canceliftargetdead(keys)
    if keys.ability.target == nil or keys.ability.target:IsNull() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    elseif not keys.ability.target:IsAlive() then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()
    end
end


-- generic-ish autocast thinker
-- used for chronoboost
function autocastspell(keys)
    -- example:
    --local targetstring = "npc_treetag_building_mine";
    --local spelltocast = "chronoboost";
    --local range = 750;
    --local avoidbuff = "fastmine";

    local targetstring = keys.targetstring;
    local spelltocast = keys.spelltocast;
    local range = keys.range;
    local avoidbuff = keys.avoidbuff;
    local castonfullhp = keys.castonfullhp;
    local ignoreidle = keys.ignoreidle;


    if keys.caster==nil then
        return 0.5
    end
    if keys.caster:IsNull() then
        return 0.5
    end

    if ignoreidle == "false" then
        if not keys.caster:IsIdle() then
            return 0.5
        end
    end

    local castthispls = keys.caster:FindAbilityByName(spelltocast)
    if castthispls==nil then
        return 0.5
    end
    if castthispls:IsNull() then
        return 0.5
    end

    if not castthispls:IsCooldownReady() then
        return 0.5
    end
    if not castthispls:GetAutoCastState() then
        return 0.5
    end

    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), range)) do
        if unit:IsAlive() and (unit:GetTeam() == keys.caster:GetTeam()) then
            if castonfullhp=="true" or unit:GetHealth() < unit:GetMaxHealth() then
                if not unit:HasModifier(avoidbuff) then
                    if string.find(unit:GetUnitName(), targetstring) then
                        keys.caster:CastAbilityOnTarget(unit, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())
                        return 0.5
                    end
                end
            end
        end
    end

    keys.caster:CastAbilityOnTarget(healtarget, keys.caster:FindAbilityByName(spelltocast), keys.caster:GetPlayerOwnerID())

end

-- autocast repair thinker
function autorepair(keys)
    if not keys.caster:IsIdle() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):IsCooldownReady() then
        return 0.5
    end
    if not keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"):GetAutoCastState() then
        return 0.5
    end

    local healtarget = nil
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 350)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:IsAlive() and (unit:GetHealth() < unit:GetMaxHealth()) then
                if string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                    keys.caster:CastAbilityOnTarget(unit, keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"), keys.caster:GetPlayerOwnerID())
                    return 0.5
                elseif string.find(unit:GetUnitName(), "npc_treetag_building_") then
                    healtarget = unit;
                end
            end
        end
    end
    if healtarget == nil then
        return 0.5
    end

    keys.caster:CastAbilityOnTarget(healtarget,
        keys.caster:GetPlayerOwner():GetAssignedHero():FindAbilityByName("tree_repair"),
        keys.caster:GetPlayerOwnerID())
end

function clearmodel(keys)
    keys.caster:SetModelScale(0.01)
end

-- used as a passive drain for timbersaw tree destroy
-- witchdoctor heal style
function eatmana(keys)
    mana = keys.ability:GetCaster():GetMana()
    if mana<20 then
        keys.ability:ToggleAbility()
    else
        keys.ability:GetCaster():ReduceMana(20)
    end
end





function goldattack(keys)
    local armor = keys.target:GetPhysicalArmorValue();
    local armormod = 1

    if armor > 0 then
        armormod = 1 - ((0.06 * armor) / (1 + 0.06 * armor));
    elseif armor < 0 then
        armormod = 1 + ((0.06 * (0 - armor)) / (1 + 0.06 * (0 - armor)));
    end
    
    local gold = math.floor( armormod * keys.attacker:GetAverageTrueAttackDamage(keys.attacker))

    popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)
end



function interruptifnotech(keys)
    local techrange = 1000

    if keys.techrange==nil then
    elseif keys.techrange == "" then
    else
        techrange=keys.techrange
    end

    if keys.techunit==nil then

    elseif keys.techunit=="" then

    else
        if techinrange(keys.caster,keys.techunit,tonumber(keys.techunitlevel),techrange) then

        else
            keys.caster:Interrupt()
            keys.caster:InterruptChannel()

            keys.ability:GetCaster():GetAbilityByIndex(0):EndCooldown() -- upgrade ability is in first slot

            -- print("notech " .. keys.techunit)

            if keys.techunit=="npc_treetag_building_wall" then
                sendError(keys.caster:GetPlayerOwnerID(),
                    "Requires nearby wall " .. keys.techunitlevel)
            elseif keys.techunit=="npc_treetag_building_well" then
                sendError(keys.caster:GetOwner():GetPlayerID(),
                    "Requires nearby well " .. keys.techunitlevel)
            end

            return                      -- return if tech not found
        end
    end


    local manaprice = keys.ability:GetManaCost(0)

    if manaprice==0 then
        return                      -- return if no mana cost
    end

    if keys.caster:GetPlayerOwner():GetAssignedHero():GetMana() < manaprice then
        keys.caster:Interrupt()
        keys.caster:InterruptChannel()

        keys.ability:EndCooldown() -- upgrade ability is in first slot

        sendError(keys.caster:GetPlayerOwnerID(),
            "Not enough mana on hero")
        StartSoundEvent("treant_treant_nomana_01", keys.caster:GetPlayerOwner():GetAssignedHero())
        
        --print("nomana")
    else
        keys.caster:GetPlayerOwner():GetAssignedHero():SpendMana(manaprice, nil)
    end

end


function cancelifnomana(keys)
    --local manacost = keys.ability:GetManaCost(0)
    --local heromana = keys.caster:GetPlayerOwner():GetAssignedHero():GetMana()
    --print(manacost.."/"..heromana)
    --if manacost > heromana then
    --    keys.caster:Interrupt()
    --    keys.caster:InterruptChannel()
    --end
end



function refundcost(keys)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(keys.ability:GetGoldCost(1), true, 0)
end

function dailygold(keys)
    --gives 1 gold every 5 sec
    if keys.caster == nil or keys.caster:GetPlayerOwner() == nil then
        return nil
    end
    
    local heroname = keys.caster:GetUnitName()

    

    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(1, true, 0)
end

function dailyinfgold(keys)
    --gives 15 gold every 5 sec
    if keys.caster == nil or keys.caster:GetPlayerOwner() == nil then
        return nil
    end
    
    local heroname = keys.caster:GetUnitName()

    

    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(15, true, 0)
end

function passiveincome(keys)
    if keys.caster == nil or keys.caster:GetPlayerOwner() == nil then
        return nil
    end

    local resourcetreename = keys.caster:GetUnitName()  --get units name

    if resourcetreename == "npc_treetag_building_mine_1" then
        local gold = 1
        popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
     keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)
    elseif resourcetreename == "npc_treetag_building_mine_2" then
        local gold = 4
        popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
     keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)
    elseif resourcetreename == "npc_treetag_building_mine_3" then
        local gold = 7
        popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
        keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)
    end
    

end

function passivegold(keys)
    if keys.caster == nil or keys.caster:GetPlayerOwner() == nil then
        return nil
    end

    local goldMineLevel = string.gsub(keys.caster:GetUnitName(), "(npc_treetag_building_mine_)", "")
    local gold = 2 ^ (goldMineLevel - 1);

    if keys.caster:HasModifier("slowmine") or keys.caster:HasModifier("scannedmine") then
        gold = math.floor(gold*0.5+0.5)
    end

    -- round up most of the time
    if keys.caster:HasModifier("fastmine") then
        gold = math.floor(gold * 1.2 + 0.9)
    end

    popupNumbers(keys.caster, "gold", Vector(255, 200, 33), 1.0, gold, nil, nil)
    keys.caster:GetPlayerOwner():GetAssignedHero():ModifyGold(gold, true, 0)

    for _, unit in pairs(Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                if string.find(unit:GetUnitName(), "npc_treetag_building_mine") then
                    -- apply slow mine debuff
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "slowmine", {duration = "1.5"})    -- overlap important or code below doesnt detect the modifier
                end
            end
        end
    end

end


function turretreducedamage(keys)
    for _,unit in pairs( Entities:FindAllByClassnameWithin("npc_dota_creep", keys.caster:GetAbsOrigin(), 600)) do
        if unit:GetTeam() == keys.caster:GetTeam() then
            if unit:GetPlayerOwnerID() ~= keys.caster:GetPlayerOwnerID() then
                if string.find(unit:GetUnitName(), "npc_treetag_building_turret") then
                    -- apply reduced damage to turret
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "reduceddamage", {duration = "1.5"})
                elseif string.find(unit:GetUnitName(), "npc_treetag_building_wall") then
                    -- reduce armor of wall
                    local item = CreateItem( "item_apply_stack_debuffs", unit, unit )
                    item:ApplyDataDrivenModifier(unit, unit, "reducedarmor", {duration = "1.5"})
                end
            end
        end
    end
end

function RevealArea( event )

    if event.caster == nil or event.caster:GetPlayerOwner() == nil then
        return nil
    end

	local caster = event.caster
	local point = caster:GetAbsOrigin()
	local visionRadius = string.match(GetMapName(),"winter") and event.Radius*1.75 or event.Radius
	local visionDuration = event.Duration
	AddFOWViewer(caster:GetTeamNumber(), point, visionRadius, visionDuration, false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
	local timeElapsed = 0
	Timers:CreateTimer(0.03,function()
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_invisible") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		timeElapsed = timeElapsed + 0.03
		if timeElapsed < visionDuration then
			return 0.03
		end
    end)
    
    if caster == nil then 
    end
end

function RevealItemArea( event )

	local caster = event.caster
	local point = event.target_points[1]
	local visionRadius = string.match(GetMapName(),"winter") and event.Radius*1.75 or event.Radius
	local visionDuration = event.Duration
	AddFOWViewer(caster:GetTeamNumber(), point, visionRadius, visionDuration, false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
	local timeElapsed = 0
	Timers:CreateTimer(0.03,function()
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_invisible") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		timeElapsed = timeElapsed + 0.03
		if timeElapsed < visionDuration then
			return 0.03
		end
	end)
end
function truesight(event)
    local caster = event.caster
    local point = caster:GetAbsOrigin()
    local visionRadius = string.match(GetMapName(),"winter") and event.Radius*1.75 or event.Radius
    local units = FindUnitsInRadius(caster:GetTeamNumber(), point , nil, visionRadius , DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , DOTA_UNIT_TARGET_FLAG_NONE, 0 , false)
    local timeElapsed = 0
    Timers:CreateTimer(0.03,function()
		for _,unit in pairs(units) do
			if unit:HasModifier("modifier_invisible") then
				unit:RemoveModifierByName("modifier_invisible")
			end
		end
		timeElapsed = timeElapsed + 0.03
		if timeElapsed < visionDuration then
			return 0.03
		end
	end)
end
function savedeadentlua(keys)
    local herotargetted1 = keys.target:GetUnitName()
    DebugPrint("[EXPERIMENT]hero targetted is: " .. herotargetted1)
    if herotargetted1 == "npc_dota_hero_earth_spirit" then
        keys.target:ForceKill(false)
    else 
        sendError(keys.caster:GetPlayerOwnerID(), "You can only use this skill on Dead Ents")
    end
    
end

function hirelightarcher(event)
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_light_archer", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    caster:RemoveItem(caster:FindItemInInventory("item_hire_light_archer"))
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
end

function hireburningarcher(event)
    
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_burning_archer", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    caster:RemoveItem(caster:FindItemInInventory("item_hire_burning_archer"))
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
end

function hireundeadlumberjack(event)
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_undead_lumberjack", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    caster:RemoveItem(caster:FindItemInInventory("item_hire_undead_lumberjack"))
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
end

function hireenthelper(event)
    local caster = event.caster
    local ability = event.ability
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_ent_helper", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
    


    local itemNames = {
       
        'item_ent_tree_cutting',
        "item_ent_blink"
        
       
    }
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, unit, unit)
        
        unit:AddItem(item)
    end
       
end

function traintreefighter(event)
    
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_tree_fighter", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)

    --function to debug its spawn

    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)

    
end

function trainchameleon(event)
    
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_chameleon", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
    
end

function traintrapper(event)
    
    local caster = event.caster
    local playerID = caster:GetPlayerOwnerID()
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    local unit = CreateUnitByName("npc_treetag_creep_trapper", caster:GetAbsOrigin() , true, nil, nil, hero:GetTeamNumber())
    unit:SetOwner(hero)
    unit:SetControllableByPlayer(playerID,true)
    learnabilities(unit)
    local position = unit:GetAbsOrigin()
    FindClearSpaceForUnit(unit, position, true)
end

function blinkconsumable(keys)
    local caster = keys.caster
    groundclickpos = GetGroundPosition(keys.target_points[1], nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)
    FindClearSpaceForUnit(caster, groundclickpos, true)
    caster:RemoveItem(caster:FindItemInInventory("item_blinking_scroll"))
end

function potofhealing(keys)
    local caster = keys.caster
    local heal = 3000
    local hp = caster:GetHealth()
    local healthset = hp + heal
    caster:SetHealth(healthset)
    caster:RemoveItem(caster:FindItemInInventory("item_pot_of_healing"))
end

function potofmana(keys)
    local caster = keys.caster
    local mana = 500
    caster:GiveMana(mana)
    caster:RemoveItem(caster:FindItemInInventory("item_pot_of_mana"))
end

function Blink(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	local casterPos = caster:GetAbsOrigin()
	--local pid = caster:GetPlayerID()
	local difference = point - casterPos
	local ability = keys.ability
	local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))

	if difference:Length2D() > range then
		point = casterPos + (point - casterPos):Normalized() * range
	end

	FindClearSpaceForUnit(caster, point, false)
	ProjectileManager:ProjectileDodge(caster)
	
	local blinkIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_blink_start.vpcf", PATTACH_ABSORIGIN, caster)
	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle( blinkIndex, false )
		return nil
		end
	)
end

function crystalball(keys)
    DebugPrint("crystal ball activated")
    local caster = keys.caster
    caster:RemoveItem(caster:FindItemInInventory("item_activate_crystal_ball_of_true_eye"))
    local item = CreateItem("item_crystal_ball_of_true_eye", caster, caster)
    caster:AddItem(item)
end