import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageService extends GetxService {
  static LanguageService get to => Get.find();
  
  final _currentLanguage = 'ar'.obs;
  
  String get currentLanguage => _currentLanguage.value;

  @override
  void onInit() {
    super.onInit();
    String lang = Get.deviceLocale?.languageCode ?? 'ar';
    if (lang != 'ar' && lang != 'en') {
      lang = 'ar'; // Default to Arabic
    }
    _currentLanguage.value = lang;
  }

  String getCurrentLanguage() {
    return _currentLanguage.value;
  }

  void changeLanguage(String languageCode) {
    _currentLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }
}