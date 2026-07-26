import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:jameya/core/cache/cache_key.dart';
import 'package:jameya/core/localization/cubit/localization_state.dart';

import '../../../../core/cache/cache_helper.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._cacheHelper)
    : super(const LocaleState(locale: Locale('en')));

  final CacheHelper _cacheHelper;

  /// load saved language
  void loadSavedLanguage() {
    final languageCode =
        _cacheHelper.getString(key: CacheKey.languageCode) ?? 'en';

    emit(LocaleState(locale: Locale(languageCode)));
  }

  /// Switch Language
  Future<void> changeLanguage(String languageCode) async {
    await _cacheHelper.saveData(
      key: CacheKey.languageCode,
      value: languageCode,
    );

    emit(LocaleState(locale: Locale(languageCode)));
  }

  bool get isArabic => state.locale.languageCode == 'ar';

  Future<void> toggleLanguage() async {
    if (isArabic) {
      await changeLanguage('en');
    } else {
      await changeLanguage('ar');
    }
  }
}
