
local myname, ns = ...


ns:RegisterEvent("ADDON_LOADED")
function ns:ADDON_LOADED(event, addon)
	if addon ~= myname then return end

	LibStub("tekKonfig-AboutPanel").new(nil, myname)

	self:UnregisterEvent("ADDON_LOADED")
	self.ADDON_LOADED = nil
end
