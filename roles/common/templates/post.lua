init = function(args)
   local r = {}
   r[1] = wrk.format(nil, "/?stm=1597991043684")
   r[2] = wrk.format(nil, "/?stm=1597991043684")
   r[3] = wrk.format(nil, "/?stm=1597991043684")

   req = table.concat(r)
end

request = function()
   return req
end

wrk.method = "POST"
wrk.body   = "[{"ai":"0a1b4118dd954ec3bcc69da5138bdb96","av":"2.1.36","b":"Web","u":"ce8d5fb6-0b0a-43db-a6f7-ab8b7a68c6ff","s":"f3feee14-4412-4257-9ba5-9a2e4a4e4728","t":"vst","tm":1598013140093,"pt":"https","sh":900,"sw":1440,"d":"docs.growingio.com","p":"/","rf":"","l":"en"},{"ai":"0a1b4118dd954ec3bcc69da5138bdb96","av":"2.1.36","b":"Web","u":"ce8d5fb6-0b0a-43db-a6f7-ab8b7a68c6ff","s":"f3feee14-4412-4257-9ba5-9a2e4a4e4728","t":"vst","tm":1598013140093,"pt":"https","sh":900,"sw":1440,"d":"docs.growingio.com","p":"/","rf":"","l":"en"}]"
wrk.headers["Content-Type"] = "application/json"
