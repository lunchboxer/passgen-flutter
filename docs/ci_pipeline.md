# CI Pipeline Documentation

This document explains the continuous integration (CI) pipeline for the Passgen project.

## Overview

The CI pipeline is implemented using GitHub Actions and consists of several jobs that run on every push to the main branch and on every pull request. The pipeline ensures code quality, runs tests, and verifies that the application builds correctly.

## Pipeline Structure

The CI pipeline consists of the following jobs:

### 1. Test Job

This job runs all tests in the project:
- Unit tests
- Widget tests
- Core component tests
- Integration tests
- UI component tests
- Model tests
- Performance tests (as regular tests)

It also performs code analysis and formatting checks.

### 2. Build Job

This job builds the application for different platforms:
- Android APK (debug build)
- Web version

It runs after the test job succeeds.

### 3. Lint Job

This job runs the Flutter analyzer to check for linting issues.

### 4. Format Job

This job checks that the code is properly formatted according to Dart formatting standards.

### 5. Benchmark Job

This optional job runs performance benchmarks. It only runs on pushes to the main branch, not on pull requests.

## Workflow Triggers

The CI pipeline is triggered by:
- Pushes to the main branch
- Pull requests targeting the main branch

## Jobs Dependencies

```
test → build
   ↘
lint → (no downstream jobs)
   ↘
format → (no downstream jobs)

benchmark (runs independently, only on main branch)
```

## Environment

All jobs run on Ubuntu virtual machines with the following setup:
- Java 17 (Temurin distribution)
- Flutter 3.27.0 (stable channel)
- Dart SDK version matching Flutter

## Steps in Each Job

### Test Job Steps:
1. Checkout code
2. Setup Java
3. Setup Flutter SDK
4. Verify Flutter installation with `flutter doctor`
5. Install dependencies with `flutter pub get`
6. Check code formatting with `dart format`
7. Analyze code with `dart analyze`
8. Run various test suites:
   - Unit tests with coverage
   - Widget tests
   - Core component tests
   - Integration tests
   - UI component tests
   - Model tests
   - Performance tests

### Build Job Steps:
1. Checkout code
2. Setup Java
3. Setup Flutter SDK
4. Install dependencies
5. Build Android APK (debug)
6. Build Web version
7. Archive build artifacts

### Lint Job Steps:
1. Checkout code
2. Setup Flutter SDK
3. Install dependencies
4. Run Flutter analyzer

### Format Job Steps:
1. Checkout code
2. Setup Flutter SDK
3. Check code formatting

### Benchmark Job Steps:
1. Checkout code
2. Setup Flutter SDK
3. Install dependencies
4. Run performance benchmarks individually

## Configuration Files

The CI pipeline is configured in `.github/workflows/ci.yml`. This file defines all jobs, their steps, and their dependencies.

## Adding New Tests

To add new tests to the CI pipeline:

1. Place test files in the appropriate directory under `test/`
2. If needed, update the CI workflow file to include new test commands
3. Ensure tests can run in a headless Linux environment

## Customization

The CI pipeline can be customized by modifying `.github/workflows/ci.yml`:

- To change Flutter version: Update the `flutter-version` in the Flutter setup steps
- To add new jobs: Add new job definitions following the existing pattern
- To modify triggers: Update the `on` section at the beginning of the file
- To add/remove test suites: Modify the test steps in the test job

## Secrets and Environment Variables

Currently, the pipeline doesn't require any secrets or environment variables. If needed in the future, they can be added through the GitHub repository settings.

## Artifacts

The build job archives the following artifacts:
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

## Extending the Pipeline

To extend the pipeline with additional checks:

1. Add new jobs following the existing pattern
2. Define appropriate dependencies using the `needs` keyword
3. Use existing actions where possible for common tasks
4. Add conditional execution where appropriate using the `if` keyword

## Monitoring

Pipeline runs can be monitored through:
- GitHub Actions tab in the repository
- Email notifications (if configured)
- Status badges in README (if added)

## Performance Considerations

- Jobs run in parallel where possible to reduce total pipeline time
- The benchmark job only runs on main branch pushes to avoid unnecessary resource usage
- Test jobs are split by category to allow for selective re-running if needed