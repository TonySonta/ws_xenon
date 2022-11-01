ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('ws:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)

ESX.RegisterServerCallback('ws:XenonCheckVehicle', function(source, cb, ProprieterVehicule)
	local ColorOrigine = nil
	local NeonBackActived = nil

    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = ProprieterVehicule.plate
	}, function(result)

        if result[1] then
            local vehicle = json.decode(result[1].vehicle)
        
            for _,v in pairs(result) do
                ColorOrigine = vehicle.xenonColor
				NeonBackActived = vehicle.neonEnabled
				NeonColorOrigine = vehicle.neonColor
				OpenMenuAutorise = 'autorise'
            end
            cb(ColorOrigine,NeonBackActived,NeonColorOrigine,OpenMenuAutorise)
    
            print('véhicule bien trouver')

		
        else
            print('véhicule sans propriétaire')
    
        end
	end)
end)

RegisterNetEvent('ws:validechangexenom')
AddEventHandler('ws:validechangexenom', function(ProprieterVehicule)
    MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = ProprieterVehicule.plate
    }, function(result)
		if result[1] then
			local vehicle = json.decode(result[1].vehicle)

			if ProprieterVehicule.model == vehicle.model then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
					['@plate'] = ProprieterVehicule.plate,
					['@vehicle'] = json.encode(ProprieterVehicule)
				})
			else
				print(("ERRROR VEHICLE NON CONFORME"):format(xPlayer.identifier))
			end
		end
	end)
end)

RegisterNetEvent('ws:paiementXenonMechanicJob')
AddEventHandler('ws:paiementXenonMechanicJob',function(ValeurDuChoix)
    local src = source
    local AccountSocietyMechanic = nil 
    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_'..ConfXenom.JobOnly, function(account)
        AccountSocietyMechanic = account
    end)
    AccountSocietyMechanic.removeMoney(ValeurDuChoix)
end)

ESX.RegisterServerCallback('xenon:getOtherPlayerData', function(source, cb, target)
	local targer = target
	local xPlayer = ESX.GetPlayerFromId(targer)

	if xPlayer ~= nil then 

	MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		local data = {
			name = GetPlayerName(target),
			job = xPlayer.job,
			job2 = xPlayer.job2,
			inventory = xPlayer.inventory,
			accounts = xPlayer.accounts,
			weapons = xPlayer.getLoadout(),
			m = result[1]['money'],
			firstname = result[1]['firstname'],
			grade = result[1]['job_grade'],
			lastname = result[1]['lastname'],
			sex = result[1]['sex'],
			dob = result[1]['dateofbirth'],
			height = result[1]['height']
		}
	
		cb(data)
		end)
	end
end)