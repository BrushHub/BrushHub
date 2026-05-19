local KEY_FILE = "BrushHub/key.txt"
local SERVICE  = 2499
local SECRET   = "b64ce9c9-12e7-4992-a9e1-fa1202a366d3"
local fReq     = syn_request or request or http_request
local fHwid    = gethwid or function() return tostring(game.Players.LocalPlayer.UserId) end

local function sha256(msg)
	local a = 2^32; local b = a - 1
	local function bxor(x,y) local r,g=0,1 while x~=0 or y~=0 do r=r+(x%2~=y%2 and g or 0) x=math.floor(x/2) y=math.floor(y/2) g=g*2 end return r end
	local function band(x,y) local r,g=0,1 while x~=0 and y~=0 do r=r+(x%2==1 and y%2==1 and g or 0) x=math.floor(x/2) y=math.floor(y/2) g=g*2 end return r end
	local function bnot(x) return b-x end
	local function rshift(x,n) return math.floor(x%a/2^n) end
	local function lshift(x,n) return x*2^n%a end
	local function rotr(x,n) x=x%a n=n%32 return rshift(x,n)+lshift(band(x,2^n-1),32-n) end
	local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
	local function num2bytes(n,l) local r="" for _=1,l do r=string.char(n%256)..r n=math.floor(n/256) end return r end
	local function bytes2num(s,i) local n=0 for j=i,i+3 do n=n*256+s:byte(j) end return n end
	local len=#msg
	local pad=64-(len+9)%64
	msg=msg.."\128"..("\0"):rep(pad)..num2bytes(len*8,8)
	local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
	for i=1,#msg,64 do
		local W={}
		for j=1,16 do W[j]=bytes2num(msg,i+(j-1)*4) end
		for j=17,64 do
			local s0=bxor(rotr(W[j-15],7),bxor(rotr(W[j-15],18),rshift(W[j-15],3)))
			local s1=bxor(rotr(W[j-2],17),bxor(rotr(W[j-2],19),rshift(W[j-2],10)))
			W[j]=(W[j-16]+s0+W[j-7]+s1)%a
		end
		local h1,h2,h3,h4,h5,h6,h7,h8=H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
		for j=1,64 do
			local S1=bxor(rotr(h5,6),bxor(rotr(h5,11),rotr(h5,25)))
			local ch=bxor(band(h5,h6),band(bnot(h5),h7))
			local t1=(h8+S1+ch+K[j]+W[j])%a
			local S0=bxor(rotr(h1,2),bxor(rotr(h1,13),rotr(h1,22)))
			local maj=bxor(band(h1,h2),bxor(band(h1,h3),band(h2,h3)))
			local t2=(S0+maj)%a
			h8=h7;h7=h6;h6=h5;h5=(h4+t1)%a;h4=h3;h3=h2;h2=h1;h1=(t1+t2)%a
		end
		H[1]=(H[1]+h1)%a;H[2]=(H[2]+h2)%a;H[3]=(H[3]+h3)%a;H[4]=(H[4]+h4)%a
		H[5]=(H[5]+h5)%a;H[6]=(H[6]+h6)%a;H[7]=(H[7]+h7)%a;H[8]=(H[8]+h8)%a
	end
	local result=""
	for _,v in ipairs(H) do result=result..num2bytes(v,4) end
	return result:gsub(".",function(c) return string.format("%02x",c:byte()) end)
end

local function jsonDecode(s)
	local pos=1
	local function skip() while s:sub(pos,pos):match("%s") do pos=pos+1 end end
	local decode
	local function decodeStr()
		pos=pos+1 local r=""
		while pos<=#s do
			local c=s:sub(pos,pos)
			if c=='"' then pos=pos+1 return r
			elseif c=="\\" then
				pos=pos+1 local e=s:sub(pos,pos)
				local em={['"']='"',["\\"]="\\",["/"]=  "/",["n"]="\n",["r"]="\r",["t"]="\t",["b"]="\b",["f"]="\f"}
				if e=="u" then local h=tonumber(s:sub(pos+1,pos+4),16) r=r..utf8.char(h) pos=pos+5
				else r=r..(em[e] or e) pos=pos+1 end
			else r=r..c pos=pos+1 end
		end
	end
	local function decodeNum() local i=pos while s:sub(pos,pos):match("[%d%.%-%+eE]") do pos=pos+1 end return tonumber(s:sub(i,pos-1)) end
	local function decodeArr()
		pos=pos+1 local r={} skip()
		while s:sub(pos,pos)~="]" do r[#r+1]=decode() skip() if s:sub(pos,pos)=="," then pos=pos+1 skip() end end
		pos=pos+1 return r
	end
	local function decodeObj()
		pos=pos+1 local r={} skip()
		while s:sub(pos,pos)~="}" do
			local k=decodeStr() skip() pos=pos+1 skip()
			r[k]=decode() skip()
			if s:sub(pos,pos)=="," then pos=pos+1 skip() end
		end
		pos=pos+1 return r
	end
	decode=function()
		skip() local c=s:sub(pos,pos)
		if c=='"' then return decodeStr()
		elseif c=="[" then return decodeArr()
		elseif c=="{" then return decodeObj()
		elseif c=="t" then pos=pos+4 return true
		elseif c=="f" then pos=pos+5 return false
		elseif c=="n" then pos=pos+4 return nil
		else return decodeNum() end
	end
	return decode()
end

local function nonce()
	local s="" for _=1,16 do s=s..string.char(math.floor(math.random()*(122-97+1))+97) end return s
end

local function cleanKey(raw)
	if not raw then return nil end
	local k = raw:gsub("^KEY:FREE_",""):gsub("^KEY:",""):gsub("%.key$",""):gsub("%.Key$",""):match("^%s*(.-)%s*$")
	return (k ~= "") and k or nil
end

local function loadKey()
	if not isfolder("BrushHub") or not isfile(KEY_FILE) then return nil end
	return cleanKey(readfile(KEY_FILE))
end

local host = "https://api.platoboost.com"
pcall(function()
	local r = fReq({ Url = host .. "/public/connectivity", Method = "GET" })
	if r.StatusCode ~= 200 and r.StatusCode ~= 429 then
		host = "https://api.platoboost.net"
	end
end)

local function validateKey(key)
	local k = cleanKey(key)
	if not k then return false end
	local nc  = nonce()
	local url = host .. "/public/whitelist/" .. tostring(SERVICE)
	            .. "?identifier=" .. sha256(fHwid())
	            .. "&key=" .. k
	            .. "&nonce=" .. nc
	local ok, r = pcall(fReq, { Url = url, Method = "GET" })
	if not ok or r.StatusCode ~= 200 then return false end
	local d = jsonDecode(r.Body)
	if d and d.success and d.data and d.data.valid then
		return d.data.hash == sha256("true-" .. nc .. "-" .. SECRET)
	end
	return false
end

local savedKey = loadKey()
if not savedKey or not validateKey(savedKey) then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "Brush Hub",
		Text  = "Run Brush Hub first to validate your key!",
		Duration = 5
	})
	loadstring(game:HttpGet("https://raw.githubusercontent.com/BrushHub/BrushHub/refs/heads/main/Scripts/Brush%20Hub.lua"))()
	return
end

local Games = loadstring(
	game:HttpGet("https://raw.githubusercontent.com/BrushHub/BrushHub/refs/heads/main/Scripts/Loaders/GameList.lua")
)()

local URL = Games[game.GameId]
if not URL or URL == "0" then return end

loadstring(game:HttpGet(URL))()
