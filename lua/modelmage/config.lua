local M = {}

-- Default configuration values
M.options = {
  -- A custom import line to be added to the generated file.
  -- Can be project-specific. Set to nil to disable.
  custom_import = "import '../../../features_exports.dart';",

  -- Whether to automatically run 'dart run build_runner build' after file creation.
  auto_run_build_runner = true,

  -- Directory to place the generated file, relative to the current file's directory.
  -- "." means the same directory.
  output_directory = ".",

  -- Short key mappings for data types.
  type_mappings = {
    s = 'String',
    i = 'int',
    d = 'double',
    b = 'bool',
    l = 'List', -- Will prompt for generic type e.g., List<String>
    m = 'Map', -- Will prompt for generic type e.g., Map<String, dynamic>
    dt = 'DateTime',
    o = 'Object',
  },

  -- The command to run for build_runner.
  build_runner_command = 'dart run build_runner build --delete-conflicting-outputs',
}

--- Merges user configuration with the default options.
-- @param user_config table: The configuration table provided by the user.
function M.setup(user_config)
  user_config = user_config or {}
  M.options = vim.tbl_deep_extend('force', M.options, user_config)
end

return M
