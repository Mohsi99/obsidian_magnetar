import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:obsidian_magnetar/core/constants/app_colors.dart';
import 'package:obsidian_magnetar/core/data/model/transactions_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Groceries';
  bool _isRecurring = false;

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
        lastDate: DateTime(2100));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text("Add Transaction"),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:  const Icon(Icons.arrow_back),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
        body: SafeArea(child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(20),child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 20),
              _buildAmountInput(),
              const SizedBox(height: 20),
              _buildFormCard(),
              const SizedBox(height: 26),
              ElevatedButton(onPressed: (){Navigator.pop(context);},

                style:  ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: AppColors.primary500.withValues(alpha: 0.4),
                ),

                child:Text(
                'Save Transaction',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ), )
            ],
          ),),
        )),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
              child: _buildTypeButton(
            title: "Expense",
            isSelected: _selectedType == TransactionType.expense,
            onTap: () =>
                setState(() => _selectedType = TransactionType.expense),
          )),
          Expanded(
              child: _buildTypeButton(
            title: "Income",
            isSelected: _selectedType == TransactionType.income,
            onTap: () => setState(() => _selectedType = TransactionType.income),
          )),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary500 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.gray600,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 32,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Amount",
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 8,
          ),
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
              prefixText: "\$",
              prefixStyle: GoogleFonts.inter(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                color: AppColors.gray900,
              ),
              hintText: '0.00',
              hintStyle: GoogleFonts.inter(
                color: AppColors.gray300,
              ),
            ),
          )
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
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildFormRow(
              icon: Icons.cabin_outlined,
              label: "Category",
              value: _selectedCategory,
              onTap: () {},showArrow: true),
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
          const Divider(height: 32, color: AppColors.gray100),
          _buildSwitchRow(
            icon: Icons.autorenew,
            label: 'Recurring',
            value: _isRecurring,
            onChanged: (val) => setState(() => _isRecurring = val),
          ),
        ],
      ),
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
          SizedBox(
            width: 16,
          ),
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
          child: const Icon(Icons.edit_outlined,
              color: AppColors.gray600, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
            child: TextField(
          controller: _noteController,
          style: GoogleFonts.inter(
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: "Add a note",
            hintStyle: GoogleFonts.inter(color: AppColors.gray400),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            filled: false,
          ),
        ))
      ],
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
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
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary500,
        ),
      ],
    );
  }
}
