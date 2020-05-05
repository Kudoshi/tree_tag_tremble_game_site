--[[ Tree tracking ]]

destroyed_trees = {}

function AddDestroyedTree(tree)
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
    
    
    
	local trees = GridNav:GetAllTreesAroundPoint(target_point, radius, false)
	for i, tree in ipairs(trees) do
		tree:CutDown(caster_team)
		AddDestroyedTree(tree)
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
	local target_point = event.target_points[1]
    local radius = event.Radius
    
    print("regrow tree function accessed")
	
    local trees = GetDestroyedTreesAroundPoint(target_point, radius)
    
    print("function after local trees worked and accessed")
	for i, tree in ipairs(trees) do
		tree:GrowBack()
        RemoveDestroyedTree(tree)
        print("regrow tree in the for function nice function accessed")
	end
end
