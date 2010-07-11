
local myname, ns = ...


ns.names = setmetatable({}, {__index = function(t,i)
	if type(i) == "number" then
		local _, givenName, surname, _, _, _, _, _, _, _, _, note = BNGetFriendInfoByID(toastData)
		local v = note ~= "" and note or givenName
		t[i] = v
		return v
	else
		for j=1,BNGetNumFriends() do
			local _, givenName, surname, _, _, _, _, _, _, _, _, note = BNGetFriendInfo(j)
			if (givenName.. " ".. surname) == i then
				local v = note ~= "" and note or givenName
				t[i] = v
				return v
			end
		end
	end
	return i
end})


ns.pIDs = setmetatable({}, {__index = function(t,i)
	for j=1,BNGetNumFriends() do
		local pID, givenName, surname = BNGetFriendInfo(j)
		if (givenName.. " ".. surname) == i then
			t[i] = pID
			return pID
		end
	end
end})


function ns:BN_CONNECTED(...)
	if BNConnected() then
		for i=1,BNGetNumFriends() do
			local pID, givenName, surname, _, _, _, _, _, _, _, _, note = BNGetFriendInfo(i)
			local k = givenName.. " ".. surname
			ns.names[k], ns.pIDs[k] = (note ~= '' and note) or givenName, pID
			ns.names[pID] = ns.names[k]
		end
	else
		table.wipe(ns.names)
		table.wipe(ns.pIDs)
	end
end
ns.BN_DISCONNECTED = ns.BN_CONNECTED
ns.PLAYER_LOGIN = ns.BN_CONNECTED
ns.BN_SELF_ONLINE = ns.BN_CONNECTED
ns:RegisterEvent("BN_CONNECTED")
ns:RegisterEvent("BN_DISCONNECTED")
ns:RegisterEvent("BN_SELF_ONLINE")
ns:RegisterEvent("PLAYER_LOGIN")
