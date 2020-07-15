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