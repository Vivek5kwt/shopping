import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';
import 'package:shop/features/controllers/order/order_controller.dart';
import 'package:shop/features/screens/favorite/view/favorite_screen.dart';
import 'package:shop/features/screens/orders/view/order_list.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/localization/language_provider.dart';
import 'package:shop/utils/responsive/responsive.dart';
import 'package:shop/utils/shimmer/shimmer_effect.dart';
import 'package:shop/utils/theme/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const double _bottomNavBarHeight = 110;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderController = Provider.of<OrderController>(
        context,
        listen: false,
      );
      orderController.myOrders();
      final controller = Provider.of<UserController>(context, listen: false);
      controller.fetchUser();
    });
  }

  String _safeString(dynamic value) {
    try {
      if (value == null) return '';
      return value.toString();
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Consumer2<UserController, OrderController>(

      builder: (context, controller, orderController, child) {
        // Use safe accessors and provide demo/fallback values when data is not available.
        final dynamic user = controller.user;
        final String userName = _safeString(user?.name).isNotEmpty
            ? _safeString(user?.name)
            : loc.profileGuestUser;
        final String userEmail = _safeString(user?.email).isNotEmpty
            ? _safeString(user?.email)
            : loc.profileNoEmail;
        final String profilePic = _safeString(user?.profilePic);
        final int ordersCount = orderController.orders?.length ?? 0;
        final double logoutButtonBottomPadding =
            MediaQuery.of(context).padding.bottom +
                responsive.spacing(16) +
                _bottomNavBarHeight;

        // Instead of showing a full-screen loader when user is null, show the page with demo/fallback data.
        // This avoids leaving the user staring at a loader indefinitely when no data comes back.
        return Scaffold(

          backgroundColor: isDark ? colorScheme.surface : Colors.grey[50],
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: logoutButtonBottomPadding + responsive.spacing(72),
                ),
                child: CustomScrollView(
                  slivers: [
              // App Bar with Profile Header
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: responsive.heightPercent(40),
                pinned: true,
                backgroundColor: const Color(0xFF3B82F6),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF3B82F6),
                          Color(0xFF2563EB),
                          Color(0xFF1D4ED8),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveSizedBox(height: 20),
                          // Profile Image (handles null user/profilePic internally)
                          _buildProfileImage(controller, profilePic, responsive),
                          ResponsiveSizedBox(height: 16),
                          // User Name
                          ResponsiveText(
                            userName,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          ResponsiveSizedBox(height: 4),
                          // Email
                          ResponsiveText(
                            userEmail,
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          ResponsiveSizedBox(height: 16),
                          // Stats Row
                          _buildStatsRow(
                            orderController,
                            responsive,
                            ordersCount,
                            loc,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Profile Options
              SliverToBoxAdapter(
                child: ResponsivePadding(
                  all: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Account Section
                      _buildSectionTitle(
                        loc.sectionAccount,
                        responsive,
                        isDark,
                      ),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, isDark, [
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.person_outline,
                          title: loc.editProfile,
                          subtitle: loc.editProfileSubtitle,
                          color: const Color(0xFF3B82F6),
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.location_on_outlined,
                          title: loc.addresses,
                          subtitle: loc.addressesSubtitle,
                          color: const Color(0xFFEC4899),
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.payment_outlined,
                          title: loc.paymentMethods,
                          subtitle: loc.paymentMethodsSubtitle,
                          color: const Color(0xFF8B5CF6),
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Orders Section
                      _buildSectionTitle(
                        loc.sectionOrders,
                        responsive,
                        isDark,
                      ),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, isDark, [
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.shopping_bag_outlined,
                          title: loc.myOrders,
                          subtitle: loc.ordersDescription(ordersCount),
                          color: const Color(0xFF10B981),
                          isDark: isDark,
                          onTap: () => Get.to(() => OrderListScreen()),
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.favorite_outline,
                          title: loc.wishlist,
                          subtitle: loc.wishlistSubtitle,
                          color: const Color(0xFFEF4444),
                          isDark: isDark,
                          onTap: () => Get.to(() => FavoriteScreen()),
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          responsive: responsive,
                          icon: Icons.star_outline,
                          title: loc.reviews,
                          subtitle: loc.reviewsSubtitle,
                          color: const Color(0xFFF59E0B),
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Settings Section
                      _buildSectionTitle(
                        loc.sectionSettings,
                        responsive,
                        isDark,
                      ),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, isDark, [
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.notifications_outlined,
                          title: loc.notifications,
                          subtitle: loc.notificationsSubtitle,
                          color: const Color(0xFF6366F1),
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        Consumer<LanguageProvider>(
                          builder: (context, languageProvider, _) {
                            final languageLabel = loc.translate(
                              languageProvider.selectedLanguage.labelKey,
                            );
                            return _buildOption(
                              context: context,
                              responsive: responsive,
                              icon: Icons.language_outlined,
                              title: loc.language,
                              subtitle: languageLabel,
                              color: const Color(0xFF14B8A6),
                              isDark: isDark,
                              onTap: languageProvider.isInitialized
                                  ? () => _showLanguageSelector(languageProvider)
                                  : null,
                              trailing: languageProvider.isInitialized
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: responsive.spacing(12),
                                        vertical: responsive.spacing(6),
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF14B8A6)
                                            .withOpacity(isDark ? 0.25 : 0.12),
                                        borderRadius: BorderRadius.circular(
                                          responsive.borderRadius(16),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.translate,
                                            color: const Color(0xFF0F766E),
                                            size: responsive.iconSize(18),
                                          ),
                                          SizedBox(
                                            width: responsive.spacing(6),
                                          ),
                                          Text(
                                            languageLabel,
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF0F172A),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      height: responsive.spacing(24),
                                      width: responsive.spacing(24),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        Consumer<ThemeProvider>(
                          builder: (context, themeProvider, _) {
                            final bool isDarkEnabled =
                                themeProvider.isInitialized
                                    ? themeProvider.isDarkMode
                                    : false;
                            return _buildOption(
                              context: context,
                              responsive: responsive,
                              icon: Icons.dark_mode_outlined,
                              title: loc.darkMode,
                              subtitle: loc.darkModeSubtitle,
                              color: const Color(0xFF64748B),
                              isDark: isDark,
                              onTap: themeProvider.isInitialized
                                  ? () =>
                                      themeProvider.toggleTheme(!isDarkEnabled)
                                  : null,
                              trailing: themeProvider.isInitialized
                                  ? Switch.adaptive(
                                      value: isDarkEnabled,
                                      onChanged: (value) =>
                                          themeProvider.toggleTheme(value),
                                      activeColor: const Color(0xFF2563EB),
                                      activeTrackColor:
                                          const Color(0xFF2563EB).withOpacity(0.4),
                                      inactiveTrackColor:
                                          Colors.grey.withOpacity(0.4),
                                    )
                                  : SizedBox(
                                      height: responsive.spacing(24),
                                      width: responsive.spacing(24),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ]),

                      ResponsiveSizedBox(height: 24),

                      // Support Section
                      _buildSectionTitle(
                        loc.sectionSupport,
                        responsive,
                        isDark,
                      ),
                      ResponsiveSizedBox(height: 8),
                      _buildOptionCard(responsive, isDark, [
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.help_outline,
                          title: loc.helpCenter,
                          subtitle: loc.helpCenterSubtitle,
                          color: const Color(0xFF06B6D4),
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.privacy_tip_outlined,
                          title: loc.privacyPolicy,
                          subtitle: loc.privacyPolicySubtitle,
                          color: const Color(0xFF84CC16),
                          isDark: isDark,
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        _buildOption(
                          context: context,
                          responsive: responsive,
                          icon: Icons.description_outlined,
                          title: loc.terms,
                          subtitle: loc.termsSubtitle,
                          color: const Color(0xFFA855F7),
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ]),

                      ResponsiveSizedBox(height: responsive.spacing(220)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
              Positioned(
                left: responsive.spacing(16),
                right: responsive.spacing(16),
                bottom: logoutButtonBottomPadding,
                child: _buildStickyLogoutButton(responsive, loc),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStickyLogoutButton(
      ResponsiveUtils responsive, AppLocalizations loc) {
    // The sticky logout button floats above the custom bottom bar so that it is always tappable.
    // It uses a Consumer to access the UserController and shows a confirmation dialog before logging out.
    return Consumer<UserController>(
      builder: (context, userController, child) {
        return SizedBox(
          height: responsive.spacing(56),
          child: Material(
            borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
            child: InkWell(
              borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
              onTap: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(loc.logoutConfirmTitle),
                      content: Text(loc.logoutConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: Text(loc.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: Text(loc.confirmLogout),
                        ),
                      ],
                    );
                  },
                );

                if (shouldLogout == true) {
                  // call logout on the controller
                  userController.logout(context);
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      blurRadius: responsive.spacing(12),
                      offset: Offset(0, responsive.spacing(6)),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: responsive.iconSize(20),
                      ),
                      SizedBox(width: responsive.spacing(8)),
                      ResponsiveText(
                        loc.logout,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(
      UserController controller,
      String? profilePic,
      ResponsiveUtils responsive,
      ) {
    final imageSize = responsive.spacing(100);
    final iconSize = responsive.iconSize(16);

    // Provide a fallback image URL when profilePic is empty.
    const fallbackImageUrl =
        'https://plus.unsplash.com/premium_photo-1671656349218-5218444643d8?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D';

    return Stack(
      children: [
        Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: responsive.spacing(4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: responsive.spacing(20),
                offset: Offset(0, responsive.spacing(10)),
              ),
            ],
          ),
          child: ClipOval(
            child: controller.isUpdatingPhoto
                ? ShimmerEffect(
              width: imageSize,
              height: imageSize,
              radius: imageSize / 2,
            )
                : controller.selectedImage != null
                ? Image.file(
              controller.selectedImage!,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            )
                : (profilePic != null && profilePic.isNotEmpty)
                ? Image.network(
              profilePic,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  fallbackImageUrl,
                  width: imageSize,
                  height: imageSize,
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.network(
              fallbackImageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () => controller.updateProfilePhoto(context),
            child: Container(
              padding: EdgeInsets.all(responsive.spacing(4)),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: responsive.spacing(2),
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                size: iconSize,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(
      OrderController orderController,
      ResponsiveUtils responsive,
      int ordersCount,
      AppLocalizations loc,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: responsive.spacing(40)),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.spacing(24),
        vertical: responsive.spacing(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            loc.statOrders,
            '$ordersCount',
            responsive,
          ),
          Container(
            height: responsive.spacing(30),
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(loc.statWishlist, '12', responsive),
          Container(
            height: responsive.spacing(30),
            width: 1,
            color: Colors.white.withOpacity(0.3),
          ),
          _buildStatItem(loc.statReviews, '8', responsive),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label,
      String value,
      ResponsiveUtils responsive,
      ) {
    return Column(
      children: [
        ResponsiveText(
          value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        ResponsiveSizedBox(height: 2),
        ResponsiveText(
          label,
          fontSize: 12,
          color: Colors.white.withOpacity(0.9),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(
    String title,
    ResponsiveUtils responsive,
    bool isDark,
  ) {
    return ResponsivePadding(
      left: 4,
      child: ResponsiveText(
        title,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : const Color(0xFF1F2937),
      ),
    );
  }

  Widget _buildOptionCard(
    ResponsiveUtils responsive,
    bool isDark,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.transparent,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: responsive.spacing(10),
                  offset: Offset(0, responsive.spacing(2)),
                ),
              ],
      ),
      child: Column(children: children),
    );
  }

  Future<void> _showLanguageSelector(LanguageProvider provider) async {
    if (!mounted) return;

    final loc = context.loc;
    final selectedCode = provider.locale.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  loc.languageSheetTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.languageSheetSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7) ??
                            const Color(0xFF64748B),
                      ) ??
                      const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                ),
                const SizedBox(height: 12),
                ...provider.languages.map((option) {
                  final label = loc.translate(option.labelKey);
                  final isSelected =
                      option.locale.languageCode == selectedCode;
                  return RadioListTile<String>(
                    value: option.locale.languageCode,
                    groupValue: selectedCode,
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.2),
                      ),
                    ),
                    tileColor: isSelected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08)
                        : null,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) async {
                      if (value == null) return;
                      await provider.updateLocale(option.locale);
                      if (Navigator.of(sheetContext).canPop()) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    title: Text(
                      label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                    secondary: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required BuildContext context,
    required ResponsiveUtils responsive,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isDark,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final iconContainerSize = responsive.spacing(48);
    final iconSizeValue = responsive.iconSize(24);
    final titleColor = isDark ? Colors.white : const Color(0xFF1F2937);
    final subtitleColor =
        isDark ? Colors.white.withOpacity(0.72) : Colors.grey[600];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: color.withOpacity(0.12),
        onTap: onTap,
        borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        child: Padding(
          padding: responsive.padding(all: 16),
          child: Row(
            children: [
              Container(
                width: iconContainerSize,
                height: iconContainerSize,
                decoration: BoxDecoration(
                  color: color.withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(
                    responsive.borderRadius(12),
                  ),
                ),
                child: Icon(icon, color: color, size: iconSizeValue),
              ),
              SizedBox(width: responsive.spacing(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      title,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                    ResponsiveSizedBox(height: 2),
                    ResponsiveText(
                      subtitle,
                      fontSize: 13,
                      color: subtitleColor,
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white54 : Colors.grey[400],
                    size: responsive.iconSize(24),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
