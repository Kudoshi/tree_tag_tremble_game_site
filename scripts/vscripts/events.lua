require('libraries/notifications')

function CTreeTagGameMode:OnNPCSpawned(keys) --All entity spawned will start here
    DebugPrint("------------------------------------------------------------------")
    local npc = EntIndexToHScript(keys.entindex)
    local heroname = npc:GetUnitName()
    DebugPrint("OnNPCSpawned:" .. heroname)
    DebugPrintTable(keys)
    
    
    
    local tempdeadentcount = CTreeTagGameMode.DeadEntCount 
    DebugPrint(heroname)

    --function to remove excess dead ent from reviving due to bug 
    if npc.bFirstSpawned == true then   
        if heroname == "npc_dota_hero_earth_spirit" then
            npc:SetRespawnsDisabled(true) 
            CTreeTagGameMode.ExtraDeadEntCount = CTreeTagGameMode.ExtraDeadEntCount + 1
           
            
            if CTreeTagGameMode.ExtraDeadEntCount > CTreeTagGameMode.DeadEntCount then
                npc:Destroy()
                DebugPrint("[BUG) Removed extra dead ent")
                CTreeTagGameMode.ExtraDeadEntCount = CTreeTagGameMode.ExtraDeadEntCount - 1
            elseif CTreeTagGameMode.ExtraDeadEntCount == CTreeTagGameMode.DeadEntCount then
            end
        elseif heroname == "npc_dota_hero_doom_bringer" then
            CTreeTagGameMode.InfernoCount =  CTreeTagGameMode.InfernoCount + 1
        end
    end
    
    

    

    --innate skill upgrade
  
    local innateAbilityName = "inferno_tree_cutting"
    local innateAbility2Name = "inferno_aoe_destroy_tree"
    local innateAbility3Name = "invul"
    local innateAbility4Name = "picktree"
    local innateAbility5Name = "pickinferno"
    local innateAbility6Name = "dailyinfgold"

    --Ent innate skill 
    if npc:IsRealHero() and npc:HasAbility(innateAbility3Name) then
        npc:FindAbilityByName(innateAbility3Name):SetLevel(1)
    end
    if npc:IsRealHero() and npc:HasAbility(innateAbility4Name) then
        npc:FindAbilityByName(innateAbility4Name):SetLevel(1)
    end
    if npc:IsRealHero() and npc:HasAbility(innateAbility5Name) then
        npc:FindAbilityByName(innateAbility5Name):SetLevel(1)
    end
    
    if heroname == "npc_dota_hero_doom_bringer" then 
        
        if npc.bFirstSpawned == nil then  --prevents skills from resetting
            
            --inferno innate skill
            if npc:IsRealHero() and npc:HasAbility(innateAbilityName) then
                npc:FindAbilityByName(innateAbilityName):SetLevel(1)
            end
                
            if npc:IsRealHero() and npc:HasAbility(innateAbility2Name) then
                npc:FindAbilityByName(innateAbility2Name):SetLevel(1)
            end

            if npc:IsRealHero() and npc:HasAbility(innateAbility6Name) then
                npc:FindAbilityByName(innateAbility6Name):SetLevel(1)
            end
        end
        --Prevents inferno from getting stuck when spawned 

        local position = npc:GetAbsOrigin()
        FindClearSpaceForUnit(npc, position, true)
    end
        
   

    --Reroute to OnHeroIngame in Addongamemode
    if npc:IsRealHero() and npc.bFirstSpawned == nil then --unit only enters when spawned for first time
        npc.bFirstSpawned = true
        CTreeTagGameMode:OnHeroInGame(npc)
        
    end
   
    --===================================================================PRESTART FUNCTION AREA =================================================================
    --Run Function At The Start of the game
    if CTreeTagGameMode.RunAtStart == false then 
        CTreeTagGameMode.RunAtStart = true 

        CTreeTagGameMode:PreStart()
        --Put your function that wants to be run at bottom
        if CTreeTagGameMode.StartVictoryTimer == 0 then 
            CTreeTagGameMode.StartVictoryTimer = CTreeTagGameMode.StartVictoryTimer + 1
        
            StartVictoryTimer()

        end

       StartMessagePopup()
    end
    
     
