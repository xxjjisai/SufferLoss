local Map = class("Map")

local Block = require('app.Block')

function Map:ctor( node ) 
    self.map = {};
    self.node = node;
    for x = 0, MapWidth-1 do  
        for y = 0, MapHeight-1 do 
            if x == 0 or x == MapWidth -1 or y == 0 or y == MapHeight-1 then 
                self:Set(x,y,"steel")
            else 
                self:Set(x,y,"mud")
            end
        end 
    end 

    self:Set(5,6,"water")
    self:Set(5,7,"grass")
    self:Set(5,8,"steel")
    self:Set(6,8,"road")
    self:Set(6,6,"brick")
    self:Set(6,7,"brick")
    self:Set(7,7,"brick")
    self:Set(8,7,"brick")
    self:Set(9,7,"brick")

    self:Load("editor.lua")
end 

function Map:Get(x,y) 
    if x<0 or y<0 then 
        return nil;
    end

    if x >= MapWidth or y >= MapHeight then 
       return nil; 
    end 

    return self.map[x*MapHeight+y];
end 

function Map:Set(x,y,type) 
    local block = self.map[x*MapHeight+y];
    if block == nil then 
        block = Block.new(self.node);
    end 
    block:SetPos(x,y);
    self.map[x*MapHeight+y] = block;
    block:Reset(type);
    block.x = x;
    block.y = y;
end

function Map:collideWithBlock(r,x,y) 
    local block = self:Get(x,y);
    if block == nil then 
        return nil;
    end 
    if block.damping < 1 then 
        return nil;
    end 
    if RectIntersect(r,block:GetRect()) ~= nil then 
        return block;
    end
end

function Map:Collide( posx, posy, ex) 
    local objRect = NewRect( posx, posy, ex);
    for x = 0, MapWidth-1 do  
        for y = 0, MapHeight-1 do 
            local b = self:collideWithBlock(objRect, x, y)
            if b ~= nil then 
                return b;
            end 
        end 
    end 
    return nil;
end

function Map:Hit(posx, posy) 
    local x,y = Pos2Grid(posx, posy)
    local block = self:Get(x, y)
    if block == nil then 
        return nil,true;
    end 
    if block.breakable then 
        return block;
    end 
    return nil;
end

function Map:Load(filename)
    local t = dofile(filename)
    if t == nil then 
        return 
    end 
    for _,block in ipairs(t) do
        self:Set(block.x, block.y, block.type)
    end
    print(filename.."loaded!!!")
end

function Map:Save(filename) 
    local f = assert(io.open(filename,'w'))
    f:write("return {\n")
    for x = 0,MapWidth -1 do 
        for y=0,MapHeight -1 do 
            local block = self:Get(x, y)
            f:write(string.format( "{x=%d,y=%d,type='%s'},\n",x,y,block.type ))
        end
    end 
    f:write("}\n")
    f:close()
    print(filename.."saved!!!")
end 

return Map