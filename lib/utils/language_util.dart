import '../services/language_service.dart';

class LanguageUtil {
  static void toggleLanguage() {
    String currentLang = LanguageService.to.currentLanguage;
    String newLang = currentLang == 'ar' ? 'en' : 'ar';
    LanguageService.to.changeLanguage(newLang);
  }
}