local progress = nil

local function interruptProgress()
    return IsControlJustPressed(1, 38)
end

local function startProgress(data)
    progress = data
    local anim = data.anim
    local startTime = GetGameTimer()

    if anim then
        if anim.dict then
            RequestAnimDict(anim.dict)
            while not HasAnimDictLoaded(anim.dict) do
                Wait(100)
            end

            TaskPlayAnim(PlayerPedId(), anim.dict, anim.clip, anim.blendIn or 3.0, anim.blendOut or 1.0, anim.duration or -1, anim.flag or 49, anim.playbackRate or 0, false, false, false)
        elseif anim.scenario then
            TaskStartScenarioInPlace(PlayerPedId(), anim.scenario, 0, anim.playEnter ~= nil and anim.playEnter or true)
        end
    end

    local disable = data.disable
    local duration = data.duration or 5000

    local elapsedTime = 0
    while progress do
        if disable.mouse then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
        end

        if disable.move then
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
        end

        if disable.combat then
            DisableControlAction(0, 24, true)
            DisablePlayerFiring(PlayerId(), true)
        end

        if interruptProgress() then
            progress = false
        end

        elapsedTime = elapsedTime + GetFrameTime() * 1000
        if elapsedTime >= duration then
            break
        end

        Wait(0)
    end

    if anim then
        if anim.dict then
            StopAnimTask(PlayerPedId(), anim.dict, anim.clip, 1.0)
            Wait(0)
        else
            ClearPedTasks(PlayerPedId())
        end
    end

    if progress == false then
        SendNUIMessage({ action = 'progressCancel' })
        progress = nil
        return false
    end

    progress = nil
    return true
end

exports('progressBar', function(data)
    if progress ~= nil then
        return false
    end

    SendNUIMessage({
        action = 'progress',
        data = {
            label = data.label,
            duration = data.duration
        }
    })

    return startProgress(data)
end)
