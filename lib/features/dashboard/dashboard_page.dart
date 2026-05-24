import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/theme/app_colors.dart';
import '../auth/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    this.userName = 'Asadel',
    this.userEmail = 'adel123@gmail.com',
  });

  static const routeName = '/home';
  final String userName;
  final String userEmail;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const _homeWidgetProvider = 'SakuSummaryWidgetProvider';
  static const _initialBalance = 12045000;

  int _currentIndex = 0;
  _DashboardSurface _surface = _DashboardSurface.main;
  _TransactionItem? _editingTransaction;
  final List<_TransactionItem> _transactions = [
    const _TransactionItem(
      title: 'Makanan',
      note: 'Beli jajan kopi sama temen',
      amountValue: -30000,
      time: '11:55 AM',
      icon: Icons.restaurant_rounded,
      color: SakuColors.danger,
    ),
    const _TransactionItem(
      title: 'Hadiah',
      note: 'THR dari bos',
      amountValue: 30000,
      time: '11:55 AM',
      icon: Icons.card_giftcard_rounded,
      color: SakuColors.success,
    ),
    const _TransactionItem(
      title: 'Transportasi',
      note: 'Bensin pulang kampus',
      amountValue: -45000,
      time: '09:20 AM',
      icon: Icons.directions_car_rounded,
      color: SakuColors.danger,
    ),
  ];

  final List<_BudgetItem> _budgets = [
    const _BudgetItem(
      title: 'Transportasi',
      amountValue: 200000,
      remaining: 'sisa 50%',
      progress: 0.5,
      icon: Icons.directions_car_rounded,
    ),
    const _BudgetItem(
      title: 'Belanja',
      amountValue: 150000,
      remaining: 'sisa 40%',
      progress: 0.4,
      icon: Icons.shopping_cart_rounded,
    ),
    const _BudgetItem(
      title: 'Skincare',
      amountValue: 300000,
      remaining: 'sisa 35%',
      progress: 0.35,
      icon: Icons.spa_rounded,
    ),
  ];

  int get _currentBalance => _transactions.fold<int>(
        _initialBalance,
        (balance, item) => balance + item.amountValue,
      );

  int get _currentExpense => _transactions
      .where((item) => item.amountValue < 0)
      .fold<int>(0, (sum, item) => sum + item.amountValue.abs());

  @override
  void initState() {
    super.initState();
    _syncHomeWidget();
  }

  Future<void> _syncHomeWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(
        'balance',
        'Rp ${_formatPlain(_currentBalance)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense',
        'Rp ${_formatPlain(_currentExpense)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'latest',
        _transactions.isEmpty
            ? 'Belum ada catatan'
            : '${_transactions.first.title} ${_transactions.first.amount}',
      );
      await HomeWidget.updateWidget(name: _homeWidgetProvider);
    } catch (_) {
      // Platform channel is not available on web and widget tests.
    }
  }

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

    await _syncHomeWidget();
    try {
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

  void _addTransaction(_TransactionItem item) {
    setState(() {
      _transactions.insert(0, item);
      _surface = _DashboardSurface.main;
      _currentIndex = 1;
    });
    _syncHomeWidget();
  }

  void _addBudget(_BudgetItem item) {
    setState(() {
      _budgets.insert(0, item);
    });
  }

  void _deleteTransaction(_TransactionItem item) {
    setState(() => _transactions.remove(item));
    _syncHomeWidget();
  }

  void _markTransactionSettled(_TransactionItem item) {
    final index = _transactions.indexOf(item);
    if (index == -1) return;
    setState(() {
      _transactions[index] = item.copyWith(settled: true);
    });
    _syncHomeWidget();
  }

  void _openEditTransaction(_TransactionItem item) {
    setState(() {
      _editingTransaction = item;
      _surface = _DashboardSurface.editTransaction;
    });
  }

  void _updateTransaction(_TransactionItem oldItem, _TransactionItem newItem) {
    final index = _transactions.indexOf(oldItem);
    if (index == -1) return;
    setState(() {
      _transactions[index] = newItem;
      _editingTransaction = null;
      _surface = _DashboardSurface.main;
      _currentIndex = 1;
    });
    _syncHomeWidget();
  }

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
                      budgets: _budgets,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                    ),
                  _DashboardSurface.insight => _InsightDashboard(
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                    ),
                  _DashboardSurface.notifications => _NotificationsDashboard(
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                    ),
                  _DashboardSurface.addExpense => _AddNoteDashboard(
                      mode: _AddNoteMode.expense,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(() => _surface = _surfaceForMode(mode));
                      },
                      onSave: _addTransaction,
                    ),
                  _DashboardSurface.addIncome => _AddNoteDashboard(
                      mode: _AddNoteMode.income,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(() => _surface = _surfaceForMode(mode));
                      },
                      onSave: _addTransaction,
                    ),
                  _DashboardSurface.addDebt => _AddNoteDashboard(
                      mode: _AddNoteMode.debt,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(() => _surface = _surfaceForMode(mode));
                      },
                      onSave: _addTransaction,
                    ),
                  _DashboardSurface.addLoan => _AddNoteDashboard(
                      mode: _AddNoteMode.loan,
                      onBack: () {
                        setState(() => _surface = _DashboardSurface.main);
                      },
                      onSwitchMode: (mode) {
                        setState(() => _surface = _surfaceForMode(mode));
                      },
                      onSave: _addTransaction,
                    ),
                  _DashboardSurface.editTransaction =>
                    _EditTransactionDashboard(
                      item: _editingTransaction,
                      onBack: () {
                        setState(() {
                          _editingTransaction = null;
                          _surface = _DashboardSurface.main;
                        });
                      },
                      onSave: _updateTransaction,
                    ),
                  _DashboardSurface.main => switch (_currentIndex) {
                      0 => _HomeDashboard(
                          userName: widget.userName,
                          transactions: _transactions,
                          onOpenHistory: () {
                            setState(() => _currentIndex = 1);
                          },
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
                      1 => _HistoryDashboard(
                          transactions: _transactions,
                          onDelete: _deleteTransaction,
                          onEdit: _openEditTransaction,
                          onMarkSettled: _markTransactionSettled,
                        ),
                      2 => _ChartDashboard(transactions: _transactions),
                      _ => _ProfileDashboard(
                          initialName: widget.userName,
                          initialEmail: widget.userEmail,
                          onOpenNotifications: () {
                            setState(
                              () => _surface = _DashboardSurface.notifications,
                            );
                          },
                          onAddHomeWidget: _requestHomeWidget,
                        ),
                    },
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: _surface == _DashboardSurface.insight ||
              _surface == _DashboardSurface.notifications ||
              _surface == _DashboardSurface.addExpense ||
              _surface == _DashboardSurface.addIncome ||
              _surface == _DashboardSurface.addDebt ||
              _surface == _DashboardSurface.addLoan ||
              _surface == _DashboardSurface.editTransaction
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (_surface == _DashboardSurface.budget) {
                  showDialog<void>(
                    context: context,
                    builder: (context) => _BudgetFormDialog(
                      onSave: (item) {
                        _addBudget(item);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                  return;
                }
                setState(() => _surface = _DashboardSurface.addExpense);
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

enum _DashboardSurface {
  main,
  budget,
  insight,
  notifications,
  addExpense,
  addIncome,
  addDebt,
  addLoan,
  editTransaction
}

enum _AddNoteMode { expense, income, debt, loan }

_DashboardSurface _surfaceForMode(_AddNoteMode mode) {
  return switch (mode) {
    _AddNoteMode.expense => _DashboardSurface.addExpense,
    _AddNoteMode.income => _DashboardSurface.addIncome,
    _AddNoteMode.debt => _DashboardSurface.addDebt,
    _AddNoteMode.loan => _DashboardSurface.addLoan,
  };
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

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.userName,
    required this.transactions,
    required this.onOpenHistory,
    required this.onOpenBudget,
    required this.onOpenInsight,
  });

  final String userName;
  final List<_TransactionItem> transactions;
  final VoidCallback onOpenHistory;
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
                  Expanded(
                    child: Text(
                      'Hei, $userName!',
                      style: const TextStyle(
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
              _RecentNotesCard(
                transactions: transactions.take(2).toList(),
                onOpenMore: onOpenHistory,
              ),
              const SizedBox(height: 20),
              const _ActiveDebtCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryDashboard extends StatefulWidget {
  const _HistoryDashboard({
    required this.transactions,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final List<_TransactionItem> transactions;
  final ValueChanged<_TransactionItem> onDelete;
  final ValueChanged<_TransactionItem> onEdit;
  final ValueChanged<_TransactionItem> onMarkSettled;

  @override
  State<_HistoryDashboard> createState() => _HistoryDashboardState();
}

class _HistoryDashboardState extends State<_HistoryDashboard> {
  String _query = '';
  String _category = 'Semua';

  List<_TransactionItem> get _visibleTransactions {
    return widget.transactions.where((item) {
      final matchesQuery = _query.trim().isEmpty ||
          item.title.toLowerCase().contains(_query.toLowerCase()) ||
          item.note.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _category == 'Semua' || item.title == _category;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleTransactions = _visibleTransactions;
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
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(
            hintText: 'Cari catatan...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => _FilterDialog(
                    selectedCategory: _category,
                    onApply: (category) {
                      setState(() => _category = category);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.filter_alt_rounded),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const _MonthHeader(),
        const SizedBox(height: 14),
        if (visibleTransactions.isEmpty)
          const _EmptyStateCard(
            icon: Icons.receipt_long_outlined,
            title: 'Belum ada catatan',
            message: 'Coba ubah pencarian atau filter kategorinya.',
          )
        else
          _CardList(
            children: visibleTransactions
                .map(
                  (transaction) => _TransactionTile(
                    item: transaction,
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => _TransactionDetailDialog(
                          item: transaction,
                          onDelete: () {
                            widget.onDelete(transaction);
                            Navigator.of(context).pop();
                          },
                          onMarkSettled: () {
                            widget.onMarkSettled(transaction);
                            Navigator.of(context).pop();
                          },
                          onEdit: () {
                            Navigator.of(context).pop();
                            widget.onEdit(transaction);
                          },
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _BudgetDashboard extends StatelessWidget {
  const _BudgetDashboard({
    required this.budgets,
    required this.onBack,
  });

  final List<_BudgetItem> budgets;
  final VoidCallback onBack;

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
              ...budgets.map(_BudgetRow.new),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightDashboard extends StatefulWidget {
  const _InsightDashboard({required this.onBack});

  final VoidCallback onBack;

  @override
  State<_InsightDashboard> createState() => _InsightDashboardState();
}

class _InsightDashboardState extends State<_InsightDashboard> {
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      text:
          'Halo, aku Saku AI. Untuk demo ini aku bisa bantu baca pola catatan, kasih tips hemat, dan bikin arahan budgeting sederhana.',
      fromUser: false,
      time: '1:27',
    ),
  ].toList();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final message = text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis pertanyaan dulu sebelum dikirim')),
      );
      return;
    }

    setState(() {
      _messages
          .add(_ChatMessage(text: message, fromUser: true, time: 'Sekarang'));
      _messages.add(
        _ChatMessage(
          text: _buildDemoReply(message),
          fromUser: false,
          time: 'Sekarang',
        ),
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  String _buildDemoReply(String message) {
    final lower = message.toLowerCase();
    if (_containsAny(lower, const ['budget', 'batas', 'limit'])) {
      return 'Buka menu Budgeting, isi nominal, pilih kategori, lalu simpan. Untuk demo, budget akan tampil sebagai daftar limit agar user tahu sisa ruang belanjanya.';
    }
    if (_containsAny(lower, const ['grafik', 'laporan', 'kategori'])) {
      return 'Di tab Grafik, user bisa melihat ringkasan pengeluaran per kategori. Cocok buat menjawab kategori mana yang paling sering menghabiskan saldo.';
    }
    if (_containsAny(lower, const ['widget', 'homescreen', 'home screen'])) {
      return 'Widget homescreen menampilkan saldo, pengeluaran, dan catatan terbaru. Di Android, tambah dari Profil > Widget Homescreen atau dari daftar widget launcher.';
    }
    if (_containsAny(lower, const ['dompet', 'rekening', 'wallet'])) {
      return 'Dompet dipakai untuk memisahkan sumber uang, misalnya BSI, Cash, atau e-wallet. Untuk demo, dompet baru bisa ditambahkan dari halaman Profil.';
    }
    if (_containsAny(lower, const ['hutang', 'pinjaman', 'lunas'])) {
      return 'Catatan hutang dan pinjaman bisa dibuat dari tombol tambah. Detailnya bisa dibuka dari riwayat, lalu ditandai lunas saat sudah selesai.';
    }
    if (_containsAny(lower, const ['export', 'excel', 'pdf', 'unduh'])) {
      return 'Untuk sementara export belum aktif. Nanti bisa ditambahkan sebagai tombol laporan bulanan ke PDF atau Excel setelah format laporan disepakati.';
    }
    if (lower.contains('boros') || lower.contains('bulan')) {
      return 'Dari contoh data, pengeluaran yang paling terasa ada di Makanan dan Transportasi. Coba pasang limit mingguan kecil dulu, lalu cek ulang di tab Grafik.';
    }
    if (lower.contains('hemat') || lower.contains('tips')) {
      return 'Mulai dari aturan 3 langkah: catat pengeluaran kecil, pisahkan dompet kebutuhan dan jajan, lalu set budget harian. Yang penting konsisten dulu, bukan langsung sempurna.';
    }
    if (lower.contains('catatan') || lower.contains('pembelian')) {
      return 'Untuk catatan cepat, pakai tombol tambah di tengah, pilih kategori, isi nominal, lalu simpan. Nanti ringkasannya ikut masuk ke widget homescreen Android.';
    }
    return 'Aku catat pertanyaanmu. Versi demo ini menjawab secara lokal dulu; nanti bisa disambungkan ke AI beneran kalau customer sudah siap pakai API.';
  }

  bool _containsAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Saku AI', onBack: widget.onBack),
        Expanded(
          child: Container(
            color: SakuColors.blue50,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(42, 30, 42, 24),
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _QuickQuestionBubble(onQuestion: _sendMessage),
                      ),
                      const SizedBox(height: 18),
                      ..._messages.map(_ChatBubble.new),
                    ],
                  ),
                ),
                _InsightComposer(onSend: _sendMessage),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationsDashboard extends StatelessWidget {
  const _NotificationsDashboard({required this.onBack});

  final VoidCallback onBack;

  static const _items = [
    _NotificationItem(
      title: 'Jangan lupa catat ya. sudah ada\npengeluaran hari ini?',
      time: '4:40 PM',
      icon: Icons.edit_note_rounded,
      iconColor: SakuColors.neutral700,
    ),
    _NotificationItem(
      title:
          'Pengeluaran meningkat kamu\nmenghabiskan lebih banyak dari pada\nbiasanya',
      time: '6.30 PM',
      icon: Icons.trending_down_rounded,
      iconColor: SakuColors.danger,
    ),
    _NotificationItem(
      title:
          'Pengeluaran tercatat\nkamu baru saja mengeluarkan Rp\n50.000 untuk makan',
      time: '8.25 PM',
      icon: Icons.edit_note_rounded,
      iconColor: SakuColors.neutral700,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Notifikasi', onBack: onBack),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return _NotificationRow(item: _items[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _AddNoteDashboard extends StatefulWidget {
  const _AddNoteDashboard({
    required this.mode,
    required this.onBack,
    required this.onSwitchMode,
    required this.onSave,
  });

  final _AddNoteMode mode;
  final VoidCallback onBack;
  final ValueChanged<_AddNoteMode> onSwitchMode;
  final ValueChanged<_TransactionItem> onSave;

  @override
  State<_AddNoteDashboard> createState() => _AddNoteDashboardState();
}

class _AddNoteDashboardState extends State<_AddNoteDashboard> {
  final _nameController = TextEditingController(text: 'Nama');
  final _noteController = TextEditingController();
  String _amount = '0';
  String _expenseCategory = 'Makanan';
  String _incomeCategory = 'Gaji';

  bool get _isLoan => widget.mode == _AddNoteMode.loan;
  bool get _isIncome => widget.mode == _AddNoteMode.income;
  bool get _isExpense => widget.mode == _AddNoteMode.expense;
  bool get _isDailyNote => _isExpense || _isIncome;
  String get _selectedCategory =>
      _isIncome ? _incomeCategory : _expenseCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _handleKeypadTap(String key) {
    if (key == 'Simpan') {
      _saveNote();
      return;
    }
    setState(() {
      if (key == 'C') {
        _amount = '0';
      } else if (key == 'back') {
        _amount = _amount.length <= 1
            ? '0'
            : _amount.substring(0, _amount.length - 1);
      } else if (RegExp(r'^\d+$').hasMatch(key)) {
        _amount = _amount == '0' ? key : '$_amount$key';
      }
    });
  }

  void _saveNote() {
    final numericAmount = int.tryParse(_amount) ?? 0;
    if (numericAmount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal belum diisi')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final title = _isDailyNote
        ? _selectedCategory
        : _isLoan
            ? 'Beri Pinjaman'
            : 'Hutang';
    final isMoneyOut = _isExpense || _isLoan;
    widget.onSave(
      _TransactionItem(
        title: title,
        note: note.isNotEmpty
            ? note
            : _isDailyNote
                ? 'Catatan $title'
                : '${_isLoan ? 'Pinjaman ke' : 'Hutang ke'} ${name.isEmpty ? 'Nama' : name}',
        amountValue: isMoneyOut ? -numericAmount : numericAmount,
        time: 'Baru saja',
        icon: _categoryIcon(title),
        color: isMoneyOut ? SakuColors.danger : SakuColors.success,
      ),
    );
  }

  Future<void> _openCategoryPicker() async {
    final category = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => _CategorySelectionPage(
          selectedCategory: _selectedCategory,
          kind: _isIncome ? _CategoryKind.income : _CategoryKind.expense,
        ),
      ),
    );
    if (category == null) return;
    setState(() {
      if (_isIncome) {
        _incomeCategory = category;
      } else {
        _expenseCategory = category;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: 'Tambah Catatan', onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 18, 32, 14),
            children: [
              _AddNoteTypeSelector(
                mode: widget.mode,
                onSwitchMode: widget.onSwitchMode,
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
              if (_isDailyNote) ...[
                _SelectablePillField(
                  label: 'Kategori',
                  text: _selectedCategory,
                  icon: _categoryIcon(_selectedCategory),
                  onTap: _openCategoryPicker,
                ),
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
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _EditablePillField(
                        label: 'Nama',
                        controller: _nameController,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: _LabeledPillField(
                        label: 'Jatuh Tempo',
                        text: '12 Juni 2026',
                        icon: Icons.calendar_month_rounded,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              _EditablePillField(
                label: 'Catatan',
                controller: _noteController,
                hintText: 'Tulis catatan atau keterangan disini',
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
          child: Column(
            children: [
              _AmountDisplay(amount: _amount),
              const SizedBox(height: 6),
              _CalculatorPad(onTap: _handleKeypadTap),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditTransactionDashboard extends StatefulWidget {
  const _EditTransactionDashboard({
    required this.item,
    required this.onBack,
    required this.onSave,
  });

  final _TransactionItem? item;
  final VoidCallback onBack;
  final void Function(_TransactionItem oldItem, _TransactionItem newItem)
      onSave;

  @override
  State<_EditTransactionDashboard> createState() =>
      _EditTransactionDashboardState();
}

class _EditTransactionDashboardState extends State<_EditTransactionDashboard> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  late final TextEditingController _amountController;
  late String _category;

  _TransactionItem? get _item => widget.item;
  bool get _isLoan => _item?.title == 'Beri Pinjaman';
  bool get _isDebt => _item?.title == 'Hutang';
  bool get _isDaily => !_isLoan && !_isDebt;
  bool get _isIncome => (_item?.amountValue ?? 0) > 0 && _isDaily;

  @override
  void initState() {
    super.initState();
    final item = _item;
    final person = item == null
        ? ''
        : item.note
            .replaceFirst('Pinjaman ke ', '')
            .replaceFirst('Hutang ke ', '')
            .trim();
    _category = item?.title ?? 'Makanan';
    _nameController = TextEditingController(text: person);
    _noteController = TextEditingController(text: item?.note ?? '');
    _amountController = TextEditingController(
      text: item == null ? '' : _formatPlain(item.amountValue.abs()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _openCategoryPicker() async {
    final category = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => _CategorySelectionPage(
          selectedCategory: _category,
          kind: _isIncome ? _CategoryKind.income : _CategoryKind.expense,
        ),
      ),
    );
    if (category == null) return;
    setState(() => _category = category);
  }

  void _save() {
    final item = _item;
    if (item == null) return;
    final amount = _parseCurrency(_amountController.text);
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nominal belum diisi')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final note = _noteController.text.trim();
    final title = _isDaily ? _category : item.title;
    final isMoneyOut = item.amountValue < 0;
    widget.onSave(
      item,
      item.copyWith(
        title: title,
        note: note.isNotEmpty
            ? note
            : _isDaily
                ? 'Catatan $title'
                : '${_isLoan ? 'Pinjaman ke' : 'Hutang ke'} ${name.isEmpty ? 'Nama' : name}',
        amountValue: isMoneyOut ? -amount : amount,
        icon: _categoryIcon(title),
        color: isMoneyOut ? SakuColors.danger : SakuColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    if (item == null) {
      return Column(
        children: [
          _ChildPageTopBar(title: 'Edit Catatan', onBack: widget.onBack),
          const Expanded(
            child: Center(child: Text('Catatan tidak ditemukan')),
          ),
        ],
      );
    }

    return Column(
      children: [
        _ChildPageTopBar(title: 'Edit Catatan', onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 22, 32, 22),
            children: [
              if (_isDaily)
                _SelectablePillField(
                  label: 'Kategori',
                  text: _category,
                  icon: _categoryIcon(_category),
                  onTap: _openCategoryPicker,
                )
              else
                _EditablePillField(
                  label: 'Nama',
                  controller: _nameController,
                ),
              const SizedBox(height: 14),
              _EditablePillField(
                label: 'Catatan',
                controller: _noteController,
                hintText: 'Tulis catatan atau keterangan disini',
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  prefixText: 'Rp ',
                  filled: true,
                  fillColor: SakuColors.white,
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
              const SizedBox(height: 20),
              const SizedBox(
                width: 164,
                child: _WalletPicker(),
              ),
            ],
          ),
        ),
        Container(
          color: SakuColors.white,
          padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SakuColors.mango500,
                    side:
                        const BorderSide(color: SakuColors.mango500, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: SakuColors.blue300,
                    foregroundColor: SakuColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontWeight: FontWeight.w900),
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

class _ChartDashboard extends StatelessWidget {
  const _ChartDashboard({required this.transactions});

  final List<_TransactionItem> transactions;

  static const _palette = [
    Color(0xFFFF355D),
    Color(0xFFF9EA18),
    Color(0xFFFFBE3D),
    Color(0xFFFF7D31),
    Color(0xFFE5007D),
    Color(0xFF5AC97B),
  ];

  List<_ChartCategory> get _categories {
    final grouped = <String, int>{};
    for (final item in transactions.where((item) => item.amountValue < 0)) {
      grouped[item.title] = (grouped[item.title] ?? 0) + item.amountValue.abs();
    }
    if (grouped.isEmpty) {
      return const [
        _ChartCategory(
          title: 'Belum ada',
          percent: 100,
          amountValue: 0,
          icon: Icons.pie_chart_outline_rounded,
          color: SakuColors.neutral300,
        ),
      ];
    }
    final total = grouped.values.fold<int>(0, (sum, value) => sum + value);
    var index = 0;
    return grouped.entries.map((entry) {
      final color = _palette[index % _palette.length];
      index += 1;
      return _ChartCategory(
        title: entry.key,
        percent: math.max(1, ((entry.value / total) * 100).round()),
        amountValue: entry.value,
        icon: _categoryIcon(entry.key),
        color: color,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final totalExpense = transactions
        .where((item) => item.amountValue < 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue.abs());
    final totalIncome = transactions
        .where((item) => item.amountValue > 0)
        .fold<int>(0, (sum, item) => sum + item.amountValue);

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        const _MonthTopBar(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _PeriodFilter(
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Periode $value dipilih')),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _ChartSection(
            title: 'Pengeluaran',
            total: _formatPlain(totalExpense),
            categories: categories,
            accent: SakuColors.danger,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: _CompactIncomeCard(totalIncome: totalIncome),
        ),
      ],
    );
  }
}

class _ProfileDashboard extends StatefulWidget {
  const _ProfileDashboard({
    required this.initialName,
    required this.initialEmail,
    required this.onOpenNotifications,
    required this.onAddHomeWidget,
  });

  final String initialName;
  final String initialEmail;
  final VoidCallback onOpenNotifications;
  final VoidCallback onAddHomeWidget;

  @override
  State<_ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<_ProfileDashboard> {
  late String _profileName;
  late String _profileEmail;
  bool _passwordChanged = false;
  bool _photoUpdated = false;
  _ProfileEditField? _editingField;
  final List<_WalletItem> _wallets = [
    const _WalletItem(name: 'BSI', balance: 12000000),
  ];

  @override
  void initState() {
    super.initState();
    _profileName = widget.initialName;
    _profileEmail = widget.initialEmail;
  }

  void _openAddWalletDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => _WalletFormDialog(
        onSave: (wallet) {
          setState(() => _wallets.add(wallet));
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showProfilePhotoInfo() {
    setState(() => _photoUpdated = true);
    _showInfoDialog(
      context,
      title: 'Foto Profil',
      message:
          'Untuk demo tanpa database, foto profil ditandai sudah diperbarui. Nanti bisa disambungkan ke galeri/kamera perangkat.',
    );
  }

  void _showWalletDetail(_WalletItem item) {
    showDialog<void>(
      context: context,
      builder: (context) => _WalletDetailDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editingField = _editingField;
    if (editingField != null) {
      return _ProfileEditDashboard(
        field: editingField,
        currentName: _profileName,
        currentEmail: _profileEmail,
        onBack: () => setState(() => _editingField = null),
        onSaveName: (value) {
          setState(() {
            _profileName = value;
            _editingField = null;
          });
        },
        onSaveEmail: (value) {
          setState(() {
            _profileEmail = value;
            _editingField = null;
          });
        },
        onSavePassword: () {
          setState(() {
            _passwordChanged = true;
            _editingField = null;
          });
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 96),
      children: [
        _ProfileHeader(
          name: _profileName,
          photoUpdated: _photoUpdated,
          onEditPhoto: _showProfilePhotoInfo,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(32, 32, 32, 12),
          decoration: const BoxDecoration(
            color: SakuColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileSectionTitle('List Dompet'),
              const SizedBox(height: 12),
              ..._wallets.map(
                (wallet) => _WalletCard(
                  wallet,
                  onTap: () => _showWalletDetail(wallet),
                ),
              ),
              if (_wallets.isNotEmpty) const SizedBox(height: 12),
              _AddWalletCard(onTap: _openAddWalletDialog),
              const SizedBox(height: 24),
              const _ProfileSectionTitle('Informasi Akun'),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.person_rounded,
                title: 'Nama',
                subtitle: _profileName,
                onTap: () {
                  setState(() => _editingField = _ProfileEditField.name);
                },
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.mail_rounded,
                title: 'Email',
                subtitle: _profileEmail,
                onTap: () {
                  setState(() => _editingField = _ProfileEditField.email);
                },
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.lock_rounded,
                title: 'Password',
                subtitle: _passwordChanged ? 'Sudah diperbarui' : '********',
                onTap: () {
                  setState(() => _editingField = _ProfileEditField.password);
                },
              ),
              const SizedBox(height: 24),
              const _ProfileSectionTitle('Pengaturan'),
              const SizedBox(height: 12),
              _NotificationTile(onTap: widget.onOpenNotifications),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.widgets_rounded,
                title: 'Widget Homescreen',
                subtitle: 'Ringkasan saldo di layar utama',
                iconColor: SakuColors.blue700,
                onTap: widget.onAddHomeWidget,
              ),
              const SizedBox(height: 12),
              _ProfileMenuTile(
                icon: Icons.logout_rounded,
                title: 'Keluar',
                subtitle: 'Kembali ke halaman masuk',
                iconColor: SakuColors.mango500,
                trailing: Icons.chevron_right_rounded,
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginPage.routeName);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _ProfileEditField { name, email, password }

class _ProfileEditDashboard extends StatefulWidget {
  const _ProfileEditDashboard({
    required this.field,
    required this.currentName,
    required this.currentEmail,
    required this.onBack,
    required this.onSaveName,
    required this.onSaveEmail,
    required this.onSavePassword,
  });

  final _ProfileEditField field;
  final String currentName;
  final String currentEmail;
  final VoidCallback onBack;
  final ValueChanged<String> onSaveName;
  final ValueChanged<String> onSaveEmail;
  final VoidCallback onSavePassword;

  @override
  State<_ProfileEditDashboard> createState() => _ProfileEditDashboardState();
}

class _ProfileEditDashboardState extends State<_ProfileEditDashboard> {
  late final TextEditingController _primaryController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool get _isName => widget.field == _ProfileEditField.name;
  bool get _isEmail => widget.field == _ProfileEditField.email;
  bool get _isPassword => widget.field == _ProfileEditField.password;

  String get _title {
    return switch (widget.field) {
      _ProfileEditField.name => 'Edit Nama',
      _ProfileEditField.email => 'Edit Email',
      _ProfileEditField.password => 'Ganti Password',
    };
  }

  @override
  void initState() {
    super.initState();
    _primaryController = TextEditingController(
      text: _isName
          ? widget.currentName
          : _isEmail
              ? widget.currentEmail
              : '',
    );
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _save() {
    if (_isPassword) {
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();
      if (password.length < 6 || password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password minimal 6 karakter dan harus sama'),
          ),
        );
        return;
      }
      widget.onSavePassword();
      return;
    }

    final value = _primaryController.text.trim();
    if (value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data belum diisi')),
      );
      return;
    }

    if (_isEmail && !value.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format email belum benar')),
      );
      return;
    }

    if (_isName) {
      widget.onSaveName(value);
    } else {
      widget.onSaveEmail(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ChildPageTopBar(title: _title, onBack: widget.onBack),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 24),
            children: [
              if (!_isPassword)
                TextField(
                  controller: _primaryController,
                  keyboardType: _isEmail
                      ? TextInputType.emailAddress
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: _isEmail ? 'Email' : 'Nama',
                    prefixIcon: Icon(
                      _isEmail ? Icons.mail_rounded : Icons.person_rounded,
                    ),
                    filled: true,
                    fillColor: SakuColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                )
              else ...[
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password baru',
                    prefixIcon: const Icon(Icons.lock_rounded),
                    filled: true,
                    fillColor: SakuColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Ulangi password',
                    prefixIcon: const Icon(Icons.lock_reset_rounded),
                    filled: true,
                    fillColor: SakuColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: SakuColors.blue50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: SakuColors.blue100),
                ),
                child: Text(
                  _isPassword
                      ? 'Perubahan password disimpan lokal untuk demo. Nanti dapat disambungkan ke autentikasi.'
                      : 'Perubahan ini langsung terlihat di halaman Profil selama aplikasi belum di-refresh.',
                  style: const TextStyle(
                    color: SakuColors.neutral600,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: SakuColors.white,
          padding: const EdgeInsets.fromLTRB(32, 14, 32, 18),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SakuColors.mango500,
                    side:
                        const BorderSide(color: SakuColors.mango500, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: SakuColors.blue300,
                    foregroundColor: SakuColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontWeight: FontWeight.w900),
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
                      'Rp ${_formatPlain(item.amountValue)}',
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

class _BudgetFormDialog extends StatefulWidget {
  const _BudgetFormDialog({required this.onSave});

  final ValueChanged<_BudgetItem> onSave;

  @override
  State<_BudgetFormDialog> createState() => _BudgetFormDialogState();
}

class _BudgetFormDialogState extends State<_BudgetFormDialog> {
  final _amountController = TextEditingController();
  String _category = 'Kategori';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _pickCategory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _CategoryPickerSheet(
        selectedCategory: _category,
        kind: _CategoryKind.expense,
        onSelected: (category) {
          setState(() => _category = category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _save() {
    final amount = _parseCurrency(_amountController.text);
    if (_category == 'Kategori' || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi kategori dan nominal budget')),
      );
      return;
    }

    widget.onSave(
      _BudgetItem(
        title: _category,
        amountValue: amount,
        remaining: 'sisa 100%',
        progress: 1,
        icon: _categoryIcon(_category),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 34, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Buat budget baru untuk\nmengatur keuangan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                const Expanded(
                  child: _DialogSelectField(
                    label: 'Dompet',
                    value: 'BSI',
                    icon: Icons.credit_card_rounded,
                    trailing: Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _DialogSelectField(
                    label: 'Kategori',
                    value: _category,
                    icon: Icons.work_rounded,
                    trailing: Icons.chevron_right_rounded,
                    muted: _category == 'Kategori',
                    onTap: _pickCategory,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Budget',
                style: TextStyle(
                  color: SakuColors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Masukkan Nominal Budget..',
                filled: true,
                fillColor: SakuColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.neutral300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: const BorderSide(color: SakuColors.blue300),
                ),
              ),
            ),
            const SizedBox(height: 54),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDialog extends StatefulWidget {
  const _FilterDialog({
    required this.selectedCategory,
    required this.onApply,
  });

  final String selectedCategory;
  final ValueChanged<String> onApply;

  @override
  State<_FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<_FilterDialog> {
  late String _category = widget.selectedCategory;

  void _pickCategory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: SakuColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _CategoryPickerSheet(
        selectedCategory: _category,
        kind: _CategoryKind.expense,
        includeAll: true,
        onSelected: (category) {
          setState(() => _category = category);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Cari berdasarkan filter\ntanggal dan kategori',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 17,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _DialogSelectField(
                    label: 'Kategori',
                    value: _category == 'Semua' ? 'Semua' : _category,
                    icon: Icons.work_rounded,
                    trailing: Icons.chevron_right_rounded,
                    muted: _category == 'Semua',
                    onTap: _pickCategory,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: _DialogSelectField(
                    label: 'Tanggal',
                    value: 'Pilih tanggal',
                    icon: null,
                    trailing: Icons.keyboard_arrow_down_rounded,
                    muted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: () => widget.onApply(_category),
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
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

class _CategoryPickerSheet extends StatelessWidget {
  const _CategoryPickerSheet({
    required this.selectedCategory,
    required this.onSelected,
    this.kind = _CategoryKind.expense,
    this.includeAll = false,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final _CategoryKind kind;
  final bool includeAll;

  static const _expenseCategories = [
    'Makanan',
    'Transportasi',
    'Rumah',
    'Kesehatan',
    'Belanja',
    'Kecantikan',
    'Hiburan',
    'Pendidikan',
    'Olahraga',
    'Darurat',
    'Sedekah',
    'Lainnya',
  ];

  static const _incomeCategories = [
    'Gaji',
    'Freelance',
    'Bisnis',
    'Hadiah',
    'Penjualan',
    'Investasi',
    'Sewa',
    'Uang Saku',
    'Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    final baseItems = _categoriesForKind(kind);
    final items = includeAll ? ['Semua', ...baseItems] : baseItems;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Kategori',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.95,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final category = items[index];
                  final selected = category == selectedCategory;
                  return _CategoryChoiceTile(
                    title: category,
                    icon: _categoryIcon(category),
                    selected: selected,
                    onTap: () => onSelected(category),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _CategoryKind { expense, income }

List<String> _categoriesForKind(_CategoryKind kind) {
  return kind == _CategoryKind.income
      ? _CategoryPickerSheet._incomeCategories
      : _CategoryPickerSheet._expenseCategories;
}

class _CategorySelectionPage extends StatelessWidget {
  const _CategorySelectionPage({
    required this.selectedCategory,
    required this.kind,
  });

  final String selectedCategory;
  final _CategoryKind kind;

  @override
  Widget build(BuildContext context) {
    final categories = _categoriesForKind(kind);
    final title = kind == _CategoryKind.income
        ? 'Kategori Pemasukan'
        : 'Kategori Pengeluaran';

    return Scaffold(
      backgroundColor: SakuColors.neutral50,
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 430,
            child: Column(
              children: [
                _ChildPageTopBar(
                  title: title,
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 20,
                      childAspectRatio: 1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _CategoryPageTile(
                        title: category,
                        selected: category == selectedCategory,
                        onTap: () => Navigator.of(context).pop(category),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPageTile extends StatelessWidget {
  const _CategoryPageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final asset = _categoryAsset(title);
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: selected ? 4 : 2,
      shadowColor: SakuColors.black.withValues(alpha: 0.26),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? SakuColors.blue300 : SakuColors.neutral300,
              width: selected ? 2 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (asset != null)
                Image.asset(asset, width: 38, height: 38, fit: BoxFit.contain)
              else
                Icon(_categoryIcon(title),
                    color: SakuColors.mango500, size: 36),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 14,
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

class _CategoryChoiceTile extends StatelessWidget {
  const _CategoryChoiceTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? SakuColors.blue100 : SakuColors.neutral100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    selected ? SakuColors.blue300 : SakuColors.white,
                child: Icon(
                  icon,
                  color: selected ? SakuColors.white : SakuColors.mango500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: SakuColors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransactionDetailDialog extends StatelessWidget {
  const _TransactionDetailDialog({
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final _TransactionItem item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onMarkSettled;

  bool get _isLoan => item.title == 'Beri Pinjaman';
  bool get _isDebt => item.title == 'Hutang';

  @override
  Widget build(BuildContext context) {
    if (_isLoan) {
      return _LoanDetailDialog(
        item: item,
        onDelete: onDelete,
        onEdit: onEdit,
        onMarkSettled: onMarkSettled,
      );
    }

    if (_isDebt) {
      return _DebtPaymentDialog(
        item: item,
        onMarkSettled: onMarkSettled,
      );
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: item.color.withValues(alpha: 0.12),
              child: Icon(item.icon, color: item.color, size: 34),
            ),
            const SizedBox(height: 14),
            Text(
              item.title,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.amount,
              style: TextStyle(
                color: item.color,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            _DetailLine(label: 'Catatan', value: item.note),
            _DetailLine(label: 'Waktu', value: item.time),
            const _DetailLine(label: 'Dompet', value: 'BSI'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: SakuColors.blue300,
                  foregroundColor: SakuColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DebtPaymentDialog extends StatelessWidget {
  const _DebtPaymentDialog({
    required this.item,
    required this.onMarkSettled,
  });

  final _TransactionItem item;
  final VoidCallback onMarkSettled;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bayar hutang dari dompet mana?',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _DialogSelectField(
                    label: 'Dompet',
                    value: 'BSI',
                    icon: Icons.credit_card_rounded,
                    trailing: Icons.keyboard_arrow_down_rounded,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _DialogSelectField(
                    label: 'Tanggal Lunas',
                    value: '12 Juni 2026',
                    icon: null,
                    trailing: Icons.calendar_month_rounded,
                    muted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: SakuColors.mango500,
                      side: const BorderSide(
                        color: SakuColors.mango500,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Kembali',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: onMarkSettled,
                    style: FilledButton.styleFrom(
                      backgroundColor: item.settled
                          ? SakuColors.success
                          : SakuColors.neutral300,
                      foregroundColor: item.settled
                          ? SakuColors.white
                          : SakuColors.neutral600,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      item.settled ? 'Sudah Lunas' : 'Lunas',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanDetailDialog extends StatelessWidget {
  const _LoanDetailDialog({
    required this.item,
    required this.onDelete,
    required this.onEdit,
    required this.onMarkSettled,
  });

  final _TransactionItem item;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onMarkSettled;

  @override
  Widget build(BuildContext context) {
    final person = item.note
        .replaceFirst('Pinjaman ke ', '')
        .replaceFirst('Minjam uang ke ', '')
        .trim();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            'Beri Pinjaman',
                            style: TextStyle(
                              color: SakuColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          _PaidBadge(settled: item.settled),
                        ],
                      ),
                    ),
                    Text(
                      'Rp ${_formatPlain(item.amountValue.abs())}',
                      style: const TextStyle(
                        color: SakuColors.neutral300,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.hourglass_bottom_rounded,
                      color: SakuColors.neutral300,
                      size: 15,
                    ),
                    SizedBox(width: 3),
                    Text(
                      '30 April 2026',
                      style: TextStyle(
                        color: SakuColors.neutral300,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(
                  color: SakuColors.neutral300,
                  thickness: 3,
                  height: 1,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama',
                            style: TextStyle(
                              color: SakuColors.neutral600,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            person.isEmpty ? 'Nama' : person,
                            style: const TextStyle(
                              color: SakuColors.neutral300,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Catatan',
                            style: TextStyle(
                              color: SakuColors.neutral600,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            item.note,
                            style: const TextStyle(
                              color: SakuColors.neutral300,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Cash',
                          style: TextStyle(
                            color: SakuColors.neutral600,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: 10),
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          color: SakuColors.mango500,
                          size: 32,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: SakuColors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Hapus',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_rounded, color: Colors.red),
                ),
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon:
                      const Icon(Icons.edit_rounded, color: SakuColors.blue700),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Tandai lunas',
                  onPressed: onMarkSettled,
                  icon: Icon(
                    Icons.check_rounded,
                    color: item.settled ? SakuColors.neutral300 : Colors.green,
                    size: 30,
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

class _PaidBadge extends StatelessWidget {
  const _PaidBadge({required this.settled});

  final bool settled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: settled ? const Color(0xFFD9FBE8) : SakuColors.neutral100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: settled ? SakuColors.success : SakuColors.neutral300,
        ),
      ),
      child: Text(
        settled ? 'Lunas' : 'Belum Lunas',
        style: TextStyle(
          color: settled ? SakuColors.success : SakuColors.neutral600,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(
                color: SakuColors.neutral300,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: SakuColors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
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

class _QuickQuestionBubble extends StatelessWidget {
  const _QuickQuestionBubble({required this.onQuestion});

  final ValueChanged<String> onQuestion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      decoration: BoxDecoration(
        color: SakuColors.blue100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pertanyaan Cepat',
            style: TextStyle(
              color: SakuColors.blue700,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          for (final question in _quickQuestions) ...[
            _QuestionPill(question, onTap: onQuestion),
            if (question != _quickQuestions.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

const _quickQuestions = [
  'Catatan pembelian cepat',
  'Tips hemat buat aku dong',
  'Bulan ini boros dimana?',
  'Cara bikin budget?',
  'Grafik itu buat apa?',
  'Tambah dompet gimana?',
  'Widget homescreen apa?',
  'Hutang bisa ditandai lunas?',
];

class _QuestionPill extends StatelessWidget {
  const _QuestionPill(this.text, {required this.onTap});

  final String text;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.blue300,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: () => onTap(text),
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

class _ChatBubble extends StatelessWidget {
  const _ChatBubble(this.message);

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final alignment =
        message.fromUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = message.fromUser ? SakuColors.blue300 : SakuColors.white;
    final textColor = message.fromUser ? SakuColors.white : SakuColors.black;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 286),
          child: Column(
            crossAxisAlignment: message.fromUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(message.fromUser ? 18 : 4),
                    bottomRight: Radius.circular(message.fromUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SakuColors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.38,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.time,
                style: const TextStyle(
                  color: SakuColors.neutral300,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final _NotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 10),
      decoration: const BoxDecoration(
        color: SakuColors.white,
        border: Border(bottom: BorderSide(color: SakuColors.neutral300)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            height: 40,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Icon(item.icon, color: item.iconColor, size: 28),
                if (item.icon == Icons.edit_note_rounded)
                  const Positioned(
                    right: 0,
                    bottom: 3,
                    child: Icon(
                      Icons.edit_rounded,
                      color: SakuColors.mango500,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: SakuColors.black,
                    fontSize: 17,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    item.time,
                    style: const TextStyle(
                      color: SakuColors.neutral300,
                      fontSize: 12,
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

class _InsightComposer extends StatefulWidget {
  const _InsightComposer({required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<_InsightComposer> createState() => _InsightComposerState();
}

class _InsightComposerState extends State<_InsightComposer> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final message = _controller.text.trim();
    widget.onSend(message);
    if (message.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SakuColors.white,
      padding: const EdgeInsets.fromLTRB(32, 14, 32, 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
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
              onPressed: _send,
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
          Expanded(
            flex: mode == _AddNoteMode.expense ? 5 : 2,
            child: _ModeChip(
              selected: mode == _AddNoteMode.expense,
              label: 'Pengeluaran',
              icon: Icons.paid_outlined,
              onTap: () => onSwitchMode(_AddNoteMode.expense),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == _AddNoteMode.income ? 5 : 2,
            child: _ModeChip(
              selected: mode == _AddNoteMode.income,
              label: 'Pemasukan',
              icon: Icons.savings_outlined,
              onTap: () => onSwitchMode(_AddNoteMode.income),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == _AddNoteMode.debt ? 5 : 2,
            child: _ModeChip(
              selected: mode == _AddNoteMode.debt,
              label: 'Hutang',
              icon: Icons.payments_outlined,
              onTap: () => onSwitchMode(_AddNoteMode.debt),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: mode == _AddNoteMode.loan ? 6 : 2,
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
              if (selected) ...[
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

class _SelectablePillField extends StatelessWidget {
  const _SelectablePillField({
    required this.label,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: SakuColors.neutral300),
              ),
              child: Row(
                children: [
                  Icon(icon, color: SakuColors.mango500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: SakuColors.neutral700,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EditablePillField extends StatelessWidget {
  const _EditablePillField({
    required this.label,
    required this.controller,
    this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;

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
        SizedBox(
          height: 48,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: SakuColors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
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
  const _AmountDisplay({required this.amount});

  final String amount;

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
      child: Text(
        _formatPlain(int.tryParse(amount) ?? 0),
        style: const TextStyle(
          color: SakuColors.neutral300,
          fontSize: 31,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CalculatorPad extends StatelessWidget {
  const _CalculatorPad({required this.onTap});

  final ValueChanged<String> onTap;

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
                        onTap: () => onTap(label),
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
  const _PeriodFilter({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: SakuColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih Periode',
                    style: TextStyle(
                      color: SakuColors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final item in ['Mingguan', 'Bulanan', 'Tahunan'])
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(item),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).pop();
                        onChanged(item);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
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
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: SakuColors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  builder: (context) => _ChartCategorySheet(
                    title: title,
                    categories: categories,
                  ),
                );
              },
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

class _ChartCategorySheet extends StatelessWidget {
  const _ChartCategorySheet({
    required this.title,
    required this.categories,
  });

  final String title;
  final List<_ChartCategory> categories;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semua Kategori $title',
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            for (final category in categories)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: category.color,
                  child: Icon(category.icon, color: SakuColors.black),
                ),
                title: Text(category.title),
                subtitle: Text('Rp ${_formatPlain(category.amountValue)}'),
                trailing: Text(
                  '${category.percent}%',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CompactIncomeCard extends StatelessWidget {
  const _CompactIncomeCard({required this.totalIncome});

  final int totalIncome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(radius: 10),
      child: Row(
        children: [
          const Icon(Icons.paid_outlined, color: SakuColors.success, size: 28),
          const SizedBox(width: 8),
          const Expanded(
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
            _formatPlain(totalIncome),
            style: const TextStyle(
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
  const _ProfileHeader({
    required this.name,
    required this.photoUpdated,
    required this.onEditPhoto,
  });

  final String name;
  final bool photoUpdated;
  final VoidCallback onEditPhoto;

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
              child: Icon(
                photoUpdated ? Icons.check_rounded : Icons.person_rounded,
                color: SakuColors.blue700,
                size: 62,
              ),
            ),
          ),
          Positioned(
            top: 104,
            right: 165,
            child: Material(
              color: SakuColors.white,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onEditPhoto,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.camera_alt_rounded),
                ),
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: Text(
              name,
              style: const TextStyle(
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

class _WalletCard extends StatelessWidget {
  const _WalletCard(this.item, {required this.onTap});

  final _WalletItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: SakuColors.blue50,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: SakuColors.blue100),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: SakuColors.blue300,
                  child:
                      Icon(Icons.credit_card_rounded, color: SakuColors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          color: SakuColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Rp ${_formatPlain(item.balance)}',
                        style: const TextStyle(
                          color: SakuColors.neutral600,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletDetailDialog extends StatelessWidget {
  const _WalletDetailDialog({required this.item});

  final _WalletItem item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: SakuColors.blue300,
              child: Icon(Icons.credit_card_rounded, color: SakuColors.white),
            ),
            const SizedBox(height: 12),
            Text(
              item.name,
              style: const TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Saldo Rp ${_formatPlain(item.balance)}',
              style: const TextStyle(
                color: SakuColors.neutral600,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Detail dompet masih berupa data lokal demo. Nanti bagian ini bisa dipakai untuk edit nama dompet, arsip, dan melihat transaksi dompet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SakuColors.neutral600,
                height: 1.35,
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
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddWalletCard extends StatelessWidget {
  const _AddWalletCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.neutral100,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
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
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final IconData trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
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
        ),
      ),
    );
  }
}

class _WalletFormDialog extends StatefulWidget {
  const _WalletFormDialog({required this.onSave});

  final ValueChanged<_WalletItem> onSave;

  @override
  State<_WalletFormDialog> createState() => _WalletFormDialogState();
}

class _WalletFormDialogState extends State<_WalletFormDialog> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    final balance = _parseCurrency(_balanceController.text);
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dompet belum diisi')),
      );
      return;
    }
    widget.onSave(_WalletItem(name: name, balance: balance));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      backgroundColor: SakuColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Tambah Dompet',
              style: TextStyle(
                color: SakuColors.black,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nama dompet',
                prefixIcon: Icon(Icons.account_balance_wallet_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Saldo awal',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: SakuColors.blue300,
                      foregroundColor: SakuColors.white,
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SakuColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: SakuColors.neutral300),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.notifications_rounded,
                color: SakuColors.mango500,
              ),
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
                onChanged: (_) => onTap(),
                activeThumbColor: SakuColors.white,
                activeTrackColor: SakuColors.mango500,
              ),
            ],
          ),
        ),
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
  const _RecentNotesCard({
    required this.transactions,
    required this.onOpenMore,
  });

  final List<_TransactionItem> transactions;
  final VoidCallback onOpenMore;

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
              onTap: onOpenMore,
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
  const _TransactionTile({
    required this.item,
    this.compactIcon = false,
    this.onTap,
  });

  final _TransactionItem item;
  final bool compactIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
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
        ),
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
    required this.amountValue,
    required this.icon,
    required this.color,
  });

  final String title;
  final int percent;
  final int amountValue;
  final IconData icon;
  final Color color;
}

class _BudgetItem {
  const _BudgetItem({
    required this.title,
    required this.amountValue,
    required this.remaining,
    required this.progress,
    required this.icon,
  });

  final String title;
  final int amountValue;
  final String remaining;
  final double progress;
  final IconData icon;
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
    required this.amountValue,
    required this.time,
    required this.icon,
    required this.color,
    this.settled = false,
  });

  final String title;
  final String note;
  final int amountValue;
  final String time;
  final IconData icon;
  final Color color;
  final bool settled;

  String get amount {
    final sign = amountValue < 0 ? '-' : '+';
    return '$sign ${_formatPlain(amountValue.abs())}';
  }

  _TransactionItem copyWith({
    String? title,
    String? note,
    int? amountValue,
    String? time,
    IconData? icon,
    Color? color,
    bool? settled,
  }) {
    return _TransactionItem(
      title: title ?? this.title,
      note: note ?? this.note,
      amountValue: amountValue ?? this.amountValue,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      settled: settled ?? this.settled,
    );
  }
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
    'Makanan' => 'icon/Property 1=makanan.png',
    'Transportasi' => 'icon/Property 1=kendaraan.png',
    'Rumah' => 'icon/Property 1=rumah.png',
    'Kesehatan' => 'icon/Property 1=kesehatan.png',
    'Belanja' => 'icon/Property 1=belanja.png',
    'Kecantikan' => 'icon/Property 1=kecantikan.png',
    'Hiburan' => 'icon/Property 1=hiburan.png',
    'Pendidikan' => 'icon/Property 1=pendidikan.png',
    'Olahraga' => 'icon/Property 1=olahraga.png',
    'Darurat' => 'icon/Property 1=darurat.png',
    'Sedekah' => 'icon/Property 1=sedekah.png',
    'Lainnya' => 'icon/Property 1=lainnya.png',
    'Gaji' => 'icon/Property 1=gaji.png',
    'Freelance' => 'icon/Property 1=freelance.png',
    'Bisnis' => 'icon/Property 1=bisnis.png',
    'Hadiah' => 'icon/Property 1=hadiah.png',
    'Penjualan' => 'icon/Property 1=penjualan.png',
    'Investasi' => 'icon/Property 1=investasi.png',
    'Sewa' => 'icon/Property 1=sewa.png',
    'Uang Saku' => 'icon/Property 1=uangsaku.png',
    _ => null,
  };
}
