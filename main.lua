
local characters = {
    "!","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"," ",
    " ","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
    "0","1","2","3","4","5","6","7","8","9","+","-","?","$","%","[","]","(",")","+","-","?","$","%","[","]","(",")","!",
}

local function randchar(len)
    local ret = ''
    for i = 1,len do
        local pos = math.random(84)
        ret = ret..characters[pos]
    end
    return ret
end

local config = SMODS.current_mod.config
SMODS.current_mod.config_tab = function()
    return{
        n = G.UIT.ROOT, config = {r = 0.1, minw = 8, minh = 6, align = "tm", padding = 0.2, colour = G.C.BLACK, emboss = 0.1}, nodes = {
            {n = G.UIT.R, config = {padding = 0}, nodes = {
                {n = G.UIT.C, config = {align = "cm"}, nodes = {
                    {n = G.UIT.R,  config = {align = "cm", padding = 0.01},  nodes = {
                        create_toggle({
                            label = 'removes all descriptions\n   (requires restart)',
                            ref_table = config,
                            ref_value = 'unreadable'
                        }),
                    }}
                }}
            }}
        }
    }
end

local absurdity = config.unreadable
local dont_hurt_my_eyes = randchar(1)

function number_format(num)
    if type(num) ~= "number" and type(num) ~= "cdata" then return num end
    if num == 0 then
        return absurdity and dont_hurt_my_eyes or "None"
    elseif num > 1e208 then
        return 'Too much'
    else
        return absurdity and dont_hurt_my_eyes or (num < 0 and "-" or "").."Some"
    end
end

local oldlocalize = localize
function localize(args, misc_cat)
    if absurdity then
        if args.type == 'name_text' then
            local ret_string
            local name_text = G.localization.descriptions[(args.set or args.node.config.center.set)][args.key or args.node.config.center.key].name
            if type(name_text) == "table" then
                ret_string = ""
            for i, line in ipairs(name_text) do
                ret_string = ret_string.. (i ~= 1 and " " or "")..randchar(6)
            end
            else
                ret_string = name_text
            end
        elseif args.type == 'raw_descriptions' then
            return {randchar(4), randchar(5)}
        end
        return randchar(4)
    else
        return oldlocalize(args, misc_cat)
    end
end

local oldlocparsestring = loc_parse_string
function loc_parse_string(line)
    if absurdity then
        local ret = oldlocparsestring('')
        return{strings = '', control = ret and ret.control or {}}
    else
        return oldlocparsestring(line)
    end
end

function SMODS.juice_up_blind()
end