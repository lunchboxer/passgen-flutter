# Code Linting and Formatting Rules

This document explains the linting and formatting rules used in the Passgen project.

## Overview

The Passgen project uses a comprehensive set of linting rules based on Flutter's recommended lints, with additional rules for stricter code quality enforcement. Code formatting follows the standard Dart formatter guidelines.

## Linting Rules

### Error Prevention Rules

These rules help prevent common programming errors:
- `avoid_empty_else`: Prevents empty else blocks
- `cancel_subscriptions`: Ensures subscriptions are cancelled
- `close_sinks`: Ensures sinks are closed properly
- `control_flow_in_finally`: Prevents control flow statements in finally blocks
- `hash_and_equals`: Ensures classes that override hashCode also override ==

### Style Rules

These rules enforce consistent coding style:
- `always_declare_return_types`: Functions must declare return types
- `annotate_overrides`: Override annotations must be used
- `camel_case_types`: Class names must be in camelCase
- `curly_braces_in_flow_control_structures`: Curly braces required in flow control
- `directives_ordering`: Import directives must be ordered correctly
- `file_names`: File names must be snake_case
- `omit_local_variable_types`: Omit types for local variables when possible
- `prefer_final_fields`: Fields that are not reassigned should be final
- `prefer_final_locals`: Local variables that are not reassigned should be final
- `sort_constructors_first`: Constructors should be sorted before other members
- `type_annotate_public_apis`: Public APIs should have type annotations

### Best Practices

These rules enforce Dart and Flutter best practices:
- `prefer_const_constructors`: Prefer const constructors
- `prefer_const_declarations`: Prefer const declarations
- `prefer_contains`: Use contains instead of indexOf
- `prefer_initializing_formals`: Use initializing formal parameters
- `prefer_is_empty`: Use isEmpty instead of length == 0
- `use_key_in_widget_constructors`: Use keys in widget constructors
- `use_rethrow_when_possible`: Use rethrow when possible

## Formatting Rules

The project uses the standard Dart formatter with these settings:
- Line length: 80 characters
- Indentation: 2 spaces
- Single quotes preferred for strings
- Trailing commas in collection literals when multiline

## Running Linting and Formatting

### Linting

To check for linting issues:

```bash
# Run Dart analyzer
dart analyze

# Or run Flutter analyzer
flutter analyze
```

### Formatting

To format code:

```bash
# Format all Dart files
dart format .

# Or use the project script
./tool/format.sh
```

### Automatic Fixing

Some linting issues can be automatically fixed:

```bash
# Fix formatting issues
dart format .

# Fix some linting issues (not all)
dart fix --apply
```

## Editor Integration

Most modern editors support automatic linting and formatting:

### VS Code

Install the Dart and Flutter extensions. The editor will:
- Show linting errors in real-time
- Format code on save (when enabled)
- Provide quick fixes for common issues

### IntelliJ/Android Studio

Install the Dart and Flutter plugins. The IDE will:
- Highlight linting issues
- Format code with Ctrl+Alt+L (Cmd+Alt+L on Mac)
- Provide intentions for quick fixes

## CI Integration

Linting and formatting checks are integrated into the CI pipeline to ensure:
- All code meets quality standards before merging
- Consistent style across the codebase
- Early detection of potential issues

## Custom Rules

The project enables a comprehensive set of rules beyond the standard Flutter lints. These include:
- Stricter type safety requirements
- Enhanced readability rules
- Performance optimization suggestions
- Better maintainability guidelines

## Disabling Rules

Rules should only be disabled when absolutely necessary. When disabling:
- Use `// ignore: rule_name` for single lines
- Use `// ignore_for_file: rule_name` for entire files
- Add a comment explaining why the rule is disabled

Example:
```dart
// ignore: avoid_print
print('Debug information'); // Only used in development
```

## Updating Rules

Linting rules can be updated by modifying `analysis_options.yaml`. When updating:
- Review the impact on existing code
- Ensure consistency with project goals
- Discuss changes with the team
- Update documentation accordingly