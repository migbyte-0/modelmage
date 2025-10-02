# ModelMage.nvim 🧙✨

Magically generate Flutter Freezed models directly within Neovim.

ModelMage is a helper plugin that automates the creation of `freezed` data models in your Flutter projects. It provides an interactive UI to define your class and its properties, checks for necessary dependencies, and even runs `build_runner` for you.

## Features

-   **Interactive UI**: A floating window guides you through creating your model.
-   **Dependency Management**: Automatically checks `pubspec.yaml` for required packages (`freezed`, `json_serializable`, etc.) and offers to add them for you.
-   **Code Generation**: Creates a complete, well-formatted Dart file with your `freezed` model.
-   **Build Runner Integration**: Can automatically run the `build_runner` command after file creation.
-   **Highly Configurable**: Customize data type shortcuts, output paths, and more.

## Installation

Using `lazy.nvim`:

```lua
{
  'your-username/modelmage.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' }, -- Optional, but recommended for some utilities
  config = function()
    require('modelmage').setup({
      -- Your custom configuration here
      custom_import = "import '../../../features_exports.dart';", -- Example
    })
  end,
}
