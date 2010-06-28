
local myname, ns = ...
local BNLINK = "|HBNplayer:%s:%s:%s:%s:%s|h[%s]|h"


local function commafy(name, ...)
	if select("#", ...) > 0 then return ns.names[name:trim()].. ", ".. commafy(...)
	else return ns.names[name:trim()] end
end


local function bettername(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local msg, name, _, _, _, status, _, _, _, _, arg11 = ... -- arg13 is the presenceID, which isn't passed right now

	local chattype = strsub(event, 10)
	local chatGroup = Chat_GetChatCategory(chattype)

	local chatTarget = chatGroup == "BN_CONVERSATION" and tostring(arg8) or name:upper()

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


ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", function(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local msg, name, _, _, _, flag, _, arg8, _, _, arg11 = ...
	local info = ChatTypeInfo.BN_CONVERSATION

	local chatGroup = Chat_GetChatCategory("BN_CONVERSATION")
	local chatTarget = tostring(arg8)

	if self.bnConversationList and not self.bnConversationList[arg8] or self.excludeBNConversationList and self.excludeBNConversationList[arg8] then return true end

	local _, fontHeight = FCF_GetChatWindowInfo(self:GetID())
	fontHeight = fontHeight == 0 and 14 or fontHeight

	local pflag = strlen(flag) > 0 and _G["CHAT_FLAG_"..flag] or ""
	local playerLink = pflag.."|Hplayer:"..name..":"..arg11..":"..chatGroup..(chatTarget and ":"..chatTarget or "").."|h["..ns.names[name].."]|h"

	local stamp = CHAT_TIMESTAMP_FORMAT and BetterDate(CHAT_TIMESTAMP_FORMAT, time()) or ""
	local body = stamp..CHAT_BN_CONVERSATION_GET_LINK:format(arg8, MAX_WOW_CHAT_CHANNELS + arg8)..CHAT_BN_CONVERSATION_GET:format(playerLink)..msg

	local accessID, typeID = ChatHistory_GetAccessID(chatGroup, chatTarget), ChatHistory_GetAccessID("BN_CONVERSATION", chatTarget)
	self:AddMessage(body, info.r, info.g, info.b, info.id, false, accessID, typeID)
	return true
end)


ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_ALERT", function(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local arg1, name, _, _, _, _, _, _, _, _, arg11 = ...
	if arg1 == "FRIEND_REQUEST" or arg1 == "FRIEND_PENDING" or arg1 == "FRIEND_REMOVED" then return end

	local info = ChatTypeInfo.BN_INLINE_TOAST_ALERT
	if FCFManager_ShouldSuppressMessage(self, "BN_INLINE_TOAST_ALERT", nil) then return true end

	local playerLink = format(BNLINK, name, ns.pIDs[name], arg11, "BN_INLINE_TOAST_ALERT", 0, ns.names[name])
	self:AddMessage(_G["BN_INLINE_TOAST_"..arg1]:format(playerLink), info.r, info.g, info.b, info.id)
	return true
end)


ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_BROADCAST", function(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local msg, name, _, _, _, _, _, _, _, _, arg11 = ...
	if msg == "" then return end

	local info = ChatTypeInfo.BN_INLINE_TOAST_BROADCAST
	if FCFManager_ShouldSuppressMessage(self, "BN_INLINE_TOAST_ALERT", nil) then return true end

	local playerLink = format(BNLINK, name, ns.pIDs[name], arg11, "BN_INLINE_TOAST_ALERT", 0, ns.names[name])
	self:AddMessage(BN_INLINE_TOAST_BROADCAST:format(playerLink, msg), info.r, info.g, info.b, info.id)
	return true
end)


ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_INLINE_TOAST_CONVERSATION", function(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local names = ...

	local info = ChatTypeInfo.BN_INLINE_TOAST_BROADCAST
	if FCFManager_ShouldSuppressMessage(self, "BN_INLINE_TOAST_ALERT", nil) then return true end

	self:AddMessage(BN_INLINE_TOAST_CONVERSATION:format(commafy(string.split(",", names))), info.r, info.g, info.b, info.id)
	return true
end)


local notice_types = {CONVERSATION_CONVERTED_TO_WHISPER = true, MEMBER_JOINED = true, MEMBER_LEFT = true}
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION_NOTICE", function(self, event, ...)
	ns.Debug("Chat filter", event, ...)

	local notice_type, name, _, _, _, _, _, arg8, _, _, arg11 = ...
	if not notice_types[notice_type] then return end

	local info = ChatTypeInfo.BN_CONVERSATION_NOTICE
	if self.bnConversationList and not self.bnConversationList[arg8] or self.excludeBNConversationList and self.excludeBNConversationList[arg8] then return true end

	local channelLink = CHAT_BN_CONVERSATION_GET_LINK:format(arg8, MAX_WOW_CHAT_CHANNELS + arg8)
	local playerLink = BNLINK:format(name, ns.pIDs[name], arg11, Chat_GetChatCategory("BN_CONVERSATION_NOTICE"), arg8, ns.names[name])
	local message = _G["CHAT_CONVERSATION_"..notice_type.."_NOTICE"]:format(channelLink, playerLink)

	local accessID = ChatHistory_GetAccessID(Chat_GetChatCategory("BN_CONVERSATION_NOTICE"), arg8)
	local typeID = ChatHistory_GetAccessID("BN_CONVERSATION_NOTICE", arg8)
	self:AddMessage(message, info.r, info.g, info.b, info.id, false, accessID, typeID)
	-- return true
end)

