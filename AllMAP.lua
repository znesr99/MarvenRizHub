getgenv().Map = {
	["Rock Fruit"] = {
		ID = 119091355492870,
		HTTP = "https://raw.githubusercontent.com/znesr99/MarvenRizHub/refs/heads/main/Rock_Fruit.lua"
	},
}

for _, v in pairs(getgenv().Map) do
    if game.PlaceId == v.ID then
        loadstring(game:HttpGet(v.HTTP))()
        break
    end
end
