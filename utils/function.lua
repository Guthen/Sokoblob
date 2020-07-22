function approach( a, b, t )
    t = math.abs( t )

    if a < b then
        return math.min( a + t, b )
    elseif a > b then
        return math.max( a - t, b )
    end

    return b
end

function enum( name, tbl )
    for k, v in pairs( tbl ) do
        _G[name .. k] = v
    end
end

function clamp( value, min, max )
	return value < min and min or value > max and max or value
end

function collide( a, b )
    return a.x < b.x + b.w and b.x < a.x + a.w 
       and a.y < b.y + b.h and b.y < a.y + a.h
end

function get_hovered_color( base_color, hovered_amount )
	hovered_amount = hovered_amount or .1
	return { base_color[1] - hovered_amount, base_color[2] - hovered_amount, base_color[3] - hovered_amount }
end

function get_string_tall( text )
	local lines = 1

	for l in text:gmatch( "\n" ) do
		lines = lines + 1
	end

	return lines * Game.Font:getHeight()
end

Game.Timers = {} 
function timer( seconds, callback )
	Game.Timers[#Game.Timers + 1] = { time = seconds, callback = callback }
end

--  > https://love2d.org/wiki/HSL_color (this code look a mess :sue:)
function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h/256*6, s/255, l/255
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255,a
end