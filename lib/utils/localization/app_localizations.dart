import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('hi'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'profile.guestUser': 'Guest User',
      'profile.noEmail': 'No email provided',
      'profile.section.account': 'Account',
      'profile.section.orders': 'Orders',
      'profile.section.settings': 'Settings',
      'profile.section.support': 'Support',
      'profile.editProfile': 'Edit Profile',
      'profile.editProfileSubtitle': 'Update your information',
      'profile.addresses': 'Addresses',
      'profile.addressesSubtitle': 'Manage shipping addresses',
      'profile.paymentMethods': 'Payment Methods',
      'profile.paymentMethodsSubtitle': 'Manage your cards',
      'profile.myOrders': 'My Orders',
      'profile.ordersWithCount': 'You have {count} orders',
      'profile.noOrders': 'No orders yet',
      'profile.wishlist': 'Wishlist',
      'profile.wishlistSubtitle': 'Your saved items',
      'profile.reviews': 'Reviews',
      'profile.reviewsSubtitle': 'Your product reviews',
      'profile.notifications': 'Notifications',
      'profile.notificationsSubtitle': 'Manage notification preferences',
      'profile.language': 'Language',
      'profile.darkMode': 'Dark Mode',
      'profile.darkModeSubtitle': 'Switch theme appearance',
      'profile.helpCenter': 'Help Center',
      'profile.helpCenterSubtitle': 'FAQs and support',
      'profile.privacyPolicy': 'Privacy Policy',
      'profile.privacyPolicySubtitle': 'View our privacy policy',
      'profile.terms': 'Terms & Conditions',
      'profile.termsSubtitle': 'View terms of service',
      'profile.personalInfo': 'Personal Information',
      'profile.profileUpdateSubtitle':
          'Keep your details updated for a seamless experience',
      'profile.fullNameLabel': 'Full Name',
      'profile.emailLabel': 'Email Address',
      'profile.phoneLabel': 'Phone Number',
      'profile.locationLabel': 'Location',
      'profile.profileInfoHelper':
          'Your personal information helps us tailor recommendations and keep your account secure.',
      'profile.saveChanges': 'Save Changes',
      'profile.profileUpdated': 'Profile details saved successfully!',
      'profile.addAddressCta': 'Add New Address',
      'profile.remove': 'Remove',
      'profile.primaryBadge': 'Primary',
      'profile.addPaymentMethodCta': 'Add Payment Method',
      'profile.expiryLabel': 'Expiry',
      'profile.cardHolderLabel': 'Cardholder',
      'profile.logout': 'Logout',
      'profile.logoutConfirmTitle': 'Confirm Logout',
      'profile.logoutConfirmMessage': 'Are you sure you want to logout?',
      'profile.cancel': 'Cancel',
      'profile.confirmLogout': 'Logout',
      'profile.stat.orders': 'Orders',
      'profile.stat.wishlist': 'Wishlist',
      'profile.stat.reviews': 'Reviews',
      'language.english': 'English (US)',
      'language.hindi': 'Hindi',
      'language.sheetTitle': 'Choose a language',
      'language.sheetSubtitle': 'Your selection updates the entire app instantly.',
      'form.required': 'This field is required',
    },
    'hi': {
      'profile.guestUser': 'अतिथि उपयोगकर्ता',
      'profile.noEmail': 'कोई ईमेल उपलब्ध नहीं',
      'profile.section.account': 'खाता',
      'profile.section.orders': 'ऑर्डर',
      'profile.section.settings': 'सेटिंग्स',
      'profile.section.support': 'सहायता',
      'profile.editProfile': 'प्रोफ़ाइल संपादित करें',
      'profile.editProfileSubtitle': 'अपनी जानकारी अपडेट करें',
      'profile.addresses': 'पते',
      'profile.addressesSubtitle': 'शिपिंग पते प्रबंधित करें',
      'profile.paymentMethods': 'भुगतान विधियाँ',
      'profile.paymentMethodsSubtitle': 'अपने कार्ड प्रबंधित करें',
      'profile.myOrders': 'मेरे ऑर्डर',
      'profile.ordersWithCount': 'आपके {count} ऑर्डर हैं',
      'profile.noOrders': 'अभी तक कोई ऑर्डर नहीं',
      'profile.wishlist': 'इच्छा सूची',
      'profile.wishlistSubtitle': 'आपकी पसंदीदा वस्तुएँ',
      'profile.reviews': 'समीक्षाएँ',
      'profile.reviewsSubtitle': 'आपकी उत्पाद समीक्षाएँ',
      'profile.notifications': 'सूचनाएँ',
      'profile.notificationsSubtitle': 'सूचना प्राथमिकताएँ प्रबंधित करें',
      'profile.language': 'भाषा',
      'profile.darkMode': 'डार्क मोड',
      'profile.darkModeSubtitle': 'थीम रूप बदलें',
      'profile.helpCenter': 'सहायता केंद्र',
      'profile.helpCenterSubtitle': 'सामान्य प्रश्न और सहायता',
      'profile.privacyPolicy': 'गोपनीयता नीति',
      'profile.privacyPolicySubtitle': 'हमारी गोपनीयता नीति देखें',
      'profile.terms': 'नियम और शर्तें',
      'profile.termsSubtitle': 'सेवा की शर्तें देखें',
      'profile.personalInfo': 'व्यक्तिगत जानकारी',
      'profile.profileUpdateSubtitle':
          'बेहतर अनुभव के लिए अपनी जानकारी अद्यतन रखें',
      'profile.fullNameLabel': 'पूरा नाम',
      'profile.emailLabel': 'ईमेल पता',
      'profile.phoneLabel': 'फ़ोन नंबर',
      'profile.locationLabel': 'स्थान',
      'profile.profileInfoHelper':
          'आपकी व्यक्तिगत जानकारी हमें सुझावों को व्यक्तिगत बनाने और खाते को सुरक्षित रखने में मदद करती है।',
      'profile.saveChanges': 'परिवर्तन सहेजें',
      'profile.profileUpdated': 'प्रोफ़ाइल विवरण सफलतापूर्वक सहेजे गए!',
      'profile.addAddressCta': 'नया पता जोड़ें',
      'profile.remove': 'हटाएं',
      'profile.primaryBadge': 'प्राथमिक',
      'profile.addPaymentMethodCta': 'भुगतान विधि जोड़ें',
      'profile.expiryLabel': 'समाप्ति',
      'profile.cardHolderLabel': 'कार्डधारक',
      'profile.logout': 'लॉगआउट',
      'profile.logoutConfirmTitle': 'लॉगआउट की पुष्टि करें',
      'profile.logoutConfirmMessage': 'क्या आप वास्तव में लॉगआउट करना चाहते हैं?',
      'profile.cancel': 'रद्द करें',
      'profile.confirmLogout': 'लॉगआउट',
      'profile.stat.orders': 'ऑर्डर',
      'profile.stat.wishlist': 'इच्छा सूची',
      'profile.stat.reviews': 'समीक्षाएँ',
      'language.english': 'अंग्रेज़ी (US)',
      'language.hindi': 'हिंदी',
      'language.sheetTitle': 'भाषा चुनें',
      'language.sheetSubtitle': 'आपकी पसंद तुरंत पूरे ऐप पर लागू होगी।',
      'form.required': 'यह फ़ील्ड आवश्यक है',
    },
  };

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String _string(String key) {
    final languageCode = locale.languageCode;
    final localeMap = _localizedValues[languageCode];
    if (localeMap != null && localeMap.containsKey(key)) {
      return localeMap[key]!;
    }
    final fallbackMap = _localizedValues['en'];
    if (fallbackMap != null && fallbackMap.containsKey(key)) {
      return fallbackMap[key]!;
    }
    return key;
  }

  String translate(String key) => _string(key);

  String get profileGuestUser => _string('profile.guestUser');
  String get profileNoEmail => _string('profile.noEmail');
  String get sectionAccount => _string('profile.section.account');
  String get sectionOrders => _string('profile.section.orders');
  String get sectionSettings => _string('profile.section.settings');
  String get sectionSupport => _string('profile.section.support');
  String get editProfile => _string('profile.editProfile');
  String get editProfileSubtitle => _string('profile.editProfileSubtitle');
  String get addresses => _string('profile.addresses');
  String get addressesSubtitle => _string('profile.addressesSubtitle');
  String get paymentMethods => _string('profile.paymentMethods');
  String get paymentMethodsSubtitle =>
      _string('profile.paymentMethodsSubtitle');
  String get myOrders => _string('profile.myOrders');
  String get wishlist => _string('profile.wishlist');
  String get wishlistSubtitle => _string('profile.wishlistSubtitle');
  String get reviews => _string('profile.reviews');
  String get reviewsSubtitle => _string('profile.reviewsSubtitle');
  String get notifications => _string('profile.notifications');
  String get notificationsSubtitle =>
      _string('profile.notificationsSubtitle');
  String get language => _string('profile.language');
  String get darkMode => _string('profile.darkMode');
  String get darkModeSubtitle => _string('profile.darkModeSubtitle');
  String get helpCenter => _string('profile.helpCenter');
  String get helpCenterSubtitle => _string('profile.helpCenterSubtitle');
  String get privacyPolicy => _string('profile.privacyPolicy');
  String get privacyPolicySubtitle =>
      _string('profile.privacyPolicySubtitle');
  String get terms => _string('profile.terms');
  String get termsSubtitle => _string('profile.termsSubtitle');
  String get personalInfo => _string('profile.personalInfo');
  String get profileUpdateSubtitle =>
      _string('profile.profileUpdateSubtitle');
  String get fullNameLabel => _string('profile.fullNameLabel');
  String get emailLabel => _string('profile.emailLabel');
  String get phoneLabel => _string('profile.phoneLabel');
  String get locationLabel => _string('profile.locationLabel');
  String get profileInfoHelper => _string('profile.profileInfoHelper');
  String get saveChanges => _string('profile.saveChanges');
  String get profileUpdated => _string('profile.profileUpdated');
  String get addAddressCta => _string('profile.addAddressCta');
  String get removeAction => _string('profile.remove');
  String get primaryBadge => _string('profile.primaryBadge');
  String get addPaymentMethodCta =>
      _string('profile.addPaymentMethodCta');
  String get expiryLabel => _string('profile.expiryLabel');
  String get cardHolderLabel => _string('profile.cardHolderLabel');
  String get fieldRequired => _string('form.required');
  String get logout => _string('profile.logout');
  String get logoutConfirmTitle => _string('profile.logoutConfirmTitle');
  String get logoutConfirmMessage =>
      _string('profile.logoutConfirmMessage');
  String get cancel => _string('profile.cancel');
  String get confirmLogout => _string('profile.confirmLogout');
  String get statOrders => _string('profile.stat.orders');
  String get statWishlist => _string('profile.stat.wishlist');
  String get statReviews => _string('profile.stat.reviews');
  String get languageSheetTitle => _string('language.sheetTitle');
  String get languageSheetSubtitle => _string('language.sheetSubtitle');

  String ordersDescription(int count) {
    if (count > 0) {
      return _string('profile.ordersWithCount')
          .replaceFirst('{count}', '$count');
    }
    return _string('profile.noOrders');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension LocalizationBuildContext on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this);
}
