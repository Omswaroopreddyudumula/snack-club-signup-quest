# Snack Club

**Om Swaroop Reddy Udumula**  
MAD 4360 — Activity 10: Flutter Signup Form Quest  
Undergraduate track: signup form and Task A

## About

Snack Club is a Flutter signup form with an orange theme and a cookie icon. The form checks a full name, email address, and password before showing a green success message. This is a demo; it does not create accounts or save credentials.

## Form validation

- Full name: required; spaces alone are rejected.
- Email: required and checked for a basic email format.
- Password: required, at least six characters, and cannot contain only spaces. Characters are hidden, with autocorrect and suggestions disabled.

## Task A: Signup tips

The **Get a signup tip** button uses the fixed `password_help` category. Three stored tips appear in order and repeat after the third tip. A short loading state disables the button while the next tip is selected. Each tip is plain text under 240 characters. This runs locally without a network request.

## Run

Install Flutter and configure an Android device or emulator, then run:

```sh
flutter pub get
flutter run
```

## Tests

```sh
flutter analyze
flutter test
```

Widget tests cover required fields, invalid email, password length, successful signup, tip loading and order, disposing the page during loading, and scrolling with a keyboard inset.

To run the Android signup and tip smoke test, replace `emulator-5554` with the device ID shown by `flutter devices`:

```sh
flutter test integration_test/app_test.dart -d emulator-5554
```

## Build APK

```sh
flutter build apk --debug
```

The APK is created at `build/app/outputs/flutter-apk/app-debug.apk`.

## Implementation

The signup page is a StatefulWidget with a Form and GlobalKey. TextEditingControllers hold the field values and are disposed when the page closes. SafeArea and SingleChildScrollView keep the form usable with the keyboard open. A counter selects the next tip, and a mounted check prevents updating the page after it closes.

Repository: https://github.com/Omswaroopreddyudumula/snack-club-signup-quest
