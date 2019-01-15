local Actor = require("app.Actor")
local Block = class("Block",Actor)
local nMaxBreakableStep = 3;
local tbBlockProperty = {
    mud = -- 泥土类型
    { 
        hp = 0;
        needAp = false; -- 穿甲弹
        damping = 0.2; -- 阻尼
        breakable = false; -- 是否可以破坏
    },
    road = -- 路面类型
    { 
        hp = 0;
        needAp = false; -- 穿甲弹
        damping = 0; -- 阻尼
        breakable = false; -- 是否可以破坏
    },
    grass = -- 草荫类型
    { 
        hp = 0;
        needAp = false; -- 穿甲弹
        damping = 0; -- 阻尼
        breakable = false; -- 是否可以破坏
    },
    water = -- 水类型
    { 
        hp = 0;
        needAp = false; -- 穿甲弹
        damping = 1; -- 阻尼
        breakable = false; -- 是否可以破坏
    },
    brick = -- 砖类型
    { 
        hp = nMaxBreakableStep;
        needAp = false; -- 穿甲弹
        damping = 1; -- 阻尼
        breakable = true; -- 是否可以破坏
    },
    steel = -- 钢铁类型
    { 
        hp = nMaxBreakableStep;
        needAp = true; -- 穿甲弹
        damping = 1; -- 阻尼
        breakable = true; -- 是否可以破坏
    }
}
function Block:ctor(node)
    Block.super.ctor(self,node) 
    self.node = node;
end

function Block:Break() 
    if not self.breakable then 
        return false;
    end  
    self.hp = self.hp - 1;
    if self.hp < 0 then 
        self:Reset("mud");
    else  
        self:updateImage();
    end 
end

function Block:updateImage() 
    local spriteFrameCache = cc.SpriteFrameCache:getInstance();
    local spriteName = nil;
    if self.breakable then 
        spriteName = string.format( "%s%d.png",self.type, nMaxBreakableStep - self.hp)
    else
        spriteName = string.format( "%s.png",self.type)
    end
    local frame = spriteFrameCache:getSpriteFrame(spriteName);
    if frame == nil then 
        print(" Block:updateImage frame not found!~~~");
    else
        self.sp:setSpriteFrame(frame);
        if self.type == "grass" then 
            self.sp:setLocalZOrder(10)
            self.sp:setOpacity(200)
        else
            self.sp:setLocalZOrder(0)
            self.sp:setOpacity(255)
        end
    end
end

function Block:Reset(type) 
    local t = tbBlockProperty[type];
    assert(t);
    for k,d in pairs(t) do
        self[k] = d
    end
    self.type = type;
    self:updateImage();
end

return Block