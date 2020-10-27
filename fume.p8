pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
	init_s()
end

function _update60()
	update_s()
end

function _draw()
	cls()
 draw_s()
end

function make_s(x,y,init_t)
	local s = {}
	s.x=x
	s.y=y
	s.width = init_t
	s.width_final = init_t + rnd(3)+1
	s.t=0
	s.max_t = 15+rnd(10)
	s.dx = 1-rnd(2)
	s.dy = 1-rnd(2)
	s.ddy = .02
	add(smoke,s)
	return s
end

function init_s()
	smoke = {}
	cursorx = 50
	cursory = 50
	color = 7
end

function draw_s()
  for i=1,#smoke do
	   if (smoke[i]!=nil) circfill(smoke[i].x, smoke[i].y,smoke[i].width, rnd({7,12}))
  end
 --foreach(smoke, draw_s)
end
function move_s(sp)
	if (sp.t > sp.max_t) then
	del(smoke,sp)
	end
	if (sp.t < sp.max_t) then
	sp.width +=1
	sp.width = min(sp.width,sp.width_final)
	end
	sp.x = sp.x + sp.dx
	sp.y = sp.y + sp.dy
	sp.dy= sp.dy+ sp.ddy
	sp.t = sp.t + 1
end

function update_s ()
	for i=1,#smoke do
		if (smoke[i]!=nil) move_s(smoke[i])
	end
	if btn(0,0) then cursorx-=1 end
	if btn(1,0) then cursorx+=1 end
	if btn(2,0) then cursory-=1 end
	if btn(3,0) then cursory+=1 end
	if btn(4,0) then color = flr(rand(16)) end
	make_s(cursorx,cursory,1-rnd(2),color)
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
