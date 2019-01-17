
local WelcomeScene = class("WelcomeScene", cc.load("mvc").ViewBase)

function WelcomeScene:onCreate()

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello Tank World", "Arial", 40)
        :move(display.cx, display.cy + 100)
        :addTo(self)

    self:ProcessInput();
    
end


function WelcomeScene:ProcessInput() 
    local listener = cc.EventListenerKeyboard:create();
    listener:registerScriptHandler(function (keyCode,event)
        if keyCode == 146 then 
            -- local testScene = self:getApp():getSceneWithName( "MainScene" )
            -- local transition = cc.TransitionJumpZoom:create( 0.5, testScene )
            -- cc.Director:getInstance():replaceScene(transition)
            cc.Director:getInstance():replaceScene(TransitionFlipX:create(2, "EditorScene"))
        elseif keyCode == 142 then 
            local testScene = self:getApp():getSceneWithName( "EditorScene" )
            local transition = cc.TransitionJumpZoom:create( 0.5, testScene )
            cc.Director:getInstance():replaceScene(transition)
        end 
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)

    local eventDispatcher = self:getEventDispatcher();
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self);
end 

return WelcomeScene

