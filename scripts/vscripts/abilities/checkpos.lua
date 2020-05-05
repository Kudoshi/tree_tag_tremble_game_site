function checkposimmediate(keys)
    DebugPrint("===========================================================")

    local caster = keys.caster
    local point = caster:GetAbsOrigin()
    groundclickpos = GetGroundPosition(point, nil)
    xpos = GridNav:WorldToGridPosX(groundclickpos.x)
    ypos = GridNav:WorldToGridPosY(groundclickpos.y)
    groundclickpos.x = GridNav:GridPosToWorldCenterX(xpos)
    groundclickpos.y = GridNav:GridPosToWorldCenterY(ypos)

    DebugPrint(groundclickpos.x .." " .. groundclickpos.y)

    
end