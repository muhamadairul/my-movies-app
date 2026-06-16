import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../providers/auth_provider.dart';

/// Halaman profil pengguna dengan info dan logout.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Avatar
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.accentGoldSoft,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accentGold, width: 2),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.accentGold,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              // Name
              Text(
                'Muhamad Airul Mustakim',
                style: AppTextStyles.headingM,
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                '3124510015',
                style: AppTextStyles.bodyM,
              ),
              const SizedBox(height: 8),
              // Email
              Text(
                authProvider.userEmail,
                style: AppTextStyles.bodyM,
              ),
              const SizedBox(height: 40),
              // Menu items
              _buildMenuItem(
                icon: Icons.settings_outlined,
                label: 'Pengaturan',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                label: 'Bantuan',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                label: 'Tentang Aplikasi',
                onTap: () {},
              ),
              const Spacer(),
              // Logout button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Keluar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.2),
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label, style: AppTextStyles.bodyL),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}