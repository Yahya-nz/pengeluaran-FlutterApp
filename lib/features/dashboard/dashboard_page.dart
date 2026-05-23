import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  static const routeName = '/home';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  _DashboardSurface _surface = _DashboardSurface.main;

  static const _transactions = [
    _TransactionItem(
      title: 'Makanan',
      note: 'Beli jajan kopi sama temen',
      amount: '- 30.000',
      time: '11:55 AM',
      icon: Icons.restaurant_rounded,
      color: SakuColors.danger,
    ),
    _TransactionItem(
      title: 'Hadiah',
      note: 'THR dari bos',
      amount: '+ 30.000',
      time: '11:55 AM',
      icon: Icons.card_giftcard_rounded,
      color: SakuColors.success,
    ),
    _TransactionItem(
      title: 'Transportasi',
      note: 'Bensin pulang kampus',
      amount: '- 45.000',
      time: '09:20 AM',
      icon: Icons.directions_car_rounded,
      color: SakuColors.danger,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                child: switch (_surface) {
                  _DashboardSurface.budget => _BudgetDashboard(
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                    ),
                  _DashboardSurface.insight => _InsightDashboard(
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                    ),
                  _DashboardSurface.addDebt => _AddNoteDashboard(
                      mode: _AddNoteMode.debt,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(
                          () => _surface = mode == _AddNoteMode.debt
                              ? _DashboardSurface.addDebt
                              : _DashboardSurface.addLoan,
                        );
                      },
                    ),
                  _DashboardSurface.addLoan => _AddNoteDashboard(
                      mode: _AddNoteMode.loan,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(
                          () => _surface = mode == _AddNoteMode.debt
                              ? _DashboardSurface.addDebt
                              : _DashboardSurface.addLoan,
                        );
                      },
                    ),
                  _DashboardSurface.main => switch (_currentIndex) {
                      0 => _HomeDashboard(
                          transactions: _transactions,
                          onOpenBudget: () {
                            setState(
                              () => _surface = _DashboardSurface.budget,
                            );
                          },
                          onOpenInsight: () {
                            setState(
                              () => _surface = _DashboardSurface.insight,
                            );
                          },
                        ),
                      1 => const _HistoryDashboard(
                          transactions: _transactions,
                        ),
                      2 => const _ChartDashboard(),
                      _ => const _ProfileDashboard(),
                    },
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: _surface == _DashboardSurface.insight ||
              _surface == _DashboardSurface.addDebt ||
              _surface == _DashboardSurface.addLoan
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() => _surface = _DashboardSurface.addDebt);
              },
              backgroundColor: SakuColors.mango500,
              foregroundColor: SakuColors.white,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded, size: 34),
            ),
      floatingActionButtonLocation: _surface == _DashboardSurface.main
          ? FloatingActionButtonLocation.centerDocked
          : FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _surface == _DashboardSurface.main
          ? Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Center(
                heightFactor: 1,
                child: SizedBox(
                  width: 430,
                  child: NavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (index) {
                      setState(() => _currentIndex = index);
                    },
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
  }
}

enum _DashboardSurface { main, budget, insight, addDebt, addLoan }

