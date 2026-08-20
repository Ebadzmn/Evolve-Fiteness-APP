import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(Get.locale ?? const Locale('en'));

  void toggleLocale() {
    final nextLocale = state.languageCode == 'en'
        ? const Locale('de')
        : const Locale('en');
    _setLocale(nextLocale);
  }

  void setLocale(Locale locale) {
    _setLocale(locale);
  }

  void _setLocale(Locale locale) {
    if (locale == state) {
      return;
    }

    // Keep GetX and the bloc in sync so runtime localization updates propagate
    // through the app shell and all localized widgets rebuild correctly.
    Get.updateLocale(locale);
    emit(locale);
  }
}
