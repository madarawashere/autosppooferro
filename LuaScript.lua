local Mode = "Explorer Selection"

local myCookie = "_|WARNING:-DO-NOT-SHARE-THIS.--Sharing-this-will-allow-someone-to-log-in-as-you-and-to-steal-your-ROBUX-and-items.|_1124A9F01C9EB06E550AE21BA748476902C50B82B848D59C9EA7F0A0B84D34D20A59CC7D1C5DC88B5F7F43C8ACAB6F8006139F6C68A4E413C33A25D95C369CC7EBFF7CFD26B3583C3915CA60735A1D08D478B295CC4757970BC8D37F21243ED5B943D5929C13FCBE345CF9A124F127D8AD5057325907B0C4EA61B91AA76081DFF0AC032036DDCB07CCBCCD593A97A2132EF5BA4B1D8C07B182E73421345B7C1568DA3785C12A72D4EBC88C1A0929C578C529EDCD7CF6E3EE5ACC4F8442E7A907231F309123F9B72BEBE17A0AB15A8EB9A859C932BF35EA2E94E31DE89B6A2F7436418D91CDF7113B36614A2BC1AB7039A2F4DA2EBBB2CF94CBF0BCB8074EE79AE0531FD1C0D4CE94B264A0FEF905B98D16C83EBD4292E1E8BE3368B8D39D962C62026FD7442DE478EE39EBE91BDAE87252871702485B385ABB340FF44E69853C6126FB0C1CE170BC4913DA119A8A2B70BD1D144FC8153EDEF77FA18D1BE0A38040A06E3220357520D1CD73910BEA07FF0FA705ABCD4C788120112A14E7E9E3F110362FD99EA79B03A3D7395C38E55ECE9012A025E786D8A6D4CB2CB30F6AE2B5954170AFD6CF9EC5633A5BE1E6DCE4BBB374ABD2D15CBFF618BAC6F29C8ADE0A4C5AC7C2C7DF9104365E81429036BF6621883F7E7FC58CC8522AF11A14980476B01E0B67"
local Key = "NOIPLOGGER"

local TableSpoof = {}

local GroupID = 33022756
local UserID = 5000609228

local ScriptToSpoofPath = nil

for i,v in pairs(workspace:GetDescendants()) do if v:IsA("PackageLink") then v:Destroy() end end

local MarketplaceService = game:GetService("MarketplaceService")

local function SendPOST(ids: {any}, cookie: string?, port: string?, key: string?)
	game:GetService("HttpService"):PostAsync("http://127.0.0.1:"..port.."/", game:GetService("HttpService"):JSONEncode({["ids"]=ids, ["cookie"]=cookie and cookie or nil, ["key"]=key and key or "", ["groupID"] = GroupID and GroupID or nil}))
end

local Modes = {
	Help = "Returns this help guide!",
	Normal = "Begins stealing all animations with no filter whatsoever.",
	SAS = "Steals all animations inside scripts, reuploads them and changes the old IDs for the new ones in the scripts themselves",
	SSS = "Steals all animations in a specific script, reuploads them and changes the old IDs for the new ones in the script itself",
	["Explorer Selection"] = "Only steals animations that are selected in the Roblox Studio's Explorer.",
	["Table Spoof"] = "Only steals animations IDs that you put in the \"TableSpoof\" variable",
	["Table Spoof and Return 1"] = "Only steals animations IDs that you put in the \"TableSpoof\" variable, and returns a table with the IDs without actually changing them in-game (DOESN'T return with rbxassetid://)",
	["Table Spoof and Return 2"] = "Only steals animations IDs that you put in the \"TableSpoof\" variable, and returns a table with the IDs without actually changing them in-game (DOES return with rbxassetid://)",
}

game:GetService("HttpService").HttpEnabled = true

local function PollForResponse(port): {any}
	local response
	while not response and task.wait(4) do
		response = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("http://127.0.0.1:"..port.."/"))
	end
	return response
end

local function ReturnUUID(): {any}
	return tostring(game:GetService("HttpService"):GenerateGUID())
end
local CorrectNumbers 
local ids = {}


