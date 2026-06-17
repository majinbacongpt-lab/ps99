local function getRoomsTable()
	local ClientModule = require(game.Workspace.__THINGS.__INSTANCE_CONTAINER.Active.Backrooms.ClientModule)
	local getfenv = getfenv
	local getupvalues = debug.getupvalues or getupvalues
	if not getfenv or not getupvalues then return nil end
	local env = getfenv(ClientModule.OnJoin)
	if not env then return nil end
	local getRoom = env.getRoom
	if not getRoom then return nil end
	for _, v in pairs(getupvalues(getRoom)) do
		if typeof(v) == "table" then
			return v
		end
	end
	return nil
end

local roomsTable = getRoomsTable()
if not roomsTable then
	print("roomsTable is nil!")
else
	local found = false
	for uid, roomController in pairs(roomsTable) do
		local model = roomController.model
		local name = model and model.Name or "Unknown"
		local roomId = model and model:GetAttribute("RoomID") or "Unknown"
		print("UID:", uid, "Name:", name, "RoomID:", roomId)
		if name == "MiniBossRoom" or roomId == "MiniBossRoom" then
			found = true
			print("firing")
			local success, err = pcall(function()
				roomController:FireServer("UnlockDoors")
			end)
			print("output:", success, err)
		end
	end
	if not found then
		print("not found")
	end
end
