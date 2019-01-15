
local Actor = class("Actor")
function Actor:ctor(node,camp)
    self.sp = cc.Sprite:create();
    self.node = node;
    self.node:addChild(self.sp);
    self:Stop();
    Camp_Add(camp, self);
    if self.Update ~= nil then 
        self.updateFuncID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
            self:Update();
        end,0,false)
    end 
end

function Actor:Alive()
    return self.sp ~= nil;
end

function Actor:Stop() 
    self.dx = 0;
    self.dy = 0;
end

function Actor:UpdatePosition(callback) 
    local dt = cc.Director:getInstance():getDeltaTime();
    local nextPosX = self.sp:getPositionX() + self.dx * dt;
    local nextPosY = self.sp:getPositionY() + self.dy * dt;
    if callback(nextPosX,nextPosY) then 
        return 
    end 
    if self.dx ~= 0 then 
        self.sp:setPositionX(nextPosX)
    end 
    if self.dy ~= 0 then 
        self.sp:setPositionY(nextPosY)
    end 
end

function Actor:Destory()
    Camp_Remove(self)
    if self.updateFuncID then 
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.updateFuncID)
    end
    self.node:removeChild(self.sp)
    self.sp = nil;
end

function Actor:SetPos(x,y) 
    local posx,posy = Grid2Pos(x, y)
    self.sp:setPositionX(posx)
    self.sp:setPositionY(posy)
end 

function Actor:GetPos() 
    return Pos2Grid(self.sp:getPositionX(), self.sp:getPositionY())
end 

function Actor:GetRect()
    return NewRect(self.sp:getPositionX(), self.sp:getPositionY())
end

-- 活体之间的碰撞
function Actor:CheckCollide(posx,posy,ex)
    local selfrect = NewRect(posx,posy,ex);
    return Camp_IterateAll(function (obj)
        if obj == self then 
            return false;
        end
        local tgtrect = NewRect(obj.sp:getPositionX(), obj.sp:getPositionY())
        if RectIntersect(selfrect, tgtrect) ~= nil then 
            return obj;
        end 
    end)
end

function Actor:CheckHit(posx,posy)
    return Camp_IterateHostile(self.camp, function (obj)
        local tgtrect = obj:GetRect();
        if RectHit(tgtrect, posx,posy) then 
            return obj;
        end 
    end)
end

return Actor