end

function CTreeTagGameMode:OnEntityKilled(keys) --entered everytime an entity is killed
    DebugPrint("====================================================")
    DebugPrint("ENTITY KILLED = : ")
    --Killed entity
    local killed = EntIndexToHScript(keys.entindex_killed)
    local killedPlayerID = killed:GetPlayerOwnerID()
    local killedPlayerN = PlayerResource:GetPlayerName(killedPlayerID)
    --Killer entity
    local attacker = EntIndexToHScript(keys.entindex_attacker)
    local attackerPlayerID = attacker:GetPlayerOwnerID()
    local team = killed:GetTeamNumber()
    local attackPlayerN = PlayerResource:GetPlayerName(attackerPlayerID)
    local baseclass = killed:GetClassname()
    
    --CHECK IF ENTITITY KILLED IS HERO
   if killed:IsRealHero() then     
        if team == 2 then   
            local DeadHeroUnit = killed:GetUnitName()
            
            if DeadHeroUnit == "npc_dota_hero_earth_spirit" then

                --entering as killed dead ent
                DebugPrint("deadent -> treant loaded")

                CTreeTagGameMode.EntCount = CTreeTagGameMode.EntCount + 1
                CTreeTagGameMode.DeadEntCount = CTreeTagGameMode.DeadEntCount - 1
                CTreeTagGameMode.ExtraDeadEntCount = CTreeTagGameMode.ExtraDeadEntCount - 1
                local hero = pickHero(killedPlayerID, "npc_dota_hero_treant")
		Notifications:ClearBottomFromAll()
		Notifications:BottomToAll({text=killedPlayerN .. " has been saved ", duration=5, style={color="green"}, continue=true})
                
                --function to spawn unit in middle point
                xpos = -608
                ypos = -224
                local position = Vector(xpos, ypos, 136)
                FindClearSpaceForUnit(hero, position, true)
                
                
                
                hero:SetRespawnsDisabled(true)
                giveitems(hero)

            elseif DeadHeroUnit == "npc_dota_hero_treant" then
                DebugPrint("Treant -> deadent loaded")


                CTreeTagGameMode.EntCount = CTreeTagGameMode.EntCount - 1
                CTreeTagGameMode.DeadEntCount  = CTreeTagGameMode.DeadEntCount + 1
	        	Notifications:ClearTopFromAll()
	        	Notifications:TopToAll({text=attackPlayerN .. " has killed " .. killedPlayerN, duration=5, style={color="red"}, continue=true})
                --entering as killed ent
                
               
                
                

                --================================================================KILL ALL UNITS FUNCTION================
                local allEntities = Entities:FindAllByClassname("npc_dota_building")
                for _, unit in pairs(allEntities) do
                    if unit:GetPlayerOwnerID() == killedPlayerID then 
                        unit:ForceKill(false)
                        local bounty = unit:GetGoldBounty()
                        attacker:ModifyGold(bounty, false, 0)
                        attacker:AddExperience(60, 0, false, false)
                        UTIL_Remove(minimapEntity)
                    end
                end
                --===========================================SPAWN HERO ===========
                local hero = pickDeadEnt(killedPlayerID, "npc_dota_hero_earth_spirit")
                hero:SetGold(1, false)
                hero:SetRespawnsDisabled(true)
                xpos = -608
                ypos = -224
                local position = Vector(xpos, ypos, 136)
                FindClearSpaceForUnit(hero, position, true)

                checkinfernovictory()
                
                clearInventory(hero)

            else
                DebugPrint("[BUG] Good guy team hero other than ent and dead ent has been killed")
            end
        else
            DebugPrint("[UNIT]INFERNO DIED")

            CTreeTagGameMode.InfernoCount = CTreeTagGameMode.InfernoCount - 1
        end

        
    elseif baseclass == "npc_dota_creep" then 

        --KILL MINIMAP ENTITY FUNCTION 

        --kills minimap entity when building is killed
        DebugPrint("Dota Creature Killed: ")
        local minimapEntities = Entities:FindAllByClassname("npc_dota_building")
        killed.minimapEntity.correspondingEntity = "dead"
		for k, minimapEntity in pairs(minimapEntities) do
			if not minimapEntity:IsNull() and minimapEntity.correspondingEntity == "dead" and IsLocationVisible(DOTA_TEAM_BADGUYS, minimapEntity:GetAbsOrigin()) then
				minimapEntity.correspondingEntity = nil
				minimapEntity:ForceKill(false)
                UTIL_Remove(minimapEntity)
                DebugPrint("in pairs minimap entities")
			end
		end
        

        
    end
