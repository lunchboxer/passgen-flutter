#!/bin/bash

# Script to format all Dart files in the project
# Uses dart format command which is part of the Dart SDK

echo "Formatting Dart files..."

# Format all Dart files in lib, test, and tool directories
find lib test tool -name "*.dart" -exec dart format {} \;

echo "Formatting completed."