-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

-- Creating a global gamemode class variable;
if CTreeTagGameMode == nil then
	_G.CTreeTagGameMode  = class({})
else
	DebugPrint("[BAREBONES] barebones class name is already in use, change the name if this is the first time you launch the game!")
	DebugPrint("[BAREBONES] If this is not your first time, you probably used script_reload in console.")
end


require('libraries/timers')                      -- Core lua library


--3tag's own require
require("_precache")
require('internal/util')
require("hero_util")
require('libraries/notifications')

require("pick_abilities_radiant")

require("events")
require("settings")
require("_util")

function Precache(context)
	preCacheResources(context)
end

-- Create the game mode when we activate
function Activate()
	DebugPrint("[TREETAG] Activating ...")
	print("Your custom game is activating.")
	CTreeTagGameMode:InitGameMode()
end

-- Set this to true if you want to see a complete debug output of all events/processes done by trollnelves2
-- You can also change the cvar 'trollnelves2_spew' at any time to 1 or 0 for output/no output


function CTreeTagGameMode:InitGameMode()
	DebugPrint( "[TREETAG] Initgamemode:Tree Tag is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )

    --if GetMapName() == "mines_trio" then
	-- different team sizes for different maps okok todo:
	
	--set teamnumbers
    GameRules:SetCustomGameTeamMaxPlayers(2, 8)
	GameRules:SetCustomGameTeamMaxPlayers(3, 3)
	
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)

	--force hero i think
   

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroRespawnEnabled(true)
	GameRules:SetUseUniversalShopMode(false)
    GameRules:SetHeroSelectionTime(0) -- hero selection is not skipped unless this is set to 0 it seems
	GameRules:SetPreGameTime(2105)
	GameRules:SetPostGameTime(30.0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetTreeRegrowTime(99999)
    GameRules:SetRuneSpawnTime(0)
    GameRules:SetFirstBloodActive(false)
	GameRules:SetUseBaseGoldBountyOnHeroes(true)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CTreeTagGameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CTreeTagGameMode, 'OnEntityKilled'), self)
	
	CTreeTagGameMode.EntCount = 0
	CTreeTagGameMode.DeadEntCount = 0
	CTreeTagGameMode.ExtraDeadEntCount = 0
	CTreeTagGameMode.InfernoCount = 0
	CTreeTagGameMode.StartVictoryTimer = 0 --dont touch this
	CTreeTagGameMode.RunAtStart = false -- Run functions at the start of the game
	CTreeTagGameMode.EnterMessageFunction = true --Fires message

	CTreeTagGameMode.DeveloperMode = false --set to false when releasing including the debugspew

	local spew = 0
  if TREETAG_DEBUG_SPEW then
		spew = 1
  end
  Convars:RegisterConvar('TREETAG_spew', tostring(spew), 'Set to 1 to start spewing treetag debug info.  Set to 0 to disable.', 0)

    --GameMode:SetCameraDistanceOverride(1404.0)
end

function CTreeTagGameMode:PreStart()
	--CreateMinimapBuildings() broken
	StartCreatingMinimapBuildings()
end

function CreateMinimapBuildings()
	DebugPrint("Creating MiniMap Buildings for example")
	Timers:CreateTimer(0.3,function()
		if GameRules:State_Get() > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			return
		end	
		local allEntities = Entities:FindAllByClassname("npc_dota_creep")
		for _, unit in pairs(allEntities) do
			if not unit:IsNull() and not unit.minimapEntity and unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS and IsLocationVisible(DOTA_TEAM_BADGUYS, unit:GetAbsOrigin()) then
				
				local position = unit:GetAbsOrigin()
				
				local playerID = unit:GetPlayerOwnerID()
				
				building = CreateUnitByName("minimap_entity", position, false, unit:GetOwner(), unit:GetOwner(), unit:GetTeamNumber())
				building:SetOwner(unit:GetOwner())
				building:AddNewModifier(building, nil, "modifier_minimap", {})
			end
		end
				
		return 0.3
	end)
