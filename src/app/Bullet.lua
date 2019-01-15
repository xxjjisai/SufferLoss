local Actor = require("app.Actor")
local Bullet = class("Bullet",Actor)
local SpriteAnim = require("app.SpriteAnim")

local function getDeltaByDir(dir,speed) 
    if dir == "left" then 
        return -speed,0;
    elseif dir == "right" then 
        return speed,0;
    elseif dir == "up" then 
        return 0,speed;
    elseif dir == "down" then 
        return 0,-speed;
    end
    return 0,0
end

function Bullet:ctor( node,map,type,obj,dir ) 
    Bullet.super.ctor(self,node,obj.camp..".bullet") 
    self.node = node;

    self.dx,self.dy = getDeltaByDir(dir, 200)
    self.map = map;
    self.sp:setPositionX(obj.sp:getPositionX())
    self.sp:setPositionY(obj.sp:getPositionY())

    self.spAnim = SpriteAnim.new(self.sp);
    self.spAnim:Define(nil,"bullet",2,0.1);
    self.spAnim:Define(nil,"explode",3,0.1,true);

    self.spAnim:SetFrame("bullet", type);
end

function Bullet:Update()
    if self.map == nil then return end;
    self:UpdatePosition(function (nextX,nextY) 
        local hit = nil; 
        local block,out = self.map:Hit(nextX,nextY)
        if block or out then 
            hit = "explode";
            if block and block.breakable then 
                if (block.needAp and self.type == 1) or not block.needAp then 
                    block:Break();
                end
            end 
        else
            local target = self:CheckHit(nextX,nextY) 
            if target then 
                target:Destory();
                if iskindof(target, "Bullet") then 
                    hit = "disappear"
                    target.spAnim:Destory();
                else
                    hit = "explode";
                end 
            end   
        end 
        if hit then 
            self:Stop();
            if hit == "explode" then 
                self:Explode();
            elseif hit == "disappear" then 
                self.spAnim:Destory();
                self:Destory();
            end 
        end
        return false;
    end)
end

function Bullet:Explode()
    self.spAnim:Play("explode",function ()
        self:Destory();
    end)
end

return Bullet