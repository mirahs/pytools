local M = {}
local moduleName = ...
_G[moduleName] = M
setmetatable(M, {__index = _G})
local _ENV = M


function new()
	local tab_obj = {}
	setmetatable(tab_obj, {__index = AckRoleLoginOkNoRole})
	tab_obj:init()
	return tab_obj
end

function init(self)
end


function encode(self)
	pack = packet.new()
	return pack:encode(Msg.P_ACK_ROLE_LOGIN_OK_NO_ROLE)
end

