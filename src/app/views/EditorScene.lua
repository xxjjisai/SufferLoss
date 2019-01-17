local EditorScene = class("EditorScene", cc.load("mvc").ViewBase)

local TankCursor = require('app.TankCursor')

local Map = require("app.Map")


function EditorScene:onCreate()
    local size = cc.Director:getInstance():getWinSize();
    local spriteFrameCache = cc.SpriteFrameCache:getInstance();
    spriteFrameCache:addSpriteFrames("res/tex.plist")

    self.map = Map.new(self);

    self.tank = TankCursor.new(self,"tank_green",self.map);
    self.tank:SetPos(5,5);

    self:ProcessInput();
end 


function EditorScene:ProcessInput() 
    local listener = cc.EventListenerKeyboard:create();
    listener:registerScriptHandler(function (keyCode,event)
        if self.tank ~= nil then 
            if keyCode == 146 then 
                -- self.tank:MoveCursor(0,1)
            elseif keyCode == 142 then 
                -- self.tank:MoveCursor(0,-1)
            elseif keyCode == 124 then 
                -- self.tank:MoveCursor(-1,0)
            elseif keyCode == 127 then 
                -- self.tank:MoveCursor(1,0)
            end
        end 
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)

    listener:registerScriptHandler(function (keyCode,event)
        if self.tank ~= nil then 
            if keyCode == 146 then 
                self.tank:MoveCursor(0,1)
            elseif keyCode == 142 then 
                self.tank:MoveCursor(0,-1)
            elseif keyCode == 124 then 
                self.tank:MoveCursor(-1,0)
            elseif keyCode == 127 then 
                self.tank:MoveCursor(1,0)
            elseif keyCode == 133 then 
                self.tank:SwitchBlock(1)
            elseif keyCode == 134 then 
                self.tank:SwitchBlock(-1)
            elseif keyCode == 49 then 
                self.map:Load("editor.lua")
            elseif keyCode == 50 then 
                self.map:Save("editor.lua")
            end
        end 
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)

    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self);
end 

return EditorScene
