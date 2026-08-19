getgenv().Map = {
	["Rock Fruit"] = {
		ID = 119091355492870,
		HTTP = "https://api.jnkie.com/api/v1/luascripts/public/4aba6c760b4e7d740ec5b688356eba80cca256676fdda159759cb42841bb8332/download"
	};
    ["Rock Fruit Raid"] = {
		ID = 82878101790702,
		HTTP = "https://api.jnkie.com/api/v1/luascripts/public/4aba6c760b4e7d740ec5b688356eba80cca256676fdda159759cb42841bb8332/download"
	};
	["Reign piece"] = {
		ID = 78466992256287,
		HTTP = "https://raw.githubusercontent.com/znesr99/MarvenRizHub/refs/heads/main/Reign_piece.lua"
	};
	["Legacy piece"] = {
		ID = 111097829542198,
		HTTP = "https://raw.githubusercontent.com/znesr99/MarvenRizHub/refs/heads/main/Legacy_piece.lua"
	};
}

for _, v in pairs(getgenv().Map) do
    if game.PlaceId == v.ID then
        loadstring(game:HttpGet(v.HTTP))()
        break
    end
end

