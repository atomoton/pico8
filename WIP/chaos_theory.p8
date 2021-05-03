pico-8 cartridge // http://www.pico-8.com
version 32
__lua__


-- to do: stars on background, collisions

function draw_phobos()
	-- now draw the trail
	for i=1,#phobos.history,1 do
	  spr(34, phobos.history[i]["x"], phobos.history[i]["y"])
	end
	if phobos.offscreen then
		spr(18, phobos.ix, phobos.iy)
	else
		spr(2, phobos.x, phobos.y)
	end
end

function draw_demos()
	-- now draw the trail
	for i=1,#demos.history,1 do
	  spr(36, demos.history[i]["x"], demos.history[i]["y"])
	end
	if demos.offscreen then
		spr(20, demos.ix, demos.iy)
	else
		spr(4, demos.x, demos.y)
	end
end

function draw_luna()
	-- now draw the trail
	for i=1,#luna.history,1 do
	  spr(33, luna.history[i]["x"], luna.history[i]["y"])
	end
	
	if luna.offscreen then
		spr(17, luna.ix, luna.iy)
	else
		spr(1, luna.x, luna.y)
	end	
end

function draw_target(x,y)
	circfill(x,y,4,8)
	circfill(x,y,3,7)
	circfill(x,y,2,8)
	circfill(x,y,1,7)
end

blank_timer_max=600
blank_timer=blank_timer_max

snapshot_rate=2
snapshot_timer=snapshot_rate
trail_length=500

function _init()
	cls()
end

-->8
--functions

phobos = {
	x=rnd(128),
	y=rnd(128),
	m=30,
	vx=rnd(0.2),
	vy=rnd(1.0)+0.2,
	f=0,
	ix=0,
	iy=0,
	offscreen=false,
	history={}
}


demos = {
	x=rnd(128),
	y=rnd(128),
	m=30,
	vx=-1 * phobos.vx,
	vy=-1 * phobos.vy,
	f=0,
	ix=0,
	iy=0,
	offscreen=false,
	history={}
}

luna = {
	x=rnd(128),
	y=rnd(128),
	m=30,
	vx=0,
	vy=0,
	f=0,
	ix=0,
	iy=0,
	offscreen=false,
	history={}
}

target = {
	x=rnd(57)+70,
	y=rnd(57)+70
}


function move_planet(p)
	
	if p.f >= 2 then
		planet_crash = true
	else

 	for f in all(planets) do
 		local dist=0
 		local angle=0
 		local force=0
 		
 		if not(f==p) then
 			dist=pythag(f.x-p.x,f.y-p.y)
 			dist = mid(0.01, dist, 50)
 			angle = atan2(p.x-f.x,p.y-f.y)
 			force = (p.m * f.m * (6.67*10^-3)) / dist^2
 			force = mid(0.01, force, 2)
 			p.f = max(force, p.f)
 			p.vx=p.vx-force*cos(angle)
 			p.vy=p.vy-force*sin(angle)
 		end
 	end
 	
 	p.vx = mid(-6, p.vx, 6)
 	p.vy = mid(-6, p.vy, 6)
 
 	--move
 	if planet_crash then
 	  p.x+=p.vx -- (sx - 63)
 	  p.y+=p.vy -- (sy - 63)
 	else
 	  p.x+=p.vx - (sx - 63)
   	p.y+=p.vy - (sy - 63)
  end
 	
 end
end

function pythag(a,b)
	if a > 126 then a = 126 end
	if b > 126 then b = 126 end
	return sqrt(a^2+b^2)
end

function offscreen_check(p)
	if p.x < 0 then 
		p.ix = 0
		p.offscreen = true
	end
	if p.y < 0 then 
		p.iy = 0
		p.offscreen = true
	end
	if p.x > 127 then 
		p.ix = 126
		p.offscreen = true
	end
	if p.y > 127 then 
		p.iy = 126
		p.offscreen = true
	end
	if (0 <= p.x) and (p.x <= 127) then
		p.ix = p.x
	end
	if (0 <= p.y) and (p.y <= 127) then
		p.iy = p.y
	end
	if (0 <= p.x) and (p.x <= 127) and (0 <= p.y) and (p.y <= 127) then
		p.offscreen = false
	end
end
-->8
--draw

