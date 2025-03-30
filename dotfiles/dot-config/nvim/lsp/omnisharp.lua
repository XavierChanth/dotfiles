return {
  filetypes = { "cs", "vb" },
  root_dir = function(bufnr, cb)
    cb(vim.fs.root(bufnr, function(name, _)
      return name:match("%.csproj$") ~= nil
    end))
  end,
  before_init = function(_, config)
    -- Get the initially configured value of `cmd`
    config.cmd = { table.unpack(config.cmd or {}) }

    -- Append hard-coded command arguments
    table.insert(config.cmd, "-z") -- https://github.com/OmniSharp/omnisharp-vscode/pull/4300
    vim.list_extend(config.cmd, { "--hostPID", tostring(vim.fn.getpid()) })
    table.insert(config.cmd, "DotNet:enablePackageRestore=false")
    vim.list_extend(config.cmd, { "--encoding", "utf-8" })
    table.insert(config.cmd, "--languageserver")

    -- Append configuration-dependent command arguments
    local function flatten(tbl)
      local ret = {}
      for k, v in pairs(tbl) do
        if type(v) == "table" then
          for _, pair in ipairs(flatten(v)) do
            ret[#ret + 1] = k .. ":" .. pair
          end
        else
          ret[#ret + 1] = k .. "=" .. vim.inspect(v)
        end
      end
      return ret
    end
    if config.settings then
      vim.list_extend(config.cmd, flatten(config.settings))
    end

    -- Disable the handling of multiple workspaces in a single instance
    config.capabilities = vim.deepcopy(config.capabilities)
    config.capabilities.workspace.workspaceFolders = false -- https://github.com/OmniSharp/omnisharp-roslyn/issues/909
  end,
  init_options = {},
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = nil,
    },
    MsBuild = { LoadProjectsOnDemand = false },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      AnalyzeOpenDocumentsOnly = false,
    },
    Sdk = { IncludePrereleases = false },
  },
}
