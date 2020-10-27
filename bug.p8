pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

function _init	()
	temps=0
	a=0	
end

function _update60()
	
end

function _draw()
	cls()
	rectfill(32,32,96,96,8)
	
	if (btnp(❎)) then		
		temps=10
		a=100
	end
	if btnp(🅾️) then
		temps=20
		a=300
	end
	bug(temps,a)
end

function bug(t,int)
	if t>0 then
		temps-=1
		sfx(0)
		camera(16-rnd(32),16-rnd(32))
		for i=0,int do
		poke4(0x6000+rnd(32732-24576),rnd(0xffff))
		poke4(0x6000+rnd(32732-24576),rnd(0xffff))
		--poke(0x6011,rnd(15))
		--poke(0x6100,rnd(15))
		end
	end
end



__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002b6502b6502b6502b6502b6502b6502b6502b650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
