function Cancel(keys)
	--clear inventory
	local caster = keys.caster
	ClrInv(caster)
	addDefault(caster)
	
end

function ClrInv(caster)
	for i=0,8 do
        local item = caster:GetItemInSlot(i)
        if item then
            item:RemoveSelf()
        end
    end
end

function addDefault(caster)
	local itemNames = {
		
		"item_ent_cancel",
		"item_basic_buildings",
		"item_summoning_buildings",
        "item_destroy_building"
       
    }
    for _, itemName in pairs(itemNames) do
		--if statement to prevent two ent_cancel items
		
			local item = CreateItem(itemName, caster, caster)
		if caster:HasItemInInventory("item_ent_cancel") == false or itemName ~= "item_ent_cancel" then
			caster:AddItem(item)
		end
    end

    if CTreeTagGameMode.DeveloperMode == true then 
        caster:AddItemByName("item_checkpos")
    end
end

--buildings in category 1
function addCategory1(keys)
	local caster = keys.caster
	local itemNames = {
        'item_place_mine',
        'item_place_wall',
        "item_place_sentrytower",
		"item_place_invisiblewall"
    }
	ClrInv(caster)
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, caster, caster)
        
        caster:AddItem(item)
    end

    if CTreeTagGameMode.DeveloperMode == true then 
        caster:AddItemByName("item_checkpos")
    end
end

--buildings in category 2
function addCategory2(keys)
	local caster = keys.caster
	local itemNames = {
        "item_place_littlesaver",
        "item_place_birdoflife",
        "item_place_barracks"
    }
	ClrInv(caster)
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, caster, caster)
        
        caster:AddItem(item)
    end

    if CTreeTagGameMode.DeveloperMode == true then 
        caster:AddItemByName("item_checkpos")
    end
end