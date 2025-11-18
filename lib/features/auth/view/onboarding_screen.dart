import 'package:flutter/material.dart';
import 'package:shop/utils/localization/app_localizations.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final Future<void> Function()? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  static const int _pageCount = 3;

  void _goToNextPage() {
    if (_currentIndex < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    if (widget.onComplete != null) {
      await widget.onComplete!.call();
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFECF4FF),
              Color(0xFFF3ECFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  final loc = context.loc;
                  final pages = _buildPages(loc);
                  final isLastPage = _currentIndex == pages.length - 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _currentIndex > 0 ? 1 : 0,
                          child: _currentIndex > 0
                              ? IconButton(
                                  onPressed: () {
                                    if (_currentIndex > 0) {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 400),
                                        curve: Curves.easeOut,
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                )
                              : const SizedBox(width: 48),
                        ),
                        TextButton(
                          onPressed: () => _completeOnboarding(),
                          child: Text(
                            isLastPage ? loc.onboardingDone : loc.onboardingSkip,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final loc = context.loc;
                    final pages = _buildPages(loc);
                    return PageView.builder(
                      controller: _pageController,
                      itemCount: pages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final page = pages[index];
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              page.illustration,
                              const SizedBox(height: 32),
                              Text(
                                page.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ) ??
                                    const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                page.description,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.black54,
                                        ) ??
                                    const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                              ),
                              const Spacer(),
                              _OnboardingActionButton(
                                label: page.buttonLabel,
                                isPrimary: page.isPrimaryAction,
                                onPressed: () {
                                  if (page.isPrimaryAction) {
                                    _completeOnboarding();
                                  } else {
                                    _goToNextPage();
                                  }
                                },
                              ),
                              const SizedBox(height: 24),
                              _PageIndicator(
                                length: pages.length,
                                currentIndex: _currentIndex,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_OnboardingPageData> _buildPages(AppLocalizations loc) {
    return [
      _OnboardingPageData(
        title: loc.onboardingPage1Title,
        description: loc.onboardingPage1Description,
        buttonLabel: loc.onboardingNext,
        isPrimaryAction: false,
        illustration: const _TrendingDesignIllustration(),
      ),
      _OnboardingPageData(
        title: loc.onboardingPage2Title,
        description: loc.onboardingPage2Description,
        buttonLabel: loc.onboardingNext,
        isPrimaryAction: false,
        illustration: const _FastDeliveryIllustration(),
      ),
      _OnboardingPageData(
        title: loc.onboardingPage3Title,
        description: loc.onboardingPage3Description,
        buttonLabel: loc.onboardingGetStarted,
        isPrimaryAction: true,
        illustration: const _CreateStyleIllustration(),
      ),
    ];
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final String buttonLabel;
  final bool isPrimaryAction;
  final Widget illustration;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.isPrimaryAction,
    required this.illustration,
  });
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.length,
    required this.currentIndex,
  });

  final int length;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }
}

class _OnboardingActionButton extends StatelessWidget {
  const _OnboardingActionButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.black : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: isPrimary ? 4 : 1,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: isPrimary ? Colors.white : Colors.black,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward,
                size: 18,
                color: isPrimary ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendingDesignIllustration extends StatelessWidget {
  const _TrendingDesignIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 380,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(48),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
          ),
          Positioned(
            top: 14,
            child: Container(
              width: 120,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          Positioned(
            top: 64,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6E6E6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 140,
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A64FF),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.checkroom,
                        color: Colors.white,
                        size: 72,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'SOFTBALL\nIS MY PASSION',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 90,
            right: 16,
            child: Container(
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4D67),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: 120,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE6E6E6),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateStyleIllustration extends StatelessWidget {
  const _CreateStyleIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF546CFF), Color(0xFF4F80FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(120),
            ),
          ),
          Positioned(
            top: 48,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(80),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 110,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F80FF),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 40,
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFF617DFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FastDeliveryIllustration extends StatelessWidget {
  const _FastDeliveryIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FF),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    right: 24,
                    child: Container(
                      height: 36,
                      width: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF5F5F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
