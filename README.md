
-----

Done by **Migbyte** Team

# ModelMage.nvim

🪄 **Model + Mage = ModelMage**
Magically generate your Flutter Freezed models directly within Neovim\!

```
                                  / \
                                 /   \
                                /     \
                               /       \
                              /_________\
                             (____/ \____)
                              (  /   \  )
                              / /     \ \
                             / /       \ \
                            ( (         ) )
                            / /         \ \
                           /_____________ \
                          / / \       / \ \ \
                         / /   \     /   \ \ \
                        ( (     )   (     ) ) )
                         \ \   /     \   / / /
                          \ \ /_______\ / / /
                           \___________/ /
                            /    |   |    \
                           /     |   |     \
                          /      |   |      \
                         (_______|___|_______)
                          (_________________)
```

```
      ___           ___                       ___           ___     
     /\  \         /\  \          ___        /\  \         /\__\    
    /::\  \       /::\  \        /\  \      /::\  \       /:/ _/_   
   /:/\ \  \     /:/\:\  \       \:\  \    /:/\:\  \     /:/ /\  \  
  _\:\~\ \  \   /::\~\:\  \      /::\__\  /::\~\:\  \   /:/ /::\  \ 
 /\ \:\ \ \__\ /:/\:\ \:\__\  __/:/\/__/ /:/\:\ \:\__\ /:/_/:/\:\__\
 \:\ \:\ \/__/ \/__\:\/:/  / /\/:/  /    \:\~\:\ \/__/ \:\/:/ /:/  /
  \:\ \:\__\        \::/  /  \::/__/      \:\ \:\__\    \::/ /:/  / 
   \:\/:/  /        /:/  /    \:\__\       \:\/:/  /     \/_/:/  /  
    \::/  /        /:/  /      \/__/        \::/  /        /:/  /   
     \/__/         \/__/                     \/__/         \/__/    
```

