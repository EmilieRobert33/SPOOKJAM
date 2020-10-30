pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
function _init()
 state="menu"
 --music(02)
 init_menu()
 init_cut()
 init_gene()
 init_jeux()
 music(02)
end

function _update()
 if state=="menu" then
  up_menu()

 elseif state=="jeux" then
  up_jeux()
 elseif state=="cut" then
  up_cut()
 elseif state=="gene" then
  up_gene()
 end
 
end

function _draw()
 if state=="menu" then
  draw_menu()
 elseif state=="jeux" then
  draw_jeux()
 elseif state=="cut" then
  draw_cut()
 elseif state=="gene" then
  draw_gene()
 end
 --paup()
 --print(t_cut,0,0,7)
 
end

-----------------------
--menu
-----------------------
function init_menu()
 init_paup()
end

function up_menu()
 if (btnp(❎) or btnp(🅾️)) then
   state="jeux"
   music(00)
 end
end

function draw_menu()
 cls()
 print("symphony of masks", 30,45,7)
 print("press x/❎/c/🅾️ to start", 20,80,7)
end


-----------------------
--cut
-----------------------
function init_cut()
 t_cut=0
end

function up_cut()
 t_cut+=1
 if (t_cut>5) oeil=true
 if (t_cut>100) state="gene"
end

function draw_cut()
 cls(1)
 ------------------------
 print("was it all just a dream?",20,30,7)
 print("game over",46,90,7)
 spr(105,64-16,48,4,2)
 if (cos(t())<0) then
  spr(97,64-16,48+16,4,2)
 else
  spr(101,64-16,48+16,4,2)
 end
 paup()
end



-----------------------
--gene
-----------------------
function init_gene()
 gene=121
end

function up_gene()
 gene-=0.5
 if (btnp(❎)) then
  state="menu"
  _init()
 end
end

function draw_gene()
 --cls(6)
  cls()
  print("thank you",30+15,gene,7)
  print("for playing",30+11,gene+10,7)
  print("game made by",30+10,gene+20,7)
  print("gascoun gaming",30+7,gene+30,7)
  print("art and music:",30+7,gene+40,7)
  print("kaioken",30+17+4,gene+50,7)
  print("code :",30+19+4,gene+60,7)
  print("ph0enix",30+17+4,gene+70,7)
  print("naw4k",30+21+4,gene+80,7)
  print("retry: x/❎",30+14,gene+90,7)
end


-----------------------
--jeux
-----------------------
--variables for p and obj
function init_jeux()
	p = {}
 p.t=t()
 -----------------
 --gestion de la vie
 ------------------
 p.infob1=false
 p.infob2=false
 p.mort=false
 p.life="♥♥♥♥"
 ------------------
 ------------------
	p.sp = 32
	p.x = 64
	p.y = 210
	p.dx = 0
	p.dy = 0
	p.w = 8
	p.h = 16
	p.flp = false
	p.max_dx = 2
	p.max_dy = 3
	p.acc = 0.5
	p.boost = 4.6
	p.jump = 0
	p.mask = 0
	p.mask2 = 0
	p.porte = 0
	p.anim = 0
	p.running = false
	p.jumping = false
	p.falling = false
	p.sliding = false
	p.landed = false
	p.cp = false
	p.score=0
	
	--objet mask
	mask = {}
	mask.x = 32*8
	mask.y = 11*8
	mask.w = 16
	mask.h = 16
	mask.sp = 68
	mask.taken = false
	
	mask_l = {}
	mask_l.choisi = 0
	
	mask2s={}
	
	mask_final={}
	mask_final.x1=51
	mask_final.y1=61
	mask_final.x2=52
	mask_final.y2=62
	
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
	torches = {}
	music(00)
	detect_fait_torch()
	make_torche(x,y)
	
	--change state
	temps_final = 0
	
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
 init_plat()
 init_f()
 init_co()
 
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

