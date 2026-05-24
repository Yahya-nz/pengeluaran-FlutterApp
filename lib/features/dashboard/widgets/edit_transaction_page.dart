part of '../dashboard_page.dart';

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
