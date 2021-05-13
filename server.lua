FakeNames = {}
FakeNames.Players = {}

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM fakenames',{},function(res)
		for k,v in ipairs(res) do
			FakeNames.Players[v.identifier] = (FakeNames.Players[v.identifier] or {})
			FakeNames.Players[v.identifier].firstname  = v.firstname
			FakeNames.Players[v.identifier].lastname  = v.lastname
			FakeNames.Players[v.identifier].dateofbirth  = v.dateofbirth
		end
	end)
end)	

RegisterServerEvent('av:generate')
AddEventHandler('av:generate', function(name, lastname, dob)
	local identifier = GetPlayerIdentifier(source)
	local result = MySQL.Sync.fetchAll('SELECT identifier FROM fakenames WHERE identifier = @identifier', {
		['@identifier'] = identifier
	})
	if #result > 0 then
		MySQL.Async.execute('UPDATE fakenames SET firstname = @firstname, lastname = @lastname, dateofbirth = @dateofbirth WHERE identifier = @identifier',
			{
				['@identifier']   = identifier,
				['@firstname']   = name,
				['@lastname']   = lastname,
				['@dateofbirth']   = dob,
			},
			function()
				FakeNames.Players[identifier] = (FakeNames.Players[identifier] or {})
				FakeNames.Players[identifier].firstname = name
				FakeNames.Players[identifier].lastname = lastname
				FakeNames.Players[identifier].dateofbirth = dob
			end
		)		
	else
		MySQL.Async.execute('INSERT INTO fakenames (identifier, firstname, lastname, dateofbirth) VALUES (@identifier, @firstname, @lastname, @dateofbirth)',
			{
				['@identifier']   = identifier,
				['@firstname']   = name,
				['@lastname']   = lastname,
				['@dateofbirth']   = dob,
			},
			function()
				FakeNames.Players[identifier] = (FakeNames.Players[identifier] or {})
				FakeNames.Players[identifier].firstname = name
				FakeNames.Players[identifier].lastname = lastname
				FakeNames.Players[identifier].dateofbirth = dob
			end
		)
	end
end)

RegisterServerEvent('av:showid')
AddEventHandler('av:showid', function()
	local identifier = GetPlayerIdentifier(source)
	
	if FakeNames.Players[identifier] then
		TriggerClientEvent("chat:proximity", -1, source, {
			template = '<div class="chat-message advert"><div class="chat-message-body"><strong>{0}</strong><br><strong>Name:</strong> {1} <br><strong>Lastname:</strong> {2} <br><strong>DOB:</strong> {3}</div></div>',
			args = {'Citizen ID', FakeNames.Players[identifier].firstname, FakeNames.Players[identifier].lastname, FakeNames.Players[identifier].dateofbirth}
		})
	end
end)