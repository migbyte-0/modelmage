local utils = require('modelmage.utils')
local config = require('modelmage.config')

local M = {}

--- Generates the Dart code for the Freezed model.
-- @param model_data table: The data collected from the UI.
-- @return string: The full content of the Dart file.
function M.generate_file_content(model_data)
  local class_name = model_data.class_name
  local model_name = class_name .. 'Model'
  local file_name = utils.snake_case(model_name) .. '.dart'
  local entity_name = class_name

  local imports = {
    "// ignore_for_file: invalid_annotation_target",
    "import 'package:freezed_annotation/freezed_annotation.dart';",
  }
  if config.options.custom_import then
    table.insert(imports, config.options.custom_import)
  end
  table.insert(imports, string.format("part '%s.freezed.dart';", utils.snake_case(model_name)))
  table.insert(imports, string.format("part '%s.g.dart';", utils.snake_case(model_name)))

  local params_list = {}
  local entity_fields_list = {}

  for _, p in ipairs(model_data.parameters) do
    local annotation = string.format("    @JsonKey(name: '%s') ", utils.snake_case(p.name))
    local required_keyword = p.optional and '' or 'required '
    local nullable_char = p.optional and '?' or ''

    local param_line = string.format("%s%s%s%s %s,", annotation, required_keyword, p.type, nullable_char, p.name)
    table.insert(params_list, param_line)

    local entity_field_line = string.format("      %s: %s,", p.name, p.name)
    table.insert(entity_fields_list, entity_field_line)
  end

  local template = [[
%s

@freezed
abstract class %s with _$%s {
  const %s._();

  const factory %s({
%s
  }) = _%s;

  factory %s.fromJson(Map<String, dynamic> json) =>
      _$%sFromJson(json);

  /// Converts the Data Transfer Object (Model) to a domain object (Entity).
  %s toEntity() {
    return %s(
%s
    );
  }
}
]]

  return string.format(
    template,
    table.concat(imports, '\n'),
    model_name, model_name,
    model_name,
    model_name,
    table.concat(params_list, '\n'),
    model_name,
    model_name,
    model_name,
    entity_name,
    entity_name,
    table.concat(entity_fields_list, '\n')
  )
end

return M
