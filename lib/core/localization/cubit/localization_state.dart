import 'package:flutter/material.dart';

// Holds the current locale (language) of the app
class LocaleState {
  final Locale locale;

  const LocaleState({required this.locale});

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale: locale ?? this.locale);
  }
}
