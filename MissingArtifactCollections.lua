-- All missing artifact collections that are not part of the Rift Discovery file

-- Contributed by Adelea
local MISSING_ARTIFACTS = {
--------------------------------------------------------------------------------
-- UNSTABLE ARTIFACTS
	["Unstable: Sourcewell Ejecta"] = {
		["I019C4BACB3A99082,3BD9AAD89672380D,,,,,,"] = true,
		["I019C4BADCA6C9F06,8B46D9E7D24CC282,,,,,,"] = true,
		["I019C4BAE8FFE7D82,1F73D8BC464A7D83,,,,,,"] = true,
		["I3149F5DEA74D642F,41BB7712E1AB4889,,,,,,"] = true,
		["I3149F5DFA01D845E,F08EF4A51C7EF0CA,,,,,,"] = true,
		["I3149F5E0ACC9E44D,19420F4569A406A5,,,,,,"] = true,
		["I37B9DDAA22DBDB34,2CB1939069E8745D,,,,,,"] = true,
		["I37B9DDAB72382E46,5B981B0F707BEF72,,,,,,"] = true,
		["I37B9DDAC3462B14D,3CF3E9AD1B525D83,,,,,,"] = true,
		["I37B9DDAD621F462E,54D7ABDA242A2C05,,,,,,"] = true,
		["I37B9DDAE800F29F3,E6DA02F02F86F32E,,,,,,"] = true,
		["I4B0862CA9A32CA48,50FD7EE0119FCF59,,,,,,"] = true,
		["I4B0862CB513577AD,53490A26AC03D518,,,,,,"] = true,
		["I4B0862CC29FC1FE1,654B613BB7609C41,,,,,,"] = true
	},
	["Unstable: Sourcewell Ejecta "] = {
		["I1AC2ECFD6EB5FFDF,3A87056B1FBEE7B9,,,,,,"] = true,
		["I1AC2ECFE6A2730B7,F705A8F926BC58F1,,,,,,"] = true,
		["I1AC2ECFF305794B2,4660516916D609F7,,,,,,"] = true,
		["I1AC2ED0082B98A75,0A2DBD026016B8BC,,,,,,"] = true,
		["I272EC9E818B44C26,34C82C48AABA9698,,,,,,"] = true,
		["I272EC9E9CD355A5E,C6CA835E3617E110,,,,,,"] = true,
		["I272EC9EADFCEE96F,D68F28C70D1257A1,,,,,,"] = true,
		["I5C037FE750103703,C0742587E6F57C77,,,,,,"] = true,
		["I5C037FE87627ADA2,25D78542C5495622,,,,,,"] = true,
		["I5C037FE9A29C6183,D986523A7253167C,,,,,,"] = true,
		["I5C037FEA869CA4C1,C79E81C127A1172B,,,,,,"] = true,
		["I5C037FEB7C8E5AAD,FA9C11982C93FB47,,,,,,"] = true,
		["I5C037FEC76AAFC4C,257B8B47FFAA0AC2,,,,,,"] = true,
		["I671B9A9A4D55FBE4,9C84416DA98710B6,,,,,,"] = true,
		["I671B9A9BE3766271,AB97A9B6586AAB0A,,,,,,"] = true,
		["I671B9A9C86435BCF,9C9EC8096A315540,,,,,,"] = true,
		["I671B9A9D8318E24A,DD7D44D556F8D730,,,,,,"] = true,
		["I671B9A9E4E1E1DAF,EF7F9BEA62559E59,,,,,,"] = true
	},
}

for k, v in pairs(MISSING_ARTIFACTS) do
	--[[
	-- Dupe checking
	if not INDY_ArtifactCollections[k] then
		print(k)
		INDY_ArtifactCollections[k] = v
	end
	--]]
	INDY_ArtifactCollections[k] = v
end