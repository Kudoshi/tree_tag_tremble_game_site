-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

-- Creating a global gamemode class variable;
if CTreeTagGameMode == nil then
	_G.CTreeTagGameMode  = class({})
else
	DebugPrint("[BAREBONES] barebones class name is already in use, change the name if this is the first time you launch the game!")
	DebugPrint("[BAREBONES] If this is not your first time, you probably used script_reload in console.")
end

--Required Files
require('libraries/timers')                   
require("_precache")
require('internal/util')
require("hero_util")
require('libraries/notifications')
require("pick_abilities_radiant")
require("events")
require("settings")
require("_util")

--Precache models,particles and sounds. Put your precache in the _precache.lua file
function Precache(context)
	preCacheResources(context)
end

-- Create the game mode when we activate
function Activate()
	DebugPrint("[TREETAG] Activating ...")
	print("Your custom game is activating.")
	CTreeTagGameMode:InitGameMode()
end

-- DEBUG SPEW is in the settings.lua for debugging purposes. Set to false when releasing to public


function CTreeTagGameMode:InitGameMode()
	DebugPrint( "[TREETAG] Initgamemode:Tree Tag is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 1 )

    --if GetMapName() == "mines_trio" then
	-- different team sizes for different maps
	
	--set teamnumbers
    GameRules:SetCustomGameTeamMaxPlayers(2, 8) -- Team 2 : 8 players (Ents)
	GameRules:SetCustomGameTeamMaxPlayers(3, 3)	-- Team 3 : 3 players (Inferno)
	
	GameRules:GetGameModeEntity():SetCustomGameForceHero("npc_dota_hero_wisp")	--force all to spawn as wisp
    GameRules:GetGameModeEntity():SetCustomHeroMaxLevel(1)
    GameRules:GetGameModeEntity():SetBuybackEnabled(false)

	--force hero i think
   

	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroRespawnEnabled(true)
	GameRules:SetUseUniversalShopMode(false)

	--time settings
    GameRules:SetHeroSelectionTime(0)
	GameRules:SetPreGameTime(2105)
	GameRules:SetPostGameTime(30.0)
	GameRules:SetShowcaseTime(0)
	GameRules:SetTreeRegrowTime(99999)
    GameRules:SetRuneSpawnTime(0)
    GameRules:SetFirstBloodActive(false)
	GameRules:SetUseBaseGoldBountyOnHeroes(true)

	--ListenToGameEvent Section

	ListenToGameEvent('npc_spawned', Dynamic_Wrap(CTreeTagGameMode, 'OnNPCSpawned'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CTreeTagGameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(CTreeTagGameMode, 'UnitLevelUp'), self)
	
	--Global Variables

	CTreeTagGameMode.EntCount = 0 --Keeps count of ent alive
	CTreeTagGameMode.DeadEntCount = 0	--Keeps count of dead ent alive
	CTreeTagGameMode.ExtraDeadEntCount = 0 --Keeps count of earth spirit respawning due to bug
	CTreeTagGameMode.InfernoCount = 0	--Keeps count of inferno alive
	CTreeTagGameMode.StartVictoryTimer = 0 --Start victory timer stuff. Always set to 0
	CTreeTagGameMode.RunAtStart = false -- Run functions at the start of the game
	CTreeTagGameMode.EnterMessageFunction = true --Fires message but currently not in use coz broken

	CTreeTagGameMode.DeveloperMode = false --not used for now

	--debug spew

	local spew = 0
  if TREETAG_DEBUG_SPEW then
		spew = 1
  end
  Convars:RegisterConvar('TREETAG_spew', tostring(spew), 'Set to 1 to start spewing treetag debug info.  Set to 0 to disable.', 0)

    --GameMode:SetCameraDistanceOverride(1404.0)
end

function CTreeTagGameMode:PreStart()
	--PreStart stuff
	--CreateMinimapBuildings() broken
	StartCreatingMinimapBuildings()
end

function StartCreatingMinimapBuildings()

	--Create Minimap Entity on Buildings when inferno sees the buildings

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


function CTreeTagGameMode:OnHeroInGame(hero)
	-- Initialize a hero when it spawns for the first time. 
	

	DebugPrint("=======================================================[OnHeroInGame] accessed")
	
	local currentGameTime = GameRules:GetDOTATime(false,false)
	local heroname = hero:GetUnitName()


	--starting game function to assign heroes to ent and inferno

	if heroname == "npc_dota_hero_wisp" then 
		
		local wispid  = hero:GetPlayerOwnerID()
		--entered here as a wisp for first time
		DebugPrint("[TREETAG]Wisp hero loaded")
		
		local team = hero:GetTeam()

		if team == DOTA_TEAM_GOODGUYS then
			--ENT--

			CTreeTagGameMode.EntCount = CTreeTagGameMode.EntCount + 1  --Add one count to ent alive

			--initializing ent 

			hero:AddAbility("picktree")
			ability = hero:FindAbilityByName("picktree")
			ability:SetLevel(1)
			ability:StartCooldown(5)
			ability:SetHidden(false)
			ability:SetActivated(true)
			
			--auto picks hero
			Timers:CreateTimer(5, function()
				if heroname == "npc_dota_hero_wisp" then
				
					local hero = pickHero(wispid, "npc_dota_hero_treant")
				
					hero:SetRespawnsDisabled(true)
					hero:RemoveAbility("picktree")
					giveitems(hero)
					
				end
			end)
			
			
		else

			--INFERNO--

			CTreeTagGameMode.InfernoCount = CTreeTagGameMode.InfernoCount + 1	--Add one count to inferno alive

			--initializing inferno

			hero:AddAbility("pickinferno")
			ability = hero:FindAbilityByName("pickinferno")
			ability:SetLevel(1)
			ability:StartCooldown(35)
			ability:SetHidden(false)
			ability:SetActivated(true)
			
			--autopick inferno. Could be removed and used for picking different inferno heroes
			Timers:CreateTimer(35, function()
				if heroname == "npc_dota_hero_wisp" then
					
					local point = hero:GetAbsOrigin()
					GridNav:DestroyTreesAroundPoint(point, 500, false)
					local hero = pickBadHero(wispid, "npc_dota_hero_doom_bringer")
					
					hero:SetRespawnsDisabled(false)
					hero:RemoveAbility("pickinferno")
					giveitemsdire(hero)
				end
			end)
			
		end
		
			
		
	else

		--could be used for initializing different units
		DebugPrint("[TREETAG] A hero has spawned")
	end
end






