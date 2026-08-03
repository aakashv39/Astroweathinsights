// ignore_for_file: unused_element_parameter

import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/controllers/astrologer_assistant_controller.dart';
import 'package:AstrowayCustomer/controllers/customer_support_controller.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/customer_support/customerSupportChatScreen.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/feedbackScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/settings_controller.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/block_astrologer_screen.dart';
import 'package:AstrowayCustomer/views/languageScreen.dart';
import 'package:AstrowayCustomer/widget/commonAppbar.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class SettingListScreen extends StatelessWidget {
  const SettingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: CommonAppBar(title: 'Settings'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Account Section ──────────────────────────────────────────
              _SectionLabel(label: 'Account'),
              const SizedBox(height: 8),
              _SettingsGroup(
                items: [
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    iconBgColor: const Color(0xFFE1F5EE),
                    iconColor: const Color(0xFF0F6E56),
                    title: 'Choose Language',
                    subtitle: 'App display language',
                    onTap: () async {
                      final homeController = Get.find<HomeController>();
                      homeController.lan = [];
                      await homeController.getLanguages();
                      await homeController.updateLanIndex();
                      Get.to(() => Languagescreen());
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.headphones,
                    iconBgColor: const Color(0xFFD8DFEF),
                    iconColor: const Color(0xFF0F186E),
                    title: 'Support Chat',
                    subtitle: '24/7 Support',
                    onTap: () async {
                      bool isLogin = await global.isLogin();
                      if (isLogin) {
                        final customerSupportController =
                            Get.find<CustomerSupportController>();
                        final astrologerAssistantController =
                            Get.find<AstrologerAssistantController>();
                        global.showOnlyLoaderDialog(context);
                        await customerSupportController.getCustomerTickets();
                        astrologerAssistantController
                            .getChatWithAstrologerAssisteant();
                        global.hideLoader();
                        Get.to(() => CustomerSupportChat());
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: CupertinoIcons.arrow_3_trianglepath,
                    iconBgColor: const Color(0xFFD8DFEF),
                    iconColor: const Color(0xFF0F186E),
                    title: 'FeedBack',
                    subtitle: 'Your feedback matters',
                    onTap: () async {
                      bool isLogin = await global.isLogin();
                      if (isLogin) {
                        Get.to(() => FeedbackScreen());
                      } else {
                        global.showToast(
                            message: 'Please login first',
                            textColor: Colors.white,
                            bgColor: Colors.black);
                      }
                    },
                  ),
                  GetBuilder<SettingsController>(
                    builder: (settingsController) {
                      if (settingsController.blockedAstroloer.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return _SettingsTile(
                        icon: Icons.block_rounded,
                        iconBgColor: const Color(0xFFFCEBEB),
                        iconColor: const Color(0xFFA32D2D),
                        title: 'Blocked Astrologers',
                        subtitle: 'Manage blocked profiles',
                        showDivider: false,
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          await settingsController.getBlockAstrologerList();
                          global.hideLoader();
                          Get.to(() => BlockAstrologerScreen());
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Legal Section ─────────────────────────────────────────────
              _SectionLabel(label: 'Legal'),
              const SizedBox(height: 8),
              _SettingsGroup(
                items: [
                  _SettingsTile(
                    icon: Icons.description_rounded,
                    iconBgColor: const Color(0xFFEEEDFE),
                    iconColor: const Color(0xFF534AB7),
                    title: 'Terms and Conditions',
                    subtitle: 'Usage policies',
                    onTap: () => launchUrl(Uri.parse(termsconditionUrl)),
                  ),
                  _SettingsTile(
                    icon: Icons.lock_rounded,
                    iconBgColor: const Color(0xFFE1F5EE),
                    iconColor: const Color(0xFF0F6E56),
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your data',
                    onTap: () => launchUrl(Uri.parse(privacyUrl)),
                  ),
                  _SettingsTile(
                    icon: Icons.receipt_long_rounded,
                    iconBgColor: const Color(0xFFFAEEDA),
                    iconColor: const Color(0xFF854F0B),
                    title: 'Refund Policy',
                    subtitle: 'Cancellations & returns',
                    showDivider: false,
                    onTap: () => launchUrl(Uri.parse(refundpolicy)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Danger Zone ───────────────────────────────────────────────
              _SectionLabel(label: 'Danger Zone'),
              const SizedBox(height: 8),
              _SettingsGroup(
                items: [
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    iconBgColor: const Color(0xFFF1EFE8),
                    iconColor: const Color(0xFF5F5E5A),
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    onTap: () => _showLogoutDialog(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ).tr(),
        content: const Text('Are you sure you want to logout?').tr(),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No', style: TextStyle(color: Colors.grey)).tr(),
          ),
          ElevatedButton(
            onPressed: () {
              final historyController = Get.find<HistoryController>();
              historyController.chatHistoryList.clear();
              historyController.astroMallHistoryList.clear();
              historyController.reportHistoryList.clear();
              historyController.callHistoryList.clear();
              historyController.paymentLogsList.clear();
              historyController.walletTransactionList.clear();
              global.logoutUser();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Get.theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white))
                .tr(),
          ),
        ],
      ),
    );
  }
}

// ── Section Label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 0.8,
        ),
      ).tr(),
    );
  }
}

// ── Settings Group (grouped card) ─────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final List<Widget> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children:
              items.where((w) => w is! SizedBox || (w).width != null).toList(),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final Color? chevronColor;
  final bool showDivider;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.chevronColor,
    this.showDivider = true,
    required this.onTap,
  });

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            color: _pressed ? Colors.grey.shade100 : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.iconBgColor,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 18,
                    color: widget.iconColor,
                  ),
                ),
                const SizedBox(width: 14),
                // Title + subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: widget.titleColor ?? Colors.black87,
                        ),
                      ).tr(),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.subtitleColor ?? Colors.grey.shade500,
                        ),
                      ).tr(),
                    ],
                  ),
                ),
                // Chevron
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: widget.chevronColor ?? Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
        if (widget.showDivider)
          Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 66,
            endIndent: 0,
            color: Colors.grey.shade200,
          ),
      ],
    );
  }
}
