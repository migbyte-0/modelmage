local utils = require('modelmage.utils')
local config = require('modelmage.config')

local M = {}

local function get_type_hint()
  local hints = {}
  for k, v in pairs(config.options.type_mappings) do
    table.insert(hints, string.format('%s: %s', k, v))
  end
  return table.concat(hints, ', ')
end

--- Prompts the user for input with a message.
-- @param prompt string: The message to show the user.
-- @param default string (optional): The default value for the input.
-- @return string or nil: The user's input, or nil if they canceled.
local function get_input(prompt, default)
  return vim.fn.input({
    prompt = prompt .. '\n> ',
    default = default or '',
    completion = nil,
    cancelreturn = 'cancel',
  })
end

--- Gathers all necessary information from the user to build the model.
-- @return table or nil: A table with model info, or nil if canceled.
function M.get_model_details()
  utils.notify('🧙 ModelMage Wizard Started', 'info')

  -- 1. Get Class Name
  local class_name = get_input('Enter the Class Name (e.g., AppInfo)')
  if class_name == 'cancel' or class_name == '' then
    utils.notify('Model generation canceled.', 'warn')
    return nil
  end
  -- PascalCase the class name
  class_name = class_name:sub(1, 1):upper() .. class_name:sub(2)

  -- 2. Get Number of Parameters
  local num_params_str = get_input('How many parameters does it have?')
  if num_params_str == 'cancel' then
    utils.notify('Model generation canceled.', 'warn')
    return nil
  end
  local num_params = tonumber(num_params_str)
  if not num_params or num_params <= 0 then
    utils.notify('Invalid number of parameters. Aborting.', 'error')
    return nil
  end

  -- 3. Loop to get each parameter's details
  local params = {}
  for i = 1, num_params do
    utils.notify(string.format('Enter details for Parameter %d of %d', i, num_params), 'info')

    local param_name = get_input(string.format('[%d/%d] Parameter Name (camelCase)', i, num_params))
    if param_name == 'cancel' or param_name == '' then
      utils.notify('Model generation canceled.', 'warn')
      return nil
    end

    local type_key = get_input(string.format('[%d/%d] Data Type (%s)', i, num_params, get_type_hint()))
    if type_key == 'cancel' then
      utils.notify('Model generation canceled.', 'warn')
      return nil
    end
    local param_type = config.options.type_mappings[type_key]
    if not param_type then
      utils.notify(string.format('Invalid type key "%s". Aborting.', type_key), 'error')
      return nil
    end

    -- Handle generic types like List<T>
    if param_type == 'List' then
      local generic_type_key = get_input(string.format('[%d/%d] Enter type for List<T> (e.g., s for String)', i, num_params))
      local generic_type = config.options.type_mappings[generic_type_key] or 'dynamic'
      param_type = string.format('List<%s>', generic_type)
    end
    if param_type == 'Map' then
        param_type = 'Map<String, dynamic>'
    end

    local nullability = get_input(string.format('[%d/%d] Is it Optional/Nullable? (o) or Required? (r)', i, num_params), 'r')
    if nullability == 'cancel' then
      utils.notify('Model generation canceled.', 'warn')
      return nil
    end
    local is_optional = (nullability:lower() == 'o')

    table.insert(params, {
      name = param_name,
      type = param_type,
      optional = is_optional,
    })
  end

  return {
    class_name = class_name,
    parameters = params,
  }
end

return M
