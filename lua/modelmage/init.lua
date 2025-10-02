-- lua/modelmage/init.lua

local config = require('modelmage.config')
local handlers = require('modelmage.handlers')

local M = {}

--- The main setup function for the plugin.
-- Users will call this in their Neovim config.
-- @param user_config table: A table of user-provided configuration options.
function M.setup(user_config)
  config.setup(user_config)
end

--- The primary function to start the model generation process.
-- This is what the user command will call.
function M.generate_model()
  handlers.start_generation_flow()
end

return M
