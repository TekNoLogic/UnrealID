
local myname, ns = ...


local o = BNToastFrameTopLine.SetFormattedText
function BNToastFrameTopLine:SetFormattedText(format, ...) return o(self, "%s", ...) end
