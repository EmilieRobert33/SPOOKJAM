pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
--variables for p and obj
function _init()
	p = {}
 -----------------
 --gestion de la vie
 ------------------
 p.mort=false
 p.life="♥♥♥♥"
 ------------------
 ------------------
	p.sp = 32
	p.x = 64
	p.y = 40
	p.dx = 0
	p.dy = 0
	p.w = 8
	p.h = 16
	p.flp = false
	p.max_dx = 2
	p.max_dy = 3
	p.acc = 0.5
	p.boost = 4
	p.mask = 0
	p.anim = 0
	p.running = false
	p.jumping = false
	p.falling = false
	p.sliding = false
	p.landed = false
	p.cp = false
	
	
	
	--objet mask
	mask = {}
	mask.x = 32*8
	mask.y = 11*8
	mask.w = 16
	mask.h = 16
	mask.sp = 46
	mask.taken = false
	
	
	gravity = 0.3
	friction = 0.85
	
	--simple camera
	cam_x=0
	cam_y=0
	
	--map limit
	mapw_start=0
	mapw_end=1024
	maph_start=0
	maph_end=180
	
	--sfx
	particules = {}
	explosions = {}
	
	------------test---------
	x1r=0 y1r=0 x2r=0 y2r=0
	collide_l="no"
	collide_r="no"
	collide_u="no"
	collide_d="no"
	--------------------------
 --------------------------
 -- ici cest blink
 --------------------------
 init_f()
 --ici cest la lave 
 init_l()
 --dithering
    dither={0b0000000000000000,
         0b1000000000000000,
   0b1000000000100000,
   0b1000000010100000,
   0b1010000010100000,
   0b1010010010100000,
   0b1010010010100001,
   0b1010010010100101,
   0b1010010110100101,
   0b1010011110100101,
   0b1010011110100111,
   0b1010011110101111,
   0b1010111110101111,
   0b1110111110101111,
   0b1110111110111111,
   0b1110111111111111,
   0b1111111111111111}
	
end



-->8
--update and draw

function _draw()
	cls()
 draw_fond()
	map(0,0)
	if p.dx<0 then
		spr(p.sp,p.x-8,p.y,2,2,p.flp)
	else
		spr(p.sp,p.x,p.y,2,2,p.flp)
	end
	--mask 2
	spr(mask.sp,mask.x,mask.y,2,2)
	
	--sfx 
	draw_explosions()
	draw_particules()
	--------------------------
 --draw pour les fantomes
 --------------------------
 dr_fant()
	----------test----------
	rect(x1r,y1r,x2r,y2r,7)
	--print("⬅️ "..collide_l,p.x,p.y-10)
	--print("➡️ "..collide_r,p.x,p.y-18)
--	print("⬆️ "..collide_u,p.x,p.y-26)
	--print("⬇️ "..collide_d,p.x,p.y-34)
	--print(p.sliding,p.x,p.y-34,8)
	--print(p.running,p.x,p.y-28,9)
	print(p.cp,p.x,p.y-20,10)
	print("p.sp "..p.sp,p.x,p.y-45,7)
 print("p.dx "..p.dx,p.x,p.y-51,7)
 
 ------------------------------
 -- dessine la vie
 ------------------------------
 draw_life() 
 -------------------------------
 --dessine la lave
 -------------------------------
 draw_lave()
end

function _update()
	player_update()
	player_animate()
 update_f()
	camera_update()
 ---------------
 --ici c'est la lave
 -------------------	
 up_lave()
end

--camera follow player
function camera_update()
	cam_x= p.x-64+(p.w/2)
	cam_y= p.y-64+(p.h/2)
	if (cam_x<mapw_start) then
		cam_x= mapw_start
	end
	if(cam_x>mapw_end-128) then
		cam_x=mapw_end-128
	end
	camera(cam_x,cam_y)
end


-->8
--collisions

