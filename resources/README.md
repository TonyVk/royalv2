# Dinamicne mafije [FiveM]
### Instalacija
5 stvari je potrebno kako bi skripta radila normalno

U [essential]\es_extended\server\common.lua je potrebno dodati:
```
RegisterServerEvent('RefreshPoslove')
AddEventHandler('RefreshPoslove', function()
	ESX.Jobs = {}
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		ESX.Jobs[result[i].name] = result[i]
		ESX.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if ESX.Jobs[result2[i].job_name] then
			ESX.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('es_extended: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(ESX.Jobs) do
		if next(v.grades) == nil then
			ESX.Jobs[v.name] = nil
			print(('es_extended: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)
```

U esx_addonaccount u server\main.lua:

```
RegisterServerEvent('RefreshAddone')
AddEventHandler('RefreshAddone', function()
	SharedAccounts = {}
	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_account')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @account_name', {
			['@account_name'] = name
		})

		if shared == 0 then
			table.insert(AccountsIndex, name)
			Accounts[name] = {}

			for j=1, #result2, 1 do
				local addonAccount = CreateAddonAccount(name, result2[j].owner, result2[j].money)
				table.insert(Accounts[name], addonAccount)
			end
		else
			local money = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO addon_account_data (account_name, money, owner) VALUES (@account_name, @money, NULL)', {
					['@account_name'] = name,
					['@money']        = 0
				})

				money = 0
			else
				money = result2[1].money
			end

			local addonAccount   = CreateAddonAccount(name, nil, money)
			SharedAccounts[name] = addonAccount
		end
	end
end)
```

U esx_society/server/main.lua:

```
RegisterNetEvent('RefreshSociety')
AddEventHandler('RefreshSociety', function()
	Jobs = {}
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)
```

U esx_datastore/server/main.lua:

```
RegisterNetEvent('RefreshDatastore')
AddEventHandler('RefreshDatastore', function()
	DataStores = {}
	DataStoresIndex = {}
	SharedDataStores = {}
	local result = MySQL.Sync.fetchAll('SELECT * FROM datastore')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM datastore_data WHERE name = @name', {
			['@name'] = name
		})

		if shared == 0 then
			table.insert(DataStoresIndex, name)
			DataStores[name] = {}

			for j=1, #result2, 1 do
				local storeName  = result2[j].name
				local storeOwner = result2[j].owner
				local storeData  = (result2[j].data == nil and {} or json.decode(result2[j].data))
				local dataStore  = CreateDataStore(storeName, storeOwner, storeData)

				table.insert(DataStores[name], dataStore)
			end
		else
			local data = nil

			if #result2 == 0 then
				MySQL.Sync.execute('INSERT INTO datastore_data (name, owner, data) VALUES (@name, NULL, \'{}\')', {
					['@name'] = name
				})

				data = {}
			else
				data = json.decode(result2[1].data)
			end

			local dataStore = CreateDataStore(name, nil, data)
			SharedDataStores[name] = dataStore
		end
	end
end)
```

U esx_addoninventory/server/main.lua:

```
RegisterServerEvent('RefreshInventory')
AddEventHandler('RefreshInventory', function()
	Items = {}
	InventoriesIndex = {}
	Inventories = {}
	SharedInventories = {}
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')

	for i=1, #items, 1 do
		Items[items[i].name] = items[i].label
	end

	local result = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory')

	for i=1, #result, 1 do
		local name   = result[i].name
		local label  = result[i].label
		local shared = result[i].shared

		local result2 = MySQL.Sync.fetchAll('SELECT * FROM addon_inventory_items WHERE inventory_name = @inventory_name', {
			['@inventory_name'] = name
		})

		if shared == 0 then

			table.insert(InventoriesIndex, name)

			Inventories[name] = {}
			local items       = {}

			for j=1, #result2, 1 do
				local itemName  = result2[j].name
				local itemCount = result2[j].count
				local itemOwner = result2[j].owner

				if items[itemOwner] == nil then
					items[itemOwner] = {}
				end

				table.insert(items[itemOwner], {
					name  = itemName,
					count = itemCount,
					label = Items[itemName]
				})
			end

			for k,v in pairs(items) do
				local addonInventory = CreateAddonInventory(name, k, v)
				table.insert(Inventories[name], addonInventory)
			end

		else
			local items = {}

			for j=1, #result2, 1 do
				table.insert(items, {
					name  = result2[j].name,
					count = result2[j].count,
					label = Items[result2[j].name]
				})
			end

			local addonInventory    = CreateAddonInventory(name, nil, items)
			SharedInventories[name] = addonInventory
		end
	end
end)
```