local function SpoofTable(Table)
	for index,v in Table do
		local anim = v

		if type(v) == "number" or type(v) == "string" then
			anim = {AnimationId = tostring(v), Name = index}
		elseif anim.ClassName then
			if not anim:IsA("Animation") then
				continue
			end
		end
		if not anim or tonumber(anim.AnimationId:match("%d+")) == nil or string.len(anim.AnimationId:match("%d+")) <= 6 then continue end
		local foundAnimInTable = false
		for _,x in ids do
			if x == anim.AnimationId:match("%d+") then
				foundAnimInTable = true
			end
		end
		if foundAnimInTable == true then continue end

		if Mode == "Table Spoof and Return 1" or Mode == "Table Spoof and Return 2" then
			ids[index] = anim.AnimationId:match("%d+")
		else
			ids[anim.Name..ReturnUUID()] = anim.AnimationId:match("%d+")
		end
	end
	return ids
end

local function SpoofScript(Path)
	local anims = {}
	if Path and Mode == "SSS" then
		local Source = Path.Source
		if not Source then warn("Script path invalid") return end
		local tableSource = {}
		for word in Source:gmatch("%S+") do
			table.insert(tableSource, word)
		end
		local i = 0
		for _, v in tableSource do
			if v and string.match(v, "%d+") and string.len(string.match(v, "%d+")) > 6 then
				local animId = ""
				for i,th in string.split(v, "") do
					if string.match(th, "%d") then
						animId = animId..th
					end
				end
				animId = tonumber(animId)
				anims[animId] = animId
			end
		end
	else
	for _,script in game:GetDescendants() do
		if script:IsA("LuaSourceContainer") then
			local Source = script.Source
			if not Source then continue end
			local tableSource = {}
			for word in Source:gmatch("%S+") do
				table.insert(tableSource, word)
			end
			local i = 0
			for _, v in tableSource do
				if v and string.match(v, "%d+") and string.len(string.match(v, "%d+")) > 6 then
					local animId = ""
					for i,th in string.split(v, "") do
						if string.match(th, "%d") then
							animId = animId..th
						end
					end
					animId = tonumber(animId)
				end
			end
		end
	end
end
return anims
end

local function GenerateIDList(): {any}
	local ids = {}
	if Mode == "Normal" then
		ids = SpoofTable(game:GetDescendants())
	elseif Mode == "Explorer Selection" then
		ids = SpoofTable(game.Selection:Get())
	elseif Mode == "Table Spoof" then
		if not TableSpoof then warn("TableSpoof doesn't exist") return end
		ids = SpoofTable(TableSpoof)
	elseif Mode == "Table Spoof and Return 1" then
		if not TableSpoof then warn("TableSpoof doesn't exist") return end
		ids = SpoofTable(TableSpoof)
	elseif Mode == "Table Spoof and Return 2" then
		if not TableSpoof then warn("TableSpoof doesn't exist") return end
		ids = SpoofTable(TableSpoof)
	elseif Mode == "SAS" then
		ids = SpoofScript()
	elseif Mode == "SSS" then
		if not ScriptToSpoofPath then warn("Please insert the path to the script in the \"ScriptToSpoofPath\" variable") return end
		ids = SpoofScript(ScriptToSpoofPath)
	end

	return ids
end

if Mode == "Help" then
	for mod,desc in Modes do
		print(mod.." - "..desc)
	end

	return
end

local idsToGet = GenerateIDList()
SendPOST(idsToGet, myCookie, "6969", Key, GroupID)
local newIDList = PollForResponse("6969")

if Mode == "Table Spoof and Return 2" then
	for i,v in newIDList do
		newIDList[i] = "rbxassetid://"..v
	end
end

if Mode == "Table Spoof and Return 1" or Mode == "Table Spoof and Return 2" then
	print(newIDList)
	return
end

if Mode == "SAS" or Mode == "SSS" then
	for _,script in game:GetDescendants() do
		if script:IsA("Script") or script:IsA("ModuleScript") or script:IsA("LocalScript") then
			local Source = script.Source
			for old,new in newIDList do
				Source = string.gsub(Source, old, new)
			end
			game:GetService("ChangeHistoryService"):SetWaypoint("BeforeScriptUpdate")
			script.Source = Source
		end
	end
	return
end

for oldID,newID in newIDList do
	for _,v in game:GetDescendants() do
		if v:IsA("Animation") and string.find(v.AnimationId, tonumber(oldID)) then
			v.AnimationId = "rbxassetid://"..tostring(newID)
		end
	end
end