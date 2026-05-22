local GAMELIST_URL = "https://raw.githubusercontent.com/BrushHub/BrushHub/refs/heads/main/Scripts/Loaders/GameList.lua"

local currentPlaceId = game.PlaceId

local function fetchScript(url)
	local success, result = pcall(function()
		return game:HttpGet(url)
	end)
	if success and result then
		return result
	end
	return nil
end

local function execScript(code)
	local fn = loadstring(code)
	if fn then
		pcall(fn)
	end
end

local gameListCode = fetchScript(GAMELIST_URL)
if not gameListCode then return end

local gameListFn = loadstring(gameListCode)
if not gameListFn then return end

local ok, Games = pcall(gameListFn)
if not ok or type(Games) ~= "table" then return end

local scriptUrl = Games[currentPlaceId]
if not scriptUrl then return end

local gameScript = fetchScript(scriptUrl)
if not gameScript then return end

execScript(gameScript)
