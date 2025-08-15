# Continuous Integration (CI) Pipeline

This document explains the CI pipeline configuration for the Passgen project.

## Overview

The CI pipeline is implemented using GitHub Actions and automatically runs on every push to the main branch and every pull request targeting the main branch. It ensures code quality, runs tests, and verifies that the application builds correctly.

## Pipeline Configuration

The CI pipeline is configured in `.github/workflows/ci.yml`. This file defines all jobs, their steps, and their dependencies.

## Pipeline Structure

The CI pipeline consists of multiple jobs that can run sequentially or in parallel:

### 1. Analyze Job

This job checks code formatting and runs static analysis:
- Verifies Flutter installation
- Checks for any formatting issues using `dart format`
- Statically analyzes the Dart code for any errors using `dart analyze`

### 2. Test Job

This job runs all unit, widget, and integration tests:
- Runs widget tests
- Runs core component tests
- Runs model tests
- Runs UI component tests
- Runs UI screen tests
- Runs integration tests

### 3. Performance Job

This job runs performance benchmarks:
- Runs all performance tests in the `test/performance` directory

### 4. Build Job

This job builds the application for different platforms:
- Builds Android APK (debug build)
- Builds web version

### 5. Security Job

This job runs security-related tests:
- Runs word list integrity verification tests

## Trigger Events

The CI pipeline is triggered by:
- Pushes to the main branch
- Pull requests targeting the main branch
- Manual triggers from the GitHub Actions tab

## Environment

All jobs run on Ubuntu virtual machines with the following setup:
- Java 17 (Temurin distribution)
- Flutter 3.27.0 (stable channel)
- Dart SDK version matching Flutter

## Dependencies

The pipeline automatically installs all project dependencies using `flutter pub get`.

## Customization

The CI pipeline can be customized by modifying `.github/workflows/ci.yml`:
- To change Flutter version: Update the `flutter-version` in the Flutter setup step
- To add new jobs: Add new job definitions following the existing pattern
- To modify triggers: Update the `on` section at the beginning of the file
- To add/remove test suites: Modify the test steps in the test job

## Secrets and Environment Variables

Currently, the pipeline doesn't require any secrets or environment variables. If needed in the future, they can be added through the GitHub repository settings.

## Artifacts

The build job creates the following artifacts:
- Android APK (debug build)
- Web build output

These can be downloaded from the GitHub Actions run page.

## Troubleshooting

Common issues and solutions:

1. **Flutter version mismatch**: Ensure the Flutter version in the workflow matches the project requirements
2. **Dependency issues**: Run `flutter pub get` locally and check in any updated lock files
3. **Test failures**: Run tests locally with the same commands used in CI
4. **Formatting issues**: Run `dart format .` locally to format code before committing
5. **Analysis issues**: Run `dart analyze` locally to check for linting issues
6. **Build failures**: Ensure all dependencies are correctly specified in `pubspec.yaml`

## Extending the Pipeline

To extend the pipeline with additional checks:

1. Add new steps following the existing pattern
2. Use existing actions where possible for common tasks
3. Add conditional execution where appropriate using the `if` keyword

## Monitoring

Pipeline runs can be monitored through:
- GitHub Actions tab in the repository
- Email notifications (if configured)
- Status badges in README (if added)

## Performance Considerations

- The pipeline runs all tests and builds in parallel where possible to reduce total execution time
- Caching mechanisms are used to speed up dependency installation
- Only debug builds are created to reduce build time

## Best Practices

1. **Fast Feedback**: The pipeline is designed to provide fast feedback on code changes
2. **Reliability**: All steps are deterministic and should produce consistent results
3. **Comprehensiveness**: The pipeline covers all aspects of code quality, testing, and building
4. **Maintainability**: The pipeline configuration is kept simple and well-documented