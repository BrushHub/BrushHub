local Games = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/BrushHub/BrushHub/refs/heads/main/Scripts/Loaders/GameList.lua")
)()

local URL = Games[game.GameId]
if not URL or URL == "0" then return end

loadstring(game:HttpGet(URL))()
