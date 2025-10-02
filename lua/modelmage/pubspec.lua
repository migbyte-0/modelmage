local utils = require('modelmage.utils')

local M = {}

local required_deps = { 'freezed_annotation', 'json_annotation' }
local required_dev_deps = { 'build_runner', 'freezed', 'json_serializable' }

--- Finds the pubspec.yaml file by searching upwards from the current directory.
-- @return string or nil: The path to pubspec.yaml or nil if not found.
local function find_pubspec()
  local path = vim.fn.expand('%:p:h')
  local pubspec_path = vim.fs.find('pubspec.yaml', { path = path, upward = true, type = 'file' })
  return #pubspec_path > 0 and pubspec_path[1] or nil
end

--- Checks pubspec.yaml and installs missing dependencies.
-- @return boolean: True if all dependencies are present or installed, false otherwise.
function M.check_and_install_deps()
  local pubspec_file = find_pubspec()
  if not pubspec_file then
    utils.notify('Could not find pubspec.yaml in the project.', 'error')
    return false
  end

  local content = utils.read_file(pubspec_file)
  if not content then
    utils.notify('Could not read pubspec.yaml.', 'error')
    return false
  end

  local missing_deps = {}
  local missing_dev_deps = {}

  for _, dep in ipairs(required_deps) do
    if not content:match(dep .. ':') then
      table.insert(missing_deps, dep)
    end
  end

  for _, dep in ipairs(required_dev_deps) do
    if not content:match(dep .. ':') then
      table.insert(missing_dev_deps, dep)
    end
  end

  if #missing_deps == 0 and #missing_dev_deps == 0 then
    local confirm = vim.fn.confirm('All necessary packages are present. Continue?', '&Yes\n&No', 1)
    return confirm == 1
  end

  local message = 'Missing required packages:\n'
  if #missing_deps > 0 then
    message = message .. '- Dependencies: ' .. table.concat(missing_deps, ', ') .. '\n'
  end
  if #missing_dev_deps > 0 then
    message = message .. '- Dev Dependencies: ' .. table.concat(missing_dev_deps, ', ') .. '\n'
  end
  message = message .. '\nAdd them now?'

  local choice = vim.fn.confirm(message, '&Yes\n&No', 1)
  if choice == 1 then
    if #missing_deps > 0 then
      local cmd = 'flutter pub add ' .. table.concat(missing_deps, ' ')
      utils.run_command_in_terminal(cmd)
    end
    if #missing_dev_deps > 0 then
      local cmd = 'flutter pub add --dev ' .. table.concat(missing_dev_deps, ' ')
      utils.run_command_in_terminal(cmd)
    end
    utils.notify('Dependencies are being added. Please wait for completion before proceeding.', 'info')
    -- In a real scenario, you'd wait for the commands to finish.
    -- For this implementation, we assume the user will wait.
    return true
  else
    utils.notify('Dependency installation canceled. Aborting.', 'warn')
    return false
  end
end

return M
