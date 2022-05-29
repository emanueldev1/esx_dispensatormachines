local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

ESX = nil;
local inRange = false;
local closestmach, machPos;

format = string.format;

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent("esx:getSharedObject", function(obj)
			ESX = obj;
		end);
		Citizen.Wait(0);
	end;
end);


local function DrawText3D(position, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(position.x, position.y,
                                               position.z)
    local dist = #(GetGameplayCamCoords() - position)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0 * scale, 0.40 * scale)
        else
            SetTextScale(0.0 * scale, customScale)
        end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- function NearMachine3Dtext(a)
--     local ped = GetPlayerPed(-1)
--     local pos = GetEntityCoords(ped)

    
--         local machine = GetClosestObjectOfType(pos.x, pos.y, pos.z, 9.5, Config.allSpendormodels[a].model, false, false, false)
--         if DoesEntityExist(machine) then
--             if machine ~= closestmach then
--                 closestmach = machine
--                 machPos = GetEntityCoords(machine)
--             end
--             local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, machPos.x,machPos.y, machPos.z, true)

--             if dist <= 9.0 then
--                 return {machpos = machPos, name = Config.allSpendormodels[a].machmenuname}
--             elseif dist <= 9.5 then
--                 return "uptdate"
--             end

--         end
-- end

function NearMachine()
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped)
    for i = 1, #Config.allSpendormodels do
        local machine = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.5,
        Config.allSpendormodels[i].model, false, false,
            false)
        if DoesEntityExist(machine) then
            if machine ~= closestmach then
                closestmach = machine
                machPos = GetEntityCoords(machine)
            end
            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, machPos.x,machPos.y, machPos.z, true)

            if dist <= 1.4 then
                -- print({products = Config.allSpendormodels[i].products, machname = Config.allSpendormodels[i].machmenuname, near = true, machpos = machPos })
                return {products = Config.allSpendormodels[i].products, machname = Config.allSpendormodels[i].machmenuname, near = true, machpos = machPos }
            elseif dist <= 1.5 then
                return "uptdate"
            end

        end

    end
end


function openmenu(items, machname)

    if items == nil then
        exports['okokNotify']:Alert("ERROR", "Disculpa las molestias esta maquina esta fuera de servicio", 1500, 'error')

        return
    end
    ESX.UI.Menu.CloseAll()

    local elements = {}

    for i=1, #items do
        local items = items[i]
        table.insert(elements, {
            realLabel = items["label"],
            label = items["label"] .. ' (<span style="color:green">$' .. items["price"] .. '</span>)',
            item = items["item"],
            price = items["price"],
            value = 1, type = 'slider', min = 1, max = 15,
        })
    end

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buy_machine', {
        title = machname,
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        local payAmount =  data.current["price"] * data.current.value

		if not inRange then

            ESX.TriggerServerCallback('esx_spendormachines:CheckMoney', function(hasMoney)
                if hasMoney then
    
                    TriggerServerEvent('esx_spendormachines:Cashier', payAmount, data.current['item'], data.current['value'])
                    payAmount = 0
                    menu.close()
                else
                    -- pNotify("No tienes suficiente dinero!", 'error', 1500)
                    exports['okokNotify']:Alert("ERROR", "No tienes suficiente dinero!", 1500, 'error')
    
                end
            end, payAmount)
    
            menu.close()
        else
            
            menu.close()
            exports['okokNotify']:Alert("ERROR", "¡Estas demaciado lejos de la maquina!", 1500, 'error')
			
		end;
       

    end, function(data, menu) menu.close() end)
end

-- print(NearMachine())
-- Citizen.CreateThread(function()
--     while true do
--         for i = 1, 7 do
--             if NearMachine3Dtext(i) ~= "update" and NearMachine3Dtext(i) ~= nil   then

--                     if NearMachine3Dtext(i).machpos ~= nil then
--                         DrawText3D(NearMachine3Dtext(i).machpos, NearMachine3Dtext(i).name, 255, 255, 255)
--                     end

--             end;
--         end
--     end

--     Citizen.Wait(0)
-- end)

Citizen.CreateThread(function()
	
	local dict = "anim@amb@prop_human_atm@interior@male@enter";
	local anim = "enter";
	local ped = GetPlayerPed(-1);

    local shown = false;

	while true do

		inRange = false;
		Citizen.Wait(0);

        local a = NearMachine()

        -- print(a)
		if a ~= "update" and a ~= nil then

            -- print(a)
            local products = a.products;
            local machname = a.machname;

			if not Config.okokTextUI then
				ESX.ShowHelpNotification("Pulsa [E] para ver lo que tiene la ~b~ maquina");
			else

                if a ~= 'uptdate' then
				    inRange = true;
                end
			end;
            -- print('esperando pressed')
            if IsControlJustPressed(1, 38) or IsDisabledControlJustPressed(1,38) and a ~= 'uptdate'  then
                -- print(json.encode(products))
                openmenu(products, machname);

            end;

		elseif a == "update" then
			Citizen.Wait(250);
		else
			Citizen.Wait(1500);
		end;

		if inRange and (not shown) then
			shown = true;
			exports.okokTextUI:Open("Pulsa [E] para ver lo que tiene la maquina", "darkblue", "left");
		elseif not inRange and shown then
			shown = false;
			exports.okokTextUI:Close();
            
		end;

	end;
end);
