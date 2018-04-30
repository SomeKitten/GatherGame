engine = {}
engine.imgs = {}

function engine.load(amount)
    game = {}
    game.layers = {}

    for i = 1, amount do
        game.layers[i] = {}
        game.layers[i].children = {}
    end
end

function engine.newObject(properties)
    local p = properties.parent or game.layers[1]
    local n = properties.name or engine.newObjName(p)

    p.children[n] = engine.new(properties)

    print (p.children)

    return p.children[n]
end

function engine.newObjName(p)
    local count = 1
    while p.children['obj' .. count] ~= nil do
        count = count + 1
    end

    return 'obj' .. count
end

function engine.new(properties)
    local props = properties or {}

    local component = {}
    component.x = props.x or 0
    component.y = props.y or 0
    component.w = props.w or 100
    component.h = props.h or 100
    component.onclick = props.onclick or function () return end
    component.color = props.color
    component.children = properties.children or {}

    component.img = props.img
    if component.img ~= nil then
        component.img:setFilter( 'nearest', 'nearest' )
    end

    component.enabled = props.enabled == nil and true or props.enabled

    return component
end

function engine.enable(o)
    if mathK.tLength(o.children) > 0 then
        for k,child in pairs(o.children) do
            engine.enable(child)
        end
    end

    o.enabled = true
end

function engine.disable(o)
    if mathK.tLength(o.children) > 0 then
        for k,child in pairs(o.children) do
            engine.disable(child)
        end
    end

    o.enabled = false
end

function engine.drawObjects()
    for i = #game.layers, 1, -1 do
        for k,o in pairs(game.layers[i].children) do
            engine.drawObject(o)
        end
    end
end

function engine.drawObject(o)
    if o.enabled then
        engine.draw(o)

        if mathK.tLength(o.children) > 0 then
            for k,child in pairs(o.children) do
                engine.drawObject(child)
            end
        end
    end
end

function engine.draw(component)
    if component.img ~= nil then
        love.graphics.draw( component.img, component.x, component.y, 0, component.w / component.img:getWidth(), component.h / component.img:getHeight())
    else
        if component.color ~= nil then
            love.graphics.setColor(component.color[1], component.color[2], component.color[3])
            love.graphics.rectangle('fill', component.x, component.y, component.w, component.h)
        end
    end
end

function engine.checkObjectsPressed(x, y, button, istouch)
    local clicked = false
    for i,l in ipairs(game.layers) do
        for k,o in pairs(l.children) do
            local clicked = engine.checkObjectPressed(o, x, y, button, istouch)

            if clicked then return true end
        end
    end
end

function engine.checkObjectPressed(o, x, y, button, istouch)
    if mathK.tLength(o.children) > 0 then
        for k,child in pairs(o.children) do
            local clicked = engine.checkObjectPressed(child, x, y, button, istouch)

            if clicked then return true end
        end
    end
    if o.enabled
        and o.x < x
        and o.y < y
        and x < o.w + o.x
        and y < o.h + o.y
    then
        o.onclick()
        return true
    end

    return false
end