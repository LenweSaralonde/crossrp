-- This miraculous pile of miracle isn't my code.
-- I found it here: https://gist.github.com/dannysmc95/956327d65a0e47182638
-- The original work was done by Roberto Ierusalimschy (MIT License).
-- http://lua-users.org/lists/lua-l/2014-08/msg00628.html
--
-- I just optimized it to use newer bit ops and such (it runs 10x faster).
-- 

local _, Me = ...

local gsub,        format,        strbyte,     strchar,     strrep = 
      string.gsub, string.format, string.byte, string.char, string.rep
local lshift,     rshift,     bxor,     band =
      bit.lshift, bit.rshift, bit.bxor, bit.band

local k = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
	0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
	0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
	0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
	0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
	0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
	0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
	0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
	0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}
local function num2s(l, n)
	local s = ""
	for i = 1, n do
		local rem = l % 256
		s = strchar(rem) .. s
		l = (l - rem) / 256
	end
	return s
end
local function preproc(msg, len)
	local extra = 64 - ((len + 9) % 64)
	len = num2s(8 * len, 8)
	msg = msg .. "\128" .. strrep( "\0", extra ) .. len
	assert(#msg % 64 == 0)
	return msg
end
local function initH256(H)
	H[1] = 0x6a09e667
	H[2] = 0xbb67ae85
	H[3] = 0x3c6ef372
	H[4] = 0xa54ff53a
	H[5] = 0x510e527f
	H[6] = 0x9b05688c
	H[7] = 0x1f83d9ab
	H[8] = 0x5be0cd19
	return H
end
local function digestblock(msg, i, H)
	local w = {}
	for j = 0, 15 do
		local a, b, c, d = strbyte( msg, i+j*4, i+j*4+3 )
		w[1+j] = a*0x1000000 + b*0x10000 + c*0x100 + d
	end
	for j = 17, 64 do
		local v = w[j - 15]
		-- s0 = XOR( v >>> 7, v >>> 18, v >> 3 )
		local s0 = bxor( rshift(v,7) + lshift(v,25), rshift(v,18) + lshift(v,14), rshift(v,3) )
		v = w[j - 2]
		--w[j] = w[j - 16] + s0 + w[j - 7] + bxor( rrotate( v, 17 ), rrotate( v, 19 ), rshift( v, 10 ) )
		w[j] = w[j - 16] + s0 + w[j - 7] + bxor( rshift(v, 17) + lshift(v, 32-17), rshift(v,19)+lshift(v,32-19), rshift( v, 10 ) )
	end
	local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
	for i = 1, 64 do
		-- s0 = XOR( a >>> 2, a >>> 13, a >>> 22 )
		local s0 = bxor( rshift(a,2)+lshift(a,30), rshift(a,13)+lshift(a,32-13), rshift(a,22)+lshift(a,32-22) )
		local maj = bxor( band( a, b ), band( a, c ), band( b, c ))
		local t2 = s0 + maj
		-- s1 = XOR( e >>> 6, e >>> 11, e >>> 25 )
		local s1 = bxor( rshift(e,6)+lshift(e,32-6), rshift(e,11)+lshift(e,32-11), rshift(e,25)+lshift(e,32-25) )
		-- ch = XOR( e & f, ~e & g )
		local ch = bxor( band( e, f ), band( 2^32-1-e, g ))
		local t1 = h + s1 + ch + k[i] + w[i]
		h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
	end
	H[1] = ( H[1] + a ) % 2^32
	H[2] = ( H[2] + b ) % 2^32
	H[3] = ( H[3] + c ) % 2^32
	H[4] = ( H[4] + d ) % 2^32
	H[5] = ( H[5] + e ) % 2^32
	H[6] = ( H[6] + f ) % 2^32
	H[7] = ( H[7] + g ) % 2^32
	H[8] = ( H[8] + h ) % 2^32
end

function Me.Sha256Data(msg)
	msg = preproc(msg, #msg)
	local H = initH256({})
	for i = 1, #msg, 64 do digestblock(msg, i, H) end
	return H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
end                                            local Sha256Data = Me.Sha256Data

-------------------------------------------------------------------------------
-- Hashes msg and returns the sha256 as a 64-char string.
--
function Me.Sha256(msg)
	local a,b,c,d,e,f,g,h = Sha256Data( msg )
	return format( 
	       "%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x%04x",
	                                                 rshift(a, 16), a % 65536,
	                                                 rshift(b, 16), b % 65536,
	                                                 rshift(c, 16), c % 65536,
	                                                 rshift(d, 16), d % 65536,
	                                                 rshift(e, 16), e % 65536,
	                                                 rshift(f, 16), f % 65536,
	                                                 rshift(g, 16), g % 65536,
	                                                 rshift(h, 16), h % 65536 )
end
