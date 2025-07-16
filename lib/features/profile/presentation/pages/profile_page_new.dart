import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            state.userName.split(' ').map((e) => e[0]).join(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.userName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.userEmail,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Settings Section
                  _buildSectionTitle('Settings'),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    icon: Icons.dark_mode,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: state.isDarkMode,
                      onChanged: (_) =>
                          context.read<ProfileCubit>().toggleDarkMode(),
                    ),
                  ),

                  _buildSettingsTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    trailing: Switch(
                      value: state.isNotificationsEnabled,
                      onChanged: (_) =>
                          context.read<ProfileCubit>().toggleNotifications(),
                    ),
                  ),

                  _buildSettingsTile(
                    icon: Icons.language,
                    title: 'Language',
                    subtitle: 'English',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to language settings
                    },
                  ),

                  _buildSettingsTile(
                    icon: Icons.security,
                    title: 'Security',
                    subtitle: 'Password & Biometrics',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to security settings
                    },
                  ),

                  const SizedBox(height: 24),

                  // Account Section
                  _buildSectionTitle('Account'),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    subtitle: 'Update your information',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to edit profile
                    },
                  ),

                  _buildSettingsTile(
                    icon: Icons.wallet,
                    title: 'Payment Methods',
                    subtitle: 'Manage your cards',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to payment methods
                    },
                  ),

                  _buildSettingsTile(
                    icon: Icons.history,
                    title: 'Transaction History',
                    subtitle: 'View all transactions',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to transaction history
                    },
                  ),

                  const SizedBox(height: 24),

                  // Support Section
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    icon: Icons.help,
                    title: 'Help Center',
                    subtitle: 'Get help and support',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Navigate to help center
                    },
                  ),

                  _buildSettingsTile(
                    icon: Icons.info,
                    title: 'About',
                    subtitle: 'App version 1.0.0',
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Show about dialog
                    },
                  ),

                  const SizedBox(height: 32),

                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().logout(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