function collide_map(obj,aim,flag)
	--obj = table needsx,y,w,h
	--aim = left,right,up,down
	local x=obj.x  local y=obj.y
	local w=obj.w  local h=obj.h
	
	if aim=="left" then
		x1=x+3  y1=y
		x2=x+10    y2=y+h-1
	
	elseif aim=="right" then
		x1=x+w+2  y1=y
		x2=x+w+6    y2=y+h-1
		
	elseif aim=="up" then
		x1=x    y1=y-1
		x2=x+w  y2=y
	
	elseif aim=="down" then
		x1=x    y1=y+h
		x2=x+w  y2=y+h
	
	end
	
	-------test--------
	x1r=x1   y1r=y1
	x2r=x2   y2r=y2
	---------------------
	
	--pixels to tiles
	x1/=8   y1/=8
	x2/=8   y2/=8
	
	--check tile
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
		return true
	else 
		return false
	end
	
end

--collision mask

function collide_with(obj,flag)
	local x=obj.x  local y=obj.y
	local w=obj.w  local h=obj.h
	
	x1=x+2    y1=y-1
	x2=x+w-3  y2=y+h
	--pixels to tiles
	x1/=8   y1/=8
	x2/=8   y2/=8
	
	--check tile
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
		return true
	else 
		return false
	end
end

--collision between ojbect
function get_box(a)
	local box = {}
	box.x1= a.x+2
	box.y1= a.y-1
	box.x2= a.x+a.w-1
	box.y2= a.y+a.h/3
	return box
end

function check_coll(a,b)
	local box_a = get_box(a)
	local box_b = get_box(b)
	
	if(box_a.x1>box_b.x2
	or box_a.y1> box_b.y2
	or box_b.x1> box_a.x2
	or box_b.y1> box_a.y2) then
		return false
	end
	return true
end
-->8
--player functions

function player_update()
	--physics
	p.dy += gravity
	p.dx *= friction
	
	--controls
	if (btn(0)) then 
		p.dx-=p.acc
		p.running=true
		p.flp=true
	end
	if btn(1) then
		p.dx+=p.acc
		p.running=true
		p.flp=false
	end
	
	--jumping
	if(btnp(🅾️))
	and p.landed then
		p.dy-=p.boost
		p.landed = false
	end
 -------test por declenche fantome depuis tiles----
 --if (btnp(5)) detect_fait_fantome()
	
	--if player collides with a mask
	check_collision_m()
	
	--if player has mask 2
	if (p.mask == 2) then
		p.boost = 6
	end
	
	--mettre/enlever mask
	player_mask()
	
	--slide
	player_slide()
	
		
	--check collisions up and down
	check_collision_ud()
	
	--check collisions left and right
	check_collision_rl()
		
	--if player collide with lava
	if(collide_with(p,3)) p.mort=true
	
	--if player collides with cp save
	if(collide_with(p,4)) then
		p.cp=true
		local cp ={}
		cp.x = p.x
		cp.y = p.y
		cp.mask = p.mask
		cp.life = p.life
	end
	p.x += p.dx
	p.y += p.dy
	
	--limit player to the map
	limit_map()
end

function player_animate()
	if p.jumping then
		p.sp = 7
	elseif p.falling then
		p.sp = 38
	elseif p.sliding then
		p.sp = 44
	elseif p.running then
		if time()-p.anim>.1 then
			p.anim=time()
			p.sp+=2
			if p.sp>7 then
				p.sp=1
			end
		end
	else -- player idle
		if time()-p.anim>.5 then
			p.anim=time()
			p.sp+=2
			if p.sp>36 then
				p.sp=32
			end
		end
	end
end

function limit_speed(num,maximum)
	return mid(-maximum,num,maximum)
end

function player_mask()
	if(mask.taken == true) then
		if(p.mask == 0) then
			if(btnp(❎)) then
			 p.mask = 1
			end
		elseif(p.mask == 1) then
		 p.dx = 0
			p.dy = 0
			if(btnp(❎)) p.mask = 0
		end
	end
end

function check_collision_m()
	if(check_coll(p,mask)
	and mask.taken == false) then
		make_explosions(mask.x,mask.y,15)
		make_particules(16)
		mask.sp = 100
		mask.taken = true
	end
end

