// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Skip`
  String get skip {
    return Intl.message('Skip', name: 'skip', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Start Now`
  String get start {
    return Intl.message('Start Now', name: 'start', desc: '', args: []);
  }

  /// `With You Every Step`
  String get onboardingTitle1 {
    return Intl.message(
      'With You Every Step',
      name: 'onboardingTitle1',
      desc: '',
      args: [],
    );
  }

  /// `Whether you are just starting or have been managing your Jameya for a while, you will find everything you need clearly and simply. Our goal is to make saving easier, faster, and hassle-free.`
  String get onboardingSubtitle1 {
    return Intl.message(
      'Whether you are just starting or have been managing your Jameya for a while, you will find everything you need clearly and simply. Our goal is to make saving easier, faster, and hassle-free.',
      name: 'onboardingSubtitle1',
      desc: '',
      args: [],
    );
  }

  /// `All Your Jameya Details in One Place`
  String get onboardingTitle2 {
    return Intl.message(
      'All Your Jameya Details in One Place',
      name: 'onboardingTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Don't worry about payment dates or tracking your turn. The app will help you easily track everything, from the first payment to the last update in your Jameya.`
  String get onboardingSubtitle2 {
    return Intl.message(
      'Don\'t worry about payment dates or tracking your turn. The app will help you easily track everything, from the first payment to the last update in your Jameya.',
      name: 'onboardingSubtitle2',
      desc: '',
      args: [],
    );
  }

  /// `Let Your Savings Grow With You`
  String get onboardingTitle3 {
    return Intl.message(
      'Let Your Savings Grow With You',
      name: 'onboardingTitle3',
      desc: '',
      args: [],
    );
  }

  /// `Every small step counts, and every amount you save gets you closer to your goals. With Jameya, you can easily track your savings journey.`
  String get onboardingSubtitle3 {
    return Intl.message(
      'Every small step counts, and every amount you save gets you closer to your goals. With Jameya, you can easily track your savings journey.',
      name: 'onboardingSubtitle3',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
