local QBCore = exports['qb-core']:GetCoreObject()
local Debug = exports['qb-vape']:Debug()


function createTheSmokeParticle(clientPed)
    local ped = NetToPed(clientPed)
    
    if DoesEntityExist(ped) and not IsEntityDead(ped) then
        
        local smokeParts = {}
    
        smokeParts.createdSmoke = UseParticleFxAssetNextCall(Config.smoke.particle_asset)
        smokeParts.part = StartParticleFxLoopedOnEntityBone(Config.smoke.particle, ped, 0.0, 0.0, -0.04, 0.0, 0.0, 0.0, GetPedBoneIndex(ped, Config.smoke.bone), Config.smoke.size, 0.0, 0.0, 0.0)
        
        Wait(Config.VapeHangTime)
        
        for _, part in pairs(smokeParts) do
            while DoesParticleFxLoopedExist(part) do
                StopParticleFxLooped(part, 1)
                Wait(0)
            end
        end
        
        Wait(Config.VapeHangTime * 3)
        
        RemoveParticleFxFromEntity(NetToPed(clientPed))
    end
end



local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local VapeMod

function PlayerIsAbleToVape()
    local ped = PlayerPedId()
    local AnimDict = "anim@heists@humane_labs@finale@keycards"
    local anim = "ped_a_enter_loop"
    local SKEL_L_Hand = 18905
    
    if VapeMod ~= nil and DoesEntityExist(VapeMod) then
        DeleteObject(VapeMod)
        VapeMod = nil
    end

    loadAnimDict(AnimDict)
    TaskPlayAnim(ped, AnimDict, anim, 8.00, -8.00, -1, 50, 0.00, 0, 0, 0)
    
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local prop_name = "ba_prop_battle_vape_01"
    VapeMod = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(VapeMod, ped, GetPedBoneIndex(ped, SKEL_L_Hand), 0.08, -0.00, 0.03, -150.0, 90.0, -10.0, true, true, false, true, 1, true)
end

function animBackPosition()
    local ped = PlayerPedId()
    local AnimDict = "anim@heists@humane_labs@finale@keycards"
    local anim = "ped_a_enter_loop"
    loadAnimDict(AnimDict)
    TaskPlayAnim(ped, AnimDict, anim, 8.00, -8.00, -1, 50, 0.00, 0, 0, 0)
    PlayerIsAbleToVape()
end


function useVape()
    local ped = PlayerPedId()
    local AnimDict = "mp_player_inteat@burger"
    local anim = "mp_player_int_eat_burger"
    loadAnimDict(AnimDict)
    TaskPlayAnim(ped, AnimDict, anim, 8.0, 1.0, -1, 50, 0, false, false, false)
    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
    Wait(1000)
    TriggerServerEvent("sh-vape:server_effect_smoke", PedToNet(ped))
    animBackPosition()
end

function stopUsingVape()
    local ped = PlayerPedId()
    print(VapeMod)
    if VapeMod ~= nil and DoesEntityExist(VapeMod) then
        DeleteObject(VapeMod)
        VapeMod = nil
    end
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
end

-- events
RegisterNetEvent("qb-vape:client_effect_smoke", function(clientPed)
    createTheSmokeParticle(clientPed)
end)

RegisterNetEvent("qb-vape:startUseVape", function()
    useVape()
end)

-- -- keybords map
-- RegisterKeyMapping('usevape', 'Use Vape', 'keyboard', 'Y')
RegisterKeyMapping('stopvape', 'Stop Using Vape', 'keyboard', 'U')

-- -- commands to use and stop
RegisterCommand('usevape', function()
    useVape()
end, false)


RegisterCommand('stopvape', function()
    print("chamando comando")
    stopUsingVape()
end, false)