function check_collision_ud()
	if(p.dy>0) then
		p.falling=true
		p.landed=false
		p.jumping=false
		
		p.dy=limit_speed(p.dy,p.max_dy)
		
		if(collide_map(p,"down",0)) then
			p.landed= true
			p.falling= false
			p.dy=0
			p.y-=((p.y+p.h+1)%8)-1
			
			-----test-----------
			collide_d = "yes"
			else collide_d="no"
			--------------------
			
		end
	elseif (p.dy<0) then
		p.jumping=true
		if collide_map(p,"up",1) then
			p.dy=0
			
			-----test-----------
			collide_u = "yes"
			else collide_u="no"
			--------------------
		
		end
	end
end-----fin check col ud

function check_collision_rl()
	if (p.dx<0) then
	
	p.dy=limit_speed(p.dy,p.max_dy)
		if(collide_map(p,"left",0)) then
			p.dx=0
		-----test-----------
		collide_l = "yes"
		else collide_l="no"
		--------------------
			
		end
	elseif (p.dx>0) then
	
	p.dy=limit_speed(p.dy,p.max_dy)
		if(collide_map(p,"right",0)) then
			p.dx=0
		-----test-----------
		collide_r = "yes"
		else collide_r="no"
		--------------------
		end
	end
end

function limit_map()
	if (p.x<mapw_start) then
		p.x=mapw_start
	end
	if(p.x>mapw_end-p.w) then
		p.x=mapw_end-p.w
	end
end

function player_slide()
	if p.running 
	and not (btn(1))
	and not (btn(0))
	and not p.falling
	and not p.jumping 
	 then
			p.running = false
			p.sliding = true	
	end
	
	--stop sliding with wall
	if(p.sliding) then
		if abs(p.dx)==.2
		or p.running 
		 then
			p.dx=0
			p.sliding=false
	--stop sliding with mask
		elseif(p.running 
		and btnp(❎)) then
			p.dx=0
			p.sliding=false	
		end
	end
	
end

---test----
-->8
--sfx

--explosion
function make_explosions(x,y,nb)
	while(nb > 0) do
		explo = {}
		explo.x = x+(rnd(2)-1)*10
		explo.y = y+(rnd(2)-1)*10
		explo.r = 4 + rnd(4)
		explo.c = 10
		add(explosions, explo)
		sfx(0)
		nb -= 1
	end
end

function draw_explosions()
	for e in all(explosions) do
		circfill(e.x,e.y,e.r,e.c)
		e.r -=1
		if(e.r <=4) e.c = 9
		if(e.r <=2) e.c = 8
		if (e.r <= 0) del(explosions,e)
	end
end

--particules

function make_particules(nb)
	while (nb > 0) do
		part = {}
		part.x = explo.x +4
		part.y = explo.y +4
		part.col = flr(rnd(16))
		part.dx = (rnd(2)-1)*3
		part.dy = (rnd(2)-1)*3
		part.f = 0
		part.fmax = 30*2
		add(particules,part)
		nb -= 1
	end
end

function draw_particules()
	for part in all(particules) do
		pset(part.x, part.y, part.col)
		part.x += part.dx
		part.y += part.dy
		part.f += 1
		if (part.f > part.fmax or
						part.x < 0 or part.x >= 128 or
						part.y < 0 or part.y >= 128) then
			del(particules, part)
		end
	end
end

--screenshake

---------------------------------
-- bordel de blink pour les fantomes
--------------------------------------
function init_f()
 init_s()

 --mask=0
 fants={}
 timer_f=40
 fants_f=10
 f_f=0
 init_bug()
end

function update_f()
 detect_fait_fantome()
 -- if (p.mask==1) then
 --  p.mask=0
 -- else
  -- p.mask=1
 -- end
 up_f()
 if bug_p>0 then
  temps=20*bug_p
  a=800*bug_p
  bug_p=0
 end
end
function make_f(x,y)
 local f={}
 f.x=x
 f.y=y
 add(fants,f)
end

function draw_f()
 if (p.mask==1) then
  for i=1,#fants do
   if (fants[i].x<p.x) then
    spr(fants_f,fants[i].x,fants[i].y,2,2,0)
   else
    spr(fants_f,fants[i].x,fants[i].y,2,2,1)
   end
  end
 else
  for i=1,#fants do
   circfill(fants[i].x,fants[i].y,3,8)
  end
 end
 draw_s()
