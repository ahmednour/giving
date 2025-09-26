import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../utils/responsive.dart';
import '../../components/navigation/sidebar.dart';
import '../../components/navigation/navbar.dart';
import '../../components/common/custom_card.dart';
import '../../components/buttons/custom_button.dart';
import '../../components/forms/custom_text_field.dart';
import '../../components/common/loading_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSidebarCollapsed = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Profile form controllers
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  // Settings
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _marketingEmails = false;
  bool _weeklyDigest = true;
  bool _profileVisibility = true;
  bool _showDonationHistory = false;

  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user != null) {
      _firstNameController.text = authProvider.user!.firstName;
      _lastNameController.text = authProvider.user!.lastName;
      _emailController.text = authProvider.user!.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: Responsive.showSidebar(context)
          ? null
          : AppNavbar(
              title: 'Settings',
              actions: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ],
            ),
      drawer: Responsive.showDrawer(context)
          ? Drawer(
              child: Sidebar(currentRoute: '/settings', isCollapsed: false),
            )
          : null,
      body: Row(
        children: [
          if (Responsive.showSidebar(context))
            Sidebar(
              currentRoute: '/settings',
              isCollapsed: _isSidebarCollapsed,
              onToggle: () {
                setState(() {
                  _isSidebarCollapsed = !_isSidebarCollapsed;
                });
              },
            ),
          Expanded(
            child: LoadingOverlay(
              isLoading: _isLoading,
              loadingMessage: 'Saving changes...',
              child: _buildMainContent(context, isDarkMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDarkMode) {
    return Container(
      color: isDarkMode ? AppColors.darkBackground : AppColors.background,
      child: SingleChildScrollView(
        padding: Responsive.responsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDarkMode),
            const SizedBox(height: 32),
            if (_hasUnsavedChanges) ...[
              _buildUnsavedChangesNotice(),
              const SizedBox(height: 24),
            ],
            ResponsiveWidget(
              mobile: Column(
                children: [
                  _buildProfileSection(isDarkMode),
                  const SizedBox(height: 32),
                  _buildNotificationSettings(isDarkMode),
                  const SizedBox(height: 32),
                  _buildPrivacySettings(isDarkMode),
                  const SizedBox(height: 32),
                  _buildAppearanceSettings(isDarkMode),
                  const SizedBox(height: 32),
                  _buildAccountActions(isDarkMode),
                ],
              ),
              desktop: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildProfileSection(isDarkMode),
                        const SizedBox(height: 32),
                        _buildAccountActions(isDarkMode),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      children: [
                        _buildNotificationSettings(isDarkMode),
                        const SizedBox(height: 32),
                        _buildPrivacySettings(isDarkMode),
                        const SizedBox(height: 32),
                        _buildAppearanceSettings(isDarkMode),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style:
              Responsive.responsiveValue(
                context,
                mobile: AppTypography.headlineMedium,
                desktop: AppTypography.headlineLarge,
              ).copyWith(
                color: isDarkMode
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your account, notifications, and preferences.',
          style: AppTypography.bodyLarge.copyWith(
            color: isDarkMode
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildUnsavedChangesNotice() {
    return CustomCard(
      variant: CardVariant.filled,
      backgroundColor: AppColors.warning.withOpacity(0.1),
      borderColor: AppColors.warning,
      child: Row(
        children: [
          Icon(Icons.warning_amber, color: AppColors.warning, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have unsaved changes',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          CustomButton(
            text: 'Save Changes',
            onPressed: _saveChanges,
            size: ButtonSize.small,
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(bool isDarkMode) {
    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            onChanged: () {
              if (!_hasUnsavedChanges) {
                setState(() {
                  _hasUnsavedChanges = true;
                });
              }
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled:
                      false, // Email changes should go through verification
                  helperText: 'Contact support to change your email address',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hint: 'Optional',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: 'Bio',
                  controller: _bioController,
                  maxLines: 3,
                  hint: 'Tell the community about yourself...',
                  helperText: 'This will be visible on your public profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(bool isDarkMode) {
    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Email Notifications',
            'Receive email updates about donations and requests',
            _emailNotifications,
            (value) => setState(() {
              _emailNotifications = value;
              _hasUnsavedChanges = true;
            }),
          ),
          _buildSettingsTile(
            'Push Notifications',
            'Get notified about urgent requests and updates',
            _pushNotifications,
            (value) => setState(() {
              _pushNotifications = value;
              _hasUnsavedChanges = true;
            }),
          ),
          _buildSettingsTile(
            'Marketing Emails',
            'Receive newsletters and promotional content',
            _marketingEmails,
            (value) => setState(() {
              _marketingEmails = value;
              _hasUnsavedChanges = true;
            }),
          ),
          _buildSettingsTile(
            'Weekly Digest',
            'Get a summary of community activity',
            _weeklyDigest,
            (value) => setState(() {
              _weeklyDigest = value;
              _hasUnsavedChanges = true;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(bool isDarkMode) {
    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            'Public Profile',
            'Allow others to see your profile information',
            _profileVisibility,
            (value) => setState(() {
              _profileVisibility = value;
              _hasUnsavedChanges = true;
            }),
          ),
          _buildSettingsTile(
            'Show Donation History',
            'Display your donation activity on your profile',
            _showDonationHistory,
            (value) => setState(() {
              _showDonationHistory = value;
              _hasUnsavedChanges = true;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings(bool isDarkMode) {
    final themeProvider = context.watch<ThemeProvider>();

    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose your preferred color scheme',
                      style: AppTypography.bodySmall.copyWith(
                        color: isDarkMode
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.brightness_auto, size: 16),
                    label: Text('Auto'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode, size: 16),
                    label: Text('Light'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode, size: 16),
                    label: Text('Dark'),
                  ),
                ],
                selected: {themeProvider.themeMode},
                onSelectionChanged: (Set<ThemeMode> selection) {
                  themeProvider.setThemeMode(selection.first);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountActions(bool isDarkMode) {
    return CustomCard(
      variant: CardVariant.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Actions',
            style: AppTypography.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Change Password',
                  onPressed: _changePassword,
                  variant: ButtonVariant.outline,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Download My Data',
                  onPressed: _downloadData,
                  variant: ButtonVariant.outline,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.download),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: 'Delete Account',
                  onPressed: _deleteAccount,
                  variant: ButtonVariant.danger,
                  size: ButtonSize.large,
                  icon: const Icon(Icons.delete_forever),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDarkMode
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.updateProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _hasUnsavedChanges = false;
        });
        _showSuccessMessage('Settings saved successfully');
      } else if (mounted) {
        _showErrorMessage(
          authProvider.errorMessage ?? 'Failed to save settings',
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('An unexpected error occurred');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _changePassword() {
    // TODO: Implement change password flow
    _showInfoMessage('Change password feature will be implemented soon');
  }

  void _downloadData() {
    // TODO: Implement data export
    _showInfoMessage('Data download feature will be implemented soon');
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and you will lose all your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete Account',
            onPressed: () {
              Navigator.of(context).pop();
              _showInfoMessage(
                'Account deletion feature will be implemented soon',
              );
            },
            variant: ButtonVariant.danger,
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
