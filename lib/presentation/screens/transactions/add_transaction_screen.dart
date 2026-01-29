import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/data/model/budget_model.dart';
import '../../../core/data/model/category_model.dart';
import '../../../core/data/model/transactions_model.dart';
import '../../../providers/budget_provider.dart';
import '../../../providers/category_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../providers/user_provider.dart';


class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transactionToEdit;

  const AddTransactionScreen({
    super.key,
    this.transactionToEdit,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  BudgetModel? _selectedBudget;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.transactionToEdit != null) {
      _initEditMode();
    }
  }

  void _initEditMode() {
    final t = widget.transactionToEdit!;
    _amountController.text = t.amount.toString(); // or toStringAsFixed(2) if you prefer
    if (_amountController.text.endsWith('.0')) {
      _amountController.text = _amountController.text.substring(0, _amountController.text.length - 2);
    }
    _noteController.text = t.note ?? '';
    _selectedDate = t.date;

    // We need to set the selected budget.
    // Since we don't have the full budget list synchronously here, we might need to rely on the provider having it loaded
    // or correct the logic to find it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final budgetProvider = context.read<BudgetProvider>();
      try {
        final budget = budgetProvider.budgets.firstWhere((b) => b.id == t.budgetId);
        setState(() => _selectedBudget = budget);
      } catch (e) {
        debugPrint('Could not find budget for editing transaction: $e');
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.transactionToEdit != null ? 'Edit Transaction' : 'Add Transaction'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAmountInput(),
              const SizedBox(height: 24),
              _buildFormCard(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Amount',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: AppColors.gray900,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              prefixText: '\$',
              prefixStyle: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
              hintText: '0.00',
              hintStyle: GoogleFonts.inter(color: AppColors.gray300),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBudgetSelector(),
          const Divider(height: 32, color: AppColors.gray100),
          _buildFormRow(
            icon: Icons.calendar_today_outlined,
            label: 'Date',
            value: DateFormat('MMM dd, yyyy').format(_selectedDate),
            onTap: () => _selectDate(context),
            showArrow: true,
          ),
          const Divider(height: 32, color: AppColors.gray100),
          _buildNoteInput(),
        ],
      ),
    );
  }

  Widget _buildBudgetSelector() {
    return InkWell(
      onTap: _showBudgetBottomSheet,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pie_chart_outline, color: AppColors.gray600, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Budget',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.gray900,
              ),
            ),
          ),
          if (_selectedBudget != null) ...[
            Consumer<CategoryProvider>(
              builder: (context, catProvider, child) {
                CategoryModel? category;
                try {
                  category = catProvider.categories.firstWhere((c) => c.id == _selectedBudget!.categoryId);
                } catch (_) {}

                return Text(
                  category?.name ?? 'Loading...',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray900,
                  ),
                );
              },
            ),
          ] else
            Text(
              'Select Budget',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.gray400,
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: AppColors.gray400, size: 20),
        ],
      ),
    );
  }

  void _showBudgetBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer2<BudgetProvider, CategoryProvider>(
          builder: (context, budgetProvider, categoryProvider, child) {
            final budgets = budgetProvider.budgets;
            if (budgets.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No budgets found. Please create a budget first.',
                    style: GoogleFonts.inter(color: AppColors.gray500),
                  ),
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Budget',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: budgets.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final budget = budgets[index];
                        CategoryModel? category;
                        try {
                          category = categoryProvider.categories.firstWhere((c) => c.id == budget.categoryId);
                        } catch (_) {}

                        final categoryName = category?.name ?? 'Uncategorized';
                        final categoryIcon = category != null
                            ? IconData(category.iconCode, fontFamily: 'MaterialIcons')
                            : Icons.help_outline;
                        final categoryColor = category != null
                            ? Color(category.colorValue)
                            : AppColors.gray400;

                        return InkWell(
                          onTap: () {
                            setState(() => _selectedBudget = budget);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _selectedBudget?.id == budget.id
                                    ? AppColors.primary500
                                    : AppColors.gray200,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: categoryColor.withOpacity(0.1),
                                  child: Icon(
                                    categoryIcon,
                                    color: categoryColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        categoryName,
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Remaining: \$${budget.remaining.toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  Widget _buildFormRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool showArrow = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.gray600, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.gray900,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.gray600,
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.gray400, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildNoteInput() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.edit_outlined, color: AppColors.gray600, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _noteController,
            style: GoogleFonts.inter(fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Add a note',
              hintStyle: GoogleFonts.inter(color: AppColors.gray400),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              filled: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _saveTransaction,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        shadowColor: AppColors.primary500.withOpacity(0.4),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      )
          : Text(
        widget.transactionToEdit != null ? 'Update Transaction' : 'Save Transaction',
        style: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _saveTransaction() async {
    final amountText = _amountController.text;
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    if (_selectedBudget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a budget')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    // Validate budget limit
    // If editing, we need to consider the old amount being refunded.
    // effectiveRemaining = currentRemaining + (if same budget ? oldAmount : 0)
    double effectiveRemaining = _selectedBudget!.remaining;
    if (widget.transactionToEdit != null && widget.transactionToEdit!.budgetId == _selectedBudget!.id) {
      effectiveRemaining += widget.transactionToEdit!.amount;
    }

    if (amount > effectiveRemaining) {
      _showErrorDialog(amount, effectiveRemaining);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = context.read<UserProvider>().userModel;
      final budgetProvider = context.read<BudgetProvider>();
      final transactionProvider = context.read<TransactionProvider>();

      if (user != null) {
        final transactionData = TransactionModel(
          id: widget.transactionToEdit?.id ?? '', // Use existing ID for edit
          userId: user.userId,
          budgetId: _selectedBudget!.id,
          amount: amount,
          date: _selectedDate,
          note: _noteController.text,
          createdAt: widget.transactionToEdit?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(), // Track updates
        );

        if (widget.transactionToEdit != null) {
          await transactionProvider.updateTransaction(
            transactionData,
            widget.transactionToEdit!,
            budgetProvider,
            _selectedBudget!,
          );
        } else {
          await transactionProvider.addTransaction(
              transactionData,
              budgetProvider,
              _selectedBudget!
          );
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(double enteredAmount, double available) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Budget Exceeded', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          'You are trying to spend \$${enteredAmount.toStringAsFixed(2)}, but only \$${available.toStringAsFixed(2)} is available in this budget.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.inter(color: AppColors.primary500)),
          ),
        ],
      ),
    );
  }
}
