local nio = require("nio")

--- Run command in a tmux split at the bottom
---@param spec neotest.RunSpec
---@return neotest.Process
return function(spec)
  local command = spec.command
  local cwd = spec.cwd or vim.fn.getcwd()
  local env = spec.env

  -- Check if we're in a tmux session
  local in_tmux = vim.fn.system("echo $TMUX"):gsub("%s+", "") ~= ""

  if not in_tmux then
    vim.notify("Not in a tmux session. Cannot use tmux strategy.", vim.log.levels.ERROR)
    return {}
  end

  local output_path = nio.fn.tempname()
  local result_code = 0

  -- Convert command array to string, properly escaping each argument
  local command_str
  if type(command) == "table" then
    local escaped_parts = {}
    for _, part in ipairs(command) do
      table.insert(escaped_parts, vim.fn.shellescape(part))
    end
    command_str = table.concat(escaped_parts, " ")
  else
    command_str = command
  end

  -- Build environment variables string
  local env_str = ""
  if env then
    for k, v in pairs(env) do
      env_str = env_str .. string.format("%s=%s ", k, vim.fn.shellescape(v))
    end
  end

  -- Build the command that uses 'tee' to show output in tmux AND write to file
  -- This allows interactive debugging while still capturing output for neotest
  local full_command = string.format(
    "%s%s 2>&1 | tee %s; echo $? > %s.exit",
    env_str,
    command_str,
    vim.fn.shellescape(output_path),
    vim.fn.shellescape(output_path)
  )

  -- Split window at bottom (20% height) and run the command
  -- Keep the pane open after test finishes for debugging
  local tmux_command = string.format(
    "tmux split-window -v -l 30%% -c %s '%s; echo; echo \"Press Enter to close\"; read'",
    vim.fn.shellescape(cwd),
    full_command
  )

  vim.fn.system(tmux_command)

  return {
    is_complete = function()
      return nio.fn.filereadable(output_path .. ".exit") == 1
    end,

    output = function()
      return output_path
    end,

    stop = function()
      -- Just wait command to finish
    end,

    output_stream = function()
      return function()
        return nil
      end
    end,

    attach = function()
      -- No-op for tmux strategy
    end,

    result = function()
      -- Wait for the exit code file to appear
      while nio.fn.filereadable(output_path .. ".exit") ~= 1 do
        nio.sleep(100)
      end

      local exit_file = io.open(output_path .. ".exit", "r")
      if exit_file then
        result_code = tonumber(exit_file:read("*l")) or 1
        exit_file:close()
        os.remove(output_path .. ".exit")
      end

      return result_code
    end,
  }
end
