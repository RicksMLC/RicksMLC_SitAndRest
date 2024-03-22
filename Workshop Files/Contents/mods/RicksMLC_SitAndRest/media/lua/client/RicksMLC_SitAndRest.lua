-- Rick's MLC Sit And Rest
--

require "TimedActions/ISRestAction"

RicksMLC_SitAndRestTA = ISRestAction:derive("RicksMLC_SitAndRestTA");
RicksMLC_SitAndRestTA.base = ISRestAction

function RicksMLC_SitAndRestTA:new(character)
	local o = ISRestAction:new(character)
	setmetatable(o, self)
	self.__index = self

	return o
end

function RicksMLC_SitAndRestTA:start()
	ISRestAction.start(self)
	if not self.character:isSitOnGround() then
		ISWorldObjectContextMenu.onSitOnGround(self.character:getPlayerNum())
	end
end

local function RicksMLC_onSitAndRest(bed, player)
   local playerObj = getSpecificPlayer(player)
   if luautils.walkAdj(getSpecificPlayer(player), bed:getSquare()) then
       ISTimedActionQueue.add(RicksMLC_SitAndRestTA:new(playerObj))
   end
end

local function AddSitAndRestOption(player, context, worldobjects, test)
	local playerObj = getSpecificPlayer(player)
	if bed and not ISWorldObjectContextMenu.isSomethingTo(bed, player) and (playerObj:getStats():getEndurance() < 1) then
		if bed:getSquare():getRoom() == playerObj:getSquare():getRoom() then
			context:addOption(getText("ContextMenu_RicksMLC_SitAndRest"), bed, RicksMLC_onSitAndRest, player);
		end
	end
end

Events.OnFillWorldObjectContextMenu.Add(AddSitAndRestOption)
