# qurbanqu

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

qurbanqu/
|-- lib/
    |-- main.dart
    |-- firebase_options.dart
    |-- constants/
    |   |-- colors.dart
    |   |-- styles.dart
    |
    |-- models/
    |   |-- user_model.dart
    |   |-- kurban_model.dart
    |   |-- order_model.dart
    |
    |-- services/
    |   |-- auth_service.dart
    |   |-- database_service.dart
    |
    |-- screens/
    |   |-- auth/
    |   |   |-- login_screen.dart
    |   |   |-- register_screen.dart
    |   |
    |   |-- user/
    |   |   |-- home_screen.dart
    |   |   |-- profile_screen.dart
    |   |   |-- kurban_detail_screen.dart
    |   |   |-- order_history_screen.dart
    |   |
    |   |-- admin/
    |       |-- admin_dashboard.dart
    |       |-- manage_kurban_screen.dart
    |       |-- add_edit_kurban_screen.dart
    |
    |-- widgets/
        |-- kurban_card.dart
        |-- order_item.dart
        |-- custom_button.dart