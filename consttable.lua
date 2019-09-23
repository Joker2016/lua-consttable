
function newConst( const_table )    --生成常量表功能
    function Const( const_table )
        local pairsFunc = function(t, key)
            local nk, nv
            if not key or (key and const_table[key]) then
                nk, nv = next(const_table, key)
            end
            --print(key, nk, nv)
            if nk then
                return nk, nv
            end

            if key and const_table[key] then
                nk, nv = next(t.__parent, nil)
                --print("1111",key, nk, nv)
                return nk, nv
            end

            nk, nv = next(t.__parent, key)
            --print("2222",key, nk, nv)
            return nk, nv
        end
        local mt =
        {
            __index = function (t,k)
                if t.__parent[k] then
                    return t.__parent[k]
                end
                if type(const_table[k])=="table" then
                    const_table[k] = newConst(const_table[k])
                end
                return const_table[k]
            end,
            __newindex = function (t,k,v)
                if const_table[k] then
                    print("*can't update " .. tostring(const_table) .."[" .. tostring(k) .."] = " .. tostring(v))
                else
                    t.__parent[k] = v
                end
            end,
            __pairs = function(t, key)
                return pairsFunc, t, nil
            end
        }
        return mt
    end

    local t = {}
    t.__parent = {}
    setmetatable(t, Const(const_table))
    return t
end

quan = {a = {[1]={2}}}
quan.b = quan
t = newConst(quan)
t.b = 4
print(type(t))
print(quan.b)
t.c = "ddd"
t.d = "ddd"


for k,v in pairs(t) do
    print("XXXXXXXXXXXXXXXXXXXXXX",k,v)
end
