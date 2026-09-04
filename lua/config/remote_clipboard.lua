-- Clipboard for sessions whose yanks may need to reach another machine:
-- every copy is emitted as OSC 52 (inside tmux this becomes a tmux buffer,
-- rebroadcast to every attached client, local or SSH). Paste prefers the
-- machine's own clipboard when one is reachable, so content copied in other
-- apps remains pasteable; without one, paste is an OSC 52 query that tmux
-- (or the terminal) answers.
local M = {}

local function proc_lines(pid, file)
  local ok, lines = pcall(vim.fn.readfile, "/proc/" .. pid .. "/" .. file)
  return ok and lines or {}
end

local function proc_ppid(pid)
  for _, line in ipairs(proc_lines(pid, "status")) do
    local ppid = line:match("^PPid:%s+(%d+)")
    if ppid then
      return tonumber(ppid)
    end
  end
end

local function ancestor_process_named(name)
  local pid = vim.fn.getpid()

  for _ = 1, 16 do
    local ppid = proc_ppid(pid)
    if not ppid or ppid <= 1 then
      return false
    end

    local comm = proc_lines(ppid, "comm")[1] or ""
    if comm:find(name, 1, true) then
      return true
    end

    pid = ppid
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
  local in_herdr = vim.env.HERDR_PANE_ID ~= nil or ancestor_process_named("herdr")

  if not (in_tmux or in_ssh or in_herdr) then
    return
  end

  local osc52 = require("vim.ui.clipboard.osc52")

  local function copy(register)
    local emit = osc52.copy(register)
    local local_cmd = local_clipboard(register)

    return function(lines)
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
    if not local_cmd then
      return osc52.paste(register)
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
