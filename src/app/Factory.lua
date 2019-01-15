local Tank = require("app.Tank")
local AITank = require("app.AITank")
local Factory = class("Factory")

function Factory:ctor(node,map)
    self.map = map
    self.node = node;

    cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
        self:SpawnRandom();
    end,5,false)

    self:SpawnRandom();
end

function Factory:SpawnRandom()
    local x,y = self:GeneratePos();
    self:SpawnByPos(x,y);
end

function Factory:GeneratePos()
    while true do  
        local x = math.random( 0,MapWidth-1 )
        local y = math.random( 0,MapHeight-1 )
        if self:CheckPos(x,y) then 
            return x,y;
        end 
    end
end

function Factory:CheckPos(x,y)
    local block = self.map:Get(x, y)
    local blockRect = NewRect(block.sp:getPositionX(), block.sp:getPositionY());
    if block.type == 'mud' then 
        if not Camp_IterateAll(function (obj)
            local tgtrect = NewRect(obj.sp:getPositionX(), obj.sp:getPositionY());
            if RectIntersect(blockRect, tgtrect) ~= nil then 
                return true;
            end 
        end) then 
            return true;
        end
    end 
end 

function Factory:SpawnByPos(x,y) 
    AITank.new(self.node,"tank_blue",self.map,"enemy"):SetPos(x,y);
end

return Factory