function draw_jeux()
	cls()
	
 draw_fond()
 --sfx 
 
	draw_explosions()
	draw_torches()

	draw_particules()

	map(0,0,0,0,128,128)--,0,0,64,64)
 draw_info(p.infob1,p.infob2)
	--draw player
	if p.dx<0 then
		spr(p.sp,p.x-8,p.y,2,2,p.flp)
	else
		spr(p.sp,p.x,p.y,2,2,p.flp)
	end
	
 if (p.mask==1) then
  --rectfill(p.x,p.y,p.x+15,p.y+6,0)
  spr(74,p.x+4,p.y)
 end
 --p porte mask2
 if (p.mask2==1) then
  spr(75,p.x+3,p.y)
 end
	--mask 1
	spr(mask.sp,mask.x,mask.y,2,2)
	--mask 2
	draw_mask2s()
	
	if(p.mort==true 
	and p.cp==false) then
		--restart game
			print("you are dead ",p.x,p.y-51,9)
	end
	
	--------------------------
 --draw pour les fantomes
 --------------------------
 dr_fant()
 draw_co()
	----------test----------
	draw_plat()
	--collision player
	rect(x1r,y1r,x2r,y2r,7)
	--for pl in all(plat) do
		--rectfill(pl.x,pl.y,pl.x+pl.w,pl.y+pl.h,7)		
	--end
	
	--draw mask item
	if(mask.taken == true) then
		if(mask_l.choisi == 0) then
			rectfill(cam_x,cam_y+10,cam_x+7,cam_y+17,11)
		end
		spr(74,cam_x,cam_y+10)
	end
	
	for mask2 in all(mask2s) do
		if(mask2.taken == true) then
			if(mask_l.choisi == 1) then
			rectfill(cam_x+10,cam_y+10,cam_x+17,cam_y+17,11)
			end
			spr(75,cam_x+10,cam_y+10)
		end
		--rectfill(mask2.x,mask2.y,mask2.x+mask2.w,mask2.y+mask2.h,7)
		--print("mask2 x"..mask2.x, p.x,p.y-10,7)
		--print("mask apparition",p.x,p.y-20,7)
		--print(mask2.taken,p.x,p.y-25,7)
	end
	
	--print(mask.taken,p.x,p.y-25,7)
	--print("⬅️ "..collide_l,p.x,p.y-10)
	--print("➡️ "..collide_r,p.x,p.y-18)
 --print("⬆️ "..collide_u,p.x,p.y-26)
	--print("⬇️ "..collide_d,p.x,p.y-34)
	--print(p.sliding,p.x,p.y-34,8)
	--print(p.running,p.x,p.y-28,9)
	--print("mask porte"..p.porte,p.x,p.y-20,10)
	--print("p.mask2 "..p.mask2,p.x,p.y-45,7)
 --print("temps final"..temps_final,p.x,p.y-45,7)
 
 if(p.score>0) then
 	cls()
 	temps_final+=1
 	print("your score is: "..p.score,cam_x+28,cam_y+60,7)
 	--print("temps final"..temps_final,p.x,p.y-45,7)
 	if(temps_final>=50) then
 		state = "cut"
 	end
 end
 ------------------------------
 -- dessine la vie
 ------------------------------
 draw_life() --efzef
 -------------------------------
 --dessine la lave
 -------------------------------
 draw_lave()
	
 
end

function up_jeux()
	player_update()
	player_animate()
 update_f()
	camera_update()
 up_plat()
 detect_fait_mask()
	
	--sfx
	animate_torche()
 ---------------
 --ici c'est la lave
 -------------------	
 up_lave()
 up_co()
 creve(p.mort)
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

