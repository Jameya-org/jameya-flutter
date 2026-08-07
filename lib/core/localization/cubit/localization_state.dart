import 'package:flutter/material.dart';

// Holds the current locale (language) of the app
class LocaleState {
  const LocaleState({required this.locale});
  final Locale locale;

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}
