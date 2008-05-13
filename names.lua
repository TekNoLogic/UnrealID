
local myname, ns = ...


ns.names = setmetatable({}, {__index = function(t,i)
	local _, online = BNGetNumFriends()
	for j=1,online do
		local _, givenName, surname, _, _, _, _, _, _, _, _, note = BNGetFriendInfo(j)
		if (givenName.. " ".. surname) == i then
			local v = note and note ~= "" and note or givenName
			t[i] = v
			return v
		end
	end
	return i
end})

function ns.GetPresenceID(name)
	local _, online = BNGetNumFriends()
	for i=1,online do
		local pID, givenName, surname = BNGetFriendInfo(i)
		if (givenName.. " ".. surname) == name then
			return pID
		end
	end
end