-- collision with final mask
function collide_with_sp(obj)
	local x=obj.x  local y=obj.y
	local w=obj.w  local h=obj.h
	
	x1=x    y1=y
	x2=x+w  y2=y+h
	
	
	--pixels to tiles
	x1/=8   y1/=8
	x2/=8   y2/=8
	
	--check tile
	if mget(x1,y1)==mget(51,61)
	or mget(x1,y2)==mget(52,61)
	or mget(x2,y1)==mget(51,62)
	or mget(x2,y2)==mget(52,62) then
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
	and p.jump > 0 then
		p.dy-=p.boost
		p.landed = false
		p.jump -= 1
		sfx(31)
	end
 -------test por declenche fantome depuis tiles----
 --if (btnp(5)) detect_fait_fantome()
	
	--if player collides with a mask
	check_collision_m()
	check_collision_m2()
	--if player has mask 2
	--if (p.jump == 2) then
		--p.jump_mask = 2
	--end
	
	--p collide with final mask
	if(collide_with_sp(p)) then
		p.score=t()-p.t
		make_explosions(p.x,p.y,48)
		sfx(30)
	end
	
	--mettre/enlever mask
	player_mask()
	
	--slide
	player_slide()
	
	--choix mask
	choix_mask()
		
	--check collisions up and down
	check_collision_ud()
	
	--check collisions left and right
	check_collision_rl()
		
	--if player collide with lava
	if(collide_with(p,3)) then	
		p.mort=true
		make_explosions(p.x,p.y,25)
		p.dx=0
		p.dy=0
		sfx(32)
		if(p.cp==true) then
			p.x = cp.x
			p.y = cp.y
			p.mask = cp.mask
			p.mask2 = cp.mask2
			p.life = cp.life
		else
		--restart game
		print("you are dead ",p.x,p.y-51,9)
		end
	end
	--if player collides with cp save
	if(collide_with(p,4)) then
		p.cp=true
	 cp ={}
		cp.x = p.x
		cp.y = p.y
		cp.mask = 0
		cp.mask2 = 0	
		cp.life = p.life
  --detruit fants
  --for i=1,#fants do
   --  if (fants[i]!=nil) del (fants,fants[i]) 
  --end
	end

	
	--if p collides with moved plat
	for pl in all(plat) do
		if(check_coll(p,pl)==true) then
			p.landed = true
			p.y=pl.y-8		
			p.dx=pl.s
		end
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
			if(btnp(❎))
			and mask_l.choisi == 0 then
			 p.mask = 1
			 p_vie()
			end
		elseif(p.mask == 1) then
		 p.dx = 0
			p.dy = 0
			if(btnp(❎)) p.mask = 0
		end
	end
	for mask2 in all(mask2s) do
		if(mask2.taken == true) then
			if(p.mask2 == 0) then
				if(btnp(❎))
				and mask_l.choisi == 1 then
					p.mask2 = 1	
					p_vie()
				end 	
			elseif(p.mask2 == 1) then
				p.jump=2
				p.dy = 0
			 p.dx = 0
				if(btnp(❎)) then
					p.mask2 = 0
				end
			end		
		end
	end	
end

function choix_mask()
	if (btnp(⬇️)) then
		if(mask_l.choisi >=1) then
			mask_l.choisi = 0
		else
			mask_l.choisi += 1
		end
	end		 
end


function check_collision_m()
	if(check_coll(p,mask)
	and mask.taken == false) then
		make_explosions(mask.x,mask.y,15)
		make_particules(mask.x,mask.y,16)
		mask.sp = 141
		sfx(33)
		mask.taken = true
  detect_fait_fantome()
  p.infob1=true
	end
end

function check_collision_m2()
	for mask2 in all(mask2s) do
		if(check_coll(p,mask2)
		and mask2.taken == false) then
			make_explosions(mask2.x,mask2.y,15)
			make_particules(mask2.x,mask2.y,16)
			sfx(33)
			mask2.sp = 141
			mask2.taken = true
   p.infob2=true
		end 		
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
			if(p.jump == 2) then
			 p.jump =2
			else
				p.jump = 1
			end
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

--mask 
function detect_fait_mask()
	for x=0,64 do
   for y=0,64 do 
    if (mget(x,y)==25) then
    mset(x,y,0)
    make_mask(x*8,y*8)
   	end
  	end
 	end
end

function make_mask(x,y)
	local mask2={}
 mask2.x=x
 mask2.y=y
 mask2.sp=46
 mask2.w = 16
	mask2.h = 16
	mask2.taken = false
 add(mask2s,mask2)
end

--draw mask
function draw_mask2s()
	for mask2 in all(mask2s) do
		spr(mask2.sp,mask2.x,mask2.y,2,2)
	end
end

--torches qui bougent
function detect_fait_torch()
  for x=0,128 do
   for y=0,64 do 
    if (fget(mget(x,y),5)) then
    mset(x,y,0)
    make_torche(x*8,y*8)
   	end
  	end
 	end
end

function make_torche(x,y)
	local to={}
 to.x=x
 to.y=y
 to.sp=70
 add(torches,to)
end

function draw_torches()
	for tor in all(torches) do
		spr(tor.sp,tor.x,tor.y)
	end
end

function animate_torche()
	for tor in all(torches) do
		if((cos(1.5*t())>0)
		and tor.sp==70) then
			tor.sp=71
		end
		if((cos(1.5*t())<0)
		and tor.sp==71) then
			tor.sp=70
		end
	end
end


--explosion
function make_explosions(x,y,nb)
	while(nb > 0) do
		explo = {}
		explo.x = x+(rnd(2)-1)*10
		explo.y = y+(rnd(2)-1)*10
		explo.r = 4 + rnd(4)
		explo.c = 8
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

function make_particules(x,y,nb)
	while (nb > 0) do
		part = {}
		part.x = x +4
		part.y = y +4
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
 --detect_fait_fantome()
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
 f.w=16
 f.h=16
 add(fants,f)
end

