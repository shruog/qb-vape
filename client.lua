local QBCore = exports['qb-core']:GetCoreObject()

--- The debug object from the qb-vape resource.
---@class Debug
local Debug = exports['qb-vape']:Debug()

--- Creates the smoke particle effect on the given clientPed.
---@param clientPed The client ped to create the effect on.
local function createTheSmokeParticle(clientPed)
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

--- Event handler for the client effect smoke event.
-- Calls createTheSmokeParticle function with the given clientPed.
---@param clientPed The client ped to create the effect on.
RegisterNetEvent("sh-vape:client_effect_smoke", function(clientPed)
createTheSmokeParticle(clientPed)
end)

---Loads the given animation dictionary and waits until it is loaded.
---@param dict The name of the animation dictionary to load.
local function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

local VapeMod

--- Makes the player able to vape by attaching the vape object to their hand and playing the animation.
-- Deletes the current vape object if it exists.
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

--- Plays the animation 
function animBackPosition()
    local ped = PlayerPedId()
    local AnimDict = "anim@heists@humane_labs@finale@keycards"
    local anim = "ped_a_enter_loop"
    loadAnimDict(AnimDict)
    TaskPlayAnim(ped, AnimDict, anim, 8.00, -8.00, -1, 50, 0.00, 0, 0, 0)
    PlayerIsAbleToVape()
end

--- Plays the animation and particle effects for vaping.
-- Triggers the client_effect_smoke event on the server to create the smoke particle effect.
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

--- Stops using the vape by deleting the vape object and clearing the player's tasks.
function stopUsingVape()
    local ped = PlayerPedId()
    if VapeMod ~= nil and DoesEntityExist(VapeMod) then
    DeleteObject(VapeMod)
    VapeMod = nil
    end
    ClearPedTasks(ped)
    ClearPedSecondaryTask(ped)
end

--- Registers the stopvape keybind and command to stop using the vape.
RegisterKeyMapping('stopvape', 'Stop Using Vape', 'keyboard', 'U')
RegisterCommand('stopvape', function()
    stopUsingVape()
end, false)