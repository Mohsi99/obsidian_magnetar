import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:obsidian_magnetar/core/contants/app_colors.dart';
import 'package:obsidian_magnetar/providers/currency_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>().currency;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.gray900,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const _ProfileHeader(),
              SizedBox(
                height: 30,
              ),
              _SectionHeader(title: 'Account Settings'),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.currency_exchange,
                title: "Currency",
                onTap: () => _showCurrencyPicker(context),
                value: "${currency.code} ${currency.symbol}",
              ),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                value: 'On',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.lock_outline,
                title: 'Privacy & Security',
                onTap: () {},
              ),
              const SizedBox(height: 32),
              _SectionHeader(title: 'App Settings'),
              const SizedBox(height: 16),
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                value: 'Light',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.info_outline,
                title: 'About',
                onTap: () {},
              ),
              const SizedBox(height: 48),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Log Out',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.danger500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Select Currency',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gray900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: AppCurrencies.all.map((currency) {
                        final isSelected =
                            context.read<CurrencyProvider>().currency == currency;
                        return InkWell(
                          onTap: () {
                            context
                                .read<CurrencyProvider>()
                                .setCurrency(currency);
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            color: isSelected
                                ? AppColors.primary100
                                : Colors.transparent,
                            child: Row(
                              children: [
                                Text(
                                  currency.symbol,
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.primary600
                                        : AppColors.gray500,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    currency.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? AppColors.primary600
                                          : AppColors.gray900,
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary600,
                                    size: 20,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary100, width: 2),
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primary100,
              child: Text(
                'JD',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "John Doe",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray900,
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'john.doe@example.com',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.gray500,
                ),
              ),
            ],
          )),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.gray500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gray100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.gray900,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                ),
              ),
              if (value != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.gray500,
                    ),
                  ),
                ),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.gray400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