### Table of Contents 📜

  * [Why ModelMage?](https://www.google.com/search?q=%23why-modelmage)
  * [Features](https://www.google.com/search?q=%23features)
  * [Screenshots](https://www.google.com/search?q=%23screenshots)
  * [Installation](https://www.google.com/search?q=%23installation)
  * [Usage](https://www.google.com/search?q=%23usage)
  * [Configuration](https://www.google.com/search?q=%23configuration)
  * [Dependencies](https://www.google.com/search?q=%23dependencies)
  * [Advanced Topics](https://www.google.com/search?q=%23advanced-topics)
      * [Customizing Type Mappings](https://www.google.com/search?q=%23customizing-type-mappings)
      * [Understanding the `toEntity()` Method](https://www.google.com/search?q=%23understanding-the-toentity-method)
  * [License](https://www.google.com/search?q=%23license)

### Why ModelMage?

💡 **ModelMage.nvim** saves you from the tedious and error-prone task of writing boilerplate for `freezed` data models. It accelerates your Flutter development by automating the entire creation process from start to finish.

With **ModelMage**, you can:
⚡️ Interactively generate complete `freezed` models in seconds.
🐍 Automatically create snake\_case `@JsonKey` annotations to prevent typos.
📦 Check your `pubspec.yaml` for necessary dependencies and offer to add them.
🏃‍♂️ Run `build_runner` automatically after file creation.
🚀 Focus on writing logic, not boilerplate.

### Features

🧙‍♂️ **Interactive Wizard**
A step-by-step command-line interface guides you through defining your model's name, parameters, data types, and nullability.

📦 **Dependency Management**
Automatically checks for `freezed_annotation`, `json_serializable`, and `build_runner`, and can add them to your `pubspec.yaml` if they are missing.

✍️ **Smart Generation**
Generates everything you need:

  * The `freezed` factory constructor.
  * The `fromJson` factory for JSON deserialization.
  * A `toEntity` method for clean architecture principles.
  * Correct `part` directives for generated files.

🛠️ **Customizable Templates**
Easily configure a custom import line (e.g., for a shared `exports.dart` file) to match your project's architecture.

### Screenshots

Here are some simulations of the **ModelMage.nvim** workflow:

✨ **Step 1: The wizard asks for the class name and parameter count.**

```
[ModelMage] 🧙 ModelMage Wizard Started
Enter the Class Name (e.g., AppInfo)
> UserProfile
How many parameters does it have?
> 3
```

📝 **Step 2: It prompts for each parameter's details.**

```
[ModelMage] Enter details for Parameter 1 of 3
[1/3] Parameter Name (camelCase)
> userId
[1/3] Data Type (s: String, i: int, d: double, b: bool, l: List, m: Map, dt: DateTime, o: Object)
> s
[1/3] Is it Optional/Nullable? (o) or Required? (r)
> r
```

🪄 **Step 3: The final generated model file.**

```dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../features_exports.dart';
part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
abstract class UserProfileModel with _$UserProfileModel {
  const UserProfileModel._();

  const factory UserProfileModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserProfileModel;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts the Data Transfer Object (Model) to a domain object (Entity).
  UserProfile toEntity() {
    return UserProfile(
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
    );
  }
}
```

### Installation

Install using **`lazy.nvim`** or your preferred plugin manager:

```lua
{
  "migbyte-0/modelmage.nvim",
  config = function()
    require("modelmage").setup({
      -- Your custom configuration can go here. For example:
      custom_import = "import '../../../features_exports.dart';",
      auto_run_build_runner = true,
    })
  end,
  -- Optional: Define a keymap for easy access
  keys = {
    { "<leader>mm", function() require("modelmage").generate_model() end, desc = "[M]odel [M]age" },
  }
}
```

Alternatively, with **`packer.nvim`**:

```lua
use {
  "migbyte-0/modelmage.nvim",
  config = function()
    require("modelmage").setup()
  end,
}
```

### Usage

1.  Run `:ModelMageGenerate` or use the keybinding (`<leader>mm` in the example above).
2.  Follow the interactive prompts in the command line.
3.  Enter your class name and parameter details.
4.  Watch ModelMage create the file and run `build_runner` for you\! 🎉

### Configuration

You can customize ModelMage.nvim by passing options to the `setup` function:

| Option                  | Default                                                              | Description                                                                     |
| ----------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `custom_import`         | `import '../../../features_exports.dart';`                           | A custom import line to add to the top of the file. Set to `nil` to disable.    |
| `auto_run_build_runner` | `true`                                                               | Automatically run `build_runner` after the file is created.                     |
| `output_directory`      | `.`                                                                  | The directory to save the file in, relative to the current buffer's directory.  |
| `type_mappings`         | `{ s = 'String', i = 'int', ... }`                                   | A table of shortcuts for Dart data types used in the wizard.                    |
| `build_runner_command`  | `dart run build_runner build --delete-conflicting-outputs`           | The exact command to execute for `build_runner`.                                |

### Dependencies

  * **Neovim** (`>= 0.8.0`)
  * **Flutter SDK** (for the `dart` and `flutter` executables)

### Advanced Topics

#### 📂 Customizing Type Mappings

You can extend the `type_mappings` table in your setup to add shortcuts for your own custom types or frequently used types. For example, to add a shortcut for `Uri`:

```lua
require("modelmage").setup({
  type_mappings = {
    s = 'String',
    i = 'int',
    -- ... other defaults
    u = 'Uri', -- Your custom addition
  },
})
```

Now, when the wizard asks for a data type, you can simply enter `u`.

#### 🔌 Understanding the `toEntity()` Method

ModelMage automatically generates a `toEntity()` method to help you follow Clean Architecture principles. This method converts the Data Transfer Object (the `Model` used for parsing JSON) into a pure domain object (the `Entity`). This practice decouples your application's core business logic from the data layer, making your code more robust and testable.

### License

ModelMage.nvim is distributed under the **MIT License**.

> MIT License
>
> Copyright (c) 2025 Migbyte
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> ...

-----

### Start Conjuring Your Models Today\! 🚀

Feel free to open PRs, issues, or share your feedback. Together, let’s make Flutter development even more magical\!

**ModelMage on\!** 🎨✨
