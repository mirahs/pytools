module("AckSceneMove", package.seeall)


function new()
	local tab_obj = {}
	setmetatable(tab_obj, {__index = AckSceneMove})
	tab_obj:init()
	return tab_obj
end

function init(self)
	self.scene_rot_pos = nil
	self.forward = nil
	self.ani_name = ""
	self.x_axis = 0
	self.uid = 0
end


function encode(self)
	local pack = packet.new()
	pack:writeBytes(self.scene_rot_pos:getBytes())
	pack:writeBytes(self.forward:getBytes())
	pack:writeString(self.ani_name)
	pack:writeI16(self.x_axis)
	pack:writeU32(self.uid)
	return pack:encode(Msg.P_ACK_SCENE_MOVE)
end