import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/theme/app_colors.dart';
import '../auth/google_auth_service.dart';
import '../auth/login_page.dart';
import 'bloc/dashboard_cubit.dart';

part 'widgets/dashboard_content.dart';
part 'widgets/home_page.dart';
part 'widgets/history_page.dart';
part 'widgets/budget_page.dart';
part 'widgets/insight_page.dart';
part 'widgets/notifications_page.dart';
part 'widgets/add_note_page.dart';
part 'widgets/edit_transaction_page.dart';
part 'widgets/chart_page.dart';
part 'widgets/profile_page.dart';

typedef _DashboardSurface = DashboardSurface;
typedef _AddNoteMode = AddNoteMode;
typedef _TransactionItem = DashboardTransaction;
typedef _BudgetItem = DashboardBudget;

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.userName = 'Asadel',
    this.userEmail = 'adel123@gmail.com',
    this.openAddNote = false,
  });

  static const routeName = '/home';
  final String userName;
  final String userEmail;
  final bool openAddNote;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';

  Future<void> _requestHomeWidget() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      _showInfoDialog(
        context,
        title: 'Widget Homescreen',
        message:
            'Widget ringkasan siap untuk Android. Tambahkan dari homescreen perangkat Android setelah aplikasi diinstal.',
      );
      return;
    }

    try {
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
      final supported = await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (supported) {
        await HomeWidget.requestPinWidget(name: _homeWidgetProvider);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permintaan widget dikirim ke homescreen')),
        );
      } else {
        if (!mounted) return;
        _showInfoDialog(
          context,
          title: 'Tambahkan Widget',
          message:
              'Tekan lama area kosong di homescreen, pilih Widget, lalu pilih Saku Ringkasan.',
        );
      }
    } catch (_) {
      if (!mounted) return;
      _showInfoDialog(
        context,
        title: 'Tambahkan Widget',
        message:
            'Tekan lama area kosong di homescreen, pilih Widget, lalu pilih Saku Ringkasan.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DashboardCubit(openAddNote: widget.openAddNote)..syncHomeWidget(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final cubit = context.read<DashboardCubit>();
          return Scaffold(
            backgroundColor: SakuColors.neutral50,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final pageWidth =
                      constraints.maxWidth > 430 ? 430.0 : constraints.maxWidth;

                  return Center(
                    child: SizedBox(
                      width: pageWidth,
                      height: constraints.maxHeight,
                      child: _DashboardContent(
                        state: state,
                        userName: widget.userName,
                        userEmail: widget.userEmail,
                        onRequestHomeWidget: _requestHomeWidget,
                      ),
                    ),
                  );
                },
              ),
            ),
            floatingActionButton: state.hidesFloatingActionButton
                ? null
                : FloatingActionButton(
                    onPressed: () {
                      if (state.surface == _DashboardSurface.budget) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => _BudgetFormDialog(
                            onSave: (item) {
                              cubit.addBudget(item);
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                        return;
                      }
                      cubit.showAddNote();
                    },
                    backgroundColor: SakuColors.mango500,
                    foregroundColor: SakuColors.white,
                    shape: const CircleBorder(),
                    child: const Icon(Icons.add_rounded, size: 34),
                  ),
            floatingActionButtonLocation: state.showBottomNavigation
                ? FloatingActionButtonLocation.centerDocked
                : FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: state.showBottomNavigation
                ? Container(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    child: Center(
                      heightFactor: 1,
                      child: SizedBox(
                        width: 430,
                        child: NavigationBar(
                          selectedIndex: state.currentIndex,
                          onDestinationSelected: cubit.selectTab,
                          indicatorColor: SakuColors.blue100,
                          destinations: const [
                            NavigationDestination(
                              icon: Icon(Icons.home_outlined),
                              selectedIcon: Icon(Icons.home_rounded),
                              label: 'Beranda',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.receipt_long_outlined),
                              selectedIcon: Icon(Icons.receipt_long_rounded),
                              label: 'Riwayat',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.pie_chart_outline_rounded),
                              selectedIcon: Icon(Icons.pie_chart_rounded),
                              label: 'Grafik',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.person_outline_rounded),
                              selectedIcon: Icon(Icons.person_rounded),
                              label: 'Profil',
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _ChildPageTopBar extends StatelessWidget {
  const _ChildPageTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SakuColors.white,
        boxShadow: [
          BoxShadow(
            color: SakuColors.black.withValues(alpha: 0.16),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            const SizedBox(width: 14),
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left_rounded, size: 34),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogSelectField extends StatelessWidget {
  const _DialogSelectField({
    required this.label,
    required this.value,
    this.icon,
    required this.trailing,
    this.muted = false,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final IconData trailing;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: SakuColors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: SakuColors.white,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SakuColors.neutral300),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: SakuColors.mango500, size: 22),
                    const SizedBox(width: 6),
                  ],
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: muted
                            ? SakuColors.neutral300
                            : SakuColors.neutral700,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(trailing, color: SakuColors.black),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(radius: 18),
      child: Column(
        children: [
          Icon(icon, color: SakuColors.neutral300, size: 42),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: SakuColors.black,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SakuColors.neutral300,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  const _NotificationItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.fromUser,
    required this.time,
  });

  final String text;
  final bool fromUser;
  final String time;
}

class _WalletItem {
  const _WalletItem({required this.name, required this.balance});

  final String name;
  final int balance;
}

BoxDecoration _cardDecoration({double radius = 20}) {
  return BoxDecoration(
    color: SakuColors.white,
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: SakuColors.black.withValues(alpha: 0.06),
        blurRadius: 18,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

void _showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: SakuColors.neutral600,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: SakuColors.blue300,
                  foregroundColor: SakuColors.white,
                ),
                child: const Text('Mengerti'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _formatPlain(int value) {
  final text = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final position = text.length - i;
    buffer.write(text[i]);
    if (position > 1 && position % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

int _parseCurrency(String value) {
  return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
}

IconData _categoryIcon(String category) {
  return switch (category) {
    'Makanan' => Icons.restaurant_rounded,
    'Transportasi' => Icons.directions_car_rounded,
    'Rumah' => Icons.home_rounded,
    'Belanja' => Icons.shopping_cart_rounded,
    'Pendidikan' => Icons.school_rounded,
    'Hiburan' => Icons.movie_rounded,
    'Kesehatan' => Icons.health_and_safety_rounded,
    'Kecantikan' => Icons.spa_rounded,
    'Olahraga' => Icons.sports_soccer_rounded,
    'Darurat' => Icons.emergency_rounded,
    'Sedekah' => Icons.volunteer_activism_rounded,
    'Hadiah' => Icons.card_giftcard_rounded,
    'Gaji' => Icons.account_balance_wallet_rounded,
    'Freelance' => Icons.self_improvement_rounded,
    'Bisnis' => Icons.handshake_rounded,
    'Penjualan' => Icons.storefront_rounded,
    'Investasi' => Icons.trending_up_rounded,
    'Sewa' => Icons.receipt_long_rounded,
    'Uang Saku' => Icons.savings_rounded,
    'Hutang' => Icons.payments_outlined,
    'Beri Pinjaman' => Icons.request_quote_outlined,
    'Semua' => Icons.apps_rounded,
    _ => Icons.work_rounded,
  };
}

String? _categoryAsset(String category) {
  return switch (category) {
    'Makanan' => 'assets/icons/Property 1=makanan.png',
    'Transportasi' => 'assets/icons/Property 1=kendaraan.png',
    'Rumah' => 'assets/icons/Property 1=rumah.png',
    'Kesehatan' => 'assets/icons/Property 1=kesehatan.png',
    'Belanja' => 'assets/icons/Property 1=belanja.png',
    'Kecantikan' => 'assets/icons/Property 1=kecantikan.png',
    'Hiburan' => 'assets/icons/Property 1=hiburan.png',
    'Pendidikan' => 'assets/icons/Property 1=pendidikan.png',
    'Olahraga' => 'assets/icons/Property 1=olahraga.png',
    'Darurat' => 'assets/icons/Property 1=darurat.png',
    'Sedekah' => 'assets/icons/Property 1=sedekah.png',
    'Lainnya' => 'assets/icons/Property 1=lainnya.png',
    'Gaji' => 'assets/icons/Property 1=gaji.png',
    'Freelance' => 'assets/icons/Property 1=freelance.png',
    'Bisnis' => 'assets/icons/Property 1=bisnis.png',
    'Hadiah' => 'assets/icons/Property 1=hadiah.png',
    'Penjualan' => 'assets/icons/Property 1=penjualan.png',
    'Investasi' => 'assets/icons/Property 1=investasi.png',
    'Sewa' => 'assets/icons/Property 1=sewa.png',
    'Uang Saku' => 'assets/icons/Property 1=uangsaku.png',
    _ => null,
  };
}
