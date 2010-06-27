
local origs, butts, inhook = {}, {}


local function NewSetText(frame, str, ...)
	if inhook then return end -- Failsafe to avoid the great infinity
	inhook = true

	local butt = butts[frame]
	if butt.buttonType == FRIENDS_BUTTON_TYPE_BNET then
		local _, givenName, surname, _, _, client, online, _, _, _, _, note = BNGetFriendInfo(butt.id)
		if givenName and surname and (client == BNET_CLIENT_WOW or not online) then
			local origname = BATTLENET_NAME_FORMAT:format(givenName, surname)
			origs[frame](frame, str:gsub("^"..origname, note and note ~= "" and note or givenName), ...)
		end
	end

	inhook = nil
end


for i=1,FRIENDS_TO_DISPLAY do
	local f = _G["FriendsFrameFriendsScrollFrameButton"..i.."Name"]
	butts[f] = _G["FriendsFrameFriendsScrollFrameButton"..i]
	origs[f] = f.SetText
	hooksecurefunc(f, "SetText", NewSetText)
end
