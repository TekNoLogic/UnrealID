
local myname, ns = ...


hooksecurefunc("BNToastFrame_Show", function()
	local toastType, toastData = BNToastFrame.toastType, BNToastFrame.toastData
	if not toastType or toastType < 1 or toastType > 3 then return end

	BNToastFrameTopLine:SetText(ns.names[toastData])
end)