function draw_f()
if fants[1]!=nil then
--print(abs(fants[1].x-p.x),p.x,p.y+20,8)
end
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
   circ(fants[i].x,fants[i].y,3,12)
  end
 end
 draw_s()
end

function creve(m)
 if (m) then
  make_explosions(p.x,p.y,25)
  p.dx=0
  p.dy=0
  sfx(32)
  if(p.cp==true) then
  p.x = cp.x
  p.y = cp.y
  p.mask = cp.mask
  p.life = cp.life
  end
 end
 p.mort=false
end

function up_f()
------------------------------
-- on detecte si les fants tuent
--------------------------------
for i=1,#fants do
   if (fants[i]!=nil) then
     if (check_coll(fants[i],p)) then
       p.mort=true
       --p_vie()
     end
   end
 end
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
   if (p.x>=fants[i].x) then
    fants[i].x+=0.3
   -- if (abs((fants[i].x)-p.x)<16) p.mort=true--
   end
   if (p.x<=fants[i].x) then 
    fants[i].x-=0.3
    --if (abs(fants[i].x-(p.x+16))<2) p.mort=true
   end
   if (p.y<=fants[i].y) then
    fants[i].y-=0.3
    --if (abs(fants[i].y-(p.y+16))<2) p.mort=true
   end
   if (p.y>=fants[i].y) then
    fants[i].y+=0.3
    --if (abs((fants[i].y+16)-p.y)<2) p.mort=true
   end  
  end
 elseif p.mask==1 then
  if timer_f<0 then --avec port du mask on go
   for i=1,#fants do
   if (p.x>=fants[i].x) then
    fants[i].x-=0.5
   -- if (abs((fants[i].x)-p.x)<16) p.mort=true
   end
   if (p.x<=fants[i].x) then 
    fants[i].x+=0.5
   -- if (abs(fants[i].x-(p.x+16))<2) p.mort=true
   end
   if (p.y<=fants[i].y) then
    fants[i].y+=0.5
   -- if (abs(fants[i].y-(p.y+16))<2) p.mort=true
   end
   if (p.y>=fants[i].y) then
    fants[i].y-=0.5
   -- if (abs((fants[i].y+16)-p.y)<2) p.mort=true
   end 
   -- if (p.x>=fants[i].x) fants[i].x-=0.5
   -- if (p.x<=fants[i].x) fants[i].x+=0.5
   -- if (p.y<=fants[i].y) fants[i].y+=0.5
   -- if (p.y>=fants[i].y) fants[i].y-=0.5
   end
   else 
    timer_f-=1
    for i=1,#fants do
     make_s(fants[i].x+8,fants[i].y+8,1-rnd(2),colo)
     fants[i].x+=0.005*cos(3*t())
     fants[i].y+=-0.005*sin(3*t())    
    end
   end
   update_s()  
 end
-------------------------------------------------------
-- on declenche le bug
-------------------------------------------------------
 --if (temps==0) sfx(30)
 for i=1,#fants do
  if (p.mask!=1 and bug_p==0 and temps<=-20)then
 -- sfx(30,1)
   if (abs(p.y-fants[i].y)< 50) then
    if (abs(p.x-fants[i].x)< 20 and temps<=0) bug_p+=1
    if (abs(p.x-fants[i].x)< 35 and temps<=0) bug_p+=1
    if (abs(p.x-fants[i].x)< 50 and temps<=0) bug_p+=1
   end
  end
 end 
end