function _draw()
	--comment out for trails
	cls()
	
	draw_phobos()
	draw_demos()
	draw_luna()
 --draw_target(target.x, target.y)

 --print(unpack(luna.x_history))
	--print(demos.x)
	--print(demos.y)
	--print(phobos.x)
	--print(phobos.y)
	--print(target.x)
	--print(target.y)
	--print(dist)
	--print(angle)
	--print(force)
	--print(phobos.f)
	--print(demos.f)
	--print(luna.f)
	

	
end


-->8
--update

function _update60()
	
	blank_timer-=1
	if blank_timer<0 then 
		blank_timer=blank_timer_max 
		cls()
	end

 snapshot_timer-=1
 if snapshot_timer<0 then
   snapshot_timer=snapshot_rate
   -- record snapshots
   add(phobos.history, {x=phobos.x, y=phobos.y})
   if #phobos.history > trail_length then
     deli(phobos.history, 1)
   end

   add(demos.history, {x=demos.x, y=demos.y})
   if #demos.history > trail_length then
     deli(demos.history, 1)
   end
   
   add(luna.history, {x=luna.x, y=luna.y})
   if #luna.history > trail_length then
     deli(luna.history, 1)
   end
   
 end
 planet_crash = false

	planets = {}
	add(planets, phobos)
	add(planets, demos)
	add(planets, luna)
	
	get_avg_change()	
	move_planet(phobos, planets)
	move_planet(demos, planets)
	move_planet(luna, planets)
	
	for p in all(planets) do
		offscreen_check(p)
	end
	
	-- target stays in a fixed position
	target.x = sx
	target.y = sy

end
	
-->8

function get_avg_change()
 
	local avg_x = {}
	local avg_y = {}
	
		for p in all(planets) do
		add(avg_x, p.x)
		add(avg_y, p.y)
	end
	
	sx = 0.0
	sy = 0.0
	for i=1,#avg_x do
		sx += avg_x[i]
		sy += avg_y[i]
	end
	sx = sx / #avg_x
	sy = sy / #avg_y
end

