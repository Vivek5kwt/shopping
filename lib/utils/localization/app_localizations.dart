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
      'profile.contactSupport': 'Contact Support',
      'profile.chatWithTeam': 'Chat with our team',
      'profile.quickActions': 'Quick Actions',
      'profile.faqs': 'Frequently Asked Questions',
      'profile.needHelpTitle': 'Need help?',
      'profile.helpHeroDescription':
          'Our support team is available 24/7. Chat with us or explore curated answers to common questions.',
      'profile.trackOrder': 'Track Order',
      'profile.trackOrderSubtitle': 'Realtime delivery updates',
      'profile.reportIssue': 'Report Issue',
      'profile.reportIssueSubtitle': 'Let us know what happened',
      'profile.privacyPolicy': 'Privacy Policy',
      'profile.privacyPolicySubtitle': 'View our privacy policy',
      'profile.respectPrivacyTitle': 'We respect your privacy',
      'profile.respectPrivacySubtitle':
          'Every interaction is encrypted end-to-end and stays compliant with GDPR & local regulations.',
      'profile.needSomethingElse': 'Need something else?',
      'profile.privacyEmailDescription':
          'Write to privacy@shop.com and we will address any request in under 48 hours.',
      'profile.terms': 'Terms & Conditions',
      'profile.termsSubtitle': 'View terms of service',
      'profile.transparencyTitle': 'Designed for transparency',
      'profile.transparencySubtitle':
          'Please review the highlights below. By continuing to use the app you agree to the full terms and policies.',
      'profile.acceptanceNote':
          'By continuing you accept these Terms & Conditions in addition to the Privacy Policy and Help Center guidelines.',
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
      'auth.login.title': 'Welcome Back',
      'auth.login.subtitle': 'Sign in to continue to B&W',
      'auth.email.label': 'Email',
      'auth.email.hint': 'Enter your email address',
      'auth.password.label': 'Password',
      'auth.password.hint': 'Enter your password',
      'auth.fullName.label': 'Full Name',
      'auth.fullName.hint': 'Enter your full name',
      'auth.login.forgot': 'Forgot Password?',
      'auth.login.button': 'Sign In',
      'auth.signup.button': 'Sign Up',
      'auth.common.orContinue': 'or continue with',
      'auth.login.footer.question': "Don't have an account?",
      'auth.signup.footer.question': 'Already have an account?',
      'auth.forgot.footer.question': 'Remembered your password?',
      'auth.footer.signIn': 'Sign In',
      'auth.footer.signUp': 'Sign Up',
      'auth.backToSignIn': 'Back to Sign In',
      'auth.signup.title': 'Create Account',
      'auth.signup.subtitle': 'Sign up to get started with B&W',
      'auth.forgot.title': 'Forgot Password',
      'auth.forgot.subtitle': 'Enter your email to reset your password',
      'auth.forgot.button': 'Reset Password',
      'auth.social.apple.title': 'Apple Sign-In',
      'auth.social.apple.message':
          'Apple Sign-In is not available on this device.',
      'onboarding.page1.title': 'Shop Trending\nDesigns',
      'onboarding.page1.description':
          'Design and personalize your T-shirts\nwith just a few taps.',
      'onboarding.page2.title': 'Fast Delivery\n& Easy Returns',
      'onboarding.page2.description':
          'Design and personalize your T-shirts\nwith just a few taps.',
      'onboarding.page3.title': 'Create Your Own\nStyle',
      'onboarding.page3.description':
          'Design and personalize your T-shirts\nwith just a few taps.',
      'onboarding.next': 'Next',
      'onboarding.getStarted': 'Get Started',
      'onboarding.skip': 'Skip',
      'onboarding.done': 'Done',
      'splash.tagline': 'Curated looks, effortless style.',
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
      'profile.contactSupport': 'सहायता से संपर्क करें',
      'profile.chatWithTeam': 'हमारी टीम से चैट करें',
      'profile.quickActions': 'त्वरित क्रियाएँ',
      'profile.faqs': 'अक्सर पूछे जाने वाले प्रश्न',
      'profile.needHelpTitle': 'मदद चाहिए?',
      'profile.helpHeroDescription':
          'हमारी सहायता टीम 24/7 उपलब्ध है। हमसे चैट करें या सामान्य प्रश्नों के लिए तैयार किए गए उत्तर देखें।',
      'profile.trackOrder': 'ऑर्डर ट्रैक करें',
      'profile.trackOrderSubtitle': 'रियलटाइम डिलीवरी अपडेट्स',
      'profile.reportIssue': 'समस्या रिपोर्ट करें',
      'profile.reportIssueSubtitle': 'हमें बताएं क्या हुआ',
      'profile.privacyPolicy': 'गोपनीयता नीति',
      'profile.privacyPolicySubtitle': 'हमारी गोपनीयता नीति देखें',
      'profile.respectPrivacyTitle': 'हम आपकी गोपनीयता का सम्मान करते हैं',
      'profile.respectPrivacySubtitle':
          'हर इंटरैक्शन एंड-टू-एंड एन्क्रिप्टेड है और GDPR तथा स्थानीय नियमों के अनुरूप है।',
      'profile.needSomethingElse': 'कुछ और चाहिए?',
      'profile.privacyEmailDescription':
          'privacy@shop.com पर लिखें और हम 48 घंटों के भीतर किसी भी अनुरोध का जवाब देंगे।',
      'profile.terms': 'नियम और शर्तें',
      'profile.termsSubtitle': 'सेवा की शर्तें देखें',
      'profile.transparencyTitle': 'पारदर्शिता के लिए डिज़ाइन किया गया',
      'profile.transparencySubtitle':
          'नीचे दिए गए मुख्य बिंदुओं की समीक्षा करें। ऐप का उपयोग जारी रखते हुए आप सभी नियमों और नीतियों से सहमत होते हैं।',
      'profile.acceptanceNote':
          'जारी रखते हुए आप इन नियमों व शर्तों के साथ-साथ गोपनीयता नीति और सहायता दिशानिर्देशों से भी सहमत होते हैं।',
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
      'auth.login.title': 'वापसी पर स्वागत है',
      'auth.login.subtitle': 'B&W जारी रखने के लिए साइन इन करें',
      'auth.email.label': 'ईमेल',
      'auth.email.hint': 'अपना ईमेल पता दर्ज करें',
      'auth.password.label': 'पासवर्ड',
      'auth.password.hint': 'अपना पासवर्ड दर्ज करें',
      'auth.fullName.label': 'पूरा नाम',
      'auth.fullName.hint': 'अपना पूरा नाम दर्ज करें',
      'auth.login.forgot': 'पासवर्ड भूल गए?',
      'auth.login.button': 'साइन इन',
      'auth.signup.button': 'साइन अप',
      'auth.common.orContinue': 'या इन विकल्पों से जारी रखें',
      'auth.login.footer.question': 'क्या आपका खाता नहीं है?',
      'auth.signup.footer.question': 'क्या आपके पास पहले से खाता है?',
      'auth.forgot.footer.question': 'क्या आपको अपना पासवर्ड याद आ गया?',
      'auth.footer.signIn': 'साइन इन',
      'auth.footer.signUp': 'साइन अप',
      'auth.backToSignIn': 'साइन इन पर वापस जाएँ',
      'auth.signup.title': 'खाता बनाएँ',
      'auth.signup.subtitle': 'B&W शुरू करने के लिए साइन अप करें',
      'auth.forgot.title': 'पासवर्ड भूल गए',
      'auth.forgot.subtitle': 'पासवर्ड रीसेट करने के लिए अपना ईमेल दर्ज करें',
      'auth.forgot.button': 'पासवर्ड रीसेट करें',
      'auth.social.apple.title': 'एप्पल साइन-इन',
      'auth.social.apple.message':
          'एप्पल साइन-इन इस डिवाइस पर उपलब्ध नहीं है।',
      'onboarding.page1.title': 'ट्रेंडिंग डिज़ाइन्स\nखरीदें',
      'onboarding.page1.description':
          'बस कुछ टैप्स में अपने टी-शर्ट डिज़ाइन करें\nऔर उन्हें व्यक्तिगत बनाएं।',
      'onboarding.page2.title': 'तेज़ डिलीवरी\nऔर आसान रिटर्न',
      'onboarding.page2.description':
          'बस कुछ टैप्स में अपने टी-शर्ट डिज़ाइन करें\nऔर उन्हें व्यक्तिगत बनाएं।',
      'onboarding.page3.title': 'अपनी खुद की\nस्टाइल बनाएँ',
      'onboarding.page3.description':
          'बस कुछ टैप्स में अपने टी-शर्ट डिज़ाइन करें\nऔर उन्हें व्यक्तिगत बनाएं।',
      'onboarding.next': 'आगे',
      'onboarding.getStarted': 'शुरू करें',
      'onboarding.skip': 'छोड़ें',
      'onboarding.done': 'समाप्त',
      'splash.tagline': 'सजावट भरी पसंद, बेपरवाह अंदाज़।',
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
  String get contactSupport => _string('profile.contactSupport');
  String get chatWithTeam => _string('profile.chatWithTeam');
  String get quickActions => _string('profile.quickActions');
  String get faqs => _string('profile.faqs');
  String get needHelpTitle => _string('profile.needHelpTitle');
  String get helpHeroDescription => _string('profile.helpHeroDescription');
  String get trackOrder => _string('profile.trackOrder');
  String get trackOrderSubtitle => _string('profile.trackOrderSubtitle');
  String get reportIssue => _string('profile.reportIssue');
  String get reportIssueSubtitle =>
      _string('profile.reportIssueSubtitle');
  String get privacyPolicy => _string('profile.privacyPolicy');
  String get privacyPolicySubtitle =>
      _string('profile.privacyPolicySubtitle');
  String get respectPrivacyTitle => _string('profile.respectPrivacyTitle');
  String get respectPrivacySubtitle =>
      _string('profile.respectPrivacySubtitle');
  String get needSomethingElse => _string('profile.needSomethingElse');
  String get privacyEmailDescription =>
      _string('profile.privacyEmailDescription');
  String get terms => _string('profile.terms');
  String get termsSubtitle => _string('profile.termsSubtitle');
  String get transparencyTitle => _string('profile.transparencyTitle');
  String get transparencySubtitle =>
      _string('profile.transparencySubtitle');
  String get acceptanceNote => _string('profile.acceptanceNote');
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
  String get authLoginTitle => _string('auth.login.title');
  String get authLoginSubtitle => _string('auth.login.subtitle');
  String get authEmailLabel => _string('auth.email.label');
  String get authEmailHint => _string('auth.email.hint');
  String get authPasswordLabel => _string('auth.password.label');
  String get authPasswordHint => _string('auth.password.hint');
  String get authFullNameLabel => _string('auth.fullName.label');
  String get authFullNameHint => _string('auth.fullName.hint');
  String get authForgotPassword => _string('auth.login.forgot');
  String get authSignInButton => _string('auth.login.button');
  String get authSignUpButton => _string('auth.signup.button');
  String get authOrContinue => _string('auth.common.orContinue');
  String get authLoginFooterQuestion =>
      _string('auth.login.footer.question');
  String get authSignupFooterQuestion =>
      _string('auth.signup.footer.question');
  String get authForgotFooterQuestion =>
      _string('auth.forgot.footer.question');
  String get authFooterSignIn => _string('auth.footer.signIn');
  String get authFooterSignUp => _string('auth.footer.signUp');
  String get authBackToSignIn => _string('auth.backToSignIn');
  String get authSignupTitle => _string('auth.signup.title');
  String get authSignupSubtitle => _string('auth.signup.subtitle');
  String get authForgotTitle => _string('auth.forgot.title');
  String get authForgotSubtitle => _string('auth.forgot.subtitle');
  String get authForgotButton => _string('auth.forgot.button');
  String get authSocialAppleTitle => _string('auth.social.apple.title');
  String get authSocialAppleMessage =>
      _string('auth.social.apple.message');
  String get onboardingPage1Title => _string('onboarding.page1.title');
  String get onboardingPage1Description =>
      _string('onboarding.page1.description');
  String get onboardingPage2Title => _string('onboarding.page2.title');
  String get onboardingPage2Description =>
      _string('onboarding.page2.description');
  String get onboardingPage3Title => _string('onboarding.page3.title');
  String get onboardingPage3Description =>
      _string('onboarding.page3.description');
  String get onboardingNext => _string('onboarding.next');
  String get onboardingGetStarted => _string('onboarding.getStarted');
  String get onboardingSkip => _string('onboarding.skip');
  String get onboardingDone => _string('onboarding.done');
  String get splashTagline => _string('splash.tagline');

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
