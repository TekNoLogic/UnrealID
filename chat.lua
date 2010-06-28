
local myname, ns = ...


local function bettername(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local msg, name, _, _, _, status, _, _, _, _, arg11 = ... -- arg13 is the presenceID, which isn't passed right now

	local chattype = event == "CHAT_MSG_BN_WHISPER" and "BN_WHISPER" or "BN_WHISPER_INFORM"
	local chatGroup, chatTarget = Chat_GetChatCategory(chattype), name:upper()

	local flag, stamp = status and status ~= '' and _G["CHAT_FLAG_"..status] or "", CHAT_TIMESTAMP_FORMAT and BetterDate(CHAT_TIMESTAMP_FORMAT, time()) or ""
	msg = gsub(msg, "%%", "%%%%")
	local body = stamp.. format(_G["CHAT_"..chattype.."_GET"]..msg, flag.."|HBNplayer:"..name..":"..ns.pIDs[name]..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h".."["..ns.names[name].."]".."|h")

	local accessID, typeID, info = ChatHistory_GetAccessID(chatGroup, chatTarget), ChatHistory_GetAccessID(chattype, chatTarget), ChatTypeInfo[chattype]
	self:AddMessage(body, info.r, info.g, info.b, info.id, false, accessID, typeID)

	ChatEdit_SetLastTellTarget(name)
	if self.tellTimer and (GetTime() > self.tellTimer) then PlaySound("TellMessage") end
	self.tellTimer = GetTime() + CHAT_TELL_ALERT_TIME

	return true
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", bettername)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", bettername)
