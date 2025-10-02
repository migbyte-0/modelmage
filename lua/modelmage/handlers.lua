local ui = require('modelmage.ui')
local pubspec = require('modelmage.pubspec')
local generator = require('modelmage.generator')
local utils = require('modelmage.utils')
local config = require('modelmage.config')

local M = {}

--- The main function that controls the entire generation flow.
function M.start_generation_flow()
  -- 1. Get model details from the user via the UI
  local model_data = ui.get_model_details()
  if not model_data then
    return -- User canceled
  end

  -- 2. Check dependencies in pubspec.yaml
  local deps_ok = pubspec.check_and_install_deps()
  if not deps_ok then
    return -- User canceled or error
  end

  -- 3. Generate the file content
  local file_content = generator.generate_file_content(model_data)

  -- 4. Determine file path and write the file
  local file_name = utils.snake_case(model_data.class_name .. 'Model') .. '.dart'
  local current_dir = vim.fn.expand('%:p:h')
  local output_dir = config.options.output_directory
  local target_path = current_dir .. '/' .. (output_dir ~= '.' and output_dir .. '/' or '') .. file_name

  local success = utils.write_file(target_path, file_content)
  if not success then
    utils.notify('Failed to write model file at: ' .. target_path, 'error')
    return
  end

  utils.notify('Successfully created model file: ' .. file_name, 'info')
  vim.cmd('edit ' .. target_path) -- Open the newly created file

  -- 5. Run build_runner if configured
  if config.options.auto_run_build_runner then
    utils.notify('Running build_runner...', 'info')
    utils.run_command_in_terminal(config.options.build_runner_command)
  end
end

return M