__gfx__
000000000666d600000ffff088888888033333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006666d6660fff99ff80088008332223330070000000000700000000700000000000000070000700000070000000000000000000000000000000000000
00700700565555550ffff99f80088008332322230777000000000000000000000007000000007070000700000770000000000000000000000000000000000000
000770005556d656ff9aaa9f88888888332333330070000000700000000000000077700000700000077770000000707000000000000000000000000000000000
000770006655d556ffaaaaff88888888323333230000000000000000000000000007000000007000007777000000070000000000000000000000000000000000
0070070066d555600faa99f080088008233223230000007000007000000000000000000000000000000700000000707000000000000000000000000000000000
0000000006d65d600ff99ff080088008333323330000077700077700000000000000000000007000000700000000000000000000000000000000000000000000
000000000666666000ffff0088888888032333300000007000007000000000000000000000000000000000000000000000000000000000000000000000000000
0000000066000000aa00000000000000330000000000000000000000000000000000000000000000090000000908888a0908888a0900888a0900088a00000000
0000000066000000aa00000000000000330000000000000000000000000000000000000000a00a0000a99a9088a99a9a88a99a9a88a09a900000900000000000
000000000000000000000000000000000000000000000000000000000000000000000000000a0000099909000999080a0990080a090008000900080000000000
00000000000000000000000000000000000000000000000000000000000000000007700000a77a0000a79a9000a79a8000000080000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000770000a077a0009097a00a8097a80a8000080a80000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000a0000000a90990a8a90980a8a00080a80000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000a0009000a09a8998898a8998898a80080980800000800000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000090000a8a8988aa8a8988aa800908a0000000a00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066000000aa00000000000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000066000000aa00000000000000330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888777777888eeeeee888eeeeee888eeeeee888eeeeee888888888888888888888888888888888888ff8ff8888228822888222822888888822888888228888
8888778887788ee88eee88ee888ee88ee888ee88ee8e8ee88888888888888888888888888888888888ff888ff888222222888222822888882282888888222888
888777878778eeee8eee8eeeee8ee8eeeee8ee8eee8e8ee88888e88888888888888888888888888888ff888ff888282282888222888888228882888888288888
888777878778eeee8eee8eee888ee8eeee88ee8eee888ee8888eee8888888888888888888888888888ff888ff888222222888888222888228882888822288888
888777878778eeee8eee8eee8eeee8eeeee8ee8eeeee8ee88888e88888888888888888888888888888ff888ff888822228888228222888882282888222288888
888777888778eee888ee8eee888ee8eee888ee8eeeee8ee888888888888888888888888888888888888ff8ff8888828828888228222888888822888222888888
888777777778eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661611166616611616111116661666166616661666111116661666161611111c111ccc1ccc1111111111111111111111111111111111111111111111111111
16161611161616161616111111611161166616111616111116661616161617771c111c1c1c1c1111111111111111111111111111111111111111111111111111
16611611166616161661111111611161161616611661111116161666116111111ccc1c1c1c1c1111111111111111111111111111111111111111111111111111
16161611161616161616111111611161161616111616111116161616161617771c1c1c1c1c1c1111111111111111111111111111111111111111111111111111
16661666161616161616166611611666161616661616166616161616161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661611166616611616111116661666166616661666111116661611166616611616111116661666166616661666111116661666161611111111111111111111
16161611161616161616111111611161166616111616177716161611161616161616111111611161166616111616111116661616161611111111111111111111
16611611166616161661111111611161161616611661111116611611166616161661111111611161161616611661111116161666116111111111111111111111
16161611161616161616111111611161161616111616177716161611161616161616111111611161161616111616111116161616161611111111111111111111
16661666161616161616166611611666161616661616111116661666161616161616166611611666161616661616166616161616161611111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111888881111111111111111111111111111111111111111111111111111111111111111111
11661661166616661166161611661666111116661666166616661111888881111111111111111111111111111111111111111111111111111111111111111111
16111616161616161611161616161161111116161616116116111777888881117111111111111111111111111111111111111111111111111111111111111111
16661616166616661666166616161161111116611666116116611111888881117711111111111111111111111111111111111111111111111111111111111111
11161616161616111116161616161161111116161616116116111777888881117771111111111111111111111111111111111111111111111111111111111111
16611616161616111661161616611161166616161616116116661111888881117777111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111117711111111111111111111111111111111111111111111111111111111111111
11661661166616661166161611661666111116661666166616661666111111661171166616661166161611661666111116661666166616661111111111111111
16111616161616161611161616161161111111611161166616111616177716111616161616161611161616161161111116161616116116111111111111111111
16661616166616661666166616161161111111611161161616611661111116661616166616661666166616161161111116611666116116611111111111111111
11161616161616111116161616161161111111611161161616111616177711161616161616111116161616161161111116161616116116111111111111111111
16611616161616111661161616611161166611611666161616661616111116611616161616111661161616611161166616161616116116661111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
16661666166616661611111116111666166111661666161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111111111111111
11611616161611611611111116111611161616111161161617771c111c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
11611661166611611611111116111661161616111161166611111ccc1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
1161161616161161161111111611161116161616116116161777111c1c1c1c1c1111111111111111111111111111111111111111111111111111111111111111
11611616161616661666166616661666161616661161161611111ccc1ccc1ccc1111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111111111666166116661666117111711111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111111111161161611611161171111171111111111111111111111111111111111111111111111111111111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116661666161616661161117111711111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1b1111bb1171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111b111711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b111bbb1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111b111b11111b1711111711111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111bb1bbb1bb11171117111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1ee11ee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1ee11e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1e111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1eee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822282228888888888888888888888888888888888888888888888888222822282888882822282288222822288866688
82888828828282888888828888828828828882828888888888888888888888888888888888888888888888888282828282888828828288288282888288888888
82888828828282288888822282228828822282228888888888888888888888888888888888888888888888888222822282228828822288288222822288822288
82888828828282888888888282888828888288828888888888888888888888888888888888888888888888888282828282828828828288288882828888888888
82228222828282228888822282228288822288828888888888888888888888888888888888888888888888888222822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0303030303030303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000600000060000600096500b6500f65013650196501d65022650276502b6502f6503265033650346503465034650346503465032650316502e65029650226501f6501865014650126500d650096500865000600
001000000565008650000000b6500e650136501a65021650266502c650316503465037650396503a6503b650000003b6503b65038650336502d6502965023650206501c65015650106500c650086500265002650
00010000000000000005650086500c6500f65012650166501b65020650246502c65030650316500000033650346503465034650316502c650246501e650146500f6500c650086500265000000000000000000000
010800000005102051040510505107051090510b0510c0510e05110051110511305117051180511a0511c0511d0511f05121051210511f0511d0511c0511a0511805117051150511305111051100510e0510c051
__music__
00 41424344
00 01030244

