local campMap = {};
local relation = {};

function Camp_Add(camp,obj) 
    if camp == nil then 
        return 
    end 
    local campList = campMap[camp]
    if campList == nil then 
        campList = {};
        campMap[camp] = campList;
    end 
    campList[obj] = obj;
    obj.camp = camp;
end

function Camp_SetHostile(camp1,camp2,fight)
    relation[camp1.."|"..camp2] = fight

end

function Camp_IsHostile(camp1,camp2)
    return relation[camp1.."|"..camp2] 
end

function Camp_Remove(obj)
    if obj.camp == nil then 
        return 
    end
    local campList = campMap[obj.camp]
    if campList == nil then 
        return 
    end 
    campList[obj] = nil;
    obj.camp = nil;
end

function Camp_IterateHostile(myCamp,callback)
    for camp,campList in pairs(campMap) do
        if Camp_IsHostile(myCamp,camp) then 
            for _,obj in pairs(campList) do
                local result = callback(obj)
                if result then 
                    return result
                end 
            end
        end
    end
end

function Camp_IterateAll(callback)
    for camp,campList in pairs(campMap) do
        for _,obj in pairs(campList) do
            local result = callback(obj)
            if result then 
                return result
            end 
        end
    end
end