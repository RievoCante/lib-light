// Localization support for English and Thai
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  late Map<String, String> _localizedStrings;
  late Map<String, dynamic> _localizedValues;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Future<bool> load() async {
    final jsonString = await rootBundle.loadString(
      'lib/localization/${locale.languageCode}.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Store raw values for arrays
    _localizedValues = jsonMap;

    // Store string values for regular translations
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Convenience getters
  String get appName => translate('app_name');
  String get home => translate('home');
  String get buySell => translate('buy_sell');
  String get portfolio => translate('portfolio');
  String get content => translate('content');
  String get you => translate('you');
  String get login => translate('login');
  String get logout => translate('logout');
  String get username => translate('username');
  String get password => translate('password');
  String get rememberMe => translate('remember_me');
  String get forgotPassword => translate('forgot_password');
  String get calendar => translate('calendar');
  String get today => translate('today');
  String get corporateActions => translate('corporate_actions');
  String get thaiStock => translate('thai_stock');
  String get usStock => translate('us_stock');
  String get mutualFund => translate('mutual_fund');
  String get buy => translate('buy');
  String get sell => translate('sell');
  String get volume => translate('volume');
  String get inPort => translate('in_port');
  String get price => translate('price');
  String get limit => translate('limit');
  String get conditional => translate('conditional');
  String get pin => translate('pin');
  String get clear => translate('clear');
  String get high => translate('high');
  String get low => translate('low');
  String get open => translate('open');
  String get previousClose => translate('previous_close');
  String get ceiling => translate('ceiling');
  String get floor => translate('floor');
  String get bids5 => translate('bids_5');
  String get bids10 => translate('bids_10');
  String get bid => translate('bid');
  String get offer => translate('offer');
  String get tradingAccount => translate('trading_account');
  String get lineAvailable => translate('line_available');
  String get cashBalance => translate('cash_balance');
  String get order => translate('order');
  String get summary => translate('summary');
  String get allPort => translate('all_port');
  String get symbol => translate('symbol');
  String get avg => translate('avg');
  String get market => translate('market');
  String get uplPercent => translate('upl_percent');
  String get total => translate('total');
  String get shareAll => translate('share_all');
  String get search => translate('search');
  String get popular => translate('popular');
  String get breaking => translate('breaking');
  String get research => translate('research');
  String get readMore => translate('read_more');
  String get setting => translate('setting');
  String get language => translate('language');
  String get english => translate('english');
  String get thai => translate('thai');
  String get darkTheme => translate('dark_theme');
  String get orderEntry => translate('order_entry');
  String get others => translate('others');
  String get eService => translate('e_service');
  String get contactUs => translate('contact_us');
  String get privacyPolicy => translate('privacy_policy');
  String get logoutConfirmation => translate('logout_confirmation');
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get noData => translate('no_data');
  String get noCorporateActions => translate('no_corporate_actions');
  String get emptyPortfolio => translate('empty_portfolio');
  String get startTrading => translate('start_trading');
  String get noNews => translate('no_news');
  String get thaiNotice => translate('thai_notice');
  String get volumePlaceholder => translate('volume_placeholder');
  String get pricePlaceholder => translate('price_placeholder');
  String get pinPlaceholder => translate('pin_placeholder');
  String get testing => translate('testing');
  String get register => translate('register');
  String get supportChat => translate('support_chat');
  String get viewChatHistory => translate('view_chat_history');
  String get recentOrders => translate('recent_orders');
  String get searchOrAsk => translate('search_or_ask');
  String get solved => translate('solved');
  String get unsolved => translate('unsolved');

  // Get FAQ questions as list
  List<String> get faqQuestions {
    final value = _localizedValues['faq_questions'];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool get isThaiLanguage => locale.languageCode == 'th';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'th'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
