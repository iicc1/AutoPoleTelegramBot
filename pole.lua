local redis = require("redis")
local redis = redis.connect('127.0.0.1', 6379)
local test = false
function tdbot_update_callback(data)
    if not test then 
    	getChats(2^63 - 1, 0, 20, ok_cb)    -- Si está recién arrancado, cargar chats de TDCLI
    	test = true
    end
    if string.find(os.date("%X"), "00:00:0%d") and not redis:get("wait_time") then
        local chatsTexts = getChatsTexts()
        print("Enviando mensaje a las", os.date("%c"))
        for _,chat in pairs(chatsTexts) do
            sendMessage(chat.id, chat.text) 
        end
        redis:setex("wait_time", 10, true)      -- Para que envíe solo un mensaje
    end
    return
end

function getChatsTexts()    -- Pon en este array los grupos que quieres que envíe el mensaje y que texto enviar
    local tbl = {}          -- Los supergrupos deben empezar por -100xxx..., los grupos por -xxx... y los mensajes a usuarios sin "-"
    tbl[1] = {}
    tbl[1].id = -100288288288 -- Ejemplo supergrupo/canal
    tbl[1].text = "Pole"
    tbl[2] = {}
    tbl[2].id = -288288288  -- Ejempro grupo
    tbl[2].text = "P013 3NV!4A4 (0RR3(74M3N73 " .. os.date("%X")
    tbl[3] = {}
    tbl[3].id = 288288288  -- Ejemplo usuario normal
    tbl[3].text = "Poleee"
    return tbl
end

function sleep(n)
    os.execute("sleep " .. tonumber(n))
end

function dl_cb(a, b)
    vardump(b)
end

function sendMessage(chat_id, text)
   tdbot_function ({
        _="sendMessage", 
        chat_id=chat_id, 
        reply_to_message_id=nil, 
        disable_notification=false, 
        from_background=true, reply_markup=nil, 
        input_message_content={_="inputMessageText", text=text, disable_web_page_preview=true, clear_draft=false, entities={}, parse_mode=nil}}, 
    	dl_cb, nil)
end

function getChats(offset_order, offset_chat_id, limit, cb, cmd)
    if not limit or limit > 20 then
    	limit = 20
    end
  	tdbot_function ({
     	_ = "getChats",
      	offset_order = offset_order or 9223372036854775807,
      	offset_chat_id = offset_chat_id or 0,
      	limit = limit
    	}, nil)
end

function vardump(value, depth, key)
  local linePrefix = ""
  local spaces = ""

  if key ~= nil then
    linePrefix = "["..key.."] = "
  end

  if depth == nil then
    depth = 0
  else
    depth = depth + 1
    for i=1, depth do spaces = spaces .. "  " end
  end

  if type(value) == 'table' then
    mTable = getmetatable(value)
  if mTable == nil then
    print(spaces ..linePrefix.."(table) ")
  else
    print(spaces .."(metatable) ")
    value = mTable
  end   
  for tableKey, tableValue in pairs(value) do
    vardump(tableValue, depth, tableKey)
  end
  elseif type(value)  == 'function' or 
    type(value) == 'thread' or 
    type(value) == 'userdata' or
    value   == nil
  then
    print(spaces..tostring(value))
  else
    print(spaces..linePrefix.."("..type(value)..") "..tostring(value))
  end
end
