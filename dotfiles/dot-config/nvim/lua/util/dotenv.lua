local loop = vim.loop

local function read_file(path)
  local fd = assert(loop.fs_open(path, "r", 438))
  local stat = assert(loop.fs_fstat(fd))
  local data = assert(loop.fs_read(fd, stat.size, 0))
  assert(loop.fs_close(fd))
  return data
end

local function parse_data(data)
  local values = vim.split(data, "\n")
  local out = {}
  for _, pair in pairs(values) do
    pair = vim.trim(pair)
    if not vim.startswith(pair, "#") and pair ~= "" then
      local splitted = vim.split(pair, "=")
      if #splitted > 1 then
        local key = splitted[1]
        local v = {}
        for i = 2, #splitted, 1 do
          local k = vim.trim(splitted[i])
          if k ~= "" then
            table.insert(v, splitted[i])
          end
        end
        if #v > 0 then
          local value = table.concat(v, "=")
          value, _ = string.gsub(value, '"', "")
          vim.env[key] = value
          out[key] = value
        end
      end
    end
  end
  return out
end

local function get_env_file()
  local files = vim.fs.find(".env", { upward = true, type = "file" })
  if #files == 0 then
    return
  end
  return files[1]
end

local function load(file)
  if file == nil then
    file = get_env_file()
  end

  local ok, data = pcall(read_file, file)
  if not ok then
    vim.print("couldn't read file")
    vim.print(data)
    return
  end

  local values = parse_data(data)
  for k, v in pairs(values) do
    vim.schedule(function()
      vim.print("setting: " .. k .. "=" .. v)
      vim.uv.os_setenv(k, v)
    end)
  end
end

return {
  load = load,
}
