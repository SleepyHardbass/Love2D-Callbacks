# Features
* Multiple Event Handlers
* Process events without branching
# Usage Example
``` lua
local callbacks = require("callbacks"); callbacks:init()
love.handlers = callbacks.handlers

callbacks:appendhandler("mousemoved", function(x,y) print(x,y) end) -- return's function ~0x1
callbacks:appendhandler("mousemoved", function(x,y) print(x*y) end) -- return's function ~0x2

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

``` lua
function love.run()    
    local callbacks = require("callbacks"); callbacks:init()
    local handlers = callbacks.handlers
    
    local quitarg = false
    local quit = function(arg) quitarg = arg or 0 end
    callbacks:appendhandler("quit", quit)
    
    local delta = timer.step()
    return function()
        -- Process events.
        love.event.pump()
        if quitarg then return quitarg end
        for name, a,b,c,d,e,f in love.event.poll_i do
            handlers[name](a,b,c,d,e,f)
        end
        
        delta = love.timer.step()
        
        love.graphics.clear()
        love.graphics.print(timer.getFPS(), 10, 10)
        love.graphics.present()
        
        love.timer.sleep(0.001)
    end
end
```
