return {
    __VERSION = "11.4",
    __URL = "https://github.com/SleepyHardbass/Love2D-Callbacks",
    __LICENSE = "MIT License",
    __WARNMSG = "Callbacks version is (%s)\nIt may not be compatible with the running version (%s)\n\n",
    __EMPTY = function() end,
    __ITERATOR = {
        __call = function(self, a,b,c,d,e,f)
            for index = 1, self[0] do
                self[index](a,b,c,d,e,f)
            end
        end
    },
    __GARBAGE = {}, -- <array>{ [index] = <metatable> }
    __SYSEVENTS = {
        keypressed = true,
        keyreleased = true,
        textinput = true,
        textedited = true,
        mousemoved = true,
        mousepressed = true,
        mousereleased = true,
        wheelmoved = true,
        touchpressed = true,
        touchreleased = true,
        touchmoved = true,
        joystickpressed = true,
        joystickreleased = true,
        joystickaxis = true,
        joystickhat = true,
        joystickadded = true,
        joystickremoved = true,
        gamepadpressed = true,
        gamepadreleased = true,
        gamepadaxis = true,
        focus = true,
        mousefocus = true,
        visible = true,
        resize = true,
        displayrotated = true,
        quit = true,
        threaderror = true,
        lowmemory = true,
        filedropped = true,
        directorydropped = true
    },
    
    handlers = {}, -- <hash>{ [event name] = <function or metatable> }
    init = function(self)
        if love._version ~= self.__VERSION then
            io.write(string.format(self.__WARNMSG, self.__VERSION, love._version))
        end
        self:reinit()
    end,
    reinit = function(self)
        for name, value in next, self.handlers do
            self.handlers[name] = nil
            if type(value) == "table" then
                self.__GARBAGE[#self.__GARBAGE + 1] = value
            end
        end
        for name in next, self.__SYSEVENTS do
            self.handlers[name] = self.__EMPTY
        end
    end,
    
    registerevent = function(self, event)
        if not self.handlers[event] then
            self.handlers[event] = self.__EMPTY
        end
    end,
    unregisterevent = function(self, event)
        if not self.handlers[event] then return end
        if type(self.handlers[event]) == "table" then
            self.__GARBAGE[#self.__GARBAGE + 1] = self.handlers[event]
        end
        if self.__SYSEVENTS[event] then
            self.handlers[event] = self.__EMPTY
        else
            self.handlers[event] = nil
        end
    end,
    
    appendhandler = function(self, event, handler)
        if self.handlers[event] == self.__EMPTY then
            self.handlers[event] = handler
        elseif type(self.handlers[event]) == "table" then
            local index = self.handlers[event][0] + 1
            self.handlers[event][0] = index
            self.handlers[event][index] = handler
        elseif #self.__GARBAGE > 0 then
            local array = self.__GARBAGE[#self.__GARBAGE]
            self.__GARBAGE[#self.__GARBAGE] = nil
            array[0], array[1], array[2] = 2, self.handlers[event], handler
            self.handlers[event] = array
        else
            self.handlers[event] = setmetatable(
                {[0] = 2, self.handlers[event], handler}, self.__ITERATOR
            )
        end
    end,
    removehandler = function(self, event, handler)
        if type(self.handlers[event]) == "table" then
            local array = self.handlers[event]
            local position = array[0] + 1
            for index = 1, array[0] do
                if array[index] == handler then
                    position = index; break
                end
            end
            if position <= array[0] then
                array[position] = array[ array[0] ]
                array[0] = array[0] - 1
                if array[0] == 1 then
                    self.handlers[event] = array[1]
                    self.__GARBAGE[#self.__GARBAGE + 1] = array
                end
            end
        elseif self.handlers[event] == handler then
            self.handlers[event] = self.__EMPTY
        end
    end,
    
    collectgarbage = function(self)
        local array
        for index = #self.__GARBAGE, 1, -1 do
            array = self.__GARBAGE[index]
            for i = #array, 0, -1 do
                array[i] = nil
            end
            self.__GARBAGE[index] = nil
        end
    end
}