end
function StartCreatingMinimapBuildings()
	DebugPrint("Creating minimap building")
	Timers:CreateTimer(0.3,function()
		if GameRules:State_Get() > DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			return
		end	
		-- Create minimap entities for buildings that are visible and don't already have a minimap entity
		local allEntities = Entities:FindAllByClassname("npc_dota_creep")
		for _, unit in pairs(allEntities) do
			
			if not unit:IsNull() and not unit.minimapEntity and  unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS and IsLocationVisible(DOTA_TEAM_BADGUYS, unit:GetAbsOrigin()) then
				DebugPrint("Create minimap entity")
				unit.minimapEntity = CreateUnitByName("minimap_entity", unit:GetAbsOrigin(), false, unit:GetOwner(), unit:GetOwner(), unit:GetTeamNumber())
				--unit.minimapEntity:AddNewModifier(unit.minimapEntity, nil, "modifier_minimap", {})
				--unit.minimapEntity.correspondingEntity = unit
				unit.minimapEntity:SetOwner(unit:GetOwner())
			end
		end
		-- Kill minimap entities of dead buildings when location is scouted
		local minimapEntities = Entities:FindAllByClassname("npc_dota_building")
		for k, minimapEntity in pairs(minimapEntities) do
			if not minimapEntity:IsNull() and minimapEntity.correspondingEntity == "dead" and IsLocationVisible(DOTA_TEAM_BADGUYS, minimapEntity:GetAbsOrigin()) then
				minimapEntity.correspondingEntity = nil
				minimapEntity:ForceKill(false)
				UTIL_Remove(minimapEntity)
			end
		end
		return 0.3
	end)
end

function CTreeTagGameMode:OnThink()
	--This whole thing not working at all
	
	local currentGameTime = GameRules:GetDOTATime(false,false);

	

	
	
	


	

 
end

-- Initialize a hero when it spawns for the first time
function CTreeTagGameMode:OnHeroInGame(hero)
	DebugPrint("=======================================================[OnHeroInGame] accessed")
	
	local currentGameTime = GameRules:GetDOTATime(false,false)

	
	
	local heroname = hero:GetUnitName()

	if heroname == "npc_dota_hero_wisp" then 
		
		local wispid  = hero:GetPlayerOwnerID()
		--entered here as a wisp for first time
		DebugPrint("[TREETAG]Wisp hero loaded")
		
		local team = hero:GetTeam()

		if team == DOTA_TEAM_GOODGUYS then
			CTreeTagGameMode.EntCount = CTreeTagGameMode.EntCount + 1
			hero:AddAbility("picktree")
			ability = hero:FindAbilityByName("picktree")
			ability:SetLevel(1)
			ability:StartCooldown(5)
			ability:SetHidden(false)
			ability:SetActivated(true)
			
			Timers:CreateTimer(5, function()
				if heroname == "npc_dota_hero_wisp" then
				
					local hero = pickHero(wispid, "npc_dota_hero_treant")
				
					hero:SetRespawnsDisabled(true)
					hero:RemoveAbility("picktree")
					giveitems(hero)
					
				end
			end)
			
			
		else
			CTreeTagGameMode.InfernoCount = CTreeTagGameMode.InfernoCount + 1
			hero:AddAbility("pickinferno")
			ability = hero:FindAbilityByName("pickinferno")
			ability:SetLevel(1)
			ability:StartCooldown(35)
			ability:SetHidden(false)
			ability:SetActivated(true)
			

			Timers:CreateTimer(35, function()
				if heroname == "npc_dota_hero_wisp" then
						
					local hero = pickBadHero(wispid, "npc_dota_hero_doom_bringer")
					
					hero:SetRespawnsDisabled(false)
					hero:RemoveAbility("pickinferno")
					giveitemsdire(hero)
				end
			end)
			
		end
		
			
		
	else
		DebugPrint("[TREETAG] A hero has spawned")
	end
end






