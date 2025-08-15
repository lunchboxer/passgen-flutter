# Release Signing Configuration

This document explains how to set up release signing for the Passgen app.

## Keystore Generation

To generate a proper keystore for release signing, run the following command:

```
keytool -genkey -v -keystore passgen-release.keystore -alias passgen -keyalg RSA -keysize 2048 -validity 10000
```

This will create a keystore file that should be placed in the `android/app/keystore/` directory.

## Key Properties

The `key.properties` file contains the configuration for the keystore:

```
keyAlias=passgen
keyPassword=passgen123
storeFile=keystore/passgen-release.keystore
storePassword=passgen123
```

**Important:** In a real deployment, you should use strong passwords and keep the keystore file secure. Never commit the actual keystore file to version control.

## Build Process

To build a release version of the app:

```
flutter build apk --release
```

This will use the release signing configuration to sign the APK.