end

function up_f()
-----------------------------------------------------
--animation des fantomes
-----------------------------------------------------
f_f+=1
if (f_f>20) then
 f_f=0
 fants_f+=2
end

if (fants_f>14) fants_f=10
-----------------------------------------------------
-- on bouge les fantomes
-----------------------------------------------------
 if p.mask==0 then --sans port du masque on s'approche
  timer_f=40
  for i=1,#fants do
   if (p.x>=fants[i].x) fants[i].x+=0.15
   if (p.x<=fants[i].x) fants[i].x-=0.15
   if (p.y<=fants[i].y) fants[i].y-=0.15
   if (p.y>=fants[i].y) fants[i].y+=0.15
  end
 elseif p.mask==1 then
  if timer_f<0 then --avec port du mask on go
   for i=1,#fants do
    if (p.x>=fants[i].x) fants[i].x-=0.15
    if (p.x<=fants[i].x) fants[i].x+=0.15
    if (p.y<=fants[i].y) fants[i].y-=0.15
    if (p.y>=fants[i].y) fants[i].y+=0.15
   end
   else 
    timer_f-=1
    for i=1,#fants do
     make_s(fants[i].x+8,fants[i].y+8,1-rnd(2),color)
     fants[i].x+=0.005*cos(3*t())
     fants[i].y+=-0.005*sin(3*t())    
    end
   end
   update_s()  
 end
-------------------------------------------------------
-- on declenche le bug
-------------------------------------------------------
 if (temps==0) sfx(30)
 for i=1,#fants do
  if (p.mask!=1 and bug_p==0 and temps<=-20)then
 -- sfx(30,1)
   if (abs(p.x-fants[i].x)< 90 and temps<=0) bug_p+=1
   if (abs(p.x-fants[i].x)< 50 and temps<=0) bug_p+=1
   if (abs(p.x-fants[i].x)< 30 and temps<=0) bug_p+=1
  end
 end 
end

function bug(t,int)
 temps-=1
 if t>0 then
  --sfx(0,1)
  --camera(16-rnd(18),16-rnd(18))
  for i=0,int do
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  poke4(0x6000+rnd(32732-24576),rnd(0xffff))
  --poke(0x6011,rnd(15))
  --poke(0x6100,rnd(15))
  end
 end
end

function init_bug()
 bug_p=0
 temps=-5
 a=0
 bug_f=0
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
 --foreach(smoke, draw_s) gg
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
end

function detect_fait_fantome()
 if btn(🅾️) then
  for x=0,64 do
   for y=0,64 do 
   if (fget(mget(x,y),7)) then
    mset(x,y,0)
    make_f(x*8,y*8)
   end
  end
 end
 end
end

function dr_fant()
 draw_f()
 bug(a,temps)
end
--------------------------------
--gestion de la vie
---------------------------------
function g_vie() --gagne un coeur
  p.life=p.life.."♥"
end

