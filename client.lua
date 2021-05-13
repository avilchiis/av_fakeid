local w = 500

Citizen.CreateThread(function()
	while true do
		w = 500
		if #(GetEntityCoords(PlayerPedId()) - vector3(1275.64, -1710.44, 54.77)) < 2 then
			w = 5
			DrawText3D(1275.64, -1710.44, 54.77, 'Press ~r~[E]~w~ to generate fake ID')
			if IsControlJustPressed(0,38) then
				TriggerEvent('av:fakeid')
			end
		end
		Citizen.Wait(w)
	end
end)

RegisterNetEvent('av:fakeid')
AddEventHandler('av:fakeid', function()
	local name
	local lastname
	local dob

	name = KeyboardInput('Name', '', 15)

	if name ~= nil then 
		lastname = KeyboardInput('Lastname', '', 15)
	end

	if lastname ~= nil then 
		dob = KeyboardInput('DOB (01/01/1990)', '', 10)
	end
		
	if dob ~= nil then 
		TriggerServerEvent('av:generate', name, lastname, dob)
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

RegisterCommand('fakeid', function()
	TriggerServerEvent('av:showid')
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent("chat:proximity")
AddEventHandler("chat:proximity", function(serverId,chatMessage)
    local source = PlayerId()
    local target = GetPlayerFromServerId(serverId)
    local sourcePed, targetPed = PlayerPedId(), GetPlayerPed(target)
    local sourceCoords, targetCoords = GetEntityCoords(sourcePed), GetEntityCoords(targetPed)
    local distance = GetDistanceBetweenCoords(sourceCoords, targetCoords, true)
    if target == source then
        TriggerEvent("chat:addMessage", chatMessage)
     elseif distance < 10 and distance ~= 0 and distance > 0.1 then
     	TriggerEvent("chat:addMessage", chatMessage)
    end
end)