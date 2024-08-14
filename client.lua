CreateThread(function()
    while (true) do
        local _ped = PlayerPedId()
        local _coords = GetEntityCoords(_ped)
        local closestVehicle = GetClosestVehicle(_coords.x, _coords.y, _coords.z, 10.0, 0, 70)

        if (closestVehicle ~= 0) then
            local vehPos = GetEntityCoords(closestVehicle)
            local speed = GetEntitySpeed(closestVehicle)

            if #(playerPos - vehPos) < 3.0 and speed > 10.0 then
                SetEntityNoCollisionEntity(_ped, closestVehicle, true)
                SetEntityNoCollisionEntity(closestVehicle, _ped, true)

                Wait((2) * 1000)

                SetEntityNoCollisionEntity(_ped, closestVehicle, false)
                SetEntityNoCollisionEntity(closestVehicle, _ped, false)
            end
        end

        Wait(0)
    end
end)

function CarKill(tipo)
	local Weapons = {'WEAPON_RUN_OVER_BY_CAR', 'WEAPON_RAMMED_BY_CAR'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == tipo then
			return true
		end
	end
	return false
end

function RevivePlayer()
    if not (IsEntityDead(PlayerPedId())) then return; end;
    TriggerEvent('esx_ambulancejob:revive')
end

CreateThread(function()
    local _sleep = false
	  while (true) do
        local playerPed = PlayerPedId()
        _sleep = not (IsEntityDead(playerPed))
		    Wait(_sleep and 750 or 0)
		    if IsEntityDead(playerPed) then
            local _deathCause = GetPedCauseOfDeath(playerPed)
            if CarKill(_deathCause) then
                Wait(1000)
                RevivePlayer()
            end
		    end
		    while IsEntityDead(playerPed) do
			    Wait(1000)
		    end
	  end
end)
