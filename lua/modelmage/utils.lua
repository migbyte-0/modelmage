local M = {}

--- A simple notifier function.
-- @param msg string: The message to display.
-- @param level string: The log level ('info', 'warn', 'error').
function M.notify(msg, level)
  level = level or 'info'
  local vim_level
  if level == 'warn' then
    vim_level = vim.log.levels.WARN
  elseif level == 'error' then
    vim_level = vim.log.levels.ERROR
  else
    vim_level = vim.log.levels.INFO
  end
  vim.notify('[ModelMage] ' .. msg, vim_level)
end

--- Converts a string from PascalCase or camelCase to snake_case.
-- @param str string: The input string.
-- @return string: The snake_cased string.
function M.snake_case(str)
  return str
    :gsub('%s', '_')
    :gsub('([A-Z])([A-Z][a-z])', '%1_%2')
    :gsub('([a-z])([A-Z])', '%1_%2')
    :lower()
end

--- Reads the content of a file.
-- @param path string: The full path to the file.
-- @return string or nil: The file content or nil on error.
function M.read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

--- Writes content to a file.
-- @param path string: The full path to the file.
-- @param content string: The content to write.
-- @return boolean: True on success, false on failure.
function M.write_file(path, content)
  local file = io.open(path, 'w')
  if not file then
    return false
  end
  file:write(content)
  file:close()
  return true
end

--- Runs a command in a floating terminal window.
-- @param cmd string: The command to execute.
function M.run_command_in_terminal(cmd)
  vim.cmd('vsplit')
  vim.cmd('terminal ' .. cmd)
end

return M
