import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/features/auth/controller/user/user_controller.dart';
import 'package:shop/utils/localization/app_localizations.dart';
import 'package:shop/utils/responsive/responsive.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final userController = Provider.of<UserController>(context);
    final user = userController.user;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = '';
    _locationController.text = user?.address ?? '';
    _initialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final loc = context.loc;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editProfile),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: responsive.padding(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeaderHighlight(
                title: loc.personalInfo,
                subtitle: loc.profileUpdateSubtitle,
              ),
              SizedBox(height: responsive.spacing(20)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      context,
                      controller: _nameController,
                      label: loc.fullNameLabel,
                      icon: Icons.person_outline,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildField(
                      context,
                      controller: _emailController,
                      label: loc.emailLabel,
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.mail_outline,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildField(
                      context,
                      controller: _phoneController,
                      label: loc.phoneLabel,
                      keyboardType: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                    SizedBox(height: responsive.spacing(16)),
                    _buildField(
                      context,
                      controller: _locationController,
                      label: loc.locationLabel,
                      icon: Icons.location_on_outlined,
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsive.spacing(24)),
              Container(
                padding: responsive.padding(all: 16),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(responsive.borderRadius(18)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: colorScheme.primary,
                    ),
                    SizedBox(width: responsive.spacing(12)),
                    Expanded(
                      child: Text(
                        loc.profileInfoHelper,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: responsive.padding(all: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _handleSave,
            icon: const Icon(Icons.save_rounded),
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: responsive.spacing(12)),
              child: Text(
                loc.saveChanges,
                style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    IconData? icon,
  }) {
    final loc = context.loc;
    final theme = Theme.of(context);
    final responsive = context.responsive;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor:
            theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return loc.fieldRequired;
        }
        return null;
      },
    );
  }

  void _handleSave() {
    final loc = context.loc;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.profileUpdated)),
      );
    }
  }
}

class _HeaderHighlight extends StatelessWidget {
  const _HeaderHighlight({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: responsive.padding(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
        ),
        borderRadius: BorderRadius.circular(responsive.borderRadius(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: responsive.spacing(18),
            offset: Offset(0, responsive.spacing(6)),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: responsive.spacing(8)),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
