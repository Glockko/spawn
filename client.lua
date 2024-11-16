RegisterCommand("spawn", function()
    TriggerEvent("spawn:openSpawnUI")
end, false) --Remember to change to true

--[[RegisterNetEvent("playerSpawned", function()
    TriggerEvent("spawn:openSpawnUI")
end)]]

local citycamPos = vector3(-2170.8274, -1761.0039, 762.4913)
local citycamRot = vector3(-25.09, 0.00, -60.01)
local cam = nil

function CreateMenu()
    local spawnMenu = UIMenu.New("Welcome to Los Santos!", "Select your spawn", 50, 50, true, "commonmenu", "interaction_bgd", true)
    spawnMenu:MouseControlsEnabled(true)
    spawnMenu:CanPlayerCloseMenu(false)
    spawnMenu:MouseEdgeEnabled(false)
    for k, spawnLocation in ipairs(SpawnLocations) do
        newItem = UIMenuItem.New(spawnLocation.label, spawnLocation.desc)
        spawnMenu:AddItem(newItem)
    end
    spawnMenu:Visible(true)

    spawnMenu.OnItemSelect = function(sender, item, index)
        TriggerEvent("spawnSelected", index)
        spawnMenu:Visible(false)
    end
end

RegisterNetEvent('spawn:openSpawnUI', function()
    DoScreenFadeOut(250)
    SetEntityVisible(PlayerPedId(), false, false)
    DisplayRadar(false)
    Wait(500)
    DoScreenFadeIn(250)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", citycamPos.x, citycamPos.y, citycamPos.z, citycamRot.x, citycamRot.y, citycamRot.z, GetGameplayCamFov(), false, 0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    CreateMenu()
end)

RegisterNetEvent("spawnSelected", function(index)
    --add a SetFocusPosAndVel() here to render world before spawning, or RequestCollisionAtCoord()
    local spawnCoords = SpawnLocations[index].coords
    SetEntityCoords(PlayerPedId(), spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, false) -- to do: move this to serverside

    DestroyCam(cam)
    RenderScriptCams(false, false, 1, true, true)
    SetEntityVisible(PlayerPedId(), true, false)
    DisplayRadar(true)
end)