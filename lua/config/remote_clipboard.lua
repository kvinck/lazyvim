-- Clipboard for sessions whose yanks may need to reach another machine:
-- every copy is emitted as OSC 52 (inside tmux this becomes a tmux buffer,
-- rebroadcast to every attached client, local or SSH). Paste prefers the
-- machine's own clipboard when one is reachable, so content copied in other
-- apps remains pasteable; without one, paste falls back to whatever this
-- instance last copied.
local M = {}

-- Whether `name` appears anywhere in this process's own chain of ancestors.
-- macOS has no /proc, so the walk goes through ps; comm is a full executable
-- path there and a basename truncated to 15 characters on Linux, which is why
-- the test is a substring match.
local function in_process_tree_of(name)
  local pid = vim.fn.getpid()

  for _ = 1, 16 do
    local line = vim.fn.systemlist({ "ps", "-o", "ppid=,comm=", "-p", tostring(pid) })[1]
    local ppid, comm = (line or ""):match("^%s*(%d+)%s+(.*)$")
    if not ppid then
      return false
    end

    if comm:find(name, 1, true) then
      return true
    end

    pid = tonumber(ppid)
    if pid <= 1 then
      return false
    end
  end

  return false
end

-- Commands for the clipboard of the machine Neovim itself runs on, or nil when
-- it has none. Wayland keeps the primary selection in a separate buffer that
-- "* maps onto; the macOS pasteboard has no equivalent, so both registers
-- share it.
local function local_clipboard(register)
  if
    vim.env.WAYLAND_DISPLAY ~= nil
    and vim.fn.executable("wl-copy") == 1
    and vim.fn.executable("wl-paste") == 1
  then
    local copy = { "wl-copy", "--sensitive", "--type", "text/plain" }
    local paste = { "wl-paste", "--no-newline" }
    if register == "*" then
      copy[#copy + 1] = "--primary"
      paste[#paste + 1] = "--primary"
    end
    return { copy = copy, paste = paste }
  end

  if vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1 then
    return { copy = { "pbcopy" }, paste = { "pbpaste" } }
  end
end

function M.setup()
  local in_tmux = vim.env.TMUX ~= nil
  local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
  local in_herdr = vim.env.HERDR_PANE_ID ~= nil or in_process_tree_of("herdr")

  if not (in_tmux or in_ssh or in_herdr) then
    return
  end

  local osc52 = require("vim.ui.clipboard.osc52")
  -- Lines this instance last put on each register, for the paste fallback.
  local last_copied = {}

  local function copy(register)
    local emit = osc52.copy(register)
    local local_cmd = local_clipboard(register)

    return function(lines)
      last_copied[register] = lines

      if local_cmd then
        vim.fn.system(local_cmd.copy, lines)
      end

      if vim.g.omarchy_remote_clipboard_osc52 ~= false then
        emit(lines)
      end
    end
  end

  local function paste(register)
    local local_cmd = local_clipboard(register)

    -- With no clipboard to read back, report what this instance last copied.
    -- The alternative is an OSC 52 query, which wedges the editor until it
    -- times out against any terminal or multiplexer that will not answer one.
    if not local_cmd then
      return function()
        return last_copied[register] or {}
      end
    end

    return function()
      local lines = vim.fn.systemlist(local_cmd.paste, "", 1)
      return vim.v.shell_error == 0 and lines or {}
    end
  end

  vim.g.clipboard = {
    name = "OmarchyRemoteClipboard",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste("+"), ["*"] = paste("*") },
    cache_enabled = 0,
  }
end

return M