function p_vie() --perte d'un coeur
  p.life=sub(p.life,1,#p.life-1)
  if (#p.life<=0) p.mort=true
end

function draw_life()
  print(p.life,cam_x,cam_y,8)
end
-----------------------------------
-- on fait la lave
-----------------------------------
function init_l()
 lave={}
 cendre={}
 lave_pal={7,8,9,10}
 faire_tile_lave()
end
function faire_tile_lave()
 for x=0,64 do
  for y=0,64 do
   if fget(mget(x,y),6) then
    make_lave(x*8,y*8)
    mset(x,y,0) 
   end
  end
 end
end
function make_cendre(x,y)
 local c={}
 c.yfix=y
 c.x=x
 c.y=y
 c.dx=rnd(6)-3
 c.dy=-rnd(2)
 add(cendre,c) 
end

function update_cendre()
 for i=1,#cendre do
  if cendre[i]!=nil then
   cendre[i].x+=cendre[i].dx
   cendre[i].y+=cendre[i].dy
   cendre[i].dy+=1
   if (cendre[i].y>cendre[i].yfix) del(cendre,cendre[i])
  end
 end
end
function draw_cendre()
 for i=1,#cendre do
  if cendre[i]!=nil then
   pset (cendre[i].x,cendre[i].y,rnd(lave_pal))
  end
 end
end
function make_lave(x,y)
 local l={}
 l.x=x
 l.y=y
 add(lave,l)
end
function up_lave()
 if t()%0.5 then
  for i=1,#lave do
   make_cendre(lave[i].x+2,lave[i].y)
   make_cendre(lave[i].x+4,lave[i].y)  
   make_cendre(lave[i].x+6,lave[i].y)  
  end
 end
 update_cendre()
end
function draw_lave()
 for n=1,#lave do 
  for i=0,7 do
   for y=0,7 do
    pset(lave[n].x+i,lave[n].y+y,rnd(lave_pal))
   end
  end
 end
 draw_cendre()
end

-----test por le fond --------
function draw_fond()
 rectfill(0,0,128*8,64,0)
 rectfill(0,64,128*8,128,1)
 rectfill(0,100,128*8,228,2)
 for i=1,#dither do
  fillp(dither[#dither-i])
  pal(0,0)
  rectfill(0,4*i,128*8,4*i+8,1)
  pal(0,1)
  rectfill(0,50+4*i,128*8,50+4*i+8,2)
  pal()
  fillp()
 end
end
__gfx__
0000000000444444000000000044444400000000000000000000000000000000000000009999999900000ccccc00000000000000000000000000000000000000
000000000444444440000000044444444000000000444444000000000004444000000000999999990000c77777c0000000000ccccc00000000000ccccc000000
007007000444aaaa400000000444aaaa400000000444444440000000004444444000000099999999000c7777777c00000000c77777c000000000c77777c00000
0007700004490aa04000000004490aa040000000044444444000000004444444400000009999999900c777777777c00000c777777777c00000c777777777c000
000770000449aaaa000000000449aaaa0000000004440aa04000000004440aa040000000999999990c77cc77cc777c000c77cc77cc777c000c77cc77cc777c00
007007004449aaaa000000004449aaaa000000000449aaaa000000000449aaaa00000000999999990c77cc77cc777c000c77cc77cc777c000c77cc77cc777c00
000000004449a8aa000000004449a8aa000000004449aaaa000000004449aaaa00000000999999990c7ccc77ccc77c000c7ccc77ccc77c000c7ccc77ccc77c00
00000000044eeeee00000000044eeeee000000004449a8aa000000004449a8aa00000000999999990c7cc7777cc77c000c7cc7777cc77c000c7cc7777cc77c00
8888888800eeeeee0000000000eeeeee00000000044ee8ee00000000444ee8ee00000000000000000c77777777777c000c77777777777c00c7777777777cccc0
88888888a0eeeeee0a000000a0eeeeee0a0000000aeeeeeea000000000aeeeee00000000000000000c77778877cc7c00cc77778877c77c007777788887cc77c0
8888888890eeeeee0900000090eeeeee0900000009eeeeee90000000009eeeee0000000000000000c7c777887c777c0077c77888877c7c00ccc77788777777c0
8888888800444a440000000000444a440000000000eeeeee0000000000eeeeee0000000000000000c7c777777c7c7c00ccc7777777777c0000c77777777ccc00
8888888800cccccc0000000000cccccc0000000000444a440000000000444a4400000000000000000c0c77777cc777c0000c7777777777c0000c7777777777c0
8888888800cc000c000000000acc000c0000000000cc000c0000000000cc000c00000000000000000000cc777777777c0000cc777777777c0000cc777777777c
888888880ac0000c00000000000000c00000000000c00acc0000000000c000ac0000000000000000000000ccc77777c0000000ccc77777c0000000cc777777c0
888888880000000a00000000000000a00000000000a00000000000000a0000000000000000000000000000000ccccc00000000000ccccc0000000000cccccc00
000000000000000000444444000000000044444400000000004444440000000000000000000000000004444440000000000444444000000000000a99a9900000
004444440000000004444444400000000444444440000000044444444000000000444444000000000044444444000000004444444400000000099a9999999000
04444444400000000444aaaa400000000444aaaa400000000444aaaa40000000044444444000000000444aaaa400000000444aaaa40000000099a99999a99900
0444aaaa4000000004490aa00000000004490aa00000000004490aa0400000000444aaaa40000000004490aa04000000004490aa04000000099a999999a99990
04490aa0400000000449aaaa000000000449aaaa000000000449aaaa0000000004490aa04000000000449aaaa000000000449aaaa00000000998999999989990
0449aaaa000000004449aaaa000000004449aaaa000000004449aaaa000000000449aaaa0000000004449aaaa000000004449aaaa0000000999a89999989a999
4449aaaa000000004449aaaa000000004449aaaa000000004449a8aa000000004449aaaa0000000004449a8aa000000004449a8aa00000009999889998899999
4449aaaa00000000044eeeee00000000044eeeee00000000a44eeeee0a0000004449a8aa000000000044ee8e000000000044ee8e00000000999a88898889a999
044eeeee0000000000eeeeee0000000000eeeeee0000000090eeeeee09000000044eeeee0000000000eeeeee00000000a0eeeeee0a0000009999999999999999
00eeeeee00000000a0eeeeee0a00000000eeeeee0000000000eeeeee00000000a0eeeeee0a000000a0eeeeee0a00000090eeeeee09000000999999999999a999
a0eeeeee0a00000090eeeeee09000000a0eeeeee0a00000000eeeeee0000000090eeeeee0900000090eeeeee0900000000eeeeee00000000499a999999999999
90eeeeee0900000000444a440000000090444a440900000000444a440000000000eeeeee0000000000444a440000000000444a44000000000499a989998a9990
00444a440000000000cccccc0000000000cccccc0000000000cccccc0000000000444a440000000000cccccc0000000000cccccc000000000499a89898989990
00cccccc0000000000cc000c0000000000cc000c0000000000cc000c0000000000cccccc0000000000cc000c0000000000c00000c00000000044899989a98900
00cc000c0000000000c0000c0000000000c0000c0000000000c0000c0000000000cc000c000000000c000000c00000000c0000000c00000000044a999a999000
00a0000a0000000000a0000a0000000000a0000a0000000000a0000a0000000000a0000a000000000a000000a0000000a00000000a0000000000049a99900000
1dddddd14444444465556666445d4444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd11d11444444446000000655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd1111114444444460000006444445d4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d11111444444446000000655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1111114444444465556666445d4444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111444444446000000655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0111111044444444600000065d4445d4000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111000444444446000000655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1dddddd1bbbbbbbb1dddddd100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ddd11d11bbbbbbbbddd11d1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dd111111bbbbbbbbdd11111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d11111bbbbbbbbd1d1111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d111111bbbbbbbb1d11111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111bbbbbbbb1111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01111110bbbbbbbb0111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111000bbbbbbbb0011100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88808888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80008008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80008008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80008888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
80008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000004000000000000080000000000000000000000000000000000000000000000000000000000004840000000000000000000000000000040401010000010000000000000000000000030309000000000000000000000000001004000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000047000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000040404000004040400000000050004040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000050090909090950505050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000004040400000000000000000000000000050505050505050000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000050090950000000404040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040404040400000000040404040400909090940400000000000000000000000000000000000000000000000000050504040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000405252525240004040400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004040404000000000000000000000000000000000404000000000000000000000100000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000100000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000404040404040404000000000004040404040400000000000000000000000000000004000000000000000000000000000505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004040400000000000000000000000000000000040404040404040404040400000004040400000005050505050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000040404000000040000000000000000000400000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4040090909404000000000000000000000000000000000000000000000000000000000000040000000000000000000400000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004040404040404040404040405151514040404040404040404040404040404040000000000000000000400000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000515151515151515151515151515151510000000000000000000000404040400000004040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400909094000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b00001515317153191531c153231532d1532615322153201531f1531d1531c1531b1531b1531b1531c1531d1531e1532115323153271532b1532f153361531f1531d153000000000000000000000000000000
