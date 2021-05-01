local ESX = nil
local colors = {
	[0] = 'Crna',
	[1] = 'Crna',
	[2] = 'Crna',
	[55] = 'Crna',
	[56] = 'Crna',
	[57] = 'Crna',
	[58] = 'Crna',
	[59] = 'Crna',
	[60] = 'Crna',
	[61] = 'Crna',
	[3] = 'Smedja',
	[4] = 'Smedja',
	[5] = 'Smedja',
	[6] = 'Smedja',
	[7] = 'Smedja',
	[8] = 'Smedja',
	[9] = 'Crvena',
	[10] = 'Crvena',
	[11] = 'Crvena',
	[12] = 'Crvena',
	[13] = 'Crvena',
	[14] = 'Crvena',
	[15] = 'Crvena',
	[16] = 'Crvena',
	[62] = 'Crvena',
	[63] = 'Crvena',
	[26] = 'Siva',
	[27] = 'Siva',
	[28] = 'Siva',
	[29] = 'Siva',
	[30] = 'Ljubicasta',
	[31] = 'Ljubicasta',
	[32] = 'Ljubicasta',
	[33] = 'Ljubicasta',
	[34] = 'Ljubicasta',
	[35] = 'Ljubicasta',
	[36] = 'Tirkizna',
	[37] = 'Tirkizna',
	[38] = 'Tirkizna',
	[39] = 'Zelena',
	[40] = 'Zelena',
	[41] = 'Zelena',
	[42] = 'Zelena',
	[43] = 'Zelena',
	[44] = 'Zelena',
	[45] = 'Zuta',
	[46] = 'Zuta',
	[47] = 'Narancasta',
	[48] = 'Narancasta',
	[49] = 'Narancasta',
	[51] = 'Narancasta',
	[52] = 'Narancasta'
}
local letter   = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'X', 'Y'}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

math.randomseed(os.time())

-- Fetch
ESX.RegisterServerCallback('databaza:fetch', function( source, cb, data, type )
  if type == 'start' then
    MySQL.Async.fetchAll('SELECT date, offense, institution, charge, term, classified FROM jsfour_criminalrecord', {},
    function (result)
      cb(result)
    end)
  elseif type == 'record' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_criminalrecord WHERE offense = @offense', {['@offense'] = data.offense},
    function (resultRecord)
		if resultRecord[1] ~= nil then
	      MySQL.Async.fetchAll('SELECT firstname, lastname, sex FROM jsfour_criminaluserinfo WHERE identifier = @identifier', {['@identifier'] = resultRecord[1].identifier},
	      function (resultUser)
	        local array = {
	          userinfo = resultUser,
	          records = resultRecord
	        }
	        cb(array)
	      end)
		else
			cb('error')
		end
    end)
  elseif type == 'user' then
    MySQL.Async.fetchAll('SELECT * FROM jsfour_criminaluserinfo WHERE dob = @dob', {['@dob'] = data.dob},
    function (resultUser)
      MySQL.Async.fetchAll('SELECT * FROM jsfour_criminalrecord WHERE identifier = @identifier', {['@identifier'] = resultUser[1].identifier},
      function (resultRecord)
        local array = {
          userinfo = resultUser,
          records = resultRecord
        }
        cb(array)
      end)
    end)
  end
end)

-- Search
ESX.RegisterServerCallback('databaza:search', function( source, cb, data )
  local query    = 'SELECT * FROM jsfour_criminaluserinfo'
  local queryVal = nil

  if string.len(data.dob) > 0 then
    query    = 'SELECT * FROM jsfour_criminaluserinfo WHERE dob = @x'
    queryVal = data.dob
  elseif string.len(data.firstname) > 0 then
    query = 'SELECT * FROM jsfour_criminaluserinfo WHERE firstname = @x'
    queryVal = data.firstname
  elseif string.len(data.lastname) > 0 then
    query = 'SELECT * FROM jsfour_criminaluserinfo WHERE lastname = @x'
    queryVal = data.lastname
  elseif string.len(data.offense) > 0 then
		cb('ok')
  end

  if queryVal == nil then
    MySQL.Async.fetchAll(query, {},
     function (result)
       if result[1] ~= nil then
		cb(result)
       else
         cb('error')
       end
     end)
   else
     MySQL.Async.fetchAll(query, {['@x'] = queryVal},
      function (result)
        if result[1] ~= nil then
          cb(result)
        else
          cb('error')
        end
      end)
   end
end)

