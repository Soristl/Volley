-- local tfm.exec.chatMessage_colors = { 
--     cep = "#f0a78e", fc = "#ff8547", ce = "#e88f4f",
--     o = "#f79337", cs = "#efce8f", d = "#ffd991",
--     j = "#babd2f", t = "#a4cf9e", vp = "#2ecf73",
--     pt = "#2eba7e", v = "#009d9d", ch = "#98e2eb",
--     bv = "#2f7fcc", bl = "#6c77c1", g = "#60608f",
--     n = "#c2c2da", n2 = "#9393aa", vi = "#c53dff",
--     s = "#caa4cb", ps = "#f1c4f6", ch2 = "#feb1fc",
--     rose = "#ed67ea", r = "#cb546b"
-- }

-- local branch = "test"

-- if branch == "test" then
--     printCallback = print
-- else
--     printCallback = tfm.exec.chatMessage
-- end

-- -- ui.addTextArea(3232, "<font size = 14px>Debug zone", 
-- --                 nil, -310, 5, 300, 600,
-- -- 			    0x000000, 0x00ffaa, 0.9, 
-- -- 			    true)

-- function debug_textArea(text, target)
--     ui.updateTextArea(3232, text, target)
-- end


-- function split(inputstr, sep)
--   if sep == nil then
--     sep = "%s"
--   end
--   local t={}
--   for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--     table.insert(t, str)
--   end
--   return t
-- end

-- local tfm.exec.chatMessage_categories = 
-- {
--     warning, info, err, debug, sensible 
-- }

-- -- function tfm.exec.chatMessage(type, message, target)
-- --     --print("Type:"..type)
-- -- 	--print("Message:"..message)
-- -- 	--print(target)

-- --     if type == "info" then
-- --         printCallback(message)
-- --     elseif type == "debug" then
-- --         debug_textArea(message)
-- --     end

-- -- end

-- -- tfm.exec.chatMessage("info", "<br><j>Welcome to the Volley, created by Refletz#6472", name)
-- -- tfm.exec.chatMessage("info", "<n>#Volley Version: <j>2.3.0<n>", name)
-- -- tfm.exec.chatMessage("info", "<n>Join our #Volley Discord server: <ce>https://discord.com/invite/pWNTesmNhu<n><br>", name)

-- message = "<font size = '12x'>"

-- --tfm.exec.chatMessage("debug", message, name)