enum _AddNoteMode { debt, loan }

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

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.transactions,
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final List<_TransactionItem> transactions;
  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 28),
          decoration: const BoxDecoration(
            color: SakuColors.blue100,
            image: DecorationImage(
              image: AssetImage('background beranda biru.png'),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: SakuColors.blue50,
                    child: Icon(
                      Icons.person_rounded,
                      color: SakuColors.blue700,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Hei, Asadel!',
                      style: TextStyle(
                        color: SakuColors.white,
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(LoginPage.routeName);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: SakuColors.white.withValues(alpha: 0.2),
                      foregroundColor: SakuColors.white,
                    ),
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              const _BalanceCard(),
              const SizedBox(height: 20),
              _HeroTools(
                onOpenBudget: onOpenBudget,
                onOpenInsight: onOpenInsight,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            children: [
              _RecentNotesCard(transactions: transactions.take(2).toList()),
              const SizedBox(height: 20),
              const _ActiveDebtCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryDashboard extends StatelessWidget {
  const _HistoryDashboard({required this.transactions});

  final List<_TransactionItem> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
      children: [
        const Text(
          'Riwayat',
          style: TextStyle(
            color: SakuColors.black,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari catatan...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.filter_alt_rounded),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _MonthHeader(),
        const SizedBox(height: 14),
        _CardList(
          children: transactions
              .map((transaction) => _TransactionTile(item: transaction))
              .toList(),
        ),
      ],
    );
  }
}

class _BudgetDashboard extends StatelessWidget {
  const _BudgetDashboard({required this.onBack});

  final VoidCallback onBack;

  static const _budgets = [
    _BudgetItem(
      title: 'Transportasi',
      amount: 'Rp 200.000',
      remaining: 'sisa 50%',
      progress: 0.5,
      icon: Icons.directions_car_rounded,
    ),
    _BudgetItem(
      title: 'Belanja',
      amount: 'Rp 150.000',
      remaining: 'sisa 40%',
      progress: 0.4,
      icon: Icons.shopping_cart_rounded,
    ),
    _BudgetItem(
      title: 'Skincare',
      amount: 'Rp 300.000',
      remaining: 'sisa 35%',
      progress: 0.35,
      icon: Icons.spa_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Budget', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 120),
            children: [
              const Text(
                'Budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan Nominal Budget..',
                  filled: true,
                  fillColor: SakuColors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: SakuColors.neutral300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: SakuColors.neutral300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: SakuColors.mango500),
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'Katagori budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              ..._budgets.map(_BudgetRow.new),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightDashboard extends StatelessWidget {
  const _InsightDashboard({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Saku Insight', onBack: onBack),
        Expanded(
          child: Container(
            color: SakuColors.blue50,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(42, 30, 42, 24),
                    children: const [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _QuickQuestionBubble(),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '1:27',
                        style: TextStyle(
                          color: SakuColors.neutral300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const _InsightComposer(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AddNoteDashboard extends StatelessWidget {
  const _AddNoteDashboard({
    required this.mode,
    required this.onBack,
    required this.onSwitchMode,
  });

  final _AddNoteMode mode;
  final VoidCallback onBack;
  final ValueChanged<_AddNoteMode> onSwitchMode;

  bool get _isLoan => mode == _AddNoteMode.loan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Tambah Catatan', onBack: onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 18, 32, 14),
            children: [
              _AddNoteTypeSelector(
                mode: mode,
                onSwitchMode: onSwitchMode,
              ),
              const SizedBox(height: 24),
              const Row(
                children: [
                  Expanded(
                    child: _PillField(
                      text: '21 April 2026',
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _PillField(
                      text: '8:21 AM',
                      icon: Icons.access_time_filled_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(
                    child: _LabeledPillField(
                      label: 'Nama',
                      text: 'Nama',
                      icon: null,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _LabeledPillField(
                      label: 'Jatuh Tempo',
                      text: '12 Juni 2026',
                      icon: Icons.calendar_month_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _LabeledPillField(
                label: 'Catatan',
                text: 'Tulis catatan atau keterangan disini',
                icon: null,
              ),
              if (_isLoan) ...[
                const SizedBox(height: 14),
                const Text(
                  'Dompet',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                const SizedBox(
                  width: 164,
                  child: _WalletPicker(),
                ),
              ],
            ],
          ),
        ),
        Container(
          color: SakuColors.blue50,
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 12),
          child: const Column(
            children: [
              _AmountDisplay(),
              SizedBox(height: 6),
              _CalculatorPad(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartDashboard extends StatelessWidget {
  const _ChartDashboard();

  static const _categories = [
    _ChartCategory(
      title: 'Olahraga',
      percent: 8,
      amount: '80.000',
      icon: Icons.sports_soccer_rounded,
      color: Color(0xFFFF355D),
    ),
    _ChartCategory(
      title: 'Makanan',
      percent: 8,
      amount: '80.000',
      icon: Icons.fastfood_rounded,
      color: Color(0xFFF9EA18),
    ),
    _ChartCategory(
      title: 'Transportasi',
      percent: 8,
      amount: '80.000',
      icon: Icons.directions_car_rounded,
      color: Color(0xFFFFBE3D),
    ),
    _ChartCategory(
      title: 'Rumah',
      percent: 8,
      amount: '80.000',
      icon: Icons.home_rounded,
      color: Color(0xFFFF7D31),
    ),
    _ChartCategory(
      title: 'Belanja',
      percent: 7,
      amount: '70.000',
      icon: Icons.shopping_cart_rounded,
      color: Color(0xFFE5007D),
    ),
    _ChartCategory(
      title: 'Pendidikan',
      percent: 7,
      amount: '70.000',
      icon: Icons.school_rounded,
      color: Color(0xFF5AC97B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: const [
        _MonthTopBar(),
        SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: _PeriodFilter(),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: _ChartSection(
            title: 'Pengeluaran',
            total: '1.000.000',
            categories: _categories,
            accent: SakuColors.danger,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: _CompactIncomeCard(),
        ),
      ],
    );
  }
}

class _ProfileDashboard extends StatelessWidget {
  const _ProfileDashboard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        const _ProfileHeader(),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
          decoration: const BoxDecoration(
            color: SakuColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileSectionTitle('List Dompet'),
              SizedBox(height: 12),
              _AddWalletCard(),
              SizedBox(height: 24),
              _ProfileSectionTitle('Informasi Akun'),
              SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.person_rounded,
                title: 'Nama',
                subtitle: 'Asadel',
              ),
              SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.mail_rounded,
                title: 'Email',
                subtitle: 'adel123@gmail.com',
              ),
              SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.lock_rounded,
                title: 'Password',
                subtitle: '********',
              ),
              SizedBox(height: 24),
              _ProfileSectionTitle('Pengaturan'),
              SizedBox(height: 12),
              _NotificationTile(),
              SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.logout_rounded,
                title: 'Keluar',
                subtitle: 'Kembali ke halaman masuk',
                iconColor: SakuColors.mango500,
                trailing: Icons.chevron_right_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BudgetRow extends StatelessWidget {
  const _BudgetRow(this.item);

  final _BudgetItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: SakuColors.neutral100)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: SakuColors.neutral300, width: 1.4),
            ),
            child: Icon(item.icon, color: SakuColors.blue700, size: 26),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.amount,
                      style: const TextStyle(
                        color: SakuColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: item.progress,
                          minHeight: 14,
                          color: SakuColors.mango500,
                          backgroundColor: SakuColors.neutral100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.remaining,
                      style: const TextStyle(
                        color: SakuColors.neutral300,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickQuestionBubble extends StatelessWidget {
  const _QuickQuestionBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pertanyaan Cepat',
            style: TextStyle(
              color: SakuColors.blue700,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          _QuestionPill('Catatan pembelian cepat'),
          SizedBox(height: 8),
          _QuestionPill('Tips hemat buat aku dong'),
          SizedBox(height: 8),
          _QuestionPill('Bulan ini boros dimana?'),
        ],
      ),
    );
  }
}

class _QuestionPill extends StatelessWidget {
  const _QuestionPill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.blue300,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(13),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: SakuColors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _InsightComposer extends StatelessWidget {
  const _InsightComposer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.white,
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tanya AI...',
                filled: true,
                fillColor: SakuColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: SakuColors.blue300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton.filled(
              onPressed: () {},
              style: IconButton.styleFrom(backgroundColor: SakuColors.blue300),
              icon: const Icon(
                Icons.send_rounded,
                color: SakuColors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddNoteTypeSelector extends StatelessWidget {
  const _AddNoteTypeSelector({
    required this.mode,
    required this.onSwitchMode,
  });

  final _AddNoteMode mode;
  final ValueChanged<_AddNoteMode> onSwitchMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: SakuColors.neutral100,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          const _SmallModeIcon(icon: Icons.paid_outlined),
          const SizedBox(width: 10),
          const _SmallModeIcon(icon: Icons.savings_outlined),
          const SizedBox(width: 10),
          Expanded(
            flex: mode == _AddNoteMode.debt ? 5 : 3,
            child: _ModeChip(
              selected: mode == _AddNoteMode.debt,
              label: 'Hutang',
              icon: Icons.payments_outlined,
              onTap: () => onSwitchMode(_AddNoteMode.debt),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == _AddNoteMode.loan ? 5 : 3,
            child: _ModeChip(
              selected: mode == _AddNoteMode.loan,
              label: 'Beri Pinjaman',
              icon: Icons.request_quote_outlined,
              onTap: () => onSwitchMode(_AddNoteMode.loan),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallModeIcon extends StatelessWidget {
  const _SmallModeIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 36,
      child: Icon(icon, color: SakuColors.black, size: 25),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SakuColors.blue100 : Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: SakuColors.black, size: 24),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: const TextStyle(
                      color: SakuColors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
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
}

class _PillField extends StatelessWidget {
  const _PillField({required this.text, this.icon});

  final String text;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SakuColors.neutral300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: SakuColors.neutral700,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (icon != null) Icon(icon, color: SakuColors.neutral300),
        ],
      ),
    );
  }
}

class _LabeledPillField extends StatelessWidget {
  const _LabeledPillField({
    required this.label,
    required this.text,
    this.icon,
  });

  final String label;
  final String text;
  final IconData? icon;

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
        _PillField(text: text, icon: icon),
      ],
    );
  }
}

class _WalletPicker extends StatelessWidget {
  const _WalletPicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: SakuColors.neutral300),
      ),
      child: const Row(
        children: [
          Icon(Icons.credit_card_rounded, color: SakuColors.mango500),
          SizedBox(width: 6),
          Expanded(
            child: Text(
              'BSI',
              style: TextStyle(
                color: SakuColors.neutral700,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down_rounded, color: SakuColors.black),
        ],
      ),
    );
  }
}

class _AmountDisplay extends StatelessWidget {
  const _AmountDisplay();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SakuColors.neutral300),
      ),
      alignment: Alignment.centerRight,
      child: const Text(
        '0',
        style: TextStyle(
          color: SakuColors.neutral300,
          fontSize: 31,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CalculatorPad extends StatelessWidget {
  const _CalculatorPad();

  static const _rows = [
    ['x', '-', '+', 'back'],
    ['1', '2', '3', 'C'],
    ['4', '5', '6', '='],
    ['7', '8', '9', 'Simpan'],
    ['', '0', '000', 'Simpan'],
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        children: List.generate(_rows.length, (rowIndex) {
          return Expanded(
            child: Row(
              children: List.generate(_rows[rowIndex].length, (index) {
                final label = _rows[rowIndex][index];
                if (label.isEmpty) {
                  return const Expanded(child: SizedBox.shrink());
                }
                if (label == 'Simpan' && rowIndex == 4) {
                  return const Expanded(child: SizedBox.shrink());
                }
                final rowSpan = label == 'Simpan';
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: SizedBox(
                      height: rowSpan ? double.infinity : null,
                      child: _KeypadButton(
                        label: label,
                        tall: rowSpan,
                        onTap: () {},
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.label,
    required this.onTap,
    this.tall = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final isAction = label == '=' || label == 'Simpan';
    final isMuted = label == 'back' || label == 'C' || label == 'Simpan';

    return Material(
      color: isAction
          ? (label == '=' ? SakuColors.blue100 : SakuColors.neutral300)
          : (isMuted ? SakuColors.neutral100 : SakuColors.white),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Center(
          child: label == 'back'
              ? const Icon(Icons.backspace_outlined,
                  color: SakuColors.neutral600)
              : Text(
                  label,
                  style: TextStyle(
                    color:
                        label == 'Simpan' ? SakuColors.white : SakuColors.black,
                    fontSize: label == 'Simpan' ? 18 : 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
      ),
    );
  }
}

class _MonthTopBar extends StatelessWidget {
  const _MonthTopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.blue100,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
      child: const Row(
        children: [
          Icon(Icons.chevron_left_rounded, color: SakuColors.blue900, size: 34),
          Expanded(
            child: Column(
              children: [
                Text(
                  'April',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '2026',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: SakuColors.blue900, size: 34),
        ],
      ),
    );
  }
}

class _PeriodFilter extends StatelessWidget {
  const _PeriodFilter();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: SakuColors.neutral600,
        side: const BorderSide(color: SakuColors.neutral300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Pilih Periode'),
          SizedBox(width: 24),
          Icon(Icons.keyboard_arrow_down_rounded, color: SakuColors.black),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection({
    required this.title,
    required this.total,
    required this.categories,
    required this.accent,
  });

  final String title;
  final String total;
  final List<_ChartCategory> categories;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(radius: 10),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
            child: Row(
              children: [
                Icon(Icons.paid_outlined, color: accent, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: SakuColors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: SakuColors.neutral100),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 26),
            child: SizedBox(
              height: 230,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(210, 210),
                    painter: _DonutChartPainter(categories),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: SakuColors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        total,
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ...categories.take(4).map((category) => _CategoryRow(category)),
          Material(
            color: SakuColors.neutral100,
            child: InkWell(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lihat Lainnya',
                      style: TextStyle(
                        color: SakuColors.neutral600,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: SakuColors.neutral600,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactIncomeCard extends StatelessWidget {
  const _CompactIncomeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 10),
      child: const Row(
        children: [
          Icon(Icons.paid_outlined, color: SakuColors.success, size: 28),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Pemasukan',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 23,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            '13.000.000',
            style: TextStyle(
              color: SakuColors.success,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow(this.category);

  final _ChartCategory category;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: SakuColors.neutral100)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: category.color,
            child: Icon(category.icon, color: SakuColors.black, size: 15),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              category.title,
              style: const TextStyle(
                color: SakuColors.neutral700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            '${category.percent}%',
            style: const TextStyle(
              color: SakuColors.neutral700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        color: SakuColors.blue100,
        image: DecorationImage(
          image: AssetImage('background beranda biru.png'),
          fit: BoxFit.cover,
          opacity: 0.32,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 34,
            child: Container(
              width: 94,
              height: 94,
              decoration: BoxDecoration(
                color: SakuColors.blue50,
                shape: BoxShape.circle,
                border: Border.all(color: SakuColors.white, width: 4),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: SakuColors.blue700,
                size: 62,
              ),
            ),
          ),
          Positioned(
            top: 104,
            right: 165,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: SakuColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded),
            ),
          ),
          const Positioned(
            top: 140,
            child: Text(
              'Asadel',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSectionTitle extends StatelessWidget {
  const _ProfileSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: SakuColors.black,
        fontSize: 16,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _AddWalletCard extends StatelessWidget {
  const _AddWalletCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.neutral100,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: const Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: SakuColors.neutral300,
                child:
                    Icon(Icons.add_rounded, color: SakuColors.white, size: 34),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Tambah dompet baru',
                  style: TextStyle(
                    color: SakuColors.neutral600,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor = SakuColors.blue700,
    this.trailing = Icons.chevron_right_rounded,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final IconData trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SakuColors.neutral300),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 27),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SakuColors.neutral300,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(trailing, color: SakuColors.neutral600, size: 30),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SakuColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SakuColors.neutral300),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_rounded, color: SakuColors.mango500),
          const SizedBox(width: 18),
          const Expanded(
            child: Text(
              'Notifikasi',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Switch(
            value: true,
            onChanged: (_) {},
            activeThumbColor: SakuColors.white,
            activeTrackColor: SakuColors.mango500,
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(26, 28, 26, 24),
      decoration: BoxDecoration(
        color: SakuColors.blue900.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: SakuColors.blue900.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Total Saldo',
                  style: TextStyle(
                    color: SakuColors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.visibility_outlined,
                color: SakuColors.white,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: SakuColors.blue100,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: SakuColors.blue300, width: 2),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                '12.000.000',
                style: TextStyle(
                  color: SakuColors.neutral700,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: SakuColors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: SakuColors.blue300, width: 2),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: _HeroMetric(
                    title: 'Pengeluaran',
                    amount: '1.000.000',
                    icon: Icons.trending_down_rounded,
                    color: SakuColors.danger,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _HeroMetric(
                    title: 'Pemasukan',
                    amount: '13.000.000',
                    icon: Icons.trending_up_rounded,
                    color: SakuColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 26),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  amount,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroTools extends StatelessWidget {
  const _HeroTools({
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final VoidCallback onOpenBudget;
  final VoidCallback onOpenInsight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 224,
              padding: const EdgeInsets.all(13),
              decoration: _cardDecoration(radius: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _ToolShortcut(
                      title: 'Budgeting',
                      icon: Icons.savings_rounded,
                      onTap: onOpenBudget,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ToolShortcut(
                      title: 'Saku Insight',
                      icon: Icons.insights_rounded,
                      onTap: onOpenInsight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Positioned(
            right: 2,
            bottom: -2,
            child: Image(
              image: AssetImage('Maskot-dashboard.png'),
              width: 156,
              height: 98,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolShortcut extends StatelessWidget {
  const _ToolShortcut({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: SakuColors.blue50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SakuColors.blue100, width: 2),
            ),
            child: Icon(icon, color: SakuColors.blue300, size: 34),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentNotesCard extends StatelessWidget {
  const _RecentNotesCard({required this.transactions});

  final List<_TransactionItem> transactions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(radius: 18),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Catatan Terakhir',
                style: TextStyle(
                  color: SakuColors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          Container(
            color: SakuColors.blue50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: const Row(
              children: [
                Text(
                  '18',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 44,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'April',
                        style: TextStyle(
                          color: SakuColors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Sabtu',
                        style: TextStyle(
                          color: SakuColors.neutral300,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '11.970.000',
                  style: TextStyle(
                    color: SakuColors.neutral700,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          ...transactions.map((transaction) => _TransactionTile(
                item: transaction,
                compactIcon: true,
              )),
          Material(
            color: SakuColors.neutral100,
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(18),
            ),
            child: InkWell(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(18),
              ),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Lihat riwayat lainnya',
                          style: TextStyle(
                            color: SakuColors.neutral600,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: SakuColors.neutral600,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveDebtCard extends StatelessWidget {
  const _ActiveDebtCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(radius: 18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hutang Aktif',
            style: TextStyle(
              color: SakuColors.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          _DebtTile(
            title: 'Hutang',
            person: 'Anisa',
            amount: '30.000',
            due: '30 April 2026',
          ),
          Divider(height: 1, color: SakuColors.neutral100),
          _DebtTile(
            title: 'Beri Pinjaman',
            person: 'Nadia',
            amount: '20.000',
            due: '02 Mei 2026',
          ),
        ],
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({
    required this.title,
    required this.person,
    required this.amount,
    required this.due,
  });

  final String title;
  final String person;
  final String amount;
  final String due;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SakuColors.neutral300, width: 1.5),
            ),
            child: const Icon(
              Icons.payments_outlined,
              color: SakuColors.sage500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: SakuColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    children: const [
                      TextSpan(
                        text: ' Belum Lunas',
                        style: TextStyle(
                          color: SakuColors.danger,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '$person - jatuh tempo',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SakuColors.neutral300,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    amount,
                    style: const TextStyle(
                      color: SakuColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    due,
                    style: const TextStyle(
                      color: SakuColors.neutral300,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardList extends StatelessWidget {
  const _CardList({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(children: children),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item, this.compactIcon = false});

  final _TransactionItem item;
  final bool compactIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: compactIcon
                  ? SakuColors.white
                  : item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(compactIcon ? 12 : 14),
              border: compactIcon
                  ? Border.all(color: SakuColors.neutral300, width: 1.5)
                  : null,
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: compactIcon ? 20 : 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.note,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: SakuColors.neutral300),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.time,
                style: const TextStyle(color: SakuColors.neutral300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.chevron_left_rounded, color: SakuColors.blue900),
          Expanded(
            child: Column(
              children: [
                Text(
                  'April',
                  style: TextStyle(
                    color: SakuColors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '2026',
                  style: TextStyle(
                    color: SakuColors.neutral700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: SakuColors.blue900),
        ],
      ),
    );
  }
}

class _ChartCategory {
  const _ChartCategory({
    required this.title,
    required this.percent,
    required this.amount,
    required this.icon,
    required this.color,
  });

  final String title;
  final int percent;
  final String amount;
  final IconData icon;
  final Color color;
}

class _BudgetItem {
  const _BudgetItem({
    required this.title,
    required this.amount,
    required this.remaining,
    required this.progress,
    required this.icon,
  });

  final String title;
  final String amount;
  final String remaining;
  final double progress;
  final IconData icon;
}

class _DonutChartPainter extends CustomPainter {
  const _DonutChartPainter(this.categories);

  final List<_ChartCategory> categories;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 48
      ..strokeCap = StrokeCap.butt;

    var startAngle = -math.pi / 2;
    final total = categories.fold<int>(0, (sum, item) => sum + item.percent);

    for (final category in categories) {
      final sweepAngle = math.pi * 2 * (category.percent / total);
      paint.color = category.color;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.categories != categories;
  }
}

class _TransactionItem {
  const _TransactionItem({
    required this.title,
    required this.note,
    required this.amount,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String note;
  final String amount;
  final String time;
  final IconData icon;
  final Color color;
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
