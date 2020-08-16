import 'package:beam/features/presentation/onboarding/habits_page.dart';
import 'package:beam/l10n/messages_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final String localeName;

  AppLocalizations(this.localeName);

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      return AppLocalizations(localeName);
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'Beam Project',
      name: 'title',
      desc: 'Title for the Beam Project',
      locale: localeName,
    );
  }

  String get donationsContent {
    return Intl.message(
      'Donate to charities as you develop good habits',
      name: 'donationsContent',
      desc: 'Description of donating to charities',
      locale: localeName,
    );
  }

  String get habitsContent {
    return Intl.message(
      'Develop good habits while reducing the bad ones',
      name: 'habitsContent',
      desc: 'Description of developing habits',
      locale: localeName,
    );
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