function bug(t,int)
 temps-=1
 if t>0 then
  --sfx(0,1)
  --camera(16-rnd(18),16-rnd(18))
  for i=0,int do
  sfx(30)
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
 colo = 7
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
 --if btn(🅾️) then
  for x=0,64 do
   for y=0,64 do 
    if (fget(mget(x,y),7)) then
    mset(x,y,0)
    make_f(x*8,y*8)
   end
  end
 end
 --end
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
  print(p.life..sub((t()-p.t),1,-4),cam_x,cam_y,8)
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
 for x=0,128 do
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
 cal=140
 --clip(0,100,256,256)
 --rectfill(0,0,128*8,cal+64,1)
 rectfill(0,cal,128*3,cal+64,0)
 rectfill(0,cal+64,128*3,cal+128,1)
 rectfill(0,cal+100,128*3,cal+228,2)
 for i=1,#dither do
  fillp(dither[#dither-i])
  pal(0,0)
  rectfill(0,cal+4+4*i,128*3,cal+4*i+8,1)
  pal(0,1)
  rectfill(0,cal+50+4*i,128*3,50+cal+4*i+8,2)
  pal()
  fillp()
 end
 
 rectfill(0,cal+110,128*8,cal+228*2,0)
 
 --clip()
end

------------------------------------------------
--plat qui bouge en horizontal
-------------------------------------------------
function init_plat()
 plat={}
 detect_fait_plat()
end
function detect_fait_plat()
  for x=0,64 do
   for y=0,64 do 
    if (mget(x,y)==127) then
    mset(x,y,0)
    make_plat(x*8,y*8,0.5,4)
   end
  end
 end
end
function make_plat(x,y,s,tile)
 local b={}
 b.xinit=x
 b.x=x
 b.y=y
 b.s=s
 b.w=8
 b.h=8
 b.fin=tile
 add(plat,b) 
end


function up_plat()
 for i=1,#plat do
  if (plat[i]!=nil) then
   if (plat[i].s>0 and plat[i].x<plat[i].xinit+(plat[i].fin)*8) then
    plat[i].x+=1*plat[i].s
   end
   if (plat[i].x>=plat[i].xinit+plat[i].fin*8) then
    plat[i].s=-1*plat[i].s
   end
   if (plat[i].s<0 and plat[i].x>=plat[i].xinit) then
    plat[i].x+=1*plat[i].s
   end
   if (plat[i].x<plat[i].xinit) then
    plat[i].s=-1*plat[i].s
   end  
  end
 end
end

function draw_plat()
 for i=1,#plat do
  if (plat[i]!=nil) spr(127,plat[i].x,plat[i].y)
 end
end

-----------------------------------
--putain de coeur
--------------------------------------
function init_co()
co={}
  for x=0,128 do
   for y=0,128 do 
    if (mget(x,y)==72) then
    mset(x,y,0)
    make_co(x*8,y*8)
   end
  end
 end
end

function make_co(x,y)
 local c={}
 c.x=x
 c.y=y
 c.h=8
 c.w=8
 c.spr=72
 add(co,c)
end

function up_co()
 for i=1,#co do
   if (co[i]!=nil) then
     if check_coll(co[i],p) then
       g_vie()
       sfx(29) --son pour prise de coeur
       mset(co[i].x,co[i].y,0)
       del(co,co[i])
     end
   end
 end
end

function draw_co()
 for i=1,#co do
   if (co[i]!=nil) spr(co[i].spr,co[i].x,co[i].y)
 end
end

-------------------------------------------------------
-- on dessine les info bules
---------------------------------------------------------
function draw_info(i1,i2)--
 if i1 then
  fillp(dither[8])
  rectfill(mask.x-32,mask.y-52,mask.x+70,mask.y-8,2)
  fillp()
  color(7)
  print ("★★mask of the truth★★",mask.x-30,mask.y-50)
  print ("   use it to stop time",mask.x-30,mask.y-50+6)
  print ("  and the  truth behind",mask.x-30,mask.y-50+12)
  print ("        glitches",mask.x-30,mask.y-50+18)
  print ("   press  ❎/x to wear",mask.x-30,mask.y-50+24)
  print ("    it will cost you:",mask.x-30,mask.y-50+30)
  print ("           one ♥ ",mask.x-30,mask.y-50+36)
 end
 if i2 then
  fillp(dither[8])
  rectfill(mask2s[1].x-32,mask2s[1].y-52,mask2s[1].x+70,mask2s[1].y-2,2)
  fillp()
  color(7)
  print ("★★mask of the hight★★",mask2s[1].x-30,mask2s[1].y-50)
  print ("   use it to stop time",mask2s[1].x-30,mask2s[1].y-50+6)
  print ("  and be able to double-",mask2s[1].x-30,mask2s[1].y-50+12)
  print ("          jump",mask2s[1].x-30,mask2s[1].y-50+18)
  print ("   press  ❎/x to wear",mask2s[1].x-30,mask2s[1].y-50+24)
  print ("    it will cost you:",mask2s[1].x-30,mask2s[1].y-50+30)
  print ("         one ♥ ",mask2s[1].x-30,mask2s[1].y-50+36)
  print (" press ⬇️ to switch mask ",mask2s[1].x-30,mask2s[1].y-50+42)
 end
end

-----------------------
--function  utiles
-----------------------

function init_paup()
 oeil=false
 h=128
 l=128
 fc=0
 c=8
end

function paup()
 --if (fc<=-5) return
 if (fc<=64 and oeil==true) then
  fc+=1
  rectfill(0,0,128,0+fc,0)
  rectfill(0,128,128,128-fc,0)
  if (fc>64) then 
   oeil=false
  --quand on change oeil on switch 
  --la map dans la chambre
   c=9
  end
 else
  fc-=1
  rectfill(0,0,128,0+fc,0)
  rectfill(0,128,128,128-fc,0)
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
8888888800eeeeee0000000000eeeeee00000000044ee8ee00000000444ee8ee00000000bbbbbbbb0c77777777777c000c77777777777c00c7777777777cccc0
88888888a0eeeeee0a000000a0eeeeee0a0000000aeeeeeea000000000aeeeee00000000bbbbbbbb0c77778877cc7c00cc77778877c77c007777788887cc77c0
8888888890eeeeee0900000090eeeeee0900000009eeeeee90000000009eeeee00000000bbbbbbbbc7c777887c777c0077c77888877c7c00ccc77788777777c0
8888888800444a440000000000444a440000000000eeeeee0000000000eeeeee00000000bbbbbbbbc7c777777c7c7c00ccc7777777777c0000c77777777ccc00
8888888800cccccc0000000000cccccc0000000000444a440000000000444a4400000000bbbbbbbb0c0c77777cc777c0000c7777777777c0000c7777777777c0
8888888800cc000c000000000acc000c0000000000cc000c0000000000cc000c00000000bbbbbbbb0000cc777777777c0000cc777777777c0000cc777777777c
888888880ac0000c00000000000000c00000000000c00acc0000000000c000ac00000000bbbbbbbb000000ccc77777c0000000ccc77777c0000000cc777777c0
888888880000000a00000000000000a00000000000a00000000000000a00000000000000bbbbbbbb000000000ccccc00000000000ccccc0000000000cccccc00
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
1dddddd14444444465556666445d444400000cccccc0000000900000000a0000022002200000000000cccc0000aaaa0000000001100000001144444411111111
ddd11d114444444460000006555555550000cccccccc0000a009000000a009002ee22e72001101600c7777c00a9999a001110017710011101444444441111111
dd1111114444444460000006444445d4000cc777777cc0000aa97000099770002eeeeee201110116c777777ca999999a16871117711178711444aaaa41155551
d1d1111144444444600000065555555500c7777777777c000a99900009a990002eeeeee200000000c7c77c7ca9a99a9a187877777777878114490aa011555555
1d1111114444444465556666445d44440c777777777777c000970000009700002eeeeee201110116c7c77c7ca9a99a9a18778777777877811449aaaa11595585
11111111444444446000000655555555c77ccc7777ccc77c004400000044000002eeee20011101160c7777c00a9999a018787788887787814449aaaa1159a855
0111111044444444600000065d4445d4c77ccc7777ccc77c0054000000540000002ee2000111011600c77c0000a99a001687786aa78778714449aaaa11599a55
00111000444444446000000655555555c7ccc777777ccc7c00540000005400000002200001110116000cc000000aa0001677866aa6687771144eeeee1155a555
1dddddd1333333331dddddd177766666c7ccc77cc77ccc7c0006700000000000000000000000000000d00d0000d00d00167778666687777111eeeeee11154551
ddd11d1133333333ddd11d1177776666c77777777777777c0066770000000000000000000111011600dddd0000dddd001678778888778771a1eeeeee11114111
dd11111144434444dd11111177776666c777777cc777777c00667700000000000000000001110116d02dd20d002dd200017887777778871091eeeeee111a9111
d1d1111144444444d1d11111077766600c77777cc77777c0066677700000000000000000011101161dddddd1dddddddd0178a888888a871011444a4411111111
1d111111446444441d1111110777666000ccc77cc77ccc000666777000000000000000000000000011d66d1111dddd1100178aaaaaa8710011cccccc11111111
1111111144444464111111110077660000000c7cc7c000006666777700000000000000000111011611dddd1111dddd110001188aa881100011cc111c11111111
0111111044444444011111100077660000000cc77cc000006666777700000000000000000111011600dddd0010dddd01000001188110000011c1111c11111111
001110004444444400111000000760000000000cc00000006666677700000000000000000111011600d00d0000d00d00000000011000000011a1111a11111111
00000000111111144411111111111111111111111111111444111111111111111111111111111111111111111111111111111111111111111111111100000000
88808888111111144411111771111777711111111111111444111111111111111111111111111111111111111117777777111111114444441111111100000000
80008008111111114111111771111111711111111111111141111117711111177771111111111111111111111777777774471111144444444155551100000000
8000800811111114411111111111111711111111111111144111171771111111117111111999191919991111777777777a4471111444aaaa4555555100000000
80008888111144454111171111111171111771111111444541111111111111111711111111911999199111177777777a7aa4a71114490aa04585595100000000
8000800011445566444111111111171111117111114455664441111111111111711111111191191919111170077777777ee477711449aaaa1558a95100000000
888880004455666226f4411111111777711711114455666226f4411111111117111111111191191919991100777777777ee777714449aaaa155a995100000000
0000000054666222226ff44dd11111111117711154666222226ff44dd111111777717711111111111111117779977777ccc777714449aaaa1555a55100000000
000000004662222aaa66fffdddd11111111111114662222aaa66ffffddd1111111111711111111111111117779977777a7c77771144eeeee11554511445d4444
00000000666222aaaaa6ffddddddd11111111111666222aaaaa6fffdddddd1111111711119991911919911000000000007a7777111eeeeee1111411155555555
00000000f6629aaaaaaafdddddddddd111111111f6629aaaaaaaffddddddddd11111771119911991919191177777777700000011a1eeeeee111a9111444445d4
00000000ff6229aaa8aadddddddddddddd111111ff6229aaa88adddddddddddddd1111111911191991919111777777777777711191eeeeee1111111155555555
00000000fff2229aaaaddddddddddddddddd1111fff2229aa8addddddddddddddddd11111999191191991111177777777777111111444a4411111111445d4444
00000000ffff22229adddddddddddddddddddd11ffff22229adddddddddddddddddddd111111111111111111111777777711111111cccccc1111111155555555
00000000ffff22222dddddddddddddddddddddddffff222222dddddddddddddddddddddd1111111111111111111111111111111111cc111c111111115d4445d4
00000000ffffff22ddddddddddddddddddddddddffffff222ddddddddddddddddddddddd1111111111111111111111111111111111a1111a1111111155555555
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050500000000000005000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050000000000000005050000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050590900500840000050000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050025250000000005050000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050000000000000005000000000000000000000000000000000000000000000000000000000000000000
00000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000050000000000000005000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000005050000000000000005000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000505000000000000000005000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000050500940000000000000005000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000094
00000000000000000094000000000000000000050000958400000590900505000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000940000007400000000000000000094000000007400000000000000000000000000000000000000000000000000000000000095
00000000000000000095000000000000000005050000950000000025250500000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000950000740000000000000000000095000000740000000000000000000000000000000000000000000074000000000074000095
00000000007400000095000000000000050505000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000950074747474740084000000000095000074007474747484000000000000000091000000000000000000000000000000000000
00000000000000000000000000060000000000000000000000000000050500000000000000000000000000000000000000000000000000000000000000000000
05000000000000000000000000000000740000000000000000000000000000740000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000060000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000
05000000000505050505050000000000007400000005050505000000000000007400000005050505050000000505050500000000000505050505050505000000
00050505050500000000050505060000000000000000000000000505050000000000000000000000000000000000000000000000000000000000000000000000
05000000000500000025006565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565656565
65656565650065656565250005050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000000000000
05000000000500000000252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525252525
25252525256525252525250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000000000500000000000000000000000000000005053535353535353535353535353535353535353535353535353535353535353535353535353535353535
35353535252525000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000000000005000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05000000000000050000000000000000000000000505000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050000000000050500000000000000000505050500000000000000000000000000000000000000000000000064000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000000000505000000000000050500000000000000000000000000000000000000000000000000000000640000740000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050500000000000005050000000005050000000000000000000000000000050505050500000000050505050000006400640000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000505000000000000050500000505000000000000000000000084000000000000000000000000000000000000000064740000000500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000005000000000000000505050500000000000000000000000000000000000000000000000000000000000000747474740000000500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050000000000000000060000000000000000000005050505050000000000000000000000000000000000000000000000000500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050500000000000000060000000000000084000000000000000000000000000000000000000000000000000000000000000500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000505050000000000060000000005050505050000000000000000000000000000000000000000000500000000000000000505000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000500000000000600000000000000000000000000000000000000000000000000000000000005050000000000c4d40500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100000000000505040404040404040465656565656565656565656565656565656565656565656565656565050500000000c5d50500000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000005050505050505052525252525252525252525252525252525252525252525252525252525050505050505050505000000000000000000
__gff__
0000000000000000004000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000001000020200000000000000000030308000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000
0000000000000000004000000000000080000000000000000000000000000000000000000000000000000000000004840000000000000000000000000000040401010000000000000000000000000000030309000000000000000000000000001004000000000000000000000000000000000000000000000000000000000000
__map__
5000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000005050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000050500000000000000000000000000000005000404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000505000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000005000000000000000000000000000005052525252000000000000000000000000000000000000000000005050505050505050505050505050505050505050505050505050500000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000005050500000000000000000000000005000000000000000000000000000000040404000000000000000005000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000000000505000000000000000000000005000000000000000005000100000000000000000000000000000500000000000000000000000000000000000000000000000460000505000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000000000005050000000000000000000005000000000000000000000000000000000000000000000000050006000490000000000490000000000490000000000000000460000005000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000000000000050500000000000000000005000000000000000000000000000000000000000000000005000006000590048470000590000474800590000000000000000460000005000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000000000000000000000505050505050505050505050505050505050505050505050505050505050505050500000006000000000000000000000000000000000000060004600460046505000000000000000000000000000000000000000000000000000000000000000
5000004900000000000000000000000000004900000000000000600000000000000047000000470000000047000000000047000000000047000000000047000000000000006000000050500000500000505000000000000060000046464600500000000000000000000000000000000000000000000000000000000000000000
5000495949000000000000000000000000005900004700000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000060000000460000500000000000000000000000000000000000000000000000000000000000000000
5000595959000000000000000000000000005900000000000000505050505050505050505050405050505050505050505050505050505050505050505050505050505050505050565656565656565656565656564040404040000000000000500000000000000000000000000000000000000000000000000000000000000000
5000595959000000000000000000000000000000000000005050505252525252525052525200000000000000000000000000525252520050100000000000000000000000000052525252525252525252525252525200000050000000000000500000000000000000000000000000000000000000000000000000000000000000
5000595959000000005050090909095000000000005050505050505050505000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000000000000000050000000000000500000000000000000000000000000000000000000000000000000000000000000
5000000000000000505050525252525000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000000000000000050000000000000500000000000000000000000000000000000000000000000000000000000000000
5000000000000050505050505050505000004900490000000000000000000000000000000000000000000000604600004050500000000000000000000000000000000000000000000000000000000000000000000000000050000000000000505000000000000000000000000000000000000000000000000000000000000000
5043434343435050505050505050505000005900590000470047000000000000004700004700000000000000600000004000000000000000000000000000000000000000000000000000000000000000000000000000000050500909500000005000000000000000000000000000000000000000000000000000000000000000
5000000000000000000047000000470000005900590000000000000000000000000000000000000000000000600000004000000000000000000000000000000000000000000000000000000000000000000000000000000050005252000000005000000000000000000000000000000000000000000000000000000000000000
5000000000000000000000000000000000000000000000505050500909090909405040405000000000000050504343435000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000505000000000000000000000000000000000000000000000000000000000000000
5050505050500000005050505050505040500000000000000000505052525252520000000000000000000000500000465000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000500000000000000000000000000000000000000000000000000000000000000000
0000505000000000000000000000000000000000000000000000000000000000000000000000000000000000500000005000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000504343435000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000000500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000504600005000000000000000000000000000000000000000000000000000000000000000000000000000000050004900000000500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000500000005000000000000000000000000000000000000000000000000000000000000000000000000000000050005900000000500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000006000000000000000000000000000000000504343435000000000000000000000000000000000000000000000000000000000000000000000000000000050005900500909500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000050005900005252500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000006000000000505050000050505000000000000000005000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000050500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000505050505050500000000000000000000000005050505050504000000000000000000000000000000000000000000000000000000000000000000000000000000050000000000050000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000005050505050404040500909090909090909090909095040404040404000000000000000000000000000000000000000000000000000000000000000000000000000005050000000000050000000000000000000000000000000000000000000000000000000000000000000
5151515151515151515151515151515151515151514141414141414040505252525252525252525252525040404040404000000000000000000000000000000000000000000000000000000000000000000000000000005000000000000050000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
010a00002d5522f552305520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011b00001355600000000000000000000000000200502005020050900500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002415023150211501d1501d150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010b0000185501a5501c5501d5501d5501d5500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900000e0520e0520e0520e052110521105210052100520d0520000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011900000205502055020551005500000000000000000000000000000000000000000000000000000000000002055020550205509055000000000000000000000000000000000000000000000000000000000000
012800000f0541205414054160540f0541205414054160540f0541205414054160540d0540f05412054140540d0540f05412054140540d0540f05412054140540105403054060540805401054030540605408054
01320000185551a555005050050518555155550050500505185551a5551c5551d5551c5551a5551c5551a555155550000500005185551a55500005000051855515555000000c55510555105550e5550c55500000
011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 23424344
02 22424344
03 25424344
03 24424344

