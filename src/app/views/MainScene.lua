local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local Map = require("app.Map")
local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")
local Factory = require("app.Factory")
function MainScene:onCreate()
    local size = cc.Director:getInstance():getWinSize();
    local spriteFrameCache = cc.SpriteFrameCache:getInstance();
    spriteFrameCache:addSpriteFrames("res/tex.plist")


    Camp_SetHostile("player", "enemy", true)
    Camp_SetHostile("enemy", "player", true)
    
    Camp_SetHostile("player.bullet", "enemy", true)
    Camp_SetHostile("enemy.bullet", "player", true)

    Camp_SetHostile("player.bullet", "enemy.bullet", true)
    Camp_SetHostile("enemy.bullet", "player.bullet", true)

    self.map = Map.new(self);

    self.factory = Factory.new(self,self.map);

    self.tank = PlayerTank.new(self,"tank_green",self.map,"player");
    self.tank:SetPos(5,5);

    -- Tank.new(self,"tank_blue",self.map,"enemy"):SetPos(3,4);

    self:ProcessInput();
end

function MainScene:ProcessInput() 
    local listener = cc.EventListenerKeyboard:create();
    listener:registerScriptHandler(function (keyCode,event)
        if self.tank ~= nil then 
            if keyCode == 146 then 
                self.tank:MoveEnd("up")
            elseif keyCode == 142 then 
                self.tank:MoveEnd("down")
            elseif keyCode == 124 then 
                self.tank:MoveEnd("left")
            elseif keyCode == 127 then 
                self.tank:MoveEnd("right")
            end
        end 
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)

    listener:registerScriptHandler(function (keyCode,event)
        if self.tank ~= nil then 
            if keyCode == 146 then 
                self.tank:MoveBegin("up")
            elseif keyCode == 142 then 
                self.tank:MoveBegin("down")
            elseif keyCode == 124 then 
                self.tank:MoveBegin("left")
            elseif keyCode == 127 then 
                self.tank:MoveBegin("right")
            elseif keyCode == 133 then 
                self.tank:Fire();
            elseif keyCode == 134 then 
                self.factory:SpawnRandom();
            end
        end 
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)

    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self);
end 

return MainScene