-- Add
ESX.RegisterServerCallback('databaza:add', function( source, cb, data )
  local recordid = letter[math.random(1,6)] .. math.random(0,999) .. letter[math.random(1,6)] .. math.random(0,999)
  local weight   = 0
  local warden = ESX.GetPlayerFromId(source).identifier

  local date    = data.date
  local offense = letter[math.random(1,6)] .. '-' .. math.random(100,999)

  if date == 'DANAS' then
    date = os.date('%Y-%m-%d')
  end

  MySQL.Async.fetchAll('SELECT firstname FROM users WHERE identifier = @identifier', {['@identifier'] = warden},
  function (result)
    warden = result[1].firstname
  end)


  MySQL.Async.fetchAll('SELECT identifier, skin, sex, height FROM users WHERE UPPER(firstname) = @firstname AND UPPER(lastname) = @lastname AND dateofbirth = @dateofbirth', {['@firstname'] = data.firstname, ['@lastname'] = data.lastname, ['@dateofbirth'] = data.dob},
  function (result)
    if result[1] ~= nil then
      local identifier = result[1].identifier

      if result[1].sex == 'M' then
       if tonumber(result[1].height) < 170 then
         weight = math.random(52,65)
       else
         weight = math.random(65,90)
       end
      else
        if tonumber(result[1].height) < 170 then
         weight = math.random(49,61)
        else
         weight = math.random(61,85)
        end
      end

      MySQL.Async.fetchAll('SELECT identifier FROM jsfour_criminaluserinfo WHERE identifier = @identifier', {['@identifier'] = identifier},
      function (resultCheck)
        if resultCheck[1] == nil then
          MySQL.Async.execute('INSERT INTO jsfour_criminaluserinfo (identifier, aliases, recordid, weight, eyecolor, haircolor, firstname, lastname, dob, sex, height) VALUES (@identifier, @aliases, @recordid, @weight, @eyecolor, @haircolor, @firstname, @lastname, @dob, @sex, @height)',
           {
             ['@identifier'] = identifier,
             ['@aliases']    = data.firstname,
             ['@recordid']   = recordid,
             ['@weight']     = weight .. 'kg',
             ['@eyecolor']   = colors[json.decode(result[1].skin)['eye_color']],
             ['@haircolor']  = colors[json.decode(result[1].skin)['hair_color_1']],
             ['@firstname']  = data.firstname,
             ['@lastname']   = data.lastname,
             ['@dob']        = data.dob,
             ['@sex']        = result[1].sex,
             ['@height']     = result[1].height .. 'cm'
           },
           function (rowsChanged)
             MySQL.Async.execute('INSERT INTO jsfour_criminalrecord (offense, date, institution, charge, description, term, classified, identifier, dob, warden) VALUES (@offense, @date, @institution, @charge, @description, @term, @classified, @identifier, @dob, @warden)',
              {
                ['@offense']     = offense,
                ['@date']        = date,
                ['@institution'] = 'LOS SANTOS',
                ['@charge']      = data.charge,
                ['@description'] = data.description,
                ['@term']        = data.term,
                ['@classified']  = 0,
                ['@identifier']  = identifier,
                ['@dob']         = data.dob,
                ['@warden']      = warden
              },
              function (rowsChanged)
                MySQL.Async.fetchAll('SELECT * FROM jsfour_criminalrecord WHERE offense = @offense', {['@offense'] = offense},
                 function (result)
                   if result[1] ~= nil then
                     MySQL.Async.fetchAll('SELECT * FROM jsfour_criminaluserinfo WHERE UPPER(firstname) = @firstname AND UPPER(lastname) = @lastname AND dob = @dob', {['@firstname'] = data.firstname, ['@lastname'] = data.lastname, ['@dob'] = data.dob},
                      function (uinfo)
                        if uinfo[1] ~= nil then
                          local array = {
                            userinfo = uinfo,
                            records = result
                          }

                          cb(array)
                        end
                      end)
                   end
                 end)
             end)
          end)
        else
          MySQL.Async.execute('INSERT INTO jsfour_criminalrecord (offense, date, institution, charge, description, term, classified, identifier, dob, warden) VALUES (@offense, @date, @institution, @charge, @description, @term, @classified, @identifier, @dob, @warden)',
           {
             ['@offense']     = offense,
             ['@date']        = date,
             ['@institution'] = 'LOS SANTOS',
             ['@charge']      = data.charge,
             ['@description'] = data.description,
             ['@term']        = data.term,
             ['@classified']  = 0,
             ['@identifier']  = identifier,
             ['@dob']         = data.dob,
             ['@warden']      = warden
           },
           function (rowsChanged)
             MySQL.Async.fetchAll('SELECT * FROM jsfour_criminalrecord WHERE offense = @offense', {['@offense'] = offense},
              function (result)
                if result[1] ~= nil then
                  MySQL.Async.fetchAll('SELECT * FROM jsfour_criminaluserinfo WHERE UPPER(firstname) = @firstname AND UPPER(lastname) = @lastname AND dob = @dob', {['@firstname'] = data.firstname, ['@lastname'] = data.lastname, ['@dob'] = data.dob},
                   function (uinfo)
                     if uinfo[1] ~= nil then
                       local array = {
                         userinfo = uinfo,
                         records = result
                       }
                       cb(array)
                     end
                   end)
                end
              end)
          end)
        end
      end)
     else
       cb('error')
     end
   end)
end)

-- Update
ESX.RegisterServerCallback('databaza:update', function( source, cb, data )
	if data.description ~= nil then
	  MySQL.Async.execute('UPDATE jsfour_criminalrecord SET description = @description WHERE offense = @offense', {['@description'] = data.description, ['@offense'] = data.offense})
	  cb('ok')
	elseif data.classified ~= nil then
		MySQL.Async.execute('UPDATE jsfour_criminalrecord SET classified = @classified WHERE offense = @offense', {['@classified'] = data.classified, ['@offense'] = data.offense})
 	 	cb('ok')
	end
end)

-- Remove
ESX.RegisterServerCallback('databaza:remove', function( source, cb, data )
  MySQL.Async.fetchAll('SELECT identifier FROM jsfour_criminalrecord WHERE offense = @offense', {['@offense'] = data.offense},
  function (resultID)
    MySQL.Async.fetchAll('SELECT * FROM jsfour_criminalrecord WHERE identifier = @identifier', {['@identifier'] = resultID[1].identifier},
    function (resultAll)
      if #resultAll < 2 then
        MySQL.Async.execute('DELETE FROM jsfour_criminaluserinfo WHERE identifier = @identifier',{ ['@identifier'] = resultID[1].identifier})
        MySQL.Async.execute('DELETE FROM jsfour_criminalrecord WHERE offense = @offense',{ ['@offense'] = data.offense})
      else
        MySQL.Async.execute('DELETE FROM jsfour_criminalrecord WHERE offense = @offense',{ ['@offense'] = data.offense})
      end
      cb('ok')
    end)
  end)
end)
