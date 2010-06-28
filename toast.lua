
local myname, ns = ...


hooksecurefunc("BNToastFrame_Show", function()
	local toastType, toastData = BNToastFrame.toastType, BNToastFrame.toastData
	if not toastType or toastType < 1 or toastType > 3 then return end

	local _, givenName, surname, _, _, _, _, _, _, _, _, note = BNGetFriendInfoByID(toastData)
	local name = ns.names[givenName.." "..surname]
	if name then BNToastFrameTopLine:SetText(name) end
end)
