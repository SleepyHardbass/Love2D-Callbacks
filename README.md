# Features
* Multiple Event Handlers
* Process events without branching
# Usage Example
* New event must be registered: callbacks:registerevent(< key >)
* Such functions can be invoked as usual, via love.event.push using the table index as an argument.
``` lua
local callbacks = require("callbacks"); callbacks:init()
love.handlers = callbacks.handlers

local gametime = require("gametime")
for index = 1, #gametime.__NEWEVENTS do
    callbacks:registerevent(gametime.__NEWEVENTS[index])
    -- registerevent "minutepassed"
    -- registerevent "hourpassed"
    -- registerevent "daypassed"
    -- ect.
end

```
* Example1:
``` lua
local callbacks = require("callbacks"); callbacks:init()
love.handlers = callbacks.handlers

-- callbacks.handlers.mousemoved is <function> callbacks.__EMPTY

callbacks:appendhandler("mousemoved", function(x,y) print(x,y) end) -- return's function ~0x1
-- callbacks.handlers.mousemoved is <function> ~0x1

callbacks:appendhandler("mousemoved", function(x,y) print(x*y) end) -- return's function ~0x2
-- callbacks.handlers.mousemoved is <metatable>__ITERATOR {[0] = 2, ~0x1, ~0x2 }

function love.load()
    -- ...
end

function love.update()
    -- ...
end

function love.draw()
    -- ...
end
```
* Example2:
``` lua
function love.run()    
    local callbacks = require("callbacks"); callbacks:init()
    local handlers = callbacks.handlers
    
    local quitarg = false
    local quit = function(arg) quitarg = arg or 0 end
    callbacks:appendhandler("quit", quit)
    
    local delta = love.timer.step()
    return function()
        -- Process events.
        love.event.pump()
        if quitarg then return quitarg end
        for name, a,b,c,d,e,f in love.event.poll_i do
            handlers[name](a,b,c,d,e,f)
        end

        -- Update
        delta = love.timer.step()
        -- ...

        -- Render
        love.graphics.clear()
        love.graphics.print(love.timer.getFPS(), 10, 10)
        love.graphics.present()
        
        love.timer.sleep(0.001)
    end
end
```
