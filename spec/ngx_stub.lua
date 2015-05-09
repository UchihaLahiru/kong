local reg = require "rex_pcre"

_G.ngx = {
  time = function() return os.time() end, -- cassandra.lua
  re = {
    match = reg.match
  },
  -- Builds a querystring from a table, separated by `&`
  -- @param tab The key/value parameters
  -- @param key The parent key if the value is multi-dimensional (optional)
  -- @return a string representing the built querystring
  encode_args = function(tab, key)
    local query = {}
    local keys = {}

    for k in pairs(tab) do
      keys[#keys+1] = k
    end

    table.sort(keys)

    for _, name in ipairs(keys) do
      local value = tab[name]
      if key then
        name = string.format("%s[%s]", tostring(key), tostring(name))
      end
      if type(value) == "table" then
        query[#query+1] = build_query(value, name)
      else
        value = tostring(value)
        if value ~= "" then
          query[#query+1] = string.format("%s=%s", name, value)
        else
          query[#query+1] = name
        end
      end
    end

    return table.concat(query, "&")
  end
}
