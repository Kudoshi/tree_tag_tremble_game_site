require("CosmeticLib")
require("hero_util")

-- give treant starting items
function giveitems(hero)
    clearInventory(hero)
    addRadiantItems(hero)
end

function giveitemsdire(hero)
    clearInventory(hero)
    addDireItems(hero)
end

function picktree(keys)
    local hero = pickHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_treant")
    hero:RemoveAbility("picktree")
 
	hero:SetRespawnsDisabled(true)
    giveitems(hero)
end

function pickinferno(keys)
    local hero = pickBadHero(keys.caster:GetPlayerOwnerID(), "npc_dota_hero_doom_bringer")
    hero:RemoveAbility("pickinferno")
    giveitemsdire(hero)
end

--Ent's item
function addRadiantItems(hero)
    local itemNames = {
        'item_ent_cancel',
        'item_basic_buildings',
        "item_summoning_buildings",
	"item_destroy_building"
       
    }
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, hero, hero)
        
        hero:AddItem(item)
    end

    if CTreeTagGameMode.DeveloperMode == true then 
        hero:AddItemByName("item_checkpos")
    end
end

--Inferno's item
function addDireItems(hero)
    local itemNames = {
        'item_ward_observe'
    }
    for _, itemName in pairs(itemNames) do
        local item = CreateItem(itemName, hero, hero)
        
        hero:AddItem(item)
    end
end
