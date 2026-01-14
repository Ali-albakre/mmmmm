# Google Drive Backup Setup

This app uses Google Drive to upload daily JSON backups. You must configure
OAuth credentials for your app package before sign-in will work.

## 1) Enable Drive API
- Create a Google Cloud project.
- Enable "Google Drive API" for the project.
- Configure the OAuth consent screen.

## 2) Create OAuth Client IDs
### Android
- Create an OAuth client for Android.
- Use your package name and SHA-1 certificate fingerprint.

### iOS
- Create an OAuth client for iOS.
- Use your bundle ID and Team ID.

## 3) Install google-services (Android)
- Download `google-services.json`.
- Place it in `android/app/`.
- Ensure your `applicationId` matches the OAuth client package name.

## 4) Add URL schemes (iOS)
- Download `GoogleService-Info.plist`.
- Place it in `ios/Runner/`.
- Ensure the URL scheme matches the OAuth client.

## 5) Test
- Open Settings → Backup.
- Connect Google Drive.
- Tap "Backup now".

The app will automatically upload one backup per day when enabled.