end

function CTreeTagGameMode:UnitLevelUp(keys)
	
	DebugPrint("------")
	local instance = PlayerInstanceFromIndex(keys.player)
	DebugPrint(tostring(instance))
	local hero = instance:GetAssignedHero()
	DebugPrint(tostring(hero))
	local heroname = hero:GetUnitName()
	DebugPrint(heroname)
	--update choptree skill for inferno at certain levels
	if heroname == "npc_dota_hero_doom_bringer" then
		if 	keys.level > 4 then
			hero:FindAbilityByName("inferno_tree_cutting"):SetLevel(4)
		elseif keys.level > 3 then
			hero:FindAbilityByName("inferno_tree_cutting"):SetLevel(3)
		else
			hero:FindAbilityByName("inferno_tree_cutting"):SetLevel(2)
		end				
	end
end

function checkinfernovictory()
    

    if CTreeTagGameMode.EntCount == 0 then
        GameRules:SetGameWinner(3)
    end
end

function StartVictoryTimer()
    --Starts victory timer for ent. Its 35 minutes for now
    --Total game time : 35 minutes + extra 5 seconds
    -- 35 mins plus extra mins =2105 sec
    Timers:CreateTimer(2105, function()
        GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
        DebugPrint("Dota Team GOod guy has won due to time running out")
        local currentGameTime = GameRules:GetDOTATime(false,false)
        DebugPrint(currentGameTime)
    end)

    --Give inferno special power at last 2.5 min. Placed here just because i lazy lol
    --1805 refer to min 32.5 when he get the power up ... 1955 for reference
    Timers:CreateTimer(1955, function()
        local allinferno = Entities:FindAllByClassname("npc_dota_hero_doom_bringer")
        DebugPrint("Inferno Special Power Activated")
        for _, infernos in pairs(allinferno) do
            DebugPrint("Accessed inferno endgame")
            infernos:AddAbility("inferno_endgame")
            ability = infernos:FindAbilityByName("inferno_endgame")
            ability:SetLevel(1)
           
            for i = 0,30,1 
            do 
                infernos:HeroLevelUp(false)
            end
            
        end
        
    end)
    
end

function StartMessagePopup()
    --not working
   -- + 5 PreGameTime btw
    --1st message

    DebugPrint("Accessed start message popup ")
    Timers:CreateTimer(5, function()
        Notifications:TopToTeam(DOTA_TEAM_BADGUYS, {text="Ent has spawned. Kill them before 35 minutes is up", duration=6.0})
        Notifications:TopToTeam(DOTA_TEAM_GOODGUYS, {text="Run and survive for 35 minutes", duration=5.0})
    end)
    Timers:CreateTimer(35, function()
        Notifications:TopToAll({text="Inferno has spawned ", duration=5.0})
    end)

    Timers:CreateTimer(305, function()
        Notifications:TopToAll({text="30 minutes remaining", duration=5.0})
    end)

    Timers:CreateTimer(605, function()
        Notifications:TopToAll({text="25 minutes remaining", duration=5.0})
    end)
    Timers:CreateTimer(905, function()
        Notifications:TopToAll({text="20 minutes remaining", duration=5.0})
    end)
    Timers:CreateTimer(1205, function()
        Notifications:TopToAll({text="15 minutes remaining", duration=5.0})
        Notifications:TopToTeam(DOTA_TEAM_BADGUYS, {text="Better hurry up there", duration=6.0})
    end)
    Timers:CreateTimer(1505, function()
        Notifications:TopToAll({text="10 minutes remaining", duration=5.0})
    end)
    Timers:CreateTimer(1805, function()
        Notifications:TopToAll({text="5 minutes remaining", duration=5.0})
        Notifications:TopToTeam(DOTA_TEAM_BADGUYS, {text="You have one last chance", duration=6.0})
    end)
end
