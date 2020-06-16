--[[ Tree tracking ]]

destroyed_trees = {}

function AddDestroyedTree(tree)
	print("Adde destroyed tree hit in")
	local origin = tree:GetOrigin()
	destroyed_trees[origin] = tree
end

function RemoveDestroyedTree(tree)
	local origin = tree:GetOrigin()
	destroyed_trees[origin] = nil
end

function GetDestroyedTreesAroundPoint(point, radius)
	trees = {}
	for origin, tree in pairs(destroyed_trees) do
		dist = (point - origin):Length2D()
		if dist <= radius then
			table.insert(trees, tree)
		end
	end
	return trees
end

-- [[ Spell functions ]]

function DestroyTree(event)
	local caster = event.caster
	local caster_team = caster:GetTeam()
    local target = event.target
    
	target:CutDown(caster_team)
    AddDestroyedTree(target)
	
end

function DestroyTreeAoE(event)
	local caster = event.caster
	local caster_team = caster:GetTeam()
	local target_point = event.target_points[1]
	local radius = event.Radius


	-- Emit particle + sound
	local blast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(blast_pfx, 0, target_point)
	ParticleManager:SetParticleControl(blast_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(blast_pfx)
	EmitSoundOnLocationWithCaster(target_point, "Ability.LightStrikeArray", caster)

    
	local trees = GridNav:GetAllTreesAroundPoint(target_point, radius, false)
	for i, tree in ipairs(trees) do
		tree:CutDown(caster_team)
		AddDestroyedTree(tree)
	end
end

function forceofnature(event)
	local caster = event.caster 
	local radius = event.Radius
	local target_point = event.target_points[1]
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
        creep:SetOwner(hero)
        creep:SetControllableByPlayer(playerID,true)
        local position = creep:GetAbsOrigin()
     FindClearSpaceForUnit(creep, position, true)
        creepcount = creepcount + 1
    end
end
function UltDestroyTree(event)
	DebugPrint("[DEBUGGING]UltDestroytree function accessed")
	local caster = event.caster
	local caster_team = caster:GetTeam()
	local target_point = caster:GetAbsOrigin()
	local radius = event.Radius
    
    
    
	local trees = GridNav:GetAllTreesAroundPoint(target_point, radius, false)
	for i, tree in ipairs(trees) do
		tree:CutDown(caster_team)
		AddDestroyedTree(tree)
	end

	
end

function doom_scorch(event)
	local caster = event.caster
	local caster_team = caster:GetTeam()
	local target_point = event.target_caster[1]
	local radius = event.Radius
    
    print("after the local vary")
    
    local trees = GridNav:GetAllTreesAroundPoint(target_point, radius, false)
    print("It passed thru gridnav getalltrees ")
	for i, tree in ipairs(trees) do
		tree:CutDown(caster_team)
        AddDestroyedTree(tree)
        print("It entered for function for ultimate")
	end
end

function RegrowTreeAoE(event)
	local caster = event.caster
	local target_point = event.target_points[1]
    local radius = event.Radius
    
    print("regrow tree function accessed")
	
    local trees = GetDestroyedTreesAroundPoint(target_point, radius)
    
	print("function after local trees worked and accessed")

	local regrow_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast_growing_wood.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(regrow_pfx, 0, target_point)
	ParticleManager:SetParticleControl(regrow_pfx, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(regrow_pfx)
	EmitSoundOnLocationWithCaster(target_point, "Hero_Treant.Overgrowth.Cast", caster)

	for i, tree in ipairs(trees) do
		tree:GrowBack()
        RemoveDestroyedTree(tree)
        print("regrow tree in the for function nice function accessed")
	end
end

function EatTree(event)
	local caster = event.caster
	local caster_team = caster:GetTeam()
    local target = event.target
    
	target:CutDown(caster_team)
	AddDestroyedTree(target)
	
	local base_regen = caster:GetBaseHealthRegen()
	--Hard coding The values done. Screw it
	--local temp_regen = ability:GetLevelSpecialValueFor("tempregen", (ability:GetLevel() - 1))
	--local regen_duration = ability:GetLevelSpecialValueFor("duration", (ability:GetLevel() - 1))

	local temp_regen = 14
	local regen_duration = 30



	DebugPrint("Eat Tree not Lua")
	caster:SetBaseHealthRegen(temp_regen)

	EmitSoundOn("Hero_Tiny.Tree.Grab" , target)

	--self.particle = ParticleManager:CreateParticle("particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor_beam_c.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	--ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
	--self:AddParticle(self.particle, false, false, -1, false, true)

	Timers:CreateTimer(regen_duration, function()
		caster:SetBaseHealthRegen(base_regen)
		
		
	end)
	
end

function EatTreeLua(event)
	local caster = event.caster
	local caster_team = caster:GetTeam()
    local target = event.target
	DebugPrint("This is a lua stuff")
	target:CutDown(caster_team)
	AddDestroyedTree(target)
	EmitSoundOn("Hero_Tiny.Tree.Grab" , target)

	LinkLuaModifier("modifier_eat_tree_regen", "modifiers/modifier_eat_tree_regen.lua", LUA_MODIFIER_MOTION_NONE)
	caster:AddNewModifier(caster, event.ability, "modifier_eat_tree_regen", { duration = 30 } )
end
